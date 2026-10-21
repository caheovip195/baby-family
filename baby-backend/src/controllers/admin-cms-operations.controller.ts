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
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AdminCmsGuard } from '../common/auth/admin-cms.guard';
import {
  CurrentAdminCms,
  AdminCmsRoles,
} from '../common/auth/admin-cms-actor.decorator';
import type { AdminCmsActor } from '../models/admin-cms-auth.model';
import {
  AdminCmsOperationsListDto,
  AdminCmsOperationsStatusDto,
  AdminCmsOperationsActionDto,
  AdminCmsOperationsBlockDto,
  AdminCmsOperationsReasonDto,
} from '../dto/admin-cms-operations/admin-cms-operations.dto';
import { ADMIN_CMS_OPERATIONS_SERVICE } from '../interfaces/services/admin-cms-operations-service.interface';
import type { IAdminCmsOperationsService } from '../interfaces/services/admin-cms-operations-service.interface';
@ApiTags('Admin operations')
@ApiBearerAuth()
@UseGuards(AdminCmsGuard)
@Controller('admin/v1')
export class AdminCmsOperationsController {
  constructor(
    @Inject(ADMIN_CMS_OPERATIONS_SERVICE)
    private readonly service: IAdminCmsOperationsService,
  ) {}
  @Get('moderation/cases')
  @AdminCmsRoles('MODERATOR', 'SUPPORT', 'OPS')
  list(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Query() input: AdminCmsOperationsListDto,
  ) {
    return this.service.list(actor, input);
  }
  @Get('moderation/cases/:id')
  @AdminCmsRoles('MODERATOR', 'SUPPORT', 'OPS')
  detail(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.detail(actor, id);
  }
  @Post('moderation/cases/:id/content')
  @AdminCmsRoles('MODERATOR')
  content(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: AdminCmsOperationsReasonDto,
  ) {
    return this.service.content(actor, id, input);
  }
  @Patch('moderation/cases/:id/status')
  @AdminCmsRoles('MODERATOR')
  status(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: AdminCmsOperationsStatusDto,
  ) {
    return this.service.status(actor, id, input);
  }
  @Post('moderation/cases/:id/actions')
  @AdminCmsRoles('MODERATOR')
  hide(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: AdminCmsOperationsActionDto,
  ) {
    return this.service.hide(actor, id, input);
  }
  @Post('families/:id/license/block')
  @AdminCmsRoles('OPS', 'BILLING_OPS')
  block(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: AdminCmsOperationsBlockDto,
  ) {
    return this.service.license(actor, id, true, input);
  }
  @Post('families/:id/license/unblock')
  @AdminCmsRoles('OPS', 'BILLING_OPS')
  unblock(
    @CurrentAdminCms() actor: AdminCmsActor,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: AdminCmsOperationsBlockDto,
  ) {
    return this.service.license(actor, id, false, input);
  }
}
