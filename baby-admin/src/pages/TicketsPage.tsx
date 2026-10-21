import { useCallback, useEffect, useState } from 'react';
import { App, Button, Drawer, Form, Input, Select, Space, Table, Tag, Typography } from 'antd';
import { adminApi, TICKET_STATUSES, type TicketDetail, type TicketMetadata } from '../api/admin';
import { errorText } from '../components/errors';

/** Reason code sent when reading a ticket's encrypted content (audited). */
const READ_REASON = 'SUPPORT_REQUEST';

/** CSKH: list metadata, open content (audited), reply as SUPPORT, change status. */
export function TicketsPage() {
  const { message } = App.useApp();
  const [status, setStatus] = useState<string | undefined>('OPEN');
  const [rows, setRows] = useState<TicketMetadata[]>([]);
  const [offset, setOffset] = useState(0);
  const [next, setNext] = useState<number | null>(null);
  const [loading, setLoading] = useState(false);
  const [detail, setDetail] = useState<TicketDetail | null>(null);
  const [form] = Form.useForm<{ body: string }>();

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const page = await adminApi.tickets(status, offset);
      setRows(page.items);
      setNext(page.nextOffset ?? null);
    } catch (e) {
      message.error(errorText(e));
    } finally {
      setLoading(false);
    }
  }, [status, offset, message]);
  useEffect(() => {
    void load();
  }, [load]);

  const open = async (id: string) => {
    try {
      setDetail(await adminApi.ticketDetail(id, READ_REASON));
    } catch (e) {
      message.error(errorText(e));
    }
  };

  const reply = async ({ body }: { body: string }) => {
    if (!detail) return;
    try {
      await adminApi.ticketReply(detail.id, body.trim(), READ_REASON);
      form.resetFields();
      await open(detail.id);
      message.success('Đã gửi trả lời');
    } catch (e) {
      message.error(errorText(e));
    }
  };

  const changeStatus = async (value: string) => {
    if (!detail) return;
    try {
      await adminApi.ticketStatus(detail.id, value, READ_REASON);
      await open(detail.id);
      await load();
    } catch (e) {
      message.error(errorText(e));
    }
  };

  return (
    <>
      <Space style={{ marginBottom: 16 }}>
        <Typography.Title level={4} style={{ margin: 0 }}>
          Yêu cầu hỗ trợ
        </Typography.Title>
        <Select
          allowClear
          placeholder="Mọi trạng thái"
          value={status}
          onChange={(value) => {
            setStatus(value);
            setOffset(0);
          }}
          options={TICKET_STATUSES.map((s) => ({ value: s, label: s }))}
          style={{ width: 180 }}
        />
      </Space>
      <Table
        rowKey="id"
        loading={loading}
        dataSource={rows}
        pagination={false}
        scroll={{ x: true }}
        onRow={(row) => ({ onClick: () => void open(row.id), style: { cursor: 'pointer' } })}
        columns={[
          { title: 'Danh mục', dataIndex: 'category' },
          { title: 'Trạng thái', dataIndex: 'status', render: (s: string) => <Tag>{s}</Tag> },
          {
            title: 'Tạo lúc',
            dataIndex: 'createdAt',
            render: (at: string) => new Date(at).toLocaleString('vi-VN'),
          },
        ]}
      />
      <Space style={{ marginTop: 16 }}>
        <Button disabled={offset === 0} onClick={() => setOffset(Math.max(0, offset - 50))}>
          Trước
        </Button>
        <Button disabled={next === null} onClick={() => next !== null && setOffset(next)}>
          Sau
        </Button>
      </Space>
      <Drawer open={!!detail} onClose={() => setDetail(null)} width={560} title={detail?.code} destroyOnClose>
        {detail && (
          <Space direction="vertical" style={{ width: '100%' }} size="middle">
            <Select
              value={detail.status}
              onChange={(value) => void changeStatus(value)}
              options={TICKET_STATUSES.map((s) => ({ value: s, label: s }))}
              style={{ width: 200 }}
            />
            <Typography.Title level={5}>{detail.subject}</Typography.Title>
            <Typography.Paragraph style={{ whiteSpace: 'pre-wrap' }}>{detail.body}</Typography.Paragraph>
            {detail.messages.map((m) => (
              <div
                key={m.id}
                style={{
                  alignSelf: m.sender === 'SUPPORT' ? 'flex-end' : 'flex-start',
                  background: m.sender === 'SUPPORT' ? '#FFF4F1' : '#F7F1EC',
                  borderRadius: 12,
                  padding: 12,
                  maxWidth: '85%',
                }}
              >
                <Typography.Text type="secondary">
                  {m.sender === 'SUPPORT' ? 'Hỗ trợ' : 'Người dùng'} ·{' '}
                  {new Date(m.createdAt).toLocaleString('vi-VN')}
                </Typography.Text>
                <div style={{ whiteSpace: 'pre-wrap' }}>{m.body}</div>
              </div>
            ))}
            <Form form={form} layout="vertical" onFinish={reply}>
              <Form.Item name="body" rules={[{ required: true, whitespace: true, message: 'Nhập nội dung' }]}>
                <Input.TextArea rows={4} placeholder="Trả lời người dùng" />
              </Form.Item>
              <Button type="primary" htmlType="submit">
                Gửi trả lời
              </Button>
            </Form>
          </Space>
        )}
      </Drawer>
    </>
  );
}
