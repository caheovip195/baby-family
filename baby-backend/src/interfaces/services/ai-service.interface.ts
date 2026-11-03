import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  AiBridgeSummaryDto,
  AiCaptionDto,
  AiCaptionResultDto,
  AiDayStoryDto,
  AiMissionResultDto,
  AiMissionSuggestDto,
  AiRewriteDto,
  AiRewriteResultDto,
  AiStatusDto,
  AiStoryResultDto,
  AiSummaryResultDto,
} from '../../dto/ai/ai.dto';

export const AI_SERVICE = Symbol('AI_SERVICE');

export interface IAiService {
  status(actor: AuthPrincipal, familyId: string): Promise<AiStatusDto>;
  consent(
    actor: AuthPrincipal,
    familyId: string,
    feature: string,
  ): Promise<AiStatusDto>;
  captions(
    actor: AuthPrincipal,
    familyId: string,
    input: AiCaptionDto,
  ): Promise<AiCaptionResultDto>;
  dayStory(
    actor: AuthPrincipal,
    familyId: string,
    input: AiDayStoryDto,
  ): Promise<AiStoryResultDto>;
  rewrite(
    actor: AuthPrincipal,
    familyId: string,
    input: AiRewriteDto,
  ): Promise<AiRewriteResultDto>;
  missionSuggestions(
    actor: AuthPrincipal,
    familyId: string,
    input: AiMissionSuggestDto,
  ): Promise<AiMissionResultDto>;
  bridgeSummary(
    actor: AuthPrincipal,
    familyId: string,
    input: AiBridgeSummaryDto,
  ): Promise<AiSummaryResultDto>;
}
