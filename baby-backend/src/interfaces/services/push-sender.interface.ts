export const PUSH_SENDER = Symbol('PUSH_SENDER');

export interface PushMessage {
  token: string;
  title: string;
  body: string;
  data: { notificationId: string; deepLink: string };
}

export type PushSendResult =
  | { status: 'sent'; messageId: string }
  | {
      status: 'invalid-token' | 'permanent' | 'transient' | 'disabled';
      code: string;
    };

/** Provider failures are sanitized codes, never raw responses/tokens/content. */
export interface IPushSender {
  send(message: PushMessage, signal: AbortSignal): Promise<PushSendResult>;
}
