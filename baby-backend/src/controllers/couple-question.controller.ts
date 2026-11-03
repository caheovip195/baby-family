import {
  Body,
  Controller,
  Get,
  Inject,
  Param,
  ParseUUIDPipe,
  Put,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  AnswerCoupleQuestionDto,
  CoupleWeekQueryDto,
} from '../dto/us/couple-question.dto';
import { COUPLE_QUESTION_SERVICE } from '../interfaces/services/couple-question-service.interface';
import type { ICoupleQuestionService } from '../interfaces/services/couple-question-service.interface';

/** Câu hỏi kết nối + US-14 Tuần của hai ta (chỉ Papa & Mama). */
@ApiTags('Couple question & week')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/us')
export class CoupleQuestionController {
  constructor(
    @Inject(COUPLE_QUESTION_SERVICE)
    private readonly service: ICoupleQuestionService,
  ) {}

  @Get('question/today')
  today(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
  ) {
    return this.service.today(actor, familyId);
  }

  /** Tạo hoặc sửa câu trả lời của tôi cho câu hôm nay (idempotent). */
  @Put('question/today/answer')
  answer(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Body() input: AnswerCoupleQuestionDto,
  ) {
    return this.service.answer(actor, familyId, input);
  }

  @Get('week')
  week(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Query() query: CoupleWeekQueryDto,
  ) {
    return this.service.week(actor, familyId, query);
  }
}
