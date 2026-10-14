/** Created from a verified access token and a live database session, never HTTP input. */
export interface AuthPrincipal {
  readonly userId: string;
  readonly sessionId: string;
  readonly tokenVersion: number;
}

export const AUTH_PRINCIPAL = Symbol('AUTH_PRINCIPAL');
