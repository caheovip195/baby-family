import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Inject,
  Param,
  Post,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOkResponse,
  ApiNoContentResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  LinkAppleIdentityDto,
  LinkGoogleIdentityDto,
  UnlinkIdentityDto,
  SignInMethodResponseDto,
} from '../dto/auth/social-identity.dto';
import {
  SOCIAL_IDENTITY_SERVICE,
  type ISocialIdentityService,
} from '../interfaces/services/social-identity-service.interface';
@ApiTags('Account security')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Throttle({ default: { limit: 30, ttl: 60000 } })
@Controller('me')
export class SignInMethodsController {
  constructor(
    @Inject(SOCIAL_IDENTITY_SERVICE)
    private readonly service: ISocialIdentityService,
  ) {}
  @Get('sign-in-methods')
  @ApiOkResponse({ type: SignInMethodResponseDto, isArray: true })
  list(@CurrentActor() actor: AuthPrincipal) {
    return this.service.list(actor);
  }
  @Post('identities/apple')
  @HttpCode(204)
  @ApiNoContentResponse()
  apple(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: LinkAppleIdentityDto,
  ) {
    return this.service.link(actor, 'APPLE', input, input.reauthToken);
  }
  @Post('identities/google')
  @HttpCode(204)
  @ApiNoContentResponse()
  google(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: LinkGoogleIdentityDto,
  ) {
    return this.service.link(actor, 'GOOGLE', input, input.reauthToken);
  }
  @Delete('identities/:provider')
  @HttpCode(204)
  @ApiNoContentResponse()
  unlink(
    @CurrentActor() actor: AuthPrincipal,
    @Param('provider') provider: string,
    @Body() input: UnlinkIdentityDto,
  ) {
    return this.service.unlink(actor, provider, input.reauthToken);
  }
}
