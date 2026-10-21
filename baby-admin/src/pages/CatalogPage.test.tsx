import {
  render,
  screen,
  waitFor,
  cleanup,
  fireEvent,
} from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { App } from 'antd';
import { CatalogPage, catalogState } from './CatalogPage';
import { adminApi } from '../api/admin';
import { setSession } from '../api/client';
import { canWriteCatalog, catalogPayload } from '../components/catalog-form';

const mount = (roles = ['CONTENT'], rows: Record<string, unknown>[] = []) => {
  setSession({
    accessToken: 't',
    expiresAt: new Date(Date.now() + 60_000).toISOString(),
    admin: { id: 'a', roles },
  });
  vi.spyOn(adminApi, 'catalog').mockResolvedValue({
    kind: 'missions',
    mutationSupported: true,
    items: rows,
  });
  vi.spyOn(adminApi, 'catalogDrafts').mockResolvedValue({
    kind: 'plan-versions',
    items: [],
  });
  return render(
    <App>
      <CatalogPage />
    </App>,
  );
};
beforeEach(() => {
  const computed = window.getComputedStyle.bind(window);
  vi.spyOn(window, 'getComputedStyle').mockImplementation((element) =>
    computed(element),
  );
});
afterEach(() => {
  cleanup();
  vi.restoreAllMocks();
  setSession(null);
});

