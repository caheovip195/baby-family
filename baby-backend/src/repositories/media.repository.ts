import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import type {
  Asset as AssetRow,
  AssetVariant as AssetVariantRow,
  IdempotencyRecord as IdempotencyRecordRow,
  StorageReservation as StorageReservationRow,
} from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import { ConflictError, DomainError } from '../common/errors/domain.error';
import type {
  EffectivePlanData,
  IMediaRepository,
  ProcessingCommit,
  ProcessingResult,
  PurgeRule,
  ReserveUploadInput,
  ReserveUploadResult,
} from '../interfaces/repositories/media-repository.interface';
import { Asset } from '../models/asset.model';
import { AssetVariant } from '../models/asset-variant.model';
import type { JobLease } from '../models/job-lease.model';
import { MediaAssetView, MediaUpload } from '../models/media-upload.model';
import { memoryContentScope } from './memory-content-visibility';
import { parentSharedAssetSql } from './parent-asset-visibility.sql';

type Transaction = Prisma.TransactionClient;
type AssetWithReservation = AssetRow & {
  storageReservation: StorageReservationRow[];
};

const TRANSACTION_OPTIONS = {
  isolationLevel: Prisma.TransactionIsolationLevel.ReadCommitted,
  timeout: 10000,
};
const STORED_STATUSES = new Set(['UPLOADED', 'PROCESSING', 'READY']);
const UPLOAD_INTENT_OPERATION = 'media.upload_intent';

/**
 * Upload workflow persistence (spec §10.2) and the Parent media visibility query
 * (spec §6.3). Every write that touches quota locks `billing.family_usage` first,
 * so concurrent reserve/confirm/fail calls of a family are serialized.
 */
@Injectable()
export class MediaRepository implements IMediaRepository {
  constructor(private readonly prisma: PrismaService) {}

