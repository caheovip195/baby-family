import { Checkbox, Form, Input, InputNumber, Select } from 'antd';

export type WritableCatalogKind =
  'missions' | 'plan-versions' | 'trial-policies';
export const isWritableCatalog = (kind: string): kind is WritableCatalogKind =>
  ['missions', 'plan-versions', 'trial-policies'].includes(kind);

export function canWriteCatalog(kind: string, roles: string[]): boolean {
  return (
    isWritableCatalog(kind) &&
    (roles.includes('SUPER_ADMIN') ||
      (kind === 'missions'
        ? roles.includes('CONTENT')
        : roles.some((r) => ['OPS', 'BILLING_OPS'].includes(r))))
  );
}

const required = [{ required: true, message: 'Vui lòng nhập giá trị.' }];
const text = (name: string | string[], label: string, maxLength?: number) => (
  <Form.Item
    key={String(name)}
    name={name}
    label={label}
    rules={[...required, { whitespace: true }]}
  >
    <Input maxLength={maxLength} />
  </Form.Item>
);
const number = (
  name: string,
  label: string,
  min: number,
  max?: number,
  optional = false,
) => (
  <Form.Item
    key={name}
    name={name}
    label={label}
    rules={optional ? [] : required}
  >
    <InputNumber min={min} max={max} precision={0} style={{ width: '100%' }} />
  </Form.Item>
);
const select = (name: string, label: string, values: string[]) => (
  <Form.Item key={name} name={name} label={label} rules={required}>
    <Select options={values.map((value) => ({ value, label: value }))} />
  </Form.Item>
);

export function CatalogFields({ kind }: { kind: WritableCatalogKind }) {
  if (kind === 'missions')
    return (
      <>
        {text('code', 'Mã mới', 20)}
        {number('version', 'Phiên bản', 1)}
        {select('stage', 'Giai đoạn', ['PREGNANCY', 'CHILD', 'ANY'])}
        {number('minAgeDays', 'Tuổi tối thiểu (ngày)', 0, 2147483647, true)}
        {number('maxAgeDays', 'Tuổi tối đa (ngày)', 0, 2147483647, true)}
        {number('minPregWeek', 'Tuần thai tối thiểu', 1, 42, true)}
        {number('maxPregWeek', 'Tuần thai tối đa', 1, 42, true)}
        {select('category', 'Nhóm', [
          'CARE',
          'BONDING',
          'PLAY',
          'OUTDOOR',
          'MEMORY',
          'TOGETHER',
          'SUPPORT',
          'SELF',
          'COUPLE',
          'PREP',
          'HOME',
        ])}
        {select('suggestedScope', 'Phạm vi', [
          'CHILD',
          'MULTI_CHILD',
          'FAMILY',
          'COUPLE',
        ])}
        {select('roleFit', 'Vai trò phù hợp', [
          'ANY_PARENT',
          'PREGNANT_MOTHER',
          'PARTNER_OF_PREGNANT',
          'TOGETHER',
        ])}
        {number('hearts', 'Hearts', 1, 10)}
        {number('durationMin', 'Thời lượng (phút)', 1, 32767)}
        {number('weight', 'Trọng số', 1, 32767)}
        {text(['titleI18n', 'vi'], 'Tên (vi)')}
        {text(['titleI18n', 'en'], 'Tên (en)')}
        {text(['descI18n', 'vi'], 'Mô tả (vi)')}
        {text(['descI18n', 'en'], 'Mô tả (en)')}
        <Form.Item name={['memoryPromptI18n', 'vi']} label="Gợi ý ký ức (vi)">
          <Input />
        </Form.Item>
        <Form.Item name={['memoryPromptI18n', 'en']} label="Gợi ý ký ức (en)">
          <Input />
        </Form.Item>
        <Form.Item name="tags" label="Nhãn">
          <Select mode="tags" />
        </Form.Item>
        <Form.Item name="multiChildOk" valuePropName="checked">
          <Checkbox>Cho phép nhiều bé</Checkbox>
        </Form.Item>
        <Form.Item name="requestable" valuePropName="checked">
          <Checkbox>Cho phép đề nghị</Checkbox>
        </Form.Item>
      </>
    );
  if (kind === 'plan-versions')
    return (
      <>
        {text('planId', 'ID gói')}
        {number('version', 'Phiên bản', 1)}
        {number('entitlementRank', 'Thứ hạng quyền lợi', 0)}
        <Form.Item
          name="quotas"
          label="Quota (JSON)"
          rules={[...required, jsonRule]}
        >
          <Input.TextArea rows={4} />
        </Form.Item>
        <Form.Item
          name="features"
          label="Tính năng (JSON)"
          rules={[...required, jsonRule]}
        >
          <Input.TextArea rows={4} />
        </Form.Item>
      </>
    );
  return (
    <>
      {text('code', 'Mã chính sách', 60)}
      {number('version', 'Phiên bản', 1)}
      {text('planVersionId', 'ID phiên bản gói')}
      {number('durationSeconds', 'Thời hạn (giây)', 1, Number.MAX_SAFE_INTEGER)}
      <Form.Item
        name="reminderOffsets"
        label="Mốc nhắc trước hết hạn (giây, phân cách dấu phẩy)"
        rules={[
          {
            validator: (_, value: string | undefined) =>
              !value ||
              value
                .split(',')
                .every(
                  (v) =>
                    /^\d+$/.test(v.trim()) &&
                    Number.isSafeInteger(Number(v)) &&
                    Number(v) > 0,
                )
                ? Promise.resolve()
                : Promise.reject(new Error('Nhập các số nguyên dương.')),
          },
        ]}
      >
        <Input />
      </Form.Item>
    </>
  );
}
const jsonRule = {
  validator: (_: unknown, value: string) => {
    try {
      const parsed: unknown = JSON.parse(value);
      if (!parsed || typeof parsed !== 'object' || Array.isArray(parsed))
        throw new Error();
      return Promise.resolve();
    } catch {
      return Promise.reject(new Error('Nhập JSON object hợp lệ.'));
    }
  },
};

