import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  ConflictError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import type {
  Paginated,
  PaginationInput,
} from '../common/pagination/pagination.types';
import type { UpdatePregnancyDto } from '../dto/pregnancy/update-pregnancy.dto';
import type { CreatePregnancyDto } from '../dto/pregnancy/create-pregnancy.dto';
import { PregnancyResponseDto } from '../dto/pregnancy/pregnancy-response.dto';
import { PREGNANCY_REPOSITORY } from '../interfaces/repositories/pregnancy-repository.interface';
import type {
  IPregnancyRepository,
  UpdatePregnancyInput,
} from '../interfaces/repositories/pregnancy-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IPregnancyService } from '../interfaces/services/pregnancy-service.interface';
import { PREGNANCY_COMMAND_REPOSITORY } from '../interfaces/repositories/pregnancy-command-repository.interface';
import type { IPregnancyCommandRepository } from '../interfaces/repositories/pregnancy-command-repository.interface';

@Injectable()
export class PregnancyService implements IPregnancyService {
  constructor(
    @Inject(PREGNANCY_REPOSITORY)
    private readonly repository: IPregnancyRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(PREGNANCY_COMMAND_REPOSITORY)
    private readonly commands: IPregnancyCommandRepository,
  ) {}

  async create(
    actor: AuthPrincipal,
    familyId: string,
    input: CreatePregnancyDto,
  ): Promise<PregnancyResponseDto> {
    await this.access.requireParent(actor, familyId, 'write');
    if (
      typeof input.nickname !== 'string' ||
      !input.nickname.trim() ||
      input.nickname.trim().length > 40
    )
      throw new ValidationError(
        'Pregnancy nickname must contain between 1 and 40 characters.',
      );
    const expectedCount =
      input.expectedCount === undefined ? 1 : input.expectedCount;
    if (
      !Number.isInteger(expectedCount) ||
      expectedCount < 1 ||
      expectedCount > 4
    )
      throw new ValidationError(
        'Expected count must be an integer between 1 and 4.',
      );
    return PregnancyResponseDto.fromModel(
      await this.commands.createNext(familyId, {
        nickname: input.nickname.trim(),
        dueDate:
          input.dueDate === undefined || input.dueDate === null
            ? null
            : this.parseDate(input.dueDate),
        expectedCount,
        createdBy: actor.userId,
      }),
    );
  }

  async list(
    actor: AuthPrincipal,
    familyId: string,
    input: PaginationInput,
  ): Promise<Paginated<PregnancyResponseDto>> {
    await this.access.requireParent(actor, familyId, 'read');
    const result = await this.repository.list({ familyId }, input);
    return {
      data: result.data.map((pregnancy) =>
        PregnancyResponseDto.fromModel(pregnancy),
      ),
      meta: result.meta,
    };
  }

  async getById(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
  ): Promise<PregnancyResponseDto> {
    await this.access.requireParent(actor, familyId, 'read');
    const pregnancy = await this.repository.findByKey({ familyId }, { id });
    if (!pregnancy) throw new NotFoundError('Pregnancy was not found.');
    return PregnancyResponseDto.fromModel(pregnancy);
  }

  async update(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    input: UpdatePregnancyDto,
  ): Promise<PregnancyResponseDto> {
    await this.access.requireParent(actor, familyId, 'write');
    const current = await this.repository.findByKey({ familyId }, { id });
    if (!current) throw new NotFoundError('Pregnancy was not found.');
    if (current.status !== 'ACTIVE')
      throw new ConflictError('Only an active pregnancy can be edited.');
    const data: UpdatePregnancyInput = {};
    if (input.nickname !== undefined) {
      if (
        typeof input.nickname !== 'string' ||
        !input.nickname.trim() ||
        input.nickname.trim().length > 40
      )
        throw new ValidationError(
          'Pregnancy nickname must contain between 1 and 40 characters.',
        );
      data.nickname = input.nickname.trim();
    }
    if (input.expectedCount !== undefined) {
      if (
        !Number.isInteger(input.expectedCount) ||
        input.expectedCount < 1 ||
        input.expectedCount > 4
      )
        throw new ValidationError(
          'Expected count must be an integer between 1 and 4.',
        );
      data.expectedCount = input.expectedCount;
    }
    if (input.dueDate !== undefined)
      data.dueDate =
        input.dueDate === null ? null : this.parseDate(input.dueDate);
    if (!Object.keys(data).length)
      throw new ValidationError(
        'Provide at least one supported pregnancy field.',
      );
    const pregnancy = await this.repository.update({ familyId }, { id }, data);
    if (!pregnancy) throw new NotFoundError('Pregnancy was not found.');
    return PregnancyResponseDto.fromModel(pregnancy);
  }

  private parseDate(value: string): Date {
    if (typeof value !== 'string' || !/^\d{4}-\d{2}-\d{2}$/.test(value))
      throw new ValidationError('Due date must use YYYY-MM-DD.');
    const date = new Date(value + 'T00:00:00.000Z');
    if (
      value.startsWith('0000-') ||
      !Number.isFinite(date.getTime()) ||
      date.toISOString().slice(0, 10) !== value
    )
      throw new ValidationError('Due date must be a valid calendar date.');
    return date;
  }
}
