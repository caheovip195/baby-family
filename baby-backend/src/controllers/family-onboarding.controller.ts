import {
  Body,
  Controller,
  Get,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  CreateFamilyDto,
  CreatePartnerInviteDto,
} from '../dto/onboarding/onboarding-commands.dto';
import {
  CreatedPartnerInviteResponseDto,
  FamilyBootstrapResponseDto,
  PartnerInviteStatusResponseDto,
} from '../dto/onboarding/onboarding-response.dto';
import { ONBOARDING_SERVICE } from '../interfaces/services/onboarding-service.interface';
import type { IOnboardingService } from '../interfaces/services/onboarding-service.interface';

/** ONB-06, ONB-07, ONB-WAIT and SPL-01 bootstrap (spec §11.3–11.4). */
@ApiTags('Family onboarding')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families')
export class FamilyOnboardingController {
  constructor(
    @Inject(ONBOARDING_SERVICE) private readonly service: IOnboardingService,
  ) {}

  @Post()
  @ApiCreatedResponse({ type: FamilyBootstrapResponseDto })
  create(@CurrentActor() actor: AuthPrincipal, @Body() input: CreateFamilyDto) {
    return this.service.createFamily(actor, input);
  }

  @Post(':familyId/cancel')
  @HttpCode(204)
  @ApiNoContentResponse()
  cancel(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
  ) {
    return this.service.cancelFamily(actor, familyId);
  }

  @Post(':familyId/invites/partner')
  @ApiCreatedResponse({ type: CreatedPartnerInviteResponseDto })
  createPartnerInvite(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Body() input: CreatePartnerInviteDto,
  ) {
    return this.service.createPartnerInvite(actor, familyId, input);
  }

  @Get(':familyId/invites/partner')
  @ApiOkResponse({ type: PartnerInviteStatusResponseDto })
  getPartnerInvite(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
  ) {
    return this.service.getPartnerInvite(actor, familyId);
  }

  @Get(':familyId/bootstrap')
  @ApiOkResponse({ type: FamilyBootstrapResponseDto })
  bootstrap(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
  ) {
    return this.service.bootstrap(actor, familyId);
  }
}
