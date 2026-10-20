import {
  Body,
  Controller,
  HttpCode,
  Inject,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import {
  ApiAcceptedResponse,
  ApiBearerAuth,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import type { Request } from 'express';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { PhoneOtpResponseDto } from '../dto/auth/phone-otp.dto';
import {
  RequestReauthOtpDto,
  VerifyReauthDto,
  ReauthResponseDto,
} from '../dto/auth/reauth.dto';
import { REAUTH_SERVICE } from '../interfaces/services/reauth-service.interface';
import type { IReauthService } from '../interfaces/services/reauth-service.interface';

@ApiTags('Auth')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Throttle({ default: { limit: 30, ttl: 60_000 } })
@Controller('auth/reauth')
export class ReauthController {
  constructor(
    @Inject(REAUTH_SERVICE) private readonly service: IReauthService,
  ) {}
  @Post('otp')
  @HttpCode(202)
  @ApiAcceptedResponse({ type: PhoneOtpResponseDto })
  requestOtp(
    @CurrentActor() actor: AuthPrincipal,
    @Body() _input: RequestReauthOtpDto,
    @Req() request: Request,
  ) {
    return this.service.requestOtp(actor, request.ip ?? null);
  }
  @Post('verify')
  @HttpCode(200)
  @ApiOkResponse({ type: ReauthResponseDto })
  verify(@CurrentActor() actor: AuthPrincipal, @Body() input: VerifyReauthDto) {
    return this.service.verify(actor, input.code);
  }
}
