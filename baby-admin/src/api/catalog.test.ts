import { adminApi } from './admin';
import { catalogPayload } from '../components/catalog-form';

afterEach(() => vi.unstubAllGlobals());

it('uses publishing endpoints and sends typed plan/trial payloads without touching Store products', async () => {
  const fetcher = vi.fn().mockResolvedValue(
    new Response(
      JSON.stringify({
        data: { kind: 'trial-policies', item: { id: 'draft' }, items: [] },
      }),
      { status: 200 },
    ),
  );
  vi.stubGlobal('fetch', fetcher);
  const payload = catalogPayload('trial-policies', {
    code: 'trial-new',
    version: 2,
    planVersionId: 'plan-v2',
    durationSeconds: 604800,
    reminderOffsets: '86400',
    reason: 'Phiên bản mới',
  });
  await adminApi.createCatalog('trial-policies', payload);
  expect(fetcher).toHaveBeenLastCalledWith(
    '/admin/v1/catalog/trial-policies',
    expect.objectContaining({
      method: 'POST',
      body: JSON.stringify({
        code: 'trial-new',
        version: 2,
        planVersionId: 'plan-v2',
        durationSeconds: 604800,
        reason: 'Phiên bản mới',
        reminderOffsetsSeconds: [86400],
      }),
    }),
  );
  fetcher.mockResolvedValue(
    new Response(JSON.stringify({ data: { items: [] } }), { status: 200 }),
  );
  await adminApi.catalogDrafts('plan-versions');
  expect(fetcher).toHaveBeenLastCalledWith(
    '/admin/v1/catalog/publishing/plan-versions',
    expect.objectContaining({ method: 'GET' }),
  );
  fetcher.mockResolvedValue(
    new Response(JSON.stringify({ data: {} }), { status: 200 }),
  );
  await adminApi.transitionCatalog('missions', 'm/code', 'retire', {
    reason: 'Đổi phiên bản',
  });
  expect(fetcher).toHaveBeenLastCalledWith(
    '/admin/v1/catalog/missions/m%2Fcode/retire',
    expect.objectContaining({
      method: 'POST',
      body: JSON.stringify({ reason: 'Đổi phiên bản' }),
    }),
  );
});
