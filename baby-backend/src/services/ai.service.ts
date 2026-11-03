import { Inject, Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError } from '../common/errors/domain.error';
import {
  AI_POLICY,
  AI_PROMPTS,
  AI_SAFETY_KEYWORDS,
  type AiFeature,
} from '../config/ai-policy';
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
} from '../dto/ai/ai.dto';
import { AI_REPOSITORY } from '../interfaces/repositories/ai-repository.interface';
import type { IAiRepository } from '../interfaces/repositories/ai-repository.interface';
import { AI_PROVIDER } from '../interfaces/services/ai-provider.interface';
import type { IAiProvider } from '../interfaces/services/ai-provider.interface';
import type { IAiService } from '../interfaces/services/ai-service.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import { BRIDGE_SERVICE } from '../interfaces/services/bridge-service.interface';
import type { IBridgeService } from '../interfaces/services/bridge-service.interface';
import { DAY_STORY_RECAP_SERVICE } from '../interfaces/services/day-story-recap-service.interface';
import type { IDayStoryRecapService } from '../interfaces/services/day-story-recap-service.interface';
import { MISSION_BOARD_SERVICE } from '../interfaces/services/mission-board-service.interface';
import type { IMissionBoardService } from '../interfaces/services/mission-board-service.interface';

const FEATURES: readonly AiFeature[] = [
  'caption',
  'dailyStory',
  'gentleRewrite',
  'bridgeSummary',
  'missionSuggest',
];

const monthOf = (now: Date) =>
  new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 1));

/** Lấy khối JSON đầu tiên trong câu trả lời của model. */
function jsonOf(text: string): Record<string, unknown> | null {
  const start = text.indexOf('{');
  const end = text.lastIndexOf('}');
  if (start < 0 || end <= start) return null;
  try {
    const value: unknown = JSON.parse(text.slice(start, end + 1));
    return value && typeof value === 'object' && !Array.isArray(value)
      ? (value as Record<string, unknown>)
      : null;
  } catch {
    return null;
  }
}

const clean = (value: unknown, max: number) =>
  typeof value === 'string' && value.trim() ? value.trim().slice(0, max) : null;

/**
 * AI 1.2 (đặc tả 7.18, BF-20261028-010): chỉ chạy khi Parent bấm; kiểm tra
 * gói (`ai.enabled`, `aiPerMonth`), cài đặt AI của người dùng, đồng ý lần đầu
 * theo tính năng, rồi giữ chỗ hạn mức → gọi nhà cung cấp → trừ khi thành
 * công. Không lưu prompt / đầu ra; đầu ra luôn là bản nháp. Viết lại câu có
 * dấu hiệu không an toàn thì không gửi AI (nhánh an toàn 7.17.3).
 */
@Injectable()
export class AiService implements IAiService {
  constructor(
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(AI_REPOSITORY) private readonly repository: IAiRepository,
    @Inject(AI_PROVIDER) private readonly provider: IAiProvider,
    @Inject(DAY_STORY_RECAP_SERVICE)
    private readonly dayStories: IDayStoryRecapService,
    @Inject(BRIDGE_SERVICE) private readonly bridges: IBridgeService,
    @Inject(MISSION_BOARD_SERVICE)
    private readonly missions: IMissionBoardService,
  ) {}

  async status(actor: AuthPrincipal, familyId: string): Promise<AiStatusDto> {
    await this.access.requireParent(actor, familyId, 'read');
    const now = new Date();
    const [access, used, consented] = await Promise.all([
      this.repository.access(familyId, actor.userId),
      this.repository.used(familyId, monthOf(now), now),
      Promise.all(
        FEATURES.map(async (feature) =>
          (await this.repository.consent(
            actor.userId,
            AI_POLICY.consentDocument(feature),
            AI_POLICY.consentVersion,
          ))
            ? feature
            : null,
        ),
      ),
    ]);
    return {
      available:
        this.provider.configured() && access.planEnabled && access.userEnabled,
      used: Math.min(used, access.perMonth),
      total: access.perMonth,
      consented: consented.filter((item): item is AiFeature => item !== null),
    };
  }

  async consent(
    actor: AuthPrincipal,
    familyId: string,
    feature: string,
  ): Promise<AiStatusDto> {
    await this.access.requireParent(actor, familyId, 'write');
    const existing = await this.repository.consent(
      actor.userId,
      AI_POLICY.consentDocument(feature as AiFeature),
      AI_POLICY.consentVersion,
    );
    if (!existing)
      await this.repository.grantConsent(
        actor.userId,
        AI_POLICY.consentDocument(feature as AiFeature),
        AI_POLICY.consentVersion,
      );
    return this.status(actor, familyId);
  }

