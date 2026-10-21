import { Controller, Get, Inject, Query } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { HelpCenterQueryDto } from '../dto/support-help-center/help-center.dto';
import {
  HELP_CENTER_SERVICE,
  type IHelpCenterService,
} from '../interfaces/services/help-center-service.interface';

/** SET-11/12: public help center (FAQ, contact, legal links). */
@ApiTags('Support')
@Controller('support/help-center')
export class HelpCenterController {
  constructor(
    @Inject(HELP_CENTER_SERVICE)
    private readonly service: IHelpCenterService,
  ) {}

  @Get()
  get(@Query() query: HelpCenterQueryDto) {
    return this.service.get(query.locale);
  }
}
