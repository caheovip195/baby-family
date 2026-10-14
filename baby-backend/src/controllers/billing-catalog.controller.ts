import { Controller, Get, Inject, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import { BillingCatalogResponseDto } from '../dto/billing/billing-catalog-response.dto';
import { BILLING_CATALOG_SERVICE } from '../interfaces/services/billing-catalog-service.interface';
import type { IBillingCatalogService } from '../interfaces/services/billing-catalog-service.interface';

@ApiTags('Billing catalog')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('billing/plans')
export class BillingCatalogController {
  constructor(
    @Inject(BILLING_CATALOG_SERVICE)
    private readonly service: IBillingCatalogService,
  ) {}

  @Get()
  @ApiOkResponse({ type: BillingCatalogResponseDto })
  list(
    @CurrentActor() actor: AuthPrincipal,
  ): Promise<BillingCatalogResponseDto> {
    return this.service.list(actor);
  }
}
