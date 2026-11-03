-- BF-20261028-004: CHD-06 Tăng trưởng — cân nặng / chiều cao của bé theo ngày.
-- Chỉ dữ liệu của bé, không lưu chuẩn tham chiếu. DDL only.
CREATE TABLE app.growth_measurements (
  id uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id uuid NOT NULL REFERENCES app.families(id),
  child_id uuid NOT NULL REFERENCES app.children(id),
  measured_on date NOT NULL,
  weight_grams integer CHECK (weight_grams BETWEEN 200 AND 200000),
  height_mm integer CHECK (height_mm BETWEEN 150 AND 2500),
  note varchar(200),
  created_by uuid NOT NULL REFERENCES app.users(id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3),
  CHECK (weight_grams IS NOT NULL OR height_mm IS NOT NULL)
);
CREATE UNIQUE INDEX uq_growth_measurement_day
  ON app.growth_measurements (child_id, measured_on)
  WHERE deleted_at IS NULL;
CREATE INDEX ix_growth_measurements_family
  ON app.growth_measurements (family_id, child_id, measured_on)
  WHERE deleted_at IS NULL;
CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.growth_measurements
FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns();
