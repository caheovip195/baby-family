import {
  Controller,
  Get,
  Inject,
  Param,
  ParseUUIDPipe,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { FAMILY_PRIVACY_SERVICE } from '../interfaces/services/family-privacy-service.interface';
import type { IFamilyPrivacyService } from '../interfaces/services/family-privacy-service.interface';

@ApiTags('Family privacy')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/privacy-overview')
export class FamilyPrivacyController {
  constructor(
    @Inject(FAMILY_PRIVACY_SERVICE)
    private readonly service: IFamilyPrivacyService,
  ) {}
  @Get()
  @ApiOperation({
    summary:
      'Parent-only privacy metadata; contains no private content or download URLs.',
  })
  get(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
  ) {
    return this.service.get(actor, familyId);
  }
}
