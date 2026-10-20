import { randomInt } from 'node:crypto';
import { Optional, Inject, Injectable } from '@nestjs/common';
import { NO_PROFILE_IMAGES } from './no-profile-images';
import { ConfigService } from '@nestjs/config';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import { CIRCLE_POLICY, parseCirclePayload } from '../config/circle-policy';
import type { Environment } from '../config/environment';
import type {
  CreateCircleInviteDto,
  UpdateCircleMemberDto,
} from '../dto/circle/circle-commands.dto';
import { FAMILY_CIRCLE_REPOSITORY } from '../interfaces/repositories/family-circle-repository.interface';
import type { IFamilyCircleRepository } from '../interfaces/repositories/family-circle-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import { AUTH_TOKEN_SERVICE } from '../interfaces/services/auth-token-service.interface';
import type { IAuthTokenService } from '../interfaces/services/auth-token-service.interface';
import type { IFamilyCircleService } from '../interfaces/services/family-circle-service.interface';
import { PROFILE_IMAGE_SERVICE } from '../interfaces/services/profile-image-service.interface';
import type { IProfileImageService } from '../interfaces/services/profile-image-service.interface';
import type { CircleSubject } from '../models/family-circle-state.model';

@Injectable()
export class FamilyCircleService implements IFamilyCircleService {
  constructor(
    @Inject(FAMILY_CIRCLE_REPOSITORY)
    private readonly repository: IFamilyCircleRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(AUTH_TOKEN_SERVICE) private readonly tokens: IAuthTokenService,
    private readonly config: ConfigService<Environment, true>,
    @Optional()
    @Inject(PROFILE_IMAGE_SERVICE)
    private readonly profileImages: IProfileImageService = NO_PROFILE_IMAGES,
  ) {}
  async createInvite(
    actor: AuthPrincipal,
    fid: string,
    input: CreateCircleInviteDto,
  ) {
    await this.access.requireParent(actor, fid, 'write');
    const payload = parseCirclePayload({
      version: 1,
      relation: input.relation,
      displayName: input.displayName,
      allowDownload:
        input.allowDownload ?? input.grants.some((g) => g.allowDownload),
      grants: input.grants.map((g) => ({
        ...g,
        allowDownload: input.allowDownload ?? g.allowDownload,
      })),
      message: input.message?.trim() || null,
    });
    return this.issue(async (secrets) =>
      this.repository.createInvite(
        actor.userId,
        fid,
        payload,
        input.requireFinalApproval ?? true,
        secrets,
      ),
    );
  }
  async listInvites(actor: AuthPrincipal, fid: string) {
    await this.access.requireParent(actor, fid, 'read');
    return this.repository.listInvites(fid);
  }
  async changeInvite(actor: AuthPrincipal, id: string, renew: boolean) {
    const invite = await this.repository.findInvite(id);
    if (!invite) throw new NotFoundError('Invite was not found.');
    const family = await this.access.requireParent(
      actor,
      invite.familyId,
      'write',
    );
    if (family.status === 'DELETION_SCHEDULED')
      throw new DomainError(
        'Family deletion is scheduled.',
        'FAMILY_DELETION_SCHEDULED',
        403,
      );
    if (renew)
      return this.issue((secrets) =>
        this.repository.changeInvite(actor.userId, id, secrets),
      );
    await this.repository.changeInvite(actor.userId, id, null);
    return { status: 'REVOKED' };
  }
  async listMembers(actor: AuthPrincipal, fid: string) {
    await this.access.requireParent(actor, fid, 'read');
    const members = await this.repository.listMembers(fid);
    return Promise.all(
      members.map(async (member) => ({
        ...member,
        ...(await this.userAvatar(member.userId)),
      })),
    );
  }
  async updateMember(
    actor: AuthPrincipal,
    id: string,
    input: UpdateCircleMemberDto | 'PAUSED' | 'ACTIVE' | 'REMOVED',
  ) {
    const member = await this.repository.findMember(id);
    if (!member) throw new NotFoundError('Member was not found.');
    const family = await this.access.requireParent(
      actor,
      member.familyId,
      'write',
    );
    if (family.status === 'DELETION_SCHEDULED')
      throw new DomainError(
        'Family deletion is scheduled.',
        'FAMILY_DELETION_SCHEDULED',
        403,
      );
    if (typeof input !== 'string') {
      if (
        (input.displayName === undefined &&
          input.allowDownload === undefined &&
          input.grants === undefined) ||
        (input.displayName !== undefined && !input.displayName.trim())
      )
        throw new ValidationError('Provide a nonempty member update.');
      if (input.grants?.length)
        parseCirclePayload({
          version: 1,
          relation: member.relation,
          displayName: input.displayName ?? member.displayName,
          allowDownload: input.allowDownload ?? member.allowDownload,
          grants: input.grants,
          message: null,
        });
    }
    await this.repository.updateMember(actor.userId, id, input);
  }
  leave(actor: AuthPrincipal, fid: string) {
    return this.repository.leave(actor.userId, fid);
  }
  async overview(actor: AuthPrincipal, fid: string) {
    await this.access.requireParent(actor, fid, 'read');
    const overview = await this.repository.overview(fid);
    const [parents, children] = await Promise.all([
      Promise.all(
        overview.parents.map(async (parent) => ({
          ...parent,
          ...(await this.userAvatar(parent.userId)),
        })),
      ),
      this.subjectImages(actor, fid, overview.children),
    ]);
    return { ...overview, parents, children };
  }
  async myCircles(actor: AuthPrincipal) {
    // Repository returns only the actor's currently granted subjects; paused or
    // awaiting-approval memberships have no children to sign.
    const circles = await this.repository.myCircles(actor.userId);
    return Promise.all(
      circles.map(async (circle) => ({
        ...circle,
        children: await this.subjectImages(
          actor,
          circle.familyId,
          circle.children,
        ),
      })),
    );
  }
  private async userAvatar(userId: string) {
    const image = await this.profileImages.userAvatar(userId);
    return {
      avatarUrl: image.avatarUrl,
      avatarUrlExpiresAt: image.avatarUrlExpiresAt?.toISOString() ?? null,
    };
  }
  private subjectImages(
    actor: AuthPrincipal,
    familyId: string,
    subjects: CircleSubject[],
  ) {
    return Promise.all(
      subjects.map(async (subject) => {
        const images =
          subject.kind === 'CHILD'
            ? await this.profileImages.childImages(actor, familyId, subject.id)
            : null;
        return {
          ...subject,
          avatarUrl: images?.avatarUrl ?? null,
          avatarUrlExpiresAt: images?.avatarUrlExpiresAt?.toISOString() ?? null,
          coverUrl: images?.coverUrl ?? null,
          coverUrlExpiresAt: images?.coverUrlExpiresAt?.toISOString() ?? null,
        };
      }),
    );
  }
  private async issue(
    write: (secrets: {
      tokenHash: Buffer;
      codeHash: Buffer;
      expiresAt: Date;
    }) => Promise<{ id: string; expiresAt: Date }>,
  ) {
    const alphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
    for (let attempt = 0; attempt < 3; attempt++) {
      const token = this.tokens.newInviteToken();
      const code = Array.from(
        { length: 8 },
        () => alphabet[randomInt(alphabet.length)],
      ).join('');
      try {
        const invite = await write({
          tokenHash: token.hash,
          codeHash: this.tokens.keyedHash('invite-code', code),
          expiresAt: new Date(Date.now() + CIRCLE_POLICY.inviteTtlMs),
        });
        const url = `${this.config.get('INVITE_LINK_BASE_URL', { infer: true })}${token.value}`;
        return {
          inviteId: invite.id,
          code,
          url,
          qrPayload: url,
          expiresAt: invite.expiresAt.toISOString(),
        };
      } catch (error) {
        if (
          attempt < 2 &&
          typeof error === 'object' &&
          error !== null &&
          'code' in error &&
          error.code === 'P2002'
        )
          continue;
        throw error;
      }
    }
    throw new Error('Could not allocate Circle invite.');
  }
}
