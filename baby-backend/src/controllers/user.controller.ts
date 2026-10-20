import {
  Body,
  Controller,
  Get,
  HttpCode,
  Inject,
  Patch,
  Post,
  Put,
  Req,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import type { Request } from 'express';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  RecordConsentsDto,
  RegisterDeviceDto,
  SetOnboardingRoleDto,
} from '../dto/user/account-commands.dto';
import { MeResponseDto } from '../dto/user/me-response.dto';
import { UpdateUserDto } from '../dto/user/update-user.dto';
import { UserResponseDto } from '../dto/user/user-response.dto';
import { USER_SERVICE } from '../interfaces/services/user-service.interface';
import type { IUserService } from '../interfaces/services/user-service.interface';

@ApiTags('User')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('me')
export class UserController {
  constructor(@Inject(USER_SERVICE) private readonly service: IUserService) {}

  @Get()
  @ApiOkResponse({ type: MeResponseDto })
  getMe(@CurrentActor() actor: AuthPrincipal) {
    return this.service.getMe(actor);
  }

  @Patch()
  @ApiOkResponse({ type: UserResponseDto })
  updateMe(@CurrentActor() actor: AuthPrincipal, @Body() input: UpdateUserDto) {
    return this.service.updateMe(actor, input);
  }

  @Put('onboarding-role')
  @ApiOkResponse({ type: MeResponseDto })
  setOnboardingRole(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: SetOnboardingRoleDto,
  ) {
    return this.service.setOnboardingRole(actor, input);
  }

  @Post('devices')
  @HttpCode(204)
  @ApiNoContentResponse()
  registerDevice(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: RegisterDeviceDto,
  ) {
    return this.service.registerDevice(actor, input);
  }

  @Post('consents')
  @HttpCode(204)
  @ApiNoContentResponse()
  recordConsents(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: RecordConsentsDto,
    @Req() request: Request,
  ) {
    return this.service.recordConsents(actor, input, request.ip ?? null);
  }
}
