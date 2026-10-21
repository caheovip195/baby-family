import { useCallback, useEffect, useState } from 'react';
import {
  App,
  Button,
  Descriptions,
  Drawer,
  Form,
  Input,
  Select,
  Space,
  Table,
  Tag,
  Typography,
} from 'antd';
import { adminApi, CASE_STATUSES, type CaseContent, type ModerationCase } from '../api/admin';
import { errorText } from '../components/errors';

const statusColor: Record<string, string> = {
  OPEN: 'blue',
  IN_REVIEW: 'gold',
  ESCALATED: 'red',
  RESOLVED: 'green',
};

/** ADM-04/05: moderation cases. Viewing reported content needs a reason (audited). */
export function CasesPage() {
  const { message } = App.useApp();
  const [status, setStatus] = useState<string | undefined>('OPEN');
  const [page, setPage] = useState(1);
  const [rows, setRows] = useState<ModerationCase[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [selected, setSelected] = useState<ModerationCase | null>(null);
  const [content, setContent] = useState<CaseContent | null>(null);
  const pageSize = 25;

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const result = await adminApi.cases(status, (page - 1) * pageSize, pageSize);
      setRows(result.items);
      setTotal(result.total ?? result.items.length);
    } catch (e) {
      message.error(errorText(e));
    } finally {
      setLoading(false);
    }
  }, [status, page, message]);
  useEffect(() => {
    void load();
  }, [load]);

  const open = async (row: ModerationCase) => {
    setContent(null);
    try {
      setSelected(await adminApi.caseDetail(row.id));
    } catch (e) {
      message.error(errorText(e));
    }
  };

  const act = async (run: () => Promise<unknown>, done: string) => {
    try {
      await run();
      message.success(done);
      if (selected) setSelected(await adminApi.caseDetail(selected.id));
      await load();
    } catch (e) {
      message.error(errorText(e));
    }
  };

  return (
    <>
      <Space style={{ marginBottom: 16 }}>
        <Typography.Title level={4} style={{ margin: 0 }}>
          Ca kiểm duyệt
        </Typography.Title>
        <Select
          allowClear
          placeholder="Mọi trạng thái"
          value={status}
          onChange={(value) => {
            setStatus(value);
            setPage(1);
          }}
          options={CASE_STATUSES.map((s) => ({ value: s, label: s }))}
          style={{ width: 180 }}
        />
      </Space>
      <Table
        rowKey="id"
        loading={loading}
        dataSource={rows}
        onRow={(row) => ({ onClick: () => void open(row), style: { cursor: 'pointer' } })}
        pagination={{ current: page, pageSize, total, onChange: setPage }}
        scroll={{ x: true }}
        columns={[
          { title: 'Ưu tiên', dataIndex: 'priority', width: 80 },
          { title: 'Đối tượng', render: (_, r) => `${r.targetType} · ${r.targetId.slice(0, 8)}` },
          {
            title: 'Trạng thái',
            dataIndex: 'status',
            render: (s: string) => <Tag color={statusColor[s]}>{s}</Tag>,
          },
          {
            title: 'Hạn SLA',
            dataIndex: 'slaDueAt',
            render: (at: string) => new Date(at).toLocaleString('vi-VN'),
          },
        ]}
      />
      <Drawer
        open={!!selected}
        onClose={() => setSelected(null)}
        width={560}
        title="Chi tiết ca"
        destroyOnClose
      >
        {selected && (
          <Space direction="vertical" style={{ width: '100%' }} size="large">
            <Descriptions column={1} size="small" bordered>
              <Descriptions.Item label="Đối tượng">
                {selected.targetType} · {selected.targetId}
              </Descriptions.Item>
              <Descriptions.Item label="Trạng thái">{selected.status}</Descriptions.Item>
              <Descriptions.Item label="Ưu tiên">{selected.priority}</Descriptions.Item>
              <Descriptions.Item label="Báo cáo">
                {(selected.reports ?? []).map((r) => (
                  <div key={r.id}>
                    <Tag>{r.reason}</Tag> mức {r.severity}
                    {r.detail ? ` — ${r.detail}` : ''}
                  </div>
                ))}
              </Descriptions.Item>
              <Descriptions.Item label="Đã xử lý">
                {(selected.actions ?? []).map((a) => (
                  <div key={a.id}>
                    {a.action} · {new Date(a.createdAt).toLocaleString('vi-VN')}
                  </div>
                ))}
              </Descriptions.Item>
            </Descriptions>

            <Form
              layout="vertical"
              onFinish={({ reason }: { reason: string }) =>
                act(async () => setContent(await adminApi.caseContent(selected.id, reason)), 'Đã mở nội dung (có ghi nhật ký)')
              }
            >
              <Typography.Text strong>Xem nội dung bị báo cáo</Typography.Text>
              <Form.Item name="reason" rules={[{ required: true, message: 'Cần lý do' }]}>
                <Input placeholder="Lý do xem (bắt buộc, được ghi nhật ký)" />
              </Form.Item>
              <Button htmlType="submit">Xem nội dung</Button>
            </Form>
            {content && (
              <Typography.Paragraph style={{ whiteSpace: 'pre-wrap' }} copyable={false}>
                {content.content.title ? <strong>{content.content.title}</strong> : null}
                {content.content.title ? '\n' : ''}
                {content.content.body ?? '(không có chữ)'}
              </Typography.Paragraph>
            )}

            <Form
              layout="vertical"
              onFinish={({ status: next, reason }: { status: string; reason: string }) =>
                act(() => adminApi.caseStatus(selected.id, next, reason), 'Đã cập nhật trạng thái')
              }
            >
              <Typography.Text strong>Đổi trạng thái</Typography.Text>
              <Form.Item name="status" rules={[{ required: true }]}>
                <Select
                  options={['IN_REVIEW', 'ESCALATED', 'RESOLVED'].map((s) => ({ value: s, label: s }))}
                />
              </Form.Item>
              <Form.Item name="reason" rules={[{ required: true, message: 'Cần lý do' }]}>
                <Input placeholder="Lý do" />
              </Form.Item>
              <Button htmlType="submit">Cập nhật</Button>
            </Form>

            <Form
              layout="vertical"
              onFinish={({ reason }: { reason: string }) =>
                act(() => adminApi.hideContent(selected.id, reason), 'Đã ẩn nội dung')
              }
            >
              <Typography.Text strong>Ẩn nội dung</Typography.Text>
              <Form.Item name="reason" rules={[{ required: true, message: 'Cần lý do' }]}>
                <Input placeholder="Lý do ẩn" />
              </Form.Item>
              <Button danger htmlType="submit">
                Ẩn nội dung
              </Button>
            </Form>
          </Space>
        )}
      </Drawer>
    </>
  );
}
