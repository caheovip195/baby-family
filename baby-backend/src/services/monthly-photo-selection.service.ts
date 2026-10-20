import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import { MEDIA_POLICY } from '../config/media-policy';
import type {
  SetMonthlyPhotoDto,
  MonthlyPhotoSelectionDto,
} from '../dto/monthly-photo/monthly-photo-selection.dto';
import {
  MONTHLY_PHOTO_SELECTION_REPOSITORY,
  type IMonthlyPhotoSelectionRepository,
} from '../interfaces/repositories/monthly-photo-selection-repository.interface';
import {
  APPLICATION_ACCESS_SERVICE,
  type IApplicationAccessService,
} from '../interfaces/services/application-access-service.interface';
import {
  MEDIA_SERVICE,
  type IMediaService,
} from '../interfaces/services/media-service.interface';
import type { IMonthlyPhotoSelectionService } from '../interfaces/services/monthly-photo-selection-service.interface';
import type { MonthlyPhotoSelection } from '../models/monthly-photo-selection.model';
import { completedPhotoMonths } from '../common/time/monthly-photo-age';
@Injectable()
export class MonthlyPhotoSelectionService implements IMonthlyPhotoSelectionService {
  constructor(
    @Inject(MONTHLY_PHOTO_SELECTION_REPOSITORY)
    private readonly repository: IMonthlyPhotoSelectionRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(MEDIA_SERVICE) private readonly media: IMediaService,
  ) {}
  async list(actor: AuthPrincipal, childId: string) {
    const context = await this.repository.child(childId, actor.userId);
    if (!context?.readable) throw new NotFoundError('Child was not found.');
    if (this.access.requireContentAccess)
      await this.access.requireContentAccess(
        actor,
        context.child.familyId,
        'read',
      );
    else await this.access.requireParent(actor, context.child.familyId, 'read');
    const rows = await this.repository.list(
      context.child.familyId,
      childId,
      actor.userId,
    );
    return this.project(
      actor,
      rows.filter(
        (row) =>
          context.child.birthDate &&
          row.occurredLocalDate >= context.child.birthDate &&
          completedPhotoMonths(
            context.child.birthDate,
            row.occurredLocalDate,
            context.child.monthlyPhotoLunar,
          ) === row.monthIndex,
      ),
    );
  }
  async set(
    actor: AuthPrincipal,
    childId: string,
    monthIndex: number,
    input: SetMonthlyPhotoDto,
  ) {
    const context = await this.repository.child(childId, actor.userId);
    if (!context?.readable) throw new NotFoundError('Child was not found.');
    const child = context.child;
    await this.access.requireParent(actor, child.familyId, 'write');
    if (!Number.isInteger(monthIndex) || monthIndex < 0 || monthIndex > 240)
      throw new DomainError('Invalid month index.', 'MONTH_INDEX_INVALID', 422);
    const candidate = await this.repository.candidate(
      child.familyId,
      input.memoryId,
      input.assetId,
    );
    if (
      !candidate ||
      (candidate.memory.visibility === 'PRIVATE' &&
        candidate.memory.authorUserId !== actor.userId)
    )
      throw new NotFoundError('Memory was not found.');
    const memory = candidate.memory;
    if (
      candidate.childIds.length !== 1 ||
      candidate.childIds[0] !== childId ||
      memory.familyMoment ||
      memory.pregnancyId ||
      !['MOMENT', 'MONTHLY_PHOTO'].includes(memory.kind) ||
      memory.status !== 'PUBLISHED' ||
      !candidate.imageReady
    )
      throw new DomainError(
        'Choose a published photo memory for this child.',
        'MONTHLY_PHOTO_INVALID',
        422,
      );
    const born = child.birthDate;
    const at = memory.occurredLocalDate;
    if (
      !born ||
      at < born ||
      memory.occurredAt.getTime() > Date.now() ||
      completedPhotoMonths(born, at, child.monthlyPhotoLunar) !== monthIndex
    )
      throw new DomainError(
        'Month index does not match the memory date.',
        'MONTH_INDEX_MISMATCH',
        422,
      );
    const row = await this.repository.set(
      child.familyId,
      childId,
      actor.userId,
      monthIndex,
      memory.id,
      input.assetId,
      memory.version,
    );
    return (await this.project(actor, [row]))[0]!;
  }
  private async project(
    actor: AuthPrincipal,
    rows: MonthlyPhotoSelection[],
  ): Promise<MonthlyPhotoSelectionDto[]> {
    const urls = new Map<string, string>();
    for (
      let start = 0;
      start < rows.length;
      start += MEDIA_POLICY.maxBatchAssets
    ) {
      const signed = await this.media.signViewUrls(actor, {
        assetIds: [
          ...new Set(
            rows
              .slice(start, start + MEDIA_POLICY.maxBatchAssets)
              .map((r) => r.assetId),
          ),
        ],
      });
      for (const item of signed.items) {
        const url =
          item.urls.t1280 ??
          item.urls.m1080 ??
          item.urls.t640 ??
          item.urls.t320 ??
          Object.values(item.urls)[0];
        if (url) urls.set(item.assetId, url);
      }
    }
    return rows.map((r) => ({
      monthIndex: r.monthIndex,
      memoryId: r.memoryId,
      url: urls.get(r.assetId) ?? null,
      occurredAt: r.occurredAt.toISOString(),
    }));
  }
}