  async reserveUpload(input: ReserveUploadInput): Promise<ReserveUploadResult> {
    try {
      return await this.prisma.$transaction(
        (tx) => this.reserveInTransaction(tx, input),
        TRANSACTION_OPTIONS,
      );
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      ) {
        // A concurrent request created the same key/content first; retrying replays it.
        throw new DomainError(
          'A concurrent upload request conflicted; retry.',
          'UPLOAD_CONFLICT',
          409,
        );
      }
      throw error;
    }
  }

  async findUpload(assetId: string): Promise<MediaUpload | null> {
    const row = await this.prisma.asset.findFirst({
      where: { id: assetId, deletedAt: null },
      include: { storageReservation: { where: { deletedAt: null } } },
    });
    return row ? mapUpload(row) : null;
  }

  async attachMultipartUpload(
    assetId: string,
    uploadId: string,
  ): Promise<string> {
    const updated = await this.prisma.asset.updateMany({
      where: {
        id: assetId,
        deletedAt: null,
        status: 'PENDING_UPLOAD',
        multipartUploadId: null,
      },
      data: { multipartUploadId: uploadId },
    });
    if (updated.count === 1) return uploadId;
    const row = await this.prisma.asset.findFirst({
      where: { id: assetId, deletedAt: null },
      select: { multipartUploadId: true },
    });
    if (!row?.multipartUploadId)
      throw new ConflictError('Upload is no longer pending.');
    return row.multipartUploadId;
  }

  confirmUpload(assetId: string, sizeBytes: bigint): Promise<Asset> {
    return this.prisma.$transaction(async (tx) => {
      const familyId = await this.lockFamilyOfAsset(tx, assetId);
      const asset = await tx.asset.findFirst({
        where: { id: assetId, deletedAt: null },
      });
      if (!asset) throw new ConflictError('Upload no longer exists.');
      if (asset.status !== 'PENDING_UPLOAD') return mapAsset(asset);
      const reservation = await tx.storageReservation.findFirst({
        where: { assetId, deletedAt: null, status: 'RESERVED' },
      });
      if (!reservation) throw new ConflictError('Upload reservation expired.');
      const now = new Date();
      const updated = await tx.asset.update({
        where: { id: assetId },
        data: { status: 'UPLOADED', sizeBytes },
      });
      await tx.storageReservation.update({
        where: { id: reservation.id },
        data: {
          status: 'CONFIRMED',
          consumedBytes: sizeBytes,
          confirmedAt: now,
        },
      });
      await tx.$executeRaw`
        UPDATE billing.family_usage
        SET reserved_storage_bytes = GREATEST(reserved_storage_bytes - ${reservation.reservedBytes}, 0),
            storage_bytes = storage_bytes + ${sizeBytes},
            version = version + 1
        WHERE family_id = ${familyId}::uuid`;
      // Transactional outbox (spec §3.3): the media worker consumes this event.
      await tx.outboxEvent.create({
        data: {
          eventType: 'media.asset_uploaded',
          aggregateId: assetId,
          familyId,
          payload: { assetId, familyId, kind: asset.kind, mime: asset.mime },
        },
      });
      return mapAsset(updated);
    }, TRANSACTION_OPTIONS);
  }

  async failUpload(assetId: string, reason: string): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      await this.lockFamilyOfAsset(tx, assetId);
      const updated = await tx.asset.updateMany({
        where: { id: assetId, deletedAt: null, status: 'PENDING_UPLOAD' },
        data: { status: 'FAILED', failureReason: reason },
      });
      if (updated.count === 1) await this.releaseReservation(tx, assetId);
    }, TRANSACTION_OPTIONS);
  }

  async findFamilyIds(
    assetIds: readonly string[],
  ): Promise<Map<string, string>> {
    const rows = await this.prisma.asset.findMany({
      where: { id: { in: [...assetIds] }, deletedAt: null },
      select: { id: true, familyId: true },
    });
    return new Map(rows.map((row) => [row.id, row.familyId]));
  }

  async findViewableByParent(
    familyId: string,
    userId: string,
    assetIds: readonly string[],
  ): Promise<MediaAssetView[]> {
    if (assetIds.length === 0) return [];
    const visible = await this.prisma.$queryRaw<{ id: string }[]>`
      SELECT a.id
      FROM app.assets a
      WHERE a.id = ANY(${[...assetIds]}::uuid[])
        AND a.family_id = ${familyId}::uuid
        AND a.deleted_at IS NULL
        AND a.private_owner_user_id IS NULL
        AND (
          -- Own uploads not yet linked to any memory; once linked, memory ACL decides.
          (a.uploader_user_id = ${userId}::uuid
            AND NOT EXISTS (SELECT 1 FROM app.memory_assets ma
                            WHERE ma.asset_id = a.id AND ma.deleted_at IS NULL)
            AND NOT EXISTS (SELECT 1 FROM app.memory_perspective_assets pa
                            WHERE pa.asset_id = a.id AND pa.deleted_at IS NULL)
            AND NOT EXISTS (SELECT 1 FROM app.memory_perspectives p
                            WHERE p.audio_asset_id = a.id AND p.deleted_at IS NULL))
          OR ${parentSharedAssetSql(userId)}
        )`;
    if (visible.length === 0) return [];
    const rows = await this.prisma.asset.findMany({
      where: { id: { in: visible.map((row) => row.id) } },
      include: { assetVariants: { where: { deletedAt: null } } },
    });
    return rows.map(
      (row) =>
        new MediaAssetView(mapAsset(row), row.assetVariants.map(mapVariant)),
    );
  }

  async hasContributeChild(familyId: string, userId: string): Promise<boolean> {
    const scope = await memoryContentScope(this.prisma, familyId, userId);
    return scope.contributeChildIds.length > 0;
  }

  async findViewableByCircle(
    familyId: string,
    userId: string,
    assetIds: readonly string[],
  ): Promise<MediaAssetView[]> {
    const scope = await memoryContentScope(this.prisma, familyId, userId, true);
    const rows = await this.prisma.asset.findMany({
      where: {
        id: { in: [...assetIds] },
        familyId,
        deletedAt: null,
        privateOwnerUserId: null,
        memoryAssets: {
          some: { familyId, deletedAt: null, memory: scope.where },
        },
      },
      include: {
        assetVariants: {
          where: { deletedAt: null, variantCode: { not: 'orig' } },
        },
      },
    });
    // Originals are issued only by the memory download flow, which checks allowDownload.
    return rows.map(
      (row) =>
        new MediaAssetView(mapAsset(row), row.assetVariants.map(mapVariant)),
    );
  }

  async startProcessing(assetId: string): Promise<Asset | null> {
    const updated = await this.prisma.asset.updateManyAndReturn({
      where: {
        id: assetId,
        deletedAt: null,
        status: { in: ['UPLOADED', 'PROCESSING'] },
      },
      data: { status: 'PROCESSING' },
    });
    return updated[0] ? mapAsset(updated[0]) : null;
  }

  async findAssetView(assetId: string): Promise<MediaAssetView | null> {
    const row = await this.prisma.asset.findFirst({
      where: { id: assetId, deletedAt: null },
      include: { assetVariants: { where: { deletedAt: null } } },
    });
    return row
      ? new MediaAssetView(mapAsset(row), row.assetVariants.map(mapVariant))
      : null;
  }

  async findEffectivePlan(familyId: string): Promise<EffectivePlanData | null> {
    const entitlement = await this.prisma.familyEntitlement.findFirst({
      where: { familyId, deletedAt: null },
      include: { planVersion: true },
    });
    const version = entitlement?.planVersion;
    return version && version.deletedAt === null
      ? { quotas: version.quotas, features: version.features }
      : null;
  }

  completeProcessing(
    assetId: string,
    result: ProcessingResult,
    lease: JobLease,
  ): Promise<ProcessingCommit> {
    return this.prisma.$transaction(async (tx) => {
      const familyId = await this.lockFamilyOfAsset(tx, assetId);
      if (!(await this.ownsLease(tx, lease))) return 'LEASE_LOST';
      const asset = await tx.asset.findFirst({
        where: { id: assetId, deletedAt: null, status: 'PROCESSING' },
      });
      if (!asset) return 'NOT_PROCESSING';
      for (const variant of result.variants) {
        const data = {
          storageBucket: variant.storageBucket,
          storageKey: variant.storageKey,
          mime: variant.mime,
          sizeBytes: variant.sizeBytes,
          width: variant.width,
          height: variant.height,
          durationMs: variant.durationMs,
          deletedAt: null,
        };
        await tx.assetVariant.upsert({
          where: {
            assetId_variantCode: { assetId, variantCode: variant.code },
          },
          create: { ...data, familyId, assetId, variantCode: variant.code },
          update: data,
        });
      }
      // Stored bytes = every rendition, including the cleaned original when kept.
      const total = result.variants.reduce(
        (sum, variant) => sum + variant.sizeBytes,
        0n,
      );
      await tx.asset.update({
        where: { id: assetId },
        data: {
          status: 'READY',
          readyAt: new Date(),
          sizeBytes: total,
          width: result.width,
          height: result.height,
          durationMs: result.durationMs,
          capturedAt: result.capturedAt,
          blurhash: result.blurhash,
          keepOriginal: result.keepOriginal,
        },
      });
      const delta = total - (asset.sizeBytes ?? 0n);
      await tx.$executeRaw`
        UPDATE billing.family_usage
        SET storage_bytes = GREATEST(storage_bytes + ${delta}, 0),
            version = version + 1
        WHERE family_id = ${familyId}::uuid`;
      await this.publishReadyMemories(tx, assetId, familyId);
      return 'COMPLETED';
    }, TRANSACTION_OPTIONS);
  }

  failProcessing(
    assetId: string,
    reason: string,
    lease: JobLease,
  ): Promise<boolean> {
    return this.prisma.$transaction(async (tx) => {
      if (!(await this.ownsLease(tx, lease))) return false;
      const updated = await tx.asset.updateMany({
        where: {
          id: assetId,
          deletedAt: null,
          status: { in: ['UPLOADED', 'PROCESSING'] },
        },
        data: { status: 'FAILED', failureReason: reason },
      });
      return updated.count === 1;
    }, TRANSACTION_OPTIONS);
  }

  async failStaleProcessing(before: Date): Promise<number> {
    const updated = await this.prisma.asset.updateMany({
      where: {
        deletedAt: null,
        status: 'PROCESSING',
        updatedAt: { lte: before },
      },
      data: { status: 'FAILED', failureReason: 'PROCESSING_STALLED' },
    });
    return updated.count;
  }

  async findStuckProcessing(
    before: Date,
    runKeyPrefix: string,
    limit: number,
  ): Promise<Asset[]> {
    const ids = await this.prisma.$queryRaw<{ id: string }[]>`
      SELECT a.id FROM app.assets a
      LEFT JOIN ops.job_runs r
        ON r.idempotency_key = ${runKeyPrefix} || a.id::text AND r.deleted_at IS NULL
      WHERE a.deleted_at IS NULL AND a.status IN ('UPLOADED', 'PROCESSING')
        AND a.updated_at <= ${before}
        AND (r.id IS NULL
             OR r.status IN ('PENDING', 'RETRY_WAIT')
             OR (r.status = 'RUNNING' AND r.lease_expires_at < now()))
      ORDER BY a.updated_at
      LIMIT ${limit}`;
    if (ids.length === 0) return [];
    const rows = await this.prisma.asset.findMany({
      where: { id: { in: ids.map((row) => row.id) } },
    });
    return rows.map(mapAsset);
  }

  async findPurgeCandidates(
    rule: PurgeRule,
    cutoff: Date,
    limit: number,
  ): Promise<string[]> {
    const rows = await this.prisma.$queryRaw<{ id: string }[]>`
      SELECT a.id FROM app.assets a
      WHERE a.deleted_at IS NULL AND ${purgePredicate(rule, cutoff)}
      ORDER BY a.created_at
      LIMIT ${limit}`;
    return rows.map((row) => row.id);
  }

  async findUncompletedUploads(
    before: Date,
    maxDeclaredBytes: bigint,
    limit: number,
  ): Promise<MediaUpload[]> {
    const rows = await this.prisma.asset.findMany({
      where: {
        deletedAt: null,
        status: 'PENDING_UPLOAD',
        createdAt: { lte: before },
        declaredSize: { lte: maxDeclaredBytes },
        storageReservation: {
          some: {
            deletedAt: null,
            status: 'RESERVED',
            expiresAt: { gt: new Date() },
          },
        },
      },
      include: { storageReservation: { where: { deletedAt: null } } },
      orderBy: { createdAt: 'asc' },
      take: limit,
    });
    return rows.map(mapUpload);
  }

  retireAsset(
    assetId: string,
    rule: PurgeRule,
    cutoff: Date,
  ): Promise<boolean> {
    return this.prisma.$transaction(async (tx) => {
      const familyId = await this.lockFamilyOfAsset(tx, assetId);
      // Re-check the rule on the locked row: a concurrent confirm, processing or
      // attachment wins and the asset is kept.
      const [locked] = await tx.$queryRaw<{ id: string }[]>`
        SELECT a.id FROM app.assets a
        WHERE a.id = ${assetId}::uuid AND a.deleted_at IS NULL
          AND ${purgePredicate(rule, cutoff)}
        FOR UPDATE`;
      if (!locked) return false;
      const asset = await tx.asset.findUniqueOrThrow({
        where: { id: assetId },
        include: { storageReservation: { where: { deletedAt: null } } },
      });
      const now = new Date();
      await this.releaseReservation(
        tx,
        assetId,
        rule === 'EXPIRED_UPLOAD' ? 'EXPIRED' : 'RELEASED',
      );
      // Stored bytes (original or renditions) were counted at confirm/processing.
      const stored =
        asset.sizeBytes ??
        asset.storageReservation.find((r) => r.status === 'CONFIRMED')
          ?.consumedBytes ??
        0n;
      await tx.storageReservation.updateMany({
        where: { assetId, deletedAt: null, status: 'CONFIRMED' },
        data: { status: 'RELEASED', releasedAt: now },
      });
      if (stored > 0n)
        await tx.$executeRaw`
          UPDATE billing.family_usage
          SET storage_bytes = GREATEST(storage_bytes - ${stored}, 0),
              version = version + 1
          WHERE family_id = ${familyId}::uuid`;
      await tx.assetVariant.updateMany({
        where: { assetId, deletedAt: null },
        data: { deletedAt: now },
      });
      // purge_after marks storage objects still to delete (see markObjectsPurged).
      await tx.asset.update({
        where: { id: assetId },
        data: { status: 'DELETED', deletedAt: now, purgeAfter: now },
      });
      return true;
    }, TRANSACTION_OPTIONS);
  }

  async findAssetsAwaitingObjectPurge(limit: number): Promise<Asset[]> {
    const rows = await this.prisma.asset.findMany({
      where: {
        deletedAt: { not: null },
        status: 'DELETED',
        purgeAfter: { lte: new Date() },
      },
      orderBy: { purgeAfter: 'asc' },
      take: limit,
    });
    return rows.map(mapAsset);
  }

  async markObjectsPurged(assetId: string): Promise<void> {
    await this.prisma.asset.updateMany({
      where: { id: assetId, status: 'DELETED' },
      data: { purgeAfter: null },
    });
  }

  /** Locks the job run row and checks the attempt still owns it (fencing). */
  /**
   * PROCESSING memories using this asset become PUBLISHED once every attached
   * asset is READY (spec §11.5 → status flow), with `memory.published` outbox.
   * Memory creation locks its asset rows, so a memory committed before this
   * transaction is visible here and one committed after sees the READY asset.
   */
  private async publishReadyMemories(
    tx: Transaction,
    assetId: string,
    familyId: string,
  ): Promise<void> {
    const published = await tx.$queryRaw<
      {
        id: string;
        author_user_id: string;
        kind: string;
        visibility: string;
      }[]
    >`
      UPDATE app.memories m
      SET status = 'PUBLISHED', published_at = now(), version = m.version + 1
      WHERE m.family_id = ${familyId}::uuid
        AND m.status = 'PROCESSING'
        AND m.deleted_at IS NULL
        AND EXISTS (SELECT 1 FROM app.memory_assets ma
                    WHERE ma.memory_id = m.id AND ma.asset_id = ${assetId}::uuid
                      AND ma.deleted_at IS NULL)
        AND NOT EXISTS (SELECT 1 FROM app.memory_assets ma
                        JOIN app.assets a ON a.id = ma.asset_id
                        WHERE ma.memory_id = m.id AND ma.deleted_at IS NULL
                          AND a.deleted_at IS NULL AND a.status <> 'READY')
      RETURNING m.id, m.author_user_id, m.kind::text AS kind,
                m.visibility::text AS visibility`;
    for (const memory of published)
      await tx.outboxEvent.create({
        data: {
          eventType: 'memory.published',
          aggregateId: memory.id,
          familyId,
          payload: {
            memoryId: memory.id,
            familyId,
            authorUserId: memory.author_user_id,
            kind: memory.kind,
            status: 'PUBLISHED',
            visibility: memory.visibility,
          },
        },
      });
  }

  private async ownsLease(tx: Transaction, lease: JobLease): Promise<boolean> {
    const rows = await tx.$queryRaw<{ id: string }[]>`
      SELECT id FROM ops.job_runs
      WHERE id = ${lease.runId}::uuid AND status = 'RUNNING'
        AND fencing_token = ${lease.fencingToken}
      FOR UPDATE`;
    return rows.length === 1;
  }

  private async reserveInTransaction(
    tx: Transaction,
    input: ReserveUploadInput,
  ): Promise<ReserveUploadResult> {
    const record = await tx.idempotencyRecord.findUnique({
      where: {
        scopeKey_operation_idempotencyKey: {
          scopeKey: input.uploaderUserId,
          operation: UPLOAD_INTENT_OPERATION,
          idempotencyKey: input.idempotencyKey,
        },
      },
    });
    if (record) return this.replay(tx, record, input);

    const usage = await this.lockUsage(tx, input.familyId);
    let reservedBytes = usage.reservedStorageBytes;
    // Dedup is per uploader (uq_asset_dedup). Another Parent's copy is reused only
    // when it is verified (READY) and already visible to this uploader; knowing a
    // hash must never grant access to private or unshared content (spec §6.3).
    const existing = await tx.asset.findFirst({
      where: {
        familyId: input.familyId,
        purpose: input.purpose,
        privateOwnerUserId: input.privateOwnerUserId ?? null,
        uploaderUserId: input.uploaderUserId,
        sha256: Buffer.from(input.sha256),
        deletedAt: null,
      },
      include: { storageReservation: { where: { deletedAt: null } } },
    });
    // Private assets are never reused from someone else's copy.
    if (
      !existing &&
      !input.privateOwnerUserId &&
      input.allowSharedCopy !== false
    ) {
      const shared = await this.findSharedCopy(tx, input);
      if (shared) {
        await this.remember(tx, input, shared.id, true);
        return { outcome: 'duplicate', asset: mapAsset(shared) };
      }
    }
    if (existing) {
      const upload = mapUpload(existing);
      if (STORED_STATUSES.has(existing.status)) {
        // Only content whose hash storage or the worker verified may be shared:
        // single PUTs are checksum-signed; multipart hashes are checked by the worker.
        if (
          existing.status !== 'READY' &&
          existing.declaredSize > input.checksumVerifiedMaxBytes
        )
          throw new DomainError(
            'The same file is still being verified; retry later.',
            'UPLOAD_PENDING_VERIFICATION',
            409,
          );
        await this.remember(tx, input, existing.id, true);
        return { outcome: 'duplicate', asset: upload.asset };
      }
      if (
        existing.status === 'PENDING_UPLOAD' &&
        !upload.isExpired(new Date())
      ) {
        await this.remember(tx, input, existing.id, false);
        return { outcome: 'replayed', upload };
      }
      // FAILED or abandoned upload of the same content: retire it so it can be retried.
      // Its storage object, if any, is removed by the orphan purge job.
      if (existing.status === 'PENDING_UPLOAD')
        reservedBytes -= await this.releaseReservation(
          tx,
          existing.id,
          'EXPIRED',
        );
      await tx.asset.update({
        where: { id: existing.id },
        data: { status: 'DELETED', deletedAt: new Date() },
      });
    }

    if (
      usage.storageBytes + reservedBytes + input.reservedBytes >
      input.storageLimitBytes
    )
      throw new DomainError(
        'Storage quota of the current plan is exceeded.',
        'QUOTA_STORAGE_EXCEEDED',
        402,
      );

    const [{ id }] = await tx.$queryRaw<
      [{ id: string }]
    >`SELECT uuidv7()::text AS id`;
    const asset = await tx.asset.create({
      data: {
        id,
        familyId: input.familyId,
        uploaderUserId: input.uploaderUserId,
        privateOwnerUserId: input.privateOwnerUserId ?? null,
        kind: input.kind,
        purpose: input.purpose,
        storageBucket: input.storageBucket,
        storageKey: input.storageKey(id),
        mime: input.mime,
        declaredSize: input.declaredSize,
        sha256: Buffer.from(input.sha256),
        width: input.width,
        height: input.height,
        durationMs: input.durationMs,
      },
    });
    const reservation = await tx.storageReservation.create({
      data: {
        familyId: input.familyId,
        assetId: id,
        requesterUserId: input.uploaderUserId,
        idempotencyKey: input.idempotencyKey,
        reservedBytes: input.reservedBytes,
        expiresAt: input.reservationExpiresAt,
      },
    });
    await tx.$executeRaw`
      UPDATE billing.family_usage
      SET reserved_storage_bytes = reserved_storage_bytes + ${input.reservedBytes},
          version = version + 1
      WHERE family_id = ${input.familyId}::uuid`;
    await this.remember(tx, input, id, false);
    return {
      outcome: 'created',
      upload: mapUpload({ ...asset, storageReservation: [reservation] }),
    };
  }

  /** Verified copy of the same content uploaded by another Parent and visible to the uploader. */
  private async findSharedCopy(
    tx: Transaction,
    input: ReserveUploadInput,
  ): Promise<AssetRow | null> {
    const [row] = await tx.$queryRaw<{ id: string }[]>`
      SELECT a.id FROM app.assets a
      WHERE a.family_id = ${input.familyId}::uuid
        AND a.purpose = ${input.purpose}
        AND a.private_owner_user_id IS NULL
        AND a.uploader_user_id <> ${input.uploaderUserId}::uuid
        AND a.sha256 = ${Buffer.from(input.sha256)}
        AND a.status = 'READY'
        AND a.deleted_at IS NULL
        AND ${parentSharedAssetSql(input.uploaderUserId)}
      ORDER BY a.created_at
      LIMIT 1`;
    return row ? tx.asset.findUnique({ where: { id: row.id } }) : null;
  }

  /** Same actor + key: the original outcome, or 409 when the request differs. */
  private async replay(
    tx: Transaction,
    record: IdempotencyRecordRow,
    input: ReserveUploadInput,
  ): Promise<ReserveUploadResult> {
    if (!Buffer.from(record.requestHash).equals(Buffer.from(input.requestHash)))
      throw new DomainError(
        'Idempotency-Key was already used for a different request.',
        'IDEMPOTENCY_KEY_REUSED',
        409,
      );
    const asset = record.resultEntityId
      ? await tx.asset.findFirst({
          where: { id: record.resultEntityId, deletedAt: null },
          include: { storageReservation: { where: { deletedAt: null } } },
        })
      : null;
    if (!asset) throw new ConflictError('The uploaded file no longer exists.');
    const reference = record.responseReference as {
      deduplicated?: boolean;
    } | null;
    return reference?.deduplicated
      ? { outcome: 'duplicate', asset: mapAsset(asset) }
      : { outcome: 'replayed', upload: mapUpload(asset) };
  }

  private async remember(
    tx: Transaction,
    input: ReserveUploadInput,
    assetId: string,
    deduplicated: boolean,
  ): Promise<void> {
    await tx.idempotencyRecord.create({
      data: {
        actorUserId: input.uploaderUserId,
        familyId: input.familyId,
        operation: UPLOAD_INTENT_OPERATION,
        scopeKey: input.uploaderUserId,
        idempotencyKey: input.idempotencyKey,
        requestHash: Buffer.from(input.requestHash),
        status: 'SUCCEEDED',
        resultEntityType: 'asset',
        resultEntityId: assetId,
        responseCode: 201,
        responseReference: { deduplicated },
        expiresAt: input.reservationExpiresAt,
      },
    });
  }

  private async lockUsage(
    tx: Transaction,
    familyId: string,
  ): Promise<{ storageBytes: bigint; reservedStorageBytes: bigint }> {
    await tx.$executeRaw`
      INSERT INTO billing.family_usage (family_id) VALUES (${familyId}::uuid)
      ON CONFLICT (family_id) DO NOTHING`;
    const [usage] = await tx.$queryRaw<
      { storage_bytes: bigint; reserved_storage_bytes: bigint }[]
    >`
      SELECT storage_bytes, reserved_storage_bytes FROM billing.family_usage
      WHERE family_id = ${familyId}::uuid FOR UPDATE`;
    if (!usage) throw new ConflictError('Family usage is unavailable.');
    return {
      storageBytes: usage.storage_bytes,
      reservedStorageBytes: usage.reserved_storage_bytes,
    };
  }

  /** Locks the family usage row of an asset (same lock order as reserveUpload). */
  private async lockFamilyOfAsset(
    tx: Transaction,
    assetId: string,
  ): Promise<string> {
    const asset = await tx.asset.findFirst({
      where: { id: assetId, deletedAt: null },
      select: { familyId: true },
    });
    if (!asset) throw new ConflictError('Upload no longer exists.');
    await this.lockUsage(tx, asset.familyId);
    return asset.familyId;
  }

  private async releaseReservation(
    tx: Transaction,
    assetId: string,
    status: 'RELEASED' | 'EXPIRED' = 'RELEASED',
  ): Promise<bigint> {
    const reservation = await tx.storageReservation.findFirst({
      where: { assetId, deletedAt: null, status: 'RESERVED' },
    });
    if (!reservation) return 0n;
    await tx.storageReservation.update({
      where: { id: reservation.id },
      data: { status, releasedAt: new Date() },
    });
    await tx.$executeRaw`
      UPDATE billing.family_usage
      SET reserved_storage_bytes = GREATEST(reserved_storage_bytes - ${reservation.reservedBytes}, 0),
          version = version + 1
      WHERE family_id = ${reservation.familyId}::uuid`;
    return reservation.reservedBytes;
  }
}

