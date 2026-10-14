-- Baby Family family-domain forward migration / BF-20261013-004/005/006.
-- Managed by Prisma Migrate in baby-backend. Review before deployment; validated on isolated PostgreSQL.
-- Baseline: docs/02_TAI_LIEU_KY_THUAT_BABY_FAMILY_v3.md §7; flows §11/14/15/16/18/20.
-- Overrides: family owns license; purchaser never moves rights to another family;
-- Every project table has 3 audit columns. Applied only through backend Prisma migrations.
-- SQL enforces structural integrity. Active membership/AccessContext, decryption,
-- quotas/catalog policies, sealed letters, approvals, provider verification, retention,
-- queue dispatch/retry/claim and end-to-end idempotency still need OOP services/repos.
-- No RLS or application grants are implied. Provision least-privilege roles separately;
-- feed/export/admin DB roles must have NO access to schema us or private encryption keys.
-- uuidv7() is native PostgreSQL18: https://www.postgresql.org/docs/18/functions-uuid.html
-- Family composite FKs prevent cross-family references, not unauthorized SELECT.
BEGIN;
SET LOCAL TIME ZONE 'UTC';



CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE EXTENSION IF NOT EXISTS citext;

CREATE SCHEMA app;
CREATE SCHEMA us;
CREATE SCHEMA billing;
CREATE SCHEMA ops;

-- Identity
CREATE TYPE app.user_status        AS ENUM ('ACTIVE','DELETION_PENDING','DELETED','SUSPENDED');
CREATE TYPE app.auth_provider      AS ENUM ('APPLE','GOOGLE','PHONE');
CREATE TYPE app.platform           AS ENUM ('IOS','ANDROID','WEB');
-- Family
CREATE TYPE app.family_status      AS ENUM ('WAITING_PARTNER','ACTIVE','PARTNER_LEFT','DELETION_SCHEDULED','DELETED');
CREATE TYPE app.onboarding_role    AS ENUM ('PARENT_FATHER','PARENT_MOTHER','CIRCLE');
CREATE TYPE app.parent_slot        AS ENUM ('A','B');
CREATE TYPE app.parent_kind        AS ENUM ('FATHER','MOTHER');           -- nhãn gốc; tên gọi tuỳ chỉnh ở call_name
CREATE TYPE app.member_status      AS ENUM ('ACTIVE','LEFT','REMOVED');
CREATE TYPE app.couple_status      AS ENUM ('ACTIVE','DISABLED','UNLINKED');
CREATE TYPE app.invite_type        AS ENUM ('PARTNER','CIRCLE');
CREATE TYPE app.invite_status      AS ENUM ('PENDING','AWAITING_APPROVAL','ACCEPTED','DECLINED','REVOKED','EXPIRED');
CREATE TYPE app.circle_relation    AS ENUM ('GRANDFATHER_PATERNAL','GRANDMOTHER_PATERNAL','GRANDFATHER_MATERNAL','GRANDMOTHER_MATERNAL',
                                            'AUNT_PATERNAL','AUNT_MATERNAL','UNCLE_PATERNAL','UNCLE_MATERNAL','COUSIN','SIBLING_ADULT',
                                            'CAREGIVER','OTHER');
CREATE TYPE app.circle_status      AS ENUM ('ACTIVE','PAUSED','SUSPENDED_PLAN','REMOVED','LEFT');
CREATE TYPE app.grant_permission   AS ENUM ('VIEW','COMMENT','CONTRIBUTE');
CREATE TYPE app.grant_status       AS ENUM ('ACTIVE','PAUSED','REVOKED');
-- Journey
CREATE TYPE app.pregnancy_status   AS ENUM ('ACTIVE','COMPLETED','PAUSED','ENDED_PRIVATE','ARCHIVED');
CREATE TYPE app.child_status       AS ENUM ('ACTIVE','ARCHIVED','MEMORIAL','DELETED');
CREATE TYPE app.gender             AS ENUM ('MALE','FEMALE','UNSPECIFIED');
-- Memory & media
CREATE TYPE app.asset_kind         AS ENUM ('IMAGE','VIDEO','AUDIO');
CREATE TYPE app.asset_status       AS ENUM ('PENDING_UPLOAD','UPLOADED','PROCESSING','READY','FAILED','DELETED');
CREATE TYPE app.memory_kind        AS ENUM ('MOMENT','DIARY','VOICE','QUOTE','MONTHLY_PHOTO','KEEPSAKE','LETTER','ULTRASOUND','BUMP','MILESTONE','MISSION','STORY');
CREATE TYPE app.moment_feeling     AS ENUM ('LOVE','JOY','TOUCHED','SURPRISED','PEACEFUL','PROUD');   -- “Cảm xúc của khoảnh khắc” (7.8.1)
CREATE TYPE app.memory_status      AS ENUM ('DRAFT','PROCESSING','PENDING_REVIEW','PUBLISHED','REJECTED','ARCHIVED','TRASHED','PURGED');
CREATE TYPE app.visibility         AS ENUM ('PRIVATE','PARENTS','FAMILY');
CREATE TYPE app.reaction_type      AS ENUM ('LOVE','CUTE','HAHA','TOUCHED','CLAP');
-- Care
-- (mô hình bảng nhiệm vụ hằng ngày — nghiệp vụ 7.13, C-14..C-16)
CREATE TYPE app.mission_scope      AS ENUM ('CHILD','MULTI_CHILD','FAMILY','COUPLE');
CREATE TYPE app.mission_owner_kind AS ENUM ('PARENT','TOGETHER');                   -- không có “giao cho bạn đời” (BR-020)
CREATE TYPE app.mission_role_fit   AS ENUM ('ANY_PARENT','PREGNANT_MOTHER','PARTNER_OF_PREGNANT','TOGETHER');
CREATE TYPE app.mission_category   AS ENUM ('CARE','BONDING','PLAY','OUTDOOR','MEMORY','TOGETHER','SUPPORT','SELF','COUPLE','PREP','HOME','CUSTOM');
CREATE TYPE app.mission_status     AS ENUM ('TODO','DONE','EXPIRED','REMOVED');     -- thay 9 trạng thái cũ (7.13.5)
CREATE TYPE app.mission_source     AS ENUM ('SYSTEM','LIBRARY','CUSTOM','SERIES');
CREATE TYPE app.mission_board_level AS ENUM ('LIGHT','MEDIUM','HEAVY');             -- Nhẹ 2 / Vừa 3 / Nhiều 4 mỗi Parent
-- Us
CREATE TYPE us.mood                AS ENUM ('GOOD','OKAY','TIRED','EXHAUSTED','STRESSED','SAD','UPSET','UPSET_WITH_PARTNER','OVERWHELMED','LONELY','NEED_AFFECTION');
CREATE TYPE us.need                AS ENUM ('BREAK','HELP_CHILD','QUIET','HUG','TALK','REASSURANCE');
CREATE TYPE us.request_kind        AS ENUM ('TASK','NEED');                          -- Lời nhờ (7.16.2)
CREATE TYPE us.request_status      AS ENUM ('SENT','SEEN','ACCEPTED','DONE','DECLINED','ACKNOWLEDGED','EXPIRED','CANCELLED');
CREATE TYPE us.request_urgency     AS ENUM ('NORMAL','SOON');
CREATE TYPE us.request_due_kind    AS ENUM ('NOW','TODAY_AT','TONIGHT','TOMORROW');
CREATE TYPE us.conflict_status     AS ENUM ('PRIVATE_DRAFT','INVITED','ACTIVE','PAUSED','AGREED','RESOLVED','CLOSED','EXPIRED');
-- Billing
CREATE TYPE billing.store          AS ENUM ('APPLE','GOOGLE');
CREATE TYPE billing.sub_status     AS ENUM ('TRIAL','ACTIVE','GRACE','ON_HOLD','PAUSED','CANCELED_ACTIVE','EXPIRED','REVOKED','REFUNDED');
-- Trust
CREATE TYPE app.report_target      AS ENUM ('MEMORY','COMMENT','USER','AI_OUTPUT','ALBUM');
CREATE TYPE app.report_reason      AS ENUM ('INAPPROPRIATE','HARASSMENT','PRIVACY','CHILD_SAFETY','SPAM','AI_CONTENT','OTHER');
CREATE TYPE app.report_status      AS ENUM ('NEW','TRIAGE','IN_REVIEW','ACTION_TAKEN','NO_VIOLATION','NEED_INFO','CLOSED');


CREATE TABLE app.users (
  id                 uuid PRIMARY KEY DEFAULT uuidv7(),
  display_name       varchar(80)  NOT NULL,
  avatar_asset_id    uuid,
  locale             varchar(10)  NOT NULL DEFAULT 'vi',
  timezone           varchar(64)  NOT NULL DEFAULT 'Asia/Ho_Chi_Minh',
  status             app.user_status NOT NULL DEFAULT 'ACTIVE',
  onboarding_role    app.onboarding_role,                      -- null ⇒ bắt buộc chọn ở ONB-03
  token_version      int          NOT NULL DEFAULT 1,       -- tăng để vô hiệu mọi access token
  last_active_at     timestamptz(3),
  created_at         timestamptz(3)  NOT NULL DEFAULT now(),
  updated_at         timestamptz(3)  NOT NULL DEFAULT now(),
  deleted_at         timestamptz(3),
  CHECK (display_name IS NULL OR char_length(btrim(display_name)) > 0)
);

