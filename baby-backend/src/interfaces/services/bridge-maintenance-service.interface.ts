export const BRIDGE_MAINTENANCE_SERVICE = Symbol('BRIDGE_MAINTENANCE_SERVICE');

export interface IBridgeMaintenanceService {
  /** Mọi gia đình: phiên bỏ dở 14 ngày → EXPIRED; quá thời hạn lưu → xoá nội dung. */
  housekeep(now: Date): Promise<Record<string, number>>;
}
