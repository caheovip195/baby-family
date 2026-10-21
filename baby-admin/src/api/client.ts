/**
 * Admin API client (`/admin/v1`, separate auth from the app). Responses use the
 * backend envelope `{ data }`; errors `{ error: { code, message } }`.
 * The session token lives in sessionStorage only (15-minute admin session).
 */
const TOKEN_KEY = 'bf-admin-session';

export interface AdminSession {
  accessToken: string;
  expiresAt: string;
  admin: { id: string; roles: string[] };
}

export class AdminApiError extends Error {
  constructor(
    readonly status: number,
    readonly code: string,
    message: string,
  ) {
    super(message);
  }
}

type Listener = () => void;
const listeners = new Set<Listener>();

export function onSessionChange(listener: Listener): () => void {
  listeners.add(listener);
  return () => listeners.delete(listener);
}

export function getSession(): AdminSession | null {
  try {
    const raw = sessionStorage.getItem(TOKEN_KEY);
    if (!raw) return null;
    const session = JSON.parse(raw) as AdminSession;
    return new Date(session.expiresAt).getTime() > Date.now() ? session : null;
  } catch {
    return null;
  }
}

export function setSession(session: AdminSession | null): void {
  try {
    if (session) sessionStorage.setItem(TOKEN_KEY, JSON.stringify(session));
    else sessionStorage.removeItem(TOKEN_KEY);
  } catch {
    // Storage blocked: the session simply does not survive a reload.
  }
  listeners.forEach((listener) => listener());
}

export async function request<T>(
  method: 'GET' | 'POST' | 'PATCH',
  path: string,
  body?: unknown,
  fetcher: typeof fetch = fetch,
): Promise<T> {
  const session = getSession();
  const response = await fetcher(`/admin/v1${path}`, {
    method,
    headers: {
      Accept: 'application/json',
      ...(body === undefined ? {} : { 'Content-Type': 'application/json' }),
      ...(session ? { Authorization: `Bearer ${session.accessToken}` } : {}),
    },
    body: body === undefined ? undefined : JSON.stringify(body),
  });
  if (response.status === 204) return undefined as T;
  const json = (await response.json().catch(() => ({}))) as {
    data?: T;
    error?: { code?: string; message?: string };
  };
  if (!response.ok) {
    // Expired/revoked session: back to the login screen.
    if (response.status === 401) setSession(null);
    throw new AdminApiError(
      response.status,
      json.error?.code ?? `HTTP_${response.status}`,
      json.error?.message ?? response.statusText,
    );
  }
  return json.data as T;
}
