-- BF-20261101-001: Nhắn tin trong gia đình. Mỗi gia đình có một cuộc trò
-- chuyện FAMILY (Parent + người thân đang có quyền) và một COUPLE theo couple
-- space (chỉ hai Parent, nội dung mã hoá). `seq` tăng dần trong từng cuộc trò
-- chuyện để client đồng bộ/phân trang; `idempotency_key` cho gửi lại khi
-- offline. DDL only.
CREATE TABLE app.chat_conversations (
  id uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id uuid NOT NULL REFERENCES app.families(id),
  kind varchar(20) NOT NULL CHECK (kind IN ('FAMILY', 'COUPLE')),
  couple_space_id uuid REFERENCES app.couple_spaces(id),
  last_seq integer NOT NULL DEFAULT 0 CHECK (last_seq >= 0),
  last_message_at timestamptz(3),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3),
  CHECK ((kind = 'COUPLE') = (couple_space_id IS NOT NULL))
);
CREATE UNIQUE INDEX uq_chat_conversation_family
  ON app.chat_conversations (family_id)
  WHERE kind = 'FAMILY' AND deleted_at IS NULL;
CREATE UNIQUE INDEX uq_chat_conversation_couple
  ON app.chat_conversations (couple_space_id)
  WHERE kind = 'COUPLE' AND deleted_at IS NULL;
CREATE INDEX ix_chat_conversations_family
  ON app.chat_conversations (family_id)
  WHERE deleted_at IS NULL;
CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.chat_conversations
FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns();

CREATE TABLE app.chat_messages (
  id uuid PRIMARY KEY DEFAULT uuidv7(),
  conversation_id uuid NOT NULL REFERENCES app.chat_conversations(id),
  family_id uuid NOT NULL REFERENCES app.families(id),
  sender_user_id uuid NOT NULL REFERENCES app.users(id),
  seq integer NOT NULL CHECK (seq > 0),
  idempotency_key uuid NOT NULL,
  body text CHECK (body IS NULL OR char_length(body) BETWEEN 1 AND 4000),
  body_enc bytea CHECK (body_enc IS NULL OR octet_length(body_enc) > 29),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3),
  CHECK ((body IS NULL) <> (body_enc IS NULL))
);
CREATE UNIQUE INDEX uq_chat_message_seq
  ON app.chat_messages (conversation_id, seq);
CREATE UNIQUE INDEX uq_chat_message_key
  ON app.chat_messages (conversation_id, sender_user_id, idempotency_key);
CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.chat_messages
FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns();

CREATE TABLE app.chat_read_states (
  id uuid PRIMARY KEY DEFAULT uuidv7(),
  conversation_id uuid NOT NULL REFERENCES app.chat_conversations(id),
  user_id uuid NOT NULL REFERENCES app.users(id),
  last_read_seq integer NOT NULL DEFAULT 0 CHECK (last_read_seq >= 0),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3)
);
CREATE UNIQUE INDEX uq_chat_read_state
  ON app.chat_read_states (conversation_id, user_id);
CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.chat_read_states
FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns();
