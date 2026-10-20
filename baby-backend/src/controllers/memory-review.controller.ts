import {
  Body,
  Controller,
  Get,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  UseGuards,
} from '@nestjs/common';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  ApproveMemoryDto,
  RejectMemoryDto,
} from '../dto/memory-review/memory-review.dto';
import {
  MEMORY_REVIEW_SERVICE,
  type IMemoryReviewService,
} from '../interfaces/services/memory-review-service.interface';
@UseGuards(AccessTokenGuard)
@Controller()
export class MemoryReviewController {
  constructor(
    @Inject(MEMORY_REVIEW_SERVICE)
    private readonly service: IMemoryReviewService,
  ) {}
  @Get('families/:fid/memories/pending-review')
  pending(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', new ParseUUIDPipe()) fid: string,
  ) {
    return this.service.pending(actor, fid);
  }
  @Post('memories/:id/approve')
  @HttpCode(200)
  approve(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: ApproveMemoryDto,
  ) {
    return this.service.approve(actor, id, input);
  }
  @Post('memories/:id/reject')
  @HttpCode(200)
  reject(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: RejectMemoryDto,
  ) {
    return this.service.reject(actor, id, input);
  }
}
