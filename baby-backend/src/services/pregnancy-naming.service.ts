import { createHash, randomUUID } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { PregnancyNameCipher } from '../common/crypto/pregnancy-name-cipher';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import {
  cleanPregnancyName,
  normalizePregnancyName,
  PREGNANCY_NAMING_POLICY,
} from '../config/pregnancy-naming-policy';
import type {
  CreatePregnancyNameDto,
  PregnancyNameItemDto,
  PregnancyNamesDto,
} from '../dto/pregnancy/naming.dto';
import type { CreateMemoryCommand } from '../interfaces/repositories/memory-content-repository.interface';
import { PREGNANCY_NAMING_REPOSITORY } from '../interfaces/repositories/pregnancy-naming-repository.interface';
import type { IPregnancyNamingRepository } from '../interfaces/repositories/pregnancy-naming-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type { IPregnancyNamingService } from '../interfaces/services/pregnancy-naming-service.interface';
import type {
  PregnancyNamingState,
  PregnancyNamingEntry,
} from '../models/pregnancy-naming-state.model';

@Injectable()
export class PregnancyNamingService implements IPregnancyNamingService {
  constructor(
    @Inject(PREGNANCY_NAMING_REPOSITORY)
    private readonly repository: IPregnancyNamingRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    private readonly config: ConfigService,
  ) {}

  async list(
    actor: AuthPrincipal,
    pregnancyId: string,
  ): Promise<PregnancyNamesDto> {
    await this.authorize(actor, pregnancyId, 'read');
    const state = await this.repository.read(pregnancyId, actor.userId);
    return {
      items: state.entries.map((entry) =>
        this.project(state, entry, actor.userId),
      ),
      chosenLimit: state.pregnancy.expectedCount,
    };
  }

  async create(
    actor: AuthPrincipal,
    pregnancyId: string,
    input: CreatePregnancyNameDto,
  ): Promise<PregnancyNameItemDto> {
    await this.authorize(actor, pregnancyId, 'write');
    if (typeof input.name !== 'string')
      throw new ValidationError('Name is required.');
    const name = cleanPregnancyName(input.name);
    if (!name || [...name].length > PREGNANCY_NAMING_POLICY.maxNameLength)
      throw new ValidationError('Name must contain 1–60 characters.');
    if (
      input.meaning !== undefined &&
      (typeof input.meaning !== 'string' ||
        [...input.meaning.trim()].length >
          PREGNANCY_NAMING_POLICY.maxMeaningLength)
    )
      throw new ValidationError('Meaning must contain at most 200 characters.');
    const meaning = input.meaning?.trim() || null;
    const normalized = normalizePregnancyName(name);
    const id = randomUUID();
    const state = await this.repository.mutate(
      pregnancyId,
      actor.userId,
      (current) => {
        this.requireWritable(current);
        const cipher = this.cipher(current);
        // Also check older rows without a blind key. No data backfill in migrations.
        if (
          current.entries.some(
            ({ candidate }) =>
              normalizePregnancyName(
                cipher.decrypt(candidate.nameEnc, 'name'),
              ) === normalized,
          )
        )
          throw new DomainError(
            'This name already exists.',
            'NAME_DUPLICATE',
            409,
          );
        if (current.entries.length >= PREGNANCY_NAMING_POLICY.maxNames)
          throw new DomainError(
            'The pregnancy name list is full.',
            'NAME_LIMIT',
            409,
          );
        return {
          type: 'create',
          id,
          nameEnc: cipher.encrypt(name, 'name'),
          meaningEnc:
            meaning === null ? null : cipher.encrypt(meaning, 'meaning'),
          nameKey: cipher.fingerprint(normalized),
        };
      },
    );
    return this.project(state, this.entry(state, id), actor.userId);
  }

  async like(
    actor: AuthPrincipal,
    nameId: string,
    liked: boolean,
  ): Promise<PregnancyNameItemDto> {
    const pregnancyId = await this.authorizeName(actor, nameId);
    const state = await this.repository.mutate(
      pregnancyId,
      actor.userId,
      (current) => {
        this.requireWritable(current);
        const entry = this.entry(current, nameId);
        // Validate the response ciphertext before committing any mutation.
        this.project(current, entry, actor.userId);
        return entry.likedByUserIds.includes(actor.userId) === liked
          ? { type: 'noop' }
          : { type: 'like', id: nameId, liked };
      },
    );
    return this.project(state, this.entry(state, nameId), actor.userId);
  }

  async choose(
    actor: AuthPrincipal,
    nameId: string,
    chosen: boolean,
  ): Promise<PregnancyNameItemDto> {
    const pregnancyId = await this.authorizeName(actor, nameId);
    const state = await this.repository.mutate(
      pregnancyId,
      actor.userId,
      (current) => {
        this.requireWritable(current);
        const entry = this.entry(current, nameId);
        this.project(current, entry, actor.userId);
        if ((entry.candidate.chosenAt !== null) === chosen)
          return { type: 'noop' };
        const chosenEntries = current.entries.filter(({ candidate }) =>
          candidate.id === nameId ? chosen : candidate.chosenAt !== null,
        );
        if (chosen && chosenEntries.length > current.pregnancy.expectedCount)
          throw new DomainError(
            'Too many chosen names.',
            'NAME_CHOICE_LIMIT',
            409,
          );
        return {
          type: 'choose',
          id: nameId,
          chosen,
          memory: this.memoryCommand(current, actor.userId, chosenEntries),
        };
      },
    );
    return this.project(state, this.entry(state, nameId), actor.userId);
  }

