import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { Gender } from '../common/database.enums';
import {
  ConflictError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import type {
  Paginated,
  PaginationInput,
} from '../common/pagination/pagination.types';
import type { CreateChildDto } from '../dto/child/create-child.dto';
import type { UpdateChildDto } from '../dto/child/update-child.dto';
import { ChildResponseDto } from '../dto/child/child-response.dto';
import { CHILD_REPOSITORY } from '../interfaces/repositories/child-repository.interface';
import type {
  IChildRepository,
  CreateChildInput,
  UpdateChildInput,
} from '../interfaces/repositories/child-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IChildService } from '../interfaces/services/child-service.interface';

@Injectable()
export class ChildService implements IChildService {
  constructor(
    @Inject(CHILD_REPOSITORY) private readonly repository: IChildRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}

  async list(
    actor: AuthPrincipal,
    familyId: string,
    input: PaginationInput,
  ): Promise<Paginated<ChildResponseDto>> {
    await this.access.requireParent(actor, familyId, 'read');
    const result = await this.repository.list({ familyId }, input);
    return {
      data: result.data.map((child) => ChildResponseDto.fromModel(child)),
      meta: result.meta,
    };
  }

  async getById(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
  ): Promise<ChildResponseDto> {
    await this.access.requireParent(actor, familyId, 'read');
    const child = await this.repository.findByKey({ familyId }, { id });
    if (!child) throw new NotFoundError('Child was not found.');
    return ChildResponseDto.fromModel(child);
  }

  async create(
    actor: AuthPrincipal,
    familyId: string,
    input: CreateChildDto,
  ): Promise<ChildResponseDto> {
    await this.access.requireParent(actor, familyId, 'write');
    const name = this.normalizeName(input.name, 60);
    const nickname = this.normalizeName(input.nickname, 40);
    this.assertNames(name, nickname);
    this.assertColor(input.colorIndex);
    if (input.gender !== undefined) this.assertGender(input.gender);
    const data: CreateChildInput = {
      name: name ?? null,
      nickname: nickname ?? null,
      birthDate: this.parseDate(input.birthDate),
      colorIndex: input.colorIndex,
      createdBy: actor.userId,
      ...(input.gender === undefined ? {} : { gender: input.gender }),
      ...(input.birthTime === undefined
        ? {}
        : { birthTime: this.parseTime(input.birthTime) }),
    };
    return ChildResponseDto.fromModel(
      await this.repository.create({ familyId }, data),
    );
  }

  async update(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    input: UpdateChildDto,
  ): Promise<ChildResponseDto> {
    await this.access.requireParent(actor, familyId, 'write');
    const current = await this.repository.findByKey({ familyId }, { id });
    if (!current) throw new NotFoundError('Child was not found.');
    if (current.status !== 'ACTIVE')
      throw new ConflictError('Only an active child profile can be edited.');
    const data: UpdateChildInput = {};
    if (input.name !== undefined)
      data.name = this.normalizeName(input.name, 60);
    if (input.nickname !== undefined)
      data.nickname = this.normalizeName(input.nickname, 40);
    this.assertNames(
      data.name === undefined ? current.name : data.name,
      data.nickname === undefined ? current.nickname : data.nickname,
    );
    if (input.birthDate !== undefined)
      data.birthDate = this.parseDate(input.birthDate);
    if (input.birthTime !== undefined)
      data.birthTime = this.parseTime(input.birthTime);
    if (input.colorIndex !== undefined) {
      this.assertColor(input.colorIndex);
      data.colorIndex = input.colorIndex;
    }
    if (input.gender !== undefined) {
      this.assertGender(input.gender);
      data.gender = input.gender;
    }
    if (!Object.keys(data).length)
      throw new ValidationError('Provide at least one supported child field.');
    const child = await this.repository.update({ familyId }, { id }, data);
    if (!child) throw new NotFoundError('Child was not found.');
    return ChildResponseDto.fromModel(child);
  }

  private normalizeName(
    value: string | null | undefined,
    max: number,
  ): string | null | undefined {
    if (value === undefined || value === null) return value;
    if (typeof value !== 'string' || value.trim().length > max)
      throw new ValidationError('Child name is invalid.');
    return value.trim() || null;
  }
  private assertNames(
    name: string | null | undefined,
    nickname: string | null | undefined,
  ): void {
    if (!name?.trim() && !nickname?.trim())
      throw new ValidationError('Provide a nonblank name or nickname.');
  }
  private assertColor(value: number): void {
    if (!Number.isInteger(value) || value < 1 || value > 8)
      throw new ValidationError(
        'Color index must be an integer between 1 and 8.',
      );
  }
  private assertGender(value: Gender): void {
    if (!Object.values(Gender).includes(value))
      throw new ValidationError('Gender is invalid.');
  }
  private parseDate(value: string): Date {
    if (typeof value !== 'string' || !/^\d{4}-\d{2}-\d{2}$/.test(value))
      throw new ValidationError('Birth date must use YYYY-MM-DD.');
    const date = new Date(value + 'T00:00:00.000Z');
    if (
      value.startsWith('0000-') ||
      !Number.isFinite(date.getTime()) ||
      date.toISOString().slice(0, 10) !== value
    )
      throw new ValidationError('Birth date must be a valid calendar date.');
    return date;
  }
  private parseTime(value: string | null): Date | null {
    if (value === null) return null;
    if (typeof value !== 'string' || !/^(?:[01]\d|2[0-3]):[0-5]\d$/.test(value))
      throw new ValidationError('Birth time must use HH:mm.');
    return new Date('1970-01-01T' + value + ':00.000Z');
  }
}
