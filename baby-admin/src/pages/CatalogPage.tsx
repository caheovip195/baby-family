import { useEffect, useState } from 'react';
import {
  Alert,
  App,
  Button,
  Form,
  Input,
  Modal,
  Space,
  Table,
  Tabs,
  Typography,
} from 'antd';
import { adminApi, CATALOG_KINDS } from '../api/admin';
import { getSession } from '../api/client';
import { errorText } from '../components/errors';
import {
  CatalogFields,
  canWriteCatalog,
  catalogDefaults,
  catalogPayload,
  isWritableCatalog,
} from '../components/catalog-form';

const labels: Record<string, string> = {
  missions: 'Nhiệm vụ',
  milestones: 'Cột mốc',
  'notification-templates': 'Mẫu thông báo',
  'plan-versions': 'Phiên bản gói',
  'trial-policies': 'Chính sách dùng thử',
};
const summary = (row: Record<string, unknown>) => {
  const title = row.titleI18n ?? row.title ?? row.displayNameI18n ?? row.name;
  if (title && typeof title === 'object') {
    const text = title as Record<string, string>;
    return text.vi ?? text.en ?? JSON.stringify(title);
  }
  return typeof title === 'string' ? title : '';
};
export function catalogState(
  kind: string,
  row: Record<string, unknown>,
): string {
  if (row.status === 'DRAFT') return 'DRAFT';
  if (row.status === 'RETIRED' || row.retiredAt || row.status === 'INACTIVE')
    return 'RETIRED';
  if (kind === 'missions') return String(row.status ?? '');
  if (kind === 'plan-versions') return 'PUBLISHED';
  if (kind === 'trial-policies') return row.publishedAt ? 'PUBLISHED' : 'DRAFT';
  return String(row.status ?? '');
}
export function CatalogPage() {
  const { message } = App.useApp();
  const [kind, setKind] = useState<string>(CATALOG_KINDS[0]);
  const [rows, setRows] = useState<Record<string, unknown>[]>([]);
  const [loading, setLoading] = useState(false);
  const [revision, setRevision] = useState(0);
  const [editing, setEditing] = useState(false);
  const [transition, setTransition] = useState<{
    row: Record<string, unknown>;
    action: 'publish' | 'retire';
  } | null>(null);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm();
  const [actionForm] = Form.useForm();
  const writable = canWriteCatalog(kind, getSession()?.admin.roles ?? []);
  useEffect(() => {
    let alive = true;
    setRows([]);
    setLoading(true);
    Promise.all([
      adminApi.catalog(kind, 0, 100),
      writable && kind !== 'missions'
        ? adminApi.catalogDrafts(kind)
        : Promise.resolve({ items: [] }),
    ])
      .then(([page, drafts]) => {
        if (alive)
          setRows([
            ...drafts.items,
            ...page.items.filter(
              (row) => !drafts.items.some((draft) => draft.id === row.id),
            ),
          ]);
      })
      .catch((e: unknown) => message.error(errorText(e)))
      .finally(() => alive && setLoading(false));
    return () => {
      alive = false;
    };
  }, [kind, message, revision, writable]);
  const save = async () => {
    if (!isWritableCatalog(kind)) return;
    let values: Record<string, unknown>;
    try {
      values = (await form.validateFields()) as Record<string, unknown>;
    } catch {
      return;
    }
    setSaving(true);
    try {
      await adminApi.createCatalog(
        kind,
        catalogPayload(kind, {
          ...values,
          reason: String(values.reason).trim(),
        }),
      );
      setEditing(false);
      setRevision((v) => v + 1);
      message.success('Đã tạo bản nháp.');
    } catch (e) {
      message.error(errorText(e));
    } finally {
      setSaving(false);
    }
  };
  const applyTransition = async () => {
    if (!transition) return;
    let values: { reason: string; availableFrom?: string };
    try {
      values = (await actionForm.validateFields()) as typeof values;
    } catch {
      return;
    }
    setSaving(true);
    try {
      await adminApi.transitionCatalog(
        kind,
        String(kind === 'missions' ? transition.row.code : transition.row.id),
        transition.action,
        {
          reason: values.reason.trim(),
          ...(values.availableFrom
            ? { availableFrom: new Date(values.availableFrom).toISOString() }
            : {}),
        },
      );
      setTransition(null);
      setRevision((v) => v + 1);
      message.success('Đã cập nhật catalog.');
    } catch (e) {
      message.error(errorText(e));
    } finally {
      setSaving(false);
    }
  };
  return (
    <>
      <Typography.Title level={4}>Catalog</Typography.Title>
      <Alert
        type="info"
        showIcon
        style={{ marginBottom: 16 }}
        message="Nội dung đã publish là bất biến. Để thay đổi, tạo mã hoặc phiên bản mới rồi ngừng dùng bản cũ."
      />
      <Tabs
        activeKey={kind}
        onChange={(value) => {
          setKind(value);
          setEditing(false);
          setTransition(null);
        }}
        items={CATALOG_KINDS.map((k) => ({ key: k, label: labels[k] }))}
      />
      {!isWritableCatalog(kind) && (
        <Alert
          type="info"
          message="Chưa hỗ trợ tạo/publish: schema catalog này chưa có phiên bản."
          style={{ marginBottom: 16 }}
        />
      )}
      {writable && (
        <Button
          type="primary"
          style={{ marginBottom: 16 }}
          onClick={() => {
            form.resetFields();
            form.setFieldsValue(
              catalogDefaults(
                kind as 'missions' | 'plan-versions' | 'trial-policies',
              ),
            );
            setEditing(true);
          }}
        >
          Tạo mới
        </Button>
      )}
      <Table
        rowKey={(row) => String(row.id ?? `${row.code}:${row.locale ?? ''}`)}
        loading={loading}
        dataSource={rows}
        scroll={{ x: true }}
        columns={[
          {
            title: 'Mã',
            render: (_, row) => String(row.code ?? row.version ?? row.id ?? ''),
          },
          { title: 'Tên', render: (_, row) => summary(row) },
          { title: 'Trạng thái', render: (_, row) => catalogState(kind, row) },
          ...(writable
            ? [
                {
                  title: 'Thao tác',
                  render: (_: unknown, row: Record<string, unknown>) => {
                    const state = catalogState(kind, row);
                    return (
                      <Space>
                        {state === 'DRAFT' && (
                          <Button
                            onClick={() => {
                              actionForm.resetFields();
                              setTransition({ row, action: 'publish' });
                            }}
                          >
                            Publish
                          </Button>
                        )}
                        {['PUBLISHED', 'ACTIVE'].includes(state) && (
                          <Button
                            danger
                            onClick={() => {
                              actionForm.resetFields();
                              setTransition({ row, action: 'retire' });
                            }}
                          >
                            Ngừng dùng
                          </Button>
                        )}
                      </Space>
                    );
                  },
                },
              ]
            : []),
        ]}
        expandable={{
          expandedRowRender: (row) => (
            <pre style={{ whiteSpace: 'pre-wrap', margin: 0 }}>
              {JSON.stringify(row, null, 2)}
            </pre>
          ),
        }}
      />
      <Modal
        title={`Tạo bản nháp — ${labels[kind]}`}
        open={editing}
        onCancel={() => setEditing(false)}
        onOk={() => void save()}
        confirmLoading={saving}
        okText="Tạo bản nháp"
        cancelText="Huỷ"
        destroyOnClose
      >
        <Form form={form} layout="vertical" preserve={false}>
          {isWritableCatalog(kind) && <CatalogFields kind={kind} />}
          <ReasonField />
        </Form>
      </Modal>
      <Modal
        title={
          transition?.action === 'publish'
            ? 'Publish phiên bản'
            : 'Ngừng dùng phiên bản'
        }
        open={Boolean(transition)}
        onCancel={() => setTransition(null)}
        onOk={() => void applyTransition()}
        confirmLoading={saving}
        okText="Xác nhận"
        cancelText="Huỷ"
        destroyOnClose
      >
        <Form form={actionForm} layout="vertical" preserve={false}>
          <Typography.Paragraph>
            {String(transition?.row.code ?? transition?.row.id ?? '')}
          </Typography.Paragraph>
          {transition?.action === 'publish' && kind !== 'missions' && (
            <Form.Item
              name="availableFrom"
              label="Có hiệu lực từ (giờ địa phương)"
              rules={[
                { required: true, message: 'Chọn thời điểm có hiệu lực.' },
                {
                  validator: (_, value: string) =>
                    !value || Number.isFinite(new Date(value).getTime())
                      ? Promise.resolve()
                      : Promise.reject(new Error('Thời điểm không hợp lệ.')),
                },
              ]}
            >
              <Input type="datetime-local" />
            </Form.Item>
          )}
          <ReasonField />
        </Form>
      </Modal>
    </>
  );
}
function ReasonField() {
  return (
    <Form.Item
      name="reason"
      label="Lý do"
      rules={[
        {
          required: true,
          whitespace: true,
          max: 80,
          message: 'Nhập lý do từ 1 đến 80 ký tự.',
        },
      ]}
    >
      <Input.TextArea maxLength={80} />
    </Form.Item>
  );
}
