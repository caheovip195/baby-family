import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { NotFoundError, ValidationError } from '../common/errors/domain.error';
import type {
  MemoryPromptResponseDto,
  MemoryPromptSubjectDto,
} from '../dto/memory-library/memory-prompt.dto';
import { MEMORY_PROMPT_REPOSITORY } from '../interfaces/repositories/memory-prompt-repository.interface';
import type { IMemoryPromptRepository } from '../interfaces/repositories/memory-prompt-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IMemoryPromptService } from '../interfaces/services/memory-prompt-service.interface';

/** Single versioned policy; the existing uq_prompt_day permits one active delivery. */
export const MEMORY_PROMPT_POLICY = Object.freeze({
  version: 1,
  repeatAfterDays: 30,
  maxItems: 1,
});
@Injectable()
export class MemoryPromptService implements IMemoryPromptService {
  constructor(
    @Inject(MEMORY_PROMPT_REPOSITORY)
    private readonly repository: IMemoryPromptRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
  ) {}
  async list(
    actor: AuthPrincipal,
    familyId: string,
    input: MemoryPromptSubjectDto,
  ): Promise<MemoryPromptResponseDto> {
    this.validate(input);
    const family = await this.access.requireParent(actor, familyId, 'read');
    if (!(await this.repository.isEnabled(actor.userId))) return { items: [] };
    const subject = await this.repository.findSubject(familyId, input);
    if (!subject) {
      if (input.childId || input.pregnancyId)
        throw new NotFoundError('Prompt subject was not found.');
      return { items: [] };
    }
    const localDate = this.localDate(family.timezone);
    const child = 'birthDate' in subject ? subject : null;
    const pregnancy = 'dueDate' in subject ? subject : null;
    const row = await this.repository.deliver({
      familyId,
      userId: actor.userId,
      localDate,
      childId: child?.id ?? null,
      pregnancyId: pregnancy?.id ?? null,
      ageDays: child
        ? Math.floor(
            (localDate.getTime() - child.birthDate.getTime()) / 86400000,
          )
        : null,
      pregnancyWeek: pregnancy?.dueDate
        ? Math.floor(
            (280 -
              (pregnancy.dueDate.getTime() - localDate.getTime()) / 86400000) /
              7,
          )
        : null,
      recentSince: new Date(
        localDate.getTime() - MEMORY_PROMPT_POLICY.repeatAfterDays * 86400000,
      ),
    });
    return {
      items: row
        ? [
            {
              code: row.template.code,
              deliveryId: row.delivery.id.toString(),
              targetKind: row.template.targetKind,
              textI18n: row.template.textI18n,
              childId: row.delivery.childId,
              pregnancyId: row.delivery.pregnancyId,
            },
          ]
        : [],
    };
  }
  async dismiss(
    actor: AuthPrincipal,
    code: string,
    input: MemoryPromptSubjectDto,
  ): Promise<{ dismissed: true }> {
    this.validate(input);
    if (!input.childId && !input.pregnancyId)
      throw new ValidationError('A childId or pregnancyId is required.');
    const subject = await this.repository.findSubject(null, input);
    if (!subject) throw new NotFoundError('Prompt subject was not found.');
    const family = await this.access.requireParent(
      actor,
      subject.familyId,
      'read',
    );
    const found = await this.repository.dismiss({
      familyId: subject.familyId,
      userId: actor.userId,
      code,
      childId: 'birthDate' in subject ? subject.id : null,
      pregnancyId: 'dueDate' in subject ? subject.id : null,
      localDate: this.localDate(family.timezone),
    });
    if (!found) throw new NotFoundError('Delivered prompt was not found.');
    return { dismissed: true };
  }
  private validate(input: MemoryPromptSubjectDto): void {
    if (input.childId && input.pregnancyId)
      throw new ValidationError('Select either childId or pregnancyId.');
  }
  private localDate(timezone: string): Date {
    const parts = new Intl.DateTimeFormat('en-CA', {
      timeZone: timezone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    }).formatToParts(new Date());
    const value = (type: string) =>
      parts.find((part) => part.type === type)!.value;
    return new Date(
      `${value('year')}-${value('month')}-${value('day')}T00:00:00.000Z`,
    );
  }
}
