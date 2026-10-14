import {
  Controller,
  Get,
  Inject,
  Param,
  ParseUUIDPipe,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import { FamilyBillingResponseDto } from '../dto/billing/family-billing-response.dto';
import { FAMILY_BILLING_SERVICE } from '../interfaces/services/family-billing-service.interface';
import type { IFamilyBillingService } from '../interfaces/services/family-billing-service.interface';

@ApiTags('Family billing')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/billing')
export class FamilyBillingController {
  constructor(
    @Inject(FAMILY_BILLING_SERVICE)
    private readonly service: IFamilyBillingService,
  ) {}

  @Get()
  @ApiOkResponse({ type: FamilyBillingResponseDto })
  get(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
  ): Promise<FamilyBillingResponseDto> {
    return this.service.get(actor, familyId);
  }
}
