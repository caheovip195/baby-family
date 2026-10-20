import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import type {
  Paginated,
  PaginationInput,
} from '../common/pagination/pagination.types';
import type { LifecycleArchivePregnancyDto } from '../dto/pregnancy/lifecycle-pregnancy.dto';
import { PregnancyResponseDto } from '../dto/pregnancy/pregnancy-response.dto';
import { PREGNANCY_LIFECYCLE_REPOSITORY } from '../interfaces/repositories/pregnancy-lifecycle-repository.interface';
import type { IPregnancyLifecycleRepository } from '../interfaces/repositories/pregnancy-lifecycle-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IPregnancyLifecycleService } from '../interfaces/services/pregnancy-lifecycle-service.interface';
import type { Pregnancy } from '../models/pregnancy.model';

@Injectable()
export class PregnancyLifecycleService implements IPregnancyLifecycleService {
  constructor(
    @Inject(PREGNANCY_LIFECYCLE_REPOSITORY)
    private readonly repository: IPregnancyLifecycleRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}

  async archive(
    actor: AuthPrincipal,
    id: string,
    input: LifecycleArchivePregnancyDto,
  ): Promise<PregnancyResponseDto> {
    const current = await this.requirePregnancy(actor, id);
    if (input.reason !== 'ARCHIVED' && input.reason !== 'ENDED_PRIVATE')
      throw new ValidationError('Reason must be ARCHIVED or ENDED_PRIVATE.');
    if (current.status === 'COMPLETED')
      throw new DomainError(
        'A converted pregnancy cannot be archived.',
        'PREGNANCY_ALREADY_COMPLETED',
        409,
      );
    if (current.status === 'ENDED_PRIVATE' && input.reason === 'ARCHIVED')
      throw new DomainError(
        'Restore the pregnancy before changing its archive mode.',
        'PREGNANCY_STATUS_CONFLICT',
        409,
      );
    if (current.status === input.reason)
      return PregnancyResponseDto.fromModel(current);
    return PregnancyResponseDto.fromModel(
      await this.repository.changeStatus(current, input.reason),
    );
  }

  async restore(
    actor: AuthPrincipal,
    id: string,
  ): Promise<PregnancyResponseDto> {
    const current = await this.requirePregnancy(actor, id);
    if (current.status === 'ACTIVE')
      return PregnancyResponseDto.fromModel(current);
    if (!['ARCHIVED', 'ENDED_PRIVATE', 'PAUSED'].includes(current.status))
      throw new DomainError(
        'Only archived pregnancies can be restored.',
        'PREGNANCY_STATUS_CONFLICT',
        409,
      );
    return PregnancyResponseDto.fromModel(
      await this.repository.changeStatus(current, 'ACTIVE'),
    );
  }

  async listArchived(
    actor: AuthPrincipal,
    familyId: string,
    input: PaginationInput,
  ): Promise<Paginated<PregnancyResponseDto>> {
    await this.access.requireParent(actor, familyId, 'read');
    const result = await this.repository.listArchived(familyId, input);
    return {
      data: result.data.map((pregnancy) =>
        PregnancyResponseDto.fromModel(pregnancy),
      ),
      meta: result.meta,
    };
  }

  private async requirePregnancy(
    actor: AuthPrincipal,
    id: string,
  ): Promise<Pregnancy> {
    const pregnancy = await this.repository.findById(id);
    if (!pregnancy) throw new NotFoundError('Pregnancy was not found.');
    await this.access.requireParent(actor, pregnancy.familyId, 'write');
    return pregnancy;
  }
}
