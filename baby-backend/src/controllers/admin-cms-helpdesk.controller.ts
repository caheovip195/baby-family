import {
  Body,
  Controller,
  Get,
  Inject,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { AdminCmsGuard } from '../common/auth/admin-cms.guard';
import {
  CurrentAdminCms,
  AdminCmsRoles,
} from '../common/auth/admin-cms-actor.decorator';
import type { AdminCmsActor } from '../models/admin-cms-auth.model';
import {
  AdminCmsHelpdeskQueryDto,
  AdminCmsHelpdeskReasonDto,
  AdminCmsHelpdeskReplyDto,
  AdminCmsHelpdeskStatusDto,
} from '../dto/admin-cms-helpdesk/admin-cms-helpdesk.dto';
import { ADMIN_CMS_HELPDESK_SERVICE } from '../interfaces/services/admin-cms-helpdesk-service.interface';
import type { IAdminCmsHelpdeskService } from '../interfaces/services/admin-cms-helpdesk-service.interface';
@UseGuards(AdminCmsGuard)
@AdminCmsRoles('SUPPORT')
@Controller('admin/v1/support/tickets')
export class AdminCmsHelpdeskController {
  constructor(
    @Inject(ADMIN_CMS_HELPDESK_SERVICE)
    private readonly service: IAdminCmsHelpdeskService,
  ) {}
  @Get() list(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Query() query: AdminCmsHelpdeskQueryDto,
  ) {
    return this.service.list(actor.id, query);
  }
  @Get(':id') detail(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Query() query: AdminCmsHelpdeskReasonDto,
  ) {
    return this.service.detail(actor.id, id, query.reasonCode);
  }
  @Post(':id/messages') reply(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: AdminCmsHelpdeskReplyDto,
  ) {
    return this.service.reply(actor.id, id, input);
  }
  @Patch(':id/status') status(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: AdminCmsHelpdeskStatusDto,
  ) {
    return this.service.status(actor.id, id, input);
  }
}
