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
import {
  AiSettingsResponseDto,
  NotificationSettingsResponseDto,
  UpdateAiSettingsDto,
  UpdateNotificationSettingsDto,
} from '../dto/preferences/preference-settings.dto';
import { PREFERENCE_SETTINGS_SERVICE } from '../interfaces/services/preference-settings-service.interface';
import type { IPreferenceSettingsService } from '../interfaces/services/preference-settings-service.interface';

/** SET thông báo (§7.21) + cài đặt AI (§9.12) của chính tôi. */
@ApiTags('Settings')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('me')
export class PreferenceSettingsController {
  constructor(
    @Inject(PREFERENCE_SETTINGS_SERVICE)
    private readonly service: IPreferenceSettingsService,
  ) {}

  @Get('notification-settings')
  @ApiOkResponse({ type: NotificationSettingsResponseDto })
  notificationSettings(@CurrentActor() actor: AuthPrincipal) {
    return this.service.notificationSettings(actor);
  }

  @Patch('notification-settings')
  @ApiOkResponse({ type: NotificationSettingsResponseDto })
  updateNotificationSettings(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: UpdateNotificationSettingsDto,
  ) {
    return this.service.updateNotificationSettings(actor, input);
  }

  @Get('ai-settings')
  @ApiOkResponse({ type: AiSettingsResponseDto })
  aiSettings(@CurrentActor() actor: AuthPrincipal) {
    return this.service.aiSettings(actor);
  }

  @Patch('ai-settings')
  @ApiOkResponse({ type: AiSettingsResponseDto })
  updateAiSettings(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: UpdateAiSettingsDto,
  ) {
    return this.service.updateAiSettings(actor, input);
  }
}
