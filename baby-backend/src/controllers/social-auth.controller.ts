import {
  Body,
  Controller,
  HttpCode,
  Inject,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOkResponse, ApiBearerAuth } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import type { Request } from 'express';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  AppleSignInDto,
  GoogleSignInDto,
} from '../dto/auth/social-identity.dto';
import { AuthTokensResponseDto } from '../dto/auth/auth-tokens.dto';
import { ReauthResponseDto } from '../dto/auth/reauth.dto';
import {
  SOCIAL_IDENTITY_SERVICE,
  type ISocialIdentityService,
} from '../interfaces/services/social-identity-service.interface';
@ApiTags('Auth')
@Throttle({ default: { limit: 30, ttl: 60000 } })
@Controller('auth')
export class SocialAuthController {
  constructor(
    @Inject(SOCIAL_IDENTITY_SERVICE)
    private readonly service: ISocialIdentityService,
  ) {}
  @Post('apple')
  @HttpCode(200)
  @ApiOkResponse({ type: AuthTokensResponseDto })
  apple(@Body() input: AppleSignInDto, @Req() req: Request) {
    return this.service.signIn('APPLE', input, req.ip ?? null);
  }
  @Post('google')
  @HttpCode(200)
  @ApiOkResponse({ type: AuthTokensResponseDto })
  google(@Body() input: GoogleSignInDto, @Req() req: Request) {
    return this.service.signIn('GOOGLE', input, req.ip ?? null);
  }
  @Post('reauth/apple')
  @HttpCode(200)
  @ApiBearerAuth()
  @UseGuards(AccessTokenGuard)
  @ApiOkResponse({ type: ReauthResponseDto })
  reauthApple(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: AppleSignInDto,
  ) {
    return this.service.reauthenticate(actor, 'APPLE', input);
  }
  @Post('reauth/google')
  @HttpCode(200)
  @ApiBearerAuth()
  @UseGuards(AccessTokenGuard)
  @ApiOkResponse({ type: ReauthResponseDto })
  reauthGoogle(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: GoogleSignInDto,
  ) {
    return this.service.reauthenticate(actor, 'GOOGLE', input);
  }
}
