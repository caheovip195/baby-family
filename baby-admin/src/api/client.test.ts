import { AdminApiError, getSession, request, setSession } from './client';

const json = (status: number, body: unknown) =>
  Promise.resolve(new Response(JSON.stringify(body), { status }));

describe('admin api client', () => {
  beforeEach(() => setSession(null));

  it('unwraps the data envelope and sends the admin bearer token', async () => {
    setSession({
      accessToken: 'admin-token',
      expiresAt: new Date(Date.now() + 60_000).toISOString(),
      admin: { id: 'a', roles: ['SUPPORT'] },
    });
    const fetcher = vi.fn(() => json(200, { data: { ok: true } }));
    await expect(request('GET', '/x', undefined, fetcher)).resolves.toEqual({ ok: true });
    const [url, init] = fetcher.mock.calls[0] as unknown as [string, RequestInit];
    expect(url).toBe('/admin/v1/x');
    expect((init.headers as Record<string, string>).Authorization).toBe('Bearer admin-token');
  });

  it('maps errors to stable codes and drops the session on 401', async () => {
    setSession({
      accessToken: 't',
      expiresAt: new Date(Date.now() + 60_000).toISOString(),
      admin: { id: 'a', roles: [] },
    });
    const fetcher = vi.fn(() =>
      json(401, { error: { code: 'ADMIN_SESSION_INVALID', message: 'expired' } }),
    );
    const error = await request('GET', '/x', undefined, fetcher).catch((e: unknown) => e);
    expect(error).toBeInstanceOf(AdminApiError);
    expect((error as AdminApiError).code).toBe('ADMIN_SESSION_INVALID');
    expect(getSession()).toBeNull();
  });

  it('ignores an expired stored session', () => {
    setSession({
      accessToken: 't',
      expiresAt: new Date(Date.now() - 1).toISOString(),
      admin: { id: 'a', roles: [] },
    });
    expect(getSession()).toBeNull();
  });
});
