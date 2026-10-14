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
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { UpdateFamilyDto } from '../dto/family/update-family.dto';
import { FamilyResponseDto } from '../dto/family/family-response.dto';
import { FAMILY_SERVICE } from '../interfaces/services/family-service.interface';
import type { IFamilyService } from '../interfaces/services/family-service.interface';

@ApiTags('Family')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId')
export class FamilyController {
  constructor(
    @Inject(FAMILY_SERVICE) private readonly service: IFamilyService,
  ) {}

  @Get()
  @ApiOkResponse({ type: FamilyResponseDto })
  getById(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
  ) {
    return this.service.getById(actor, familyId);
  }

  @Patch()
  @ApiOkResponse({ type: FamilyResponseDto })
  update(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Body() input: UpdateFamilyDto,
  ) {
    return this.service.update(actor, familyId, input);
  }
}
