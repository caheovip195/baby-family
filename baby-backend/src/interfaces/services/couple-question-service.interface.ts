import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  AnswerCoupleQuestionDto,
  CoupleQuestionTodayDto,
  CoupleWeekDto,
  CoupleWeekQueryDto,
} from '../../dto/us/couple-question.dto';

export const COUPLE_QUESTION_SERVICE = Symbol('COUPLE_QUESTION_SERVICE');

export interface ICoupleQuestionService {
  today(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<CoupleQuestionTodayDto>;
  answer(
    actor: AuthPrincipal,
    familyId: string,
    input: AnswerCoupleQuestionDto,
  ): Promise<CoupleQuestionTodayDto>;
  week(
    actor: AuthPrincipal,
    familyId: string,
    query: CoupleWeekQueryDto,
  ): Promise<CoupleWeekDto>;
}
