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
  UpdateUsSettingsDto,
  UsSettingsResponseDto,
} from '../dto/us-settings/us-settings.dto';
import { US_SETTINGS_SERVICE } from '../interfaces/services/us-settings-service.interface';
import type { IUsSettingsService } from '../interfaces/services/us-settings-service.interface';

@ApiTags('Papa & Mama settings')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('me/us-settings')
export class UsSettingsController {
  constructor(
    @Inject(US_SETTINGS_SERVICE) private readonly service: IUsSettingsService,
  ) {}

  @Get()
  @ApiOkResponse({ type: UsSettingsResponseDto })
  getMe(@CurrentActor() actor: AuthPrincipal) {
    return this.service.getMe(actor);
  }

  @Patch()
  @ApiOkResponse({ type: UsSettingsResponseDto })
  updateMe(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: UpdateUsSettingsDto,
  ) {
    return this.service.updateMe(actor, input);
  }
}
