import {
  Body,
  Controller,
  Get,
  Inject,
  Param,
  ParseUUIDPipe,
  Patch,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { UpdateFamilySettingsDto } from '../dto/family/family-settings.dto';
import { FAMILY_SETTINGS_SERVICE } from '../interfaces/services/family-settings-service.interface';
import type { IFamilySettingsService } from '../interfaces/services/family-settings-service.interface';

@ApiTags('Family settings')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/settings')
export class FamilySettingsController {
  constructor(
    @Inject(FAMILY_SETTINGS_SERVICE)
    private readonly service: IFamilySettingsService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Parent settings; Circle receives only showLunar.' })
  get(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
  ) {
    return this.service.get(actor, familyId);
  }

  @Patch()
  @ApiOperation({
    summary:
      'Parent only. Schema v1 whitelist; last-write-wins per supplied key (no Family settings version column).',
  })
  patch(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Body() input: UpdateFamilySettingsDto,
  ) {
    return this.service.patch(actor, familyId, input);
  }
}
