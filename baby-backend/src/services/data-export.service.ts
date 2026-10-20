import { createDecipheriv, hkdfSync } from 'node:crypto';
import { mkdtemp, writeFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError } from '../common/errors/domain.error';
import { PermanentJobError } from '../common/errors/job.error';
import { ACCOUNT_DELETION_POLICY } from '../config/account-deletion-policy';
import type {
  CreateDataExportDto,
  DataExportResponseDto,
} from '../dto/account/data-export.dto';
import { DATA_EXPORT_REPOSITORY } from '../interfaces/repositories/data-export-repository.interface';
import type { IDataExportRepository } from '../interfaces/repositories/data-export-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IDataExportService } from '../interfaces/services/data-export-service.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../interfaces/services/object-storage-service.interface';
import type { IObjectStorageService } from '../interfaces/services/object-storage-service.interface';
import type { DataExport } from '../models/data-export.model';

@Injectable()
export class DataExportService implements IDataExportService {
  constructor(
    @Inject(DATA_EXPORT_REPOSITORY)
    private readonly repository: IDataExportRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(OBJECT_STORAGE_SERVICE)
    private readonly storage: IObjectStorageService,
    private readonly config: ConfigService,
  ) {}
  async create(
    actor: AuthPrincipal,
    input: CreateDataExportDto,
  ): Promise<DataExportResponseDto> {
    const scope = input.scope ?? 'PERSONAL';
    if ((scope === 'FAMILY') !== Boolean(input.familyId))
      throw new DomainError(
        'familyId is required only for FAMILY exports.',
        'EXPORT_SCOPE_INVALID',
        422,
      );
    if (scope === 'FAMILY')
      await this.access.requireParent(actor, input.familyId!, 'download');
    const row = await this.repository.create({
      userId: actor.userId,
      familyId: input.familyId ?? null,
      scope,
      policyVersion: ACCOUNT_DELETION_POLICY.version,
      since: new Date(Date.now() - ACCOUNT_DELETION_POLICY.export.windowMs),
      maxRequests: ACCOUNT_DELETION_POLICY.export.maxRequests,
    });
    return this.project(row);
  }
  async find(actor: AuthPrincipal, id: string): Promise<DataExportResponseDto> {
    const row = await this.repository.find(actor.userId, id);
    if (!row)
      throw new DomainError('Export was not found.', 'EXPORT_NOT_FOUND', 404);
    if (row.scope === 'FAMILY')
      await this.access.requireParent(actor, row.familyId!, 'download');
    return this.project(row);
  }
  pending(limit = ACCOUNT_DELETION_POLICY.batchSize): Promise<DataExport[]> {
    return this.repository.pending(limit);
  }
  async execute(
    id: string,
    context: JobContext,
  ): Promise<Record<string, number>> {
    let directory: string | undefined;
    let uploadedKey: string | undefined;
    let completed = false;
    try {
      context.signal.throwIfAborted();
      const job = await this.repository.begin(id, context.lease);
      if (!job) return { completed: 0 };
      const snapshot = await this.repository.snapshot(job);
      const userScope = `user:${job.requesterId}`;
      const manifest = [];
      for (const asset of snapshot.assets) {
        context.signal.throwIfAborted();
        const bucket = this.storage.bucketOf(asset.storageBucket);
        if (!bucket || bucket === 'public' || bucket === 'exports')
          throw new DomainError(
            'Media storage unavailable.',
            'EXPORT_STORAGE_UNAVAILABLE',
            503,
          );
        const signed = await this.storage.createDownloadUrl({
          bucket,
          key: asset.storageKey,
          expiresInSeconds: ACCOUNT_DELETION_POLICY.export.urlTtlSeconds,
        });
        manifest.push({
          assetId: asset.id,
          mime: asset.mime,
          sizeBytes: asset.sizeBytes?.toString() ?? null,
          url: signed.url,
          expiresAt: signed.expiresAt.toISOString(),
        });
      }
      const payload = {
        format: 'baby-family.export.v1',
        scope: job.scope,
        exportedAt: new Date().toISOString(),
        ...snapshot.data,
        ...(job.scope === 'PERSONAL'
          ? {
              myPrivate: {
                journal: snapshot.journal.map((row) => ({
                  id: row.id,
                  familyId: row.familyId,
                  title: this.decrypt(
                    row.titleEnc,
                    'baby-family:us-journal:v1',
                    userScope,
                    userScope,
                  ),
                  body: this.decrypt(
                    row.bodyEnc,
                    'baby-family:us-journal:v1',
                    userScope,
                    userScope,
                  ),
                  mood: row.mood,
                  createdAt: row.createdAt,
                })),
                moods: snapshot.moods.map((row) => ({
                  id: row.id,
                  familyId: row.familyId,
                  mood: row.mood,
                  energy: row.energy,
                  needs: row.needs,
                  note: this.decrypt(
                    row.noteEnc,
                    'baby-family:us-checkin:v1',
                    userScope,
                    userScope,
                  ),
                  createdAt: row.createdAt,
                })),
                appreciations: snapshot.appreciations.map((row) => ({
                  id: row.id,
                  familyId: row.familyId,
                  fromUserId: row.fromUserId,
                  toUserId: row.toUserId,
                  body: this.decrypt(
                    row.bodyEnc,
                    'baby-family:us-appreciation:v1',
                    `couple:${row.coupleSpaceId}`,
                    `couple:${row.coupleSpaceId}`,
                  ),
                  createdAt: row.createdAt,
                })),
                requests: snapshot.requests.map((row) => ({
                  id: row.id,
                  familyId: row.familyId,
                  senderUserId: row.senderUserId,
                  receiverUserId: row.receiverUserId,
                  kind: row.kind,
                  status: row.status,
                  title: this.decrypt(
                    row.titleEnc,
                    'baby-family:us-request:v1',
                    `${row.coupleSpaceId}:encryption`,
                    `request:${row.id}:couple:${row.coupleSpaceId}:title`,
                  ),
                  message: this.decrypt(
                    row.messageEnc,
                    'baby-family:us-request:v1',
                    `${row.coupleSpaceId}:encryption`,
                    `request:${row.id}:couple:${row.coupleSpaceId}:message`,
                  ),
                  ...(row.receiverUserId === job.requesterId
                    ? { heartsAwarded: row.heartsAwarded }
                    : {}),
                  createdAt: row.createdAt,
                })),
              },
            }
          : {}),
        media: manifest,
      };
      // MVP JSON + URL manifest; ZIP/CSV/offline HTML and streaming remain TODO.
      const json = JSON.stringify(payload, (_key, value: unknown) =>
        typeof value === 'bigint' ? value.toString() : value,
      );
      const bytes = Buffer.byteLength(json);
      if (bytes > ACCOUNT_DELETION_POLICY.export.maxBytes)
        throw new DomainError(
          'Export exceeds MVP size limit.',
          'EXPORT_TOO_LARGE',
          422,
        );
      directory = await mkdtemp(join(tmpdir(), 'bf-export-'));
      const path = join(directory, 'data.json');
      await writeFile(path, json, { mode: 0o600 });
      context.signal.throwIfAborted();
      const key = `user/${job.requesterId}/exports/${job.id}/${context.lease.runId}-${context.lease.fencingToken}.json`;
      uploadedKey = key;
      await this.storage.uploadFile(
        { bucket: 'exports', key },
        path,
        'application/json',
      );
      context.signal.throwIfAborted();
      await this.repository.complete(
        job,
        key,
        bytes,
        new Date(Date.now() + ACCOUNT_DELETION_POLICY.export.retentionMs),
        context.lease,
      );
      completed = true;
      return { completed: 1, bytes };
    } catch (error) {
      if (uploadedKey && !completed)
        await this.storage.eraseObjectVersions({
          bucket: 'exports',
          key: uploadedKey,
        });
      if (error instanceof DomainError && error.statusCode < 500) {
        await this.repository.fail(id, error.code, context.lease);
        throw new PermanentJobError(error.code, 'Export cannot be completed.');
      }
      if (context.lease.isLastAttempt() && !context.signal.aborted)
        await this.repository.fail(
          id,
          error instanceof DomainError ? error.code : 'EXPORT_BUILD_FAILED',
          context.lease,
        );
      throw error;
    } finally {
      if (directory) await rm(directory, { recursive: true, force: true });
    }
  }
  async purgeExpired(context: JobContext): Promise<Record<string, number>> {
    const reconciled = await this.repository.reconcileFailed(context.lease);
    let purged = 0;
    for (const job of await this.repository.expired(
      new Date(),
      ACCOUNT_DELETION_POLICY.batchSize,
    )) {
      context.signal.throwIfAborted();
      const keys = new Set(
        await this.storage.listKeys(
          'exports',
          `user/${job.requesterId}/exports/${job.id}/`,
        ),
      );
      if (job.storageKey) keys.add(job.storageKey);
      for (const key of keys) {
        context.signal.throwIfAborted();
        await this.storage.eraseObjectVersions({ bucket: 'exports', key });
      }
      await this.repository.retire(job.id, context.lease);
      purged++;
    }
    return { purged, reconciled };
  }
  private async project(row: DataExport): Promise<DataExportResponseDto> {
    const now = new Date();
    const expired =
      row.status === 'COMPLETED' &&
      row.expiresAt !== null &&
      row.expiresAt <= now;
    const signed = row.isReady(now)
      ? await this.storage.createDownloadUrl({
          bucket: 'exports',
          key: row.storageKey!,
          expiresInSeconds: Math.min(
            ACCOUNT_DELETION_POLICY.export.urlTtlSeconds,
            Math.max(
              1,
              Math.floor((row.expiresAt!.getTime() - now.getTime()) / 1000),
            ),
          ),
          downloadFileName: `baby-family-${row.id}.json`,
        })
      : null;
    return {
      id: row.id,
      scope: row.scope,
      status: expired ? 'EXPIRED' : row.status,
      createdAt: row.createdAt.toISOString(),
      completedAt: row.completedAt?.toISOString() ?? null,
      expiresAt: row.expiresAt?.toISOString() ?? null,
      errorCode: row.errorCode,
      download: signed
        ? { url: signed.url, expiresAt: signed.expiresAt.toISOString() }
        : null,
    };
  }
  /** Matches the existing journal/checkin/appreciation/request AES-GCM v1 envelopes. */
  private decrypt(
    value: Uint8Array | null,
    purpose: string,
    keyScope: string,
    aad: string,
  ): string | null {
    if (value === null) return null;
    const encoded = this.config.get<string>('COUPLE_CHECKIN_ENCRYPTION_KEY');
    const master = encoded ? Buffer.from(encoded, 'base64') : null;
    if (!master || master.length !== 32)
      throw new DomainError(
        'Private export decryption unavailable.',
        'EXPORT_ENCRYPTION_UNAVAILABLE',
        503,
      );
    try {
      const data = Buffer.from(value);
      if (data.length < 29 || data[0] !== 1)
        throw new Error('Invalid envelope');
      const key = Buffer.from(
        hkdfSync('sha256', master, purpose, keyScope, 32),
      );
      const decipher = createDecipheriv(
        'aes-256-gcm',
        key,
        data.subarray(1, 13),
      );
      decipher.setAAD(Buffer.from(aad));
      decipher.setAuthTag(data.subarray(13, 29));
      return Buffer.concat([
        decipher.update(data.subarray(29)),
        decipher.final(),
      ]).toString('utf8');
    } catch {
      throw new DomainError(
        'Private export content is unreadable.',
        'EXPORT_CONTENT_UNREADABLE',
        503,
      );
    }
  }
}
