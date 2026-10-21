import { useEffect, useState } from 'react';
import { Button, Layout, Menu, Space, Typography } from 'antd';
import {
  AppstoreOutlined,
  CustomerServiceOutlined,
  LockOutlined,
  SafetyOutlined,
} from '@ant-design/icons';
import {
  Navigate,
  Route,
  Routes,
  useLocation,
  useNavigate,
} from 'react-router-dom';
import { adminApi } from './api/admin';
import { getSession, onSessionChange, type AdminSession } from './api/client';
import { LoginPage } from './pages/LoginPage';
import { CasesPage } from './pages/CasesPage';
import { LicensePage } from './pages/LicensePage';
import { TicketsPage } from './pages/TicketsPage';
import { CatalogPage } from './pages/CatalogPage';

/** Menu entries and the admin roles allowed to use them (backend enforces). */
const SECTIONS = [
  {
    key: '/moderation',
    label: 'Kiểm duyệt',
    icon: <SafetyOutlined />,
    roles: ['MODERATOR', 'SUPPORT', 'OPS'],
  },
  {
    key: '/licenses',
    label: 'Khoá license',
    icon: <LockOutlined />,
    roles: ['OPS', 'BILLING_OPS'],
  },
  {
    key: '/support',
    label: 'Hỗ trợ khách hàng',
    icon: <CustomerServiceOutlined />,
    roles: ['SUPPORT'],
  },
  {
    key: '/catalog',
    label: 'Catalog',
    icon: <AppstoreOutlined />,
    roles: ['CONTENT', 'OPS', 'BILLING_OPS'],
  },
];

export function canUse(roles: string[], allowed: string[]): boolean {
  return (
    roles.includes('SUPER_ADMIN') ||
    allowed.some((role) => roles.includes(role))
  );
}

export function App() {
  const [session, setSessionState] = useState<AdminSession | null>(getSession);
  useEffect(() => onSessionChange(() => setSessionState(getSession())), []);
  const navigate = useNavigate();
  const location = useLocation();
  if (!session) return <LoginPage />;
  const sections = SECTIONS.filter((s) => canUse(session.admin.roles, s.roles));
  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Layout.Sider breakpoint="lg" collapsedWidth={0} theme="light">
        <Typography.Title level={5} style={{ padding: 16, margin: 0 }}>
          Baby Family Admin
        </Typography.Title>
        <Menu
          mode="inline"
          selectedKeys={[location.pathname]}
          items={sections.map(({ key, label, icon }) => ({ key, label, icon }))}
          onClick={({ key }) => navigate(key)}
        />
      </Layout.Sider>
      <Layout>
        <Layout.Header
          style={{ background: 'transparent', textAlign: 'right' }}
        >
          <Space>
            <Typography.Text type="secondary">
              {session.admin.roles.join(', ')}
            </Typography.Text>
            <Button onClick={() => void adminApi.logout()}>Đăng xuất</Button>
          </Space>
        </Layout.Header>
        <Layout.Content style={{ padding: 16 }}>
          <Routes>
            <Route path="/moderation" element={<CasesPage />} />
            <Route path="/licenses" element={<LicensePage />} />
            <Route path="/support" element={<TicketsPage />} />
            <Route path="/catalog" element={<CatalogPage />} />
            <Route
              path="*"
              element={
                <Navigate to={sections[0]?.key ?? '/moderation'} replace />
              }
            />
          </Routes>
        </Layout.Content>
      </Layout>
    </Layout>
  );
}