describe('catalog publishing', () => {
  it('restricts write controls by catalog role, including billing ops', () => {
    expect(canWriteCatalog('missions', ['CONTENT'])).toBe(true);
    expect(canWriteCatalog('missions', ['OPS'])).toBe(false);
    expect(canWriteCatalog('plan-versions', ['CONTENT'])).toBe(false);
    expect(canWriteCatalog('trial-policies', ['BILLING_OPS'])).toBe(true);
    expect(canWriteCatalog('plan-versions', ['OPS'])).toBe(true);
    expect(canWriteCatalog('milestones', ['SUPER_ADMIN'])).toBe(false);
  });
  it('requires a reason before publishing and refreshes after success', async () => {
    const publish = vi.spyOn(adminApi, 'transitionCatalog').mockResolvedValue({
      kind: 'missions',
      item: { code: 'draft', status: 'PUBLISHED' },
    });
    mount(['CONTENT'], [{ code: 'draft', status: 'DRAFT' }]);
    await userEvent.click(
      await screen.findByRole('button', { name: 'Publish' }),
    );
    await userEvent.click(screen.getByRole('button', { name: 'Xác nhận' }));
    expect(
      await screen.findByText('Nhập lý do từ 1 đến 80 ký tự.'),
    ).toBeInTheDocument();
    expect(publish).not.toHaveBeenCalled();
    await userEvent.type(screen.getByLabelText('Lý do'), 'Đã duyệt');
    await userEvent.click(screen.getByRole('button', { name: 'Xác nhận' }));
    await waitFor(() =>
      expect(publish).toHaveBeenCalledWith('missions', 'draft', 'publish', {
        reason: 'Đã duyệt',
      }),
    );
    await waitFor(() => expect(adminApi.catalog).toHaveBeenCalledTimes(2));
  });
  it('retires published missions without offering publish or edit', async () => {
    const retire = vi.spyOn(adminApi, 'transitionCatalog').mockResolvedValue({
      kind: 'missions',
      item: { code: 'old', status: 'RETIRED' },
    });
    mount(['CONTENT'], [{ code: 'old', status: 'ACTIVE', rolloutPct: 100 }]);
    await userEvent.click(
      await screen.findByRole('button', { name: 'Ngừng dùng' }),
    );
    expect(
      screen.queryByRole('button', { name: 'Publish' }),
    ).not.toBeInTheDocument();
    await userEvent.type(screen.getByLabelText('Lý do'), 'Thay bằng mẫu mới');
    await userEvent.click(screen.getByRole('button', { name: 'Xác nhận' }));
    await waitFor(() =>
      expect(retire).toHaveBeenCalledWith('missions', 'old', 'retire', {
        reason: 'Thay bằng mẫu mới',
      }),
    );
  });
  it('loads billing drafts and creates typed plan version', async () => {
    const create = vi.spyOn(adminApi, 'createCatalog').mockResolvedValue({
      kind: 'plan-versions',
      item: { id: 'p', status: 'DRAFT' },
    });
    mount(['BILLING_OPS']);
    await userEvent.click(screen.getByRole('tab', { name: 'Phiên bản gói' }));
    await waitFor(() =>
      expect(adminApi.catalogDrafts).toHaveBeenCalledWith('plan-versions'),
    );
    await userEvent.click(
      await screen.findByRole('button', { name: 'Tạo mới' }),
    );
    await userEvent.type(
      screen.getByLabelText('ID gói'),
      '00000000-0000-4000-8000-000000000001',
    );
    await userEvent.type(screen.getByLabelText('Lý do'), 'Gói mới');
    await userEvent.click(screen.getByRole('button', { name: 'Tạo bản nháp' }));
    await waitFor(() =>
      expect(create).toHaveBeenCalledWith('plan-versions', {
        planId: '00000000-0000-4000-8000-000000000001',
        version: 1,
        entitlementRank: 0,
        quotas: {},
        features: {},
        reason: 'Gói mới',
      }),
    );
  });
  it('publishes billing drafts only with an effective date and reason', async () => {
    const publish = vi.spyOn(adminApi, 'transitionCatalog').mockResolvedValue({
      kind: 'trial-policies',
      item: { id: 't', status: 'PUBLISHED' },
    });
    mount(['BILLING_OPS']);
    vi.mocked(adminApi.catalogDrafts).mockResolvedValue({
      kind: 'trial-policies',
      items: [{ id: 't', code: 'trial-v2', status: 'DRAFT' }],
    });
    await userEvent.click(
      screen.getByRole('tab', { name: 'Chính sách dùng thử' }),
    );
    await userEvent.click(
      await screen.findByRole('button', { name: 'Publish' }),
    );
    await userEvent.type(screen.getByLabelText('Lý do'), 'Duyệt chính sách');
    await userEvent.click(screen.getByRole('button', { name: 'Xác nhận' }));
    expect(
      await screen.findByText('Chọn thời điểm có hiệu lực.'),
    ).toBeInTheDocument();
    expect(publish).not.toHaveBeenCalled();
    fireEvent.change(screen.getByLabelText('Có hiệu lực từ (giờ địa phương)'), {
      target: { value: '2026-11-01T09:00' },
    });
    await userEvent.click(screen.getByRole('button', { name: 'Xác nhận' }));
    await waitFor(() =>
      expect(publish).toHaveBeenCalledWith('trial-policies', 't', 'publish', {
        reason: 'Duyệt chính sách',
        availableFrom: new Date('2026-11-01T09:00').toISOString(),
      }),
    );
  });
  it('creates a mission with both translations and nullable age ranges', async () => {
    const create = vi.spyOn(adminApi, 'createCatalog').mockResolvedValue({
      kind: 'missions',
      item: { code: 'm2', status: 'DRAFT' },
    });
    mount();
    await userEvent.click(screen.getByRole('button', { name: 'Tạo mới' }));
    for (const [label, value] of [
      ['Mã mới', 'm2'],
      ['Tên (vi)', 'Chơi cùng bé'],
      ['Tên (en)', 'Play together'],
      ['Mô tả (vi)', 'Chơi năm phút'],
      ['Mô tả (en)', 'Play five minutes'],
      ['Lý do', 'Mẫu mới'],
    ]) {
      fireEvent.change(screen.getByLabelText(label), { target: { value } });
    }
    await userEvent.click(screen.getByRole('button', { name: 'Tạo bản nháp' }));
    await waitFor(() =>
      expect(create).toHaveBeenCalledWith(
        'missions',
        expect.objectContaining({
          code: 'm2',
          titleI18n: { vi: 'Chơi cùng bé', en: 'Play together' },
          minAgeDays: null,
          reason: 'Mẫu mới',
        }),
      ),
    );
  });
  it('shows unsupported notice for catalogs without version and keeps read-only for support', async () => {
    mount(['SUPPORT']);
    expect(
      screen.queryByRole('button', { name: 'Tạo mới' }),
    ).not.toBeInTheDocument();
    await userEvent.click(screen.getByRole('tab', { name: 'Cột mốc' }));
    expect(
      await screen.findByText(
        'Chưa hỗ trợ tạo/publish: schema catalog này chưa có phiên bản.',
      ),
    ).toBeInTheDocument();
  });
  it('serializes ranges, JSON quotas and reminders without plan-name assumptions', () => {
    expect(
      catalogPayload('missions', {
        code: 'm',
        memoryPromptI18n: { vi: '', en: '' },
      }),
    ).toMatchObject({
      minAgeDays: null,
      maxAgeDays: null,
      minPregWeek: null,
      maxPregWeek: null,
      tags: [],
      memoryPromptI18n: undefined,
    });
    expect(
      catalogPayload('plan-versions', {
        quotas: '{"storage.maxBytes":123}',
        features: '{"circle.enabled":true}',
      }),
    ).toEqual({
      quotas: { 'storage.maxBytes': 123 },
      features: { 'circle.enabled': true },
    });
    expect(
      catalogPayload('trial-policies', {
        durationSeconds: 86400,
        reminderOffsets: '3600, 7200',
      }),
    ).toEqual({ durationSeconds: 86400, reminderOffsetsSeconds: [3600, 7200] });
    expect(catalogState('missions', { status: 'ACTIVE', rolloutPct: 0 })).toBe(
      'ACTIVE',
    );
    expect(catalogState('trial-policies', { publishedAt: '2026-10-21' })).toBe(
      'PUBLISHED',
    );
    expect(catalogState('plan-versions', { retiredAt: '2026-10-21' })).toBe(
      'RETIRED',
    );
  });
});
