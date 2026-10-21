import {
  Body,
  Controller,
  HttpCode,
  Inject,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import type { Request } from 'express';
import { ADMIN_CMS_AUTH_SERVICE } from '../interfaces/services/admin-cms-auth-service.interface';
import type { IAdminCmsAuthService } from '../interfaces/services/admin-cms-auth-service.interface';
import { AdminCmsLoginDto } from '../dto/admin-cms-auth/admin-cms-auth.dto';
import { AdminCmsGuard } from '../common/auth/admin-cms.guard';
import { CurrentAdminCms } from '../common/auth/admin-cms-actor.decorator';
import type { AdminCmsActor } from '../models/admin-cms-auth.model';
@Controller('admin/v1/auth')
export class AdminCmsAuthController {
  constructor(
    @Inject(ADMIN_CMS_AUTH_SERVICE) private readonly auth: IAdminCmsAuthService,
  ) {}
  @Post('login')
  @HttpCode(200)
  login(@Body() input: AdminCmsLoginDto, @Req() request: Request) {
    return this.auth.login(
      input.email,
      input.password,
      input.totp,
      request.ip ?? request.socket.remoteAddress ?? 'unknown',
    );
  }
  @Post('logout')
  @HttpCode(204)
  @UseGuards(AdminCmsGuard)
  logout(@CurrentAdminCms() actor: AdminCmsActor) {
    return this.auth.logout(actor);
  }
}
