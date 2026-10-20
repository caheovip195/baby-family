import { AUTH_ACCESS_REPOSITORY } from '../interfaces/repositories/auth-access-repository.interface';
import type { IAuthAccessRepository } from '../interfaces/repositories/auth-access-repository.interface';
import { createPublicKey, randomUUID } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { importSPKI, jwtVerify } from 'jose';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError } from '../common/errors/domain.error';
import { ACCOUNT_DELETION_POLICY as POLICY } from '../config/account-deletion-policy';
import type { RequestAccountDeletionDto } from '../dto/account/account-deletion.dto';
import { ACCOUNT_DELETION_REPOSITORY } from '../interfaces/repositories/account-deletion-repository.interface';
import type { IAccountDeletionRepository } from '../interfaces/repositories/account-deletion-repository.interface';
import type { IAccountDeletionService } from '../interfaces/services/account-deletion-service.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../interfaces/services/object-storage-service.interface';
import type { IObjectStorageService } from '../interfaces/services/object-storage-service.interface';
import type {
  AccountDeletionRequest,
  AccountDeletionStep,
} from '../models/account-deletion.model';

@Injectable()
export class AccountDeletionService implements IAccountDeletionService {
  constructor(
    @Inject(ACCOUNT_DELETION_REPOSITORY)
    private readonly repository: IAccountDeletionRepository,
    @Inject(OBJECT_STORAGE_SERVICE)
    private readonly storage: IObjectStorageService,
    private readonly config: ConfigService,
    @Inject(AUTH_ACCESS_REPOSITORY)
    private readonly access: IAuthAccessRepository,
  ) {}

  async preview(actor: AuthPrincipal) {
    const scope = await this.repository.preview(actor.userId);
    return {
      policyVersion: POLICY.version,
      graceDays: POLICY.graceMs / 86_400_000,
      familyId: scope.familyId,
      familyChoices: scope.familyId
        ? scope.otherParentCount > 0
          ? ['PARTNER_CONTINUES']
          : ['DELETE_FAMILY']
        : ['NONE'],
      sharedContentChoices: ['KEEP_ANONYMIZED', 'DELETE'],
      removed: [
        'privateJournal',
        'moods',
        'sentRequests',
        'privateDrafts',
        'sessions',
        'personalIdentifiers',
      ],
      retained: [
        'anonymizedHeartsForFamilyTree',
        'minimalLegalAndBillingRecords',
        'otherUsersContent',
      ],
      familyAfterDeletion: scope.familyId
        ? scope.otherParentCount > 0
          ? 'PARTNER_LEFT'
          : 'DELETED'
        : null,
      subscriptionNotice:
        'Account deletion does not cancel Store subscriptions. Cancel in the Store settings.',
      isPayer: scope.isPayer,
      backupRetentionDays: 35,
    };
  }

  async request(actor: AuthPrincipal, input: RequestAccountDeletionDto) {
    const reauth = await this.verifyReauth(input.reauthToken);
    if (
      reauth.userId !== actor.userId ||
      reauth.sessionId !== actor.sessionId ||
      reauth.tokenVersion !== actor.tokenVersion
    )
      throw new DomainError(
        'Reauthentication does not match the current session.',
        'REAUTH_REQUIRED',
        401,
      );
    const now = new Date();
    return this.project(
      await this.repository.request({
        id: randomUUID(),
        ...actor,
        familyChoice: input.familyChoice,
        sharedContentChoice: input.sharedContentChoice,
        now,
        executeAfter: new Date(now.getTime() + POLICY.graceMs),
        policyVersion: POLICY.version,
      }),
    );
  }

  async cancel(reauthToken: string) {
    const reauth = await this.verifyReauth(reauthToken);
    const session = await this.access.findUserSessionState(
      reauth.sessionId,
      reauth.userId,
      new Date(),
    );
    if (!session || session.tokenVersion !== reauth.tokenVersion)
      throw new DomainError(
        'Fresh reauthentication is required.',
        'REAUTH_REQUIRED',
        401,
      );
    return this.project(
      await this.repository.cancel(
        reauth.userId,
        reauth.tokenVersion,
        new Date(),
      ),
    );
  }