/** Asset selection per purge rule (spec §10.2); re-evaluated under lock. */
function purgePredicate(rule: PurgeRule, cutoff: Date): Prisma.Sql {
  if (rule === 'EXPIRED_UPLOAD')
    return Prisma.sql`a.status = 'PENDING_UPLOAD' AND (
      EXISTS (SELECT 1 FROM app.storage_reservations r
              WHERE r.asset_id = a.id AND r.deleted_at IS NULL
                AND r.status = 'RESERVED' AND r.expires_at <= ${cutoff})
      OR (NOT EXISTS (SELECT 1 FROM app.storage_reservations r
                      WHERE r.asset_id = a.id AND r.deleted_at IS NULL
                        AND r.status = 'RESERVED')
          AND a.created_at <= ${cutoff}::timestamptz - interval '24 hours'))`;
  if (rule === 'FAILED')
    return Prisma.sql`a.status = 'FAILED' AND a.updated_at <= ${cutoff}`;
  if (rule === 'DETACHED')
    return Prisma.sql`a.purpose = 'MEMORY' AND a.status IN ('UPLOADED', 'READY')
    AND a.updated_at <= ${cutoff}
    AND EXISTS (SELECT 1 FROM app.memory_assets x WHERE x.asset_id = a.id)
    AND NOT EXISTS (SELECT 1 FROM app.memory_assets x
                    WHERE x.asset_id = a.id AND x.deleted_at IS NULL)
    AND NOT EXISTS (SELECT 1 FROM app.memory_perspective_assets x
                    WHERE x.asset_id = a.id AND x.deleted_at IS NULL)
    AND NOT EXISTS (SELECT 1 FROM app.memory_perspectives x
                    WHERE x.audio_asset_id = a.id AND x.deleted_at IS NULL)`;
  return Prisma.sql`a.purpose = 'MEMORY' AND a.status IN ('UPLOADED', 'READY')
    AND a.created_at <= ${cutoff}
    AND NOT EXISTS (SELECT 1 FROM app.memory_assets x WHERE x.asset_id = a.id)
    AND NOT EXISTS (SELECT 1 FROM app.memory_perspective_assets x WHERE x.asset_id = a.id)
    AND NOT EXISTS (SELECT 1 FROM app.memory_perspectives x WHERE x.audio_asset_id = a.id)
    AND NOT EXISTS (SELECT 1 FROM us.journal_assets x WHERE x.asset_id = a.id)`;
}

