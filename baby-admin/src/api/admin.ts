import { request, setSession, type AdminSession } from './client';

export interface Page<T> {
  items: T[];
  total?: number;
  nextOffset?: number | null;
}

export interface ModerationCase {
  id: string;
  targetType: string;
  targetId: string;
  priority: number;
  status: string;
  assigneeAdminId: string | null;
  slaDueAt: string;
  resolvedAt: string | null;
  createdAt: string;
  reports?: {
    id: string;
    reason: string;
    detail: string | null;
    severity: number;
    status: string;
    createdAt: string;
  }[];
  actions?: {
    id: string;
    adminId: string;
    action: string;
    createdAt: string;
  }[];
}

export interface CaseContent {
  caseId: string;
  targetType: string;
  targetId: string;
  content: {
    id: string;
    title?: string | null;
    body: string | null;
    status: string;
  };
}

export interface TicketMetadata {
  id: string;
  requesterUserId: string | null;
  familyId: string | null;
  category: string;
  status: string;
  assignedAdminId: string | null;
  createdAt: string;
  updatedAt: string;
  closedAt: string | null;
}

export interface TicketDetail {
  id: string;
  code: string;
  status: string;
  category: string;
  subject: string;
  body: string;
  createdAt: string;
  messages: {
    id: string;
    sender: 'USER' | 'SUPPORT';
    body: string;
    createdAt: string;
  }[];
}

export interface CatalogPage extends Page<Record<string, unknown>> {
  kind: string;
  mutationSupported: boolean;
}

export const CASE_STATUSES = [
  'OPEN',
  'IN_REVIEW',
  'ESCALATED',
  'RESOLVED',
] as const;
export const TICKET_STATUSES = [
  'OPEN',
  'IN_PROGRESS',
  'WAITING_USER',
  'RESOLVED',
  'CLOSED',
] as const;
export const CATALOG_KINDS = [
  'missions',
  'milestones',
  'notification-templates',
  'plan-versions',
  'trial-policies',
] as const;

const query = (params: Record<string, string | number | undefined>) => {
  const entries = Object.entries(params).filter(
    ([, v]) => v !== undefined && v !== '',
  );
  return entries.length
    ? `?${new URLSearchParams(entries.map(([k, v]) => [k, String(v)])).toString()}`
    : '';
};

export const adminApi = {
  async login(email: string, password: string, totp: string) {
    const session = await request<AdminSession>('POST', '/auth/login', {
      email,
      password,
      totp,
    });
    setSession(session);
    return session;
  },
  async logout() {
    try {
      await request<void>('POST', '/auth/logout');
    } finally {
      setSession(null);
    }
  },
  cases: (status?: string, offset = 0, limit = 25) =>
    request<Page<ModerationCase>>(
      'GET',
      `/moderation/cases${query({ status, offset, limit })}`,
    ),
  caseDetail: (id: string) =>
    request<ModerationCase>('GET', `/moderation/cases/${id}`),
  caseContent: (id: string, reason: string) =>
    request<CaseContent>('POST', `/moderation/cases/${id}/content`, { reason }),
  caseStatus: (id: string, status: string, reason: string) =>
    request<ModerationCase>('PATCH', `/moderation/cases/${id}/status`, {
      status,
      reason,
    }),
  hideContent: (id: string, reason: string) =>
    request<ModerationCase>('POST', `/moderation/cases/${id}/actions`, {
      action: 'HIDE',
      reason,
    }),
  license: (
    familyId: string,
    blocked: boolean,
    reasonCode: string,
    reason: string,
  ) =>
    request<{
      familyId: string;
      blockedAt: string | null;
      blockReasonCode: string | null;
    }>(
      'POST',
      `/families/${familyId}/license/${blocked ? 'block' : 'unblock'}`,
      { reasonCode, reason },
    ),
  tickets: (status?: string, offset = 0, limit = 50) =>
    request<Page<TicketMetadata>>(
      'GET',
      `/support/tickets${query({ status, offset, limit })}`,
    ),
  ticketDetail: (id: string, reasonCode: string) =>
    request<TicketDetail>(
      'GET',
      `/support/tickets/${id}${query({ reasonCode })}`,
    ),
  ticketReply: (id: string, body: string, reasonCode: string) =>
    request<{ id: string }>('POST', `/support/tickets/${id}/messages`, {
      body,
      reasonCode,
    }),
  ticketStatus: (id: string, status: string, reasonCode: string) =>
    request<TicketMetadata>('PATCH', `/support/tickets/${id}/status`, {
      status,
      reasonCode,
    }),
  createCatalog: (kind: string, body: Record<string, unknown>) =>
    request<{ kind: string; item: Record<string, unknown> }>(
      'POST',
      `/catalog/${kind}`,
      body,
    ),
  catalogDrafts: (kind: string) =>
    request<{ kind: string; items: Record<string, unknown>[] }>(
      'GET',
      `/catalog/publishing/${kind}`,
    ),
  transitionCatalog: (
    kind: string,
    id: string,
    action: 'publish' | 'retire',
    body: { reason: string; availableFrom?: string },
  ) =>
    request<{ kind: string; item: Record<string, unknown> }>(
      'POST',
      `/catalog/${kind}/${encodeURIComponent(id)}/${action}`,
      body,
    ),
  catalog: (kind: string, offset = 0, limit = 50) =>
    request<CatalogPage>('GET', `/catalog/${kind}${query({ offset, limit })}`),
};
