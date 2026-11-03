import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import { GROWTH_POLICY } from '../config/growth-policy';
import { GrowthEntryDto } from '../dto/growth/growth.dto';
import type { GrowthListDto, UpsertGrowthDto } from '../dto/growth/growth.dto';
import { GROWTH_REPOSITORY } from '../interfaces/repositories/growth-repository.interface';
import type { IGrowthRepository } from '../interfaces/repositories/growth-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IGrowthService } from '../interfaces/services/growth-service.interface';
import type { GrowthChild } from '../models/growth.model';

const DAY = /^\d{4}-\d{2}-\d{2}$/;

/**
 * CHD-06 Tăng trưởng (BF-20261028-004): cân nặng / chiều cao theo ngày, chỉ
 * Parent xem và ghi (dữ liệu sức khoẻ của bé). Mỗi ngày một lần đo, ghi lại
 * thì đè (PUT idempotent nên app gửi lại khi offline an toàn). Không chuẩn
 * tham chiếu, không đánh giá.
 */
@Injectable()
export class GrowthService implements IGrowthService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(GROWTH_REPOSITORY)
    private readonly repository: IGrowthRepository,
  ) {}

  async list(actor: AuthPrincipal, childId: string): Promise<GrowthListDto> {
    const { child } = await this.child(actor, childId, 'read');
    const items = await this.repository.list(child.id, GROWTH_POLICY.listLimit);
    return {
      childId: child.id,
      birthDate: child.birthDate.toISOString().slice(0, 10),
      items: items.map((item) => GrowthEntryDto.fromModel(item)),
    };
  }

  async upsert(
    actor: AuthPrincipal,
    childId: string,
    measuredOn: string,
    input: UpsertGrowthDto,
  ): Promise<GrowthEntryDto> {
    const { child, timezone } = await this.child(actor, childId, 'write');
    this.assertDay(measuredOn, child, timezone);
    const weightGrams = input.weightGrams ?? null;
    const heightMm = input.heightMm ?? null;
    if (weightGrams === null && heightMm === null)
      throw new ValidationError('weightGrams or heightMm is required.');
    const note = input.note?.trim() || null;
    return GrowthEntryDto.fromModel(
      await this.repository.upsert(
        child,
        measuredOn,
        { weightGrams, heightMm, note },
        actor.userId,
      ),
    );
  }

  async remove(
    actor: AuthPrincipal,
    childId: string,
    measuredOn: string,
  ): Promise<void> {
    const { child } = await this.child(actor, childId, 'write');
    if (!DAY.test(measuredOn))
      throw new ValidationError('measuredOn must be YYYY-MM-DD.');
    // Xoá lại (gửi lại khi offline) vẫn 204.
    await this.repository.remove(child.id, measuredOn);
  }

  private async child(
    actor: AuthPrincipal,
    childId: string,
    mode: 'read' | 'write',
  ): Promise<{ child: GrowthChild; timezone: string }> {
    const child = await this.repository.child(childId);
    if (!child) throw new NotFoundError('Child was not found.');
    const family = await this.access.requireParent(actor, child.familyId, mode);
    return { child, timezone: family.timezone };
  }

  private assertDay(day: string, child: GrowthChild, timezone: string) {
    const parsed = new Date(`${day}T00:00:00.000Z`);
    if (
      !DAY.test(day) ||
      Number.isNaN(parsed.getTime()) ||
      parsed.toISOString().slice(0, 10) !== day
    )
      throw new ValidationError('measuredOn must be YYYY-MM-DD.');
    const today = new Intl.DateTimeFormat('en-CA', {
      timeZone: timezone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    }).format(new Date());
    if (day > today)
      throw new DomainError(
        'A measurement cannot be in the future.',
        'GROWTH_DATE_INVALID',
        400,
      );
    if (day < child.birthDate.toISOString().slice(0, 10))
      throw new DomainError(
        'A measurement cannot be before birth.',
        'GROWTH_DATE_INVALID',
        400,
      );
  }
}