export const catalogDefaults = (kind: WritableCatalogKind) =>
  kind === 'missions'
    ? {
        version: 1,
        stage: 'ANY',
        category: 'CARE',
        suggestedScope: 'FAMILY',
        roleFit: 'ANY_PARENT',
        hearts: 1,
        durationMin: 5,
        weight: 1,
        tags: [],
        multiChildOk: false,
        requestable: false,
      }
    : kind === 'plan-versions'
      ? { version: 1, entitlementRank: 0, quotas: '{}', features: '{}' }
      : { version: 1 };

export function catalogPayload(
  kind: WritableCatalogKind,
  values: Record<string, unknown>,
) {
  if (kind === 'plan-versions')
    return {
      ...values,
      quotas: JSON.parse(String(values.quotas)) as unknown,
      features: JSON.parse(String(values.features)) as unknown,
    };
  if (kind === 'trial-policies') {
    const { reminderOffsets, ...rest } = values;
    return {
      ...rest,
      durationSeconds: values.durationSeconds,
      reminderOffsetsSeconds: String(reminderOffsets ?? '')
        .split(',')
        .filter((v) => v.trim())
        .map(Number),
    };
  }
  const prompt = values.memoryPromptI18n as Record<string, string> | undefined;
  return {
    ...values,
    minAgeDays: values.minAgeDays ?? null,
    maxAgeDays: values.maxAgeDays ?? null,
    minPregWeek: values.minPregWeek ?? null,
    maxPregWeek: values.maxPregWeek ?? null,
    ...(prompt?.vi || prompt?.en ? {} : { memoryPromptI18n: undefined }),
    tags: values.tags ?? [],
  };
}
