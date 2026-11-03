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
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  AiBridgeSummaryDto,
  AiCaptionDto,
  AiCaptionResultDto,
  AiConsentDto,
  AiDayStoryDto,
  AiMissionResultDto,
  AiMissionSuggestDto,
  AiRewriteDto,
  AiRewriteResultDto,
  AiStatusDto,
  AiStoryResultDto,
  AiSummaryResultDto,
} from '../dto/ai/ai.dto';
import { AI_SERVICE } from '../interfaces/services/ai-service.interface';
import type { IAiService } from '../interfaces/services/ai-service.interface';

/** AI 1.2 (đặc tả 7.18, BF-20261028-010) — chỉ chạy khi người dùng bấm. */
@ApiTags('AI')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Throttle({ default: { limit: 20, ttl: 60000 } })
@Controller('families/:familyId/ai')
export class AiController {
  constructor(@Inject(AI_SERVICE) private readonly service: IAiService) {}

  @Get('status')
  @ApiOkResponse({ type: AiStatusDto })
  status(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
  ) {
    return this.service.status(actor, familyId);
  }

  /** Đồng ý gửi dữ liệu cho nhà cung cấp AI (lần đầu mỗi tính năng). */
  @Post('consents')
  @HttpCode(200)
  @ApiOkResponse({ type: AiStatusDto })
  consent(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Body() input: AiConsentDto,
  ) {
    return this.service.consent(actor, familyId, input.feature);
  }

  @Post('captions')
  @HttpCode(200)
  @ApiOkResponse({ type: AiCaptionResultDto })
  captions(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Body() input: AiCaptionDto,
  ) {
    return this.service.captions(actor, familyId, input);
  }

  @Post('day-story')
  @HttpCode(200)
  @ApiOkResponse({ type: AiStoryResultDto })
  dayStory(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Body() input: AiDayStoryDto,
  ) {
    return this.service.dayStory(actor, familyId, input);
  }

  @Post('rewrite')
  @HttpCode(200)
  @ApiOkResponse({ type: AiRewriteResultDto })
  rewrite(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Body() input: AiRewriteDto,
  ) {
    return this.service.rewrite(actor, familyId, input);
  }

  @Post('mission-suggestions')
  @HttpCode(200)
  @ApiOkResponse({ type: AiMissionResultDto })
  missionSuggestions(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Body() input: AiMissionSuggestDto,
  ) {
    return this.service.missionSuggestions(actor, familyId, input);
  }

  @Post('bridge-summary')
  @HttpCode(200)
  @ApiOkResponse({ type: AiSummaryResultDto })
  bridgeSummary(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Body() input: AiBridgeSummaryDto,
  ) {
    return this.service.bridgeSummary(actor, familyId, input);
  }
}
