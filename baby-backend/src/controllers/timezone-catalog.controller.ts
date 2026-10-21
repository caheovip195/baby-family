import { Controller, Get, Inject, Query } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { TimezoneCatalogQueryDto } from '../dto/catalog/timezone-catalog.dto';
import {
  TIMEZONE_CATALOG_SERVICE,
  type ITimezoneCatalogService,
} from '../interfaces/services/timezone-catalog-service.interface';

@ApiTags('Catalog')
@Controller('catalog/timezones')
export class TimezoneCatalogController {
  constructor(
    @Inject(TIMEZONE_CATALOG_SERVICE)
    private readonly service: ITimezoneCatalogService,
  ) {}

  @Get()
  list(@Query() query: TimezoneCatalogQueryDto) {
    return this.service.list(query.locale);
  }
}
