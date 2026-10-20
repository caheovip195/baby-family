import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { NotFoundError, ValidationError } from '../common/errors/domain.error';
import { PregnancyPrepItemDto } from '../dto/pregnancy/prep.dto';
import type {
  CreatePregnancyPrepDto,
  UpdatePregnancyPrepDto,
  PregnancyPrepGroupDto,
} from '../dto/pregnancy/prep.dto';
import { PREGNANCY_PREP_REPOSITORY } from '../interfaces/repositories/pregnancy-prep-repository.interface';
import type { IPregnancyPrepRepository } from '../interfaces/repositories/pregnancy-prep-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IPregnancyPrepService } from '../interfaces/services/pregnancy-prep-service.interface';

@Injectable()
export class PregnancyPrepService implements IPregnancyPrepService {
  constructor(
    @Inject(PREGNANCY_PREP_REPOSITORY)
    private readonly repository: IPregnancyPrepRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}
  async list(
    actor: AuthPrincipal,
    pregnancyId: string,
  ): Promise<PregnancyPrepGroupDto[]> {
    const pregnancy = await this.pregnancy(actor, pregnancyId, 'read');
    const items = await this.repository.listAndSeed(pregnancy, actor.userId);
    if (!items) throw new NotFoundError('Pregnancy was not found.');
    const groups = new Map<string, PregnancyPrepGroupDto>();
    for (const item of items) {
      let group = groups.get(item.groupCode);
      if (!group) {
        group = { groupCode: item.groupCode, items: [] };
        groups.set(item.groupCode, group);
      }
      group.items.push(PregnancyPrepItemDto.fromModel(item));
    }
    return [...groups.values()];
  }
  async create(
    actor: AuthPrincipal,
    pregnancyId: string,
    input: CreatePregnancyPrepDto,
  ): Promise<PregnancyPrepItemDto> {
    const pregnancy = await this.pregnancy(actor, pregnancyId, 'write');
    const title = this.title(input.title);
    if (
      typeof input.groupCode !== 'string' ||
      !/^[A-Z][A-Z0-9_]{0,19}$/.test(input.groupCode)
    )
      throw new ValidationError(
        'Group code must contain 1–20 uppercase letters, digits or underscores.',
      );
    const item = await this.repository.create(pregnancy, actor.userId, {
      groupCode: input.groupCode,
      title,
    });
    if (!item) throw new NotFoundError('Pregnancy was not found.');
    return PregnancyPrepItemDto.fromModel(item);
  }
  async update(
    actor: AuthPrincipal,
    id: string,
    input: UpdatePregnancyPrepDto,
  ): Promise<PregnancyPrepItemDto> {
    const current = await this.item(actor, id);
    if (
      input.title === undefined &&
      input.done === undefined &&
      input.sortOrder === undefined
    )
      throw new ValidationError('Provide at least one checklist field.');
    const patch: UpdatePregnancyPrepDto = { ...input };
    if (input.title !== undefined) patch.title = this.title(input.title);
    if (input.done !== undefined && typeof input.done !== 'boolean')
      throw new ValidationError('Done must be boolean.');
    if (
      input.sortOrder !== undefined &&
      (!Number.isInteger(input.sortOrder) ||
        input.sortOrder < 0 ||
        input.sortOrder > 2147483647)
    )
      throw new ValidationError(
        'Sort order must be a non-negative 32-bit integer.',
      );
    const item = await this.repository.update(current, actor.userId, patch);
    if (!item) throw new NotFoundError('Checklist item was not found.');
    return PregnancyPrepItemDto.fromModel(item);
  }
  async remove(actor: AuthPrincipal, id: string): Promise<void> {
    const item = await this.item(actor, id);
    if (!(await this.repository.remove(item, actor.userId)))
      throw new NotFoundError('Checklist item was not found.');
  }
  private async pregnancy(
    actor: AuthPrincipal,
    id: string,
    mode: 'read' | 'write',
  ) {
    const pregnancy = await this.repository.findPregnancy(id);
    if (!pregnancy) throw new NotFoundError('Pregnancy was not found.');
    await this.access.requireParent(actor, pregnancy.familyId, mode);
    return pregnancy;
  }
  private async item(actor: AuthPrincipal, id: string) {
    const item = await this.repository.findItem(id);
    if (!item) throw new NotFoundError('Checklist item was not found.');
    await this.access.requireParent(actor, item.familyId, 'write');
    return item;
  }
  private title(value: string): string {
    if (typeof value !== 'string' || !value.trim() || value.trim().length > 120)
      throw new ValidationError('Title must contain 1–120 characters.');
    return value.trim();
  }
}
