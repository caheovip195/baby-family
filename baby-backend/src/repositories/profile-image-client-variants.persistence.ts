import type { Prisma } from '../generated/prisma/client';
import type { ProfileImageVariant } from '../interfaces/repositories/profile-image-repository.interface';
import { ProfileImageClientVariant } from '../models/profile-image-client-variant.model';

/** Raw-managed forward table: keeps existing generated persistence artifacts unchanged. */
export class ProfileImageClientVariantsPersistence {
  async list(tx: Prisma.TransactionClient, assetId: string, userId?: string) {
    const rows = await tx.$queryRaw<ProfileImageVariant[]>`
      SELECT variant_code AS "variantCode", storage_bucket AS "storageBucket", storage_key AS "storageKey", mime,
        size_bytes AS "sizeBytes", checksum_sha256 AS "checksumSha256", width, height
      FROM app.user_asset_variants WHERE asset_id=${assetId}::uuid AND deleted_at IS NULL
        AND (${userId ?? null}::uuid IS NULL OR owner_user_id=${userId ?? null}::uuid)`;
    return rows.map((row) => new ProfileImageClientVariant(row));
  }
  async create(
    tx: Prisma.TransactionClient,
    assetId: string,
    userId: string,
    variants: ProfileImageVariant[],
  ) {
    for (const v of variants)
      await tx.$executeRaw`INSERT INTO app.user_asset_variants
        (asset_id, owner_user_id, variant_code, storage_bucket, storage_key, mime, size_bytes, checksum_sha256, width, height)
        VALUES (${assetId}::uuid, ${userId}::uuid, ${v.variantCode}, ${v.storageBucket}, ${v.storageKey}, ${v.mime}, ${v.sizeBytes}, ${Buffer.from(v.checksumSha256)}, ${v.width}, ${v.height})`;
  }
  async verify(
    tx: Prisma.TransactionClient,
    assetId: string,
    variants: { code: string; size: bigint }[],
  ) {
    for (const variant of variants)
      await tx.$executeRaw`UPDATE app.user_asset_variants SET verified_size_bytes=${variant.size} WHERE asset_id=${assetId}::uuid AND variant_code=${variant.code} AND deleted_at IS NULL`;
  }
  async retire(tx: Prisma.TransactionClient, assetId: string) {
    await tx.$executeRaw`UPDATE app.user_asset_variants SET deleted_at=now() WHERE asset_id=${assetId}::uuid AND deleted_at IS NULL`;
  }
}