  async captions(
    actor: AuthPrincipal,
    familyId: string,
    input: AiCaptionDto,
  ): Promise<AiCaptionResultDto> {
    const user = [
      `Loại kỷ niệm: ${input.kind ?? 'ảnh'}.`,
      input.hint?.trim()
        ? `Vài từ cha mẹ gõ: "${input.hint.trim()}".`
        : 'Cha mẹ chưa gõ gì; gợi ý chú thích chung, ấm áp, không bịa chi tiết.',
    ].join('\n');
    const { json, invocationId } = await this.run(
      actor,
      familyId,
      'caption',
      user,
    );
    const list = Array.isArray(json.suggestions) ? json.suggestions : [];
    const suggestions = list
      .map((item) => clean(item, 120))
      .filter((item): item is string => item !== null)
      .slice(0, 3);
    if (!suggestions.length) throw badOutput();
    return { invocationId, suggestions };
  }

  async dayStory(
    actor: AuthPrincipal,
    familyId: string,
    input: AiDayStoryDto,
  ): Promise<AiStoryResultDto> {
    // Chỉ ký ức người dùng tick chọn và được xem (cùng quyền REC-01).
    const day = await this.dayStories.get(actor, input.childId, input.date);
    const chosen = new Set(input.memoryIds);
    const lines = day.memories
      .filter((memory) => chosen.has(memory.memoryId) && memory.title)
      .map((memory) => `- ${memory.title}`);
    if (!lines.length)
      throw new DomainError(
        'Choose at least one memory with a caption.',
        'AI_INPUT_EMPTY',
        400,
      );
    const { json, invocationId } = await this.run(
      actor,
      familyId,
      'dailyStory',
      `Các khoảnh khắc trong ngày ${input.date}:\n${lines.join('\n')}`,
    );
    const story = clean(json.story, 1200);
    if (!story) throw badOutput();
    return { invocationId, story };
  }

  async rewrite(
    actor: AuthPrincipal,
    familyId: string,
    input: AiRewriteDto,
  ): Promise<AiRewriteResultDto> {
    const text = input.text.trim();
    const lower = text.toLocaleLowerCase('vi');
    if (AI_SAFETY_KEYWORDS.some((keyword) => lower.includes(keyword))) {
      // Không gửi cho AI, không ghi lượt gọi (7.17.3).
      await this.access.requireParent(actor, familyId, 'read');
      return {
        invocationId: null,
        safety: true,
        neutral: null,
        warm: null,
        short: null,
      };
    }
    const { json, invocationId } = await this.run(
      actor,
      familyId,
      'gentleRewrite',
      `Câu gốc: "${text}"`,
    );
    const neutral = clean(json.neutral, AI_POLICY.rewriteMaxLength);
    const warm = clean(json.warm, AI_POLICY.rewriteMaxLength);
    const short = clean(json.short, AI_POLICY.rewriteMaxLength);
    if (!neutral && !warm && !short) throw badOutput();
    return { invocationId, safety: false, neutral, warm, short };
  }

  /**
   * Gợi ý nhiệm vụ (7.18): AI chỉ chọn trong các mẫu bé đủ điều kiện (cùng
   * bộ lọc CARE-04), dựa trên số việc đã xong theo nhóm 14 ngày qua; server
   * kiểm lại từng lựa chọn nên không có việc do AI bịa.
   */
  async missionSuggestions(
    actor: AuthPrincipal,
    familyId: string,
    input: AiMissionSuggestDto,
  ): Promise<AiMissionResultDto> {
    const excluded = new Set(input.excludeCategories ?? []);
    const { items } = await this.missions.templates(actor, {
      familyId,
      childId: input.childId,
    });
    const candidates = items
      .filter((item) => !excluded.has(item.category))
      .slice(0, AI_POLICY.missionCandidates);
    if (candidates.length < AI_POLICY.missionPicks.min)
      throw new DomainError(
        'Not enough missions to suggest from.',
        'AI_INPUT_EMPTY',
        400,
      );
    const since = new Date(
      Date.now() - AI_POLICY.missionHistoryDays * 86_400_000,
    );
    const done = await this.repository.recentMissionCategories(familyId, since);
    const list = candidates
      .map(
        (item, index) =>
          `${index + 1}. ${item.title} (nhóm ${item.category}, ${item.durationMin} phút)`,
      )
      .join('\n');
    const history = Object.entries(done)
      .map(([category, count]) => `${category}: ${count}`)
      .join(', ');
    const { json, invocationId } = await this.run(
      actor,
      familyId,
      'missionSuggest',
      `Danh sách việc:\n${list}\nĐã xong 14 ngày qua theo nhóm: ${history || 'chưa có'}.`,
    );
    const picks = Array.isArray(json.picks) ? json.picks : [];
    const seen = new Set<number>();
    const missions = picks
      .map((pick) => {
        const value = pick as { index?: unknown; reason?: unknown };
        const index = typeof value.index === 'number' ? value.index - 1 : -1;
        const item = candidates[index];
        if (!item || seen.has(index)) return null;
        seen.add(index);
        return {
          templateId: item.id,
          title: item.title,
          category: item.category,
          hearts: item.hearts,
          durationMin: item.durationMin,
          reason: clean(value.reason, 120) ?? '',
        };
      })
      .filter((item) => item !== null)
      .slice(0, AI_POLICY.missionPicks.max);
    if (!missions.length) throw badOutput();
    return { invocationId, missions };
  }

