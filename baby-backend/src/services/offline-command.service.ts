import {
  createCipheriv,
  createDecipheriv,
  createHash,
  randomBytes,
} from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DomainError } from '../common/errors/domain.error';
import { CoupleRequestResendBlockedError } from '../models/couple-request-resend-blocked.model';
import { OFFLINE_COMMAND_REPOSITORY } from '../interfaces/repositories/offline-command-repository.interface';
import type { IOfflineCommandRepository } from '../interfaces/repositories/offline-command-repository.interface';
import { MEMORY_CONTENT_SERVICE } from '../interfaces/services/memory-content-service.interface';
import type { IMemoryContentService } from '../interfaces/services/memory-content-service.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import type {
  IOfflineCommandService,
  OfflineCommand,
} from '../interfaces/services/offline-command-service.interface';

@Injectable()
export class OfflineCommandService implements IOfflineCommandService {
  constructor(
    @Inject(OFFLINE_COMMAND_REPOSITORY)
    private readonly repository: IOfflineCommandRepository,
    @Inject(MEMORY_CONTENT_SERVICE)
    private readonly memories: IMemoryContentService,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    private readonly config: ConfigService,
  ) {}
  async execute<T>(
    command: OfflineCommand,
    key: string,
    work: () => Promise<T>,
    authorize?: () => Promise<unknown>,
  ): Promise<T> {
    if (command.actor && command.memoryId) {
      const memory = await this.memories.getById(
        command.actor,
        command.memoryId,
      );
      if (!this.access.requireContentAccess)
        throw new DomainError(
          'Content authorization is unavailable.',
          'SERVICE_UNAVAILABLE',
          503,
        );
      if (command.parentOnly)
        await this.access.requireParent(
          command.actor,
          memory.familyId,
          'write',
        );
      await this.access.requireContentAccess(
        command.actor,
        memory.familyId,
        'write',
      );
    } else if (command.actor && command.familyId) {
      await this.access.requireParent(command.actor, command.familyId, 'write');
    }
    await authorize?.();
    const encryptionKey = this.encryptionKey();
    const requestHash = createHash('sha256')
      .update(
        canonical({
          body: command.body ?? null,
          resourceId:
            command.resourceId ?? command.memoryId ?? command.familyId ?? null,
        }),
      )
      .digest();
    const claim = await this.repository.claim({
      actorUserId: command.actor?.userId,
      familyId: command.familyId,
      scopeKey: command.actor?.userId ?? 'legacy-public-notes',
      operation: `offline.${command.operation}`,
      key,
      requestHash,
    });
    if (!Buffer.from(claim.record.requestHash).equals(requestHash))
      throw new DomainError(
        'Idempotency-Key was used for a different request.',
        'IDEMPOTENCY_KEY_REUSED',
        409,
      );
    if (!claim.acquired) {
      if (!claim.record.response)
        throw new DomainError(
          'The command is pending or requires reconciliation.',
          'IDEMPOTENCY_COMMAND_PENDING',
          409,
        );
      const encrypted = Buffer.from(claim.record.response, 'base64');
      const decipher = createDecipheriv(
        'aes-256-gcm',
        encryptionKey,
        encrypted.subarray(0, 12),
      );
      decipher.setAuthTag(encrypted.subarray(12, 28));
      decipher.setAAD(Buffer.from(claim.record.id));
      const snapshot = JSON.parse(
        Buffer.concat([
          decipher.update(encrypted.subarray(28)),
          decipher.final(),
        ]).toString('utf8'),
      ) as {
        value?: T;
        error?: {
          message: string;
          code: string;
          statusCode: number;
          retryAfter?: string;
        };
      };
      if (
        snapshot.error?.code === 'REQUEST_RESEND_BLOCKED' &&
        snapshot.error.retryAfter
      )
        throw new CoupleRequestResendBlockedError(snapshot.error.retryAfter);
      if (snapshot.error)
        throw new DomainError(
          snapshot.error.message,
          snapshot.error.code,
          snapshot.error.statusCode,
        );
      return snapshot.value as T;
    }
    let value: T;
    try {
      value = await work();
    } catch (error) {
      if (
        error instanceof DomainError &&
        error.statusCode >= 400 &&
        error.statusCode < 500
      ) {
        await this.remember(claim.record.id, encryptionKey, {
          error: {
            message: error.message,
            code: error.code,
            statusCode: error.statusCode,
            ...(error instanceof CoupleRequestResendBlockedError
              ? { retryAfter: error.retryAfter }
              : {}),
          },
        });
      } else {
        await this.repository.reject(claim.record.id);
      }
      throw error;
    }
    await this.remember(claim.record.id, encryptionKey, { value });
    return value;
  }
  private async remember(
    id: string,
    encryptionKey: Buffer,
    snapshot: unknown,
  ): Promise<void> {
    const iv = randomBytes(12);
    const cipher = createCipheriv('aes-256-gcm', encryptionKey, iv);
    cipher.setAAD(Buffer.from(id));
    const ciphertext = Buffer.concat([
      cipher.update(JSON.stringify(snapshot), 'utf8'),
      cipher.final(),
    ]);
    await this.repository.complete(
      id,
      Buffer.concat([iv, cipher.getAuthTag(), ciphertext]).toString('base64'),
    );
  }
  private encryptionKey(): Buffer {
    const secret =
      this.config.get<string>('AUTH_SECRET_PEPPER') ||
      this.config.get<string>('COUPLE_CHECKIN_ENCRYPTION_KEY');
    if (!secret)
      throw new DomainError(
        'Idempotency encryption is not configured.',
        'SERVICE_UNAVAILABLE',
        503,
      );
    return createHash('sha256')
      .update(`offline-response:v1:${secret}`)
      .digest();
  }
}
function canonical(value: unknown): string {
  if (Array.isArray(value)) return `[${value.map(canonical).join(',')}]`;
  if (value && typeof value === 'object')
    return `{${Object.entries(value)
      .filter(([, v]) => v !== undefined)
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([k, v]) => `${JSON.stringify(k)}:${canonical(v)}`)
      .join(',')}}`;
  return JSON.stringify(value) ?? 'null';
}
