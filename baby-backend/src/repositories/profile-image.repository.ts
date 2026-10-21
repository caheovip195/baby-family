import { ProfileImageClientVariantsPersistence } from './profile-image-client-variants.persistence';
import { AssetVariant } from '../models/asset-variant.model';
import { Injectable } from '@nestjs/common';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import { PrismaService } from '../database/prisma.service';
import type { IProfileImageRepository } from '../interfaces/repositories/profile-image-repository.interface';
import { UserAsset } from '../models/user-asset.model';

@Injectable()
export class ProfileImageRepository implements IProfileImageRepository {
  private readonly clientVariants = new ProfileImageClientVariantsPersistence();
  constructor(private readonly prisma: PrismaService) {}
  async reserve(input: Parameters<IProfileImageRepository['reserve']>[0]) {
    const { variants = [], ...attributes } = input;
    return this.prisma.$transaction(async (tx) => {
      const inserted = await tx.userAsset.createMany({
        data: [
          {
            ...attributes,
            purpose: 'AVATAR',
            sha256: Buffer.from(input.sha256),
          },
        ],
        skipDuplicates: true,
      });
      await tx.$queryRaw`SELECT id FROM app.user_assets WHERE id=${input.id}::uuid FOR UPDATE`;
      const row = await tx.userAsset.findUniqueOrThrow({
        where: { id: input.id },
      });
      if (
        row.deletedAt ||
        row.ownerUserId !== input.ownerUserId ||
        row.mime !== input.mime ||
        row.declaredSize !== input.declaredSize ||
        !row.sha256 ||
        !Buffer.from(row.sha256).equals(Buffer.from(input.sha256))
      )
        throw new DomainError(
          'Idempotency key was used for another upload.',
          'IDEMPOTENCY_KEY_REUSED',
          409,
        );
      const existing = await this.clientVariants.list(
        tx,
        input.id,
        input.ownerUserId,
      );
      if (existing.length) {
        if (
          existing.length !== variants.length ||
          variants.some(
            (v) =>
              !existing.some(
                (e) =>
                  e.variantCode === v.variantCode &&
                  e.mime === v.mime &&
                  e.sizeBytes === v.sizeBytes &&
                  e.width === v.width &&
                  e.height === v.height &&
                  Buffer.from(e.checksumSha256).equals(
                    Buffer.from(v.checksumSha256),
                  ),
              ),
          )
        )
          throw new DomainError(
            'Idempotency key was used for another upload.',
            'IDEMPOTENCY_KEY_REUSED',
            409,
          );
      } else if (variants.length) {
        // The row lock prevents concurrent retries from creating a different declaration set.
        if (!inserted.count || row.status !== 'PENDING_UPLOAD')
          throw new DomainError(
            'Idempotency key was used for another upload.',
            'IDEMPOTENCY_KEY_REUSED',
            409,
          );
        await this.clientVariants.create(
          tx,
          input.id,
          input.ownerUserId,
          variants,
        );
      }
      return new UserAsset(row);
    });
  }
  async variants(userId: string, assetId: string) {
    return this.clientVariants.list(this.prisma, assetId, userId);
  }
  async fail(userId: string, assetId: string) {
    await this.prisma.userAsset.updateMany({
      where: {
        id: assetId,
        ownerUserId: userId,
        deletedAt: null,
        status: { in: ['PENDING_UPLOAD', 'PROCESSING'] },
      },
      data: { status: 'FAILED' },
    });
  }
  async ownAsset(userId: string, assetId: string) {
    const row = await this.prisma.userAsset.findFirst({
      where: {
        id: assetId,
        ownerUserId: userId,
        purpose: 'AVATAR',
        deletedAt: null,
      },
    });
    return row ? new UserAsset(row) : null;
  }
  async avatar(userId: string) {
    const user = await this.prisma.user.findFirst({
      where: { id: userId, deletedAt: null },
    });
    if (!user?.avatarAssetId) return null;
    const asset = await this.ownAsset(userId, user.avatarAssetId);
    return asset?.status === 'READY' ? asset : null;
  }
  async startProcessing(userId: string, assetId: string) {
    const result = await this.prisma.userAsset.updateMany({
      where: {
        id: assetId,
        ownerUserId: userId,
        purpose: 'AVATAR',
        deletedAt: null,
        status: { in: ['PENDING_UPLOAD', 'PROCESSING'] },
        purgeAfter: { gt: new Date() },
      },
      data: { status: 'PROCESSING' },
    });
    if (!result.count)
      throw new DomainError(
        'Upload is no longer pending.',
        'UPLOAD_EXPIRED',
        409,
      );
  }
  async ready(
    userId: string,
    assetId: string,
    size: bigint,
    verifiedVariants: { code: string; size: bigint }[] = [],
  ) {
    await this.prisma.$transaction(async (tx) => {
      const result = await tx.userAsset.updateMany({
        where: {
          id: assetId,
          ownerUserId: userId,
          deletedAt: null,
          status: { in: ['PENDING_UPLOAD', 'PROCESSING'] },
          purgeAfter: { gt: new Date() },
        },
        data: {
          status: 'READY',
          sizeBytes: size,
          readyAt: new Date(),
        },
      });
      if (!result.count) {
        const existing = await this.ownAsset(userId, assetId);
        if (existing?.status !== 'READY')
          throw new DomainError(
            'Upload is no longer pending.',
            'UPLOAD_EXPIRED',
            409,
          );
      }
      if (result.count)
        await this.clientVariants.verify(tx, assetId, verifiedVariants);
    });
  }
  async attach(
    userId: string,
    assetId: string | null,
    fields: Parameters<IProfileImageRepository['attach']>[2] = {},
  ) {
    await this.prisma.$transaction(async (tx) => {
      if (assetId !== null) {
        await tx.$queryRaw`SELECT id FROM app.user_assets WHERE id = ${assetId}::uuid AND owner_user_id = ${userId}::uuid FOR UPDATE`;
        const asset = await tx.userAsset.findFirst({
          where: {
            id: assetId,
            ownerUserId: userId,
            purpose: 'AVATAR',
            status: 'READY',
            deletedAt: null,
          },
        });
        if (!asset)
          throw new DomainError(
            'A ready avatar owned by you is required.',
            'AVATAR_ASSET_INVALID',
            422,
          );
      }
      const result = await tx.user.updateMany({
        where: { id: userId, deletedAt: null },
        data: { ...fields, avatarAssetId: assetId },
      });
      if (!result.count) throw new NotFoundError('User was not found.');
    });
  }
  async childLocations(userId: string, familyId: string, childId: string) {
    const parent = await this.prisma.familyParent.findFirst({
      where: {
        familyId,
        userId,
        status: 'ACTIVE',
        deletedAt: null,
        leftAt: null,
      },
    });
    if (!parent) {
      const grant = await this.prisma.circleGrant.findFirst({
        where: {
          familyId,
          childId,
          status: 'ACTIVE',
          deletedAt: null,
          circleMember: { familyId, userId, status: 'ACTIVE', deletedAt: null },
        },
      });
      if (!grant) return null;
    }
    const child = await this.prisma.child.findFirst({
      where: { id: childId, familyId, deletedAt: null },
    });
    if (!child) return null;
    const location = async (id: string | null, purpose: string) => {
      if (!id) return null;
      const variant = await this.prisma.assetVariant.findFirst({
        where: {
          assetId: id,
          familyId,
          deletedAt: null,
          variantCode: { in: ['t320', 'm1080', 'l2048'] },
          asset: { familyId, status: 'READY', purpose, deletedAt: null },
        },
        orderBy: { variantCode: 'desc' },
      });
      return variant ? new AssetVariant(variant) : null;
    };
    return {
      avatar: await location(child.avatarAssetId, 'AVATAR'),
      cover: await location(child.coverAssetId, 'COVER'),
    };
  }

  async familyCoverLocation(familyId: string): Promise<AssetVariant | null> {
    const family = await this.prisma.family.findFirst({
      where: { id: familyId, deletedAt: null },
      select: { coverAssetId: true },
    });
    if (!family?.coverAssetId) return null;
    const variant = await this.prisma.assetVariant.findFirst({
      where: {
        assetId: family.coverAssetId,
        familyId,
        deletedAt: null,
        variantCode: { in: ['t320', 'm1080', 'l2048'] },
        asset: { familyId, status: 'READY', purpose: 'COVER', deletedAt: null },
      },
      orderBy: { variantCode: 'desc' },
    });
    return variant ? new AssetVariant(variant) : null;
  }

  async isUsableFamilyCover(
    familyId: string,
    assetId: string,
  ): Promise<boolean> {
    return (
      (await this.prisma.asset.count({
        where: {
          id: assetId,
          familyId,
          purpose: 'COVER',
          status: 'READY',
          deletedAt: null,
        },
      })) > 0
    );
  }
}
