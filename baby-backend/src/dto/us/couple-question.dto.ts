import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, Matches, MaxLength, MinLength } from 'class-validator';
import { Transform } from 'class-transformer';
import { IsOptional } from 'class-validator';
import { COUPLE_QUESTION_POLICY } from '../../config/couple-question-catalog';

/** `PUT /families/:familyId/us/question/today/answer`. */
export class AnswerCoupleQuestionDto {
  @ApiProperty({ maxLength: COUPLE_QUESTION_POLICY.answerMaxLength })
  @IsString()
  @Transform(({ value }: { value: unknown }) =>
    typeof value === 'string' ? value.trim() : value,
  )
  @MinLength(1)
  @MaxLength(COUPLE_QUESTION_POLICY.answerMaxLength)
  answer!: string;
}

export class CoupleQuestionTodayDto {
  @ApiProperty({ example: '2026-10-27' }) date!: string;
  @ApiProperty() code!: string;
  @ApiProperty({
    type: 'object',
    additionalProperties: { type: 'string' },
    description: 'Câu hỏi theo ngôn ngữ (`vi`, `en`…).',
  })
  textI18n!: Record<string, string>;
  @ApiProperty({ type: String, nullable: true }) myAnswer!: string | null;
  @ApiProperty() partnerAnswered!: boolean;
  @ApiProperty({
    type: String,
    nullable: true,
    description: 'Chỉ có khi cả hai đã trả lời.',
  })
  partnerAnswer!: string | null;
}

/** `GET /families/:familyId/us/week?weekStart=YYYY-MM-DD` (thứ Hai). */
export class CoupleWeekQueryDto {
  @ApiPropertyOptional({ example: '2026-10-26' })
  @IsOptional()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  weekStart?: string;
}

export class CoupleWeekItemDto {
  @ApiProperty() title!: string;
  @ApiProperty({ format: 'date-time' }) date!: string;
}

export class CoupleWeekDto {
  @ApiProperty() weekStart!: string;
  @ApiProperty() weekEnd!: string;
  @ApiProperty() checkins!: number;
  @ApiProperty() requestsHelped!: number;
  @ApiProperty() thanks!: number;
  @ApiProperty() togetherMissions!: number;
  @ApiProperty({ type: [CoupleWeekItemDto] }) together!: CoupleWeekItemDto[];
}
