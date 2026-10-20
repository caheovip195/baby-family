import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
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
import { PhoneOtpResponseDto } from '../dto/auth/phone-otp.dto';
import {
  ChangedPhoneResponseDto,
  RequestPhoneChangeOtpDto,
  RevokeOtherSessionsResponseDto,
  SecuritySessionsResponseDto,
  VerifyPhoneChangeDto,
} from '../dto/user/account-security.dto';
import { ACCOUNT_SECURITY_SERVICE } from '../interfaces/services/account-security-service.interface';
import type { IAccountSecurityService } from '../interfaces/services/account-security-service.interface';
@ApiTags('Account security')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Throttle({ default: { limit: 30, ttl: 60000 } })
@Controller('me')
export class AccountSecurityController {
  constructor(
    @Inject(ACCOUNT_SECURITY_SERVICE)
    private readonly service: IAccountSecurityService,
  ) {}
  @Get('sessions')
  @ApiOkResponse({ type: SecuritySessionsResponseDto })
  list(@CurrentActor() actor: AuthPrincipal) {
    return this.service.listSessions(actor);
  }
  @Delete('sessions/:id')
  @HttpCode(204)
  @ApiNoContentResponse()
  revoke(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.revokeSession(actor, id);
  }
  @Post('sessions/revoke-others')
  @HttpCode(200)
  @ApiOkResponse({ type: RevokeOtherSessionsResponseDto })
  revokeOthers(@CurrentActor() actor: AuthPrincipal) {
    return this.service.revokeOthers(actor);
  }
  @Post('phone/otp')
  @HttpCode(202)
  @ApiAcceptedResponse({ type: PhoneOtpResponseDto })
  requestPhoneOtp(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: RequestPhoneChangeOtpDto,
    @Req() req: Request,
  ) {
    return this.service.requestPhoneOtp(actor, input, req.ip ?? null);
  }
  @Post('phone/verify')
  @HttpCode(200)
  @ApiOkResponse({ type: ChangedPhoneResponseDto })
  verifyPhone(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: VerifyPhoneChangeDto,
  ) {
    return this.service.verifyPhone(actor, input);
  }
}
