export type NotificationParams = Record<string, string | string[] | number>;

export class NotificationInboxModel {
  constructor(
    readonly id: string,
    readonly tab: 'FAMILY' | 'US',
    readonly category: string,
    readonly templateCode: string,
    readonly params: NotificationParams,
    readonly createdAt: Date,
    readonly readAt: Date | null,
    readonly deepLink: string,
  ) {}
}