  async bridgeSummary(
    actor: AuthPrincipal,
    familyId: string,
    input: AiBridgeSummaryDto,
  ): Promise<AiSummaryResultDto> {
    // Chỉ các ý đã chia sẻ trong phiên (nháp riêng không có trên server).
    const session = await this.bridges.get(actor, familyId, input.sessionId);
    const lines = session.shares.map((share, index) =>
      [
        `Người ${index + 1}:`,
        share.feelings.length ? `cảm thấy ${share.feelings.join(', ')}` : '',
        share.needs.length ? `cần ${share.needs.join(', ')}` : '',
        share.topic ? `chủ đề "${share.topic}"` : '',
        share.message ? `nói: "${share.message}"` : '',
      ]
        .filter(Boolean)
        .join(' '),
    );
    if (!lines.length)
      throw new DomainError(
        'Nothing has been shared yet.',
        'AI_INPUT_EMPTY',
        400,
      );
    const { json, invocationId } = await this.run(
      actor,
      familyId,
      'bridgeSummary',
      lines.join('\n'),
    );
    const summary = clean(json.summary, 1200);
    if (!summary) throw badOutput();
    return { invocationId, summary };
  }

  /** Kiểm tra quyền + hạn mức, gọi nhà cung cấp, ghi metadata lượt gọi. */
  private async run(
    actor: AuthPrincipal,
    familyId: string,
    feature: AiFeature,
    userContent: string,
  ): Promise<{ json: Record<string, unknown>; invocationId: string }> {
    await this.access.requireParent(actor, familyId, 'write');
    if (!this.provider.configured())
      throw new DomainError(
        'AI is temporarily unavailable.',
        'AI_UNAVAILABLE',
        503,
      );
    const access = await this.repository.access(familyId, actor.userId);
    if (!access.planEnabled || access.perMonth <= 0)
      throw new DomainError(
        'AI is not included in the current plan.',
        'AI_NOT_IN_PLAN',
        403,
      );
    if (!access.userEnabled || access.features[feature] === false)
      throw new DomainError('AI is turned off.', 'AI_DISABLED', 403);
    const consentId = await this.repository.consent(
      actor.userId,
      AI_POLICY.consentDocument(feature),
      AI_POLICY.consentVersion,
    );
    if (!consentId)
      throw new DomainError(
        'Consent is required before using this AI feature.',
        'AI_CONSENT_REQUIRED',
        428,
      );
    const now = new Date();
    const reservation = await this.repository.reserve({
      familyId,
      userId: actor.userId,
      feature,
      promptVersion: AI_POLICY.promptVersion,
      model: this.provider.model(),
      consentId,
      month: monthOf(now),
      limit: access.perMonth,
      expiresAt: new Date(now.getTime() + AI_POLICY.reservationMs),
    });
    if (!reservation)
      throw new DomainError(
        'The monthly AI quota is used up.',
        'AI_QUOTA_EXCEEDED',
        429,
      );
    const started = Date.now();
    // `openrouter/free` định tuyến ngẫu nhiên: model có thể trả rỗng / sai
    // định dạng → thử lại trong cùng lượt hạn mức (BF-20261028-012).
    let lastError: unknown = null;
    let lastModel = this.provider.model();
    let tokens: { inputTokens: number | null; outputTokens: number | null } = {
      inputTokens: null,
      outputTokens: null,
    };
    for (let attempt = 0; attempt < AI_POLICY.attempts; attempt += 1) {
      try {
        const result = await this.provider.complete({
          system: AI_PROMPTS[feature],
          user: userContent,
          maxTokens: AI_POLICY.maxOutputTokens,
        });
        lastModel = result.model;
        tokens = {
          inputTokens: result.inputTokens,
          outputTokens: result.outputTokens,
        };
        const json = jsonOf(result.text);
        if (json) {
          await this.repository.finish(reservation, {
            status: 'SUCCEEDED',
            model: result.model,
            ...tokens,
            durationMs: Date.now() - started,
            errorCode: null,
          });
          return { json, invocationId: reservation.invocationId };
        }
        lastError = badOutput();
      } catch (error) {
        lastError = error;
      }
    }
    await this.repository.finish(reservation, {
      status: 'FAILED',
      model: lastModel,
      ...tokens,
      durationMs: Date.now() - started,
      errorCode:
        lastError instanceof DomainError ? lastError.code : 'AI_PROVIDER_ERROR',
    });
    throw lastError instanceof DomainError ? lastError : badOutput();
  }
}

function badOutput() {
  return new DomainError(
    'The AI answer could not be used. Please try again.',
    'AI_BAD_OUTPUT',
    502,
  );
}