-- AUTH-04/CIR-WAIT can upload an avatar before joining any family. These files
-- are user-owned and use a separate quota/retention policy from family memories.
CREATE TABLE app.user_assets (
  id uuid PRIMARY KEY DEFAULT uuidv7(), owner_user_id uuid NOT NULL REFERENCES app.users(id),
  purpose varchar(10) NOT NULL CHECK (purpose IN ('AVATAR','SUPPORT')),
  status app.asset_status NOT NULL DEFAULT 'PENDING_UPLOAD',
  storage_bucket varchar(80) NOT NULL DEFAULT 'bf-user-media', storage_key text NOT NULL,
  mime varchar(60) NOT NULL, declared_size bigint NOT NULL CHECK (declared_size >= 0),
  size_bytes bigint CHECK (size_bytes >= 0), sha256 bytea,
  ready_at timestamptz(3), purge_after timestamptz(3),
  UNIQUE (id, owner_user_id), UNIQUE (storage_bucket, storage_key),
  CHECK (sha256 IS NULL OR octet_length(sha256)=32),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE INDEX ix_user_assets_owner ON app.user_assets(owner_user_id, purpose) WHERE deleted_at IS NULL;

CREATE TABLE app.auth_identities (
  id                           uuid PRIMARY KEY DEFAULT uuidv7(),
  user_id                      uuid NOT NULL REFERENCES app.users(id),
  provider                     app.auth_provider NOT NULL,
  provider_uid                 varchar(255) NOT NULL,          -- Apple sub / Google sub / E.164 phone
  email                        citext,
  provider_refresh_token_enc   bytea,                          -- Apple refresh token (để revoke)
  created_at                   timestamptz(3) NOT NULL DEFAULT now(),
  last_used_at                 timestamptz(3),
  UNIQUE (provider, provider_uid),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE INDEX ON app.auth_identities(user_id);

CREATE TABLE app.user_sessions (
  id                   uuid PRIMARY KEY DEFAULT uuidv7(),
  user_id              uuid NOT NULL REFERENCES app.users(id),
  device_id            uuid,
  refresh_token_hash   bytea NOT NULL UNIQUE,
  replaced_by          uuid,
  platform             app.platform,
  app_version          varchar(20),
  ip_created           inet,
  created_at           timestamptz(3) NOT NULL DEFAULT now(),
  last_used_at         timestamptz(3) NOT NULL DEFAULT now(),
  expires_at           timestamptz(3) NOT NULL,
  absolute_expires_at  timestamptz(3) NOT NULL,
  revoked_at           timestamptz(3),
  revoke_reason        varchar(40),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE INDEX ON app.user_sessions(user_id) WHERE (revoked_at IS NULL) AND deleted_at IS NULL;

CREATE TABLE app.user_devices (
  id                 uuid PRIMARY KEY DEFAULT uuidv7(),
  user_id            uuid NOT NULL REFERENCES app.users(id),
  platform           app.platform NOT NULL,
  push_token         text,
  push_enabled       boolean NOT NULL DEFAULT false,      -- quyền thông báo OS
  app_version        varchar(20),
  os_version         varchar(40),
  device_model       varchar(80),
  locale             varchar(10),
  timezone           varchar(64),
  last_seen_at       timestamptz(3) NOT NULL DEFAULT now(),
  created_at         timestamptz(3) NOT NULL DEFAULT now(),
  UNIQUE (push_token),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE INDEX ON app.user_devices(user_id);

CREATE TABLE app.user_consents (
  id          uuid PRIMARY KEY DEFAULT uuidv7(),
  user_id     uuid NOT NULL REFERENCES app.users(id),
  document    varchar(40) NOT NULL,     -- TERMS | PRIVACY | DATA_PROCESSING | CHILD_DATA | AI_<FEATURE> | MARKETING
  version     varchar(20) NOT NULL,
  granted     boolean NOT NULL,
  ip          inet,
  platform    app.platform,
  created_at  timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE INDEX ON app.user_consents(user_id, document, created_at DESC);

CREATE TABLE app.user_settings (
  user_id                    uuid PRIMARY KEY REFERENCES app.users(id),
  notification_prefs         jsonb   NOT NULL DEFAULT '{}',  -- {MEMORY:true, MISSION:true, US:true, ... , mutedUserIds:[]}
  quiet_start                time    NOT NULL DEFAULT '22:00',
  quiet_end                  time    NOT NULL DEFAULT '06:30',
  hide_sensitive_preview     boolean NOT NULL DEFAULT true,
  circle_digest_mode         varchar(10) NOT NULL DEFAULT 'DIGEST',   -- INSTANT | DIGEST
  circle_digest_time         time    NOT NULL DEFAULT '19:00',
  mood_share_default         varchar(10) NOT NULL DEFAULT 'ASK',      -- ASK | ALWAYS | NEVER
  request_soon_bypass_quiet  boolean NOT NULL DEFAULT false,   -- Opt-in: only bypass quiet hours after recipient explicitly enables it
  us_lock_enabled            boolean NOT NULL DEFAULT false,
  ai_enabled                 boolean NOT NULL DEFAULT true,
  ai_features                jsonb   NOT NULL DEFAULT '{}',
  theme                      varchar(10) NOT NULL DEFAULT 'SYSTEM',
  text_scale                 numeric(3,2) NOT NULL DEFAULT 1.00,
  show_lunar                 boolean NOT NULL DEFAULT true,
  memory_prompts_enabled     boolean NOT NULL DEFAULT true,   -- “Gợi ý ghi lại” (BR-073, tắt được)
  perspective_suggest        boolean NOT NULL DEFAULT true,   -- “Bạn cũng ở đó chứ?” khi bạn đời ghi cột mốc (≤ 1/ngày)
  daily_story_suggest        boolean NOT NULL DEFAULT true,   -- 21:00 gợi ý gói Câu chuyện ngày
  updated_at                 timestamptz(3) NOT NULL DEFAULT now(),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);


CREATE TABLE app.families (
  id                   uuid PRIMARY KEY DEFAULT uuidv7(),
  name                 varchar(80) NOT NULL,
  cover_asset_id       uuid,
  status               app.family_status NOT NULL DEFAULT 'WAITING_PARTNER',
  activated_at         timestamptz(3),                    -- lúc đủ Bố + Mẹ
  timezone             varchar(64) NOT NULL DEFAULT 'Asia/Ho_Chi_Minh',
  content_locale       varchar(10) NOT NULL DEFAULT 'vi',
  settings             jsonb NOT NULL DEFAULT '{
      "defaultVisibility": null,
      "requireCircleReview": true,
      "circleCanSeeTree": false,
      "traditionalUseLunar": false,
      "milestoneSuggestions": true,
      "showLunar": true }',
  access_version       int NOT NULL DEFAULT 1,
  created_by           uuid NOT NULL REFERENCES app.users(id),
  created_at           timestamptz(3) NOT NULL DEFAULT now(),
  updated_at           timestamptz(3) NOT NULL DEFAULT now(),
  deletion_scheduled_at timestamptz(3),
  deleted_at           timestamptz(3)
);

CREATE TABLE app.family_parents (
  id               uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id        uuid NOT NULL REFERENCES app.families(id),
  user_id          uuid NOT NULL REFERENCES app.users(id),
  slot             app.parent_slot NOT NULL,
  kind             app.parent_kind NOT NULL,
  call_name        varchar(20) NOT NULL,                 -- mặc định "Papa"/"Mama"; người dùng đổi: "Bố", "Ba", "Má"...
  status           app.member_status NOT NULL DEFAULT 'ACTIVE',
  joined_at        timestamptz(3) NOT NULL DEFAULT now(),
  left_at          timestamptz(3),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  UNIQUE (id, family_id, user_id)
);
-- SQL migration: tối đa 2 Parent/Family (mỗi slot 1 người) & 1 user chỉ là Parent ở 1 family đang hoạt động
CREATE UNIQUE INDEX uq_family_parent_slot   ON app.family_parents(family_id, slot) WHERE (status = 'ACTIVE') AND deleted_at IS NULL;
CREATE UNIQUE INDEX uq_parent_one_family    ON app.family_parents(user_id)          WHERE (status = 'ACTIVE') AND deleted_at IS NULL;
CREATE UNIQUE INDEX uq_family_parent_user   ON app.family_parents(family_id, user_id) WHERE (status = 'ACTIVE') AND deleted_at IS NULL;

CREATE TABLE app.couple_spaces (
  id                uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id         uuid NOT NULL REFERENCES app.families(id),
  parent_a_user_id  uuid NOT NULL REFERENCES app.users(id),
  parent_b_user_id  uuid NOT NULL REFERENCES app.users(id),
  status            app.couple_status NOT NULL DEFAULT 'ACTIVE',
  key_id            uuid,                                -- DEK của couple (mục 16)
  created_at        timestamptz(3) NOT NULL DEFAULT now(),
  disabled_at       timestamptz(3),
  CHECK (parent_a_user_id <> parent_b_user_id),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  pair_version integer NOT NULL DEFAULT 1 CHECK (pair_version > 0),
  updated_by uuid REFERENCES app.users(id),
  UNIQUE (id, family_id),
  UNIQUE (family_id, pair_version)
);
CREATE UNIQUE INDEX uq_couple_active ON app.couple_spaces(family_id) WHERE (status = 'ACTIVE') AND deleted_at IS NULL;

CREATE TABLE app.family_invites (
  id                  uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id           uuid NOT NULL REFERENCES app.families(id),
  type                app.invite_type NOT NULL,
  inviter_user_id     uuid NOT NULL REFERENCES app.users(id),
  token_hash          bytea NOT NULL UNIQUE,            -- SHA-256(token 32 byte)
  code_hash           bytea NOT NULL UNIQUE,            -- HMAC(pepper, code 8 ký tự)
  payload             jsonb NOT NULL,                   -- PARTNER: {kind, message}
                                                        -- CIRCLE: {relation, displayName, allowDownload, message,
                                                        --          grants:[{childId|pregnancyId, permission}]}
  require_final_approval boolean NOT NULL DEFAULT true, -- PARTNER
  status              app.invite_status NOT NULL DEFAULT 'PENDING',
  expires_at          timestamptz(3) NOT NULL,
  accepted_by_user_id uuid REFERENCES app.users(id),
  accepted_at         timestamptz(3),
  decided_at          timestamptz(3),
  created_at          timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  client_request_key uuid,
  UNIQUE (family_id, client_request_key)
);
CREATE INDEX ON app.family_invites(family_id, status);
-- Mỗi family chỉ 1 lời mời PARTNER đang chờ
CREATE UNIQUE INDEX uq_partner_invite_pending ON app.family_invites(family_id)
  WHERE (type = 'PARTNER' AND status IN ('PENDING','AWAITING_APPROVAL')) AND deleted_at IS NULL;

CREATE TABLE app.circle_members (
  id               uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id        uuid NOT NULL REFERENCES app.families(id),
  user_id          uuid NOT NULL REFERENCES app.users(id),
  relation         app.circle_relation NOT NULL,
  display_name     varchar(40) NOT NULL,                 -- "Bà nội"
  allow_download   boolean NOT NULL DEFAULT false,
  status           app.circle_status NOT NULL DEFAULT 'ACTIVE',
  invited_by       uuid REFERENCES app.users(id),
  joined_at        timestamptz(3) NOT NULL DEFAULT now(),
  ended_at         timestamptz(3),
  UNIQUE (id, family_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  CHECK (display_name IS NULL OR char_length(btrim(display_name)) > 0)
);
CREATE UNIQUE INDEX uq_circle_member ON app.circle_members(family_id, user_id)
  WHERE (status IN ('ACTIVE','PAUSED','SUSPENDED_PLAN')) AND deleted_at IS NULL;
CREATE INDEX ON app.circle_members(user_id) WHERE (status IN ('ACTIVE','PAUSED','SUSPENDED_PLAN')) AND deleted_at IS NULL;


CREATE TABLE app.pregnancies (
  id                  uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id           uuid NOT NULL REFERENCES app.families(id),
  seq_no              smallint NOT NULL,
  nickname            varchar(40) NOT NULL,
  due_date            date,
  expected_count      smallint NOT NULL DEFAULT 1 CHECK (expected_count BETWEEN 1 AND 4),
  status              app.pregnancy_status NOT NULL DEFAULT 'ACTIVE',
  cover_asset_id      uuid,
  show_size_content   boolean NOT NULL DEFAULT true,
  carrier_user_id     uuid REFERENCES app.users(id),           -- “Người mang thai” (hồ sơ thai kỳ): mặc định Parent kind=MOTHER, đổi được;
                                                               -- bày bảng nhiệm vụ đọc trường này (15.3)
  bump_photo_cadence  varchar(10) NOT NULL DEFAULT 'WEEKLY',   -- WEEKLY | EVERY_4W | OFF — nhắc ảnh bụng (7.8.7, PREG-02)
  created_by          uuid NOT NULL REFERENCES app.users(id),
  created_at          timestamptz(3) NOT NULL DEFAULT now(),
  updated_at          timestamptz(3) NOT NULL DEFAULT now(),
  completed_at        timestamptz(3),
  version             int NOT NULL DEFAULT 1,
  UNIQUE (family_id, seq_no),
  UNIQUE (id, family_id),
  deleted_at timestamptz(3) DEFAULT NULL,
  CHECK (seq_no > 0),
  CHECK (bump_photo_cadence IN ('WEEKLY','EVERY_4W','OFF'))
);

CREATE TABLE app.children (
  id                uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id         uuid NOT NULL REFERENCES app.families(id),
  pregnancy_id      uuid,
  birth_order       smallint,
  name              varchar(60),
  nickname          varchar(40),
  birth_date        date NOT NULL,
  birth_time        time,
  gender            app.gender NOT NULL DEFAULT 'UNSPECIFIED',
  color_index       smallint NOT NULL CHECK (color_index BETWEEN 1 AND 8),
  avatar_asset_id   uuid,
  cover_asset_id    uuid,
  profile           jsonb NOT NULL DEFAULT '{}',          -- nameStory, favorites...
  birth_stats       jsonb,                                -- {weightGram, lengthMm} — chỉ lưu
  status            app.child_status NOT NULL DEFAULT 'ACTIVE',
  sort_order        smallint NOT NULL DEFAULT 0,
  monthly_photo_mode  varchar(10) NOT NULL DEFAULT 'AUTO',    -- AUTO: hằng tháng tới 12 tháng, sau đó 3 tháng/lần | MONTHLY
  monthly_photo_lunar boolean NOT NULL DEFAULT false,         -- ngày tròn tháng tính theo âm lịch
  created_by        uuid NOT NULL REFERENCES app.users(id),
  created_at        timestamptz(3) NOT NULL DEFAULT now(),
  updated_at        timestamptz(3) NOT NULL DEFAULT now(),
  archived_at       timestamptz(3),
  version           int NOT NULL DEFAULT 1,
  CHECK (name IS NOT NULL OR nickname IS NOT NULL),
  UNIQUE (id, family_id),
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id),
  deleted_at timestamptz(3) DEFAULT NULL,
  deletion_requested_at timestamptz(3),
  purge_after timestamptz(3),
  CHECK ((pregnancy_id IS NULL AND birth_order IS NULL) OR (pregnancy_id IS NOT NULL AND birth_order BETWEEN 1 AND 4)),
  CHECK (pregnancy_id IS NULL OR birth_order IS NOT NULL),
  CHECK (coalesce(nullif(btrim(name),''), nullif(btrim(nickname),'')) IS NOT NULL)
);
CREATE INDEX ON app.children(family_id, status);
CREATE UNIQUE INDEX uq_child_birth_order ON app.children(pregnancy_id, birth_order) WHERE (pregnancy_id IS NOT NULL) AND deleted_at IS NULL;

-- Idempotency cho birth conversion
CREATE TABLE app.birth_conversions (
  pregnancy_id     uuid PRIMARY KEY REFERENCES app.pregnancies(id),
  idempotency_key  uuid NOT NULL UNIQUE,
  family_id uuid NOT NULL REFERENCES app.families(id),
  created_by       uuid NOT NULL,
  created_at       timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id),
  FOREIGN KEY (created_by) REFERENCES app.users(id),
  UNIQUE (pregnancy_id, family_id)
);

CREATE TABLE app.circle_grants (
  id                 uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id          uuid NOT NULL,
  circle_member_id   uuid NOT NULL,
  child_id           uuid,
  pregnancy_id       uuid,
  permission         app.grant_permission NOT NULL,
  status             app.grant_status NOT NULL DEFAULT 'ACTIVE',
  created_by         uuid NOT NULL REFERENCES app.users(id),
  created_at         timestamptz(3) NOT NULL DEFAULT now(),
  updated_at         timestamptz(3) NOT NULL DEFAULT now(),
  CHECK ((child_id IS NOT NULL)::int + (pregnancy_id IS NOT NULL)::int = 1),   -- đúng 1 đối tượng
  FOREIGN KEY (circle_member_id, family_id) REFERENCES app.circle_members(id, family_id),
  FOREIGN KEY (child_id, family_id)         REFERENCES app.children(id, family_id),
  FOREIGN KEY (pregnancy_id, family_id)     REFERENCES app.pregnancies(id, family_id),
  deleted_at timestamptz(3) DEFAULT NULL,
  allow_download boolean NOT NULL DEFAULT false
);
CREATE UNIQUE INDEX uq_grant_child ON app.circle_grants(circle_member_id, child_id)     WHERE (child_id IS NOT NULL) AND deleted_at IS NULL;
CREATE UNIQUE INDEX uq_grant_preg  ON app.circle_grants(circle_member_id, pregnancy_id) WHERE (pregnancy_id IS NOT NULL) AND deleted_at IS NULL;
CREATE INDEX ON app.circle_grants(family_id, child_id) WHERE (status = 'ACTIVE') AND deleted_at IS NULL;

CREATE TABLE app.blocks (
  family_id        uuid NOT NULL REFERENCES app.families(id),
  blocker_user_id  uuid NOT NULL REFERENCES app.users(id),
  blocked_user_id  uuid NOT NULL REFERENCES app.users(id),
  created_at       timestamptz(3) NOT NULL DEFAULT now(),
  PRIMARY KEY (family_id, blocker_user_id, blocked_user_id),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  CHECK (blocker_user_id <> blocked_user_id)
);


CREATE TABLE app.assets (
  id                 uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id          uuid NOT NULL REFERENCES app.families(id),
  uploader_user_id   uuid NOT NULL REFERENCES app.users(id),
  kind               app.asset_kind NOT NULL,
  purpose            varchar(20) NOT NULL DEFAULT 'MEMORY',   -- MEMORY | AVATAR | COVER | JOURNAL | RECAP | EXPORT
  status             app.asset_status NOT NULL DEFAULT 'PENDING_UPLOAD',
  storage_key        text NOT NULL,                           -- fam/{familyId}/a/{assetId}/orig
  multipart_upload_id text,
  mime               varchar(60) NOT NULL,
  declared_size      bigint NOT NULL,
  size_bytes         bigint,                                  -- tổng gồm variants, cập nhật khi READY
  width              int, height int, duration_ms int,
  sha256             bytea,                                   -- client tính, server xác minh
  captured_at        timestamptz(3),                             -- từ EXIF trước khi strip
  blurhash           varchar(64),
  keep_original      boolean NOT NULL DEFAULT false,          -- gói Family
  failure_reason     varchar(60),
  created_at         timestamptz(3) NOT NULL DEFAULT now(),
  ready_at           timestamptz(3),
  deleted_at         timestamptz(3),
  purge_after        timestamptz(3),
  UNIQUE (id, family_id),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  storage_bucket varchar(80) NOT NULL DEFAULT 'bf-media',
  private_owner_user_id uuid REFERENCES app.users(id),
  UNIQUE (storage_bucket, storage_key),
  UNIQUE (id, family_id, uploader_user_id),
  CHECK (declared_size >= 0 AND (size_bytes IS NULL OR size_bytes >= 0)),
  CHECK ((width IS NULL OR width > 0) AND (height IS NULL OR height > 0) AND (duration_ms IS NULL OR duration_ms >= 0)),
  CHECK (sha256 IS NULL OR octet_length(sha256) = 32),
  CHECK ((purpose = 'JOURNAL') = (private_owner_user_id IS NOT NULL)),
  CHECK (private_owner_user_id IS NULL OR private_owner_user_id = uploader_user_id)
);
CREATE INDEX ON app.assets(family_id, status);
CREATE UNIQUE INDEX uq_asset_dedup ON app.assets(family_id, purpose, private_owner_user_id, sha256) NULLS NOT DISTINCT WHERE sha256 IS NOT NULL AND deleted_at IS NULL;
CREATE INDEX ON app.assets(status, created_at) WHERE (status IN ('PENDING_UPLOAD','UPLOADED','PROCESSING')) AND deleted_at IS NULL; -- dọn rác

CREATE TABLE app.memories (
  id                 uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id          uuid NOT NULL REFERENCES app.families(id),
  author_user_id     uuid NOT NULL REFERENCES app.users(id),
  author_role        varchar(10) NOT NULL,                    -- PARENT | CIRCLE (snapshot)
  kind               app.memory_kind NOT NULL DEFAULT 'MOMENT',
  title              varchar(120),
  body               text,                                     -- ≤ 20.000 ký tự (validate app)
  body_format        varchar(10) NOT NULL DEFAULT 'PLAIN',     -- PLAIN | RICH (delta JSON)
  occurred_at        timestamptz(3) NOT NULL,
  occurred_local_date date NOT NULL,                           -- theo timezone family, dùng cho nhóm/On this day
  visibility         app.visibility NOT NULL,
  status             app.memory_status NOT NULL,
  pregnancy_id       uuid,
  pregnancy_week     smallint,
  source_type        varchar(20),                              -- MISSION | RESHARE | RECAP
  source_id          uuid,
  location_label     varchar(120),
  feeling            app.moment_feeling,                       -- “Cảm xúc của khoảnh khắc” (tuỳ chọn)
  quote_context      varchar(200),                             -- QUOTE: “Con nói khi nào?”
  perspective_count  smallint NOT NULL DEFAULT 0,              -- số góc nhìn ACTIVE (badge “Cả hai cùng kể” — Parent view)
  comments_enabled   boolean NOT NULL DEFAULT true,
  -- Thư / time capsule
  unlock_at          timestamptz(3),
  -- Duyệt ký ức người thân
  reviewed_by        uuid REFERENCES app.users(id),
  reviewed_at        timestamptz(3),
  reject_reason      varchar(200),
  -- Vòng đời
  published_at       timestamptz(3),
  archived_at        timestamptz(3),
  trashed_at         timestamptz(3),
  trashed_by         uuid,
  purge_after        timestamptz(3),
  deleted_at         timestamptz(3),                              -- soft delete begins at TRASHED; purge is a separate physical lifecycle
  search_tsv         tsvector,                                 -- unaccent(title || body || location)
  comment_count      int NOT NULL DEFAULT 0,
  reaction_count     int NOT NULL DEFAULT 0,
  created_at         timestamptz(3) NOT NULL DEFAULT now(),
  updated_at         timestamptz(3) NOT NULL DEFAULT now(),
  version            int NOT NULL DEFAULT 1,
  UNIQUE (id, family_id),
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id),
  CHECK (author_role IN ('PARENT','CIRCLE')),
  CHECK (kind <> 'QUOTE' OR (body IS NOT NULL AND char_length(body) <= 280)),   -- Câu nói của con ≤ 280 ký tự
  CHECK (kind <> 'MONTHLY_PHOTO' OR author_role = 'PARENT'),
  family_moment boolean NOT NULL DEFAULT false,
  CHECK (body IS NULL OR char_length(body) <= 20000),
  CHECK (comment_count >= 0 AND reaction_count >= 0 AND perspective_count >= 0),
  CHECK (body_format IN ('PLAIN','RICH')),
  CHECK ((status IN ('TRASHED','PURGED')) = (deleted_at IS NOT NULL)),
  CHECK (status <> 'TRASHED' OR (trashed_at IS NOT NULL AND purge_after IS NOT NULL))
);
CREATE INDEX ix_mem_family_time   ON app.memories(family_id, occurred_at DESC, id DESC) WHERE deleted_at IS NULL;
CREATE INDEX ix_mem_family_pub    ON app.memories(family_id, published_at DESC, id DESC) WHERE (status = 'PUBLISHED') AND deleted_at IS NULL;
CREATE INDEX ix_mem_pending       ON app.memories(family_id, created_at) WHERE (status = 'PENDING_REVIEW') AND deleted_at IS NULL;
CREATE INDEX ix_mem_onthisday     ON app.memories(family_id, (extract(month FROM occurred_local_date)), (extract(day FROM occurred_local_date))) WHERE (status = 'PUBLISHED') AND deleted_at IS NULL;
CREATE INDEX ix_mem_search        ON app.memories USING gin (search_tsv);
CREATE INDEX ix_mem_trash         ON app.memories(purge_after) WHERE (status = 'TRASHED');
CREATE INDEX ix_mem_kind          ON app.memories(family_id, kind, occurred_at DESC) WHERE (status = 'PUBLISHED') AND deleted_at IS NULL;     -- bộ sưu tập theo loại
CREATE INDEX ix_mem_today         ON app.memories(family_id, occurred_local_date, published_at) WHERE (status = 'PUBLISHED') AND deleted_at IS NULL; -- “Hôm nay của con”

CREATE TABLE app.memory_children (
  memory_id   uuid NOT NULL,
  child_id    uuid NOT NULL,
  family_id   uuid NOT NULL,
  added_by    uuid,
  age_month   smallint NOT NULL,          -- tháng tuổi của bé tại occurred_local_date (service tính; tính lại khi đổi ngày) → chương tháng
  created_at  timestamptz(3) NOT NULL DEFAULT now(),
  PRIMARY KEY (memory_id, child_id),
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (child_id,  family_id) REFERENCES app.children(id, family_id), -- cùng family ở mức DB
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE INDEX ix_mc_child ON app.memory_children(child_id, memory_id);
CREATE INDEX ix_mc_child_month ON app.memory_children(child_id, age_month);   -- chương tháng (7.10)

CREATE TABLE app.memory_assets (
  memory_id   uuid NOT NULL,
  asset_id    uuid NOT NULL,
  family_id   uuid NOT NULL,
  sort_order  smallint NOT NULL,
  is_cover    boolean NOT NULL DEFAULT false,
  PRIMARY KEY (memory_id, asset_id),
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (asset_id,  family_id) REFERENCES app.assets(id, family_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  UNIQUE (memory_id, asset_id, family_id),
  CHECK (sort_order >= 0)
);
CREATE INDEX ON app.memory_assets(asset_id);    -- reference count khi purge

CREATE TABLE app.milestone_templates (
  code            varchar(40) PRIMARY KEY,
  category        varchar(20) NOT NULL,       -- TRADITIONAL | EMOTION | MOTOR | LANGUAGE | FOOD | BODY | EXPERIENCE | FAMILY | PREGNANCY
  icon            varchar(40) NOT NULL,
  title_i18n      jsonb NOT NULL,             -- {"vi":"Thôi nôi","en":"First birthday"}
  prompt_i18n     jsonb,
  is_traditional  boolean NOT NULL DEFAULT false,
  date_rule       jsonb,                      -- {"type":"OFFSET","months":1,"lunarOption":true} | {"type":"FIRST_LUNAR_NEW_YEAR"}
  remind_days_before smallint,
  sort_order      int NOT NULL DEFAULT 0,
  status          varchar(10) NOT NULL DEFAULT 'ACTIVE',
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);

CREATE TABLE app.milestones (
  id              uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id       uuid NOT NULL,
  child_id        uuid,                       -- cột mốc của bé
  pregnancy_id    uuid,                       -- cột mốc thai kỳ (17.2: que thử 2 vạch, nghe tim thai, chọn được tên…)
  from_milestone_id uuid,                     -- bản sao sang bé khi birth conversion (sinh đôi → 1 bản/bé)
  memory_id       uuid NOT NULL,
  template_code   varchar(40) REFERENCES app.milestone_templates(code),
  custom_title    varchar(80),
  occurred_on     date NOT NULL,
  created_by      uuid NOT NULL REFERENCES app.users(id),
  created_at      timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at      timestamptz(3),
  CHECK (template_code IS NOT NULL OR custom_title IS NOT NULL),
  CHECK ((child_id IS NOT NULL)::int + (pregnancy_id IS NOT NULL)::int = 1),
  FOREIGN KEY (child_id, family_id)  REFERENCES app.children(id, family_id),
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id),
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  UNIQUE (id, family_id)
);
CREATE UNIQUE INDEX uq_milestone_once ON app.milestones(child_id, template_code)
  WHERE template_code IS NOT NULL AND deleted_at IS NULL;
CREATE UNIQUE INDEX uq_preg_milestone_once ON app.milestones(pregnancy_id, template_code)
  WHERE pregnancy_id IS NOT NULL AND template_code IS NOT NULL AND deleted_at IS NULL;
CREATE INDEX ON app.milestones(child_id, occurred_on);

CREATE TABLE app.albums (
  id               uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id        uuid NOT NULL REFERENCES app.families(id),
  owner_user_id    uuid NOT NULL REFERENCES app.users(id),
  name             varchar(60) NOT NULL,
  cover_memory_id  uuid,
  is_sensitive     boolean NOT NULL DEFAULT false,      -- album “Tắm bé & riêng tư”
  created_at       timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at       timestamptz(3),
  UNIQUE (id, family_id),
  updated_at timestamptz(3) NOT NULL DEFAULT now()
);
CREATE TABLE app.album_memories (
  album_id   uuid NOT NULL,
  memory_id  uuid NOT NULL,
  family_id  uuid NOT NULL,
  added_by   uuid NOT NULL,
  added_at   timestamptz(3) NOT NULL DEFAULT now(),
  PRIMARY KEY (album_id, memory_id),
  FOREIGN KEY (album_id, family_id)  REFERENCES app.albums(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE,
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);

CREATE TABLE app.comments (
  id                 uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id          uuid NOT NULL,
  memory_id          uuid NOT NULL,
  author_user_id     uuid NOT NULL REFERENCES app.users(id),
  parent_comment_id  uuid,
  body               varchar(1000) NOT NULL,
  status             varchar(10) NOT NULL DEFAULT 'ACTIVE',   -- ACTIVE | DELETED | HIDDEN (moderation)
  created_at         timestamptz(3) NOT NULL DEFAULT now(),
  edited_at          timestamptz(3),
  deleted_at         timestamptz(3),
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE,
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  UNIQUE (id, family_id),
  UNIQUE (id, memory_id, family_id),
  CHECK (parent_comment_id IS NULL OR parent_comment_id <> id),
  FOREIGN KEY (parent_comment_id, memory_id, family_id) REFERENCES app.comments(id, memory_id, family_id)
);
CREATE INDEX ON app.comments(memory_id, created_at);

CREATE TABLE app.reactions (
  memory_id   uuid NOT NULL REFERENCES app.memories(id) ON DELETE CASCADE,
  user_id     uuid NOT NULL REFERENCES app.users(id),
  type        app.reaction_type NOT NULL,
  created_at  timestamptz(3) NOT NULL DEFAULT now(),
  PRIMARY KEY (memory_id, user_id),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  family_id uuid NOT NULL REFERENCES app.families(id),
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id)
);

CREATE TABLE app.favorites (
  user_id    uuid NOT NULL REFERENCES app.users(id),
  memory_id  uuid NOT NULL REFERENCES app.memories(id) ON DELETE CASCADE,
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, memory_id),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  family_id uuid NOT NULL REFERENCES app.families(id),
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id)
);

CREATE TABLE app.memory_pins (
  child_id   uuid NOT NULL REFERENCES app.children(id),
  memory_id  uuid NOT NULL REFERENCES app.memories(id) ON DELETE CASCADE,
  pinned_by  uuid NOT NULL,
  position   smallint NOT NULL CHECK (position BETWEEN 1 AND 3),
  PRIMARY KEY (child_id, position),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  family_id uuid NOT NULL REFERENCES app.families(id),
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id),
  FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id),
  FOREIGN KEY (pinned_by) REFERENCES app.users(id)
);
CREATE INDEX ON app.favorites(memory_id);