  async remove(actor: AuthPrincipal, nameId: string): Promise<void> {
    const pregnancyId = await this.authorizeName(actor, nameId);
    await this.repository.mutate(pregnancyId, actor.userId, (current) => {
      this.requireWritable(current);
      const entry = this.entry(current, nameId);
      if (entry.candidate.addedBy !== actor.userId)
        throw new DomainError(
          'Only the author can delete this name.',
          'NAME_DELETE_FORBIDDEN',
          403,
        );
      return {
        type: 'remove',
        id: nameId,
        memory:
          entry.candidate.chosenAt === null
            ? null
            : this.memoryCommand(
                current,
                actor.userId,
                current.entries.filter(
                  ({ candidate }) =>
                    candidate.id !== nameId && candidate.chosenAt !== null,
                ),
              ),
      };
    });
  }

  private async authorize(
    actor: AuthPrincipal,
    pregnancyId: string,
    mode: 'read' | 'write',
  ) {
    const pregnancy = await this.repository.findPregnancy(pregnancyId);
    if (!pregnancy) throw new NotFoundError('Pregnancy was not found.');
    await this.access.requireParent(actor, pregnancy.familyId, mode);
  }

  private async authorizeName(
    actor: AuthPrincipal,
    nameId: string,
  ): Promise<string> {
    const pregnancyId = await this.repository.findPregnancyId(nameId);
    if (!pregnancyId) throw new NotFoundError('Pregnancy name was not found.');
    await this.authorize(actor, pregnancyId, 'write');
    return pregnancyId;
  }

  private requireWritable(state: PregnancyNamingState) {
    if (state.pregnancy.status !== 'ACTIVE')
      throw new DomainError(
        'This pregnancy is read-only.',
        'PREGNANCY_READ_ONLY',
        409,
      );
  }

  private entry(state: PregnancyNamingState, id: string): PregnancyNamingEntry {
    const entry = state.entries.find(({ candidate }) => candidate.id === id);
    if (!entry) throw new NotFoundError('Pregnancy name was not found.');
    return entry;
  }

  private cipher(state: PregnancyNamingState): PregnancyNameCipher {
    return new PregnancyNameCipher(
      this.config.get<string>('COUPLE_CHECKIN_ENCRYPTION_KEY'),
      state.coupleSpaceId,
    );
  }

  private project(
    state: PregnancyNamingState,
    entry: PregnancyNamingEntry,
    actorUserId: string,
  ): PregnancyNameItemDto {
    const cipher = this.cipher(state);
    const { candidate, likedByUserIds } = entry;
    return {
      id: candidate.id,
      name: cipher.decrypt(candidate.nameEnc, 'name'),
      meaning:
        candidate.meaningEnc === null
          ? null
          : cipher.decrypt(candidate.meaningEnc, 'meaning'),
      addedByUserId: candidate.addedBy,
      likedByMe: likedByUserIds.includes(actorUserId),
      likedByPartner: likedByUserIds.includes(state.partnerUserId),
      chosen: candidate.chosenAt !== null,
      createdAt: candidate.createdAt.toISOString(),
    };
  }

  private memoryCommand(
    state: PregnancyNamingState,
    actorUserId: string,
    chosen: PregnancyNamingEntry[],
  ): CreateMemoryCommand {
    if (
      state.milestone &&
      (state.milestone.memory.deletedAt !== null ||
        state.milestone.memory.status !== 'PUBLISHED' ||
        state.milestone.memory.visibility === 'PRIVATE')
    )
      throw new DomainError(
        'The name milestone is unavailable.',
        'NAME_MILESTONE_UNAVAILABLE',
        409,
      );
    const cipher = this.cipher(state);
    const body = chosen
      .map(({ candidate }) => cipher.decrypt(candidate.nameEnc, 'name'))
      .join('\n');
    const now = new Date();
    const day = new Intl.DateTimeFormat('en-CA', {
      timeZone: state.timezone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    }).format(now);
    const quotas = state.quotas;
    if (!quotas || typeof quotas !== 'object' || Array.isArray(quotas))
      throw new DomainError(
        'Family memory capabilities are unavailable.',
        'SUBSCRIPTION_REQUIRED',
        402,
      );
    const memoryCount: unknown =
      'memoryCount' in quotas ? quotas.memoryCount : undefined;
    if (
      memoryCount !== undefined &&
      (typeof memoryCount !== 'number' ||
        !Number.isSafeInteger(memoryCount) ||
        memoryCount < 0)
    )
      throw new DomainError(
        'The memory quota is invalid.',
        'SUBSCRIPTION_REQUIRED',
        402,
      );
    return {
      familyId: state.pregnancy.familyId,
      authorUserId: actorUserId,
      idempotencyKey: randomUUID(),
      requestHash: createHash('sha256').update(body).digest(),
      kind: 'MILESTONE',
      title: PREGNANCY_NAMING_POLICY.milestoneTitle,
      body,
      occurredAt: now,
      occurredLocalDate: new Date(`${day}T00:00:00.000Z`),
      visibility: 'PARENTS',
      familyMoment: false,
      pregnancyId: state.pregnancy.id,
      pregnancyWeek: null,
      feeling: null,
      locationLabel: null,
      quoteContext: null,
      commentsEnabled: false,
      children: [],
      assets: [],
      memoryQuota: typeof memoryCount === 'number' ? memoryCount : null,
      idempotencyExpiresAt: new Date(
        now.getTime() + PREGNANCY_NAMING_POLICY.memoryIdempotencyRetentionMs,
      ),
      milestone: {
        templateCode: PREGNANCY_NAMING_POLICY.milestoneTemplateCode,
        occurredOn: day,
      },
    };
  }
}
