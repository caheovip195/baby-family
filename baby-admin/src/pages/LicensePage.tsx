import { useState } from 'react';
import { Alert, App, Button, Card, Form, Input, Popconfirm, Space } from 'antd';
import { adminApi } from '../api/admin';
import { errorText } from '../components/errors';

interface Values {
  familyId: string;
  reasonCode: string;
  reason: string;
}

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/** Block / unblock a family license (reason code + note, audited). */
export function LicensePage() {
  const { message } = App.useApp();
  const [form] = Form.useForm<Values>();
  const [result, setResult] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const run = async (blocked: boolean) => {
    const values = await form.validateFields();
    setLoading(true);
    try {
      const license = await adminApi.license(
        values.familyId.trim(),
        blocked,
        values.reasonCode.trim(),
        values.reason.trim(),
      );
      setResult(
        license.blockedAt
          ? `Đã khoá lúc ${new Date(license.blockedAt).toLocaleString('vi-VN')} (${license.blockReasonCode})`
          : 'License đang mở.',
      );
    } catch (e) {
      message.error(errorText(e));
    } finally {
      setLoading(false);
    }
  };
  return (
    <Card title="Khoá / mở khoá license gia đình" style={{ maxWidth: 560 }}>
      <Form form={form} layout="vertical" disabled={loading}>
        <Form.Item
          label="Mã gia đình (UUID)"
          name="familyId"
          rules={[{ required: true, pattern: UUID, message: 'UUID không hợp lệ' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          label="Mã lý do"
          name="reasonCode"
          rules={[
            { required: true, pattern: /^[A-Z][A-Z0-9_]{0,79}$/, message: 'Chữ in hoa, số, gạch dưới' },
          ]}
        >
          <Input placeholder="VD: PAYMENT_FRAUD, POLICY_VIOLATION" />
        </Form.Item>
        <Form.Item label="Ghi chú" name="reason" rules={[{ required: true, message: 'Cần ghi chú' }]}>
          <Input.TextArea rows={3} />
        </Form.Item>
        <Space>
          <Popconfirm title="Khoá license gia đình này?" onConfirm={() => void run(true)}>
            <Button danger>Khoá</Button>
          </Popconfirm>
          <Popconfirm title="Mở khoá license?" onConfirm={() => void run(false)}>
            <Button>Mở khoá</Button>
          </Popconfirm>
        </Space>
      </Form>
      {result && <Alert style={{ marginTop: 16 }} type="info" message={result} />}
    </Card>
  );
}