-- “Ảnh đẹp nhất của nhà mình” = ký ức được CẢ HAI Parent ACTIVE yêu thích (7.8.4); yêu thích riêng không lộ
CREATE VIEW app.v_family_best_memories AS
SELECT m.family_id, f.memory_id, max(f.created_at) AS best_since
FROM app.favorites f
JOIN app.memories m        ON m.id = f.memory_id AND m.status = 'PUBLISHED' AND m.deleted_at IS NULL
JOIN app.family_parents fp ON fp.family_id = m.family_id AND fp.user_id = f.user_id AND fp.status = 'ACTIVE' AND fp.deleted_at IS NULL
WHERE f.deleted_at IS NULL
GROUP BY m.family_id, f.memory_id
HAVING count(DISTINCT f.user_id) = 2;

CREATE TABLE app.memory_people (                  -- “Ai ở đó” (7.8.1) — KHÔNG nhận diện khuôn mặt
  id            bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  memory_id     uuid NOT NULL,
  family_id     uuid NOT NULL,
  user_id       uuid REFERENCES app.users(id),    -- Parent / người thân của gia đình (service kiểm tra thành viên ACTIVE)
  display_name  varchar(40),                      -- tên gõ tự do (“Cô Hạnh hàng xóm”)
  sort_order    smallint NOT NULL DEFAULT 0,
  added_by      uuid NOT NULL REFERENCES app.users(id),
  CHECK ((user_id IS NULL) <> (display_name IS NULL)),          -- đúng 1 trong 2
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE,
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  CHECK (display_name IS NULL OR char_length(btrim(display_name)) > 0)
);
CREATE UNIQUE INDEX uq_mem_people_user ON app.memory_people(memory_id, user_id) WHERE (user_id IS NOT NULL) AND deleted_at IS NULL;
CREATE INDEX ON app.memory_people(user_id) WHERE (user_id IS NOT NULL) AND deleted_at IS NULL;

CREATE TABLE app.memory_perspectives (            -- “Kể cùng nhau — Góc nhìn thứ hai” (7.8.6, BR-071)
  id                  uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id           uuid NOT NULL,
  memory_id           uuid NOT NULL,
  author_user_id      uuid NOT NULL REFERENCES app.users(id),   -- Parent, là bạn đời của tác giả ký ức gốc (service)
  body                varchar(1000),
  audio_asset_id      uuid,
  hidden_from_circle  boolean NOT NULL DEFAULT false,           -- tác giả ký ức gốc CHỈ được đổi cờ này
  status              varchar(10) NOT NULL DEFAULT 'ACTIVE',    -- ACTIVE | TRASHED (vào/ra thùng rác cùng ký ức gốc)
  trashed_at          timestamptz(3),
  created_at          timestamptz(3) NOT NULL DEFAULT now(),
  updated_at          timestamptz(3) NOT NULL DEFAULT now(),
  version             int NOT NULL DEFAULT 1,
  -- KHÔNG có cột visibility: luôn kế thừa ký ức gốc (6.7)
  UNIQUE (memory_id, author_user_id),                           -- tối đa 1 góc nhìn/Parent/ký ức
  UNIQUE (id, family_id),
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (audio_asset_id, family_id) REFERENCES app.assets(id, family_id),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE app.memory_perspective_assets (       -- ≤ 10 ảnh/video mỗi góc nhìn
  perspective_id  uuid NOT NULL,
  asset_id        uuid NOT NULL,
  family_id       uuid NOT NULL,
  sort_order      smallint NOT NULL,
  PRIMARY KEY (perspective_id, asset_id),
  FOREIGN KEY (perspective_id, family_id) REFERENCES app.memory_perspectives(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (asset_id, family_id)       REFERENCES app.assets(id, family_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE INDEX ON app.memory_perspective_assets(asset_id);    -- reference count khi purge

CREATE TABLE app.monthly_photos (                 -- ảnh tháng CHÍNH (7.8.7, BR-072) — 1 dòng = 1 ô MEM-20 / PREG-02
  id             uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id      uuid NOT NULL,
  child_id       uuid,
  month_index    smallint CHECK (month_index BETWEEN 0 AND 240),   -- tháng tuổi; 0 = ảnh chào đời
  pregnancy_id   uuid,
  preg_week      smallint CHECK (preg_week BETWEEN 4 AND 42),      -- ảnh bụng theo tuần
  memory_id      uuid NOT NULL,                   -- ký ức chứa ảnh (thường kind = MONTHLY_PHOTO / BUMP)
  asset_id       uuid NOT NULL,                   -- ảnh được chọn làm ảnh chính
  sticker        jsonb,                           -- {"template":"STAR_01","label":"6 tháng","locale":"vi","x":0.1,"y":0.8,"scale":1}
                                                  -- LỚP HIỂN THỊ — không burn vào ảnh gốc (10.9)
  set_by         uuid NOT NULL REFERENCES app.users(id),
  set_at         timestamptz(3) NOT NULL DEFAULT now(),
  CHECK ((child_id IS NOT NULL AND month_index IS NOT NULL AND pregnancy_id IS NULL AND preg_week IS NULL)
      OR (pregnancy_id IS NOT NULL AND preg_week IS NOT NULL AND child_id IS NULL AND month_index IS NULL)),
  FOREIGN KEY (child_id, family_id)     REFERENCES app.children(id, family_id),
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id),
  FOREIGN KEY (memory_id, family_id)    REFERENCES app.memories(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (memory_id, asset_id)     REFERENCES app.memory_assets(memory_id, asset_id) ON DELETE CASCADE,
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
-- Đúng 1 ảnh chính/bé/tháng tuổi (BR-072); đổi ảnh chính = UPSERT ON CONFLICT, ký ức cũ giữ nguyên
CREATE UNIQUE INDEX uq_monthly_child ON app.monthly_photos(child_id, month_index) WHERE (child_id IS NOT NULL) AND deleted_at IS NULL;
CREATE UNIQUE INDEX uq_bump_week     ON app.monthly_photos(pregnancy_id, preg_week) WHERE (pregnancy_id IS NOT NULL) AND deleted_at IS NULL;

CREATE TABLE app.memory_prompt_templates (       -- catalog “Gợi ý ghi lại” (nghiệp vụ 17.6), quản trị ở ADM catalog
  code           varchar(30) PRIMARY KEY,
  stage          varchar(10) NOT NULL,           -- PREGNANCY | CHILD | ANY
  min_age_days   int, max_age_days int,
  min_preg_week  smallint, max_preg_week smallint,
  target_kind    app.memory_kind NOT NULL,       -- loại ký ức mở ra: QUOTE | VOICE | MOMENT | DIARY | LETTER | MONTHLY_PHOTO | BUMP
  text_i18n      jsonb NOT NULL,                 -- {"vi":"Từ mới {childName} nói tuần này là gì?","en":"…"} — Content duyệt: không câu gây tội lỗi
  weight         smallint NOT NULL DEFAULT 10,
  status         varchar(10) NOT NULL DEFAULT 'ACTIVE',
  version        int NOT NULL DEFAULT 1,
  updated_at     timestamptz(3) NOT NULL DEFAULT now(),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);

CREATE TABLE app.memory_prompt_deliveries (      -- gợi ý đã phát cho từng Parent (BR-073)
  id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  family_id      uuid NOT NULL REFERENCES app.families(id),
  user_id        uuid NOT NULL REFERENCES app.users(id),
  local_date     date NOT NULL,
  template_code  varchar(30) NOT NULL REFERENCES app.memory_prompt_templates(code),
  child_id       uuid,                           -- bé được hỏi (hoặc pregnancy_id)
  pregnancy_id   uuid,
  status         varchar(10) NOT NULL DEFAULT 'SHOWN',   -- SHOWN | USED | DISMISSED | REPLACED
  memory_id      uuid,                           -- USED: ký ức tạo từ gợi ý
  created_at     timestamptz(3) NOT NULL DEFAULT now(),
  acted_at       timestamptz(3),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  CHECK (num_nonnulls(child_id, pregnancy_id) <= 1),
  FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id),
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id),
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id)
);
-- Tối đa 1 gợi ý hiệu lực/ngày/Parent; “Gợi ý khác” = dòng cũ REPLACED + dòng mới (≤ prompts.maxNextPerDay)
CREATE UNIQUE INDEX uq_prompt_day ON app.memory_prompt_deliveries(user_id, local_date) WHERE (status IN ('SHOWN','USED')) AND deleted_at IS NULL;
CREATE INDEX ix_prompt_recent ON app.memory_prompt_deliveries(user_id, local_date DESC, template_code);   -- không lặp 30 ngày

CREATE TABLE app.story_views (                   -- “Hôm nay của con”: mốc đã xem theo TỪNG người (7.8.9, AC-028)
  user_id        uuid NOT NULL REFERENCES app.users(id),
  subject_type   varchar(10) NOT NULL,           -- CHILD | PREGNANCY
  subject_id uuid NOT NULL,
  family_id uuid NOT NULL REFERENCES app.families(id),
  child_id uuid, pregnancy_id uuid,
  local_date     date NOT NULL,
  seen_until     timestamptz(3) NOT NULL,           -- published_at lớn nhất người này đã xem
  updated_at     timestamptz(3) NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, subject_type, subject_id, local_date),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  CHECK ((subject_type = 'CHILD' AND child_id IS NOT NULL AND subject_id = child_id AND pregnancy_id IS NULL) OR (subject_type = 'PREGNANCY' AND pregnancy_id IS NOT NULL AND subject_id = pregnancy_id AND child_id IS NULL)),
  FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id),
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id)
);

-- Trigger cập nhật search_tsv (SQL migration)
CREATE FUNCTION app.memories_tsv() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.search_tsv := to_tsvector('simple',
      unaccent(coalesce(NEW.title,'') || ' ' || coalesce(NEW.body,'') || ' ' || coalesce(NEW.location_label,'')));
  RETURN NEW;
END $$;
CREATE TRIGGER trg_memories_tsv BEFORE INSERT OR UPDATE OF title, body, location_label
  ON app.memories FOR EACH ROW EXECUTE FUNCTION app.memories_tsv();


