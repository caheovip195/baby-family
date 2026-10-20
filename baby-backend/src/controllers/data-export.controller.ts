import {
  Body,
  Controller,
  Get,
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
import { CreateDataExportDto } from '../dto/account/data-export.dto';
import { DATA_EXPORT_SERVICE } from '../interfaces/services/data-export-service.interface';
import type { IDataExportService } from '../interfaces/services/data-export-service.interface';

@ApiTags('Data export')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('exports')
export class DataExportController {
  constructor(
    @Inject(DATA_EXPORT_SERVICE) private readonly service: IDataExportService,
  ) {}
  @Post()
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: CreateDataExportDto,
  ) {
    return this.service.create(actor, input);
  }
  @Get(':id')
  find(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.find(actor, id);
  }
}
