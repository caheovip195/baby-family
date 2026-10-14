export interface AuthSessionStateAttributes {
  userId: string;
  sessionId: string;
  tokenVersion: number;
}

/** Authentication projection; deliberately contains no credentials or token hash. */
export class AuthSessionState implements AuthSessionStateAttributes {
  readonly userId: string;
  readonly sessionId: string;
  readonly tokenVersion: number;

  constructor(attributes: AuthSessionStateAttributes) {
    this.userId = attributes.userId;
    this.sessionId = attributes.sessionId;
    this.tokenVersion = attributes.tokenVersion;
  }
}
