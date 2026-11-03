import { ConfigService } from '@nestjs/config';
import { AiProviderService } from '../../src/services/ai-provider.service';

/** BF-20261028-010: client OpenRouter (API tương thích OpenAI). */
describe('AiProviderService', () => {
  afterEach(() => jest.restoreAllMocks());
  const configured = (extra: Record<string, unknown> = {}) =>
    new AiProviderService(
      new ConfigService({
        AI_API_KEY: 'test-key-not-a-secret-000000',
        AI_BASE_URL: 'https://openrouter.ai/api/v1/',
        AI_MODEL: 'openrouter/free',
        AI_TIMEOUT_MS: 5000,
        ...extra,
      }),
    );

  it('is unavailable without a key and never calls the network', async () => {
    const fetcher = jest.spyOn(globalThis, 'fetch');
    const service = new AiProviderService(new ConfigService({}));
    expect(service.configured()).toBe(false);
    await expect(
      service.complete({ system: 's', user: 'u', maxTokens: 10 }),
    ).rejects.toMatchObject({ code: 'AI_UNAVAILABLE', statusCode: 503 });
    expect(fetcher).not.toHaveBeenCalled();
  });

  it('posts a chat completion and reads text and token usage', async () => {
    const fetcher = jest.spyOn(globalThis, 'fetch').mockResolvedValue(
      new Response(
        JSON.stringify({
          model: 'some/free-model',
          choices: [{ message: { content: '{"summary":"ok"}' } }],
          usage: { prompt_tokens: 7, completion_tokens: 3 },
        }),
        { status: 200 },
      ),
    );
    const result = await configured().complete({
      system: 'sys',
      user: 'hello',
      maxTokens: 50,
    });
    expect(result).toEqual({
      text: '{"summary":"ok"}',
      model: 'some/free-model',
      inputTokens: 7,
      outputTokens: 3,
    });
    const [url, options] = fetcher.mock.calls[0]!;
    expect(url).toBe('https://openrouter.ai/api/v1/chat/completions');
    const headers = options?.headers as Record<string, string>;
    expect(headers.Authorization).toBe('Bearer test-key-not-a-secret-000000');
    const body = JSON.parse(options?.body as string) as {
      model: string;
      max_tokens: number;
      messages: { role: string }[];
    };
    expect(body).toMatchObject({ model: 'openrouter/free', max_tokens: 50 });
    expect(body.messages.map((m) => m.role)).toEqual(['system', 'user']);
  });

  it('maps provider errors and empty answers to AI_UNAVAILABLE', async () => {
    jest
      .spyOn(globalThis, 'fetch')
      .mockResolvedValueOnce(new Response('rate limited', { status: 429 }))
      .mockResolvedValueOnce(
        new Response(JSON.stringify({ choices: [] }), { status: 200 }),
      )
      .mockRejectedValueOnce(new Error('network down'));
    for (let i = 0; i < 3; i += 1)
      await expect(
        configured().complete({ system: 's', user: 'u', maxTokens: 10 }),
      ).rejects.toMatchObject({ code: 'AI_UNAVAILABLE' });
  });
});
