import {
  Controller,
  Get,
  Inject,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import { AdminCmsGuard } from '../common/auth/admin-cms.guard';
import {
  CurrentAdminCms,
  AdminCmsRoles,
} from '../common/auth/admin-cms-actor.decorator';
import type { AdminCmsActor } from '../models/admin-cms-auth.model';
import { AdminCmsCatalogQueryDto } from '../dto/admin-cms-catalog/admin-cms-catalog.dto';
import { ADMIN_CMS_CATALOG_SERVICE } from '../interfaces/services/admin-cms-catalog-service.interface';
import type { IAdminCmsCatalogService } from '../interfaces/services/admin-cms-catalog-service.interface';
@UseGuards(AdminCmsGuard)
@Controller('admin/v1/catalog')
export class AdminCmsCatalogController {
  constructor(
    @Inject(ADMIN_CMS_CATALOG_SERVICE)
    private readonly service: IAdminCmsCatalogService,
  ) {}
  @AdminCmsRoles('CONTENT', 'BILLING_OPS', 'OPS')
  @Get(':kind')
  list(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Param('kind') kind: string,
    @Query() query: AdminCmsCatalogQueryDto,
  ) {
    return this.service.list(actor.id, kind, query);
  }
}
