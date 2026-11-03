import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DomainError } from '../common/errors/domain.error';
import type {
  AiCompletion,
  IAiProvider,
} from '../interfaces/services/ai-provider.interface';

const unavailable = () =>
  new DomainError('AI is temporarily unavailable.', 'AI_UNAVAILABLE', 503);

/**
 * OpenRouter qua API tương thích OpenAI (`POST {AI_BASE_URL}/chat/completions`).
 * Không ghi log prompt / đầu ra / key; lỗi nhà cung cấp → 503 `AI_UNAVAILABLE`.
 */
@Injectable()
export class AiProviderService implements IAiProvider {
  constructor(private readonly config: ConfigService) {}

  configured(): boolean {
    return Boolean(this.config.get<string>('AI_API_KEY'));
  }

  model(): string {
    return this.config.get<string>('AI_MODEL') ?? 'openrouter/free';
  }

  async complete(input: {
    system: string;
    user: string;
    maxTokens: number;
  }): Promise<AiCompletion> {
    const key = this.config.get<string>('AI_API_KEY');
    if (!key) throw unavailable();
    const base = (
      this.config.get<string>('AI_BASE_URL') ?? 'https://openrouter.ai/api/v1'
    ).replace(/\/+$/, '');
    let response: Response;
    try {
      response = await fetch(`${base}/chat/completions`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${key}`,
          'Content-Type': 'application/json',
          'X-Title': 'Baby Family',
        },
        body: JSON.stringify({
          model: this.model(),
          max_tokens: input.maxTokens,
          temperature: 0.7,
          messages: [
            { role: 'system', content: input.system },
            { role: 'user', content: input.user },
          ],
        }),
        signal: AbortSignal.timeout(
          this.config.get<number>('AI_TIMEOUT_MS') ?? 30000,
        ),
      });
    } catch {
      throw unavailable();
    }
    if (!response.ok) {
      void response.body?.cancel().catch(() => undefined);
      throw unavailable();
    }
    const body = (await response.json().catch(() => null)) as {
      model?: string;
      choices?: { message?: { content?: unknown } }[];
      usage?: { prompt_tokens?: number; completion_tokens?: number };
    } | null;
    const text = body?.choices?.[0]?.message?.content;
    if (typeof text !== 'string' || !text.trim()) throw unavailable();
    return {
      text,
      model: (body?.model ?? this.model()).slice(0, 100),
      inputTokens: body?.usage?.prompt_tokens ?? null,
      outputTokens: body?.usage?.completion_tokens ?? null,
    };
  }
}
