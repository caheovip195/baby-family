import { Body, Controller, Get, Inject, Put, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { SetDefaultFamilyDto } from '../dto/me-families/me-families.dto';
import { ME_FAMILIES_SERVICE } from '../interfaces/services/me-families-service.interface';
import type { IMeFamiliesService } from '../interfaces/services/me-families-service.interface';

@ApiTags('My families')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('me')
export class MeFamiliesController {
  constructor(
    @Inject(ME_FAMILIES_SERVICE)
    private readonly service: IMeFamiliesService,
  ) {}

  @Get('families')
  list(@CurrentActor() actor: AuthPrincipal) {
    return this.service.list(actor);
  }

  @Put('default-family')
  setDefault(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: SetDefaultFamilyDto,
  ) {
    return this.service.setDefault(actor, input.familyId);
  }
}
