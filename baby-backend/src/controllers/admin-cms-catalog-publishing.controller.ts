import {
  Body,
  Controller,
  Get,
  Inject,
  Param,
  Post,
  UseGuards,
} from '@nestjs/common';
import { AdminCmsGuard } from '../common/auth/admin-cms.guard';
import { CurrentAdminCms } from '../common/auth/admin-cms-actor.decorator';
import type { AdminCmsActor } from '../models/admin-cms-auth.model';
import { ADMIN_CMS_CATALOG_PUBLISHING_SERVICE } from '../interfaces/services/admin-cms-catalog-publishing-service.interface';
import type { IAdminCmsCatalogPublishingService } from '../interfaces/services/admin-cms-catalog-publishing-service.interface';
@UseGuards(AdminCmsGuard)
@Controller('admin/v1/catalog')
export class AdminCmsCatalogPublishingController {
  constructor(
    @Inject(ADMIN_CMS_CATALOG_PUBLISHING_SERVICE)
    private readonly service: IAdminCmsCatalogPublishingService,
  ) {}
  @Get('publishing/:kind') drafts(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Param('kind') kind: string,
  ) {
    return this.service.drafts(actor, kind);
  }
  @Post(':kind') create(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Param('kind') kind: string,
    @Body() body: unknown,
  ) {
    return this.service.create(actor, kind, body);
  }
  @Post(':kind/:id/publish') publish(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Param('kind') kind: string,
    @Param('id') id: string,
    @Body() body: unknown,
  ) {
    return this.service.publish(actor, kind, id, body);
  }
  @Post(':kind/:id/retire') retire(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Param('kind') kind: string,
    @Param('id') id: string,
    @Body() body: unknown,
  ) {
    return this.service.retire(actor, kind, id, body);
  }
}
