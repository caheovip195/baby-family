import {
  Body,
  Controller,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  AcceptInviteDto,
  InviteReferenceDto,
} from '../dto/onboarding/onboarding-commands.dto';
import {
  InviteDecisionResponseDto,
  InvitePreviewResponseDto,
} from '../dto/onboarding/onboarding-response.dto';
import { ONBOARDING_SERVICE } from '../interfaces/services/onboarding-service.interface';
import type { IOnboardingService } from '../interfaces/services/onboarding-service.interface';

/** Spec §21.3: resolve/accept 10/min/IP so 8-character codes cannot be guessed (BR-041). */
const RESOLVE_THROTTLE = { default: { limit: 10, ttl: 60_000 } };

/** INV-01…INV-05 (spec §11.3). Resolve is public so a link opens before sign-in. */
@ApiTags('Invites')
@Controller('invites')
export class InviteController {
  constructor(
    @Inject(ONBOARDING_SERVICE) private readonly service: IOnboardingService,
  ) {}

  @Post('resolve')
  @HttpCode(200)
  @Throttle(RESOLVE_THROTTLE)
  @ApiOkResponse({ type: InvitePreviewResponseDto })
  resolve(@Body() input: InviteReferenceDto) {
    return this.service.resolveInvite(input);
  }

  @Post('accept')
  @HttpCode(200)
  @Throttle(RESOLVE_THROTTLE)
  @ApiBearerAuth()
  @UseGuards(AccessTokenGuard)
  @ApiOkResponse({ type: InviteDecisionResponseDto })
  accept(@CurrentActor() actor: AuthPrincipal, @Body() input: AcceptInviteDto) {
    return this.service.acceptInvite(actor, input);
  }

  @Post('decline')
  @HttpCode(200)
  @ApiBearerAuth()
  @UseGuards(AccessTokenGuard)
  @ApiOkResponse({ type: InviteDecisionResponseDto })
  decline(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: InviteReferenceDto,
  ) {
    return this.service.declineInvite(actor, input);
  }

  @Post(':inviteId/approve')
  @HttpCode(200)
  @ApiBearerAuth()
  @UseGuards(AccessTokenGuard)
  @ApiOkResponse({ type: InviteDecisionResponseDto })
  approve(
    @CurrentActor() actor: AuthPrincipal,
    @Param('inviteId', new ParseUUIDPipe()) inviteId: string,
  ) {
    return this.service.decideInvite(actor, inviteId, true);
  }

  @Post(':inviteId/reject')
  @HttpCode(200)
  @ApiBearerAuth()
  @UseGuards(AccessTokenGuard)
  @ApiOkResponse({ type: InviteDecisionResponseDto })
  reject(
    @CurrentActor() actor: AuthPrincipal,
    @Param('inviteId', new ParseUUIDPipe()) inviteId: string,
  ) {
    return this.service.decideInvite(actor, inviteId, false);
  }
}
