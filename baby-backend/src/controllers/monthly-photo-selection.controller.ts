import {
  Body,
  Controller,
  Get,
  Inject,
  Param,
  ParseIntPipe,
  ParseUUIDPipe,
  Post,
  Put,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  PostMonthlyPhotoDto,
  SetMonthlyPhotoDto,
} from '../dto/monthly-photo/monthly-photo-selection.dto';
import {
  MONTHLY_PHOTO_SELECTION_SERVICE,
  type IMonthlyPhotoSelectionService,
} from '../interfaces/services/monthly-photo-selection-service.interface';
@ApiTags('Monthly photos')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('children/:id/monthly-photos')
export class MonthlyPhotoSelectionController {
  constructor(
    @Inject(MONTHLY_PHOTO_SELECTION_SERVICE)
    private readonly service: IMonthlyPhotoSelectionService,
  ) {}
  @Get() list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.list(actor, id);
  }
  @Post() post(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: PostMonthlyPhotoDto,
  ) {
    return this.service.set(actor, id, input.monthIndex, input);
  }
  @Put(':monthIndex') set(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Param('monthIndex', ParseIntPipe) monthIndex: number,
    @Body() input: SetMonthlyPhotoDto,
  ) {
    return this.service.set(actor, id, monthIndex, input);
  }
}
