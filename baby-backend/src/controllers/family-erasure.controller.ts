import {
  Body,
  Controller,
  Get,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  ConfirmFamilyErasureDto,
  RequestFamilyErasureDto,
} from '../dto/family/family-erasure.dto';
import {
  FAMILY_ERASURE_SERVICE,
  type IFamilyErasureService,
} from '../interfaces/services/family-erasure-service.interface';
@ApiTags('Family deletion')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:fid/deletion')
export class FamilyErasureController {
  constructor(
    @Inject(FAMILY_ERASURE_SERVICE)
    private readonly service: IFamilyErasureService,
  ) {}
  @Get() get(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', new ParseUUIDPipe()) fid: string,
  ) {
    return this.service.get(actor, fid);
  }
  @Post() @HttpCode(202) request(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', new ParseUUIDPipe()) fid: string,
    @Body() input: RequestFamilyErasureDto,
  ) {
    return this.service.request(actor, fid, input);
  }
  @Post('confirm') @HttpCode(200) confirm(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', new ParseUUIDPipe()) fid: string,
    @Body() input: ConfirmFamilyErasureDto,
  ) {
    return this.service.confirm(actor, fid, input);
  }
  @Post('cancel') @HttpCode(200) cancel(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', new ParseUUIDPipe()) fid: string,
  ) {
    return this.service.cancel(actor, fid);
  }
}
