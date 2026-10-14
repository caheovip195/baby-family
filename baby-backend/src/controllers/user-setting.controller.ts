import {
  Body,
  Controller,
  Get,
  Inject,
  Patch,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { UpdateUserSettingDto } from '../dto/user-setting/update-user-setting.dto';
import { UserSettingResponseDto } from '../dto/user-setting/user-setting-response.dto';
import { USER_SETTING_SERVICE } from '../interfaces/services/user-setting-service.interface';
import type { IUserSettingService } from '../interfaces/services/user-setting-service.interface';

@ApiTags('UserSetting')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('me/settings')
export class UserSettingController {
  constructor(
    @Inject(USER_SETTING_SERVICE) private readonly service: IUserSettingService,
  ) {}

  @Get()
  @ApiOkResponse({ type: UserSettingResponseDto })
  getMe(@CurrentActor() actor: AuthPrincipal) {
    return this.service.getMe(actor);
  }

  @Patch()
  @ApiOkResponse({ type: UserSettingResponseDto })
  updateMe(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: UpdateUserSettingDto,
  ) {
    return this.service.updateMe(actor, input);
  }
}
