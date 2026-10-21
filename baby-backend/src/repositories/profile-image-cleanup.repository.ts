import { ProfileImageClientVariantsPersistence } from './profile-image-client-variants.persistence';
import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import type { IProfileImageCleanupRepository } from '../interfaces/repositories/profile-image-cleanup-repository.interface';
import type { JobLease } from '../models/job-lease.model';
import { UserAsset } from '../models/user-asset.model';

@Injectable()
export class ProfileImageCleanupRepository implements IProfileImageCleanupRepository {
  private readonly clientVariants = new ProfileImageClientVariantsPersistence();
  constructor(private readonly prisma: PrismaService) {}
  async findDue(
    cutoff: Date,
    staleBefore: Date,
    limit: number,
    ownerUserIds?: string[],
  ) {
    if (ownerUserIds?.length === 0) return [];
    const scope = ownerUserIds
      ? Prisma.sql`AND a.owner_user_id::text IN (${Prisma.join(ownerUserIds)})`
      : Prisma.empty;
    const rows = await this.prisma.$queryRaw<{ id: string }[]>(Prisma.sql`
      SELECT a.id FROM app.user_assets a
      WHERE a.purpose='AVATAR'
        AND a.storage_key = 'usr/' || a.owner_user_id::text || '/avatar/' || a.id::text || '/raw'
        AND (a.status <> 'PROCESSING' OR a.updated_at <= ${staleBefore})
        AND (a.purge_after <= ${cutoff} OR (
          a.purge_after IS NULL AND a.status='READY' AND (
            EXISTS (SELECT 1 FROM app.users u WHERE u.id=a.owner_user_id AND u.deleted_at IS NOT NULL)
            OR NOT EXISTS (SELECT 1 FROM app.users u WHERE u.avatar_asset_id=a.id AND u.deleted_at IS NULL)
          ))) ${scope}
      ORDER BY a.purge_after NULLS LAST, a.id LIMIT ${limit}`);
    const assets = await this.prisma.userAsset.findMany({
      where: { id: { in: rows.map((row) => row.id) } },
    });
    return assets.map((asset) => new UserAsset(asset));
  }
  prepare(id: string, cutoff: Date, staleBefore: Date, lease?: JobLease) {
    return this.prisma.$transaction(async (tx) => {
      if (lease) await this.fence(tx, lease);
      await tx.$queryRaw`SELECT id FROM app.user_assets WHERE id=${id}::uuid FOR UPDATE`;
      const asset = await tx.userAsset.findUnique({ where: { id } });
      if (
        !asset ||
        asset.purpose !== 'AVATAR' ||
        asset.storageKey !== `usr/${asset.ownerUserId}/avatar/${asset.id}/raw`
      )
        return null;
      if (asset.status === 'PROCESSING' && asset.updatedAt > staleBefore)
        return null;
      if (asset.purgeAfter && asset.purgeAfter > cutoff) return null;
      const owner = await tx.user.findUnique({
        where: { id: asset.ownerUserId },
      });
      if (owner?.deletedAt)
        await tx.user.updateMany({
          where: { id: owner.id, avatarAssetId: id },
          data: { avatarAssetId: null },
        });
      const attached =
        (await tx.user.count({
          where: { avatarAssetId: id, deletedAt: null },
        })) > 0;
      if (!asset.purgeAfter && (asset.status !== 'READY' || attached))
        return null;
      if (asset.status === 'READY' && attached) return new UserAsset(asset);
      const retired = await tx.userAsset.update({
        where: { id },
        data: {
          status: 'DELETED',
          deletedAt: asset.deletedAt ?? new Date(),
          purgeAfter: asset.purgeAfter ?? cutoff,
        },
      });
      return new UserAsset(retired);
    });
  }
  async variantKeys(assetId: string) {
    const variants = await this.clientVariants.list(this.prisma, assetId);
    return variants.map((v) => v.storageKey);
  }
  async clearDeadline(asset: UserAsset, lease?: JobLease): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      if (lease) await this.fence(tx, lease);
      if (asset.status === 'DELETED')
        await this.clientVariants.retire(tx, asset.id);
      await tx.userAsset.updateMany({
        where: {
          id: asset.id,
          updatedAt: asset.updatedAt,
          status: asset.status,
        },
        data: { purgeAfter: null },
      });
    });
  }
  private async fence(
    tx: Prisma.TransactionClient,
    lease: JobLease,
  ): Promise<void> {
    const rows = await tx.$queryRaw<
      { id: string }[]
    >`SELECT id FROM ops.job_runs WHERE id=${lease.runId}::uuid AND status='RUNNING' AND fencing_token=${lease.fencingToken} AND lease_owner=${lease.workerId} AND deleted_at IS NULL AND lease_expires_at>clock_timestamp() FOR SHARE`;
    if (!rows.length) throw new Error('Job lease was lost.');
  }
}
