import { Inject, Injectable } from '@nestjs/common';
import { isUUID } from 'class-validator';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { NotFoundError, ValidationError } from '../common/errors/domain.error';
import { ChildResponseDto } from '../dto/child/child-response.dto';
import type {
  BirthConversionDto,
  BirthConversionResponseDto,
} from '../dto/pregnancy/birth-conversion.dto';
import { BIRTH_CONVERSION_WORKFLOW_REPOSITORY } from '../interfaces/repositories/birth-conversion-workflow-repository.interface';
import type {
  IBirthConversionWorkflowRepository,
  BirthChildInput,
} from '../interfaces/repositories/birth-conversion-workflow-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IBirthConversionWorkflowService } from '../interfaces/services/birth-conversion-workflow-service.interface';
@Injectable()
export class BirthConversionWorkflowService implements IBirthConversionWorkflowService {
  constructor(
    @Inject(BIRTH_CONVERSION_WORKFLOW_REPOSITORY)
    private readonly repository: IBirthConversionWorkflowRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}
  async convert(
    actor: AuthPrincipal,
    id: string,
    key: string,
    input: BirthConversionDto,
  ): Promise<BirthConversionResponseDto> {
    if (typeof key !== 'string' || !isUUID(key))
      throw new ValidationError('Idempotency-Key must be a UUID.');
    const pregnancy = await this.repository.findPregnancy(id);
    if (!pregnancy) throw new NotFoundError('Pregnancy was not found.');
    await this.access.requireParent(actor, pregnancy.familyId, 'write');
    if (
      !input.children?.length ||
      input.children.length > pregnancy.expectedCount
    )
      throw new ValidationError('Provide 1..expectedCount children.');
    const children: BirthChildInput[] = input.children.map((child) => {
      const date = new Date(child.birthDate + 'T00:00:00.000Z');
      if (
        !Number.isFinite(date.getTime()) ||
        date.toISOString().slice(0, 10) !== child.birthDate ||
        child.birthDate.startsWith('0000-')
      )
        throw new ValidationError('Birth date is invalid.');
      return {
        name: child.name.trim(),
        nickname: child.nickname?.trim() || null,
        gender: child.gender,
        birthDate: date,
        birthTime: child.birthTime
          ? new Date('1970-01-01T' + child.birthTime + ':00.000Z')
          : null,
        ...(child.birthStats
          ? {
              birthStats: {
                ...(child.birthStats.weightG === undefined
                  ? {}
                  : { weightGram: child.birthStats.weightG }),
                ...(child.birthStats.lengthCm === undefined
                  ? {}
                  : { lengthMm: child.birthStats.lengthCm * 10 }),
              },
            }
          : {}),
      };
    });
    return {
      pregnancyId: id,
      children: (
        await this.repository.convert(
          pregnancy,
          key.toLowerCase(),
          actor.userId,
          children,
        )
      ).map((child) => ChildResponseDto.fromModel(child)),
    };
  }
}
