import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import { ChildProfileResponseDto } from '../dto/child/child-profile.dto';
import { CHILD_PROFILE_REPOSITORY } from '../interfaces/repositories/child-profile-repository.interface';
import type { IChildProfileRepository } from '../interfaces/repositories/child-profile-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IChildProfileService } from '../interfaces/services/child-profile-service.interface';
import { CHILD_PROFILE_POLICY } from '../config/child-profile-policy';
import { MEDIA_POLICY } from '../config/media-policy';
import type { Child } from '../models/child.model';
@Injectable()
export class ChildProfileService implements IChildProfileService {
  constructor(
    @Inject(CHILD_PROFILE_REPOSITORY)
    private readonly repository: IChildProfileRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}
  async reorder(actor: AuthPrincipal, familyId: string, childIds: string[]) {
    await this.access.requireParent(actor, familyId, 'write');
    const children = await this.repository.listActiveChildren(familyId);
    const expected = new Set(children.map((child) => child.id));
    if (
      !Array.isArray(childIds) ||
      childIds.length !== expected.size ||
      new Set(childIds).size !== childIds.length ||
      childIds.some((id) => !expected.has(id))
    )
      throw new ValidationError(
        'childIds must contain every active child exactly once.',
      );
    return (await this.repository.reorder(familyId, childIds, children)).map(
      (child) => ChildProfileResponseDto.fromModel(child),
    );
  }
  async transition(
    actor: AuthPrincipal,
    id: string,
    action: 'archive' | 'restore' | 'delete',
    confirmName?: string,
  ) {
    const child = await this.parent(actor, id);
    const now = new Date();
    if (action === 'delete') {
      if (confirmName !== child.name || !child.name)
        throw new ValidationError(
          'confirmName must exactly match the child name.',
        );
      if (
        child.status !== 'ARCHIVED' ||
        !child.archivedAt ||
        now.getTime() - child.archivedAt.getTime() <
          CHILD_PROFILE_POLICY.archiveBeforeDeleteMs
      )
        throw new DomainError(
          'Archive the child for at least seven days before deletion.',
          'CHILD_DELETE_GRACE_PERIOD',
          409,
        );
    } else if (
      (action === 'archive' && child.status === 'ARCHIVED') ||
      (action === 'restore' && child.status === 'ACTIVE')
    )
      return ChildProfileResponseDto.fromModel(child);
    else if (
      (action === 'archive' && child.status !== 'ACTIVE') ||
      (action === 'restore' && child.status !== 'ARCHIVED')
    )
      throw new DomainError(
        'Invalid child lifecycle transition.',
        'CHILD_STATUS_CONFLICT',
        409,
      );
    const purgeAfter = new Date(
      now.getTime() + CHILD_PROFILE_POLICY.trashRetentionMs,
    );
    return ChildProfileResponseDto.fromModel(
      await this.repository.transition(
        child,
        action,
        actor.userId,
        now,
        purgeAfter,
      ),
    );
  }
  async childAsset(
    actor: AuthPrincipal,
    id: string,
    field: 'avatarAssetId' | 'coverAssetId',
    assetId: string | null,
  ) {
    const child = await this.parent(actor, id);
    if (child.status !== 'ACTIVE')
      throw new NotFoundError('Active child was not found.');
    const asset = await this.asset(child.familyId, field, assetId);
    return ChildProfileResponseDto.fromModel(
      (await this.repository.setAsset('child', child, field, asset)) as Child,
    );
  }
  async pregnancyCover(
    actor: AuthPrincipal,
    id: string,
    assetId: string | null,
  ) {
    const pregnancy = await this.repository.findPregnancy(id);
    if (!pregnancy) throw new NotFoundError('Pregnancy was not found.');
    await this.access.requireParent(actor, pregnancy.familyId, 'write');
    if (pregnancy.status !== 'ACTIVE')
      throw new NotFoundError('Active pregnancy was not found.');
    const asset = await this.asset(pregnancy.familyId, 'coverAssetId', assetId);
    return (await this.repository.setAsset(
      'pregnancy',
      pregnancy,
      'coverAssetId',
      asset,
    )) as { id: string; familyId: string; coverAssetId: string | null };
  }
  private async asset(
    familyId: string,
    field: 'avatarAssetId' | 'coverAssetId',
    assetId: string | null,
  ) {
    if (assetId === null) return null;
    const asset = await this.repository.findAsset(assetId);
    const purpose = field === 'avatarAssetId' ? 'AVATAR' : 'COVER';
    if (
      !asset ||
      asset.familyId !== familyId ||
      asset.deletedAt ||
      asset.privateOwnerUserId !== null ||
      !(
        CHILD_PROFILE_POLICY.assignableAssetStatuses as readonly string[]
      ).includes(asset.status) ||
      asset.purpose !== purpose ||
      !(MEDIA_POLICY.purposes[purpose].kinds as readonly string[]).includes(
        asset.kind,
      )
    )
      throw new ValidationError(
        'Asset must be uploaded shared family media with the matching purpose.',
      );
    return asset;
  }

  async stats(actor: AuthPrincipal, id: string) {
    const viewer = await this.repository.viewer(id, actor.userId);
    if (!viewer) throw new NotFoundError('Child was not found.');
    if (viewer.parent) {
      await this.access.requireParent(actor, viewer.child.familyId, 'read');
    } else {
      const circle = viewer.circle;
      if (!circle) throw new NotFoundError('Child was not found.');
      if (!circle.active)
        throw new DomainError(
          'Circle membership is inactive.',
          'CIRCLE_INACTIVE',
          403,
        );
      if (!circle.granted || viewer.child.status !== 'ACTIVE')
        throw new NotFoundError('Child was not found.');
      if (!circle.familyActive || !circle.licensed || !circle.enabled)
        throw new DomainError(
          'Circle access is unavailable.',
          'CIRCLE_ACCESS_DENIED',
          403,
        );
    }
    return this.repository.stats(viewer.child, actor.userId, !viewer.parent);
  }
  private async parent(actor: AuthPrincipal, id: string) {
    const child = await this.repository.findChild(id);
    if (!child) throw new NotFoundError('Child was not found.');
    await this.access.requireParent(actor, child.familyId, 'write');
    return child;
  }
}
