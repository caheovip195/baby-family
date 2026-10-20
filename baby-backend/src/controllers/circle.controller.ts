import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  CreateCircleInviteDto,
  UpdateCircleMemberDto,
} from '../dto/circle/circle-commands.dto';
import { FAMILY_CIRCLE_SERVICE } from '../interfaces/services/family-circle-service.interface';
import type { IFamilyCircleService } from '../interfaces/services/family-circle-service.interface';
@ApiTags('Family Circle')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller()
export class CircleController {
  constructor(
    @Inject(FAMILY_CIRCLE_SERVICE)
    private readonly service: IFamilyCircleService,
  ) {}
  @Post('families/:fid/invites/circle')
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', ParseUUIDPipe) fid: string,
    @Body() input: CreateCircleInviteDto,
  ) {
    return this.service.createInvite(actor, fid, input);
  }
  @Get('families/:fid/invites/circle')
  async invites(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', ParseUUIDPipe) fid: string,
  ) {
    return {
      items: (await this.service.listInvites(actor, fid)).map((i) => ({
        inviteId: i.id,
        type: 'CIRCLE',
        status: i.status,
        ...i.payload,
        requireFinalApproval: i.requireFinalApproval,
        createdAt: i.createdAt.toISOString(),
        expiresAt: i.expiresAt.toISOString(),
      })),
    };
  }
  @Post('invites/:id/revoke')
  @HttpCode(200)
  revoke(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.changeInvite(actor, id, false);
  }
  @Post('invites/:id/renew')
  @HttpCode(200)
  renew(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.changeInvite(actor, id, true);
  }
  @Get('families/:fid/circle')
  async members(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', ParseUUIDPipe) fid: string,
  ) {
    return {
      members: (await this.service.listMembers(actor, fid)).map((m) => ({
        id: m.id,
        userId: m.userId,
        displayName: m.displayName,
        avatarUrl: m.avatarUrl,
        avatarUrlExpiresAt: m.avatarUrlExpiresAt,
        relation: m.relation,
        status: m.status,
        allowDownload: m.allowDownload,
        grants: m.grants,
        joinedAt: m.joinedAt.toISOString(),
      })),
    };
  }
  @Patch('circle-members/:id')
  @HttpCode(204)
  update(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() input: UpdateCircleMemberDto,
  ) {
    return this.service.updateMember(actor, id, input);
  }
  @Post('circle-members/:id/pause')
  @HttpCode(204)
  pause(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.updateMember(actor, id, 'PAUSED');
  }
  @Post('circle-members/:id/resume')
  @HttpCode(204)
  resume(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.updateMember(actor, id, 'ACTIVE');
  }
  @Delete('circle-members/:id')
  @HttpCode(204)
  remove(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.updateMember(actor, id, 'REMOVED');
  }
  @Post('families/:fid/circle/leave')
  @HttpCode(204)
  leave(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', ParseUUIDPipe) fid: string,
  ) {
    return this.service.leave(actor, fid);
  }
  @Get('families/:fid/overview')
  overview(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', ParseUUIDPipe) fid: string,
  ) {
    return this.service.overview(actor, fid);
  }
  @Get('me/circles')
  async mine(@CurrentActor() actor: AuthPrincipal) {
    return { items: await this.service.myCircles(actor) };
  }
}
