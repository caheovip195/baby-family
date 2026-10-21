import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { App as AntApp } from 'antd';
import { MemoryRouter } from 'react-router-dom';
import { App, canUse } from './App';
import { setSession } from './api/client';

const renderApp = (path = '/') =>
  render(
    <AntApp>
      <MemoryRouter initialEntries={[path]}>
        <App />
      </MemoryRouter>
    </AntApp>,
  );

describe('admin app', () => {
  afterEach(() => {
    setSession(null);
    vi.unstubAllGlobals();
  });

  it('shows only the sections a role may use', () => {
    expect(canUse(['SUPPORT'], ['OPS', 'BILLING_OPS'])).toBe(false);
    expect(canUse(['SUPER_ADMIN'], ['OPS'])).toBe(true);
    expect(canUse(['MODERATOR'], ['MODERATOR', 'SUPPORT'])).toBe(true);
  });

  it('logs in with email, password and TOTP, then opens the first section', async () => {
    const fetcher = vi.fn((url: string) =>
      Promise.resolve(
        new Response(
          JSON.stringify(
            url.includes('/auth/login')
              ? {
                  data: {
                    accessToken: 't',
                    expiresAt: new Date(Date.now() + 60_000).toISOString(),
                    admin: { id: 'a', roles: ['MODERATOR'] },
                  },
                }
              : { data: { items: [], total: 0 } },
          ),
          { status: 200 },
        ),
      ),
    );
    vi.stubGlobal('fetch', fetcher);
    renderApp();
    await userEvent.type(screen.getByLabelText('Email'), 'ops@example.test');
    await userEvent.type(screen.getByLabelText('Mật khẩu'), 'secret');
    await userEvent.type(screen.getByLabelText('Mã xác thực (TOTP)'), '123456');
    await userEvent.click(screen.getByRole('button', { name: /Đăng nhập/ }));
    expect(await screen.findByText('Ca kiểm duyệt')).toBeInTheDocument();
    const login = JSON.parse(String((fetcher.mock.calls[0] as unknown as [string, RequestInit])[1].body));
    expect(login).toEqual({ email: 'ops@example.test', password: 'secret', totp: '123456' });
    // Moderators do not see licence or support sections.
    expect(screen.queryByText('Khoá license')).not.toBeInTheDocument();
  });

  it('lists moderation cases from the API', async () => {
    setSession({
      accessToken: 't',
      expiresAt: new Date(Date.now() + 60_000).toISOString(),
      admin: { id: 'a', roles: ['MODERATOR'] },
    });
    vi.stubGlobal(
      'fetch',
      vi.fn(() =>
        Promise.resolve(
          new Response(
            JSON.stringify({
              data: {
                total: 1,
                items: [
                  {
                    id: '11111111-1111-4111-8111-111111111111',
                    targetType: 'MEMORY',
                    targetId: '22222222-2222-4222-8222-222222222222',
                    priority: 1,
                    status: 'OPEN',
                    assigneeAdminId: null,
                    slaDueAt: new Date().toISOString(),
                    resolvedAt: null,
                    createdAt: new Date().toISOString(),
                  },
                ],
              },
            }),
            { status: 200 },
          ),
        ),
      ),
    );
    renderApp('/moderation');
    expect(await screen.findByText('MEMORY · 22222222')).toBeInTheDocument();
  });
});
