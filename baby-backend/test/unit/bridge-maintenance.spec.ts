import { JOBS, SCHEDULES } from '../../src/config/jobs';
import type { IBridgeRepository } from '../../src/interfaces/repositories/bridge-repository.interface';
import { BridgeMaintenanceService } from '../../src/services/bridge-maintenance.service';

/** BF-20261028-009: Cầu nối tự xoá nội dung đúng hạn kể cả khi không ai mở app. */
describe('BridgeMaintenanceService', () => {
  it('housekeeps every family on an hourly maintenance schedule', async () => {
    const housekeep = jest.fn().mockResolvedValue({ expired: 1, purged: 2 });
    const service = new BridgeMaintenanceService({
      housekeep,
    } as unknown as IBridgeRepository);
    const now = new Date('2026-10-28T00:00:00Z');
    await expect(service.housekeep(now)).resolves.toEqual({
      expired: 1,
      purged: 2,
    });
    expect(housekeep).toHaveBeenCalledWith(null, now);
    expect(
      SCHEDULES.find((item) => item.job === JOBS.bridgeHousekeep)?.everyMs,
    ).toBe(60 * 60 * 1000);
  });
});
