import {
  Body,
  Controller,
  Headers,
  HttpCode,
  Inject,
  Post,
} from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { AppStoreNotificationDto } from '../dto/billing/iap-billing.dto';
import { IAP_BILLING_SERVICE } from '../interfaces/services/iap-billing-service.interface';
import type { IIapBillingService } from '../interfaces/services/iap-billing-service.interface';

@ApiTags('Store webhooks')
@Controller('webhooks')
export class IapWebhookController {
  constructor(
    @Inject(IAP_BILLING_SERVICE) private readonly service: IIapBillingService,
  ) {}
  @Post('app-store')
  @HttpCode(200)
  apple(@Body() input: AppStoreNotificationDto) {
    return this.service.receiveAppStore(input.signedPayload);
  }
  @Post('play')
  @HttpCode(200)
  play(
    @Headers('authorization') authorization: string | undefined,
    @Body() body: unknown,
  ) {
    return this.service.receivePlay(authorization, body);
  }
}
