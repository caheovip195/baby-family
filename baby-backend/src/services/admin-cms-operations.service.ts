import { Inject, Injectable } from '@nestjs/common';
import { DomainError } from '../common/errors/domain.error';
import type { AdminCmsActor } from '../models/admin-cms-auth.model';
import type {
  AdminCmsOperationsListDto,
  AdminCmsOperationsStatusDto,
  AdminCmsOperationsActionDto,
  AdminCmsOperationsBlockDto,
  AdminCmsOperationsReasonDto,
} from '../dto/admin-cms-operations/admin-cms-operations.dto';
import { ADMIN_CMS_OPERATIONS_REPOSITORY } from '../interfaces/repositories/admin-cms-operations-repository.interface';
import type { IAdminCmsOperationsRepository } from '../interfaces/repositories/admin-cms-operations-repository.interface';
import type { IAdminCmsOperationsService } from '../interfaces/services/admin-cms-operations-service.interface';
@Injectable()
export class AdminCmsOperationsService implements IAdminCmsOperationsService {
  constructor(
    @Inject(ADMIN_CMS_OPERATIONS_REPOSITORY)
    private readonly repository: IAdminCmsOperationsRepository,
  ) {}
  private allow(actor: AdminCmsActor, roles: string[]) {
    if (
      !actor.roles.some((role) =>
        [...roles, 'ADMIN', 'SUPER_ADMIN'].includes(role),
      )
    )
      throw new DomainError(
        'Admin permission is required.',
        'ADMIN_FORBIDDEN',
        403,
      );
  }
  private reason(input: AdminCmsOperationsReasonDto) {
    const reason = input.reason?.trim();
    if (!reason || reason.length > 1000)
      throw new DomainError(
        'Reason is required.',
        'ADMIN_REASON_REQUIRED',
        422,
      );
    return reason;
  }
  async list(actor: AdminCmsActor, input: AdminCmsOperationsListDto) {
    this.allow(actor, ['MODERATOR', 'SUPPORT', 'OPS']);
    const result = await this.repository.list(actor.id, {
      status: input.status,
      offset: input.offset ?? 0,
      limit: input.limit ?? 25,
    });
    return { ...result, items: result.items.map((row) => row.attributes) };
  }
  async detail(actor: AdminCmsActor, id: string) {
    this.allow(actor, ['MODERATOR', 'SUPPORT', 'OPS']);
    return (await this.repository.detail(actor.id, id)).attributes;
  }
  content(
    actor: AdminCmsActor,
    id: string,
    input: AdminCmsOperationsReasonDto,
  ) {
    this.allow(actor, ['MODERATOR']);
    return this.repository.content(actor.id, id, this.reason(input));
  }
  async status(
    actor: AdminCmsActor,
    id: string,
    input: AdminCmsOperationsStatusDto,
  ) {
    this.allow(actor, ['MODERATOR']);
    if (!['IN_REVIEW', 'RESOLVED', 'ESCALATED'].includes(input.status))
      throw new DomainError(
        'Invalid case status.',
        'ADMIN_CASE_STATE_INVALID',
        422,
      );
    return (
      await this.repository.status(
        actor.id,
        id,
        input.status,
        this.reason(input),
      )
    ).attributes;
  }
  async hide(
    actor: AdminCmsActor,
    id: string,
    input: AdminCmsOperationsActionDto,
  ) {
    this.allow(actor, ['MODERATOR']);
    if (input.action !== 'HIDE')
      throw new DomainError(
        'Invalid case action.',
        'ADMIN_ACTION_INVALID',
        422,
      );
    return (await this.repository.hide(actor.id, id, this.reason(input)))
      .attributes;
  }
  license(
    actor: AdminCmsActor,
    id: string,
    blocked: boolean,
    input: AdminCmsOperationsBlockDto,
  ) {
    this.allow(actor, ['OPS', 'BILLING_OPS']);
    const reasonCode = input.reasonCode;
    if (!reasonCode || !/^[A-Z][A-Z0-9_]{0,79}$/.test(reasonCode))
      throw new DomainError(
        'License action reason code is required.',
        'ADMIN_REASON_REQUIRED',
        422,
      );
    return this.repository.license(
      actor.id,
      id,
      blocked,
      this.reason(input),
      reasonCode,
    );
  }
}