function mapUpload(row: AssetWithReservation): MediaUpload {
  const reservation = row.storageReservation[0];
  return new MediaUpload(
    mapAsset(row),
    reservation
      ? {
          status: reservation.status,
          reservedBytes: reservation.reservedBytes,
          expiresAt: reservation.expiresAt,
          idempotencyKey: reservation.idempotencyKey,
        }
      : null,
  );
}

function mapAsset(row: AssetRow): Asset {
  return new Asset({
    id: row.id,
    familyId: row.familyId,
    uploaderUserId: row.uploaderUserId,
    kind: row.kind,
    purpose: row.purpose,
    status: row.status,
    storageKey: row.storageKey,
    multipartUploadId: row.multipartUploadId,
    mime: row.mime,
    declaredSize: row.declaredSize,
    sizeBytes: row.sizeBytes,
    width: row.width,
    height: row.height,
    durationMs: row.durationMs,
    sha256: row.sha256 === null ? null : new Uint8Array(row.sha256),
    capturedAt: row.capturedAt,
    blurhash: row.blurhash,
    keepOriginal: row.keepOriginal,
    failureReason: row.failureReason,
    createdAt: row.createdAt,
    readyAt: row.readyAt,
    deletedAt: row.deletedAt,
    purgeAfter: row.purgeAfter,
    updatedAt: row.updatedAt,
    storageBucket: row.storageBucket,
    privateOwnerUserId: row.privateOwnerUserId,
  });
}

function mapVariant(row: AssetVariantRow): AssetVariant {
  return new AssetVariant({
    id: row.id,
    familyId: row.familyId,
    assetId: row.assetId,
    variantCode: row.variantCode,
    storageBucket: row.storageBucket,
    storageKey: row.storageKey,
    mime: row.mime,
    sizeBytes: row.sizeBytes,
    width: row.width,
    height: row.height,
    durationMs: row.durationMs,
    checksumSha256:
      row.checksumSha256 === null ? null : new Uint8Array(row.checksumSha256),
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
  });
}
