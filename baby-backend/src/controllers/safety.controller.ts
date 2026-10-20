import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  BlockListResponseDto,
  CreateBlockDto,
  CreateReportDto,
  FamilyScopeQueryDto,
  ReportResponseDto,
} from '../dto/safety/safety.dto';
import { SAFETY_SERVICE } from '../interfaces/services/safety-service.interface';
import type { ISafetyService } from '../interfaces/services/safety-service.interface';

/** RPT-01 báo cáo + RPT-02 chặn (theo gia đình). */
@ApiTags('Safety')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller()
export class SafetyController {
  constructor(
    @Inject(SAFETY_SERVICE) private readonly service: ISafetyService,
  ) {}

  @Post('reports')
  @ApiCreatedResponse({ type: ReportResponseDto })
  report(@CurrentActor() actor: AuthPrincipal, @Body() input: CreateReportDto) {
    return this.service.report(actor, input);
  }

  @Post('blocks')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiNoContentResponse()
  block(@CurrentActor() actor: AuthPrincipal, @Body() input: CreateBlockDto) {
    return this.service.block(actor, input);
  }

  @Delete('blocks/:userId')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiNoContentResponse()
  unblock(
    @CurrentActor() actor: AuthPrincipal,
    @Param('userId', new ParseUUIDPipe()) userId: string,
    @Query() query: FamilyScopeQueryDto,
  ) {
    return this.service.unblock(actor, query.familyId, userId);
  }

  @Get('me/blocks')
  @ApiOkResponse({ type: BlockListResponseDto })
  blocks(
    @CurrentActor() actor: AuthPrincipal,
    @Query() query: FamilyScopeQueryDto,
  ) {
    return this.service.blocks(actor, query.familyId);
  }
}
