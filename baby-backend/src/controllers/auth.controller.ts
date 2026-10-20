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
  ApiNoContentResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import type { Request } from 'express';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  AuthTokensResponseDto,
  RefreshTokenDto,
} from '../dto/auth/auth-tokens.dto';
import {
  PhoneOtpResponseDto,
  RequestPhoneOtpDto,
} from '../dto/auth/phone-otp.dto';
import { VerifyPhoneOtpDto } from '../dto/auth/verify-phone-otp.dto';
import { AUTH_SESSION_SERVICE } from '../interfaces/services/auth-session-service.interface';
import type { IAuthSessionService } from '../interfaces/services/auth-session-service.interface';

/** Spec §21.3: `/auth/*` 30/min/IP; OTP sends are further limited per number/IP in the service. */
const AUTH_THROTTLE = { default: { limit: 30, ttl: 60_000 } };

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(
    @Inject(AUTH_SESSION_SERVICE) private readonly service: IAuthSessionService,
  ) {}

  @Post('phone/otp')
  @HttpCode(202)
  @Throttle(AUTH_THROTTLE)
  @ApiAcceptedResponse({ type: PhoneOtpResponseDto })
  requestOtp(@Body() input: RequestPhoneOtpDto, @Req() request: Request) {
    return this.service.requestPhoneOtp(input, { ip: request.ip ?? null });
  }

  @Post('phone/verify')
  @HttpCode(200)
  @Throttle(AUTH_THROTTLE)
  @ApiOkResponse({ type: AuthTokensResponseDto })
  verifyOtp(@Body() input: VerifyPhoneOtpDto, @Req() request: Request) {
    return this.service.verifyPhoneOtp(input, { ip: request.ip ?? null });
  }

  @Post('refresh')
  @HttpCode(200)
  @Throttle(AUTH_THROTTLE)
  @ApiOkResponse({ type: AuthTokensResponseDto })
  refresh(@Body() input: RefreshTokenDto) {
    return this.service.refresh(input.refreshToken);
  }

  @Post('logout')
  @HttpCode(204)
  @ApiBearerAuth()
  @UseGuards(AccessTokenGuard)
  @ApiNoContentResponse()
  logout(@CurrentActor() actor: AuthPrincipal) {
    return this.service.logout(actor);
  }
}