CREATE TABLE app.events (
  id               uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id        uuid NOT NULL REFERENCES app.families(id),
  type             varchar(20) NOT NULL,          -- CHILD | FAMILY | COUPLE | MEMORY_REMINDER | NOTE
  title            varchar(120) NOT NULL,
  notes            text,
  all_day          boolean NOT NULL DEFAULT true,
  start_at         timestamptz(3) NOT NULL,
  end_at           timestamptz(3),
  is_lunar         boolean NOT NULL DEFAULT false,
  lunar_month      smallint, lunar_day smallint, lunar_leap boolean,
  repeat_yearly    boolean NOT NULL DEFAULT false,
  invite_circle    boolean NOT NULL DEFAULT false,  -- chỉ có hiệu lực ở gói FAMILY
  created_by       uuid NOT NULL REFERENCES app.users(id),
  created_at       timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at       timestamptz(3),
  UNIQUE (id, family_id),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  timezone varchar(64) NOT NULL DEFAULT 'Asia/Ho_Chi_Minh',
  local_start_date date NOT NULL,
  local_end_date date,
  rrule text,
  version integer NOT NULL DEFAULT 1,
  CHECK (end_at IS NULL OR end_at >= start_at),
  CHECK (local_end_date IS NULL OR local_end_date >= local_start_date),
  CHECK (lunar_month IS NULL OR lunar_month BETWEEN 1 AND 12),
  CHECK (lunar_day IS NULL OR lunar_day BETWEEN 1 AND 30),
  CHECK (type IN ('CHILD','FAMILY','COUPLE','MEMORY_REMINDER','NOTE')),
  CHECK (type NOT IN ('COUPLE','NOTE','MEMORY_REMINDER') OR NOT invite_circle),
  CHECK (NOT is_lunar OR (lunar_month IS NOT NULL AND lunar_day IS NOT NULL))
);
CREATE TABLE app.event_children (
  event_id uuid NOT NULL, child_id uuid NOT NULL, family_id uuid NOT NULL,
  PRIMARY KEY (event_id, child_id),
  FOREIGN KEY (event_id, family_id) REFERENCES app.events(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);

CREATE TABLE app.prep_items (                      -- checklist chuẩn bị đón bé
  id            uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id     uuid NOT NULL,
  pregnancy_id  uuid NOT NULL,
  group_code    varchar(20) NOT NULL,              -- HOSPITAL_BAG | NEWBORN | NURSERY | PAPERS | CUSTOM
  title         varchar(120) NOT NULL,
  sort_order    int NOT NULL DEFAULT 0,
  done_at       timestamptz(3), done_by uuid,
  mission_id    uuid,
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  UNIQUE (id, family_id),
  FOREIGN KEY (done_by) REFERENCES app.users(id)
);


CREATE TABLE app.mission_templates (                -- thư viện định sẵn (nghiệp vụ 17.1), quản trị ở ADM-06..10
  id                  uuid PRIMARY KEY DEFAULT uuidv7(),
  code                varchar(20) NOT NULL UNIQUE,   -- PG-04, NB-05, …
  stage               varchar(10) NOT NULL,          -- PREGNANCY | CHILD | ANY
  min_age_days        int,  max_age_days int,        -- CHILD
  min_preg_week       smallint, max_preg_week smallint,
  category            app.mission_category NOT NULL, -- gồm SELF (chăm bản thân mẹ bầu/sau sinh); không dùng CUSTOM
  suggested_scope     app.mission_scope NOT NULL,
  role_fit            app.mission_role_fit NOT NULL DEFAULT 'ANY_PARENT',
                                                     -- PREGNANT_MOTHER = người mang thai (tuần ≥ 28) / mẹ ≤ 6 tuần sau sinh;
                                                     -- PARTNER_OF_PREGNANT = bạn đời của người đó; TOGETHER = chỉ bày ở tab Cùng nhau;
                                                     -- ngoài thai kỳ & hậu sản không gán theo giới
  hearts              smallint NOT NULL CHECK (hearts BETWEEN 1 AND 10),   -- dùng để cân bằng bảng ngày (BR-019)
  duration_min        smallint NOT NULL,
  multi_child_ok      boolean NOT NULL DEFAULT true, -- cho phép gắn ≥ 2 bé (MULTI_CHILD)
  requestable         boolean NOT NULL DEFAULT true, -- dùng được khi gửi Lời nhờ TASK (US-03)
  title_i18n          jsonb NOT NULL,
  desc_i18n           jsonb,
  memory_prompt_i18n  jsonb,
  tags                text[] NOT NULL DEFAULT '{}',
  weight              smallint NOT NULL DEFAULT 10,  -- trọng số chọn ngẫu nhiên
  rollout_pct         smallint NOT NULL DEFAULT 100,
  status              varchar(10) NOT NULL DEFAULT 'ACTIVE',
  version             int NOT NULL DEFAULT 1,
  updated_at          timestamptz(3) NOT NULL DEFAULT now(),
  CHECK (category <> 'CUSTOM'),
  CHECK (suggested_scope <> 'COUPLE' OR role_fit = 'TOGETHER'), -- “Hai ta” luôn là Cùng nhau
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  CHECK (duration_min > 0 AND weight > 0 AND rollout_pct BETWEEN 0 AND 100)
);
CREATE INDEX ix_tpl_pick   ON app.mission_templates(stage, role_fit, category) WHERE (status = 'ACTIVE') AND deleted_at IS NULL;
CREATE INDEX ix_tpl_hearts ON app.mission_templates(category, hearts)          WHERE (status = 'ACTIVE') AND deleted_at IS NULL;  -- ứng viên Đổi (Hearts ±1)

CREATE TABLE app.mission_family_settings (          -- cấu hình CẤP GIA ĐÌNH (CARE-12), áp dụng cho cả hai Parent
  family_id          uuid PRIMARY KEY REFERENCES app.families(id),
  board_level        app.mission_board_level NOT NULL DEFAULT 'MEDIUM',   -- áp dụng từ bảng ngày kế tiếp
  updated_by         uuid REFERENCES app.users(id),  -- ai đổi cũng được → outbox MissionBoardLevelChanged báo người kia
  updated_at         timestamptz(3) NOT NULL DEFAULT now(),
  version            int NOT NULL DEFAULT 1,
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);

CREATE TABLE app.mission_preferences (              -- cài đặt riêng từng Parent (CARE-12)
  family_id            uuid NOT NULL REFERENCES app.families(id),
  user_id              uuid NOT NULL REFERENCES app.users(id),
  disabled_categories  app.mission_category[] NOT NULL DEFAULT '{}', -- category không muốn nhận (vẫn bày đủ số lượng)
  board_push_time      time NOT NULL DEFAULT '07:00',               -- giờ thông báo “bảng nhiệm vụ hôm nay”
  evening_carry_over   boolean NOT NULL DEFAULT true,               -- 21:00 hỏi chuyển nhiệm vụ TỰ THÊM sang mai
  default_reminder_min smallint,                                    -- nhắc mặc định khi tự thêm
  PRIMARY KEY (family_id, user_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);

-- Bảng nhiệm vụ của một ngày (1 dòng/gia đình/ngày) — khoá idempotent của job bày bảng
CREATE TABLE app.daily_mission_boards (
  family_id          uuid NOT NULL REFERENCES app.families(id),
  board_date         date NOT NULL,                  -- ngày theo timezone family
  level              app.mission_board_level NOT NULL,
  per_parent_count   smallint NOT NULL,              -- 2 | 3 | 4 (bằng nhau cho hai Parent — BR-019)
  together_count     smallint NOT NULL,              -- 0..1
  balance_diff       smallint NOT NULL CHECK (balance_diff BETWEEN 0 AND 2),  -- |ΣHearts A − ΣHearts B| lúc bày
  generator_version  smallint NOT NULL,
  seed               bigint NOT NULL,                -- tái lập kết quả khi debug
  generated_at       timestamptz(3) NOT NULL DEFAULT now(),
  bloomed_at         timestamptz(3),                    -- cả hai xong hết bộ SYSTEM + Cùng nhau → cây nở hoa
  PRIMARY KEY (family_id, board_date),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  CHECK (per_parent_count IN (2,3,4) AND together_count BETWEEN 0 AND 1),
  CHECK (generator_version > 0)
);

-- Phần của từng Parent trong bảng ngày — CHỈ phục vụ audit/đếm lượt Đổi, KHÔNG bao giờ trả qua API
CREATE TABLE app.daily_mission_board_parents (
  family_id          uuid NOT NULL,
  board_date         date NOT NULL,
  user_id            uuid NOT NULL REFERENCES app.users(id),
  quota_count        smallint NOT NULL,              -- số nhiệm vụ SYSTEM được bày
  hearts_total       smallint NOT NULL,              -- tổng Hearts bộ lúc bày (audit BR-019, nội bộ)
  swaps_used         smallint NOT NULL DEFAULT 0 CHECK (swaps_used BETWEEN 0 AND 3),   -- Đổi ≤ 3 lần/người/ngày
  PRIMARY KEY (family_id, board_date, user_id),
  FOREIGN KEY (family_id, board_date) REFERENCES app.daily_mission_boards(family_id, board_date) ON DELETE CASCADE,
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);

CREATE TABLE app.mission_series (                   -- chỉ cho nhiệm vụ TỰ THÊM (7.13.6); không tính định mức
  id                uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id         uuid NOT NULL REFERENCES app.families(id),
  created_by        uuid NOT NULL REFERENCES app.users(id),
  owner_kind        app.mission_owner_kind NOT NULL,
  owner_user_id     uuid REFERENCES app.users(id),   -- = created_by khi PARENT; null khi TOGETHER
  template_id       uuid REFERENCES app.mission_templates(id),   -- null = tự gõ (2 Hearts)
  title             varchar(120) NOT NULL,
  note              varchar(500),
  category          app.mission_category NOT NULL,
  target_scope      app.mission_scope NOT NULL,
  hearts            smallint NOT NULL CHECK (hearts BETWEEN 1 AND 10),
  rrule             text NOT NULL,                   -- RFC 5545: DAILY | BYDAY=MO..FR | SA,SU | chọn thứ | INTERVAL=N | BYMONTHDAY=X
  time_of_day       time,
  reminder_offset_min smallint,
  start_date        date NOT NULL,
  end_date          date,
  paused_ranges     jsonb NOT NULL DEFAULT '[]',     -- [{"from":"2026-10-10","to":"2026-10-15"}] — “Tạm dừng chuỗi”
  generated_until   date,
  status            varchar(10) NOT NULL DEFAULT 'ACTIVE',   -- ACTIVE | PAUSED | ENDED
  created_at        timestamptz(3) NOT NULL DEFAULT now(),
  version           int NOT NULL DEFAULT 1,
  UNIQUE (id, family_id),
  CHECK ((owner_kind = 'PARENT') = (owner_user_id IS NOT NULL)),
  CHECK (owner_kind = 'TOGETHER' OR owner_user_id = created_by),          -- BR-020
  CHECK (target_scope <> 'COUPLE' OR owner_kind = 'TOGETHER'),
  CHECK (template_id IS NOT NULL OR hearts = 2), -- tự gõ = 2 Hearts (BR-069)
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  timezone varchar(64) NOT NULL DEFAULT 'Asia/Ho_Chi_Minh',
  CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE app.missions (
  id                 uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id          uuid NOT NULL REFERENCES app.families(id),
  board_date         date NOT NULL,                      -- ngày của bảng theo timezone family
  owner_kind         app.mission_owner_kind NOT NULL,    -- PARENT | TOGETHER
  owner_user_id      uuid REFERENCES app.users(id),      -- Parent chủ nhiệm vụ; NULL khi TOGETHER
  source             app.mission_source NOT NULL,        -- SYSTEM (bày 05:00) | LIBRARY | CUSTOM | SERIES
  template_id        uuid REFERENCES app.mission_templates(id),
  series_id          uuid,
  swapped_from_id    uuid,                               -- nhiệm vụ SYSTEM bị Đổi ra (CARE-05)
  swap_count         smallint NOT NULL DEFAULT 0,        -- số lần đã đổi trong chuỗi đổi (mới = cũ + 1)
  ref_type           varchar(20),                        -- PREP_ITEM | CONFLICT_STEP | REQUEST (“Tự mình làm”) — chỉ truy vết
  ref_id             uuid,
  title              varchar(120) NOT NULL,
  note               varchar(500),
  category           app.mission_category NOT NULL,
  target_scope       app.mission_scope NOT NULL,
  hearts             smallint NOT NULL CHECK (hearts BETWEEN 1 AND 10),  -- snapshot khi tạo; tự gõ = 2 (BR-069)
  status             app.mission_status NOT NULL DEFAULT 'TODO',
  scheduled_time     time,
  due_at             timestamptz(3),                        -- board_date + scheduled_time → UTC
  reminder_at        timestamptz(3),
  memory_prompt      boolean NOT NULL DEFAULT true,
  completed_by       uuid REFERENCES app.users(id),      -- người bấm (TOGETHER: một trong hai)
  completed_at       timestamptz(3),
  late               boolean NOT NULL DEFAULT false,     -- ghi muộn: EXPIRED → DONE trước hết ngày board_date + 1
  removed_reason     varchar(15),                        -- SKIPPED_TODAY | SWAPPED | DELETED | CARRIED_OVER | SERIES_EDIT | CHILD_ARCHIVED
  removed_at         timestamptz(3),
  created_by         uuid REFERENCES app.users(id),      -- null = hệ thống (SYSTEM, SERIES)
  created_at         timestamptz(3) NOT NULL DEFAULT now(),
  updated_at         timestamptz(3) NOT NULL DEFAULT now(),
  version            int NOT NULL DEFAULT 1,
  UNIQUE (id, family_id),
  FOREIGN KEY (series_id, family_id) REFERENCES app.mission_series(id, family_id),
  CHECK ((owner_kind = 'PARENT') = (owner_user_id IS NOT NULL)),
  CHECK (source IN ('SYSTEM','SERIES') OR owner_kind = 'TOGETHER' OR owner_user_id = created_by), -- BR-020: không tạo cho bạn đời
  CHECK ((source = 'SERIES') = (series_id IS NOT NULL)),
  CHECK (source <> 'CUSTOM' OR (template_id IS NULL AND hearts = 2)),
  CHECK (target_scope <> 'COUPLE' OR owner_kind = 'TOGETHER'),
  CHECK ((status = 'DONE') = (completed_at IS NOT NULL AND completed_by IS NOT NULL)),
  CHECK (NOT late OR status = 'DONE'),
  CHECK ((status = 'REMOVED') = (removed_reason IS NOT NULL)),
  deleted_at timestamptz(3) DEFAULT NULL,
  FOREIGN KEY (swapped_from_id, family_id) REFERENCES app.missions(id, family_id),
  CHECK (swap_count >= 0 AND version > 0),
  CHECK (source IN ('SYSTEM','SERIES') OR created_by IS NOT NULL),
  CHECK (status = 'DONE' OR (completed_at IS NULL AND completed_by IS NULL))
);
-- Bảng ngày theo tab (CARE-01): Của tôi / Của bạn đời / Cùng nhau
CREATE INDEX ix_missions_board ON app.missions(family_id, board_date, owner_kind, owner_user_id) WHERE (status <> 'REMOVED') AND deleted_at IS NULL;
-- Bày bảng idempotent + 1 template không xuất hiện 2 lần trong bộ hệ thống của một ngày
CREATE UNIQUE INDEX uq_board_template ON app.missions(family_id, board_date, template_id)
  WHERE (source = 'SYSTEM' AND status <> 'REMOVED') AND deleted_at IS NULL;
-- Không lặp trong 14 ngày (tra template đã dùng gần đây, mọi trạng thái)
CREATE INDEX ix_missions_tpl_recent ON app.missions(family_id, board_date, template_id) WHERE (template_id IS NOT NULL) AND deleted_at IS NULL;
CREATE INDEX ix_missions_due     ON app.missions(due_at) WHERE (status = 'TODO' AND due_at IS NOT NULL) AND deleted_at IS NULL;
CREATE INDEX ix_missions_expire  ON app.missions(board_date) WHERE (status = 'TODO') AND deleted_at IS NULL;                    -- job hết ngày
CREATE INDEX ix_missions_history ON app.missions(family_id, owner_user_id, board_date DESC) WHERE (status IN ('DONE','EXPIRED')) AND deleted_at IS NULL;
-- 1 instance/chuỗi/ngày ⇒ Hearts tối đa 1 lần/chuỗi/ngày
CREATE UNIQUE INDEX uq_series_day ON app.missions(series_id, board_date) WHERE (series_id IS NOT NULL AND status <> 'REMOVED') AND deleted_at IS NULL;

CREATE TABLE app.mission_children (
  mission_id  uuid NOT NULL,
  child_id    uuid NOT NULL,
  family_id   uuid NOT NULL,
  PRIMARY KEY (mission_id, child_id),
  FOREIGN KEY (mission_id, family_id) REFERENCES app.missions(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (child_id,  family_id)  REFERENCES app.children(id, family_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE INDEX ON app.mission_children(child_id);

CREATE TABLE app.mission_events (                   -- nhật ký (REMOVED chỉ còn ở đây)
  id            bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  mission_id    uuid NOT NULL REFERENCES app.missions(id) ON DELETE CASCADE,
  actor_user_id uuid,
  type          varchar(30) NOT NULL,   -- GENERATED|CREATED|SWAPPED|REMOVED|COMPLETED|LATE_COMPLETED|UNDONE|EXPIRED|
                                        -- CARRIED_OVER|EDITED|THANKED
  data          jsonb,                  -- không ghi Hearts của người khác
  created_at    timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  family_id uuid NOT NULL REFERENCES app.families(id),
  FOREIGN KEY (mission_id, family_id) REFERENCES app.missions(id, family_id),
  FOREIGN KEY (actor_user_id) REFERENCES app.users(id)
);
CREATE INDEX ON app.mission_events(mission_id, created_at);

CREATE TABLE app.mission_completions (
  id               uuid PRIMARY KEY DEFAULT uuidv7(),
  mission_id       uuid NOT NULL REFERENCES app.missions(id),
  completed_by     uuid NOT NULL REFERENCES app.users(id),
  completed_at     timestamptz(3) NOT NULL DEFAULT now(),
  late             boolean NOT NULL DEFAULT false,
  note             varchar(500),
  memory_id        uuid,
  idempotency_key  uuid NOT NULL UNIQUE,
  undone_at        timestamptz(3),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  family_id uuid NOT NULL REFERENCES app.families(id),
  FOREIGN KEY (mission_id, family_id) REFERENCES app.missions(id, family_id),
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id),
  UNIQUE (id, family_id)
);
-- Chỉ 1 completion hiệu lực / nhiệm vụ → chặn hai người cùng bấm “Xong cùng nhau”
-- (TOGETHER: 1 completion → 2 dòng heart_ledger, mỗi Parent 1 dòng, cùng source_id = completion.id)
CREATE UNIQUE INDEX uq_mission_completion_active ON app.mission_completions(mission_id) WHERE (undone_at IS NULL) AND deleted_at IS NULL;

-- Hearts: sổ cái bất biến THEO TỪNG NGƯỜI (BR-017, BR-018) — API chỉ đọc dòng của chính người gọi
CREATE TABLE app.heart_ledger (
  id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  family_id      uuid NOT NULL REFERENCES app.families(id),
  user_id        uuid NOT NULL REFERENCES app.users(id),   -- người NHẬN Hearts (Parent)
  source_type    varchar(20) NOT NULL,   -- MISSION | MISSION_PHOTO | REQUEST | MEMORY | PERSPECTIVE | MILESTONE | APPRECIATION
  source_id      uuid NOT NULL,          -- MISSION, MISSION_PHOTO: mission_completions.id (hoàn tác rồi làm lại = completion mới)
                                         -- REQUEST: us.requests.id • MEMORY: memories.id • MILESTONE • APPRECIATION
  reason         varchar(30) NOT NULL,   -- MISSION_COMPLETED | CUSTOM_COMPLETED | MISSION_PHOTO | REQUEST_DONE |
                                         -- MEMORY_CREATED | PERSPECTIVE_ADDED | MILESTONE_RECORDED | APPRECIATION_SENT | REVERSAL
  amount         smallint NOT NULL,      -- > 0; âm CHỈ ở bút toán ngược
  reversal_of    bigint REFERENCES app.heart_ledger(id),
  local_date     date NOT NULL,          -- ngày ghi nhận theo timezone family (trần/ngày, “hôm nay”, “tuần này”)
  created_at     timestamptz(3) NOT NULL DEFAULT now(),
  CHECK ((reason = 'REVERSAL') = (reversal_of IS NOT NULL)),
  CHECK ((reason = 'REVERSAL' AND amount < 0) OR (reason <> 'REVERSAL' AND amount > 0)),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  UNIQUE (id, family_id, user_id),
  FOREIGN KEY (reversal_of, family_id, user_id) REFERENCES app.heart_ledger(id, family_id, user_id)
);
CREATE UNIQUE INDEX uq_heart_once     ON app.heart_ledger(user_id, source_type, source_id, reason) WHERE (reversal_of IS NULL) AND deleted_at IS NULL; -- idempotent
CREATE UNIQUE INDEX uq_heart_reversal ON app.heart_ledger(reversal_of) WHERE (reversal_of IS NOT NULL) AND deleted_at IS NULL;                     -- đảo ≤ 1 lần
CREATE INDEX ix_heart_user_day ON app.heart_ledger(user_id, local_date DESC);   -- lịch sử “Hearts của tôi” (CARE-09)
CREATE INDEX ON app.heart_ledger(family_id, created_at);

-- Bộ đếm theo người/ngày: enforce trần trong CÙNG transaction bằng khoá dòng (thay Redis counter của v2)
CREATE TABLE app.heart_daily_counters (
  family_id      uuid NOT NULL REFERENCES app.families(id),
  user_id        uuid NOT NULL REFERENCES app.users(id),
  local_date     date NOT NULL,
  total          smallint NOT NULL DEFAULT 0 CHECK (total >= 0),  -- ≤ hearts.dailyCap (75/người/ngày — BR-069)
  custom_count   smallint NOT NULL DEFAULT 0,   -- số lần tính Hearts CUSTOM (≤ 3)
  photo_count    smallint NOT NULL DEFAULT 0,   -- đính ảnh khi hoàn thành (≤ 5)
  memory_count   smallint NOT NULL DEFAULT 0,   -- tạo ký ức + thêm góc nhìn (≤ 5, dùng chung)
  thanks_count   smallint NOT NULL DEFAULT 0,   -- gửi cảm ơn (≤ 3)
  PRIMARY KEY (user_id, local_date),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  CHECK (custom_count >= 0 AND photo_count >= 0 AND memory_count >= 0 AND thanks_count >= 0)
);

-- Cây gia đình: tổng Hearts của hai Parent (cache; nguồn đúng = ledger). Không lưu phần đóng góp theo người.
CREATE TABLE app.family_trees (
  family_id      uuid PRIMARY KEY REFERENCES app.families(id),
  total_hearts   int NOT NULL DEFAULT 0 CHECK (total_hearts >= 0), -- KHÔNG trả qua API (6.6)
  level          smallint NOT NULL DEFAULT 1,     -- 1..7 theo ngưỡng 0/100/300/700/1500/3000/6000 (ops.app_config tree.levels); không giảm
  fruits         smallint NOT NULL DEFAULT 0,     -- cấp 7: mỗi 3.000 tiếp theo một “quả”
  flowers        int NOT NULL DEFAULT 0,          -- số ngày cây nở hoa (“Những ngày tròn đầy”)
  updated_at     timestamptz(3) NOT NULL DEFAULT now(),
  version        int NOT NULL DEFAULT 1,
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  CHECK (level BETWEEN 1 AND 7 AND fruits >= 0 AND flowers >= 0)
);

CREATE TABLE app.badges (
  code         varchar(30) PRIMARY KEY,
  title_i18n   jsonb NOT NULL, desc_i18n jsonb NOT NULL,
  icon         varchar(60) NOT NULL,
  rule         jsonb NOT NULL,   -- {"metric":"MISSION_COMPLETED","filter":{"tags":["bedtime"]},"count":7,"window":"ALL"} — không dựa trên Hearts cá nhân
  scope        varchar(10) NOT NULL DEFAULT 'FAMILY',   -- FAMILY | CIRCLE_MEMBER
  status       varchar(10) NOT NULL DEFAULT 'ACTIVE',
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE app.family_badges (
  id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  family_id    uuid NOT NULL REFERENCES app.families(id),
  badge_code   varchar(30) NOT NULL REFERENCES app.badges(code),
  subject_user_id uuid,                        -- với badge CIRCLE_MEMBER (null = badge của gia đình)
  achieved_at  timestamptz(3) NOT NULL DEFAULT now(),
  UNIQUE NULLS NOT DISTINCT (family_id, badge_code, subject_user_id), -- PG15+
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  FOREIGN KEY (subject_user_id) REFERENCES app.users(id)
);

CREATE TABLE app.care_weekly_snapshots (         -- Thống kê chăm con — CHỈ cấp gia đình (BR-025)
  family_id   uuid NOT NULL,
  week_start  date NOT NULL,
  child_id    uuid,                            -- null = toàn family
  metrics     jsonb NOT NULL,                  -- {"byCategory":{"CARE":12,..},"together":5,"bloomedDays":4} — KHÔNG có byUser
  computed_at timestamptz(3) NOT NULL DEFAULT now(),
  UNIQUE NULLS NOT DISTINCT (family_id, week_start, child_id), -- PK không được chứa cột NULL
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  id uuid PRIMARY KEY DEFAULT uuidv7(),
  FOREIGN KEY (family_id) REFERENCES app.families(id),
  FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)
);


-- Scope and ownership checks are declared after all tables below.

CREATE TABLE us.mood_checkins (
  id               uuid PRIMARY KEY DEFAULT uuidv7(),
  couple_space_id  uuid NOT NULL REFERENCES app.couple_spaces(id),
  user_id          uuid NOT NULL REFERENCES app.users(id),
  mood             us.mood NOT NULL,
  energy           smallint CHECK (energy BETWEEN 1 AND 5),
  needs            us.need[] NOT NULL DEFAULT '{}',
  note_enc         bytea,                         -- mã hoá bằng DEK cá nhân (không bao giờ đọc được bởi partner nếu không share)
  shared           boolean NOT NULL DEFAULT false,
  shared_fields    text[] NOT NULL DEFAULT '{}',  -- mood | energy | needs | note
  shared_note_enc  bytea,                         -- bản note đã chia sẻ (mã hoá bằng DEK couple)
  expires_at       timestamptz(3) NOT NULL,
  seen_by_partner_at timestamptz(3),
  created_at       timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at       timestamptz(3),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  family_id uuid NOT NULL REFERENCES app.families(id),
  FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id),
  UNIQUE (id, family_id),
  UNIQUE (id, family_id, couple_space_id),
  CHECK (expires_at > created_at)
);
CREATE INDEX ON us.mood_checkins(couple_space_id, created_at DESC);
CREATE INDEX ON us.mood_checkins(user_id, created_at DESC);

CREATE TABLE us.mood_responses (
  id          uuid PRIMARY KEY DEFAULT uuidv7(),
  checkin_id  uuid NOT NULL REFERENCES us.mood_checkins(id) ON DELETE CASCADE,
  user_id     uuid NOT NULL,
  type        varchar(20) NOT NULL,     -- SEEN | ASK_NEED | TAKE_OVER | HUG
  request_id  uuid,                     -- TAKE_OVER (“Để mình lo”) → Lời nhờ TASK ACCEPTED, volunteered = true
  created_at  timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  family_id uuid NOT NULL REFERENCES app.families(id),
  couple_space_id uuid NOT NULL,
  FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id),
  FOREIGN KEY (user_id) REFERENCES app.users(id),
  FOREIGN KEY (checkin_id, family_id, couple_space_id) REFERENCES us.mood_checkins(id, family_id, couple_space_id)
);

-- Lời nhờ (nghiệp vụ 7.16.2) — thay us.support_requests; cách DUY NHẤT để nhờ bạn đời (C-16).
-- Không bao giờ trả cho Circle, không nằm trong tab nhiệm vụ (BR-070).
CREATE TABLE us.requests (
  id                uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id         uuid NOT NULL REFERENCES app.families(id),
  couple_space_id   uuid NOT NULL REFERENCES app.couple_spaces(id),
  sender_user_id    uuid NOT NULL REFERENCES app.users(id),
  receiver_user_id  uuid NOT NULL REFERENCES app.users(id),   -- = bạn đời; với TASK là người làm
  kind              us.request_kind NOT NULL,                  -- TASK (Nhờ một việc) | NEED (Mình đang cần…)
  need_code         us.need,                                   -- NEED: QUIET|HUG|TALK|REASSURANCE • TASK: BREAK|HELP_CHILD|null
  template_id       uuid REFERENCES app.mission_templates(id),-- TASK chọn từ thư viện (requestable = true)
  title_enc         bytea,                                     -- TASK tự gõ — DEK COUPLE
  duration_min      smallint CHECK (duration_min IN (15,30,60)),  -- BREAK “Cần nghỉ 15/30/60 phút”
  content_key       bytea NOT NULL,                            -- HMAC(pepper, kind|need|template|title chuẩn hoá) — chặn gửi lại 12h
  message_enc       bytea,                                     -- lời nhắn — DEK COUPLE
  due_kind          us.request_due_kind,                       -- TASK; NEED = null
  due_at            timestamptz(3),                               -- quy đổi từ due_kind theo timezone family; ≤ created_at + 7 ngày (15.8)
  urgency           us.request_urgency NOT NULL DEFAULT 'NORMAL',
  status            us.request_status NOT NULL DEFAULT 'SENT',
  volunteered       boolean NOT NULL DEFAULT false,            -- tạo từ “Để mình lo” ở check-in (sinh thẳng ACCEPTED)
  decline_reason    varchar(30),                               -- mã lý do nhanh (tuỳ chọn) — không phạt
  ack_type          varchar(15),                               -- NEED: SEEN | HUG | TALK_TIME | ENCOURAGED
  talk_at           timestamptz(3),                               -- NEED TALK: giờ hẹn nói chuyện
  reminder_at       timestamptz(3),                               -- tối đa 1 lần nhắc, do NGƯỜI NHẬN chọn (không có nút giục)
  hearts_awarded    smallint NOT NULL DEFAULT 0 CHECK (hearts_awarded >= 0),  -- TASK DONE: Hearts thực cộng cho người làm;
                                                               -- chỉ serialize cho receiver (6.6)
  self_mission_id   uuid,                                      -- “Tự mình làm” sau khi bị từ chối
  seen_at           timestamptz(3),
  responded_at      timestamptz(3),                               -- accept / decline / acknowledge
  done_at           timestamptz(3),
  cancelled_at      timestamptz(3),
  expires_at        timestamptz(3) NOT NULL,                      -- TASK: due_at + 2h • NEED: created_at + 12h
  created_at        timestamptz(3) NOT NULL DEFAULT now(),
  updated_at        timestamptz(3) NOT NULL DEFAULT now(),
  version           int NOT NULL DEFAULT 1,
  UNIQUE (id, family_id),
  CHECK (sender_user_id <> receiver_user_id),
  CHECK (due_at IS NULL OR due_at <= created_at + interval '7 days'),
  CHECK ((kind = 'NEED' AND need_code IN ('QUIET','HUG','TALK','REASSURANCE'))
      OR (kind = 'TASK' AND (need_code IS NULL OR need_code IN ('BREAK','HELP_CHILD')))),
  CHECK (kind = 'NEED' OR template_id IS NOT NULL OR title_enc IS NOT NULL OR need_code IS NOT NULL),
  CHECK (kind = 'TASK' OR (hearts_awarded = 0 AND template_id IS NULL AND due_kind IS NULL)),   -- NEED không quy đổi Hearts (BR-068)
  CHECK (status NOT IN ('ACCEPTED','DONE') OR kind = 'TASK'),
  CHECK (status <> 'ACKNOWLEDGED' OR kind = 'NEED'),
  CHECK (NOT volunteered OR kind = 'TASK'),
  deleted_at timestamptz(3) DEFAULT NULL,
  FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id),
  FOREIGN KEY (self_mission_id, family_id) REFERENCES app.missions(id, family_id),
  UNIQUE (id, family_id, couple_space_id),
  CHECK (kind <> 'NEED' OR need_code IS NOT NULL)
);
-- Tối đa 5 lời nhờ đang mở / người gửi (BR-067): đếm trên index này dưới khoá couple_spaces FOR UPDATE
CREATE INDEX ix_req_open_sender  ON us.requests(sender_user_id)
  WHERE (status IN ('SENT','SEEN','ACCEPTED') AND volunteered = false) AND deleted_at IS NULL;
-- Bị từ chối → không gửi lại cùng nội dung trong 12 giờ (BR-067)
CREATE INDEX ix_req_resend_block ON us.requests(sender_user_id, content_key, responded_at DESC) WHERE (status = 'DECLINED') AND deleted_at IS NULL;
CREATE INDEX ix_req_couple       ON us.requests(couple_space_id, status, created_at DESC);  -- “Lời nhờ đang mở” 2 chiều
CREATE INDEX ix_req_expire       ON us.requests(expires_at) WHERE (status IN ('SENT','SEEN','ACCEPTED')) AND deleted_at IS NULL;

-- Đặt tên cho con [1.1] (PREG-07) — chỉ Papa & Mama
CREATE TABLE us.pregnancy_name_candidates (
  id               uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id        uuid NOT NULL REFERENCES app.families(id),
  couple_space_id  uuid NOT NULL REFERENCES app.couple_spaces(id),
  pregnancy_id     uuid NOT NULL,
  name_enc         bytea NOT NULL,                -- DEK COUPLE
  meaning_enc      bytea,                         -- ý nghĩa tên — DEK COUPLE
  added_by         uuid NOT NULL REFERENCES app.users(id),
  chosen_at        timestamptz(3),                   -- “Chọn tên này” (≤ expected_count tên được chọn — service)
  chosen_by        uuid,
  deleted_at       timestamptz(3),
  created_at       timestamptz(3) NOT NULL DEFAULT now(),
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id),
  UNIQUE (id, family_id),
  FOREIGN KEY (chosen_by) REFERENCES app.users(id),
  UNIQUE (id, family_id, couple_space_id)
);
CREATE INDEX ON us.pregnancy_name_candidates(pregnancy_id) WHERE deleted_at IS NULL;
CREATE TABLE us.pregnancy_name_votes (           -- ❤ “thích” của từng Parent (KHÔNG phải điểm Hearts); 2 phiếu = “Cả hai thích”
  candidate_id  uuid NOT NULL REFERENCES us.pregnancy_name_candidates(id) ON DELETE CASCADE,
  user_id       uuid NOT NULL REFERENCES app.users(id),
  created_at    timestamptz(3) NOT NULL DEFAULT now(),
  PRIMARY KEY (candidate_id, user_id),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  family_id uuid NOT NULL REFERENCES app.families(id),
  couple_space_id uuid NOT NULL,
  FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id),
  FOREIGN KEY (candidate_id, family_id, couple_space_id) REFERENCES us.pregnancy_name_candidates(id, family_id, couple_space_id)
);