  async executeDue(
    now: Date,
    context: JobContext,
  ): Promise<Record<string, number>> {
    let completed = 0;
    for (let row of await this.repository.findDue(now, POLICY.batchSize)) {
      context.signal.throwIfAborted();
      try {
        // TODO Apple refresh-token revoke: no Apple identity integration/token vault exists.
        row = await this.repository.completeStep(
          row.id,
          'APPLE_REVOKE',
          now,
          context.lease,
          'NOT_INTEGRATED',
        );
        const steps: AccountDeletionStep[] = [
          'PRIVATE_DATA',
          'CIRCLE',
          'SHARED_CONTENT',
          'FAMILY_DATA',
        ];
        for (const step of steps) {
          context.signal.throwIfAborted();
          do {
            context.signal.throwIfAborted();
            row = await this.repository.executeDatabaseStep(
              row.id,
              step,
              now,
              context.lease,
            );
          } while (!row.hasStep(step));
        }
        if (!row.hasStep('OBJECTS')) {
          // Object erasure is idempotent. Checkpoints are fenced; retries can safely erase again.
          const objects = await this.repository.findPurgeObjects(
            row.id,
            POLICY.batchSize,
          );
          for (const object of objects) {
            context.signal.throwIfAborted();
            const bucket =
              object.bucket === 'exports'
                ? 'exports'
                : this.storage.bucketOf(object.bucket);
            if (!bucket)
              throw new DomainError(
                'Storage bucket is unavailable.',
                'DELETION_STORAGE_UNAVAILABLE',
                503,
              );
            if (!this.storage.isConfigured())
              throw new DomainError(
                'Storage is unavailable.',
                'DELETION_STORAGE_UNAVAILABLE',
                503,
              );
            await this.storage.eraseObjectVersions({ bucket, key: object.key });
          }
          await this.repository.markObjectsPurged(
            row.id,
            objects,
            now,
            context.lease,
          );
          if ((await this.repository.findPurgeObjects(row.id, 1)).length)
            continue;
          if (row.familyChoice === 'DELETE_FAMILY' && row.familyId) {
            if (!this.storage.isConfigured())
              throw new DomainError(
                'Storage is unavailable.',
                'DELETION_STORAGE_UNAVAILABLE',
                503,
              );
            for (const bucket of ['media', 'userMedia'] as const) {
              for (const key of await this.storage.listKeys(
                bucket,
                `fam/${row.familyId}/`,
              )) {
                context.signal.throwIfAborted();
                await this.storage.eraseObjectVersions({ bucket, key });
              }
            }
          }
          if (!this.storage.isConfigured())
            throw new DomainError(
              'Storage is unavailable.',
              'DELETION_STORAGE_UNAVAILABLE',
              503,
            );
          for (const key of await this.storage.listKeys(
            'exports',
            `user/${row.userId}/exports/`,
          )) {
            context.signal.throwIfAborted();
            await this.storage.eraseObjectVersions({ bucket: 'exports', key });
          }
          row = await this.repository.completeStep(
            row.id,
            'OBJECTS',
            now,
            context.lease,
          );
        }
        for (const step of ['MEMBERSHIP', 'IDENTITY'] as const)
          row = await this.repository.executeDatabaseStep(
            row.id,
            step,
            now,
            context.lease,
          );
        await this.repository.complete(row.id, now, context.lease);
        completed++;
      } catch (error) {
        await this.repository.fail(
          row.id,
          error instanceof DomainError
            ? error.code
            : 'DELETION_EXECUTION_FAILED',
          context.lease,
        );
        throw error;
      }
    }
    return { completed };
  }

  private project(row: AccountDeletionRequest) {
    return {
      id: row.id,
      status: row.status,
      familyChoice: row.familyChoice,
      sharedContentChoice: row.sharedContentChoice,
      requestedAt: row.requestedAt.toISOString(),
      executeAfter: row.executeAfter.toISOString(),
      cancelledAt: row.cancelledAt?.toISOString() ?? null,
      completedAt: row.completedAt?.toISOString() ?? null,
    };
  }

  /** Only purpose-bound proof from the reauthentication issuer is accepted. */
  private async verifyReauth(token: string): Promise<AuthPrincipal> {
    let pem = this.config.get<string>('AUTH_JWT_PUBLIC_KEY');
    const privatePem = this.config.get<string>('AUTH_JWT_PRIVATE_KEY');
    if (!pem && privatePem)
      pem = createPublicKey(privatePem.replace(/\\n/g, '\n'))
        .export({ type: 'spki', format: 'pem' })
        .toString();
    if (!pem)
      throw new DomainError(
        'Reauthentication is not configured.',
        'REAUTH_UNAVAILABLE',
        503,
      );
    try {
      const key = await importSPKI(pem.replace(/\\n/g, '\n'), 'ES256');
      const { payload } = await jwtVerify(token, key, {
        algorithms: ['ES256'],
        typ: 'reauth+jwt',
        issuer: this.config.get<string>('AUTH_JWT_ISSUER'),
        audience: this.config.get<string>('AUTH_JWT_AUDIENCE'),
        requiredClaims: ['sub', 'sid', 'ver', 'iat', 'exp'],
        maxTokenAge: POLICY.reauthMaxAgeSeconds,
        clockTolerance: 0,
      });
      const uuid =
        /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/iu;
      if (
        payload.scope !== 'reauth' ||
        !payload.sub ||
        !uuid.test(payload.sub) ||
        typeof payload.sid !== 'string' ||
        !uuid.test(payload.sid) ||
        !Number.isSafeInteger(payload.ver) ||
        (payload.ver as number) < 1 ||
        !Number.isInteger(payload.iat) ||
        !Number.isInteger(payload.exp) ||
        payload.exp! <= payload.iat! ||
        payload.exp! - payload.iat! > POLICY.reauthMaxAgeSeconds
      )
        throw new Error('Invalid reauth claims');
      return {
        userId: payload.sub,
        sessionId: payload.sid,
        tokenVersion: payload.ver as number,
      };
    } catch {
      throw new DomainError(
        'Fresh reauthentication is required.',
        'REAUTH_REQUIRED',
        401,
      );
    }
  }
}
