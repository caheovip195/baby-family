import { useState } from 'react';
import { Alert, Button, Card, Form, Input } from 'antd';
import { adminApi } from '../api/admin';
import { errorText } from '../components/errors';

interface Values {
  email: string;
  password: string;
  totp: string;
}

/** Admin login: email + password + mandatory TOTP (tech spec §24). */
export function LoginPage() {
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const submit = async (values: Values) => {
    setLoading(true);
    setError(null);
    try {
      await adminApi.login(values.email.trim(), values.password, values.totp.trim());
    } catch (e) {
      setError(errorText(e));
    } finally {
      setLoading(false);
    }
  };
  return (
    <div style={{ display: 'grid', placeItems: 'center', minHeight: '100vh', padding: 16 }}>
      <Card title="Đăng nhập quản trị" style={{ width: '100%', maxWidth: 380 }}>
        {error && <Alert type="error" message={error} style={{ marginBottom: 16 }} />}
        <Form layout="vertical" onFinish={submit} disabled={loading}>
          <Form.Item label="Email" name="email" rules={[{ required: true, type: 'email' }]}>
            <Input autoComplete="username" />
          </Form.Item>
          <Form.Item label="Mật khẩu" name="password" rules={[{ required: true }]}>
            <Input.Password autoComplete="current-password" />
          </Form.Item>
          <Form.Item
            label="Mã xác thực (TOTP)"
            name="totp"
            rules={[{ required: true, pattern: /^\d{6}$/, message: 'Nhập 6 chữ số' }]}
          >
            <Input inputMode="numeric" maxLength={6} autoComplete="one-time-code" />
          </Form.Item>
          <Button type="primary" htmlType="submit" block loading={loading}>
            Đăng nhập
          </Button>
        </Form>
      </Card>
    </div>
  );
}