CREATE TABLE us.request_children (              -- bé của lời nhờ (tuỳ chọn) — composite FK cùng family
  request_id  uuid NOT NULL,
  child_id    uuid NOT NULL,
  family_id   uuid NOT NULL,
  PRIMARY KEY (request_id, child_id),
  FOREIGN KEY (request_id, family_id) REFERENCES us.requests(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (child_id,  family_id)  REFERENCES app.children(id, family_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);

CREATE TABLE us.appreciations (
  id                  uuid PRIMARY KEY DEFAULT uuidv7(),
  couple_space_id     uuid NOT NULL REFERENCES app.couple_spaces(id),
  from_user_id        uuid NOT NULL, to_user_id uuid NOT NULL,
  body_enc            bytea NOT NULL,          -- DEK couple
  sticker             varchar(40),
  linked_type         varchar(10), linked_id uuid,     -- MISSION | MEMORY | REQUEST (💛 nhanh trên việc đã xong)
  family_share_status varchar(10) NOT NULL DEFAULT 'NONE',  -- NONE | REQUESTED | APPROVED | DECLINED
  family_memory_id    uuid,                    -- ký ức tạo khi được đồng ý
  seen_at             timestamptz(3),
  reaction            varchar(20),
  created_at          timestamptz(3) NOT NULL DEFAULT now(),
  deleted_by_from_at  timestamptz(3), deleted_by_to_at timestamptz(3),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  family_id uuid NOT NULL REFERENCES app.families(id),
  FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id),
  FOREIGN KEY (from_user_id) REFERENCES app.users(id),
  FOREIGN KEY (to_user_id) REFERENCES app.users(id),
  FOREIGN KEY (family_memory_id, family_id) REFERENCES app.memories(id, family_id),
  CHECK (from_user_id <> to_user_id)
);
CREATE INDEX ON us.appreciations(couple_space_id, created_at DESC);

CREATE TABLE us.journal_entries (
  id           uuid PRIMARY KEY DEFAULT uuidv7(),
  user_id      uuid NOT NULL REFERENCES app.users(id),
  family_id    uuid NOT NULL REFERENCES app.families(id),
  title_enc    bytea,
  body_enc     bytea NOT NULL,               -- DEK cá nhân → crypto-shred khi xoá tài khoản
  mood         us.mood,
  created_at   timestamptz(3) NOT NULL DEFAULT now(),
  updated_at   timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at   timestamptz(3),
  UNIQUE (id, family_id),
  UNIQUE (id, family_id, user_id)
);
CREATE INDEX ON us.journal_entries(user_id, created_at DESC);

CREATE TABLE us.conflict_sessions (
  id               uuid PRIMARY KEY DEFAULT uuidv7(),
  couple_space_id  uuid NOT NULL REFERENCES app.couple_spaces(id),
  opened_by        uuid NOT NULL,
  status           us.conflict_status NOT NULL DEFAULT 'PRIVATE_DRAFT',
  topic            varchar(20),
  next_step        jsonb,                     -- {"code":"TALK_AFTER_SLEEP","at":"...","missionId":..}
  retention_days   smallint NOT NULL DEFAULT 30,    -- 0 = xoá ngay khi đóng
  purge_at         timestamptz(3),
  invited_at       timestamptz(3), joined_at timestamptz(3), closed_at timestamptz(3),
  last_activity_at timestamptz(3) NOT NULL DEFAULT now(),
  created_at       timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  family_id uuid NOT NULL REFERENCES app.families(id),
  FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id),
  UNIQUE (id, family_id),
  FOREIGN KEY (opened_by) REFERENCES app.users(id),
  CHECK (retention_days IN (0,7,30,90)),
  UNIQUE (id, family_id, couple_space_id)
);

CREATE TABLE us.conflict_entries (
  id                 uuid PRIMARY KEY DEFAULT uuidv7(),
  session_id         uuid NOT NULL REFERENCES us.conflict_sessions(id) ON DELETE CASCADE,
  user_id            uuid NOT NULL,
  feelings           text[] NOT NULL DEFAULT '{}',
  needs              text[] NOT NULL DEFAULT '{}',
  draft_enc          bytea,                   -- DEK cá nhân — KHÔNG BAO GIỜ trả cho partner
  shared_points_enc  bytea,                   -- DEK couple — những ý người dùng chọn chia sẻ
  share_status       varchar(10) NOT NULL DEFAULT 'PRIVATE',   -- PRIVATE | SHARED
  understood_at      timestamptz(3),
  clarify_requested_at timestamptz(3),
  created_at         timestamptz(3) NOT NULL DEFAULT now(),
  updated_at         timestamptz(3) NOT NULL DEFAULT now(),
  UNIQUE (session_id, user_id),
  deleted_at timestamptz(3) DEFAULT NULL,
  family_id uuid NOT NULL REFERENCES app.families(id),
  couple_space_id uuid NOT NULL,
  FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id),
  UNIQUE (id, family_id),
  FOREIGN KEY (user_id) REFERENCES app.users(id),
  FOREIGN KEY (session_id, family_id, couple_space_id) REFERENCES us.conflict_sessions(id, family_id, couple_space_id)
);
-- Lưu ý: KHÔNG ghi bất kỳ dấu vết nào khi user mở màn Safety (US-13).

CREATE TABLE us.connection_answers (            -- câu hỏi kết nối hằng ngày [1.1]
  couple_space_id uuid NOT NULL, prompt_code varchar(30) NOT NULL, local_date date NOT NULL,
  user_id uuid NOT NULL, answer_enc bytea NOT NULL, created_at timestamptz(3) NOT NULL DEFAULT now(),
  PRIMARY KEY (couple_space_id, local_date, user_id),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  family_id uuid NOT NULL REFERENCES app.families(id),
  FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id),
  FOREIGN KEY (user_id) REFERENCES app.users(id),
  shared_answer_enc bytea,
  shared_at timestamptz(3)
);

-- Khoá mã hoá (envelope)
CREATE TABLE us.data_keys (
  id           uuid PRIMARY KEY DEFAULT uuidv7(),
  owner_type   varchar(10) NOT NULL,          -- USER | COUPLE
  user_id uuid REFERENCES app.users(id),
  couple_space_id uuid REFERENCES app.couple_spaces(id),
  key_version integer NOT NULL DEFAULT 1 CHECK (key_version > 0),
  wrapped_dek  bytea,                -- DEK bọc bởi KEK (Vault Transit / KMS)
  kek_version  int NOT NULL,
  created_at   timestamptz(3) NOT NULL DEFAULT now(),
  destroyed_at timestamptz(3),                   -- crypto-shredding
  CHECK ((owner_type = 'USER' AND user_id IS NOT NULL AND couple_space_id IS NULL) OR (owner_type = 'COUPLE' AND couple_space_id IS NOT NULL AND user_id IS NULL)),
  CHECK ((destroyed_at IS NULL) = (wrapped_dek IS NOT NULL)),
  UNIQUE NULLS NOT DISTINCT (owner_type, user_id, couple_space_id, key_version),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);


CREATE TABLE app.recaps (
  id             uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id      uuid NOT NULL REFERENCES app.families(id),
  scope          varchar(10) NOT NULL,         -- FAMILY | CHILD
  child_id       uuid,
  period         varchar(12) NOT NULL,         -- DAY | WEEK | MONTH_AGE | YEAR
  period_start   date NOT NULL, period_end date NOT NULL,
  status         varchar(12) NOT NULL DEFAULT 'READY',   -- GENERATING | READY | SAVED | SHARED | DISMISSED
  content        jsonb NOT NULL,               -- {"stats":{..},"memoryIds":[..],"text":"...","pages":[..]}
  content_parents_only jsonb,                  -- phần chỉ Parent thấy (vd. số lời cảm ơn)
  cover_asset_id uuid,
  visibility     app.visibility NOT NULL DEFAULT 'PARENTS',
  memory_id      uuid,                         -- khi lưu vào timeline
  created_at     timestamptz(3) NOT NULL DEFAULT now(),
  UNIQUE NULLS NOT DISTINCT (family_id, scope, child_id, period, period_start),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  UNIQUE (id, family_id),
  FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id),
  FOREIGN KEY (cover_asset_id, family_id) REFERENCES app.assets(id, family_id),
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id),
  CHECK ((scope = 'FAMILY' AND child_id IS NULL) OR (scope = 'CHILD' AND child_id IS NOT NULL)),
  CHECK (period_end >= period_start)
);

CREATE TABLE app.ai_usage_monthly (
  family_id uuid NOT NULL, month date NOT NULL, used int NOT NULL DEFAULT 0,
  PRIMARY KEY (family_id, month),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  FOREIGN KEY (family_id) REFERENCES app.families(id),
  CHECK (used >= 0 AND extract(day FROM month) = 1)
);

CREATE TABLE ops.notification_templates (
  code        varchar(40) NOT NULL,            -- MISSIONS_TODAY, REQUEST_RECEIVED, MOOD_SHARED, ... (không template nào có biến Hearts)
  locale      varchar(10) NOT NULL,
  title       varchar(120) NOT NULL,
  body        varchar(300) NOT NULL,           -- biến {{partnerCallName}}, {{childNames}}, ...
  sensitive   boolean NOT NULL DEFAULT false,
  hidden_title varchar(120), hidden_body varchar(300),  -- bản khi ẩn nội dung màn hình khoá
  category    varchar(20) NOT NULL,            -- MEMORY | MISSION | US | CONFLICT | APPRECIATION | MILESTONE | RECAP | CIRCLE | BILLING | SYSTEM | MARKETING
  priority    varchar(10) NOT NULL DEFAULT 'NORMAL',  -- NORMAL | HIGH (không tính vào trần 3/ngày)
  enabled     boolean NOT NULL DEFAULT true,
  PRIMARY KEY (code, locale),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);


-- BILLING: replaced by normalized family-owned license schema below.

