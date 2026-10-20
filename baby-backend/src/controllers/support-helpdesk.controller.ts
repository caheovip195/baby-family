import {
  Body,
  Controller,
  Get,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  CreateSupportHelpdeskDto,
  SupportHelpdeskMessageDto,
  SupportHelpdeskQueryDto,
} from '../dto/support-helpdesk/support-helpdesk.dto';
import { SUPPORT_HELPDESK_SERVICE } from '../interfaces/services/support-helpdesk-service.interface';
import type { ISupportHelpdeskService } from '../interfaces/services/support-helpdesk-service.interface';
@ApiTags('Support')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller()
export class SupportHelpdeskController {
  constructor(
    @Inject(SUPPORT_HELPDESK_SERVICE)
    private readonly service: ISupportHelpdeskService,
  ) {}
  @Get('support/categories') catalog() {
    return this.service.catalog();
  }
  @Post('support/tickets') create(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: CreateSupportHelpdeskDto,
  ) {
    return this.service.create(actor, input);
  }
  @Get('me/support/tickets') list(
    @CurrentActor() actor: AuthPrincipal,
    @Query() query: SupportHelpdeskQueryDto,
  ) {
    return this.service.list(actor, query);
  }
  @Get('support/tickets/:id') detail(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.detail(actor, id);
  }
  @Post('support/tickets/:id/messages') message(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: SupportHelpdeskMessageDto,
  ) {
    return this.service.message(actor, id, input);
  }
}
