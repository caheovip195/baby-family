import {
  Body,
  Controller,
  Get,
  Headers,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  CreateIapIntentDto,
  VerifyIapPurchaseDto,
} from '../dto/billing/iap-billing.dto';
import { IAP_BILLING_SERVICE } from '../interfaces/services/iap-billing-service.interface';
import type { IIapBillingService } from '../interfaces/services/iap-billing-service.interface';

@ApiTags('Family billing')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId')
export class IapBillingController {
  constructor(
    @Inject(IAP_BILLING_SERVICE) private readonly service: IIapBillingService,
  ) {}
  @Post('purchase-intents')
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Body() input: CreateIapIntentDto,
    @Headers('idempotency-key') key: string | undefined,
  ) {
    return this.service.createIntent(actor, familyId, input, key);
  }
  @Post('purchases/verify')
  @HttpCode(200)
  verify(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Body() input: VerifyIapPurchaseDto,
  ) {
    return this.service.verify(actor, familyId, input);
  }
  @Get('billing/upgrade-options')
  upgrades(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
  ) {
    return this.service.upgradeOptions(actor, familyId);
  }
}