CREATE TABLE app.reports (
  id                 uuid PRIMARY KEY DEFAULT uuidv7(),
  reporter_user_id   uuid NOT NULL REFERENCES app.users(id),
  family_id          uuid REFERENCES app.families(id),
  target_type        app.report_target NOT NULL,
  target_id          uuid NOT NULL,
  target_owner_id    uuid,
  reason             app.report_reason NOT NULL,
  detail             varchar(1000),
  severity           smallint NOT NULL DEFAULT 2,     -- 1 = cao nhất (CHILD_SAFETY)
  status             app.report_status NOT NULL DEFAULT 'NEW',
  auto_hidden        boolean NOT NULL DEFAULT false,
  hide_for_reporter  boolean NOT NULL DEFAULT false,
  sla_due_at         timestamptz(3) NOT NULL,
  created_at         timestamptz(3) NOT NULL DEFAULT now(),
  closed_at          timestamptz(3),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE INDEX ON app.reports(status, severity, created_at);

CREATE TABLE app.report_hides (                -- “Ẩn với tôi”
  user_id uuid NOT NULL, target_type app.report_target NOT NULL, target_id uuid NOT NULL,
  created_at timestamptz(3) NOT NULL DEFAULT now(), PRIMARY KEY (user_id, target_type, target_id),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  FOREIGN KEY (user_id) REFERENCES app.users(id)
);

CREATE TABLE ops.moderation_cases (
  id               uuid PRIMARY KEY DEFAULT uuidv7(),
  target_type      app.report_target NOT NULL, target_id uuid NOT NULL,
  priority         smallint NOT NULL,
  status           varchar(15) NOT NULL DEFAULT 'OPEN',   -- OPEN | IN_REVIEW | RESOLVED
  assignee_admin_id uuid,
  sla_due_at       timestamptz(3) NOT NULL,
  created_at       timestamptz(3) NOT NULL DEFAULT now(),
  resolved_at      timestamptz(3),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE ops.moderation_actions (
  id          uuid PRIMARY KEY DEFAULT uuidv7(),
  case_id     uuid NOT NULL REFERENCES ops.moderation_cases(id),
  admin_id    uuid NOT NULL,
  action      varchar(30) NOT NULL,      -- NO_ACTION | REMOVE_CONTENT | WARN | SUSPEND | REMOVE_MEMBER | BAN | ESCALATE_LEGAL
  reason_note varchar(1000) NOT NULL,
  created_at  timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);

CREATE TABLE app.deletion_requests (
  id                  uuid PRIMARY KEY DEFAULT uuidv7(),
  user_id             uuid NOT NULL REFERENCES app.users(id),
  source              varchar(10) NOT NULL,           -- APP | WEB | ADMIN
  family_choice       varchar(20) NOT NULL,           -- NONE | DELETE_FAMILY | PARTNER_CONTINUES
  shared_content_choice varchar(20) NOT NULL,         -- KEEP_ANONYMIZED | DELETE
  status              varchar(12) NOT NULL DEFAULT 'SCHEDULED',  -- SCHEDULED | CANCELLED | RUNNING | COMPLETED | FAILED
  requested_at        timestamptz(3) NOT NULL DEFAULT now(),
  execute_after       timestamptz(3) NOT NULL,           -- +30 ngày
  completed_at        timestamptz(3),
  steps               jsonb NOT NULL DEFAULT '{}', -- tiến độ từng bước (idempotent resume)
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  family_id uuid REFERENCES app.families(id),
  requested_membership_id uuid REFERENCES app.family_parents(id),
  cancelled_at timestamptz(3),
  failure_code varchar(80)
);
CREATE UNIQUE INDEX uq_deletion_active ON app.deletion_requests(user_id) WHERE (status IN ('SCHEDULED','RUNNING')) AND deleted_at IS NULL;

CREATE TABLE app.export_jobs (
  id            uuid PRIMARY KEY DEFAULT uuidv7(),
  requester_id  uuid NOT NULL REFERENCES app.users(id),
  family_id     uuid,
  scope         varchar(10) NOT NULL,        -- FAMILY | PERSONAL
  status        varchar(12) NOT NULL DEFAULT 'QUEUED',
  storage_key   text, size_bytes bigint,
  expires_at    timestamptz(3),
  created_at    timestamptz(3) NOT NULL DEFAULT now(),
  completed_at  timestamptz(3),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  access_snapshot jsonb NOT NULL DEFAULT '{}',
  access_rechecked_at timestamptz(3),
  error_code varchar(80),
  FOREIGN KEY (family_id) REFERENCES app.families(id),
  CHECK (scope IN ('FAMILY','PERSONAL'))
);

CREATE TABLE ops.outbox_events (
  id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  event_type     varchar(60) NOT NULL,
  aggregate_id   uuid,
  family_id      uuid,
  payload        jsonb NOT NULL,
  created_at     timestamptz(3) NOT NULL DEFAULT now(),
  published_at   timestamptz(3),
  attempts       int NOT NULL DEFAULT 0,
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  event_id uuid NOT NULL DEFAULT uuidv7() UNIQUE,
  available_at timestamptz(3) NOT NULL DEFAULT now(),
  lease_owner varchar(100),
  lease_expires_at timestamptz(3),
  fencing_token bigint NOT NULL DEFAULT 0,
  last_error_code varchar(80),
  FOREIGN KEY (family_id) REFERENCES app.families(id),
  CHECK (attempts >= 0 AND fencing_token >= 0)
);
CREATE INDEX ix_outbox_unpublished ON ops.outbox_events(id) WHERE (published_at IS NULL) AND deleted_at IS NULL;

CREATE TABLE ops.sync_tombstones (            -- phục vụ delta sync xoá/thu hồi
  id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  family_id    uuid NOT NULL,
  entity_type  varchar(20) NOT NULL,          -- MEMORY | CHILD | MISSION | COMMENT | ...
  entity_id    uuid NOT NULL,
  audience     varchar(10) NOT NULL DEFAULT 'ALL',  -- ALL | CIRCLE (thu hồi riêng với người thân)
  created_at   timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL,
  FOREIGN KEY (family_id) REFERENCES app.families(id),
  audience_user_id uuid REFERENCES app.users(id)
);
CREATE INDEX ON ops.sync_tombstones(family_id, id);

CREATE TABLE ops.app_config (
  key         varchar(60) PRIMARY KEY,         -- hearts.rules, hearts.dailyCap, tree.levels, mission.board, request.limits, prompts.maxNextPerDay, monthlyPhoto.remindAt, notif.dailyCap, invite.ttl, minAppVersion.ios ...
  value       jsonb NOT NULL,
  updated_by  uuid, updated_at timestamptz(3) NOT NULL DEFAULT now(),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);

CREATE TABLE ops.content_items (               -- moods, needs, câu mẫu, prompts, nguồn hỗ trợ an toàn, nội dung tuần thai
  type        varchar(30) NOT NULL,            -- MOOD | NEED | NEED_TEMPLATE | REQUEST_TEMPLATE | HARSH_WORD | MONTH_STICKER | PREG_SIZE | DIARY_PROMPT | THANKS_PROMPT | CONNECTION_PROMPT | SAFETY_RESOURCE | PREG_WEEK
  code        varchar(40) NOT NULL,
  locale      varchar(10) NOT NULL,
  data        jsonb NOT NULL,
  sort_order  int NOT NULL DEFAULT 0,
  status      varchar(10) NOT NULL DEFAULT 'ACTIVE',
  version     int NOT NULL DEFAULT 1,
  PRIMARY KEY (type, code, locale),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);

CREATE TABLE ops.admin_users (
  id uuid PRIMARY KEY DEFAULT uuidv7(), email citext UNIQUE NOT NULL, password_hash text NOT NULL,
  totp_secret_enc bytea NOT NULL, roles text[] NOT NULL, status varchar(10) NOT NULL DEFAULT 'ACTIVE',
  last_login_at timestamptz(3), created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);


-- Normalized billing: BR-038/055, AC-061/065. Family ownership overrides old §18.4/18.5.
-- Confirmed BF-20261013-005: initial paid plans House/Family, configurable 7-day
-- trial, extensible catalog; license never transfers; verified paid renewals stay
-- with original family even when purchaser was deleted. Seed is separate: prisma/seed.ts and prisma/seeds/catalog.json.
CREATE TYPE billing.access_phase AS ENUM ('INCOMPLETE','TRIAL','PAID','EXPIRED','BLOCKED');
CREATE TYPE billing.grant_source AS ENUM ('TRIAL','STORE','MANUAL','PROMOTION');
CREATE TABLE billing.plans (
  id uuid PRIMARY KEY DEFAULT uuidv7(), code varchar(40) NOT NULL UNIQUE,
  display_name_i18n jsonb NOT NULL, display_order integer NOT NULL DEFAULT 0,
  purchase_enabled boolean NOT NULL DEFAULT true, active boolean NOT NULL DEFAULT true,
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE billing.plan_versions (
  id uuid PRIMARY KEY DEFAULT uuidv7(), plan_id uuid NOT NULL REFERENCES billing.plans(id),
  version integer NOT NULL CHECK (version > 0), quotas jsonb NOT NULL,
  entitlement_rank integer NOT NULL DEFAULT 0 CHECK (entitlement_rank >= 0),
  features jsonb NOT NULL DEFAULT '{}', available_from timestamptz(3) NOT NULL DEFAULT now(),
  retired_at timestamptz(3), UNIQUE (plan_id, version),
  CHECK (jsonb_typeof(quotas) = 'object' AND jsonb_typeof(features) = 'object'),
  CHECK (retired_at IS NULL OR retired_at >= available_from),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE billing.trial_policies (
  id uuid PRIMARY KEY DEFAULT uuidv7(), code varchar(60) NOT NULL,
  version integer NOT NULL CHECK (version > 0),
  plan_version_id uuid NOT NULL REFERENCES billing.plan_versions(id),
  duration_seconds bigint NOT NULL CHECK (duration_seconds > 0),
  reminder_offsets_seconds integer[] NOT NULL DEFAULT '{}',
  active boolean NOT NULL DEFAULT false, published_at timestamptz(3), retired_at timestamptz(3),
  UNIQUE (code, version), UNIQUE (id, plan_version_id),
  CHECK (0 < ALL(reminder_offsets_seconds)),
  CHECK (active = false OR published_at IS NOT NULL),
  CHECK (retired_at IS NULL OR published_at IS NULL OR retired_at >= published_at),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE UNIQUE INDEX uq_active_trial_policy ON billing.trial_policies(code) WHERE active AND deleted_at IS NULL;
CREATE TABLE billing.products (
  id uuid PRIMARY KEY DEFAULT uuidv7(), product_id varchar(255) NOT NULL,
  store billing.store NOT NULL, environment varchar(12) NOT NULL,
  app_namespace varchar(255) NOT NULL, plan_version_id uuid NOT NULL REFERENCES billing.plan_versions(id),
  base_plan_id varchar(255), period varchar(30) NOT NULL, active boolean NOT NULL DEFAULT true,
  UNIQUE NULLS NOT DISTINCT (store, environment, app_namespace, product_id, base_plan_id),
  UNIQUE (id, store, environment, app_namespace),
  CHECK (environment IN ('PRODUCTION','SANDBOX')),
  CHECK ((store='GOOGLE') = (base_plan_id IS NOT NULL)),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE billing.family_licenses (
  id uuid PRIMARY KEY DEFAULT uuidv7(), family_id uuid NOT NULL UNIQUE REFERENCES app.families(id),
  blocked_at timestamptz(3), block_reason_code varchar(80),
  UNIQUE (id, family_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE billing.purchase_intents (
  id uuid PRIMARY KEY DEFAULT uuidv7(), family_id uuid NOT NULL,
  license_id uuid NOT NULL, purchaser_user_id uuid REFERENCES app.users(id) ON DELETE SET NULL,
  product_id uuid NOT NULL, store billing.store NOT NULL,
  environment varchar(12) NOT NULL, app_namespace varchar(255) NOT NULL,
  app_account_token uuid NOT NULL DEFAULT uuidv7() UNIQUE,
  obfuscated_account_id varchar(128), client_idempotency_key uuid NOT NULL UNIQUE,
  status varchar(16) NOT NULL DEFAULT 'CREATED', expires_at timestamptz(3) NOT NULL,
  verified_at timestamptz(3), failure_code varchar(80),
  FOREIGN KEY (license_id, family_id) REFERENCES billing.family_licenses(id, family_id),
  FOREIGN KEY (product_id, store, environment, app_namespace) REFERENCES billing.products(id, store, environment, app_namespace),
  UNIQUE (id, family_id, license_id),
  CHECK (status IN ('CREATED','PENDING','VERIFIED','CANCELLED','EXPIRED','FAILED')),
  CHECK (expires_at > created_at),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE billing.subscriptions (
  id uuid PRIMARY KEY DEFAULT uuidv7(), family_id uuid NOT NULL,
  license_id uuid NOT NULL, purchase_intent_id uuid NOT NULL,
  purchaser_user_id uuid REFERENCES app.users(id) ON DELETE SET NULL,
  product_id uuid NOT NULL, store billing.store NOT NULL,
  environment varchar(12) NOT NULL, app_namespace varchar(255) NOT NULL,
  original_transaction_id varchar(255), purchase_token_enc bytea, purchase_token_hash bytea,
  -- Stable provider chain identity (HMAC/canonical verified identifier), never reused after soft delete.
  store_binding_key bytea NOT NULL,
  app_account_token uuid, status billing.sub_status NOT NULL,
  auto_renew boolean NOT NULL DEFAULT true, in_trial boolean NOT NULL DEFAULT false,
  current_period_start timestamptz(3), current_period_end timestamptz(3), grace_until timestamptz(3),
  last_verified_at timestamptz(3), superseded_by uuid REFERENCES billing.subscriptions(id),
  detached_purchaser_at timestamptz(3),
  FOREIGN KEY (license_id, family_id) REFERENCES billing.family_licenses(id, family_id),
  FOREIGN KEY (purchase_intent_id, family_id, license_id) REFERENCES billing.purchase_intents(id, family_id, license_id),
  FOREIGN KEY (product_id, store, environment, app_namespace) REFERENCES billing.products(id, store, environment, app_namespace),
  UNIQUE (id, family_id, license_id), UNIQUE (id, store, environment, app_namespace),
  UNIQUE (store, environment, app_namespace, store_binding_key),
  CHECK (octet_length(store_binding_key) = 32),
  CHECK (current_period_end IS NULL OR current_period_start IS NULL OR current_period_end >= current_period_start),
  CHECK ((store = 'APPLE' AND original_transaction_id IS NOT NULL) OR (store = 'GOOGLE' AND purchase_token_hash IS NOT NULL AND purchase_token_enc IS NOT NULL)),
  CHECK (purchase_token_hash IS NULL OR octet_length(purchase_token_hash) = 32),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE UNIQUE INDEX uq_subscription_apple_identity ON billing.subscriptions(store, environment, app_namespace, original_transaction_id) WHERE original_transaction_id IS NOT NULL;
CREATE UNIQUE INDEX uq_subscription_google_identity ON billing.subscriptions(store, environment, app_namespace, purchase_token_hash) WHERE purchase_token_hash IS NOT NULL;
CREATE INDEX ix_subscription_family ON billing.subscriptions(family_id, status, current_period_end) WHERE deleted_at IS NULL;
CREATE TABLE billing.subscription_transactions (
  id uuid PRIMARY KEY DEFAULT uuidv7(), subscription_id uuid NOT NULL,
  family_id uuid NOT NULL, license_id uuid NOT NULL,
  store billing.store NOT NULL, environment varchar(12) NOT NULL, app_namespace varchar(255) NOT NULL,
  provider_transaction_id varchar(255) NOT NULL, kind varchar(30) NOT NULL,
  product_id uuid NOT NULL REFERENCES billing.products(id),
  period_start timestamptz(3), period_end timestamptz(3), purchased_at timestamptz(3) NOT NULL,
  revoked_at timestamptz(3), verified_at timestamptz(3) NOT NULL,
  amount_minor bigint, currency char(3), payload_hash bytea NOT NULL,
  replaces_transaction_id uuid REFERENCES billing.subscription_transactions(id),
  FOREIGN KEY (subscription_id, family_id, license_id) REFERENCES billing.subscriptions(id, family_id, license_id),
  FOREIGN KEY (subscription_id, store, environment, app_namespace) REFERENCES billing.subscriptions(id, store, environment, app_namespace),
  UNIQUE (store, environment, app_namespace, provider_transaction_id),
  UNIQUE (id, family_id, license_id),
  CHECK (period_end IS NULL OR period_start IS NULL OR period_end >= period_start),
  CHECK (amount_minor IS NULL OR amount_minor >= 0), CHECK (octet_length(payload_hash) = 32),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE billing.license_grants (
  id uuid PRIMARY KEY DEFAULT uuidv7(), family_id uuid NOT NULL, license_id uuid NOT NULL,
  plan_version_id uuid NOT NULL REFERENCES billing.plan_versions(id), source billing.grant_source NOT NULL,
  trial_policy_id uuid,
  subscription_id uuid, transaction_id uuid, provenance_key varchar(255) NOT NULL UNIQUE,
  valid_from timestamptz(3) NOT NULL, valid_until timestamptz(3) NOT NULL,
  revoked_at timestamptz(3), revoke_reason_code varchar(80),
  granted_by_admin_id uuid, justification varchar(500),
  FOREIGN KEY (license_id, family_id) REFERENCES billing.family_licenses(id, family_id),
  FOREIGN KEY (subscription_id, family_id, license_id) REFERENCES billing.subscriptions(id, family_id, license_id),
  FOREIGN KEY (transaction_id, family_id, license_id) REFERENCES billing.subscription_transactions(id, family_id, license_id),
  UNIQUE (id, family_id), CHECK (valid_until > valid_from),
  CHECK (source <> 'STORE' OR (subscription_id IS NOT NULL AND transaction_id IS NOT NULL)),
  CHECK ((source = 'TRIAL') = (trial_policy_id IS NOT NULL)),
  FOREIGN KEY (trial_policy_id, plan_version_id) REFERENCES billing.trial_policies(id, plan_version_id),
  CHECK (source <> 'MANUAL' OR (granted_by_admin_id IS NOT NULL AND justification IS NOT NULL)),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE INDEX ix_license_grants_validity ON billing.license_grants(family_id, valid_from, valid_until) WHERE revoked_at IS NULL AND deleted_at IS NULL;
CREATE TABLE billing.store_notifications (
  id uuid PRIMARY KEY DEFAULT uuidv7(), store billing.store NOT NULL,
  environment varchar(12) NOT NULL, app_namespace varchar(255) NOT NULL,
  notification_id varchar(255) NOT NULL, type varchar(100), subtype varchar(100),
  payload_hash bytea NOT NULL, payload_enc bytea, subscription_id uuid REFERENCES billing.subscriptions(id),
  received_at timestamptz(3) NOT NULL DEFAULT now(), processed_at timestamptz(3),
  status varchar(16) NOT NULL DEFAULT 'PENDING', attempts integer NOT NULL DEFAULT 0,
  next_attempt_at timestamptz(3), last_error_code varchar(80),
  UNIQUE (store, environment, app_namespace, notification_id),
  CHECK (environment IN ('PRODUCTION','SANDBOX')),
  CHECK (status IN ('PENDING','PROCESSING','PROCESSED','RETRY_WAIT','QUARANTINED','FAILED')),
  CHECK (attempts >= 0 AND octet_length(payload_hash) = 32),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
-- Recomputable projection: family lifecycle is app.families.status; paid plan is separate.
CREATE TABLE billing.family_entitlements (
  family_id uuid PRIMARY KEY REFERENCES app.families(id), license_id uuid NOT NULL UNIQUE,
  access_phase billing.access_phase NOT NULL DEFAULT 'INCOMPLETE',
  effective_plan_version_id uuid REFERENCES billing.plan_versions(id), source_grant_id uuid,
  trial_started_at timestamptz(3), trial_ends_at timestamptz(3), valid_until timestamptz(3),
  in_grace boolean NOT NULL DEFAULT false, computed_at timestamptz(3) NOT NULL DEFAULT now(),
  version bigint NOT NULL DEFAULT 1 CHECK (version > 0),
  FOREIGN KEY (license_id, family_id) REFERENCES billing.family_licenses(id, family_id),
  FOREIGN KEY (source_grant_id, family_id) REFERENCES billing.license_grants(id, family_id),
  CHECK (trial_ends_at IS NULL OR trial_started_at IS NULL OR trial_ends_at > trial_started_at),
  CHECK (access_phase NOT IN ('TRIAL','PAID') OR effective_plan_version_id IS NOT NULL),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE billing.trial_consumptions (
  trial_policy_id uuid NOT NULL REFERENCES billing.trial_policies(id),
  id uuid PRIMARY KEY DEFAULT uuidv7(), user_id uuid REFERENCES app.users(id) ON DELETE SET NULL,
  identity_hash bytea NOT NULL UNIQUE, family_id uuid NOT NULL REFERENCES app.families(id),
  grant_id uuid, started_at timestamptz(3) NOT NULL DEFAULT now(),
  FOREIGN KEY (grant_id, family_id) REFERENCES billing.license_grants(id, family_id),
  CHECK (octet_length(identity_hash) = 32),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE billing.family_usage (
  family_id uuid PRIMARY KEY REFERENCES app.families(id),
  storage_bytes bigint NOT NULL DEFAULT 0, reserved_storage_bytes bigint NOT NULL DEFAULT 0,
  memory_count integer NOT NULL DEFAULT 0, album_count integer NOT NULL DEFAULT 0,
  active_series integer NOT NULL DEFAULT 0, letter_count integer NOT NULL DEFAULT 0,
  version bigint NOT NULL DEFAULT 1,
  CHECK (storage_bytes >= 0 AND reserved_storage_bytes >= 0 AND memory_count >= 0 AND album_count >= 0 AND active_series >= 0 AND letter_count >= 0),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
-- No paid license is attached to users; no ownership CASCADE follows purchaser removal.
-- Immutable catalog/identity/grant guards and all audit triggers are declared last.


-- Missing relations/operational persistence from screen/flow audit.
CREATE TABLE app.birth_conversion_children (
  pregnancy_id uuid NOT NULL, child_id uuid NOT NULL, family_id uuid NOT NULL,
  PRIMARY KEY (pregnancy_id, child_id),
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.birth_conversions(pregnancy_id, family_id),
  FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE app.asset_variants (
  id uuid PRIMARY KEY DEFAULT uuidv7(), family_id uuid NOT NULL, asset_id uuid NOT NULL,
  variant_code varchar(30) NOT NULL, storage_bucket varchar(80) NOT NULL, storage_key text NOT NULL,
  mime varchar(80) NOT NULL, size_bytes bigint NOT NULL CHECK (size_bytes >= 0),
  width integer, height integer, duration_ms integer, checksum_sha256 bytea,
  UNIQUE (asset_id, variant_code), UNIQUE (storage_bucket, storage_key),
  FOREIGN KEY (asset_id, family_id) REFERENCES app.assets(id, family_id),
  CHECK ((width IS NULL OR width > 0) AND (height IS NULL OR height > 0) AND (duration_ms IS NULL OR duration_ms >= 0)),
  CHECK (checksum_sha256 IS NULL OR octet_length(checksum_sha256) = 32),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
-- Reserve declared size under a row lock on billing.family_usage before presigning;
-- confirm exactly once, expire unconfirmed, release consumed bytes ONLY after physical purge.
CREATE TABLE app.storage_reservations (
  id uuid PRIMARY KEY DEFAULT uuidv7(), family_id uuid NOT NULL REFERENCES app.families(id),
  asset_id uuid NOT NULL UNIQUE, requester_user_id uuid REFERENCES app.users(id),
  idempotency_key uuid NOT NULL UNIQUE, reserved_bytes bigint NOT NULL CHECK (reserved_bytes >= 0),
  consumed_bytes bigint CHECK (consumed_bytes >= 0), status varchar(16) NOT NULL DEFAULT 'RESERVED',
  expires_at timestamptz(3) NOT NULL, confirmed_at timestamptz(3), released_at timestamptz(3),
  FOREIGN KEY (asset_id, family_id) REFERENCES app.assets(id, family_id),
  CHECK (status IN ('RESERVED','CONFIRMED','EXPIRED','RELEASED')),
  CHECK (status <> 'CONFIRMED' OR (confirmed_at IS NOT NULL AND consumed_bytes IS NOT NULL)),
  CHECK (expires_at > created_at),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE INDEX ix_storage_reservation_expire ON app.storage_reservations(expires_at) WHERE status = 'RESERVED' AND deleted_at IS NULL;
CREATE TABLE app.memory_letters (
  memory_id uuid PRIMARY KEY, family_id uuid NOT NULL, child_id uuid,
  release_rule varchar(20) NOT NULL, birthday_number smallint,
  release_visibility app.visibility NOT NULL DEFAULT 'PARENTS',
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id),
  FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id),
  CHECK (release_rule IN ('DATE','CHILD_BIRTHDAY')),
  CHECK (release_rule <> 'CHILD_BIRTHDAY' OR (child_id IS NOT NULL AND birthday_number IS NOT NULL AND birthday_number > 0)),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE app.event_participants (
  event_id uuid NOT NULL, family_id uuid NOT NULL, user_id uuid NOT NULL REFERENCES app.users(id),
  response varchar(12) NOT NULL DEFAULT 'INVITED', responded_at timestamptz(3),
  PRIMARY KEY (event_id, user_id),
  FOREIGN KEY (event_id, family_id) REFERENCES app.events(id, family_id),
  CHECK (response IN ('INVITED','ACCEPTED','DECLINED')),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE app.event_reminders (
  id uuid PRIMARY KEY DEFAULT uuidv7(), event_id uuid NOT NULL, family_id uuid NOT NULL,
  recipient_user_id uuid NOT NULL REFERENCES app.users(id), offset_minutes integer NOT NULL CHECK (offset_minutes >= 0),
  occurrence_at timestamptz(3) NOT NULL, due_at timestamptz(3) NOT NULL,
  sent_at timestamptz(3), cancelled_at timestamptz(3),
  UNIQUE (event_id, recipient_user_id, occurrence_at, offset_minutes),
  FOREIGN KEY (event_id, family_id) REFERENCES app.events(id, family_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE app.mission_series_children (
  series_id uuid NOT NULL, child_id uuid NOT NULL, family_id uuid NOT NULL,
  PRIMARY KEY (series_id, child_id),
  FOREIGN KEY (series_id, family_id) REFERENCES app.mission_series(id, family_id),
  FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE us.journal_assets (
  entry_id uuid NOT NULL, asset_id uuid NOT NULL, family_id uuid NOT NULL,
  owner_user_id uuid NOT NULL REFERENCES app.users(id), sort_order smallint NOT NULL DEFAULT 0,
  PRIMARY KEY (entry_id, asset_id),
  FOREIGN KEY (entry_id, family_id, owner_user_id) REFERENCES us.journal_entries(id, family_id, user_id),
  FOREIGN KEY (asset_id, family_id, owner_user_id) REFERENCES app.assets(id, family_id, uploader_user_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE us.journal_shares (
  id uuid PRIMARY KEY DEFAULT uuidv7(), entry_id uuid NOT NULL, family_id uuid NOT NULL,
  couple_space_id uuid NOT NULL, owner_user_id uuid NOT NULL REFERENCES app.users(id),
  recipient_user_id uuid NOT NULL REFERENCES app.users(id), snippet_enc bytea NOT NULL,
  explicitly_shared_at timestamptz(3) NOT NULL DEFAULT now(), revoked_at timestamptz(3),
  FOREIGN KEY (entry_id, family_id, owner_user_id) REFERENCES us.journal_entries(id, family_id, user_id),
  FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id),
  CHECK (owner_user_id <> recipient_user_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE us.conflict_confirmations (
  session_id uuid NOT NULL, family_id uuid NOT NULL, couple_space_id uuid NOT NULL,
  user_id uuid NOT NULL REFERENCES app.users(id), step_version integer NOT NULL CHECK (step_version > 0),
  confirmed_at timestamptz(3) NOT NULL DEFAULT now(),
  PRIMARY KEY (session_id, user_id, step_version),
  FOREIGN KEY (session_id, family_id, couple_space_id) REFERENCES us.conflict_sessions(id, family_id, couple_space_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
-- Deliberately NO table/event/session for opening the Safety screen (US-13).
CREATE TABLE app.family_deletion_requests (
  id uuid PRIMARY KEY DEFAULT uuidv7(), family_id uuid NOT NULL REFERENCES app.families(id),
  requested_by uuid NOT NULL REFERENCES app.users(id), status varchar(24) NOT NULL DEFAULT 'PENDING_APPROVAL',
  request_version integer NOT NULL DEFAULT 1 CHECK (request_version > 0),
  execute_after timestamptz(3), cancelled_at timestamptz(3), completed_at timestamptz(3),
  steps jsonb NOT NULL DEFAULT '{}', reason_code varchar(80),
  UNIQUE (id, family_id),
  CHECK (status IN ('PENDING_APPROVAL','SCHEDULED','RUNNING','CANCELLED','COMPLETED','FAILED')),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE UNIQUE INDEX uq_family_deletion_active ON app.family_deletion_requests(family_id) WHERE status IN ('PENDING_APPROVAL','SCHEDULED','RUNNING') AND deleted_at IS NULL;
CREATE TABLE app.family_deletion_approvals (
  request_id uuid NOT NULL, family_id uuid NOT NULL, user_id uuid NOT NULL REFERENCES app.users(id),
  request_version integer NOT NULL, decision varchar(10) NOT NULL,
  decided_at timestamptz(3) NOT NULL DEFAULT now(),
  PRIMARY KEY (request_id, user_id, request_version),
  FOREIGN KEY (request_id, family_id) REFERENCES app.family_deletion_requests(id, family_id),
  CHECK (decision IN ('APPROVED','DECLINED')),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE ops.moderation_case_reports (
  case_id uuid NOT NULL REFERENCES ops.moderation_cases(id), report_id uuid NOT NULL REFERENCES app.reports(id),
  PRIMARY KEY (case_id, report_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE ops.admin_sessions (
  id uuid PRIMARY KEY DEFAULT uuidv7(), admin_id uuid NOT NULL REFERENCES ops.admin_users(id),
  refresh_token_hash bytea NOT NULL UNIQUE, mfa_verified_at timestamptz(3) NOT NULL,
  expires_at timestamptz(3) NOT NULL, revoked_at timestamptz(3),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE ops.admin_audit_events (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY, admin_id uuid REFERENCES ops.admin_users(id),
  action varchar(80) NOT NULL, entity_type varchar(80) NOT NULL, entity_id varchar(255),
  trace_id varchar(100), reason_code varchar(80), redacted_changes jsonb NOT NULL DEFAULT '{}',
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
-- Durable scheduling metadata; definitions may be code-owned, optional rows enable dynamic scheduling.
CREATE TABLE ops.job_schedules (
  id uuid PRIMARY KEY DEFAULT uuidv7(), job_name varchar(100) NOT NULL, scope_key varchar(255) NOT NULL DEFAULT 'GLOBAL',
  family_id uuid REFERENCES app.families(id), cron_expression varchar(100) NOT NULL,
  timezone varchar(64) NOT NULL DEFAULT 'UTC', misfire_policy varchar(12) NOT NULL,
  enabled boolean NOT NULL DEFAULT true, next_run_at timestamptz(3), last_materialized_at timestamptz(3),
  definition_version integer NOT NULL DEFAULT 1,
  UNIQUE (job_name, scope_key), CHECK (misfire_policy IN ('CATCH_UP','COALESCE','SKIP')),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE ops.job_runs (
  id uuid PRIMARY KEY DEFAULT uuidv7(), schedule_id uuid REFERENCES ops.job_schedules(id),
  job_name varchar(100) NOT NULL, scope_key varchar(255) NOT NULL,
  family_id uuid REFERENCES app.families(id), scheduled_for timestamptz(3) NOT NULL,
  idempotency_key varchar(255) NOT NULL UNIQUE,
  status varchar(16) NOT NULL DEFAULT 'PENDING', max_attempts integer NOT NULL DEFAULT 3,
  attempts integer NOT NULL DEFAULT 0, next_attempt_at timestamptz(3),
  started_at timestamptz(3), finished_at timestamptz(3),
  lease_owner varchar(100), lease_expires_at timestamptz(3), heartbeat_at timestamptz(3),
  fencing_token bigint NOT NULL DEFAULT 0, last_error_code varchar(80), last_error_summary varchar(500),
  checkpoint jsonb NOT NULL DEFAULT '{}', input_reference jsonb NOT NULL DEFAULT '{}',
  UNIQUE (job_name, scope_key, scheduled_for),
  CHECK (status IN ('PENDING','RUNNING','RETRY_WAIT','SUCCEEDED','FAILED','SKIPPED')),
  CHECK (max_attempts > 0 AND attempts >= 0 AND fencing_token >= 0),
  CHECK (status <> 'RUNNING' OR (lease_owner IS NOT NULL AND lease_expires_at IS NOT NULL)),
  CHECK (status NOT IN ('SUCCEEDED','FAILED','SKIPPED') OR finished_at IS NOT NULL),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE INDEX ix_job_runs_claim ON ops.job_runs(next_attempt_at, scheduled_for) WHERE status IN ('PENDING','RETRY_WAIT') AND deleted_at IS NULL;
CREATE INDEX ix_job_runs_stale ON ops.job_runs(lease_expires_at) WHERE status = 'RUNNING' AND deleted_at IS NULL;
CREATE TABLE ops.job_attempts (
  id uuid PRIMARY KEY DEFAULT uuidv7(), run_id uuid NOT NULL REFERENCES ops.job_runs(id),
  attempt_number integer NOT NULL CHECK (attempt_number > 0), worker_id varchar(100) NOT NULL,
  fencing_token bigint NOT NULL CHECK (fencing_token > 0), status varchar(12) NOT NULL DEFAULT 'RUNNING',
  started_at timestamptz(3) NOT NULL DEFAULT now(), finished_at timestamptz(3),
  error_code varchar(80), error_summary varchar(500), retry_requested_by_admin_id uuid REFERENCES ops.admin_users(id),
  UNIQUE (run_id, attempt_number), UNIQUE (run_id, fencing_token),
  CHECK (status IN ('RUNNING','SUCCEEDED','FAILED','TIMED_OUT')),
  CHECK ((status = 'RUNNING') = (finished_at IS NULL)),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE ops.idempotency_records (
  id uuid PRIMARY KEY DEFAULT uuidv7(), actor_user_id uuid REFERENCES app.users(id),
  family_id uuid REFERENCES app.families(id), operation varchar(100) NOT NULL,
  scope_key varchar(255) NOT NULL, idempotency_key uuid NOT NULL, request_hash bytea NOT NULL,
  status varchar(12) NOT NULL DEFAULT 'PENDING', result_entity_type varchar(80), result_entity_id uuid,
  response_code integer, response_reference jsonb, expires_at timestamptz(3),
  UNIQUE (scope_key, operation, idempotency_key),
  CHECK (status IN ('PENDING','SUCCEEDED','FAILED')), CHECK (octet_length(request_hash) = 32),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
-- PostgreSQL is the durable inbox/delivery source. MongoDB may project inbox/TTL telemetry later.
CREATE TABLE app.notifications (
  id uuid PRIMARY KEY DEFAULT uuidv7(), family_id uuid REFERENCES app.families(id),
  recipient_user_id uuid NOT NULL REFERENCES app.users(id), event_id uuid NOT NULL,
  template_code varchar(40) NOT NULL, category varchar(30) NOT NULL, priority varchar(10) NOT NULL DEFAULT 'NORMAL',
  locale varchar(10) NOT NULL DEFAULT 'vi', subject_type varchar(80), subject_id uuid,
  payload_reference jsonb NOT NULL DEFAULT '{}', sensitive boolean NOT NULL DEFAULT false,
  read_at timestamptz(3), dismissed_at timestamptz(3), expires_at timestamptz(3),
  UNIQUE (event_id, recipient_user_id, template_code),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE INDEX ix_notification_inbox ON app.notifications(recipient_user_id, created_at DESC, id DESC) WHERE deleted_at IS NULL;
CREATE TABLE app.notification_deliveries (
  id uuid PRIMARY KEY DEFAULT uuidv7(), notification_id uuid NOT NULL REFERENCES app.notifications(id),
  channel varchar(10) NOT NULL, device_id uuid REFERENCES app.user_devices(id),
  target_key varchar(255) NOT NULL, status varchar(16) NOT NULL DEFAULT 'PENDING',
  attempts integer NOT NULL DEFAULT 0 CHECK (attempts >= 0), next_attempt_at timestamptz(3),
  sent_at timestamptz(3), provider_message_id varchar(255), last_error_code varchar(80),
  UNIQUE (notification_id, channel, target_key),
  CHECK (channel IN ('INBOX','PUSH','EMAIL','SMS')),
  CHECK (status IN ('PENDING','SENT','RETRY_WAIT','FAILED','CANCELLED')),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE app.notification_delivery_attempts (
  id uuid PRIMARY KEY DEFAULT uuidv7(), delivery_id uuid NOT NULL REFERENCES app.notification_deliveries(id),
  attempt_number integer NOT NULL CHECK (attempt_number > 0),
  started_at timestamptz(3) NOT NULL DEFAULT now(), finished_at timestamptz(3),
  outcome varchar(20), provider_status_code varchar(40), error_code varchar(80),
  UNIQUE (delivery_id, attempt_number),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE ops.ai_invocations (
  id uuid PRIMARY KEY DEFAULT uuidv7(), family_id uuid NOT NULL REFERENCES app.families(id),
  requester_user_id uuid REFERENCES app.users(id), feature_code varchar(60) NOT NULL,
  prompt_version varchar(40) NOT NULL, model_id varchar(100) NOT NULL,
  status varchar(16) NOT NULL, input_tokens integer, output_tokens integer,
  duration_ms integer, error_code varchar(80), consent_id uuid REFERENCES app.user_consents(id),
  -- Metadata only: never persist prompts, journal text, private output or Safety-screen visits here.
  CHECK (status IN ('PENDING','SUCCEEDED','FAILED','REFUSED')),
  CHECK ((input_tokens IS NULL OR input_tokens >= 0) AND (output_tokens IS NULL OR output_tokens >= 0) AND (duration_ms IS NULL OR duration_ms >= 0)),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE app.event_reminder_rules (
  id uuid PRIMARY KEY DEFAULT uuidv7(), event_id uuid NOT NULL, family_id uuid NOT NULL,
  recipient_user_id uuid NOT NULL REFERENCES app.users(id), offset_minutes integer NOT NULL CHECK (offset_minutes >= 0),
  enabled boolean NOT NULL DEFAULT true,
  UNIQUE (event_id, recipient_user_id, offset_minutes),
  FOREIGN KEY (event_id, family_id) REFERENCES app.events(id, family_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE app.support_tickets (
  id uuid PRIMARY KEY DEFAULT uuidv7(), requester_user_id uuid REFERENCES app.users(id),
  family_id uuid REFERENCES app.families(id), category varchar(40) NOT NULL,
  status varchar(20) NOT NULL DEFAULT 'OPEN', message_enc bytea NOT NULL,
  assigned_admin_id uuid REFERENCES ops.admin_users(id), closed_at timestamptz(3),
  CHECK (status IN ('OPEN','IN_PROGRESS','WAITING_USER','RESOLVED','CLOSED')),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE app.support_ticket_messages (
  id uuid PRIMARY KEY DEFAULT uuidv7(), ticket_id uuid NOT NULL REFERENCES app.support_tickets(id),
  sender_user_id uuid REFERENCES app.users(id), sender_admin_id uuid REFERENCES ops.admin_users(id),
  body_enc bytea NOT NULL, CHECK (num_nonnulls(sender_user_id,sender_admin_id)=1),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
ALTER TABLE app.support_tickets ADD UNIQUE (id, requester_user_id);
CREATE TABLE app.support_ticket_attachments (
  id uuid PRIMARY KEY DEFAULT uuidv7(), ticket_id uuid NOT NULL,
  owner_user_id uuid NOT NULL REFERENCES app.users(id), asset_id uuid NOT NULL,
  FOREIGN KEY (ticket_id, owner_user_id) REFERENCES app.support_tickets(id, requester_user_id),
  FOREIGN KEY (asset_id, owner_user_id) REFERENCES app.user_assets(id, owner_user_id),
  UNIQUE (ticket_id, asset_id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);
CREATE TABLE ops.ai_usage_reservations (
  id uuid PRIMARY KEY DEFAULT uuidv7(), family_id uuid NOT NULL REFERENCES app.families(id),
  invocation_id uuid NOT NULL UNIQUE REFERENCES ops.ai_invocations(id),
  idempotency_key uuid NOT NULL UNIQUE, usage_month date NOT NULL,
  status varchar(12) NOT NULL DEFAULT 'RESERVED', expires_at timestamptz(3) NOT NULL,
  consumed_at timestamptz(3), released_at timestamptz(3),
  CHECK (status IN ('RESERVED','CONSUMED','RELEASED','EXPIRED')),
  CHECK (extract(day FROM usage_month)=1),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3) DEFAULT NULL
);


-- Deferred cyclic references and omitted FK targets from the original specification.
ALTER TABLE app.user_devices ADD UNIQUE (id, user_id);
ALTER TABLE app.user_sessions ADD UNIQUE (id, user_id),
  ADD FOREIGN KEY (device_id, user_id) REFERENCES app.user_devices(id, user_id),
  ADD FOREIGN KEY (replaced_by, user_id) REFERENCES app.user_sessions(id, user_id);
ALTER TABLE app.assets ADD UNIQUE (id, uploader_user_id);
ALTER TABLE app.users ADD FOREIGN KEY (avatar_asset_id, id) REFERENCES app.user_assets(id, owner_user_id);
ALTER TABLE app.families ADD FOREIGN KEY (cover_asset_id, id) REFERENCES app.assets(id, family_id);
ALTER TABLE app.pregnancies ADD FOREIGN KEY (cover_asset_id, family_id) REFERENCES app.assets(id, family_id);
ALTER TABLE app.children ADD FOREIGN KEY (avatar_asset_id, family_id) REFERENCES app.assets(id, family_id),
  ADD FOREIGN KEY (cover_asset_id, family_id) REFERENCES app.assets(id, family_id),
  ADD UNIQUE (id, family_id, pregnancy_id);
ALTER TABLE app.birth_conversion_children ADD FOREIGN KEY (child_id, family_id, pregnancy_id) REFERENCES app.children(id, family_id, pregnancy_id);
ALTER TABLE app.albums ADD FOREIGN KEY (cover_memory_id, family_id) REFERENCES app.memories(id, family_id);
ALTER TABLE app.memory_children ADD FOREIGN KEY (added_by) REFERENCES app.users(id);
ALTER TABLE app.album_memories ADD FOREIGN KEY (added_by) REFERENCES app.users(id);
ALTER TABLE app.milestones ADD FOREIGN KEY (from_milestone_id, family_id) REFERENCES app.milestones(id, family_id);
ALTER TABLE app.prep_items ADD FOREIGN KEY (mission_id, family_id) REFERENCES app.missions(id, family_id);
ALTER TABLE us.mood_responses ADD FOREIGN KEY (request_id, family_id, couple_space_id) REFERENCES us.requests(id, family_id, couple_space_id);
ALTER TABLE us.data_keys ADD UNIQUE (id, couple_space_id);
ALTER TABLE app.couple_spaces ADD FOREIGN KEY (key_id, id) REFERENCES us.data_keys(id, couple_space_id) DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ops.moderation_cases ADD FOREIGN KEY (assignee_admin_id) REFERENCES ops.admin_users(id);
ALTER TABLE ops.moderation_actions ADD FOREIGN KEY (admin_id) REFERENCES ops.admin_users(id);
ALTER TABLE ops.app_config ADD FOREIGN KEY (updated_by) REFERENCES ops.admin_users(id);
ALTER TABLE billing.license_grants ADD FOREIGN KEY (granted_by_admin_id) REFERENCES ops.admin_users(id);
-- Couple versions identify the actual historical pair, even when a new partner joins later.
ALTER TABLE app.couple_spaces
  ADD parent_a_membership_id uuid NOT NULL,
  ADD parent_b_membership_id uuid NOT NULL,
  ADD FOREIGN KEY (parent_a_membership_id, family_id, parent_a_user_id) REFERENCES app.family_parents(id, family_id, user_id),
  ADD FOREIGN KEY (parent_b_membership_id, family_id, parent_b_user_id) REFERENCES app.family_parents(id, family_id, user_id),
  ADD CHECK (parent_a_membership_id <> parent_b_membership_id);

-- Restore/relink natural-key join rows by updating deleted_at back to NULL;
-- history of relation changes belongs in event/audit rows, not duplicate join PKs.
CREATE UNIQUE INDEX uq_memory_cover ON app.memory_assets(memory_id) WHERE is_cover AND deleted_at IS NULL;
CREATE INDEX ix_event_family_start ON app.events(family_id, start_at, id) WHERE deleted_at IS NULL;
CREATE INDEX ix_event_reminder_due ON app.event_reminders(due_at) WHERE sent_at IS NULL AND cancelled_at IS NULL AND deleted_at IS NULL;
CREATE INDEX ix_children_family_active ON app.children(family_id, sort_order, id) WHERE deleted_at IS NULL;
CREATE INDEX ix_asset_purge ON app.assets(purge_after) WHERE purge_after IS NOT NULL;
CREATE INDEX ix_memory_children_active ON app.memory_children(child_id, age_month, memory_id) WHERE deleted_at IS NULL;
CREATE INDEX ix_notification_delivery_pending ON app.notification_deliveries(next_attempt_at, id) WHERE status IN ('PENDING','RETRY_WAIT') AND deleted_at IS NULL;
CREATE INDEX ix_store_notification_pending ON billing.store_notifications(next_attempt_at, received_at) WHERE status IN ('PENDING','RETRY_WAIT') AND deleted_at IS NULL;
CREATE INDEX ix_private_journal_owner ON us.journal_entries(user_id, created_at DESC, id DESC) WHERE deleted_at IS NULL;
CREATE INDEX ix_family_parent_history ON app.family_parents(family_id, user_id, joined_at DESC);
CREATE INDEX ix_circle_grant_pregnancy ON app.circle_grants(family_id, pregnancy_id) WHERE status = 'ACTIVE' AND deleted_at IS NULL;
CREATE INDEX ix_outbox_available ON ops.outbox_events(available_at, id) WHERE published_at IS NULL AND deleted_at IS NULL;

-- Every writer gets server-maintained updated_at; millisecond precision is not a unique version.
CREATE FUNCTION ops.touch_audit_columns() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.created_at := OLD.created_at;
  NEW.updated_at := statement_timestamp();
  RETURN NEW;
END $$;
DO $$
DECLARE t record;
BEGIN
  FOR t IN SELECT schemaname, tablename FROM pg_tables WHERE schemaname IN ('app','us','billing','ops') LOOP
    EXECUTE format('CREATE TRIGGER trg_audit_update BEFORE UPDATE ON %I.%I FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()', t.schemaname,t.tablename);
  END LOOP;
END $$;

-- Immutable structural identifiers avoid silently moving existing rows to a new tenant/pair.
CREATE FUNCTION ops.reject_changed_columns() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE column_name text;
BEGIN
  FOREACH column_name IN ARRAY TG_ARGV LOOP
    IF to_jsonb(NEW)->column_name IS DISTINCT FROM to_jsonb(OLD)->column_name THEN
      RAISE EXCEPTION 'IMMUTABLE_COLUMN %.%: %', TG_TABLE_SCHEMA,TG_TABLE_NAME,column_name USING ERRCODE='23514';
    END IF;
  END LOOP;
  RETURN NEW;
END $$;
DO $$
DECLARE t record;
BEGIN
  FOR t IN SELECT table_schema,table_name FROM information_schema.columns JOIN information_schema.tables USING (table_schema,table_name) WHERE table_schema IN ('app','us','billing','ops') AND table_type='BASE TABLE' AND column_name='family_id' LOOP
    EXECUTE format('CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON %I.%I FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns(''family_id'')',t.table_schema,t.table_name);
  END LOOP;
END $$;
CREATE TRIGGER trg_immutable_pair BEFORE UPDATE ON app.couple_spaces FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('parent_a_user_id','parent_b_user_id','parent_a_membership_id','parent_b_membership_id','pair_version');
CREATE TRIGGER trg_immutable_asset_owner BEFORE UPDATE ON app.assets FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('uploader_user_id','private_owner_user_id','purpose','storage_bucket','storage_key');
CREATE TRIGGER trg_immutable_user_asset_owner BEFORE UPDATE ON app.user_assets FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('owner_user_id','purpose','storage_bucket','storage_key');
CREATE FUNCTION app.check_user_asset_purpose() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE asset_uuid uuid; owner_uuid uuid; expected_purpose text;
BEGIN
  IF TG_TABLE_NAME='users' THEN
    asset_uuid:=NEW.avatar_asset_id; owner_uuid:=NEW.id; expected_purpose:='AVATAR';
  ELSE
    asset_uuid:=NEW.asset_id; owner_uuid:=NEW.owner_user_id; expected_purpose:='SUPPORT';
  END IF;
  IF asset_uuid IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM app.user_assets WHERE id=asset_uuid AND owner_user_id=owner_uuid
      AND purpose=expected_purpose AND deleted_at IS NULL
  ) THEN RAISE EXCEPTION 'USER_ASSET_PURPOSE_OR_OWNER_MISMATCH' USING ERRCODE='23514'; END IF;
  RETURN NEW;
END $$;
CREATE TRIGGER trg_avatar_purpose BEFORE INSERT OR UPDATE OF avatar_asset_id ON app.users FOR EACH ROW EXECUTE FUNCTION app.check_user_asset_purpose();
CREATE TRIGGER trg_support_attachment_purpose BEFORE INSERT OR UPDATE ON app.support_ticket_attachments FOR EACH ROW EXECUTE FUNCTION app.check_user_asset_purpose();
CREATE TRIGGER trg_immutable_plan_code BEFORE UPDATE ON billing.plans FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('code');
CREATE TRIGGER trg_immutable_plan_version BEFORE UPDATE ON billing.plan_versions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('plan_id','version','quotas','features','entitlement_rank');
CREATE TRIGGER trg_immutable_trial_policy BEFORE UPDATE ON billing.trial_policies FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('code','version','plan_version_id','duration_seconds','reminder_offsets_seconds');
CREATE TRIGGER trg_immutable_purchase_intent BEFORE UPDATE ON billing.purchase_intents FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('license_id','product_id','store','environment','app_namespace','app_account_token','client_idempotency_key');
CREATE TRIGGER trg_immutable_subscription_binding BEFORE UPDATE ON billing.subscriptions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('license_id','purchase_intent_id','store','environment','app_namespace','store_binding_key','original_transaction_id');
CREATE TRIGGER trg_immutable_transaction BEFORE UPDATE ON billing.subscription_transactions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('subscription_id','license_id','store','environment','app_namespace','provider_transaction_id','product_id','purchased_at','period_start','period_end');
CREATE TRIGGER trg_immutable_grant BEFORE UPDATE ON billing.license_grants FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('license_id','plan_version_id','trial_policy_id','source','subscription_id','transaction_id','provenance_key','valid_from','valid_until');
CREATE FUNCTION billing.check_trial_duration() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE policy billing.trial_policies%ROWTYPE;
BEGIN
  IF NEW.source='TRIAL' THEN
    SELECT * INTO policy FROM billing.trial_policies WHERE id=NEW.trial_policy_id;
    IF NOT FOUND THEN RAISE EXCEPTION 'TRIAL_POLICY_NOT_FOUND' USING ERRCODE='23503'; END IF;
    IF NEW.valid_until IS DISTINCT FROM NEW.valid_from + policy.duration_seconds * interval '1 second' THEN
      RAISE EXCEPTION 'TRIAL_VALIDITY_MUST_MATCH_POLICY_VERSION' USING ERRCODE='23514';
    END IF;
  END IF;
  RETURN NEW;
END $$;
CREATE TRIGGER trg_trial_duration BEFORE INSERT ON billing.license_grants FOR EACH ROW EXECUTE FUNCTION billing.check_trial_duration();
CREATE TRIGGER trg_immutable_job_key BEFORE UPDATE ON ops.job_runs FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('job_name','scope_key','scheduled_for','idempotency_key');
CREATE FUNCTION ops.deny_physical_delete() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'EXPLICIT_RETENTION_REQUIRED %.%',TG_TABLE_SCHEMA,TG_TABLE_NAME USING ERRCODE='23514';
END $$;
-- Retain purchase/grant dedup identities and financial history. A future legal purge
-- needs a separately reviewed privileged procedure preserving an anonymized dedup ledger.
DO $$
DECLARE n text;
BEGIN
  FOREACH n IN ARRAY ARRAY['family_licenses','purchase_intents','subscriptions','subscription_transactions','license_grants','store_notifications','trial_consumptions'] LOOP
    EXECUTE format('CREATE TRIGGER trg_no_delete BEFORE DELETE ON billing.%I FOR EACH ROW EXECUTE FUNCTION ops.deny_physical_delete()',n);
  END LOOP;
END $$;

-- Private rows can only name users from their immutable historical couple pair.
-- This does NOT grant read/decrypt access; current membership and share policy remain in services.
CREATE FUNCTION us.check_pair_participants() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE pair_row app.couple_spaces%ROWTYPE; field_name text; user_value uuid;
BEGIN
  SELECT * INTO pair_row FROM app.couple_spaces WHERE id=(to_jsonb(NEW)->>'couple_space_id')::uuid;
  IF NOT FOUND THEN RAISE EXCEPTION 'COUPLE_PAIR_NOT_FOUND' USING ERRCODE='23503'; END IF;
  FOREACH field_name IN ARRAY TG_ARGV LOOP
    user_value := (to_jsonb(NEW)->>field_name)::uuid;
    IF user_value IS NOT NULL AND user_value NOT IN (pair_row.parent_a_user_id,pair_row.parent_b_user_id) THEN
      RAISE EXCEPTION 'USER_OUTSIDE_COUPLE_PAIR: %',field_name USING ERRCODE='23514';
    END IF;
  END LOOP;
  RETURN NEW;
END $$;
CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.mood_checkins FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('user_id');
CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.mood_responses FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('user_id');
CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.requests FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('sender_user_id','receiver_user_id');
CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.pregnancy_name_candidates FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('added_by','chosen_by');
CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.pregnancy_name_votes FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('user_id');
CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.appreciations FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('from_user_id','to_user_id');
CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.conflict_sessions FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('opened_by');
CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.conflict_entries FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('user_id');
CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.connection_answers FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('user_id');
CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.conflict_confirmations FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('user_id');
CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.journal_shares FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('owner_user_id','recipient_user_id');
DO $$
DECLARE t record;
BEGIN
  FOR t IN SELECT table_name FROM information_schema.columns JOIN information_schema.tables USING (table_schema,table_name) WHERE table_schema='us' AND table_type='BASE TABLE' AND column_name='couple_space_id' LOOP
    EXECUTE format('CREATE TRIGGER trg_immutable_couple BEFORE UPDATE ON us.%I FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns(''couple_space_id'')',t.table_name);
  END LOOP;
END $$;
CREATE FUNCTION us.check_journal_asset_owner() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM app.assets WHERE id=NEW.asset_id AND family_id=NEW.family_id AND purpose='JOURNAL' AND private_owner_user_id=NEW.owner_user_id) THEN
    RAISE EXCEPTION 'JOURNAL_ASSET_OWNER_MISMATCH' USING ERRCODE='23514';
  END IF;
  RETURN NEW;
END $$;
CREATE TRIGGER trg_journal_asset_owner BEFORE INSERT OR UPDATE ON us.journal_assets FOR EACH ROW EXECUTE FUNCTION us.check_journal_asset_owner();

-- Serialize association edits on the mission row; validate final active-child count
-- after the transaction has inserted/soft-deleted/relinked its associations.
CREATE FUNCTION app.lock_mission_children() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE old_id uuid; new_id uuid;
BEGIN
  IF TG_OP <> 'INSERT' THEN old_id := OLD.mission_id; END IF;
  IF TG_OP <> 'DELETE' THEN new_id := NEW.mission_id; END IF;
  PERFORM id FROM app.missions WHERE id IN (old_id,new_id) ORDER BY id FOR UPDATE;
  IF TG_OP='DELETE' THEN RETURN OLD; END IF;
  RETURN NEW;
END $$;
CREATE TRIGGER trg_lock_mission_children BEFORE INSERT OR UPDATE OR DELETE ON app.mission_children FOR EACH ROW EXECUTE FUNCTION app.lock_mission_children();
CREATE FUNCTION app.check_mission_scope() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE ids uuid[]; v_id uuid; v_scope app.mission_scope; v_count integer; v_deleted timestamptz;
BEGIN
  IF TG_TABLE_NAME='missions' THEN
    ids := ARRAY[NEW.id];
  ELSIF TG_OP='INSERT' THEN ids:=ARRAY[NEW.mission_id];
  ELSIF TG_OP='DELETE' THEN ids:=ARRAY[OLD.mission_id];
  ELSE ids:=ARRAY[OLD.mission_id,NEW.mission_id]; END IF;
  FOREACH v_id IN ARRAY ids LOOP
    SELECT target_scope,deleted_at INTO v_scope,v_deleted FROM app.missions WHERE id=v_id;
    IF NOT FOUND OR v_deleted IS NOT NULL THEN CONTINUE; END IF;
    SELECT count(*) INTO v_count FROM app.mission_children WHERE mission_id=v_id AND deleted_at IS NULL;
    IF (v_scope='CHILD' AND v_count<>1) OR (v_scope='MULTI_CHILD' AND v_count<2) OR (v_scope IN ('FAMILY','COUPLE') AND v_count<>0) THEN
      RAISE EXCEPTION 'MISSION_SCOPE_MISMATCH scope=% children=%',v_scope,v_count USING ERRCODE='23514';
    END IF;
  END LOOP;
  RETURN NULL;
END $$;
CREATE CONSTRAINT TRIGGER trg_mission_scope_m AFTER INSERT OR UPDATE ON app.missions DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION app.check_mission_scope();
CREATE CONSTRAINT TRIGGER trg_mission_scope_c AFTER INSERT OR UPDATE OR DELETE ON app.mission_children DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION app.check_mission_scope();

CREATE FUNCTION app.check_heart_reversal() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE original app.heart_ledger%ROWTYPE;
BEGIN
  IF NEW.reversal_of IS NOT NULL THEN
    SELECT * INTO original FROM app.heart_ledger WHERE id=NEW.reversal_of FOR KEY SHARE;
    IF NOT FOUND OR original.reversal_of IS NOT NULL OR NEW.amount <> -original.amount THEN
      RAISE EXCEPTION 'INVALID_HEART_REVERSAL' USING ERRCODE='23514';
    END IF;
  END IF;
  RETURN NEW;
END $$;
CREATE TRIGGER trg_heart_reversal BEFORE INSERT ON app.heart_ledger FOR EACH ROW EXECUTE FUNCTION app.check_heart_reversal();
CREATE TRIGGER trg_heart_immutable BEFORE UPDATE ON app.heart_ledger FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('user_id','source_type','source_id','reason','amount','reversal_of','local_date','deleted_at');
CREATE TRIGGER trg_heart_no_delete BEFORE DELETE ON app.heart_ledger FOR EACH ROW EXECUTE FUNCTION ops.deny_physical_delete();

CREATE FUNCTION ops.protect_pending_work() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF TG_OP='DELETE' THEN
    IF OLD.status IN ('PENDING','RUNNING','RETRY_WAIT') THEN RAISE EXCEPTION 'PENDING_WORK_RETENTION_FORBIDDEN' USING ERRCODE='23514'; END IF;
    RETURN OLD;
  END IF;
  IF NEW.deleted_at IS NOT NULL AND NEW.status IN ('PENDING','RUNNING','RETRY_WAIT') THEN
    RAISE EXCEPTION 'PENDING_WORK_RETENTION_FORBIDDEN' USING ERRCODE='23514';
  END IF;
  RETURN NEW;
END $$;
CREATE TRIGGER trg_pending_work BEFORE UPDATE OR DELETE ON ops.job_runs FOR EACH ROW EXECUTE FUNCTION ops.protect_pending_work();
-- Private schema has no PUBLIC access. Role provisioning, RLS and service ACL are
-- deployment work; the schema owner/superuser can still read all metadata/ciphertext.
REVOKE ALL ON SCHEMA us FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA us FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA us FROM PUBLIC;
-- Readiness/health are not expressed by this DDL. Workers must successfully query/claim
-- PostgreSQL before side effects and reconcile unknown provider outcomes after outages.
ALTER TABLE ops.ai_invocations ADD UNIQUE (id, family_id);
ALTER TABLE ops.ai_usage_reservations ADD FOREIGN KEY (invocation_id, family_id) REFERENCES ops.ai_invocations(id, family_id);
ALTER TABLE billing.subscription_transactions ADD plan_version_id uuid NOT NULL REFERENCES billing.plan_versions(id),
  ADD UNIQUE (id, family_id, license_id, plan_version_id);
ALTER TABLE billing.license_grants ADD FOREIGN KEY (transaction_id, family_id, license_id, plan_version_id) REFERENCES billing.subscription_transactions(id, family_id, license_id, plan_version_id);
CREATE TRIGGER trg_immutable_transaction_plan BEFORE UPDATE ON billing.subscription_transactions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('plan_version_id');
-- Store tokens/identifiers must not be reclaimed by changing or deleting historical rows.
CREATE TRIGGER trg_immutable_store_notification BEFORE UPDATE ON billing.store_notifications FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('store','environment','app_namespace','notification_id','payload_hash');

CREATE TRIGGER trg_immutable_key_owner BEFORE UPDATE ON us.data_keys FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('owner_type','user_id','couple_space_id','key_version');
CREATE TRIGGER trg_grant_no_soft_delete BEFORE UPDATE ON billing.license_grants FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('deleted_at');
-- Receipt provenance is a checked chain, not independent valid foreign keys.
ALTER TABLE billing.subscription_transactions
  ADD UNIQUE (id, subscription_id, family_id, license_id, plan_version_id),
  ADD UNIQUE (id, family_id, license_id, store, environment, app_namespace),
  ADD FOREIGN KEY (product_id, store, environment, app_namespace) REFERENCES billing.products(id, store, environment, app_namespace),
  ADD FOREIGN KEY (replaces_transaction_id, family_id, license_id, store, environment, app_namespace)
    REFERENCES billing.subscription_transactions(id, family_id, license_id, store, environment, app_namespace),
  ADD CHECK (replaces_transaction_id IS NULL OR replaces_transaction_id <> id);
ALTER TABLE billing.license_grants
  ADD FOREIGN KEY (transaction_id, subscription_id, family_id, license_id, plan_version_id)
    REFERENCES billing.subscription_transactions(id, subscription_id, family_id, license_id, plan_version_id);
ALTER TABLE billing.purchase_intents
  ADD UNIQUE (id, family_id, license_id, store, environment, app_namespace);
ALTER TABLE billing.subscriptions
  ADD UNIQUE (id, family_id, license_id, store, environment, app_namespace),
  ADD FOREIGN KEY (purchase_intent_id, family_id, license_id, store, environment, app_namespace)
    REFERENCES billing.purchase_intents(id, family_id, license_id, store, environment, app_namespace),
  ADD FOREIGN KEY (superseded_by, family_id, license_id, store, environment, app_namespace)
    REFERENCES billing.subscriptions(id, family_id, license_id, store, environment, app_namespace),
  ADD CHECK (superseded_by IS NULL OR superseded_by <> id);
ALTER TABLE billing.store_notifications
  ADD FOREIGN KEY (subscription_id, store, environment, app_namespace)
    REFERENCES billing.subscriptions(id, store, environment, app_namespace);
-- Self-links are rejected here. Longer cycles/provider chain trust require service validation.

-- A family's trial identity survives revoke/soft delete and cannot be claimed again.
CREATE UNIQUE INDEX uq_family_trial_once ON billing.license_grants(family_id) WHERE source='TRIAL';
CREATE TRIGGER trg_immutable_journal_owner BEFORE UPDATE ON us.journal_entries FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('user_id');
CREATE TRIGGER trg_immutable_journal_asset_owner BEFORE UPDATE ON us.journal_assets FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('owner_user_id');
-- A NULL lunar_leap is unspecified; service resolves/validates the recurrence rule before scheduling.


-- Preserve the existing Note resource while applying the mandatory audit policy.
ALTER TABLE public.notes ADD COLUMN deleted_at timestamptz(3) DEFAULT NULL;
ALTER TABLE public.notes ALTER COLUMN updated_at SET DEFAULT now();
CREATE TRIGGER trg_audit_update BEFORE UPDATE ON public.notes
  FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns();
CREATE INDEX ix_notes_active_created ON public.notes(created_at DESC, id DESC) WHERE deleted_at IS NULL;

-- Catalog data is seeded separately by npm run db:seed; no data mutations here.
COMMIT;
