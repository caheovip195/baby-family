export const AI_PROVIDER = Symbol('AI_PROVIDER');

export interface AiCompletion {
  text: string;
  model: string;
  inputTokens: number | null;
  outputTokens: number | null;
}

/** Nhà cung cấp chat completion (OpenRouter / tương thích OpenAI). */
export interface IAiProvider {
  configured(): boolean;
  /** Mã model đang dùng (ghi metadata lượt gọi). */
  model(): string;
  complete(input: {
    system: string;
    user: string;
    maxTokens: number;
  }): Promise<AiCompletion>;
}
