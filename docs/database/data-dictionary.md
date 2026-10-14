# Data dictionary — Baby Family

Sinh từ metadata PostgreSQL cách ly sau khi replay migration backend, đối chiếu Prisma schema. Không đọc dữ liệu nghiệp vụ. Ngày kiểm chứng: 2026-10-14.

[Prisma schema](../../baby-backend/prisma/schema.prisma) · [Migration](../../baby-backend/prisma/migrations/20261013150000_family_domain/migration.sql) · [Thiết kế/phase](README.md) · [Kết quả kiểm chứng](verification.md).

123 bảng dự án ↔ 123 Prisma models. Bảng hệ thống/extension và _prisma_migrations không thuộc danh mục ứng dụng.

Mọi bảng có created_at/updated_at/deleted_at; SQL constraints không thay thế authorization ở service. Model/repository tương ứng nằm trong backend src/models, src/interfaces/repositories, src/repositories và DI registry. Không suy ra runtime feature đã hoàn chỉnh chỉ từ bảng hoặc persistence class.

## Danh mục

| Bảng                               | Prisma model                | Cột | Constraints | Indexes |
| ---------------------------------- | --------------------------- | --: | ----------: | ------: |
| app.ai_usage_monthly               | AiUsageMonthly              |   6 |           8 |       1 |
| app.album_memories                 | AlbumMemory                 |   8 |          11 |       1 |
| app.albums                         | Album                       |   9 |          12 |       2 |
| app.asset_variants                 | AssetVariant                |  15 |          17 |       3 |
| app.assets                         | Asset                       |  26 |          26 |       9 |
| app.auth_identities                | AuthIdentity                |  10 |           9 |       3 |
| app.badges                         | Badge                       |  10 |          10 |       1 |
| app.birth_conversion_children      | BirthConversionChild        |   6 |           9 |       1 |
| app.birth_conversions              | BirthConversion             |   7 |          13 |       3 |
| app.blocks                         | Block                       |   6 |          10 |       1 |
| app.care_weekly_snapshots          | CareWeeklySnapshot          |   9 |          11 |       2 |
| app.children                       | Child                       |  26 |          27 |       6 |
| app.circle_grants                  | CircleGrant                 |  12 |          15 |       5 |
| app.circle_members                 | CircleMember                |  13 |          16 |       4 |
| app.comments                       | Comment                     |  11 |          15 |       4 |
| app.couple_spaces                  | CoupleSpace                 |  14 |          23 |       4 |
| app.daily_mission_board_parents    | DailyMissionBoardParent     |   9 |          12 |       1 |
| app.daily_mission_boards           | DailyMissionBoard           |  13 |          16 |       1 |
| app.deletion_requests              | DeletionRequest             |  17 |          15 |       2 |
| app.event_children                 | EventChild                  |   6 |           8 |       1 |
| app.event_participants             | EventParticipant            |   8 |          10 |       1 |
| app.event_reminder_rules           | EventReminderRule           |   9 |          13 |       2 |
| app.event_reminders                | EventReminder               |  12 |          14 |       3 |
| app.events                         | Event                       |  23 |          26 |       3 |
| app.export_jobs                    | ExportJob                   |  15 |          11 |       1 |
| app.families                       | Family                      |  14 |          13 |       1 |
| app.family_badges                  | FamilyBadge                 |   8 |          11 |       2 |
| app.family_deletion_approvals      | FamilyDeletionApproval      |   9 |          12 |       1 |
| app.family_deletion_requests       | FamilyDeletionRequest       |  13 |          14 |       3 |
| app.family_invites                 | FamilyInvite                |  17 |          19 |       6 |
| app.family_parents                 | FamilyParent                |  12 |          14 |       6 |
| app.family_trees                   | FamilyTree                  |   9 |          12 |       1 |
| app.favorites                      | Favorite                    |   6 |          10 |       2 |
| app.heart_daily_counters           | HeartDailyCounter           |  11 |          15 |       1 |
| app.heart_ledger                   | HeartLedger                 |  12 |          18 |       6 |
| app.memories                       | Memory                      |  38 |          32 |      10 |
| app.memory_assets                  | MemoryAsset                 |   8 |          12 |       4 |
| app.memory_children                | MemoryChild                 |   8 |          10 |       4 |
| app.memory_letters                 | MemoryLetter                |   9 |          11 |       1 |
| app.memory_people                  | MemoryPerson                |  10 |          13 |       3 |
| app.memory_perspective_assets      | MemoryPerspectiveAsset      |   7 |           9 |       2 |
| app.memory_perspectives            | MemoryPerspective           |  13 |          15 |       3 |
| app.memory_pins                    | MemoryPin                   |   8 |          15 |       1 |
| app.memory_prompt_deliveries       | MemoryPromptDelivery        |  13 |          16 |       3 |
| app.memory_prompt_templates        | MemoryPromptTemplate        |  14 |          10 |       1 |
| app.milestone_templates            | MilestoneTemplate           |  13 |          10 |       1 |
| app.milestones                     | Milestone                   |  13 |          17 |       5 |
| app.mission_children               | MissionChild                |   6 |           9 |       2 |
| app.mission_completions            | MissionCompletion           |  13 |          17 |       4 |
| app.mission_events                 | MissionEvent                |   9 |          11 |       2 |
| app.mission_family_settings        | MissionFamilySetting        |   7 |           8 |       1 |
| app.mission_preferences            | MissionPreference           |   9 |          10 |       1 |
| app.mission_series                 | MissionSeries               |  24 |          28 |       2 |
| app.mission_series_children        | MissionSeriesChild          |   6 |           8 |       1 |
| app.mission_templates              | MissionTemplate             |  25 |          24 |       4 |
| app.missions                       | Mission                     |  32 |          38 |       9 |
| app.monthly_photos                 | MonthlyPhoto                |  14 |          17 |       3 |
| app.notification_deliveries        | NotificationDelivery        |  14 |          15 |       3 |
| app.notification_delivery_attempts | NotificationDeliveryAttempt |  11 |          10 |       2 |
| app.notifications                  | Notification                |  18 |          15 |       3 |
| app.pregnancies                    | Pregnancy                   |  17 |          22 |       3 |
| app.prep_items                     | PrepItem                    |  12 |          13 |       2 |
| app.reactions                      | Reaction                    |   7 |          11 |       1 |
| app.recaps                         | Recap                       |  16 |          20 |       3 |
| app.report_hides                   | ReportHide                  |   6 |           7 |       1 |
| app.reports                        | Report                      |  17 |          15 |       2 |
| app.storage_reservations           | StorageReservation          |  14 |          20 |       4 |
| app.story_views                    | StoryView                   |  11 |          14 |       1 |
| app.support_ticket_attachments     | SupportTicketAttachment     |   7 |          11 |       2 |
| app.support_ticket_messages        | SupportTicketMessage        |   8 |          10 |       1 |
| app.support_tickets                | SupportTicket               |  11 |          12 |       2 |
| app.user_assets                    | UserAsset                   |  15 |          18 |       4 |
| app.user_consents                  | UserConsent                 |  10 |           9 |       2 |
| app.user_devices                   | UserDevice                  |  14 |          11 |       4 |
| app.user_sessions                  | UserSession                 |  16 |          14 |       4 |
| app.user_settings                  | UserSetting                 |  21 |          22 |       1 |
| app.users                          | User                        |  12 |          11 |       1 |
| billing.family_entitlements        | FamilyEntitlement           |  14 |          17 |       2 |
| billing.family_licenses            | FamilyLicense               |   7 |           8 |       3 |
| billing.family_usage               | FamilyUsage                 |  11 |          13 |       1 |
| billing.license_grants             | LicenseGrant                |  18 |          25 |       5 |
| billing.plan_versions              | PlanVersion                 |  11 |          16 |       2 |
| billing.plans                      | Plan                        |   9 |          10 |       2 |
| billing.products                   | Product                     |  12 |          16 |       3 |
| billing.purchase_intents           | PurchaseIntent              |  18 |          23 |       5 |
| billing.store_notifications        | StoreNotification           |  19 |          18 |       3 |
| billing.subscription_transactions  | SubscriptionTransaction     |  23 |          33 |       6 |
| billing.subscriptions              | Subscription                |  26 |          31 |       8 |
| billing.trial_consumptions         | TrialConsumption            |  10 |          14 |       2 |
| billing.trial_policies             | TrialPolicy                 |  12 |          18 |       4 |
| ops.admin_audit_events             | AdminAuditEvent             |  11 |           8 |       1 |
| ops.admin_sessions                 | AdminSession                |   9 |          10 |       2 |
| ops.admin_users                    | AdminUser                   |  10 |          10 |       2 |
| ops.ai_invocations                 | AiInvocation                |  15 |          15 |       2 |
| ops.ai_usage_reservations          | AiUsageReservation          |  12 |          17 |       3 |
| ops.app_config                     | AppConfig                   |   6 |           6 |       1 |
| ops.content_items                  | ContentItem                 |  10 |          10 |       1 |
| ops.idempotency_records            | IdempotencyRecord           |  16 |          14 |       2 |
| ops.job_attempts                   | JobAttempt                  |  14 |          18 |       3 |
| ops.job_runs                       | JobRun                      |  24 |          22 |       5 |
| ops.job_schedules                  | JobSchedule                 |  14 |          14 |       2 |
| ops.moderation_actions             | ModerationAction            |   8 |          10 |       1 |
| ops.moderation_case_reports        | ModerationCaseReport        |   5 |           7 |       1 |
| ops.moderation_cases               | ModerationCase              |  11 |          10 |       1 |
| ops.notification_templates         | NotificationTemplate        |  13 |          11 |       1 |
| ops.outbox_events                  | OutboxEvent                 |  16 |          13 |       4 |
| ops.sync_tombstones                | SyncTombstone               |   9 |          10 |       2 |
| public.notes                       | Note                        |   6 |           5 |       2 |
| us.appreciations                   | Appreciation                |  18 |          17 |       2 |
| us.conflict_confirmations          | ConflictConfirmation        |   9 |          12 |       1 |
| us.conflict_entries                | ConflictEntry               |  15 |          18 |       3 |
| us.conflict_sessions               | ConflictSession             |  16 |          17 |       3 |
| us.connection_answers              | ConnectionAnswer            |  11 |          12 |       1 |
| us.data_keys                       | DataKey                     |  11 |          14 |       3 |
| us.journal_assets                  | JournalAsset                |   8 |          11 |       1 |
| us.journal_entries                 | JournalEntry                |   9 |          11 |       5 |
| us.journal_shares                  | JournalShare                |  12 |          16 |       1 |
| us.mood_checkins                   | MoodCheckin                 |  16 |          20 |       5 |
| us.mood_responses                  | MoodResponse                |  10 |          15 |       1 |
| us.pregnancy_name_candidates       | PregnancyNameCandidate      |  12 |          17 |       4 |
| us.pregnancy_name_votes            | PregnancyNameVote           |   7 |          12 |       1 |
| us.request_children                | RequestChild                |   6 |           8 |       1 |
| us.requests                        | Request                     |  32 |          36 |       7 |

## app.ai_usage_monthly — AiUsageMonthly

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| family_id  | uuid                        | Có       | —                              |
| month      | date                        | Có       | —                              |
| used       | integer                     | Có       | 0                              |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `ai_usage_monthly_check`: `CHECK (((used >= 0) AND (EXTRACT(day FROM month) = (1)::numeric)))`
- `ai_usage_monthly_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `ai_usage_monthly_created_at_not_null`: `NOT NULL created_at`
- `ai_usage_monthly_family_id_not_null`: `NOT NULL family_id`
- `ai_usage_monthly_month_not_null`: `NOT NULL month`
- `ai_usage_monthly_updated_at_not_null`: `NOT NULL updated_at`
- `ai_usage_monthly_used_not_null`: `NOT NULL used`
- `ai_usage_monthly_pkey`: `PRIMARY KEY (family_id, month)`

Indexes:

- `ai_usage_monthly_pkey`: `CREATE UNIQUE INDEX ai_usage_monthly_pkey ON app.ai_usage_monthly USING btree (family_id, month)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.ai_usage_monthly FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.ai_usage_monthly FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.album_memories — AlbumMemory

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| album_id   | uuid                        | Có       | —                              |
| memory_id  | uuid                        | Có       | —                              |
| family_id  | uuid                        | Có       | —                              |
| added_by   | uuid                        | Có       | —                              |
| added_at   | timestamp(3) with time zone | Có       | now()                          |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `album_memories_added_by_fkey`: `FOREIGN KEY (added_by) REFERENCES app.users(id)`
- `album_memories_album_id_family_id_fkey`: `FOREIGN KEY (album_id, family_id) REFERENCES app.albums(id, family_id) ON DELETE CASCADE`
- `album_memories_memory_id_family_id_fkey`: `FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE`
- `album_memories_added_at_not_null`: `NOT NULL added_at`
- `album_memories_added_by_not_null`: `NOT NULL added_by`
- `album_memories_album_id_not_null`: `NOT NULL album_id`
- `album_memories_created_at_not_null`: `NOT NULL created_at`
- `album_memories_family_id_not_null`: `NOT NULL family_id`
- `album_memories_memory_id_not_null`: `NOT NULL memory_id`
- `album_memories_updated_at_not_null`: `NOT NULL updated_at`
- `album_memories_pkey`: `PRIMARY KEY (album_id, memory_id)`

Indexes:

- `album_memories_pkey`: `CREATE UNIQUE INDEX album_memories_pkey ON app.album_memories USING btree (album_id, memory_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.album_memories FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.album_memories FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.albums — Album

| Cột             | PostgreSQL type             | NOT NULL | Default  |
| --------------- | --------------------------- | -------- | -------- |
| id              | uuid                        | Có       | uuidv7() |
| family_id       | uuid                        | Có       | —        |
| owner_user_id   | uuid                        | Có       | —        |
| name            | character varying(60)       | Có       | —        |
| cover_memory_id | uuid                        | Không    | —        |
| is_sensitive    | boolean                     | Có       | false    |
| created_at      | timestamp(3) with time zone | Có       | now()    |
| deleted_at      | timestamp(3) with time zone | Không    | —        |
| updated_at      | timestamp(3) with time zone | Có       | now()    |

Constraints:

- `albums_cover_memory_id_family_id_fkey`: `FOREIGN KEY (cover_memory_id, family_id) REFERENCES app.memories(id, family_id)`
- `albums_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `albums_owner_user_id_fkey`: `FOREIGN KEY (owner_user_id) REFERENCES app.users(id)`
- `albums_created_at_not_null`: `NOT NULL created_at`
- `albums_family_id_not_null`: `NOT NULL family_id`
- `albums_id_not_null`: `NOT NULL id`
- `albums_is_sensitive_not_null`: `NOT NULL is_sensitive`
- `albums_name_not_null`: `NOT NULL name`
- `albums_owner_user_id_not_null`: `NOT NULL owner_user_id`
- `albums_updated_at_not_null`: `NOT NULL updated_at`
- `albums_pkey`: `PRIMARY KEY (id)`
- `albums_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `albums_id_family_id_key`: `CREATE UNIQUE INDEX albums_id_family_id_key ON app.albums USING btree (id, family_id)`
- `albums_pkey`: `CREATE UNIQUE INDEX albums_pkey ON app.albums USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.albums FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.albums FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.asset_variants — AssetVariant

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| id              | uuid                        | Có       | uuidv7()                       |
| family_id       | uuid                        | Có       | —                              |
| asset_id        | uuid                        | Có       | —                              |
| variant_code    | character varying(30)       | Có       | —                              |
| storage_bucket  | character varying(80)       | Có       | —                              |
| storage_key     | text                        | Có       | —                              |
| mime            | character varying(80)       | Có       | —                              |
| size_bytes      | bigint                      | Có       | —                              |
| width           | integer                     | Không    | —                              |
| height          | integer                     | Không    | —                              |
| duration_ms     | integer                     | Không    | —                              |
| checksum_sha256 | bytea                       | Không    | —                              |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `asset_variants_check`: `CHECK ((((width IS NULL) OR (width > 0)) AND ((height IS NULL) OR (height > 0)) AND ((duration_ms IS NULL) OR (duration_ms >= 0))))`
- `asset_variants_checksum_sha256_check`: `CHECK (((checksum_sha256 IS NULL) OR (octet_length(checksum_sha256) = 32)))`
- `asset_variants_size_bytes_check`: `CHECK ((size_bytes >= 0))`
- `asset_variants_asset_id_family_id_fkey`: `FOREIGN KEY (asset_id, family_id) REFERENCES app.assets(id, family_id)`
- `asset_variants_asset_id_not_null`: `NOT NULL asset_id`
- `asset_variants_created_at_not_null`: `NOT NULL created_at`
- `asset_variants_family_id_not_null`: `NOT NULL family_id`
- `asset_variants_id_not_null`: `NOT NULL id`
- `asset_variants_mime_not_null`: `NOT NULL mime`
- `asset_variants_size_bytes_not_null`: `NOT NULL size_bytes`
- `asset_variants_storage_bucket_not_null`: `NOT NULL storage_bucket`
- `asset_variants_storage_key_not_null`: `NOT NULL storage_key`
- `asset_variants_updated_at_not_null`: `NOT NULL updated_at`
- `asset_variants_variant_code_not_null`: `NOT NULL variant_code`
- `asset_variants_pkey`: `PRIMARY KEY (id)`
- `asset_variants_asset_id_variant_code_key`: `UNIQUE (asset_id, variant_code)`
- `asset_variants_storage_bucket_storage_key_key`: `UNIQUE (storage_bucket, storage_key)`

Indexes:

- `asset_variants_asset_id_variant_code_key`: `CREATE UNIQUE INDEX asset_variants_asset_id_variant_code_key ON app.asset_variants USING btree (asset_id, variant_code)`
- `asset_variants_pkey`: `CREATE UNIQUE INDEX asset_variants_pkey ON app.asset_variants USING btree (id)`
- `asset_variants_storage_bucket_storage_key_key`: `CREATE UNIQUE INDEX asset_variants_storage_bucket_storage_key_key ON app.asset_variants USING btree (storage_bucket, storage_key)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.asset_variants FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.asset_variants FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.assets — Asset

| Cột                   | PostgreSQL type             | NOT NULL | Default                            |
| --------------------- | --------------------------- | -------- | ---------------------------------- |
| id                    | uuid                        | Có       | uuidv7()                           |
| family_id             | uuid                        | Có       | —                                  |
| uploader_user_id      | uuid                        | Có       | —                                  |
| kind                  | app.asset_kind              | Có       | —                                  |
| purpose               | character varying(20)       | Có       | 'MEMORY'::character varying        |
| status                | app.asset_status            | Có       | 'PENDING_UPLOAD'::app.asset_status |
| storage_key           | text                        | Có       | —                                  |
| multipart_upload_id   | text                        | Không    | —                                  |
| mime                  | character varying(60)       | Có       | —                                  |
| declared_size         | bigint                      | Có       | —                                  |
| size_bytes            | bigint                      | Không    | —                                  |
| width                 | integer                     | Không    | —                                  |
| height                | integer                     | Không    | —                                  |
| duration_ms           | integer                     | Không    | —                                  |
| sha256                | bytea                       | Không    | —                                  |
| captured_at           | timestamp(3) with time zone | Không    | —                                  |
| blurhash              | character varying(64)       | Không    | —                                  |
| keep_original         | boolean                     | Có       | false                              |
| failure_reason        | character varying(60)       | Không    | —                                  |
| created_at            | timestamp(3) with time zone | Có       | now()                              |
| ready_at              | timestamp(3) with time zone | Không    | —                                  |
| deleted_at            | timestamp(3) with time zone | Không    | —                                  |
| purge_after           | timestamp(3) with time zone | Không    | —                                  |
| updated_at            | timestamp(3) with time zone | Có       | now()                              |
| storage_bucket        | character varying(80)       | Có       | 'bf-media'::character varying      |
| private_owner_user_id | uuid                        | Không    | —                                  |

Constraints:

- `assets_check`: `CHECK (((declared_size >= 0) AND ((size_bytes IS NULL) OR (size_bytes >= 0))))`
- `assets_check1`: `CHECK ((((width IS NULL) OR (width > 0)) AND ((height IS NULL) OR (height > 0)) AND ((duration_ms IS NULL) OR (duration_ms >= 0))))`
- `assets_check2`: `CHECK ((((purpose)::text = 'JOURNAL'::text) = (private_owner_user_id IS NOT NULL)))`
- `assets_check3`: `CHECK (((private_owner_user_id IS NULL) OR (private_owner_user_id = uploader_user_id)))`
- `assets_sha256_check`: `CHECK (((sha256 IS NULL) OR (octet_length(sha256) = 32)))`
- `assets_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `assets_private_owner_user_id_fkey`: `FOREIGN KEY (private_owner_user_id) REFERENCES app.users(id)`
- `assets_uploader_user_id_fkey`: `FOREIGN KEY (uploader_user_id) REFERENCES app.users(id)`
- `assets_created_at_not_null`: `NOT NULL created_at`
- `assets_declared_size_not_null`: `NOT NULL declared_size`
- `assets_family_id_not_null`: `NOT NULL family_id`
- `assets_id_not_null`: `NOT NULL id`
- `assets_keep_original_not_null`: `NOT NULL keep_original`
- `assets_kind_not_null`: `NOT NULL kind`
- `assets_mime_not_null`: `NOT NULL mime`
- `assets_purpose_not_null`: `NOT NULL purpose`
- `assets_status_not_null`: `NOT NULL status`
- `assets_storage_bucket_not_null`: `NOT NULL storage_bucket`
- `assets_storage_key_not_null`: `NOT NULL storage_key`
- `assets_updated_at_not_null`: `NOT NULL updated_at`
- `assets_uploader_user_id_not_null`: `NOT NULL uploader_user_id`
- `assets_pkey`: `PRIMARY KEY (id)`
- `assets_id_family_id_key`: `UNIQUE (id, family_id)`
- `assets_id_family_id_uploader_user_id_key`: `UNIQUE (id, family_id, uploader_user_id)`
- `assets_id_uploader_user_id_key`: `UNIQUE (id, uploader_user_id)`
- `assets_storage_bucket_storage_key_key`: `UNIQUE (storage_bucket, storage_key)`

Indexes:

- `assets_family_id_status_idx`: `CREATE INDEX assets_family_id_status_idx ON app.assets USING btree (family_id, status)`
- `assets_id_family_id_key`: `CREATE UNIQUE INDEX assets_id_family_id_key ON app.assets USING btree (id, family_id)`
- `assets_id_family_id_uploader_user_id_key`: `CREATE UNIQUE INDEX assets_id_family_id_uploader_user_id_key ON app.assets USING btree (id, family_id, uploader_user_id)`
- `assets_id_uploader_user_id_key`: `CREATE UNIQUE INDEX assets_id_uploader_user_id_key ON app.assets USING btree (id, uploader_user_id)`
- `assets_pkey`: `CREATE UNIQUE INDEX assets_pkey ON app.assets USING btree (id)`
- `assets_status_created_at_idx`: `CREATE INDEX assets_status_created_at_idx ON app.assets USING btree (status, created_at) WHERE ((status = ANY (ARRAY['PENDING_UPLOAD'::app.asset_status, 'UPLOADED'::app.asset_status, 'PROCESSING'::app.asset_status])) AND (deleted_at IS NULL))`
- `assets_storage_bucket_storage_key_key`: `CREATE UNIQUE INDEX assets_storage_bucket_storage_key_key ON app.assets USING btree (storage_bucket, storage_key)`
- `ix_asset_purge`: `CREATE INDEX ix_asset_purge ON app.assets USING btree (purge_after) WHERE (purge_after IS NOT NULL)`
- `uq_asset_dedup`: `CREATE UNIQUE INDEX uq_asset_dedup ON app.assets USING btree (family_id, purpose, private_owner_user_id, sha256) NULLS NOT DISTINCT WHERE ((sha256 IS NOT NULL) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.assets FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_asset_owner`: `CREATE TRIGGER trg_immutable_asset_owner BEFORE UPDATE ON app.assets FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('uploader_user_id', 'private_owner_user_id', 'purpose', 'storage_bucket', 'storage_key')`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.assets FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.auth_identities — AuthIdentity

| Cột                        | PostgreSQL type             | NOT NULL | Default                        |
| -------------------------- | --------------------------- | -------- | ------------------------------ |
| id                         | uuid                        | Có       | uuidv7()                       |
| user_id                    | uuid                        | Có       | —                              |
| provider                   | app.auth_provider           | Có       | —                              |
| provider_uid               | character varying(255)      | Có       | —                              |
| email                      | citext                      | Không    | —                              |
| provider_refresh_token_enc | bytea                       | Không    | —                              |
| created_at                 | timestamp(3) with time zone | Có       | now()                          |
| last_used_at               | timestamp(3) with time zone | Không    | —                              |
| updated_at                 | timestamp(3) with time zone | Có       | now()                          |
| deleted_at                 | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `auth_identities_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `auth_identities_created_at_not_null`: `NOT NULL created_at`
- `auth_identities_id_not_null`: `NOT NULL id`
- `auth_identities_provider_not_null`: `NOT NULL provider`
- `auth_identities_provider_uid_not_null`: `NOT NULL provider_uid`
- `auth_identities_updated_at_not_null`: `NOT NULL updated_at`
- `auth_identities_user_id_not_null`: `NOT NULL user_id`
- `auth_identities_pkey`: `PRIMARY KEY (id)`
- `auth_identities_provider_provider_uid_key`: `UNIQUE (provider, provider_uid)`

Indexes:

- `auth_identities_pkey`: `CREATE UNIQUE INDEX auth_identities_pkey ON app.auth_identities USING btree (id)`
- `auth_identities_provider_provider_uid_key`: `CREATE UNIQUE INDEX auth_identities_provider_provider_uid_key ON app.auth_identities USING btree (provider, provider_uid)`
- `auth_identities_user_id_idx`: `CREATE INDEX auth_identities_user_id_idx ON app.auth_identities USING btree (user_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.auth_identities FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## app.badges — Badge

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| code       | character varying(30)       | Có       | —                              |
| title_i18n | jsonb                       | Có       | —                              |
| desc_i18n  | jsonb                       | Có       | —                              |
| icon       | character varying(60)       | Có       | —                              |
| rule       | jsonb                       | Có       | —                              |
| scope      | character varying(10)       | Có       | 'FAMILY'::character varying    |
| status     | character varying(10)       | Có       | 'ACTIVE'::character varying    |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `badges_code_not_null`: `NOT NULL code`
- `badges_created_at_not_null`: `NOT NULL created_at`
- `badges_desc_i18n_not_null`: `NOT NULL desc_i18n`
- `badges_icon_not_null`: `NOT NULL icon`
- `badges_rule_not_null`: `NOT NULL rule`
- `badges_scope_not_null`: `NOT NULL scope`
- `badges_status_not_null`: `NOT NULL status`
- `badges_title_i18n_not_null`: `NOT NULL title_i18n`
- `badges_updated_at_not_null`: `NOT NULL updated_at`
- `badges_pkey`: `PRIMARY KEY (code)`

Indexes:

- `badges_pkey`: `CREATE UNIQUE INDEX badges_pkey ON app.badges USING btree (code)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.badges FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## app.birth_conversion_children — BirthConversionChild

| Cột          | PostgreSQL type             | NOT NULL | Default                        |
| ------------ | --------------------------- | -------- | ------------------------------ |
| pregnancy_id | uuid                        | Có       | —                              |
| child_id     | uuid                        | Có       | —                              |
| family_id    | uuid                        | Có       | —                              |
| created_at   | timestamp(3) with time zone | Có       | now()                          |
| updated_at   | timestamp(3) with time zone | Có       | now()                          |
| deleted_at   | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `birth_conversion_children_child_id_family_id_fkey`: `FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)`
- `birth_conversion_children_child_id_family_id_pregnancy_id_fkey`: `FOREIGN KEY (child_id, family_id, pregnancy_id) REFERENCES app.children(id, family_id, pregnancy_id)`
- `birth_conversion_children_pregnancy_id_family_id_fkey`: `FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.birth_conversions(pregnancy_id, family_id)`
- `birth_conversion_children_child_id_not_null`: `NOT NULL child_id`
- `birth_conversion_children_created_at_not_null`: `NOT NULL created_at`
- `birth_conversion_children_family_id_not_null`: `NOT NULL family_id`
- `birth_conversion_children_pregnancy_id_not_null`: `NOT NULL pregnancy_id`
- `birth_conversion_children_updated_at_not_null`: `NOT NULL updated_at`
- `birth_conversion_children_pkey`: `PRIMARY KEY (pregnancy_id, child_id)`

Indexes:

- `birth_conversion_children_pkey`: `CREATE UNIQUE INDEX birth_conversion_children_pkey ON app.birth_conversion_children USING btree (pregnancy_id, child_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.birth_conversion_children FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.birth_conversion_children FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.birth_conversions — BirthConversion

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| pregnancy_id    | uuid                        | Có       | —                              |
| idempotency_key | uuid                        | Có       | —                              |
| family_id       | uuid                        | Có       | —                              |
| created_by      | uuid                        | Có       | —                              |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `birth_conversions_created_by_fkey`: `FOREIGN KEY (created_by) REFERENCES app.users(id)`
- `birth_conversions_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `birth_conversions_pregnancy_id_family_id_fkey`: `FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id)`
- `birth_conversions_pregnancy_id_fkey`: `FOREIGN KEY (pregnancy_id) REFERENCES app.pregnancies(id)`
- `birth_conversions_created_at_not_null`: `NOT NULL created_at`
- `birth_conversions_created_by_not_null`: `NOT NULL created_by`
- `birth_conversions_family_id_not_null`: `NOT NULL family_id`
- `birth_conversions_idempotency_key_not_null`: `NOT NULL idempotency_key`
- `birth_conversions_pregnancy_id_not_null`: `NOT NULL pregnancy_id`
- `birth_conversions_updated_at_not_null`: `NOT NULL updated_at`
- `birth_conversions_pkey`: `PRIMARY KEY (pregnancy_id)`
- `birth_conversions_idempotency_key_key`: `UNIQUE (idempotency_key)`
- `birth_conversions_pregnancy_id_family_id_key`: `UNIQUE (pregnancy_id, family_id)`

Indexes:

- `birth_conversions_idempotency_key_key`: `CREATE UNIQUE INDEX birth_conversions_idempotency_key_key ON app.birth_conversions USING btree (idempotency_key)`
- `birth_conversions_pkey`: `CREATE UNIQUE INDEX birth_conversions_pkey ON app.birth_conversions USING btree (pregnancy_id)`
- `birth_conversions_pregnancy_id_family_id_key`: `CREATE UNIQUE INDEX birth_conversions_pregnancy_id_family_id_key ON app.birth_conversions USING btree (pregnancy_id, family_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.birth_conversions FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.birth_conversions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.blocks — Block

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| family_id       | uuid                        | Có       | —                              |
| blocker_user_id | uuid                        | Có       | —                              |
| blocked_user_id | uuid                        | Có       | —                              |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `blocks_check`: `CHECK ((blocker_user_id <> blocked_user_id))`
- `blocks_blocked_user_id_fkey`: `FOREIGN KEY (blocked_user_id) REFERENCES app.users(id)`
- `blocks_blocker_user_id_fkey`: `FOREIGN KEY (blocker_user_id) REFERENCES app.users(id)`
- `blocks_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `blocks_blocked_user_id_not_null`: `NOT NULL blocked_user_id`
- `blocks_blocker_user_id_not_null`: `NOT NULL blocker_user_id`
- `blocks_created_at_not_null`: `NOT NULL created_at`
- `blocks_family_id_not_null`: `NOT NULL family_id`
- `blocks_updated_at_not_null`: `NOT NULL updated_at`
- `blocks_pkey`: `PRIMARY KEY (family_id, blocker_user_id, blocked_user_id)`

Indexes:

- `blocks_pkey`: `CREATE UNIQUE INDEX blocks_pkey ON app.blocks USING btree (family_id, blocker_user_id, blocked_user_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.blocks FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.blocks FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.care_weekly_snapshots — CareWeeklySnapshot

| Cột         | PostgreSQL type             | NOT NULL | Default                        |
| ----------- | --------------------------- | -------- | ------------------------------ |
| family_id   | uuid                        | Có       | —                              |
| week_start  | date                        | Có       | —                              |
| child_id    | uuid                        | Không    | —                              |
| metrics     | jsonb                       | Có       | —                              |
| computed_at | timestamp(3) with time zone | Có       | now()                          |
| created_at  | timestamp(3) with time zone | Có       | now()                          |
| updated_at  | timestamp(3) with time zone | Có       | now()                          |
| deleted_at  | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| id          | uuid                        | Có       | uuidv7()                       |

Constraints:

- `care_weekly_snapshots_child_id_family_id_fkey`: `FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)`
- `care_weekly_snapshots_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `care_weekly_snapshots_computed_at_not_null`: `NOT NULL computed_at`
- `care_weekly_snapshots_created_at_not_null`: `NOT NULL created_at`
- `care_weekly_snapshots_family_id_not_null`: `NOT NULL family_id`
- `care_weekly_snapshots_id_not_null`: `NOT NULL id`
- `care_weekly_snapshots_metrics_not_null`: `NOT NULL metrics`
- `care_weekly_snapshots_updated_at_not_null`: `NOT NULL updated_at`
- `care_weekly_snapshots_week_start_not_null`: `NOT NULL week_start`
- `care_weekly_snapshots_pkey`: `PRIMARY KEY (id)`
- `care_weekly_snapshots_family_id_week_start_child_id_key`: `UNIQUE NULLS NOT DISTINCT (family_id, week_start, child_id)`

Indexes:

- `care_weekly_snapshots_family_id_week_start_child_id_key`: `CREATE UNIQUE INDEX care_weekly_snapshots_family_id_week_start_child_id_key ON app.care_weekly_snapshots USING btree (family_id, week_start, child_id) NULLS NOT DISTINCT`
- `care_weekly_snapshots_pkey`: `CREATE UNIQUE INDEX care_weekly_snapshots_pkey ON app.care_weekly_snapshots USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.care_weekly_snapshots FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.care_weekly_snapshots FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.children — Child

| Cột                   | PostgreSQL type             | NOT NULL | Default                        |
| --------------------- | --------------------------- | -------- | ------------------------------ |
| id                    | uuid                        | Có       | uuidv7()                       |
| family_id             | uuid                        | Có       | —                              |
| pregnancy_id          | uuid                        | Không    | —                              |
| birth_order           | smallint                    | Không    | —                              |
| name                  | character varying(60)       | Không    | —                              |
| nickname              | character varying(40)       | Không    | —                              |
| birth_date            | date                        | Có       | —                              |
| birth_time            | time without time zone      | Không    | —                              |
| gender                | app.gender                  | Có       | 'UNSPECIFIED'::app.gender      |
| color_index           | smallint                    | Có       | —                              |
| avatar_asset_id       | uuid                        | Không    | —                              |
| cover_asset_id        | uuid                        | Không    | —                              |
| profile               | jsonb                       | Có       | '{}'::jsonb                    |
| birth_stats           | jsonb                       | Không    | —                              |
| status                | app.child_status            | Có       | 'ACTIVE'::app.child_status     |
| sort_order            | smallint                    | Có       | 0                              |
| monthly_photo_mode    | character varying(10)       | Có       | 'AUTO'::character varying      |
| monthly_photo_lunar   | boolean                     | Có       | false                          |
| created_by            | uuid                        | Có       | —                              |
| created_at            | timestamp(3) with time zone | Có       | now()                          |
| updated_at            | timestamp(3) with time zone | Có       | now()                          |
| archived_at           | timestamp(3) with time zone | Không    | —                              |
| version               | integer                     | Có       | 1                              |
| deleted_at            | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| deletion_requested_at | timestamp(3) with time zone | Không    | —                              |
| purge_after           | timestamp(3) with time zone | Không    | —                              |

Constraints:

- `children_check`: `CHECK (((name IS NOT NULL) OR (nickname IS NOT NULL)))`
- `children_check1`: `CHECK ((((pregnancy_id IS NULL) AND (birth_order IS NULL)) OR ((pregnancy_id IS NOT NULL) AND ((birth_order >= 1) AND (birth_order <= 4)))))`
- `children_check2`: `CHECK (((pregnancy_id IS NULL) OR (birth_order IS NOT NULL)))`
- `children_check3`: `CHECK ((COALESCE(NULLIF(btrim((name)::text), ''::text), NULLIF(btrim((nickname)::text), ''::text)) IS NOT NULL))`
- `children_color_index_check`: `CHECK (((color_index >= 1) AND (color_index <= 8)))`
- `children_avatar_asset_id_family_id_fkey`: `FOREIGN KEY (avatar_asset_id, family_id) REFERENCES app.assets(id, family_id)`
- `children_cover_asset_id_family_id_fkey`: `FOREIGN KEY (cover_asset_id, family_id) REFERENCES app.assets(id, family_id)`
- `children_created_by_fkey`: `FOREIGN KEY (created_by) REFERENCES app.users(id)`
- `children_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `children_pregnancy_id_family_id_fkey`: `FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id)`
- `children_birth_date_not_null`: `NOT NULL birth_date`
- `children_color_index_not_null`: `NOT NULL color_index`
- `children_created_at_not_null`: `NOT NULL created_at`
- `children_created_by_not_null`: `NOT NULL created_by`
- `children_family_id_not_null`: `NOT NULL family_id`
- `children_gender_not_null`: `NOT NULL gender`
- `children_id_not_null`: `NOT NULL id`
- `children_monthly_photo_lunar_not_null`: `NOT NULL monthly_photo_lunar`
- `children_monthly_photo_mode_not_null`: `NOT NULL monthly_photo_mode`
- `children_profile_not_null`: `NOT NULL profile`
- `children_sort_order_not_null`: `NOT NULL sort_order`
- `children_status_not_null`: `NOT NULL status`
- `children_updated_at_not_null`: `NOT NULL updated_at`
- `children_version_not_null`: `NOT NULL version`
- `children_pkey`: `PRIMARY KEY (id)`
- `children_id_family_id_key`: `UNIQUE (id, family_id)`
- `children_id_family_id_pregnancy_id_key`: `UNIQUE (id, family_id, pregnancy_id)`

Indexes:

- `children_family_id_status_idx`: `CREATE INDEX children_family_id_status_idx ON app.children USING btree (family_id, status)`
- `children_id_family_id_key`: `CREATE UNIQUE INDEX children_id_family_id_key ON app.children USING btree (id, family_id)`
- `children_id_family_id_pregnancy_id_key`: `CREATE UNIQUE INDEX children_id_family_id_pregnancy_id_key ON app.children USING btree (id, family_id, pregnancy_id)`
- `children_pkey`: `CREATE UNIQUE INDEX children_pkey ON app.children USING btree (id)`
- `ix_children_family_active`: `CREATE INDEX ix_children_family_active ON app.children USING btree (family_id, sort_order, id) WHERE (deleted_at IS NULL)`
- `uq_child_birth_order`: `CREATE UNIQUE INDEX uq_child_birth_order ON app.children USING btree (pregnancy_id, birth_order) WHERE ((pregnancy_id IS NOT NULL) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.children FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.children FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.circle_grants — CircleGrant

| Cột              | PostgreSQL type             | NOT NULL | Default                        |
| ---------------- | --------------------------- | -------- | ------------------------------ |
| id               | uuid                        | Có       | uuidv7()                       |
| family_id        | uuid                        | Có       | —                              |
| circle_member_id | uuid                        | Có       | —                              |
| child_id         | uuid                        | Không    | —                              |
| pregnancy_id     | uuid                        | Không    | —                              |
| permission       | app.grant_permission        | Có       | —                              |
| status           | app.grant_status            | Có       | 'ACTIVE'::app.grant_status     |
| created_by       | uuid                        | Có       | —                              |
| created_at       | timestamp(3) with time zone | Có       | now()                          |
| updated_at       | timestamp(3) with time zone | Có       | now()                          |
| deleted_at       | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| allow_download   | boolean                     | Có       | false                          |

Constraints:

- `circle_grants_check`: `CHECK (((((child_id IS NOT NULL))::integer + ((pregnancy_id IS NOT NULL))::integer) = 1))`
- `circle_grants_child_id_family_id_fkey`: `FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)`
- `circle_grants_circle_member_id_family_id_fkey`: `FOREIGN KEY (circle_member_id, family_id) REFERENCES app.circle_members(id, family_id)`
- `circle_grants_created_by_fkey`: `FOREIGN KEY (created_by) REFERENCES app.users(id)`
- `circle_grants_pregnancy_id_family_id_fkey`: `FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id)`
- `circle_grants_allow_download_not_null`: `NOT NULL allow_download`
- `circle_grants_circle_member_id_not_null`: `NOT NULL circle_member_id`
- `circle_grants_created_at_not_null`: `NOT NULL created_at`
- `circle_grants_created_by_not_null`: `NOT NULL created_by`
- `circle_grants_family_id_not_null`: `NOT NULL family_id`
- `circle_grants_id_not_null`: `NOT NULL id`
- `circle_grants_permission_not_null`: `NOT NULL permission`
- `circle_grants_status_not_null`: `NOT NULL status`
- `circle_grants_updated_at_not_null`: `NOT NULL updated_at`
- `circle_grants_pkey`: `PRIMARY KEY (id)`

Indexes:

- `circle_grants_family_id_child_id_idx`: `CREATE INDEX circle_grants_family_id_child_id_idx ON app.circle_grants USING btree (family_id, child_id) WHERE ((status = 'ACTIVE'::app.grant_status) AND (deleted_at IS NULL))`
- `circle_grants_pkey`: `CREATE UNIQUE INDEX circle_grants_pkey ON app.circle_grants USING btree (id)`
- `ix_circle_grant_pregnancy`: `CREATE INDEX ix_circle_grant_pregnancy ON app.circle_grants USING btree (family_id, pregnancy_id) WHERE ((status = 'ACTIVE'::app.grant_status) AND (deleted_at IS NULL))`
- `uq_grant_child`: `CREATE UNIQUE INDEX uq_grant_child ON app.circle_grants USING btree (circle_member_id, child_id) WHERE ((child_id IS NOT NULL) AND (deleted_at IS NULL))`
- `uq_grant_preg`: `CREATE UNIQUE INDEX uq_grant_preg ON app.circle_grants USING btree (circle_member_id, pregnancy_id) WHERE ((pregnancy_id IS NOT NULL) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.circle_grants FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.circle_grants FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.circle_members — CircleMember

| Cột            | PostgreSQL type             | NOT NULL | Default                        |
| -------------- | --------------------------- | -------- | ------------------------------ |
| id             | uuid                        | Có       | uuidv7()                       |
| family_id      | uuid                        | Có       | —                              |
| user_id        | uuid                        | Có       | —                              |
| relation       | app.circle_relation         | Có       | —                              |
| display_name   | character varying(40)       | Có       | —                              |
| allow_download | boolean                     | Có       | false                          |
| status         | app.circle_status           | Có       | 'ACTIVE'::app.circle_status    |
| invited_by     | uuid                        | Không    | —                              |
| joined_at      | timestamp(3) with time zone | Có       | now()                          |
| ended_at       | timestamp(3) with time zone | Không    | —                              |
| created_at     | timestamp(3) with time zone | Có       | now()                          |
| updated_at     | timestamp(3) with time zone | Có       | now()                          |
| deleted_at     | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `circle_members_display_name_check`: `CHECK (((display_name IS NULL) OR (char_length(btrim((display_name)::text)) > 0)))`
- `circle_members_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `circle_members_invited_by_fkey`: `FOREIGN KEY (invited_by) REFERENCES app.users(id)`
- `circle_members_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `circle_members_allow_download_not_null`: `NOT NULL allow_download`
- `circle_members_created_at_not_null`: `NOT NULL created_at`
- `circle_members_display_name_not_null`: `NOT NULL display_name`
- `circle_members_family_id_not_null`: `NOT NULL family_id`
- `circle_members_id_not_null`: `NOT NULL id`
- `circle_members_joined_at_not_null`: `NOT NULL joined_at`
- `circle_members_relation_not_null`: `NOT NULL relation`
- `circle_members_status_not_null`: `NOT NULL status`
- `circle_members_updated_at_not_null`: `NOT NULL updated_at`
- `circle_members_user_id_not_null`: `NOT NULL user_id`
- `circle_members_pkey`: `PRIMARY KEY (id)`
- `circle_members_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `circle_members_id_family_id_key`: `CREATE UNIQUE INDEX circle_members_id_family_id_key ON app.circle_members USING btree (id, family_id)`
- `circle_members_pkey`: `CREATE UNIQUE INDEX circle_members_pkey ON app.circle_members USING btree (id)`
- `circle_members_user_id_idx`: `CREATE INDEX circle_members_user_id_idx ON app.circle_members USING btree (user_id) WHERE ((status = ANY (ARRAY['ACTIVE'::app.circle_status, 'PAUSED'::app.circle_status, 'SUSPENDED_PLAN'::app.circle_status])) AND (deleted_at IS NULL))`
- `uq_circle_member`: `CREATE UNIQUE INDEX uq_circle_member ON app.circle_members USING btree (family_id, user_id) WHERE ((status = ANY (ARRAY['ACTIVE'::app.circle_status, 'PAUSED'::app.circle_status, 'SUSPENDED_PLAN'::app.circle_status])) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.circle_members FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.circle_members FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.comments — Comment

| Cột               | PostgreSQL type             | NOT NULL | Default                     |
| ----------------- | --------------------------- | -------- | --------------------------- |
| id                | uuid                        | Có       | uuidv7()                    |
| family_id         | uuid                        | Có       | —                           |
| memory_id         | uuid                        | Có       | —                           |
| author_user_id    | uuid                        | Có       | —                           |
| parent_comment_id | uuid                        | Không    | —                           |
| body              | character varying(1000)     | Có       | —                           |
| status            | character varying(10)       | Có       | 'ACTIVE'::character varying |
| created_at        | timestamp(3) with time zone | Có       | now()                       |
| edited_at         | timestamp(3) with time zone | Không    | —                           |
| deleted_at        | timestamp(3) with time zone | Không    | —                           |
| updated_at        | timestamp(3) with time zone | Có       | now()                       |

Constraints:

- `comments_check`: `CHECK (((parent_comment_id IS NULL) OR (parent_comment_id <> id)))`
- `comments_author_user_id_fkey`: `FOREIGN KEY (author_user_id) REFERENCES app.users(id)`
- `comments_memory_id_family_id_fkey`: `FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE`
- `comments_parent_comment_id_memory_id_family_id_fkey`: `FOREIGN KEY (parent_comment_id, memory_id, family_id) REFERENCES app.comments(id, memory_id, family_id)`
- `comments_author_user_id_not_null`: `NOT NULL author_user_id`
- `comments_body_not_null`: `NOT NULL body`
- `comments_created_at_not_null`: `NOT NULL created_at`
- `comments_family_id_not_null`: `NOT NULL family_id`
- `comments_id_not_null`: `NOT NULL id`
- `comments_memory_id_not_null`: `NOT NULL memory_id`
- `comments_status_not_null`: `NOT NULL status`
- `comments_updated_at_not_null`: `NOT NULL updated_at`
- `comments_pkey`: `PRIMARY KEY (id)`
- `comments_id_family_id_key`: `UNIQUE (id, family_id)`
- `comments_id_memory_id_family_id_key`: `UNIQUE (id, memory_id, family_id)`

Indexes:

- `comments_id_family_id_key`: `CREATE UNIQUE INDEX comments_id_family_id_key ON app.comments USING btree (id, family_id)`
- `comments_id_memory_id_family_id_key`: `CREATE UNIQUE INDEX comments_id_memory_id_family_id_key ON app.comments USING btree (id, memory_id, family_id)`
- `comments_memory_id_created_at_idx`: `CREATE INDEX comments_memory_id_created_at_idx ON app.comments USING btree (memory_id, created_at)`
- `comments_pkey`: `CREATE UNIQUE INDEX comments_pkey ON app.comments USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.comments FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.comments FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.couple_spaces — CoupleSpace

| Cột                    | PostgreSQL type             | NOT NULL | Default                        |
| ---------------------- | --------------------------- | -------- | ------------------------------ |
| id                     | uuid                        | Có       | uuidv7()                       |
| family_id              | uuid                        | Có       | —                              |
| parent_a_user_id       | uuid                        | Có       | —                              |
| parent_b_user_id       | uuid                        | Có       | —                              |
| status                 | app.couple_status           | Có       | 'ACTIVE'::app.couple_status    |
| key_id                 | uuid                        | Không    | —                              |
| created_at             | timestamp(3) with time zone | Có       | now()                          |
| disabled_at            | timestamp(3) with time zone | Không    | —                              |
| updated_at             | timestamp(3) with time zone | Có       | now()                          |
| deleted_at             | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| pair_version           | integer                     | Có       | 1                              |
| updated_by             | uuid                        | Không    | —                              |
| parent_a_membership_id | uuid                        | Có       | —                              |
| parent_b_membership_id | uuid                        | Có       | —                              |

Constraints:

- `couple_spaces_check`: `CHECK ((parent_a_user_id <> parent_b_user_id))`
- `couple_spaces_check1`: `CHECK ((parent_a_membership_id <> parent_b_membership_id))`
- `couple_spaces_pair_version_check`: `CHECK ((pair_version > 0))`
- `couple_spaces_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `couple_spaces_key_id_id_fkey`: `FOREIGN KEY (key_id, id) REFERENCES us.data_keys(id, couple_space_id) DEFERRABLE INITIALLY DEFERRED`
- `couple_spaces_parent_a_membership_id_family_id_parent_a_us_fkey`: `FOREIGN KEY (parent_a_membership_id, family_id, parent_a_user_id) REFERENCES app.family_parents(id, family_id, user_id)`
- `couple_spaces_parent_a_user_id_fkey`: `FOREIGN KEY (parent_a_user_id) REFERENCES app.users(id)`
- `couple_spaces_parent_b_membership_id_family_id_parent_b_us_fkey`: `FOREIGN KEY (parent_b_membership_id, family_id, parent_b_user_id) REFERENCES app.family_parents(id, family_id, user_id)`
- `couple_spaces_parent_b_user_id_fkey`: `FOREIGN KEY (parent_b_user_id) REFERENCES app.users(id)`
- `couple_spaces_updated_by_fkey`: `FOREIGN KEY (updated_by) REFERENCES app.users(id)`
- `couple_spaces_created_at_not_null`: `NOT NULL created_at`
- `couple_spaces_family_id_not_null`: `NOT NULL family_id`
- `couple_spaces_id_not_null`: `NOT NULL id`
- `couple_spaces_pair_version_not_null`: `NOT NULL pair_version`
- `couple_spaces_parent_a_membership_id_not_null`: `NOT NULL parent_a_membership_id`
- `couple_spaces_parent_a_user_id_not_null`: `NOT NULL parent_a_user_id`
- `couple_spaces_parent_b_membership_id_not_null`: `NOT NULL parent_b_membership_id`
- `couple_spaces_parent_b_user_id_not_null`: `NOT NULL parent_b_user_id`
- `couple_spaces_status_not_null`: `NOT NULL status`
- `couple_spaces_updated_at_not_null`: `NOT NULL updated_at`
- `couple_spaces_pkey`: `PRIMARY KEY (id)`
- `couple_spaces_family_id_pair_version_key`: `UNIQUE (family_id, pair_version)`
- `couple_spaces_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `couple_spaces_family_id_pair_version_key`: `CREATE UNIQUE INDEX couple_spaces_family_id_pair_version_key ON app.couple_spaces USING btree (family_id, pair_version)`
- `couple_spaces_id_family_id_key`: `CREATE UNIQUE INDEX couple_spaces_id_family_id_key ON app.couple_spaces USING btree (id, family_id)`
- `couple_spaces_pkey`: `CREATE UNIQUE INDEX couple_spaces_pkey ON app.couple_spaces USING btree (id)`
- `uq_couple_active`: `CREATE UNIQUE INDEX uq_couple_active ON app.couple_spaces USING btree (family_id) WHERE ((status = 'ACTIVE'::app.couple_status) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.couple_spaces FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.couple_spaces FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_immutable_pair`: `CREATE TRIGGER trg_immutable_pair BEFORE UPDATE ON app.couple_spaces FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('parent_a_user_id', 'parent_b_user_id', 'parent_a_membership_id', 'parent_b_membership_id', 'pair_version')`

## app.daily_mission_board_parents — DailyMissionBoardParent

| Cột          | PostgreSQL type             | NOT NULL | Default                        |
| ------------ | --------------------------- | -------- | ------------------------------ |
| family_id    | uuid                        | Có       | —                              |
| board_date   | date                        | Có       | —                              |
| user_id      | uuid                        | Có       | —                              |
| quota_count  | smallint                    | Có       | —                              |
| hearts_total | smallint                    | Có       | —                              |
| swaps_used   | smallint                    | Có       | 0                              |
| created_at   | timestamp(3) with time zone | Có       | now()                          |
| updated_at   | timestamp(3) with time zone | Có       | now()                          |
| deleted_at   | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `daily_mission_board_parents_swaps_used_check`: `CHECK (((swaps_used >= 0) AND (swaps_used <= 3)))`
- `daily_mission_board_parents_family_id_board_date_fkey`: `FOREIGN KEY (family_id, board_date) REFERENCES app.daily_mission_boards(family_id, board_date) ON DELETE CASCADE`
- `daily_mission_board_parents_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `daily_mission_board_parents_board_date_not_null`: `NOT NULL board_date`
- `daily_mission_board_parents_created_at_not_null`: `NOT NULL created_at`
- `daily_mission_board_parents_family_id_not_null`: `NOT NULL family_id`
- `daily_mission_board_parents_hearts_total_not_null`: `NOT NULL hearts_total`
- `daily_mission_board_parents_quota_count_not_null`: `NOT NULL quota_count`
- `daily_mission_board_parents_swaps_used_not_null`: `NOT NULL swaps_used`
- `daily_mission_board_parents_updated_at_not_null`: `NOT NULL updated_at`
- `daily_mission_board_parents_user_id_not_null`: `NOT NULL user_id`
- `daily_mission_board_parents_pkey`: `PRIMARY KEY (family_id, board_date, user_id)`

Indexes:

- `daily_mission_board_parents_pkey`: `CREATE UNIQUE INDEX daily_mission_board_parents_pkey ON app.daily_mission_board_parents USING btree (family_id, board_date, user_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.daily_mission_board_parents FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.daily_mission_board_parents FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.daily_mission_boards — DailyMissionBoard

| Cột               | PostgreSQL type             | NOT NULL | Default                        |
| ----------------- | --------------------------- | -------- | ------------------------------ |
| family_id         | uuid                        | Có       | —                              |
| board_date        | date                        | Có       | —                              |
| level             | app.mission_board_level     | Có       | —                              |
| per_parent_count  | smallint                    | Có       | —                              |
| together_count    | smallint                    | Có       | —                              |
| balance_diff      | smallint                    | Có       | —                              |
| generator_version | smallint                    | Có       | —                              |
| seed              | bigint                      | Có       | —                              |
| generated_at      | timestamp(3) with time zone | Có       | now()                          |
| bloomed_at        | timestamp(3) with time zone | Không    | —                              |
| created_at        | timestamp(3) with time zone | Có       | now()                          |
| updated_at        | timestamp(3) with time zone | Có       | now()                          |
| deleted_at        | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `daily_mission_boards_balance_diff_check`: `CHECK (((balance_diff >= 0) AND (balance_diff <= 2)))`
- `daily_mission_boards_check`: `CHECK (((per_parent_count = ANY (ARRAY[2, 3, 4])) AND ((together_count >= 0) AND (together_count <= 1))))`
- `daily_mission_boards_generator_version_check`: `CHECK ((generator_version > 0))`
- `daily_mission_boards_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `daily_mission_boards_balance_diff_not_null`: `NOT NULL balance_diff`
- `daily_mission_boards_board_date_not_null`: `NOT NULL board_date`
- `daily_mission_boards_created_at_not_null`: `NOT NULL created_at`
- `daily_mission_boards_family_id_not_null`: `NOT NULL family_id`
- `daily_mission_boards_generated_at_not_null`: `NOT NULL generated_at`
- `daily_mission_boards_generator_version_not_null`: `NOT NULL generator_version`
- `daily_mission_boards_level_not_null`: `NOT NULL level`
- `daily_mission_boards_per_parent_count_not_null`: `NOT NULL per_parent_count`
- `daily_mission_boards_seed_not_null`: `NOT NULL seed`
- `daily_mission_boards_together_count_not_null`: `NOT NULL together_count`
- `daily_mission_boards_updated_at_not_null`: `NOT NULL updated_at`
- `daily_mission_boards_pkey`: `PRIMARY KEY (family_id, board_date)`

Indexes:

- `daily_mission_boards_pkey`: `CREATE UNIQUE INDEX daily_mission_boards_pkey ON app.daily_mission_boards USING btree (family_id, board_date)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.daily_mission_boards FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.daily_mission_boards FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.deletion_requests — DeletionRequest

| Cột                     | PostgreSQL type             | NOT NULL | Default                        |
| ----------------------- | --------------------------- | -------- | ------------------------------ |
| id                      | uuid                        | Có       | uuidv7()                       |
| user_id                 | uuid                        | Có       | —                              |
| source                  | character varying(10)       | Có       | —                              |
| family_choice           | character varying(20)       | Có       | —                              |
| shared_content_choice   | character varying(20)       | Có       | —                              |
| status                  | character varying(12)       | Có       | 'SCHEDULED'::character varying |
| requested_at            | timestamp(3) with time zone | Có       | now()                          |
| execute_after           | timestamp(3) with time zone | Có       | —                              |
| completed_at            | timestamp(3) with time zone | Không    | —                              |
| steps                   | jsonb                       | Có       | '{}'::jsonb                    |
| created_at              | timestamp(3) with time zone | Có       | now()                          |
| updated_at              | timestamp(3) with time zone | Có       | now()                          |
| deleted_at              | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| family_id               | uuid                        | Không    | —                              |
| requested_membership_id | uuid                        | Không    | —                              |
| cancelled_at            | timestamp(3) with time zone | Không    | —                              |
| failure_code            | character varying(80)       | Không    | —                              |

Constraints:

- `deletion_requests_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `deletion_requests_requested_membership_id_fkey`: `FOREIGN KEY (requested_membership_id) REFERENCES app.family_parents(id)`
- `deletion_requests_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `deletion_requests_created_at_not_null`: `NOT NULL created_at`
- `deletion_requests_execute_after_not_null`: `NOT NULL execute_after`
- `deletion_requests_family_choice_not_null`: `NOT NULL family_choice`
- `deletion_requests_id_not_null`: `NOT NULL id`
- `deletion_requests_requested_at_not_null`: `NOT NULL requested_at`
- `deletion_requests_shared_content_choice_not_null`: `NOT NULL shared_content_choice`
- `deletion_requests_source_not_null`: `NOT NULL source`
- `deletion_requests_status_not_null`: `NOT NULL status`
- `deletion_requests_steps_not_null`: `NOT NULL steps`
- `deletion_requests_updated_at_not_null`: `NOT NULL updated_at`
- `deletion_requests_user_id_not_null`: `NOT NULL user_id`
- `deletion_requests_pkey`: `PRIMARY KEY (id)`

Indexes:

- `deletion_requests_pkey`: `CREATE UNIQUE INDEX deletion_requests_pkey ON app.deletion_requests USING btree (id)`
- `uq_deletion_active`: `CREATE UNIQUE INDEX uq_deletion_active ON app.deletion_requests USING btree (user_id) WHERE (((status)::text = ANY ((ARRAY['SCHEDULED'::character varying, 'RUNNING'::character varying])::text[])) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.deletion_requests FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.deletion_requests FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.event_children — EventChild

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| event_id   | uuid                        | Có       | —                              |
| child_id   | uuid                        | Có       | —                              |
| family_id  | uuid                        | Có       | —                              |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `event_children_child_id_family_id_fkey`: `FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)`
- `event_children_event_id_family_id_fkey`: `FOREIGN KEY (event_id, family_id) REFERENCES app.events(id, family_id) ON DELETE CASCADE`
- `event_children_child_id_not_null`: `NOT NULL child_id`
- `event_children_created_at_not_null`: `NOT NULL created_at`
- `event_children_event_id_not_null`: `NOT NULL event_id`
- `event_children_family_id_not_null`: `NOT NULL family_id`
- `event_children_updated_at_not_null`: `NOT NULL updated_at`
- `event_children_pkey`: `PRIMARY KEY (event_id, child_id)`

Indexes:

- `event_children_pkey`: `CREATE UNIQUE INDEX event_children_pkey ON app.event_children USING btree (event_id, child_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.event_children FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.event_children FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.event_participants — EventParticipant

| Cột          | PostgreSQL type             | NOT NULL | Default                        |
| ------------ | --------------------------- | -------- | ------------------------------ |
| event_id     | uuid                        | Có       | —                              |
| family_id    | uuid                        | Có       | —                              |
| user_id      | uuid                        | Có       | —                              |
| response     | character varying(12)       | Có       | 'INVITED'::character varying   |
| responded_at | timestamp(3) with time zone | Không    | —                              |
| created_at   | timestamp(3) with time zone | Có       | now()                          |
| updated_at   | timestamp(3) with time zone | Có       | now()                          |
| deleted_at   | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `event_participants_response_check`: `CHECK (((response)::text = ANY ((ARRAY['INVITED'::character varying, 'ACCEPTED'::character varying, 'DECLINED'::character varying])::text[])))`
- `event_participants_event_id_family_id_fkey`: `FOREIGN KEY (event_id, family_id) REFERENCES app.events(id, family_id)`
- `event_participants_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `event_participants_created_at_not_null`: `NOT NULL created_at`
- `event_participants_event_id_not_null`: `NOT NULL event_id`
- `event_participants_family_id_not_null`: `NOT NULL family_id`
- `event_participants_response_not_null`: `NOT NULL response`
- `event_participants_updated_at_not_null`: `NOT NULL updated_at`
- `event_participants_user_id_not_null`: `NOT NULL user_id`
- `event_participants_pkey`: `PRIMARY KEY (event_id, user_id)`

Indexes:

- `event_participants_pkey`: `CREATE UNIQUE INDEX event_participants_pkey ON app.event_participants USING btree (event_id, user_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.event_participants FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.event_participants FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.event_reminder_rules — EventReminderRule

| Cột               | PostgreSQL type             | NOT NULL | Default                        |
| ----------------- | --------------------------- | -------- | ------------------------------ |
| id                | uuid                        | Có       | uuidv7()                       |
| event_id          | uuid                        | Có       | —                              |
| family_id         | uuid                        | Có       | —                              |
| recipient_user_id | uuid                        | Có       | —                              |
| offset_minutes    | integer                     | Có       | —                              |
| enabled           | boolean                     | Có       | true                           |
| created_at        | timestamp(3) with time zone | Có       | now()                          |
| updated_at        | timestamp(3) with time zone | Có       | now()                          |
| deleted_at        | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `event_reminder_rules_offset_minutes_check`: `CHECK ((offset_minutes >= 0))`
- `event_reminder_rules_event_id_family_id_fkey`: `FOREIGN KEY (event_id, family_id) REFERENCES app.events(id, family_id)`
- `event_reminder_rules_recipient_user_id_fkey`: `FOREIGN KEY (recipient_user_id) REFERENCES app.users(id)`
- `event_reminder_rules_created_at_not_null`: `NOT NULL created_at`
- `event_reminder_rules_enabled_not_null`: `NOT NULL enabled`
- `event_reminder_rules_event_id_not_null`: `NOT NULL event_id`
- `event_reminder_rules_family_id_not_null`: `NOT NULL family_id`
- `event_reminder_rules_id_not_null`: `NOT NULL id`
- `event_reminder_rules_offset_minutes_not_null`: `NOT NULL offset_minutes`
- `event_reminder_rules_recipient_user_id_not_null`: `NOT NULL recipient_user_id`
- `event_reminder_rules_updated_at_not_null`: `NOT NULL updated_at`
- `event_reminder_rules_pkey`: `PRIMARY KEY (id)`
- `event_reminder_rules_event_id_recipient_user_id_offset_minu_key`: `UNIQUE (event_id, recipient_user_id, offset_minutes)`

Indexes:

- `event_reminder_rules_event_id_recipient_user_id_offset_minu_key`: `CREATE UNIQUE INDEX event_reminder_rules_event_id_recipient_user_id_offset_minu_key ON app.event_reminder_rules USING btree (event_id, recipient_user_id, offset_minutes)`
- `event_reminder_rules_pkey`: `CREATE UNIQUE INDEX event_reminder_rules_pkey ON app.event_reminder_rules USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.event_reminder_rules FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.event_reminder_rules FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.event_reminders — EventReminder

| Cột               | PostgreSQL type             | NOT NULL | Default                        |
| ----------------- | --------------------------- | -------- | ------------------------------ |
| id                | uuid                        | Có       | uuidv7()                       |
| event_id          | uuid                        | Có       | —                              |
| family_id         | uuid                        | Có       | —                              |
| recipient_user_id | uuid                        | Có       | —                              |
| offset_minutes    | integer                     | Có       | —                              |
| occurrence_at     | timestamp(3) with time zone | Có       | —                              |
| due_at            | timestamp(3) with time zone | Có       | —                              |
| sent_at           | timestamp(3) with time zone | Không    | —                              |
| cancelled_at      | timestamp(3) with time zone | Không    | —                              |
| created_at        | timestamp(3) with time zone | Có       | now()                          |
| updated_at        | timestamp(3) with time zone | Có       | now()                          |
| deleted_at        | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `event_reminders_offset_minutes_check`: `CHECK ((offset_minutes >= 0))`
- `event_reminders_event_id_family_id_fkey`: `FOREIGN KEY (event_id, family_id) REFERENCES app.events(id, family_id)`
- `event_reminders_recipient_user_id_fkey`: `FOREIGN KEY (recipient_user_id) REFERENCES app.users(id)`
- `event_reminders_created_at_not_null`: `NOT NULL created_at`
- `event_reminders_due_at_not_null`: `NOT NULL due_at`
- `event_reminders_event_id_not_null`: `NOT NULL event_id`
- `event_reminders_family_id_not_null`: `NOT NULL family_id`
- `event_reminders_id_not_null`: `NOT NULL id`
- `event_reminders_occurrence_at_not_null`: `NOT NULL occurrence_at`
- `event_reminders_offset_minutes_not_null`: `NOT NULL offset_minutes`
- `event_reminders_recipient_user_id_not_null`: `NOT NULL recipient_user_id`
- `event_reminders_updated_at_not_null`: `NOT NULL updated_at`
- `event_reminders_pkey`: `PRIMARY KEY (id)`
- `event_reminders_event_id_recipient_user_id_occurrence_at_of_key`: `UNIQUE (event_id, recipient_user_id, occurrence_at, offset_minutes)`

Indexes:

- `event_reminders_event_id_recipient_user_id_occurrence_at_of_key`: `CREATE UNIQUE INDEX event_reminders_event_id_recipient_user_id_occurrence_at_of_key ON app.event_reminders USING btree (event_id, recipient_user_id, occurrence_at, offset_minutes)`
- `event_reminders_pkey`: `CREATE UNIQUE INDEX event_reminders_pkey ON app.event_reminders USING btree (id)`
- `ix_event_reminder_due`: `CREATE INDEX ix_event_reminder_due ON app.event_reminders USING btree (due_at) WHERE ((sent_at IS NULL) AND (cancelled_at IS NULL) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.event_reminders FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.event_reminders FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.events — Event

| Cột              | PostgreSQL type             | NOT NULL | Default                               |
| ---------------- | --------------------------- | -------- | ------------------------------------- |
| id               | uuid                        | Có       | uuidv7()                              |
| family_id        | uuid                        | Có       | —                                     |
| type             | character varying(20)       | Có       | —                                     |
| title            | character varying(120)      | Có       | —                                     |
| notes            | text                        | Không    | —                                     |
| all_day          | boolean                     | Có       | true                                  |
| start_at         | timestamp(3) with time zone | Có       | —                                     |
| end_at           | timestamp(3) with time zone | Không    | —                                     |
| is_lunar         | boolean                     | Có       | false                                 |
| lunar_month      | smallint                    | Không    | —                                     |
| lunar_day        | smallint                    | Không    | —                                     |
| lunar_leap       | boolean                     | Không    | —                                     |
| repeat_yearly    | boolean                     | Có       | false                                 |
| invite_circle    | boolean                     | Có       | false                                 |
| created_by       | uuid                        | Có       | —                                     |
| created_at       | timestamp(3) with time zone | Có       | now()                                 |
| deleted_at       | timestamp(3) with time zone | Không    | —                                     |
| updated_at       | timestamp(3) with time zone | Có       | now()                                 |
| timezone         | character varying(64)       | Có       | 'Asia/Ho_Chi_Minh'::character varying |
| local_start_date | date                        | Có       | —                                     |
| local_end_date   | date                        | Không    | —                                     |
| rrule            | text                        | Không    | —                                     |
| version          | integer                     | Có       | 1                                     |

Constraints:

- `events_check`: `CHECK (((end_at IS NULL) OR (end_at >= start_at)))`
- `events_check1`: `CHECK (((local_end_date IS NULL) OR (local_end_date >= local_start_date)))`
- `events_check2`: `CHECK ((((type)::text <> ALL ((ARRAY['COUPLE'::character varying, 'NOTE'::character varying, 'MEMORY_REMINDER'::character varying])::text[])) OR (NOT invite_circle)))`
- `events_check3`: `CHECK (((NOT is_lunar) OR ((lunar_month IS NOT NULL) AND (lunar_day IS NOT NULL))))`
- `events_lunar_day_check`: `CHECK (((lunar_day IS NULL) OR ((lunar_day >= 1) AND (lunar_day <= 30))))`
- `events_lunar_month_check`: `CHECK (((lunar_month IS NULL) OR ((lunar_month >= 1) AND (lunar_month <= 12))))`
- `events_type_check`: `CHECK (((type)::text = ANY ((ARRAY['CHILD'::character varying, 'FAMILY'::character varying, 'COUPLE'::character varying, 'MEMORY_REMINDER'::character varying, 'NOTE'::character varying])::text[])))`
- `events_created_by_fkey`: `FOREIGN KEY (created_by) REFERENCES app.users(id)`
- `events_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `events_all_day_not_null`: `NOT NULL all_day`
- `events_created_at_not_null`: `NOT NULL created_at`
- `events_created_by_not_null`: `NOT NULL created_by`
- `events_family_id_not_null`: `NOT NULL family_id`
- `events_id_not_null`: `NOT NULL id`
- `events_invite_circle_not_null`: `NOT NULL invite_circle`
- `events_is_lunar_not_null`: `NOT NULL is_lunar`
- `events_local_start_date_not_null`: `NOT NULL local_start_date`
- `events_repeat_yearly_not_null`: `NOT NULL repeat_yearly`
- `events_start_at_not_null`: `NOT NULL start_at`
- `events_timezone_not_null`: `NOT NULL timezone`
- `events_title_not_null`: `NOT NULL title`
- `events_type_not_null`: `NOT NULL type`
- `events_updated_at_not_null`: `NOT NULL updated_at`
- `events_version_not_null`: `NOT NULL version`
- `events_pkey`: `PRIMARY KEY (id)`
- `events_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `events_id_family_id_key`: `CREATE UNIQUE INDEX events_id_family_id_key ON app.events USING btree (id, family_id)`
- `events_pkey`: `CREATE UNIQUE INDEX events_pkey ON app.events USING btree (id)`
- `ix_event_family_start`: `CREATE INDEX ix_event_family_start ON app.events USING btree (family_id, start_at, id) WHERE (deleted_at IS NULL)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.events FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.events FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.export_jobs — ExportJob

| Cột                 | PostgreSQL type             | NOT NULL | Default                        |
| ------------------- | --------------------------- | -------- | ------------------------------ |
| id                  | uuid                        | Có       | uuidv7()                       |
| requester_id        | uuid                        | Có       | —                              |
| family_id           | uuid                        | Không    | —                              |
| scope               | character varying(10)       | Có       | —                              |
| status              | character varying(12)       | Có       | 'QUEUED'::character varying    |
| storage_key         | text                        | Không    | —                              |
| size_bytes          | bigint                      | Không    | —                              |
| expires_at          | timestamp(3) with time zone | Không    | —                              |
| created_at          | timestamp(3) with time zone | Có       | now()                          |
| completed_at        | timestamp(3) with time zone | Không    | —                              |
| updated_at          | timestamp(3) with time zone | Có       | now()                          |
| deleted_at          | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| access_snapshot     | jsonb                       | Có       | '{}'::jsonb                    |
| access_rechecked_at | timestamp(3) with time zone | Không    | —                              |
| error_code          | character varying(80)       | Không    | —                              |

Constraints:

- `export_jobs_scope_check`: `CHECK (((scope)::text = ANY ((ARRAY['FAMILY'::character varying, 'PERSONAL'::character varying])::text[])))`
- `export_jobs_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `export_jobs_requester_id_fkey`: `FOREIGN KEY (requester_id) REFERENCES app.users(id)`
- `export_jobs_access_snapshot_not_null`: `NOT NULL access_snapshot`
- `export_jobs_created_at_not_null`: `NOT NULL created_at`
- `export_jobs_id_not_null`: `NOT NULL id`
- `export_jobs_requester_id_not_null`: `NOT NULL requester_id`
- `export_jobs_scope_not_null`: `NOT NULL scope`
- `export_jobs_status_not_null`: `NOT NULL status`
- `export_jobs_updated_at_not_null`: `NOT NULL updated_at`
- `export_jobs_pkey`: `PRIMARY KEY (id)`

Indexes:

- `export_jobs_pkey`: `CREATE UNIQUE INDEX export_jobs_pkey ON app.export_jobs USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.export_jobs FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.export_jobs FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.families — Family

| Cột                   | PostgreSQL type             | NOT NULL | Default                                                                                                                                                                     |
| --------------------- | --------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id                    | uuid                        | Có       | uuidv7()                                                                                                                                                                    |
| name                  | character varying(80)       | Có       | —                                                                                                                                                                           |
| cover_asset_id        | uuid                        | Không    | —                                                                                                                                                                           |
| status                | app.family_status           | Có       | 'WAITING_PARTNER'::app.family_status                                                                                                                                        |
| activated_at          | timestamp(3) with time zone | Không    | —                                                                                                                                                                           |
| timezone              | character varying(64)       | Có       | 'Asia/Ho_Chi_Minh'::character varying                                                                                                                                       |
| content_locale        | character varying(10)       | Có       | 'vi'::character varying                                                                                                                                                     |
| settings              | jsonb                       | Có       | '{"showLunar": true, "circleCanSeeTree": false, "defaultVisibility": null, "requireCircleReview": true, "traditionalUseLunar": false, "milestoneSuggestions": true}'::jsonb |
| access_version        | integer                     | Có       | 1                                                                                                                                                                           |
| created_by            | uuid                        | Có       | —                                                                                                                                                                           |
| created_at            | timestamp(3) with time zone | Có       | now()                                                                                                                                                                       |
| updated_at            | timestamp(3) with time zone | Có       | now()                                                                                                                                                                       |
| deletion_scheduled_at | timestamp(3) with time zone | Không    | —                                                                                                                                                                           |
| deleted_at            | timestamp(3) with time zone | Không    | —                                                                                                                                                                           |

Constraints:

- `families_cover_asset_id_id_fkey`: `FOREIGN KEY (cover_asset_id, id) REFERENCES app.assets(id, family_id)`
- `families_created_by_fkey`: `FOREIGN KEY (created_by) REFERENCES app.users(id)`
- `families_access_version_not_null`: `NOT NULL access_version`
- `families_content_locale_not_null`: `NOT NULL content_locale`
- `families_created_at_not_null`: `NOT NULL created_at`
- `families_created_by_not_null`: `NOT NULL created_by`
- `families_id_not_null`: `NOT NULL id`
- `families_name_not_null`: `NOT NULL name`
- `families_settings_not_null`: `NOT NULL settings`
- `families_status_not_null`: `NOT NULL status`
- `families_timezone_not_null`: `NOT NULL timezone`
- `families_updated_at_not_null`: `NOT NULL updated_at`
- `families_pkey`: `PRIMARY KEY (id)`

Indexes:

- `families_pkey`: `CREATE UNIQUE INDEX families_pkey ON app.families USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.families FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## app.family_badges — FamilyBadge

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| id              | bigint                      | Có       | —                              |
| family_id       | uuid                        | Có       | —                              |
| badge_code      | character varying(30)       | Có       | —                              |
| subject_user_id | uuid                        | Không    | —                              |
| achieved_at     | timestamp(3) with time zone | Có       | now()                          |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `family_badges_badge_code_fkey`: `FOREIGN KEY (badge_code) REFERENCES app.badges(code)`
- `family_badges_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `family_badges_subject_user_id_fkey`: `FOREIGN KEY (subject_user_id) REFERENCES app.users(id)`
- `family_badges_achieved_at_not_null`: `NOT NULL achieved_at`
- `family_badges_badge_code_not_null`: `NOT NULL badge_code`
- `family_badges_created_at_not_null`: `NOT NULL created_at`
- `family_badges_family_id_not_null`: `NOT NULL family_id`
- `family_badges_id_not_null`: `NOT NULL id`
- `family_badges_updated_at_not_null`: `NOT NULL updated_at`
- `family_badges_pkey`: `PRIMARY KEY (id)`
- `family_badges_family_id_badge_code_subject_user_id_key`: `UNIQUE NULLS NOT DISTINCT (family_id, badge_code, subject_user_id)`

Indexes:

- `family_badges_family_id_badge_code_subject_user_id_key`: `CREATE UNIQUE INDEX family_badges_family_id_badge_code_subject_user_id_key ON app.family_badges USING btree (family_id, badge_code, subject_user_id) NULLS NOT DISTINCT`
- `family_badges_pkey`: `CREATE UNIQUE INDEX family_badges_pkey ON app.family_badges USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.family_badges FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.family_badges FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.family_deletion_approvals — FamilyDeletionApproval

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| request_id      | uuid                        | Có       | —                              |
| family_id       | uuid                        | Có       | —                              |
| user_id         | uuid                        | Có       | —                              |
| request_version | integer                     | Có       | —                              |
| decision        | character varying(10)       | Có       | —                              |
| decided_at      | timestamp(3) with time zone | Có       | now()                          |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `family_deletion_approvals_decision_check`: `CHECK (((decision)::text = ANY ((ARRAY['APPROVED'::character varying, 'DECLINED'::character varying])::text[])))`
- `family_deletion_approvals_request_id_family_id_fkey`: `FOREIGN KEY (request_id, family_id) REFERENCES app.family_deletion_requests(id, family_id)`
- `family_deletion_approvals_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `family_deletion_approvals_created_at_not_null`: `NOT NULL created_at`
- `family_deletion_approvals_decided_at_not_null`: `NOT NULL decided_at`
- `family_deletion_approvals_decision_not_null`: `NOT NULL decision`
- `family_deletion_approvals_family_id_not_null`: `NOT NULL family_id`
- `family_deletion_approvals_request_id_not_null`: `NOT NULL request_id`
- `family_deletion_approvals_request_version_not_null`: `NOT NULL request_version`
- `family_deletion_approvals_updated_at_not_null`: `NOT NULL updated_at`
- `family_deletion_approvals_user_id_not_null`: `NOT NULL user_id`
- `family_deletion_approvals_pkey`: `PRIMARY KEY (request_id, user_id, request_version)`

Indexes:

- `family_deletion_approvals_pkey`: `CREATE UNIQUE INDEX family_deletion_approvals_pkey ON app.family_deletion_approvals USING btree (request_id, user_id, request_version)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.family_deletion_approvals FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.family_deletion_approvals FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.family_deletion_requests — FamilyDeletionRequest

| Cột             | PostgreSQL type             | NOT NULL | Default                               |
| --------------- | --------------------------- | -------- | ------------------------------------- |
| id              | uuid                        | Có       | uuidv7()                              |
| family_id       | uuid                        | Có       | —                                     |
| requested_by    | uuid                        | Có       | —                                     |
| status          | character varying(24)       | Có       | 'PENDING_APPROVAL'::character varying |
| request_version | integer                     | Có       | 1                                     |
| execute_after   | timestamp(3) with time zone | Không    | —                                     |
| cancelled_at    | timestamp(3) with time zone | Không    | —                                     |
| completed_at    | timestamp(3) with time zone | Không    | —                                     |
| steps           | jsonb                       | Có       | '{}'::jsonb                           |
| reason_code     | character varying(80)       | Không    | —                                     |
| created_at      | timestamp(3) with time zone | Có       | now()                                 |
| updated_at      | timestamp(3) with time zone | Có       | now()                                 |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone        |

Constraints:

- `family_deletion_requests_request_version_check`: `CHECK ((request_version > 0))`
- `family_deletion_requests_status_check`: `CHECK (((status)::text = ANY ((ARRAY['PENDING_APPROVAL'::character varying, 'SCHEDULED'::character varying, 'RUNNING'::character varying, 'CANCELLED'::character varying, 'COMPLETED'::character varying, 'FAILED'::character varying])::text[])))`
- `family_deletion_requests_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `family_deletion_requests_requested_by_fkey`: `FOREIGN KEY (requested_by) REFERENCES app.users(id)`
- `family_deletion_requests_created_at_not_null`: `NOT NULL created_at`
- `family_deletion_requests_family_id_not_null`: `NOT NULL family_id`
- `family_deletion_requests_id_not_null`: `NOT NULL id`
- `family_deletion_requests_request_version_not_null`: `NOT NULL request_version`
- `family_deletion_requests_requested_by_not_null`: `NOT NULL requested_by`
- `family_deletion_requests_status_not_null`: `NOT NULL status`
- `family_deletion_requests_steps_not_null`: `NOT NULL steps`
- `family_deletion_requests_updated_at_not_null`: `NOT NULL updated_at`
- `family_deletion_requests_pkey`: `PRIMARY KEY (id)`
- `family_deletion_requests_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `family_deletion_requests_id_family_id_key`: `CREATE UNIQUE INDEX family_deletion_requests_id_family_id_key ON app.family_deletion_requests USING btree (id, family_id)`
- `family_deletion_requests_pkey`: `CREATE UNIQUE INDEX family_deletion_requests_pkey ON app.family_deletion_requests USING btree (id)`
- `uq_family_deletion_active`: `CREATE UNIQUE INDEX uq_family_deletion_active ON app.family_deletion_requests USING btree (family_id) WHERE (((status)::text = ANY ((ARRAY['PENDING_APPROVAL'::character varying, 'SCHEDULED'::character varying, 'RUNNING'::character varying])::text[])) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.family_deletion_requests FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.family_deletion_requests FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.family_invites — FamilyInvite

| Cột                    | PostgreSQL type             | NOT NULL | Default                        |
| ---------------------- | --------------------------- | -------- | ------------------------------ |
| id                     | uuid                        | Có       | uuidv7()                       |
| family_id              | uuid                        | Có       | —                              |
| type                   | app.invite_type             | Có       | —                              |
| inviter_user_id        | uuid                        | Có       | —                              |
| token_hash             | bytea                       | Có       | —                              |
| code_hash              | bytea                       | Có       | —                              |
| payload                | jsonb                       | Có       | —                              |
| require_final_approval | boolean                     | Có       | true                           |
| status                 | app.invite_status           | Có       | 'PENDING'::app.invite_status   |
| expires_at             | timestamp(3) with time zone | Có       | —                              |
| accepted_by_user_id    | uuid                        | Không    | —                              |
| accepted_at            | timestamp(3) with time zone | Không    | —                              |
| decided_at             | timestamp(3) with time zone | Không    | —                              |
| created_at             | timestamp(3) with time zone | Có       | now()                          |
| updated_at             | timestamp(3) with time zone | Có       | now()                          |
| deleted_at             | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| client_request_key     | uuid                        | Không    | —                              |

Constraints:

- `family_invites_accepted_by_user_id_fkey`: `FOREIGN KEY (accepted_by_user_id) REFERENCES app.users(id)`
- `family_invites_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `family_invites_inviter_user_id_fkey`: `FOREIGN KEY (inviter_user_id) REFERENCES app.users(id)`
- `family_invites_code_hash_not_null`: `NOT NULL code_hash`
- `family_invites_created_at_not_null`: `NOT NULL created_at`
- `family_invites_expires_at_not_null`: `NOT NULL expires_at`
- `family_invites_family_id_not_null`: `NOT NULL family_id`
- `family_invites_id_not_null`: `NOT NULL id`
- `family_invites_inviter_user_id_not_null`: `NOT NULL inviter_user_id`
- `family_invites_payload_not_null`: `NOT NULL payload`
- `family_invites_require_final_approval_not_null`: `NOT NULL require_final_approval`
- `family_invites_status_not_null`: `NOT NULL status`
- `family_invites_token_hash_not_null`: `NOT NULL token_hash`
- `family_invites_type_not_null`: `NOT NULL type`
- `family_invites_updated_at_not_null`: `NOT NULL updated_at`
- `family_invites_pkey`: `PRIMARY KEY (id)`
- `family_invites_code_hash_key`: `UNIQUE (code_hash)`
- `family_invites_family_id_client_request_key_key`: `UNIQUE (family_id, client_request_key)`
- `family_invites_token_hash_key`: `UNIQUE (token_hash)`

Indexes:

- `family_invites_code_hash_key`: `CREATE UNIQUE INDEX family_invites_code_hash_key ON app.family_invites USING btree (code_hash)`
- `family_invites_family_id_client_request_key_key`: `CREATE UNIQUE INDEX family_invites_family_id_client_request_key_key ON app.family_invites USING btree (family_id, client_request_key)`
- `family_invites_family_id_status_idx`: `CREATE INDEX family_invites_family_id_status_idx ON app.family_invites USING btree (family_id, status)`
- `family_invites_pkey`: `CREATE UNIQUE INDEX family_invites_pkey ON app.family_invites USING btree (id)`
- `family_invites_token_hash_key`: `CREATE UNIQUE INDEX family_invites_token_hash_key ON app.family_invites USING btree (token_hash)`
- `uq_partner_invite_pending`: `CREATE UNIQUE INDEX uq_partner_invite_pending ON app.family_invites USING btree (family_id) WHERE ((type = 'PARTNER'::app.invite_type) AND (status = ANY (ARRAY['PENDING'::app.invite_status, 'AWAITING_APPROVAL'::app.invite_status])) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.family_invites FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.family_invites FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.family_parents — FamilyParent

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| id         | uuid                        | Có       | uuidv7()                       |
| family_id  | uuid                        | Có       | —                              |
| user_id    | uuid                        | Có       | —                              |
| slot       | app.parent_slot             | Có       | —                              |
| kind       | app.parent_kind             | Có       | —                              |
| call_name  | character varying(20)       | Có       | —                              |
| status     | app.member_status           | Có       | 'ACTIVE'::app.member_status    |
| joined_at  | timestamp(3) with time zone | Có       | now()                          |
| left_at    | timestamp(3) with time zone | Không    | —                              |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `family_parents_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `family_parents_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `family_parents_call_name_not_null`: `NOT NULL call_name`
- `family_parents_created_at_not_null`: `NOT NULL created_at`
- `family_parents_family_id_not_null`: `NOT NULL family_id`
- `family_parents_id_not_null`: `NOT NULL id`
- `family_parents_joined_at_not_null`: `NOT NULL joined_at`
- `family_parents_kind_not_null`: `NOT NULL kind`
- `family_parents_slot_not_null`: `NOT NULL slot`
- `family_parents_status_not_null`: `NOT NULL status`
- `family_parents_updated_at_not_null`: `NOT NULL updated_at`
- `family_parents_user_id_not_null`: `NOT NULL user_id`
- `family_parents_pkey`: `PRIMARY KEY (id)`
- `family_parents_id_family_id_user_id_key`: `UNIQUE (id, family_id, user_id)`

Indexes:

- `family_parents_id_family_id_user_id_key`: `CREATE UNIQUE INDEX family_parents_id_family_id_user_id_key ON app.family_parents USING btree (id, family_id, user_id)`
- `family_parents_pkey`: `CREATE UNIQUE INDEX family_parents_pkey ON app.family_parents USING btree (id)`
- `ix_family_parent_history`: `CREATE INDEX ix_family_parent_history ON app.family_parents USING btree (family_id, user_id, joined_at DESC)`
- `uq_family_parent_slot`: `CREATE UNIQUE INDEX uq_family_parent_slot ON app.family_parents USING btree (family_id, slot) WHERE ((status = 'ACTIVE'::app.member_status) AND (deleted_at IS NULL))`
- `uq_family_parent_user`: `CREATE UNIQUE INDEX uq_family_parent_user ON app.family_parents USING btree (family_id, user_id) WHERE ((status = 'ACTIVE'::app.member_status) AND (deleted_at IS NULL))`
- `uq_parent_one_family`: `CREATE UNIQUE INDEX uq_parent_one_family ON app.family_parents USING btree (user_id) WHERE ((status = 'ACTIVE'::app.member_status) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.family_parents FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.family_parents FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.family_trees — FamilyTree

| Cột          | PostgreSQL type             | NOT NULL | Default                        |
| ------------ | --------------------------- | -------- | ------------------------------ |
| family_id    | uuid                        | Có       | —                              |
| total_hearts | integer                     | Có       | 0                              |
| level        | smallint                    | Có       | 1                              |
| fruits       | smallint                    | Có       | 0                              |
| flowers      | integer                     | Có       | 0                              |
| updated_at   | timestamp(3) with time zone | Có       | now()                          |
| version      | integer                     | Có       | 1                              |
| created_at   | timestamp(3) with time zone | Có       | now()                          |
| deleted_at   | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `family_trees_check`: `CHECK ((((level >= 1) AND (level <= 7)) AND (fruits >= 0) AND (flowers >= 0)))`
- `family_trees_total_hearts_check`: `CHECK ((total_hearts >= 0))`
- `family_trees_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `family_trees_created_at_not_null`: `NOT NULL created_at`
- `family_trees_family_id_not_null`: `NOT NULL family_id`
- `family_trees_flowers_not_null`: `NOT NULL flowers`
- `family_trees_fruits_not_null`: `NOT NULL fruits`
- `family_trees_level_not_null`: `NOT NULL level`
- `family_trees_total_hearts_not_null`: `NOT NULL total_hearts`
- `family_trees_updated_at_not_null`: `NOT NULL updated_at`
- `family_trees_version_not_null`: `NOT NULL version`
- `family_trees_pkey`: `PRIMARY KEY (family_id)`

Indexes:

- `family_trees_pkey`: `CREATE UNIQUE INDEX family_trees_pkey ON app.family_trees USING btree (family_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.family_trees FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.family_trees FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.favorites — Favorite

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| user_id    | uuid                        | Có       | —                              |
| memory_id  | uuid                        | Có       | —                              |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| family_id  | uuid                        | Có       | —                              |

Constraints:

- `favorites_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `favorites_memory_id_family_id_fkey`: `FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id)`
- `favorites_memory_id_fkey`: `FOREIGN KEY (memory_id) REFERENCES app.memories(id) ON DELETE CASCADE`
- `favorites_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `favorites_created_at_not_null`: `NOT NULL created_at`
- `favorites_family_id_not_null`: `NOT NULL family_id`
- `favorites_memory_id_not_null`: `NOT NULL memory_id`
- `favorites_updated_at_not_null`: `NOT NULL updated_at`
- `favorites_user_id_not_null`: `NOT NULL user_id`
- `favorites_pkey`: `PRIMARY KEY (user_id, memory_id)`

Indexes:

- `favorites_memory_id_idx`: `CREATE INDEX favorites_memory_id_idx ON app.favorites USING btree (memory_id)`
- `favorites_pkey`: `CREATE UNIQUE INDEX favorites_pkey ON app.favorites USING btree (user_id, memory_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.favorites FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.favorites FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.heart_daily_counters — HeartDailyCounter

| Cột          | PostgreSQL type             | NOT NULL | Default                        |
| ------------ | --------------------------- | -------- | ------------------------------ |
| family_id    | uuid                        | Có       | —                              |
| user_id      | uuid                        | Có       | —                              |
| local_date   | date                        | Có       | —                              |
| total        | smallint                    | Có       | 0                              |
| custom_count | smallint                    | Có       | 0                              |
| photo_count  | smallint                    | Có       | 0                              |
| memory_count | smallint                    | Có       | 0                              |
| thanks_count | smallint                    | Có       | 0                              |
| created_at   | timestamp(3) with time zone | Có       | now()                          |
| updated_at   | timestamp(3) with time zone | Có       | now()                          |
| deleted_at   | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `heart_daily_counters_check`: `CHECK (((custom_count >= 0) AND (photo_count >= 0) AND (memory_count >= 0) AND (thanks_count >= 0)))`
- `heart_daily_counters_total_check`: `CHECK ((total >= 0))`
- `heart_daily_counters_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `heart_daily_counters_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `heart_daily_counters_created_at_not_null`: `NOT NULL created_at`
- `heart_daily_counters_custom_count_not_null`: `NOT NULL custom_count`
- `heart_daily_counters_family_id_not_null`: `NOT NULL family_id`
- `heart_daily_counters_local_date_not_null`: `NOT NULL local_date`
- `heart_daily_counters_memory_count_not_null`: `NOT NULL memory_count`
- `heart_daily_counters_photo_count_not_null`: `NOT NULL photo_count`
- `heart_daily_counters_thanks_count_not_null`: `NOT NULL thanks_count`
- `heart_daily_counters_total_not_null`: `NOT NULL total`
- `heart_daily_counters_updated_at_not_null`: `NOT NULL updated_at`
- `heart_daily_counters_user_id_not_null`: `NOT NULL user_id`
- `heart_daily_counters_pkey`: `PRIMARY KEY (user_id, local_date)`

Indexes:

- `heart_daily_counters_pkey`: `CREATE UNIQUE INDEX heart_daily_counters_pkey ON app.heart_daily_counters USING btree (user_id, local_date)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.heart_daily_counters FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.heart_daily_counters FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.heart_ledger — HeartLedger

| Cột         | PostgreSQL type             | NOT NULL | Default                        |
| ----------- | --------------------------- | -------- | ------------------------------ |
| id          | bigint                      | Có       | —                              |
| family_id   | uuid                        | Có       | —                              |
| user_id     | uuid                        | Có       | —                              |
| source_type | character varying(20)       | Có       | —                              |
| source_id   | uuid                        | Có       | —                              |
| reason      | character varying(30)       | Có       | —                              |
| amount      | smallint                    | Có       | —                              |
| reversal_of | bigint                      | Không    | —                              |
| local_date  | date                        | Có       | —                              |
| created_at  | timestamp(3) with time zone | Có       | now()                          |
| updated_at  | timestamp(3) with time zone | Có       | now()                          |
| deleted_at  | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `heart_ledger_check`: `CHECK ((((reason)::text = 'REVERSAL'::text) = (reversal_of IS NOT NULL)))`
- `heart_ledger_check1`: `CHECK (((((reason)::text = 'REVERSAL'::text) AND (amount < 0)) OR (((reason)::text <> 'REVERSAL'::text) AND (amount > 0))))`
- `heart_ledger_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `heart_ledger_reversal_of_family_id_user_id_fkey`: `FOREIGN KEY (reversal_of, family_id, user_id) REFERENCES app.heart_ledger(id, family_id, user_id)`
- `heart_ledger_reversal_of_fkey`: `FOREIGN KEY (reversal_of) REFERENCES app.heart_ledger(id)`
- `heart_ledger_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `heart_ledger_amount_not_null`: `NOT NULL amount`
- `heart_ledger_created_at_not_null`: `NOT NULL created_at`
- `heart_ledger_family_id_not_null`: `NOT NULL family_id`
- `heart_ledger_id_not_null`: `NOT NULL id`
- `heart_ledger_local_date_not_null`: `NOT NULL local_date`
- `heart_ledger_reason_not_null`: `NOT NULL reason`
- `heart_ledger_source_id_not_null`: `NOT NULL source_id`
- `heart_ledger_source_type_not_null`: `NOT NULL source_type`
- `heart_ledger_updated_at_not_null`: `NOT NULL updated_at`
- `heart_ledger_user_id_not_null`: `NOT NULL user_id`
- `heart_ledger_pkey`: `PRIMARY KEY (id)`
- `heart_ledger_id_family_id_user_id_key`: `UNIQUE (id, family_id, user_id)`

Indexes:

- `heart_ledger_family_id_created_at_idx`: `CREATE INDEX heart_ledger_family_id_created_at_idx ON app.heart_ledger USING btree (family_id, created_at)`
- `heart_ledger_id_family_id_user_id_key`: `CREATE UNIQUE INDEX heart_ledger_id_family_id_user_id_key ON app.heart_ledger USING btree (id, family_id, user_id)`
- `heart_ledger_pkey`: `CREATE UNIQUE INDEX heart_ledger_pkey ON app.heart_ledger USING btree (id)`
- `ix_heart_user_day`: `CREATE INDEX ix_heart_user_day ON app.heart_ledger USING btree (user_id, local_date DESC)`
- `uq_heart_once`: `CREATE UNIQUE INDEX uq_heart_once ON app.heart_ledger USING btree (user_id, source_type, source_id, reason) WHERE ((reversal_of IS NULL) AND (deleted_at IS NULL))`
- `uq_heart_reversal`: `CREATE UNIQUE INDEX uq_heart_reversal ON app.heart_ledger USING btree (reversal_of) WHERE ((reversal_of IS NOT NULL) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.heart_ledger FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_heart_immutable`: `CREATE TRIGGER trg_heart_immutable BEFORE UPDATE ON app.heart_ledger FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('user_id', 'source_type', 'source_id', 'reason', 'amount', 'reversal_of', 'local_date', 'deleted_at')`
- `trg_heart_no_delete`: `CREATE TRIGGER trg_heart_no_delete BEFORE DELETE ON app.heart_ledger FOR EACH ROW EXECUTE FUNCTION ops.deny_physical_delete()`
- `trg_heart_reversal`: `CREATE TRIGGER trg_heart_reversal BEFORE INSERT ON app.heart_ledger FOR EACH ROW EXECUTE FUNCTION app.check_heart_reversal()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.heart_ledger FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.memories — Memory

| Cột                 | PostgreSQL type             | NOT NULL | Default                    |
| ------------------- | --------------------------- | -------- | -------------------------- |
| id                  | uuid                        | Có       | uuidv7()                   |
| family_id           | uuid                        | Có       | —                          |
| author_user_id      | uuid                        | Có       | —                          |
| author_role         | character varying(10)       | Có       | —                          |
| kind                | app.memory_kind             | Có       | 'MOMENT'::app.memory_kind  |
| title               | character varying(120)      | Không    | —                          |
| body                | text                        | Không    | —                          |
| body_format         | character varying(10)       | Có       | 'PLAIN'::character varying |
| occurred_at         | timestamp(3) with time zone | Có       | —                          |
| occurred_local_date | date                        | Có       | —                          |
| visibility          | app.visibility              | Có       | —                          |
| status              | app.memory_status           | Có       | —                          |
| pregnancy_id        | uuid                        | Không    | —                          |
| pregnancy_week      | smallint                    | Không    | —                          |
| source_type         | character varying(20)       | Không    | —                          |
| source_id           | uuid                        | Không    | —                          |
| location_label      | character varying(120)      | Không    | —                          |
| feeling             | app.moment_feeling          | Không    | —                          |
| quote_context       | character varying(200)      | Không    | —                          |
| perspective_count   | smallint                    | Có       | 0                          |
| comments_enabled    | boolean                     | Có       | true                       |
| unlock_at           | timestamp(3) with time zone | Không    | —                          |
| reviewed_by         | uuid                        | Không    | —                          |
| reviewed_at         | timestamp(3) with time zone | Không    | —                          |
| reject_reason       | character varying(200)      | Không    | —                          |
| published_at        | timestamp(3) with time zone | Không    | —                          |
| archived_at         | timestamp(3) with time zone | Không    | —                          |
| trashed_at          | timestamp(3) with time zone | Không    | —                          |
| trashed_by          | uuid                        | Không    | —                          |
| purge_after         | timestamp(3) with time zone | Không    | —                          |
| deleted_at          | timestamp(3) with time zone | Không    | —                          |
| search_tsv          | tsvector                    | Không    | —                          |
| comment_count       | integer                     | Có       | 0                          |
| reaction_count      | integer                     | Có       | 0                          |
| created_at          | timestamp(3) with time zone | Có       | now()                      |
| updated_at          | timestamp(3) with time zone | Có       | now()                      |
| version             | integer                     | Có       | 1                          |
| family_moment       | boolean                     | Có       | false                      |

Constraints:

- `memories_author_role_check`: `CHECK (((author_role)::text = ANY ((ARRAY['PARENT'::character varying, 'CIRCLE'::character varying])::text[])))`
- `memories_body_check`: `CHECK (((body IS NULL) OR (char_length(body) <= 20000)))`
- `memories_body_format_check`: `CHECK (((body_format)::text = ANY ((ARRAY['PLAIN'::character varying, 'RICH'::character varying])::text[])))`
- `memories_check`: `CHECK (((kind <> 'QUOTE'::app.memory_kind) OR ((body IS NOT NULL) AND (char_length(body) <= 280))))`
- `memories_check1`: `CHECK (((kind <> 'MONTHLY_PHOTO'::app.memory_kind) OR ((author_role)::text = 'PARENT'::text)))`
- `memories_check2`: `CHECK (((comment_count >= 0) AND (reaction_count >= 0) AND (perspective_count >= 0)))`
- `memories_check3`: `CHECK (((status = ANY (ARRAY['TRASHED'::app.memory_status, 'PURGED'::app.memory_status])) = (deleted_at IS NOT NULL)))`
- `memories_check4`: `CHECK (((status <> 'TRASHED'::app.memory_status) OR ((trashed_at IS NOT NULL) AND (purge_after IS NOT NULL))))`
- `memories_author_user_id_fkey`: `FOREIGN KEY (author_user_id) REFERENCES app.users(id)`
- `memories_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `memories_pregnancy_id_family_id_fkey`: `FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id)`
- `memories_reviewed_by_fkey`: `FOREIGN KEY (reviewed_by) REFERENCES app.users(id)`
- `memories_author_role_not_null`: `NOT NULL author_role`
- `memories_author_user_id_not_null`: `NOT NULL author_user_id`
- `memories_body_format_not_null`: `NOT NULL body_format`
- `memories_comment_count_not_null`: `NOT NULL comment_count`
- `memories_comments_enabled_not_null`: `NOT NULL comments_enabled`
- `memories_created_at_not_null`: `NOT NULL created_at`
- `memories_family_id_not_null`: `NOT NULL family_id`
- `memories_family_moment_not_null`: `NOT NULL family_moment`
- `memories_id_not_null`: `NOT NULL id`
- `memories_kind_not_null`: `NOT NULL kind`
- `memories_occurred_at_not_null`: `NOT NULL occurred_at`
- `memories_occurred_local_date_not_null`: `NOT NULL occurred_local_date`
- `memories_perspective_count_not_null`: `NOT NULL perspective_count`
- `memories_reaction_count_not_null`: `NOT NULL reaction_count`
- `memories_status_not_null`: `NOT NULL status`
- `memories_updated_at_not_null`: `NOT NULL updated_at`
- `memories_version_not_null`: `NOT NULL version`
- `memories_visibility_not_null`: `NOT NULL visibility`
- `memories_pkey`: `PRIMARY KEY (id)`
- `memories_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `ix_mem_family_pub`: `CREATE INDEX ix_mem_family_pub ON app.memories USING btree (family_id, published_at DESC, id DESC) WHERE ((status = 'PUBLISHED'::app.memory_status) AND (deleted_at IS NULL))`
- `ix_mem_family_time`: `CREATE INDEX ix_mem_family_time ON app.memories USING btree (family_id, occurred_at DESC, id DESC) WHERE (deleted_at IS NULL)`
- `ix_mem_kind`: `CREATE INDEX ix_mem_kind ON app.memories USING btree (family_id, kind, occurred_at DESC) WHERE ((status = 'PUBLISHED'::app.memory_status) AND (deleted_at IS NULL))`
- `ix_mem_onthisday`: `CREATE INDEX ix_mem_onthisday ON app.memories USING btree (family_id, EXTRACT(month FROM occurred_local_date), EXTRACT(day FROM occurred_local_date)) WHERE ((status = 'PUBLISHED'::app.memory_status) AND (deleted_at IS NULL))`
- `ix_mem_pending`: `CREATE INDEX ix_mem_pending ON app.memories USING btree (family_id, created_at) WHERE ((status = 'PENDING_REVIEW'::app.memory_status) AND (deleted_at IS NULL))`
- `ix_mem_search`: `CREATE INDEX ix_mem_search ON app.memories USING gin (search_tsv)`
- `ix_mem_today`: `CREATE INDEX ix_mem_today ON app.memories USING btree (family_id, occurred_local_date, published_at) WHERE ((status = 'PUBLISHED'::app.memory_status) AND (deleted_at IS NULL))`
- `ix_mem_trash`: `CREATE INDEX ix_mem_trash ON app.memories USING btree (purge_after) WHERE (status = 'TRASHED'::app.memory_status)`
- `memories_id_family_id_key`: `CREATE UNIQUE INDEX memories_id_family_id_key ON app.memories USING btree (id, family_id)`
- `memories_pkey`: `CREATE UNIQUE INDEX memories_pkey ON app.memories USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.memories FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.memories FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_memories_tsv`: `CREATE TRIGGER trg_memories_tsv BEFORE INSERT OR UPDATE OF title, body, location_label ON app.memories FOR EACH ROW EXECUTE FUNCTION app.memories_tsv()`

## app.memory_assets — MemoryAsset

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| memory_id  | uuid                        | Có       | —                              |
| asset_id   | uuid                        | Có       | —                              |
| family_id  | uuid                        | Có       | —                              |
| sort_order | smallint                    | Có       | —                              |
| is_cover   | boolean                     | Có       | false                          |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `memory_assets_sort_order_check`: `CHECK ((sort_order >= 0))`
- `memory_assets_asset_id_family_id_fkey`: `FOREIGN KEY (asset_id, family_id) REFERENCES app.assets(id, family_id)`
- `memory_assets_memory_id_family_id_fkey`: `FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE`
- `memory_assets_asset_id_not_null`: `NOT NULL asset_id`
- `memory_assets_created_at_not_null`: `NOT NULL created_at`
- `memory_assets_family_id_not_null`: `NOT NULL family_id`
- `memory_assets_is_cover_not_null`: `NOT NULL is_cover`
- `memory_assets_memory_id_not_null`: `NOT NULL memory_id`
- `memory_assets_sort_order_not_null`: `NOT NULL sort_order`
- `memory_assets_updated_at_not_null`: `NOT NULL updated_at`
- `memory_assets_pkey`: `PRIMARY KEY (memory_id, asset_id)`
- `memory_assets_memory_id_asset_id_family_id_key`: `UNIQUE (memory_id, asset_id, family_id)`

Indexes:

- `memory_assets_asset_id_idx`: `CREATE INDEX memory_assets_asset_id_idx ON app.memory_assets USING btree (asset_id)`
- `memory_assets_memory_id_asset_id_family_id_key`: `CREATE UNIQUE INDEX memory_assets_memory_id_asset_id_family_id_key ON app.memory_assets USING btree (memory_id, asset_id, family_id)`
- `memory_assets_pkey`: `CREATE UNIQUE INDEX memory_assets_pkey ON app.memory_assets USING btree (memory_id, asset_id)`
- `uq_memory_cover`: `CREATE UNIQUE INDEX uq_memory_cover ON app.memory_assets USING btree (memory_id) WHERE (is_cover AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.memory_assets FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.memory_assets FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.memory_children — MemoryChild

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| memory_id  | uuid                        | Có       | —                              |
| child_id   | uuid                        | Có       | —                              |
| family_id  | uuid                        | Có       | —                              |
| added_by   | uuid                        | Không    | —                              |
| age_month  | smallint                    | Có       | —                              |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `memory_children_added_by_fkey`: `FOREIGN KEY (added_by) REFERENCES app.users(id)`
- `memory_children_child_id_family_id_fkey`: `FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)`
- `memory_children_memory_id_family_id_fkey`: `FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE`
- `memory_children_age_month_not_null`: `NOT NULL age_month`
- `memory_children_child_id_not_null`: `NOT NULL child_id`
- `memory_children_created_at_not_null`: `NOT NULL created_at`
- `memory_children_family_id_not_null`: `NOT NULL family_id`
- `memory_children_memory_id_not_null`: `NOT NULL memory_id`
- `memory_children_updated_at_not_null`: `NOT NULL updated_at`
- `memory_children_pkey`: `PRIMARY KEY (memory_id, child_id)`

Indexes:

- `ix_mc_child`: `CREATE INDEX ix_mc_child ON app.memory_children USING btree (child_id, memory_id)`
- `ix_mc_child_month`: `CREATE INDEX ix_mc_child_month ON app.memory_children USING btree (child_id, age_month)`
- `ix_memory_children_active`: `CREATE INDEX ix_memory_children_active ON app.memory_children USING btree (child_id, age_month, memory_id) WHERE (deleted_at IS NULL)`
- `memory_children_pkey`: `CREATE UNIQUE INDEX memory_children_pkey ON app.memory_children USING btree (memory_id, child_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.memory_children FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.memory_children FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.memory_letters — MemoryLetter

| Cột                | PostgreSQL type             | NOT NULL | Default                        |
| ------------------ | --------------------------- | -------- | ------------------------------ |
| memory_id          | uuid                        | Có       | —                              |
| family_id          | uuid                        | Có       | —                              |
| child_id           | uuid                        | Không    | —                              |
| release_rule       | character varying(20)       | Có       | —                              |
| birthday_number    | smallint                    | Không    | —                              |
| release_visibility | app.visibility              | Có       | 'PARENTS'::app.visibility      |
| created_at         | timestamp(3) with time zone | Có       | now()                          |
| updated_at         | timestamp(3) with time zone | Có       | now()                          |
| deleted_at         | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `memory_letters_check`: `CHECK ((((release_rule)::text <> 'CHILD_BIRTHDAY'::text) OR ((child_id IS NOT NULL) AND (birthday_number IS NOT NULL) AND (birthday_number > 0))))`
- `memory_letters_release_rule_check`: `CHECK (((release_rule)::text = ANY ((ARRAY['DATE'::character varying, 'CHILD_BIRTHDAY'::character varying])::text[])))`
- `memory_letters_child_id_family_id_fkey`: `FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)`
- `memory_letters_memory_id_family_id_fkey`: `FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id)`
- `memory_letters_created_at_not_null`: `NOT NULL created_at`
- `memory_letters_family_id_not_null`: `NOT NULL family_id`
- `memory_letters_memory_id_not_null`: `NOT NULL memory_id`
- `memory_letters_release_rule_not_null`: `NOT NULL release_rule`
- `memory_letters_release_visibility_not_null`: `NOT NULL release_visibility`
- `memory_letters_updated_at_not_null`: `NOT NULL updated_at`
- `memory_letters_pkey`: `PRIMARY KEY (memory_id)`

Indexes:

- `memory_letters_pkey`: `CREATE UNIQUE INDEX memory_letters_pkey ON app.memory_letters USING btree (memory_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.memory_letters FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.memory_letters FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.memory_people — MemoryPerson

| Cột          | PostgreSQL type             | NOT NULL | Default                        |
| ------------ | --------------------------- | -------- | ------------------------------ |
| id           | bigint                      | Có       | —                              |
| memory_id    | uuid                        | Có       | —                              |
| family_id    | uuid                        | Có       | —                              |
| user_id      | uuid                        | Không    | —                              |
| display_name | character varying(40)       | Không    | —                              |
| sort_order   | smallint                    | Có       | 0                              |
| added_by     | uuid                        | Có       | —                              |
| created_at   | timestamp(3) with time zone | Có       | now()                          |
| updated_at   | timestamp(3) with time zone | Có       | now()                          |
| deleted_at   | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `memory_people_check`: `CHECK (((user_id IS NULL) <> (display_name IS NULL)))`
- `memory_people_display_name_check`: `CHECK (((display_name IS NULL) OR (char_length(btrim((display_name)::text)) > 0)))`
- `memory_people_added_by_fkey`: `FOREIGN KEY (added_by) REFERENCES app.users(id)`
- `memory_people_memory_id_family_id_fkey`: `FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE`
- `memory_people_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `memory_people_added_by_not_null`: `NOT NULL added_by`
- `memory_people_created_at_not_null`: `NOT NULL created_at`
- `memory_people_family_id_not_null`: `NOT NULL family_id`
- `memory_people_id_not_null`: `NOT NULL id`
- `memory_people_memory_id_not_null`: `NOT NULL memory_id`
- `memory_people_sort_order_not_null`: `NOT NULL sort_order`
- `memory_people_updated_at_not_null`: `NOT NULL updated_at`
- `memory_people_pkey`: `PRIMARY KEY (id)`

Indexes:

- `memory_people_pkey`: `CREATE UNIQUE INDEX memory_people_pkey ON app.memory_people USING btree (id)`
- `memory_people_user_id_idx`: `CREATE INDEX memory_people_user_id_idx ON app.memory_people USING btree (user_id) WHERE ((user_id IS NOT NULL) AND (deleted_at IS NULL))`
- `uq_mem_people_user`: `CREATE UNIQUE INDEX uq_mem_people_user ON app.memory_people USING btree (memory_id, user_id) WHERE ((user_id IS NOT NULL) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.memory_people FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.memory_people FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.memory_perspective_assets — MemoryPerspectiveAsset

| Cột            | PostgreSQL type             | NOT NULL | Default                        |
| -------------- | --------------------------- | -------- | ------------------------------ |
| perspective_id | uuid                        | Có       | —                              |
| asset_id       | uuid                        | Có       | —                              |
| family_id      | uuid                        | Có       | —                              |
| sort_order     | smallint                    | Có       | —                              |
| created_at     | timestamp(3) with time zone | Có       | now()                          |
| updated_at     | timestamp(3) with time zone | Có       | now()                          |
| deleted_at     | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `memory_perspective_assets_asset_id_family_id_fkey`: `FOREIGN KEY (asset_id, family_id) REFERENCES app.assets(id, family_id)`
- `memory_perspective_assets_perspective_id_family_id_fkey`: `FOREIGN KEY (perspective_id, family_id) REFERENCES app.memory_perspectives(id, family_id) ON DELETE CASCADE`
- `memory_perspective_assets_asset_id_not_null`: `NOT NULL asset_id`
- `memory_perspective_assets_created_at_not_null`: `NOT NULL created_at`
- `memory_perspective_assets_family_id_not_null`: `NOT NULL family_id`
- `memory_perspective_assets_perspective_id_not_null`: `NOT NULL perspective_id`
- `memory_perspective_assets_sort_order_not_null`: `NOT NULL sort_order`
- `memory_perspective_assets_updated_at_not_null`: `NOT NULL updated_at`
- `memory_perspective_assets_pkey`: `PRIMARY KEY (perspective_id, asset_id)`

Indexes:

- `memory_perspective_assets_asset_id_idx`: `CREATE INDEX memory_perspective_assets_asset_id_idx ON app.memory_perspective_assets USING btree (asset_id)`
- `memory_perspective_assets_pkey`: `CREATE UNIQUE INDEX memory_perspective_assets_pkey ON app.memory_perspective_assets USING btree (perspective_id, asset_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.memory_perspective_assets FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.memory_perspective_assets FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.memory_perspectives — MemoryPerspective

| Cột                | PostgreSQL type             | NOT NULL | Default                        |
| ------------------ | --------------------------- | -------- | ------------------------------ |
| id                 | uuid                        | Có       | uuidv7()                       |
| family_id          | uuid                        | Có       | —                              |
| memory_id          | uuid                        | Có       | —                              |
| author_user_id     | uuid                        | Có       | —                              |
| body               | character varying(1000)     | Không    | —                              |
| audio_asset_id     | uuid                        | Không    | —                              |
| hidden_from_circle | boolean                     | Có       | false                          |
| status             | character varying(10)       | Có       | 'ACTIVE'::character varying    |
| trashed_at         | timestamp(3) with time zone | Không    | —                              |
| created_at         | timestamp(3) with time zone | Có       | now()                          |
| updated_at         | timestamp(3) with time zone | Có       | now()                          |
| version            | integer                     | Có       | 1                              |
| deleted_at         | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `memory_perspectives_audio_asset_id_family_id_fkey`: `FOREIGN KEY (audio_asset_id, family_id) REFERENCES app.assets(id, family_id)`
- `memory_perspectives_author_user_id_fkey`: `FOREIGN KEY (author_user_id) REFERENCES app.users(id)`
- `memory_perspectives_memory_id_family_id_fkey`: `FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE`
- `memory_perspectives_author_user_id_not_null`: `NOT NULL author_user_id`
- `memory_perspectives_created_at_not_null`: `NOT NULL created_at`
- `memory_perspectives_family_id_not_null`: `NOT NULL family_id`
- `memory_perspectives_hidden_from_circle_not_null`: `NOT NULL hidden_from_circle`
- `memory_perspectives_id_not_null`: `NOT NULL id`
- `memory_perspectives_memory_id_not_null`: `NOT NULL memory_id`
- `memory_perspectives_status_not_null`: `NOT NULL status`
- `memory_perspectives_updated_at_not_null`: `NOT NULL updated_at`
- `memory_perspectives_version_not_null`: `NOT NULL version`
- `memory_perspectives_pkey`: `PRIMARY KEY (id)`
- `memory_perspectives_id_family_id_key`: `UNIQUE (id, family_id)`
- `memory_perspectives_memory_id_author_user_id_key`: `UNIQUE (memory_id, author_user_id)`

Indexes:

- `memory_perspectives_id_family_id_key`: `CREATE UNIQUE INDEX memory_perspectives_id_family_id_key ON app.memory_perspectives USING btree (id, family_id)`
- `memory_perspectives_memory_id_author_user_id_key`: `CREATE UNIQUE INDEX memory_perspectives_memory_id_author_user_id_key ON app.memory_perspectives USING btree (memory_id, author_user_id)`
- `memory_perspectives_pkey`: `CREATE UNIQUE INDEX memory_perspectives_pkey ON app.memory_perspectives USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.memory_perspectives FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.memory_perspectives FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.memory_pins — MemoryPin

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| child_id   | uuid                        | Có       | —                              |
| memory_id  | uuid                        | Có       | —                              |
| pinned_by  | uuid                        | Có       | —                              |
| position   | smallint                    | Có       | —                              |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| family_id  | uuid                        | Có       | —                              |

Constraints:

- `memory_pins_position_check`: `CHECK ((("position" >= 1) AND ("position" <= 3)))`
- `memory_pins_child_id_family_id_fkey`: `FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)`
- `memory_pins_child_id_fkey`: `FOREIGN KEY (child_id) REFERENCES app.children(id)`
- `memory_pins_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `memory_pins_memory_id_family_id_fkey`: `FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id)`
- `memory_pins_memory_id_fkey`: `FOREIGN KEY (memory_id) REFERENCES app.memories(id) ON DELETE CASCADE`
- `memory_pins_pinned_by_fkey`: `FOREIGN KEY (pinned_by) REFERENCES app.users(id)`
- `memory_pins_child_id_not_null`: `NOT NULL child_id`
- `memory_pins_created_at_not_null`: `NOT NULL created_at`
- `memory_pins_family_id_not_null`: `NOT NULL family_id`
- `memory_pins_memory_id_not_null`: `NOT NULL memory_id`
- `memory_pins_pinned_by_not_null`: `NOT NULL pinned_by`
- `memory_pins_position_not_null`: `NOT NULL "position"`
- `memory_pins_updated_at_not_null`: `NOT NULL updated_at`
- `memory_pins_pkey`: `PRIMARY KEY (child_id, "position")`

Indexes:

- `memory_pins_pkey`: `CREATE UNIQUE INDEX memory_pins_pkey ON app.memory_pins USING btree (child_id, "position")`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.memory_pins FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.memory_pins FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.memory_prompt_deliveries — MemoryPromptDelivery

| Cột           | PostgreSQL type             | NOT NULL | Default                        |
| ------------- | --------------------------- | -------- | ------------------------------ |
| id            | bigint                      | Có       | —                              |
| family_id     | uuid                        | Có       | —                              |
| user_id       | uuid                        | Có       | —                              |
| local_date    | date                        | Có       | —                              |
| template_code | character varying(30)       | Có       | —                              |
| child_id      | uuid                        | Không    | —                              |
| pregnancy_id  | uuid                        | Không    | —                              |
| status        | character varying(10)       | Có       | 'SHOWN'::character varying     |
| memory_id     | uuid                        | Không    | —                              |
| created_at    | timestamp(3) with time zone | Có       | now()                          |
| acted_at      | timestamp(3) with time zone | Không    | —                              |
| updated_at    | timestamp(3) with time zone | Có       | now()                          |
| deleted_at    | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `memory_prompt_deliveries_check`: `CHECK ((num_nonnulls(child_id, pregnancy_id) <= 1))`
- `memory_prompt_deliveries_child_id_family_id_fkey`: `FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)`
- `memory_prompt_deliveries_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `memory_prompt_deliveries_memory_id_family_id_fkey`: `FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id)`
- `memory_prompt_deliveries_pregnancy_id_family_id_fkey`: `FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id)`
- `memory_prompt_deliveries_template_code_fkey`: `FOREIGN KEY (template_code) REFERENCES app.memory_prompt_templates(code)`
- `memory_prompt_deliveries_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `memory_prompt_deliveries_created_at_not_null`: `NOT NULL created_at`
- `memory_prompt_deliveries_family_id_not_null`: `NOT NULL family_id`
- `memory_prompt_deliveries_id_not_null`: `NOT NULL id`
- `memory_prompt_deliveries_local_date_not_null`: `NOT NULL local_date`
- `memory_prompt_deliveries_status_not_null`: `NOT NULL status`
- `memory_prompt_deliveries_template_code_not_null`: `NOT NULL template_code`
- `memory_prompt_deliveries_updated_at_not_null`: `NOT NULL updated_at`
- `memory_prompt_deliveries_user_id_not_null`: `NOT NULL user_id`
- `memory_prompt_deliveries_pkey`: `PRIMARY KEY (id)`

Indexes:

- `ix_prompt_recent`: `CREATE INDEX ix_prompt_recent ON app.memory_prompt_deliveries USING btree (user_id, local_date DESC, template_code)`
- `memory_prompt_deliveries_pkey`: `CREATE UNIQUE INDEX memory_prompt_deliveries_pkey ON app.memory_prompt_deliveries USING btree (id)`
- `uq_prompt_day`: `CREATE UNIQUE INDEX uq_prompt_day ON app.memory_prompt_deliveries USING btree (user_id, local_date) WHERE (((status)::text = ANY ((ARRAY['SHOWN'::character varying, 'USED'::character varying])::text[])) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.memory_prompt_deliveries FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.memory_prompt_deliveries FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.memory_prompt_templates — MemoryPromptTemplate

| Cột           | PostgreSQL type             | NOT NULL | Default                        |
| ------------- | --------------------------- | -------- | ------------------------------ |
| code          | character varying(30)       | Có       | —                              |
| stage         | character varying(10)       | Có       | —                              |
| min_age_days  | integer                     | Không    | —                              |
| max_age_days  | integer                     | Không    | —                              |
| min_preg_week | smallint                    | Không    | —                              |
| max_preg_week | smallint                    | Không    | —                              |
| target_kind   | app.memory_kind             | Có       | —                              |
| text_i18n     | jsonb                       | Có       | —                              |
| weight        | smallint                    | Có       | 10                             |
| status        | character varying(10)       | Có       | 'ACTIVE'::character varying    |
| version       | integer                     | Có       | 1                              |
| updated_at    | timestamp(3) with time zone | Có       | now()                          |
| created_at    | timestamp(3) with time zone | Có       | now()                          |
| deleted_at    | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `memory_prompt_templates_code_not_null`: `NOT NULL code`
- `memory_prompt_templates_created_at_not_null`: `NOT NULL created_at`
- `memory_prompt_templates_stage_not_null`: `NOT NULL stage`
- `memory_prompt_templates_status_not_null`: `NOT NULL status`
- `memory_prompt_templates_target_kind_not_null`: `NOT NULL target_kind`
- `memory_prompt_templates_text_i18n_not_null`: `NOT NULL text_i18n`
- `memory_prompt_templates_updated_at_not_null`: `NOT NULL updated_at`
- `memory_prompt_templates_version_not_null`: `NOT NULL version`
- `memory_prompt_templates_weight_not_null`: `NOT NULL weight`
- `memory_prompt_templates_pkey`: `PRIMARY KEY (code)`

Indexes:

- `memory_prompt_templates_pkey`: `CREATE UNIQUE INDEX memory_prompt_templates_pkey ON app.memory_prompt_templates USING btree (code)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.memory_prompt_templates FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## app.milestone_templates — MilestoneTemplate

| Cột                | PostgreSQL type             | NOT NULL | Default                        |
| ------------------ | --------------------------- | -------- | ------------------------------ |
| code               | character varying(40)       | Có       | —                              |
| category           | character varying(20)       | Có       | —                              |
| icon               | character varying(40)       | Có       | —                              |
| title_i18n         | jsonb                       | Có       | —                              |
| prompt_i18n        | jsonb                       | Không    | —                              |
| is_traditional     | boolean                     | Có       | false                          |
| date_rule          | jsonb                       | Không    | —                              |
| remind_days_before | smallint                    | Không    | —                              |
| sort_order         | integer                     | Có       | 0                              |
| status             | character varying(10)       | Có       | 'ACTIVE'::character varying    |
| created_at         | timestamp(3) with time zone | Có       | now()                          |
| updated_at         | timestamp(3) with time zone | Có       | now()                          |
| deleted_at         | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `milestone_templates_category_not_null`: `NOT NULL category`
- `milestone_templates_code_not_null`: `NOT NULL code`
- `milestone_templates_created_at_not_null`: `NOT NULL created_at`
- `milestone_templates_icon_not_null`: `NOT NULL icon`
- `milestone_templates_is_traditional_not_null`: `NOT NULL is_traditional`
- `milestone_templates_sort_order_not_null`: `NOT NULL sort_order`
- `milestone_templates_status_not_null`: `NOT NULL status`
- `milestone_templates_title_i18n_not_null`: `NOT NULL title_i18n`
- `milestone_templates_updated_at_not_null`: `NOT NULL updated_at`
- `milestone_templates_pkey`: `PRIMARY KEY (code)`

Indexes:

- `milestone_templates_pkey`: `CREATE UNIQUE INDEX milestone_templates_pkey ON app.milestone_templates USING btree (code)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.milestone_templates FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## app.milestones — Milestone

| Cột               | PostgreSQL type             | NOT NULL | Default  |
| ----------------- | --------------------------- | -------- | -------- |
| id                | uuid                        | Có       | uuidv7() |
| family_id         | uuid                        | Có       | —        |
| child_id          | uuid                        | Không    | —        |
| pregnancy_id      | uuid                        | Không    | —        |
| from_milestone_id | uuid                        | Không    | —        |
| memory_id         | uuid                        | Có       | —        |
| template_code     | character varying(40)       | Không    | —        |
| custom_title      | character varying(80)       | Không    | —        |
| occurred_on       | date                        | Có       | —        |
| created_by        | uuid                        | Có       | —        |
| created_at        | timestamp(3) with time zone | Có       | now()    |
| deleted_at        | timestamp(3) with time zone | Không    | —        |
| updated_at        | timestamp(3) with time zone | Có       | now()    |

Constraints:

- `milestones_check`: `CHECK (((template_code IS NOT NULL) OR (custom_title IS NOT NULL)))`
- `milestones_check1`: `CHECK (((((child_id IS NOT NULL))::integer + ((pregnancy_id IS NOT NULL))::integer) = 1))`
- `milestones_child_id_family_id_fkey`: `FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)`
- `milestones_created_by_fkey`: `FOREIGN KEY (created_by) REFERENCES app.users(id)`
- `milestones_from_milestone_id_family_id_fkey`: `FOREIGN KEY (from_milestone_id, family_id) REFERENCES app.milestones(id, family_id)`
- `milestones_memory_id_family_id_fkey`: `FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id)`
- `milestones_pregnancy_id_family_id_fkey`: `FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id)`
- `milestones_template_code_fkey`: `FOREIGN KEY (template_code) REFERENCES app.milestone_templates(code)`
- `milestones_created_at_not_null`: `NOT NULL created_at`
- `milestones_created_by_not_null`: `NOT NULL created_by`
- `milestones_family_id_not_null`: `NOT NULL family_id`
- `milestones_id_not_null`: `NOT NULL id`
- `milestones_memory_id_not_null`: `NOT NULL memory_id`
- `milestones_occurred_on_not_null`: `NOT NULL occurred_on`
- `milestones_updated_at_not_null`: `NOT NULL updated_at`
- `milestones_pkey`: `PRIMARY KEY (id)`
- `milestones_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `milestones_child_id_occurred_on_idx`: `CREATE INDEX milestones_child_id_occurred_on_idx ON app.milestones USING btree (child_id, occurred_on)`
- `milestones_id_family_id_key`: `CREATE UNIQUE INDEX milestones_id_family_id_key ON app.milestones USING btree (id, family_id)`
- `milestones_pkey`: `CREATE UNIQUE INDEX milestones_pkey ON app.milestones USING btree (id)`
- `uq_milestone_once`: `CREATE UNIQUE INDEX uq_milestone_once ON app.milestones USING btree (child_id, template_code) WHERE ((template_code IS NOT NULL) AND (deleted_at IS NULL))`
- `uq_preg_milestone_once`: `CREATE UNIQUE INDEX uq_preg_milestone_once ON app.milestones USING btree (pregnancy_id, template_code) WHERE ((pregnancy_id IS NOT NULL) AND (template_code IS NOT NULL) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.milestones FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.milestones FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.mission_children — MissionChild

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| mission_id | uuid                        | Có       | —                              |
| child_id   | uuid                        | Có       | —                              |
| family_id  | uuid                        | Có       | —                              |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `mission_children_child_id_family_id_fkey`: `FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)`
- `mission_children_mission_id_family_id_fkey`: `FOREIGN KEY (mission_id, family_id) REFERENCES app.missions(id, family_id) ON DELETE CASCADE`
- `mission_children_child_id_not_null`: `NOT NULL child_id`
- `mission_children_created_at_not_null`: `NOT NULL created_at`
- `mission_children_family_id_not_null`: `NOT NULL family_id`
- `mission_children_mission_id_not_null`: `NOT NULL mission_id`
- `mission_children_updated_at_not_null`: `NOT NULL updated_at`
- `mission_children_pkey`: `PRIMARY KEY (mission_id, child_id)`
- `trg_mission_scope_c`: `TRIGGER DEFERRABLE INITIALLY DEFERRED`

Indexes:

- `mission_children_child_id_idx`: `CREATE INDEX mission_children_child_id_idx ON app.mission_children USING btree (child_id)`
- `mission_children_pkey`: `CREATE UNIQUE INDEX mission_children_pkey ON app.mission_children USING btree (mission_id, child_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.mission_children FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.mission_children FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_lock_mission_children`: `CREATE TRIGGER trg_lock_mission_children BEFORE INSERT OR DELETE OR UPDATE ON app.mission_children FOR EACH ROW EXECUTE FUNCTION app.lock_mission_children()`
- `trg_mission_scope_c`: `CREATE CONSTRAINT TRIGGER trg_mission_scope_c AFTER INSERT OR DELETE OR UPDATE ON app.mission_children DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION app.check_mission_scope()`

## app.mission_completions — MissionCompletion

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| id              | uuid                        | Có       | uuidv7()                       |
| mission_id      | uuid                        | Có       | —                              |
| completed_by    | uuid                        | Có       | —                              |
| completed_at    | timestamp(3) with time zone | Có       | now()                          |
| late            | boolean                     | Có       | false                          |
| note            | character varying(500)      | Không    | —                              |
| memory_id       | uuid                        | Không    | —                              |
| idempotency_key | uuid                        | Có       | —                              |
| undone_at       | timestamp(3) with time zone | Không    | —                              |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| family_id       | uuid                        | Có       | —                              |

Constraints:

- `mission_completions_completed_by_fkey`: `FOREIGN KEY (completed_by) REFERENCES app.users(id)`
- `mission_completions_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `mission_completions_memory_id_family_id_fkey`: `FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id)`
- `mission_completions_mission_id_family_id_fkey`: `FOREIGN KEY (mission_id, family_id) REFERENCES app.missions(id, family_id)`
- `mission_completions_mission_id_fkey`: `FOREIGN KEY (mission_id) REFERENCES app.missions(id)`
- `mission_completions_completed_at_not_null`: `NOT NULL completed_at`
- `mission_completions_completed_by_not_null`: `NOT NULL completed_by`
- `mission_completions_created_at_not_null`: `NOT NULL created_at`
- `mission_completions_family_id_not_null`: `NOT NULL family_id`
- `mission_completions_id_not_null`: `NOT NULL id`
- `mission_completions_idempotency_key_not_null`: `NOT NULL idempotency_key`
- `mission_completions_late_not_null`: `NOT NULL late`
- `mission_completions_mission_id_not_null`: `NOT NULL mission_id`
- `mission_completions_updated_at_not_null`: `NOT NULL updated_at`
- `mission_completions_pkey`: `PRIMARY KEY (id)`
- `mission_completions_id_family_id_key`: `UNIQUE (id, family_id)`
- `mission_completions_idempotency_key_key`: `UNIQUE (idempotency_key)`

Indexes:

- `mission_completions_id_family_id_key`: `CREATE UNIQUE INDEX mission_completions_id_family_id_key ON app.mission_completions USING btree (id, family_id)`
- `mission_completions_idempotency_key_key`: `CREATE UNIQUE INDEX mission_completions_idempotency_key_key ON app.mission_completions USING btree (idempotency_key)`
- `mission_completions_pkey`: `CREATE UNIQUE INDEX mission_completions_pkey ON app.mission_completions USING btree (id)`
- `uq_mission_completion_active`: `CREATE UNIQUE INDEX uq_mission_completion_active ON app.mission_completions USING btree (mission_id) WHERE ((undone_at IS NULL) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.mission_completions FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.mission_completions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.mission_events — MissionEvent

| Cột           | PostgreSQL type             | NOT NULL | Default                        |
| ------------- | --------------------------- | -------- | ------------------------------ |
| id            | bigint                      | Có       | —                              |
| mission_id    | uuid                        | Có       | —                              |
| actor_user_id | uuid                        | Không    | —                              |
| type          | character varying(30)       | Có       | —                              |
| data          | jsonb                       | Không    | —                              |
| created_at    | timestamp(3) with time zone | Có       | now()                          |
| updated_at    | timestamp(3) with time zone | Có       | now()                          |
| deleted_at    | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| family_id     | uuid                        | Có       | —                              |

Constraints:

- `mission_events_actor_user_id_fkey`: `FOREIGN KEY (actor_user_id) REFERENCES app.users(id)`
- `mission_events_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `mission_events_mission_id_family_id_fkey`: `FOREIGN KEY (mission_id, family_id) REFERENCES app.missions(id, family_id)`
- `mission_events_mission_id_fkey`: `FOREIGN KEY (mission_id) REFERENCES app.missions(id) ON DELETE CASCADE`
- `mission_events_created_at_not_null`: `NOT NULL created_at`
- `mission_events_family_id_not_null`: `NOT NULL family_id`
- `mission_events_id_not_null`: `NOT NULL id`
- `mission_events_mission_id_not_null`: `NOT NULL mission_id`
- `mission_events_type_not_null`: `NOT NULL type`
- `mission_events_updated_at_not_null`: `NOT NULL updated_at`
- `mission_events_pkey`: `PRIMARY KEY (id)`

Indexes:

- `mission_events_mission_id_created_at_idx`: `CREATE INDEX mission_events_mission_id_created_at_idx ON app.mission_events USING btree (mission_id, created_at)`
- `mission_events_pkey`: `CREATE UNIQUE INDEX mission_events_pkey ON app.mission_events USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.mission_events FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.mission_events FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.mission_family_settings — MissionFamilySetting

| Cột         | PostgreSQL type             | NOT NULL | Default                           |
| ----------- | --------------------------- | -------- | --------------------------------- |
| family_id   | uuid                        | Có       | —                                 |
| board_level | app.mission_board_level     | Có       | 'MEDIUM'::app.mission_board_level |
| updated_by  | uuid                        | Không    | —                                 |
| updated_at  | timestamp(3) with time zone | Có       | now()                             |
| version     | integer                     | Có       | 1                                 |
| created_at  | timestamp(3) with time zone | Có       | now()                             |
| deleted_at  | timestamp(3) with time zone | Không    | NULL::timestamp with time zone    |

Constraints:

- `mission_family_settings_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `mission_family_settings_updated_by_fkey`: `FOREIGN KEY (updated_by) REFERENCES app.users(id)`
- `mission_family_settings_board_level_not_null`: `NOT NULL board_level`
- `mission_family_settings_created_at_not_null`: `NOT NULL created_at`
- `mission_family_settings_family_id_not_null`: `NOT NULL family_id`
- `mission_family_settings_updated_at_not_null`: `NOT NULL updated_at`
- `mission_family_settings_version_not_null`: `NOT NULL version`
- `mission_family_settings_pkey`: `PRIMARY KEY (family_id)`

Indexes:

- `mission_family_settings_pkey`: `CREATE UNIQUE INDEX mission_family_settings_pkey ON app.mission_family_settings USING btree (family_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.mission_family_settings FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.mission_family_settings FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.mission_preferences — MissionPreference

| Cột                  | PostgreSQL type             | NOT NULL | Default                            |
| -------------------- | --------------------------- | -------- | ---------------------------------- |
| family_id            | uuid                        | Có       | —                                  |
| user_id              | uuid                        | Có       | —                                  |
| disabled_categories  | app.mission_category[]      | Có       | '{}'::app.mission_category[]       |
| board_push_time      | time without time zone      | Có       | '07:00:00'::time without time zone |
| evening_carry_over   | boolean                     | Có       | true                               |
| default_reminder_min | smallint                    | Không    | —                                  |
| created_at           | timestamp(3) with time zone | Có       | now()                              |
| updated_at           | timestamp(3) with time zone | Có       | now()                              |
| deleted_at           | timestamp(3) with time zone | Không    | NULL::timestamp with time zone     |

Constraints:

- `mission_preferences_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `mission_preferences_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `mission_preferences_board_push_time_not_null`: `NOT NULL board_push_time`
- `mission_preferences_created_at_not_null`: `NOT NULL created_at`
- `mission_preferences_disabled_categories_not_null`: `NOT NULL disabled_categories`
- `mission_preferences_evening_carry_over_not_null`: `NOT NULL evening_carry_over`
- `mission_preferences_family_id_not_null`: `NOT NULL family_id`
- `mission_preferences_updated_at_not_null`: `NOT NULL updated_at`
- `mission_preferences_user_id_not_null`: `NOT NULL user_id`
- `mission_preferences_pkey`: `PRIMARY KEY (family_id, user_id)`

Indexes:

- `mission_preferences_pkey`: `CREATE UNIQUE INDEX mission_preferences_pkey ON app.mission_preferences USING btree (family_id, user_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.mission_preferences FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.mission_preferences FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.mission_series — MissionSeries

| Cột                 | PostgreSQL type             | NOT NULL | Default                               |
| ------------------- | --------------------------- | -------- | ------------------------------------- |
| id                  | uuid                        | Có       | uuidv7()                              |
| family_id           | uuid                        | Có       | —                                     |
| created_by          | uuid                        | Có       | —                                     |
| owner_kind          | app.mission_owner_kind      | Có       | —                                     |
| owner_user_id       | uuid                        | Không    | —                                     |
| template_id         | uuid                        | Không    | —                                     |
| title               | character varying(120)      | Có       | —                                     |
| note                | character varying(500)      | Không    | —                                     |
| category            | app.mission_category        | Có       | —                                     |
| target_scope        | app.mission_scope           | Có       | —                                     |
| hearts              | smallint                    | Có       | —                                     |
| rrule               | text                        | Có       | —                                     |
| time_of_day         | time without time zone      | Không    | —                                     |
| reminder_offset_min | smallint                    | Không    | —                                     |
| start_date          | date                        | Có       | —                                     |
| end_date            | date                        | Không    | —                                     |
| paused_ranges       | jsonb                       | Có       | '[]'::jsonb                           |
| generated_until     | date                        | Không    | —                                     |
| status              | character varying(10)       | Có       | 'ACTIVE'::character varying           |
| created_at          | timestamp(3) with time zone | Có       | now()                                 |
| version             | integer                     | Có       | 1                                     |
| updated_at          | timestamp(3) with time zone | Có       | now()                                 |
| deleted_at          | timestamp(3) with time zone | Không    | NULL::timestamp with time zone        |
| timezone            | character varying(64)       | Có       | 'Asia/Ho_Chi_Minh'::character varying |

Constraints:

- `mission_series_check`: `CHECK (((owner_kind = 'PARENT'::app.mission_owner_kind) = (owner_user_id IS NOT NULL)))`
- `mission_series_check1`: `CHECK (((owner_kind = 'TOGETHER'::app.mission_owner_kind) OR (owner_user_id = created_by)))`
- `mission_series_check2`: `CHECK (((target_scope <> 'COUPLE'::app.mission_scope) OR (owner_kind = 'TOGETHER'::app.mission_owner_kind)))`
- `mission_series_check3`: `CHECK (((template_id IS NOT NULL) OR (hearts = 2)))`
- `mission_series_check4`: `CHECK (((end_date IS NULL) OR (end_date >= start_date)))`
- `mission_series_hearts_check`: `CHECK (((hearts >= 1) AND (hearts <= 10)))`
- `mission_series_created_by_fkey`: `FOREIGN KEY (created_by) REFERENCES app.users(id)`
- `mission_series_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `mission_series_owner_user_id_fkey`: `FOREIGN KEY (owner_user_id) REFERENCES app.users(id)`
- `mission_series_template_id_fkey`: `FOREIGN KEY (template_id) REFERENCES app.mission_templates(id)`
- `mission_series_category_not_null`: `NOT NULL category`
- `mission_series_created_at_not_null`: `NOT NULL created_at`
- `mission_series_created_by_not_null`: `NOT NULL created_by`
- `mission_series_family_id_not_null`: `NOT NULL family_id`
- `mission_series_hearts_not_null`: `NOT NULL hearts`
- `mission_series_id_not_null`: `NOT NULL id`
- `mission_series_owner_kind_not_null`: `NOT NULL owner_kind`
- `mission_series_paused_ranges_not_null`: `NOT NULL paused_ranges`
- `mission_series_rrule_not_null`: `NOT NULL rrule`
- `mission_series_start_date_not_null`: `NOT NULL start_date`
- `mission_series_status_not_null`: `NOT NULL status`
- `mission_series_target_scope_not_null`: `NOT NULL target_scope`
- `mission_series_timezone_not_null`: `NOT NULL timezone`
- `mission_series_title_not_null`: `NOT NULL title`
- `mission_series_updated_at_not_null`: `NOT NULL updated_at`
- `mission_series_version_not_null`: `NOT NULL version`
- `mission_series_pkey`: `PRIMARY KEY (id)`
- `mission_series_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `mission_series_id_family_id_key`: `CREATE UNIQUE INDEX mission_series_id_family_id_key ON app.mission_series USING btree (id, family_id)`
- `mission_series_pkey`: `CREATE UNIQUE INDEX mission_series_pkey ON app.mission_series USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.mission_series FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.mission_series FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.mission_series_children — MissionSeriesChild

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| series_id  | uuid                        | Có       | —                              |
| child_id   | uuid                        | Có       | —                              |
| family_id  | uuid                        | Có       | —                              |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `mission_series_children_child_id_family_id_fkey`: `FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)`
- `mission_series_children_series_id_family_id_fkey`: `FOREIGN KEY (series_id, family_id) REFERENCES app.mission_series(id, family_id)`
- `mission_series_children_child_id_not_null`: `NOT NULL child_id`
- `mission_series_children_created_at_not_null`: `NOT NULL created_at`
- `mission_series_children_family_id_not_null`: `NOT NULL family_id`
- `mission_series_children_series_id_not_null`: `NOT NULL series_id`
- `mission_series_children_updated_at_not_null`: `NOT NULL updated_at`
- `mission_series_children_pkey`: `PRIMARY KEY (series_id, child_id)`

Indexes:

- `mission_series_children_pkey`: `CREATE UNIQUE INDEX mission_series_children_pkey ON app.mission_series_children USING btree (series_id, child_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.mission_series_children FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.mission_series_children FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.mission_templates — MissionTemplate

| Cột                | PostgreSQL type             | NOT NULL | Default                            |
| ------------------ | --------------------------- | -------- | ---------------------------------- |
| id                 | uuid                        | Có       | uuidv7()                           |
| code               | character varying(20)       | Có       | —                                  |
| stage              | character varying(10)       | Có       | —                                  |
| min_age_days       | integer                     | Không    | —                                  |
| max_age_days       | integer                     | Không    | —                                  |
| min_preg_week      | smallint                    | Không    | —                                  |
| max_preg_week      | smallint                    | Không    | —                                  |
| category           | app.mission_category        | Có       | —                                  |
| suggested_scope    | app.mission_scope           | Có       | —                                  |
| role_fit           | app.mission_role_fit        | Có       | 'ANY_PARENT'::app.mission_role_fit |
| hearts             | smallint                    | Có       | —                                  |
| duration_min       | smallint                    | Có       | —                                  |
| multi_child_ok     | boolean                     | Có       | true                               |
| requestable        | boolean                     | Có       | true                               |
| title_i18n         | jsonb                       | Có       | —                                  |
| desc_i18n          | jsonb                       | Không    | —                                  |
| memory_prompt_i18n | jsonb                       | Không    | —                                  |
| tags               | text[]                      | Có       | '{}'::text[]                       |
| weight             | smallint                    | Có       | 10                                 |
| rollout_pct        | smallint                    | Có       | 100                                |
| status             | character varying(10)       | Có       | 'ACTIVE'::character varying        |
| version            | integer                     | Có       | 1                                  |
| updated_at         | timestamp(3) with time zone | Có       | now()                              |
| created_at         | timestamp(3) with time zone | Có       | now()                              |
| deleted_at         | timestamp(3) with time zone | Không    | NULL::timestamp with time zone     |

Constraints:

- `mission_templates_category_check`: `CHECK ((category <> 'CUSTOM'::app.mission_category))`
- `mission_templates_check`: `CHECK (((suggested_scope <> 'COUPLE'::app.mission_scope) OR (role_fit = 'TOGETHER'::app.mission_role_fit)))`
- `mission_templates_check1`: `CHECK (((duration_min > 0) AND (weight > 0) AND ((rollout_pct >= 0) AND (rollout_pct <= 100))))`
- `mission_templates_hearts_check`: `CHECK (((hearts >= 1) AND (hearts <= 10)))`
- `mission_templates_category_not_null`: `NOT NULL category`
- `mission_templates_code_not_null`: `NOT NULL code`
- `mission_templates_created_at_not_null`: `NOT NULL created_at`
- `mission_templates_duration_min_not_null`: `NOT NULL duration_min`
- `mission_templates_hearts_not_null`: `NOT NULL hearts`
- `mission_templates_id_not_null`: `NOT NULL id`
- `mission_templates_multi_child_ok_not_null`: `NOT NULL multi_child_ok`
- `mission_templates_requestable_not_null`: `NOT NULL requestable`
- `mission_templates_role_fit_not_null`: `NOT NULL role_fit`
- `mission_templates_rollout_pct_not_null`: `NOT NULL rollout_pct`
- `mission_templates_stage_not_null`: `NOT NULL stage`
- `mission_templates_status_not_null`: `NOT NULL status`
- `mission_templates_suggested_scope_not_null`: `NOT NULL suggested_scope`
- `mission_templates_tags_not_null`: `NOT NULL tags`
- `mission_templates_title_i18n_not_null`: `NOT NULL title_i18n`
- `mission_templates_updated_at_not_null`: `NOT NULL updated_at`
- `mission_templates_version_not_null`: `NOT NULL version`
- `mission_templates_weight_not_null`: `NOT NULL weight`
- `mission_templates_pkey`: `PRIMARY KEY (id)`
- `mission_templates_code_key`: `UNIQUE (code)`

Indexes:

- `ix_tpl_hearts`: `CREATE INDEX ix_tpl_hearts ON app.mission_templates USING btree (category, hearts) WHERE (((status)::text = 'ACTIVE'::text) AND (deleted_at IS NULL))`
- `ix_tpl_pick`: `CREATE INDEX ix_tpl_pick ON app.mission_templates USING btree (stage, role_fit, category) WHERE (((status)::text = 'ACTIVE'::text) AND (deleted_at IS NULL))`
- `mission_templates_code_key`: `CREATE UNIQUE INDEX mission_templates_code_key ON app.mission_templates USING btree (code)`
- `mission_templates_pkey`: `CREATE UNIQUE INDEX mission_templates_pkey ON app.mission_templates USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.mission_templates FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## app.missions — Mission

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| id              | uuid                        | Có       | uuidv7()                       |
| family_id       | uuid                        | Có       | —                              |
| board_date      | date                        | Có       | —                              |
| owner_kind      | app.mission_owner_kind      | Có       | —                              |
| owner_user_id   | uuid                        | Không    | —                              |
| source          | app.mission_source          | Có       | —                              |
| template_id     | uuid                        | Không    | —                              |
| series_id       | uuid                        | Không    | —                              |
| swapped_from_id | uuid                        | Không    | —                              |
| swap_count      | smallint                    | Có       | 0                              |
| ref_type        | character varying(20)       | Không    | —                              |
| ref_id          | uuid                        | Không    | —                              |
| title           | character varying(120)      | Có       | —                              |
| note            | character varying(500)      | Không    | —                              |
| category        | app.mission_category        | Có       | —                              |
| target_scope    | app.mission_scope           | Có       | —                              |
| hearts          | smallint                    | Có       | —                              |
| status          | app.mission_status          | Có       | 'TODO'::app.mission_status     |
| scheduled_time  | time without time zone      | Không    | —                              |
| due_at          | timestamp(3) with time zone | Không    | —                              |
| reminder_at     | timestamp(3) with time zone | Không    | —                              |
| memory_prompt   | boolean                     | Có       | true                           |
| completed_by    | uuid                        | Không    | —                              |
| completed_at    | timestamp(3) with time zone | Không    | —                              |
| late            | boolean                     | Có       | false                          |
| removed_reason  | character varying(15)       | Không    | —                              |
| removed_at      | timestamp(3) with time zone | Không    | —                              |
| created_by      | uuid                        | Không    | —                              |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| version         | integer                     | Có       | 1                              |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `missions_check`: `CHECK (((owner_kind = 'PARENT'::app.mission_owner_kind) = (owner_user_id IS NOT NULL)))`
- `missions_check1`: `CHECK (((source = ANY (ARRAY['SYSTEM'::app.mission_source, 'SERIES'::app.mission_source])) OR (owner_kind = 'TOGETHER'::app.mission_owner_kind) OR (owner_user_id = created_by)))`
- `missions_check10`: `CHECK (((status = 'DONE'::app.mission_status) OR ((completed_at IS NULL) AND (completed_by IS NULL))))`
- `missions_check2`: `CHECK (((source = 'SERIES'::app.mission_source) = (series_id IS NOT NULL)))`
- `missions_check3`: `CHECK (((source <> 'CUSTOM'::app.mission_source) OR ((template_id IS NULL) AND (hearts = 2))))`
- `missions_check4`: `CHECK (((target_scope <> 'COUPLE'::app.mission_scope) OR (owner_kind = 'TOGETHER'::app.mission_owner_kind)))`
- `missions_check5`: `CHECK (((status = 'DONE'::app.mission_status) = ((completed_at IS NOT NULL) AND (completed_by IS NOT NULL))))`
- `missions_check6`: `CHECK (((NOT late) OR (status = 'DONE'::app.mission_status)))`
- `missions_check7`: `CHECK (((status = 'REMOVED'::app.mission_status) = (removed_reason IS NOT NULL)))`
- `missions_check8`: `CHECK (((swap_count >= 0) AND (version > 0)))`
- `missions_check9`: `CHECK (((source = ANY (ARRAY['SYSTEM'::app.mission_source, 'SERIES'::app.mission_source])) OR (created_by IS NOT NULL)))`
- `missions_hearts_check`: `CHECK (((hearts >= 1) AND (hearts <= 10)))`
- `missions_completed_by_fkey`: `FOREIGN KEY (completed_by) REFERENCES app.users(id)`
- `missions_created_by_fkey`: `FOREIGN KEY (created_by) REFERENCES app.users(id)`
- `missions_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `missions_owner_user_id_fkey`: `FOREIGN KEY (owner_user_id) REFERENCES app.users(id)`
- `missions_series_id_family_id_fkey`: `FOREIGN KEY (series_id, family_id) REFERENCES app.mission_series(id, family_id)`
- `missions_swapped_from_id_family_id_fkey`: `FOREIGN KEY (swapped_from_id, family_id) REFERENCES app.missions(id, family_id)`
- `missions_template_id_fkey`: `FOREIGN KEY (template_id) REFERENCES app.mission_templates(id)`
- `missions_board_date_not_null`: `NOT NULL board_date`
- `missions_category_not_null`: `NOT NULL category`
- `missions_created_at_not_null`: `NOT NULL created_at`
- `missions_family_id_not_null`: `NOT NULL family_id`
- `missions_hearts_not_null`: `NOT NULL hearts`
- `missions_id_not_null`: `NOT NULL id`
- `missions_late_not_null`: `NOT NULL late`
- `missions_memory_prompt_not_null`: `NOT NULL memory_prompt`
- `missions_owner_kind_not_null`: `NOT NULL owner_kind`
- `missions_source_not_null`: `NOT NULL source`
- `missions_status_not_null`: `NOT NULL status`
- `missions_swap_count_not_null`: `NOT NULL swap_count`
- `missions_target_scope_not_null`: `NOT NULL target_scope`
- `missions_title_not_null`: `NOT NULL title`
- `missions_updated_at_not_null`: `NOT NULL updated_at`
- `missions_version_not_null`: `NOT NULL version`
- `missions_pkey`: `PRIMARY KEY (id)`
- `trg_mission_scope_m`: `TRIGGER DEFERRABLE INITIALLY DEFERRED`
- `missions_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `ix_missions_board`: `CREATE INDEX ix_missions_board ON app.missions USING btree (family_id, board_date, owner_kind, owner_user_id) WHERE ((status <> 'REMOVED'::app.mission_status) AND (deleted_at IS NULL))`
- `ix_missions_due`: `CREATE INDEX ix_missions_due ON app.missions USING btree (due_at) WHERE ((status = 'TODO'::app.mission_status) AND (due_at IS NOT NULL) AND (deleted_at IS NULL))`
- `ix_missions_expire`: `CREATE INDEX ix_missions_expire ON app.missions USING btree (board_date) WHERE ((status = 'TODO'::app.mission_status) AND (deleted_at IS NULL))`
- `ix_missions_history`: `CREATE INDEX ix_missions_history ON app.missions USING btree (family_id, owner_user_id, board_date DESC) WHERE ((status = ANY (ARRAY['DONE'::app.mission_status, 'EXPIRED'::app.mission_status])) AND (deleted_at IS NULL))`
- `ix_missions_tpl_recent`: `CREATE INDEX ix_missions_tpl_recent ON app.missions USING btree (family_id, board_date, template_id) WHERE ((template_id IS NOT NULL) AND (deleted_at IS NULL))`
- `missions_id_family_id_key`: `CREATE UNIQUE INDEX missions_id_family_id_key ON app.missions USING btree (id, family_id)`
- `missions_pkey`: `CREATE UNIQUE INDEX missions_pkey ON app.missions USING btree (id)`
- `uq_board_template`: `CREATE UNIQUE INDEX uq_board_template ON app.missions USING btree (family_id, board_date, template_id) WHERE ((source = 'SYSTEM'::app.mission_source) AND (status <> 'REMOVED'::app.mission_status) AND (deleted_at IS NULL))`
- `uq_series_day`: `CREATE UNIQUE INDEX uq_series_day ON app.missions USING btree (series_id, board_date) WHERE ((series_id IS NOT NULL) AND (status <> 'REMOVED'::app.mission_status) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.missions FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.missions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_mission_scope_m`: `CREATE CONSTRAINT TRIGGER trg_mission_scope_m AFTER INSERT OR UPDATE ON app.missions DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION app.check_mission_scope()`

## app.monthly_photos — MonthlyPhoto

| Cột          | PostgreSQL type             | NOT NULL | Default                        |
| ------------ | --------------------------- | -------- | ------------------------------ |
| id           | uuid                        | Có       | uuidv7()                       |
| family_id    | uuid                        | Có       | —                              |
| child_id     | uuid                        | Không    | —                              |
| month_index  | smallint                    | Không    | —                              |
| pregnancy_id | uuid                        | Không    | —                              |
| preg_week    | smallint                    | Không    | —                              |
| memory_id    | uuid                        | Có       | —                              |
| asset_id     | uuid                        | Có       | —                              |
| sticker      | jsonb                       | Không    | —                              |
| set_by       | uuid                        | Có       | —                              |
| set_at       | timestamp(3) with time zone | Có       | now()                          |
| created_at   | timestamp(3) with time zone | Có       | now()                          |
| updated_at   | timestamp(3) with time zone | Có       | now()                          |
| deleted_at   | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `monthly_photos_check`: `CHECK ((((child_id IS NOT NULL) AND (month_index IS NOT NULL) AND (pregnancy_id IS NULL) AND (preg_week IS NULL)) OR ((pregnancy_id IS NOT NULL) AND (preg_week IS NOT NULL) AND (child_id IS NULL) AND (month_index IS NULL))))`
- `monthly_photos_month_index_check`: `CHECK (((month_index >= 0) AND (month_index <= 240)))`
- `monthly_photos_preg_week_check`: `CHECK (((preg_week >= 4) AND (preg_week <= 42)))`
- `monthly_photos_child_id_family_id_fkey`: `FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)`
- `monthly_photos_memory_id_asset_id_fkey`: `FOREIGN KEY (memory_id, asset_id) REFERENCES app.memory_assets(memory_id, asset_id) ON DELETE CASCADE`
- `monthly_photos_memory_id_family_id_fkey`: `FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE`
- `monthly_photos_pregnancy_id_family_id_fkey`: `FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id)`
- `monthly_photos_set_by_fkey`: `FOREIGN KEY (set_by) REFERENCES app.users(id)`
- `monthly_photos_asset_id_not_null`: `NOT NULL asset_id`
- `monthly_photos_created_at_not_null`: `NOT NULL created_at`
- `monthly_photos_family_id_not_null`: `NOT NULL family_id`
- `monthly_photos_id_not_null`: `NOT NULL id`
- `monthly_photos_memory_id_not_null`: `NOT NULL memory_id`
- `monthly_photos_set_at_not_null`: `NOT NULL set_at`
- `monthly_photos_set_by_not_null`: `NOT NULL set_by`
- `monthly_photos_updated_at_not_null`: `NOT NULL updated_at`
- `monthly_photos_pkey`: `PRIMARY KEY (id)`

Indexes:

- `monthly_photos_pkey`: `CREATE UNIQUE INDEX monthly_photos_pkey ON app.monthly_photos USING btree (id)`
- `uq_bump_week`: `CREATE UNIQUE INDEX uq_bump_week ON app.monthly_photos USING btree (pregnancy_id, preg_week) WHERE ((pregnancy_id IS NOT NULL) AND (deleted_at IS NULL))`
- `uq_monthly_child`: `CREATE UNIQUE INDEX uq_monthly_child ON app.monthly_photos USING btree (child_id, month_index) WHERE ((child_id IS NOT NULL) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.monthly_photos FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.monthly_photos FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.notification_deliveries — NotificationDelivery

| Cột                 | PostgreSQL type             | NOT NULL | Default                        |
| ------------------- | --------------------------- | -------- | ------------------------------ |
| id                  | uuid                        | Có       | uuidv7()                       |
| notification_id     | uuid                        | Có       | —                              |
| channel             | character varying(10)       | Có       | —                              |
| device_id           | uuid                        | Không    | —                              |
| target_key          | character varying(255)      | Có       | —                              |
| status              | character varying(16)       | Có       | 'PENDING'::character varying   |
| attempts            | integer                     | Có       | 0                              |
| next_attempt_at     | timestamp(3) with time zone | Không    | —                              |
| sent_at             | timestamp(3) with time zone | Không    | —                              |
| provider_message_id | character varying(255)      | Không    | —                              |
| last_error_code     | character varying(80)       | Không    | —                              |
| created_at          | timestamp(3) with time zone | Có       | now()                          |
| updated_at          | timestamp(3) with time zone | Có       | now()                          |
| deleted_at          | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `notification_deliveries_attempts_check`: `CHECK ((attempts >= 0))`
- `notification_deliveries_channel_check`: `CHECK (((channel)::text = ANY ((ARRAY['INBOX'::character varying, 'PUSH'::character varying, 'EMAIL'::character varying, 'SMS'::character varying])::text[])))`
- `notification_deliveries_status_check`: `CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'SENT'::character varying, 'RETRY_WAIT'::character varying, 'FAILED'::character varying, 'CANCELLED'::character varying])::text[])))`
- `notification_deliveries_device_id_fkey`: `FOREIGN KEY (device_id) REFERENCES app.user_devices(id)`
- `notification_deliveries_notification_id_fkey`: `FOREIGN KEY (notification_id) REFERENCES app.notifications(id)`
- `notification_deliveries_attempts_not_null`: `NOT NULL attempts`
- `notification_deliveries_channel_not_null`: `NOT NULL channel`
- `notification_deliveries_created_at_not_null`: `NOT NULL created_at`
- `notification_deliveries_id_not_null`: `NOT NULL id`
- `notification_deliveries_notification_id_not_null`: `NOT NULL notification_id`
- `notification_deliveries_status_not_null`: `NOT NULL status`
- `notification_deliveries_target_key_not_null`: `NOT NULL target_key`
- `notification_deliveries_updated_at_not_null`: `NOT NULL updated_at`
- `notification_deliveries_pkey`: `PRIMARY KEY (id)`
- `notification_deliveries_notification_id_channel_target_key_key`: `UNIQUE (notification_id, channel, target_key)`

Indexes:

- `ix_notification_delivery_pending`: `CREATE INDEX ix_notification_delivery_pending ON app.notification_deliveries USING btree (next_attempt_at, id) WHERE (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'RETRY_WAIT'::character varying])::text[])) AND (deleted_at IS NULL))`
- `notification_deliveries_notification_id_channel_target_key_key`: `CREATE UNIQUE INDEX notification_deliveries_notification_id_channel_target_key_key ON app.notification_deliveries USING btree (notification_id, channel, target_key)`
- `notification_deliveries_pkey`: `CREATE UNIQUE INDEX notification_deliveries_pkey ON app.notification_deliveries USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.notification_deliveries FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## app.notification_delivery_attempts — NotificationDeliveryAttempt

| Cột                  | PostgreSQL type             | NOT NULL | Default                        |
| -------------------- | --------------------------- | -------- | ------------------------------ |
| id                   | uuid                        | Có       | uuidv7()                       |
| delivery_id          | uuid                        | Có       | —                              |
| attempt_number       | integer                     | Có       | —                              |
| started_at           | timestamp(3) with time zone | Có       | now()                          |
| finished_at          | timestamp(3) with time zone | Không    | —                              |
| outcome              | character varying(20)       | Không    | —                              |
| provider_status_code | character varying(40)       | Không    | —                              |
| error_code           | character varying(80)       | Không    | —                              |
| created_at           | timestamp(3) with time zone | Có       | now()                          |
| updated_at           | timestamp(3) with time zone | Có       | now()                          |
| deleted_at           | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `notification_delivery_attempts_attempt_number_check`: `CHECK ((attempt_number > 0))`
- `notification_delivery_attempts_delivery_id_fkey`: `FOREIGN KEY (delivery_id) REFERENCES app.notification_deliveries(id)`
- `notification_delivery_attempts_attempt_number_not_null`: `NOT NULL attempt_number`
- `notification_delivery_attempts_created_at_not_null`: `NOT NULL created_at`
- `notification_delivery_attempts_delivery_id_not_null`: `NOT NULL delivery_id`
- `notification_delivery_attempts_id_not_null`: `NOT NULL id`
- `notification_delivery_attempts_started_at_not_null`: `NOT NULL started_at`
- `notification_delivery_attempts_updated_at_not_null`: `NOT NULL updated_at`
- `notification_delivery_attempts_pkey`: `PRIMARY KEY (id)`
- `notification_delivery_attempts_delivery_id_attempt_number_key`: `UNIQUE (delivery_id, attempt_number)`

Indexes:

- `notification_delivery_attempts_delivery_id_attempt_number_key`: `CREATE UNIQUE INDEX notification_delivery_attempts_delivery_id_attempt_number_key ON app.notification_delivery_attempts USING btree (delivery_id, attempt_number)`
- `notification_delivery_attempts_pkey`: `CREATE UNIQUE INDEX notification_delivery_attempts_pkey ON app.notification_delivery_attempts USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.notification_delivery_attempts FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## app.notifications — Notification

| Cột               | PostgreSQL type             | NOT NULL | Default                        |
| ----------------- | --------------------------- | -------- | ------------------------------ |
| id                | uuid                        | Có       | uuidv7()                       |
| family_id         | uuid                        | Không    | —                              |
| recipient_user_id | uuid                        | Có       | —                              |
| event_id          | uuid                        | Có       | —                              |
| template_code     | character varying(40)       | Có       | —                              |
| category          | character varying(30)       | Có       | —                              |
| priority          | character varying(10)       | Có       | 'NORMAL'::character varying    |
| locale            | character varying(10)       | Có       | 'vi'::character varying        |
| subject_type      | character varying(80)       | Không    | —                              |
| subject_id        | uuid                        | Không    | —                              |
| payload_reference | jsonb                       | Có       | '{}'::jsonb                    |
| sensitive         | boolean                     | Có       | false                          |
| read_at           | timestamp(3) with time zone | Không    | —                              |
| dismissed_at      | timestamp(3) with time zone | Không    | —                              |
| expires_at        | timestamp(3) with time zone | Không    | —                              |
| created_at        | timestamp(3) with time zone | Có       | now()                          |
| updated_at        | timestamp(3) with time zone | Có       | now()                          |
| deleted_at        | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `notifications_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `notifications_recipient_user_id_fkey`: `FOREIGN KEY (recipient_user_id) REFERENCES app.users(id)`
- `notifications_category_not_null`: `NOT NULL category`
- `notifications_created_at_not_null`: `NOT NULL created_at`
- `notifications_event_id_not_null`: `NOT NULL event_id`
- `notifications_id_not_null`: `NOT NULL id`
- `notifications_locale_not_null`: `NOT NULL locale`
- `notifications_payload_reference_not_null`: `NOT NULL payload_reference`
- `notifications_priority_not_null`: `NOT NULL priority`
- `notifications_recipient_user_id_not_null`: `NOT NULL recipient_user_id`
- `notifications_sensitive_not_null`: `NOT NULL sensitive`
- `notifications_template_code_not_null`: `NOT NULL template_code`
- `notifications_updated_at_not_null`: `NOT NULL updated_at`
- `notifications_pkey`: `PRIMARY KEY (id)`
- `notifications_event_id_recipient_user_id_template_code_key`: `UNIQUE (event_id, recipient_user_id, template_code)`

Indexes:

- `ix_notification_inbox`: `CREATE INDEX ix_notification_inbox ON app.notifications USING btree (recipient_user_id, created_at DESC, id DESC) WHERE (deleted_at IS NULL)`
- `notifications_event_id_recipient_user_id_template_code_key`: `CREATE UNIQUE INDEX notifications_event_id_recipient_user_id_template_code_key ON app.notifications USING btree (event_id, recipient_user_id, template_code)`
- `notifications_pkey`: `CREATE UNIQUE INDEX notifications_pkey ON app.notifications USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.notifications FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.notifications FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.pregnancies — Pregnancy

| Cột                | PostgreSQL type             | NOT NULL | Default                        |
| ------------------ | --------------------------- | -------- | ------------------------------ |
| id                 | uuid                        | Có       | uuidv7()                       |
| family_id          | uuid                        | Có       | —                              |
| seq_no             | smallint                    | Có       | —                              |
| nickname           | character varying(40)       | Có       | —                              |
| due_date           | date                        | Không    | —                              |
| expected_count     | smallint                    | Có       | 1                              |
| status             | app.pregnancy_status        | Có       | 'ACTIVE'::app.pregnancy_status |
| cover_asset_id     | uuid                        | Không    | —                              |
| show_size_content  | boolean                     | Có       | true                           |
| carrier_user_id    | uuid                        | Không    | —                              |
| bump_photo_cadence | character varying(10)       | Có       | 'WEEKLY'::character varying    |
| created_by         | uuid                        | Có       | —                              |
| created_at         | timestamp(3) with time zone | Có       | now()                          |
| updated_at         | timestamp(3) with time zone | Có       | now()                          |
| completed_at       | timestamp(3) with time zone | Không    | —                              |
| version            | integer                     | Có       | 1                              |
| deleted_at         | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `pregnancies_bump_photo_cadence_check`: `CHECK (((bump_photo_cadence)::text = ANY ((ARRAY['WEEKLY'::character varying, 'EVERY_4W'::character varying, 'OFF'::character varying])::text[])))`
- `pregnancies_expected_count_check`: `CHECK (((expected_count >= 1) AND (expected_count <= 4)))`
- `pregnancies_seq_no_check`: `CHECK ((seq_no > 0))`
- `pregnancies_carrier_user_id_fkey`: `FOREIGN KEY (carrier_user_id) REFERENCES app.users(id)`
- `pregnancies_cover_asset_id_family_id_fkey`: `FOREIGN KEY (cover_asset_id, family_id) REFERENCES app.assets(id, family_id)`
- `pregnancies_created_by_fkey`: `FOREIGN KEY (created_by) REFERENCES app.users(id)`
- `pregnancies_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `pregnancies_bump_photo_cadence_not_null`: `NOT NULL bump_photo_cadence`
- `pregnancies_created_at_not_null`: `NOT NULL created_at`
- `pregnancies_created_by_not_null`: `NOT NULL created_by`
- `pregnancies_expected_count_not_null`: `NOT NULL expected_count`
- `pregnancies_family_id_not_null`: `NOT NULL family_id`
- `pregnancies_id_not_null`: `NOT NULL id`
- `pregnancies_nickname_not_null`: `NOT NULL nickname`
- `pregnancies_seq_no_not_null`: `NOT NULL seq_no`
- `pregnancies_show_size_content_not_null`: `NOT NULL show_size_content`
- `pregnancies_status_not_null`: `NOT NULL status`
- `pregnancies_updated_at_not_null`: `NOT NULL updated_at`
- `pregnancies_version_not_null`: `NOT NULL version`
- `pregnancies_pkey`: `PRIMARY KEY (id)`
- `pregnancies_family_id_seq_no_key`: `UNIQUE (family_id, seq_no)`
- `pregnancies_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `pregnancies_family_id_seq_no_key`: `CREATE UNIQUE INDEX pregnancies_family_id_seq_no_key ON app.pregnancies USING btree (family_id, seq_no)`
- `pregnancies_id_family_id_key`: `CREATE UNIQUE INDEX pregnancies_id_family_id_key ON app.pregnancies USING btree (id, family_id)`
- `pregnancies_pkey`: `CREATE UNIQUE INDEX pregnancies_pkey ON app.pregnancies USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.pregnancies FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.pregnancies FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.prep_items — PrepItem

| Cột          | PostgreSQL type             | NOT NULL | Default                        |
| ------------ | --------------------------- | -------- | ------------------------------ |
| id           | uuid                        | Có       | uuidv7()                       |
| family_id    | uuid                        | Có       | —                              |
| pregnancy_id | uuid                        | Có       | —                              |
| group_code   | character varying(20)       | Có       | —                              |
| title        | character varying(120)      | Có       | —                              |
| sort_order   | integer                     | Có       | 0                              |
| done_at      | timestamp(3) with time zone | Không    | —                              |
| done_by      | uuid                        | Không    | —                              |
| mission_id   | uuid                        | Không    | —                              |
| created_at   | timestamp(3) with time zone | Có       | now()                          |
| updated_at   | timestamp(3) with time zone | Có       | now()                          |
| deleted_at   | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `prep_items_done_by_fkey`: `FOREIGN KEY (done_by) REFERENCES app.users(id)`
- `prep_items_mission_id_family_id_fkey`: `FOREIGN KEY (mission_id, family_id) REFERENCES app.missions(id, family_id)`
- `prep_items_pregnancy_id_family_id_fkey`: `FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id)`
- `prep_items_created_at_not_null`: `NOT NULL created_at`
- `prep_items_family_id_not_null`: `NOT NULL family_id`
- `prep_items_group_code_not_null`: `NOT NULL group_code`
- `prep_items_id_not_null`: `NOT NULL id`
- `prep_items_pregnancy_id_not_null`: `NOT NULL pregnancy_id`
- `prep_items_sort_order_not_null`: `NOT NULL sort_order`
- `prep_items_title_not_null`: `NOT NULL title`
- `prep_items_updated_at_not_null`: `NOT NULL updated_at`
- `prep_items_pkey`: `PRIMARY KEY (id)`
- `prep_items_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `prep_items_id_family_id_key`: `CREATE UNIQUE INDEX prep_items_id_family_id_key ON app.prep_items USING btree (id, family_id)`
- `prep_items_pkey`: `CREATE UNIQUE INDEX prep_items_pkey ON app.prep_items USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.prep_items FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.prep_items FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.reactions — Reaction

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| memory_id  | uuid                        | Có       | —                              |
| user_id    | uuid                        | Có       | —                              |
| type       | app.reaction_type           | Có       | —                              |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| family_id  | uuid                        | Có       | —                              |

Constraints:

- `reactions_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `reactions_memory_id_family_id_fkey`: `FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id)`
- `reactions_memory_id_fkey`: `FOREIGN KEY (memory_id) REFERENCES app.memories(id) ON DELETE CASCADE`
- `reactions_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `reactions_created_at_not_null`: `NOT NULL created_at`
- `reactions_family_id_not_null`: `NOT NULL family_id`
- `reactions_memory_id_not_null`: `NOT NULL memory_id`
- `reactions_type_not_null`: `NOT NULL type`
- `reactions_updated_at_not_null`: `NOT NULL updated_at`
- `reactions_user_id_not_null`: `NOT NULL user_id`
- `reactions_pkey`: `PRIMARY KEY (memory_id, user_id)`

Indexes:

- `reactions_pkey`: `CREATE UNIQUE INDEX reactions_pkey ON app.reactions USING btree (memory_id, user_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.reactions FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.reactions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.recaps — Recap

| Cột                  | PostgreSQL type             | NOT NULL | Default                        |
| -------------------- | --------------------------- | -------- | ------------------------------ |
| id                   | uuid                        | Có       | uuidv7()                       |
| family_id            | uuid                        | Có       | —                              |
| scope                | character varying(10)       | Có       | —                              |
| child_id             | uuid                        | Không    | —                              |
| period               | character varying(12)       | Có       | —                              |
| period_start         | date                        | Có       | —                              |
| period_end           | date                        | Có       | —                              |
| status               | character varying(12)       | Có       | 'READY'::character varying     |
| content              | jsonb                       | Có       | —                              |
| content_parents_only | jsonb                       | Không    | —                              |
| cover_asset_id       | uuid                        | Không    | —                              |
| visibility           | app.visibility              | Có       | 'PARENTS'::app.visibility      |
| memory_id            | uuid                        | Không    | —                              |
| created_at           | timestamp(3) with time zone | Có       | now()                          |
| updated_at           | timestamp(3) with time zone | Có       | now()                          |
| deleted_at           | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `recaps_check`: `CHECK (((((scope)::text = 'FAMILY'::text) AND (child_id IS NULL)) OR (((scope)::text = 'CHILD'::text) AND (child_id IS NOT NULL))))`
- `recaps_check1`: `CHECK ((period_end >= period_start))`
- `recaps_child_id_family_id_fkey`: `FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)`
- `recaps_cover_asset_id_family_id_fkey`: `FOREIGN KEY (cover_asset_id, family_id) REFERENCES app.assets(id, family_id)`
- `recaps_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `recaps_memory_id_family_id_fkey`: `FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id)`
- `recaps_content_not_null`: `NOT NULL content`
- `recaps_created_at_not_null`: `NOT NULL created_at`
- `recaps_family_id_not_null`: `NOT NULL family_id`
- `recaps_id_not_null`: `NOT NULL id`
- `recaps_period_end_not_null`: `NOT NULL period_end`
- `recaps_period_not_null`: `NOT NULL period`
- `recaps_period_start_not_null`: `NOT NULL period_start`
- `recaps_scope_not_null`: `NOT NULL scope`
- `recaps_status_not_null`: `NOT NULL status`
- `recaps_updated_at_not_null`: `NOT NULL updated_at`
- `recaps_visibility_not_null`: `NOT NULL visibility`
- `recaps_pkey`: `PRIMARY KEY (id)`
- `recaps_family_id_scope_child_id_period_period_start_key`: `UNIQUE NULLS NOT DISTINCT (family_id, scope, child_id, period, period_start)`
- `recaps_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `recaps_family_id_scope_child_id_period_period_start_key`: `CREATE UNIQUE INDEX recaps_family_id_scope_child_id_period_period_start_key ON app.recaps USING btree (family_id, scope, child_id, period, period_start) NULLS NOT DISTINCT`
- `recaps_id_family_id_key`: `CREATE UNIQUE INDEX recaps_id_family_id_key ON app.recaps USING btree (id, family_id)`
- `recaps_pkey`: `CREATE UNIQUE INDEX recaps_pkey ON app.recaps USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.recaps FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.recaps FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.report_hides — ReportHide

| Cột         | PostgreSQL type             | NOT NULL | Default                        |
| ----------- | --------------------------- | -------- | ------------------------------ |
| user_id     | uuid                        | Có       | —                              |
| target_type | app.report_target           | Có       | —                              |
| target_id   | uuid                        | Có       | —                              |
| created_at  | timestamp(3) with time zone | Có       | now()                          |
| updated_at  | timestamp(3) with time zone | Có       | now()                          |
| deleted_at  | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `report_hides_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `report_hides_created_at_not_null`: `NOT NULL created_at`
- `report_hides_target_id_not_null`: `NOT NULL target_id`
- `report_hides_target_type_not_null`: `NOT NULL target_type`
- `report_hides_updated_at_not_null`: `NOT NULL updated_at`
- `report_hides_user_id_not_null`: `NOT NULL user_id`
- `report_hides_pkey`: `PRIMARY KEY (user_id, target_type, target_id)`

Indexes:

- `report_hides_pkey`: `CREATE UNIQUE INDEX report_hides_pkey ON app.report_hides USING btree (user_id, target_type, target_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.report_hides FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## app.reports — Report

| Cột               | PostgreSQL type             | NOT NULL | Default                        |
| ----------------- | --------------------------- | -------- | ------------------------------ |
| id                | uuid                        | Có       | uuidv7()                       |
| reporter_user_id  | uuid                        | Có       | —                              |
| family_id         | uuid                        | Không    | —                              |
| target_type       | app.report_target           | Có       | —                              |
| target_id         | uuid                        | Có       | —                              |
| target_owner_id   | uuid                        | Không    | —                              |
| reason            | app.report_reason           | Có       | —                              |
| detail            | character varying(1000)     | Không    | —                              |
| severity          | smallint                    | Có       | 2                              |
| status            | app.report_status           | Có       | 'NEW'::app.report_status       |
| auto_hidden       | boolean                     | Có       | false                          |
| hide_for_reporter | boolean                     | Có       | false                          |
| sla_due_at        | timestamp(3) with time zone | Có       | —                              |
| created_at        | timestamp(3) with time zone | Có       | now()                          |
| closed_at         | timestamp(3) with time zone | Không    | —                              |
| updated_at        | timestamp(3) with time zone | Có       | now()                          |
| deleted_at        | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `reports_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `reports_reporter_user_id_fkey`: `FOREIGN KEY (reporter_user_id) REFERENCES app.users(id)`
- `reports_auto_hidden_not_null`: `NOT NULL auto_hidden`
- `reports_created_at_not_null`: `NOT NULL created_at`
- `reports_hide_for_reporter_not_null`: `NOT NULL hide_for_reporter`
- `reports_id_not_null`: `NOT NULL id`
- `reports_reason_not_null`: `NOT NULL reason`
- `reports_reporter_user_id_not_null`: `NOT NULL reporter_user_id`
- `reports_severity_not_null`: `NOT NULL severity`
- `reports_sla_due_at_not_null`: `NOT NULL sla_due_at`
- `reports_status_not_null`: `NOT NULL status`
- `reports_target_id_not_null`: `NOT NULL target_id`
- `reports_target_type_not_null`: `NOT NULL target_type`
- `reports_updated_at_not_null`: `NOT NULL updated_at`
- `reports_pkey`: `PRIMARY KEY (id)`

Indexes:

- `reports_pkey`: `CREATE UNIQUE INDEX reports_pkey ON app.reports USING btree (id)`
- `reports_status_severity_created_at_idx`: `CREATE INDEX reports_status_severity_created_at_idx ON app.reports USING btree (status, severity, created_at)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.reports FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.reports FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.storage_reservations — StorageReservation

| Cột               | PostgreSQL type             | NOT NULL | Default                        |
| ----------------- | --------------------------- | -------- | ------------------------------ |
| id                | uuid                        | Có       | uuidv7()                       |
| family_id         | uuid                        | Có       | —                              |
| asset_id          | uuid                        | Có       | —                              |
| requester_user_id | uuid                        | Không    | —                              |
| idempotency_key   | uuid                        | Có       | —                              |
| reserved_bytes    | bigint                      | Có       | —                              |
| consumed_bytes    | bigint                      | Không    | —                              |
| status            | character varying(16)       | Có       | 'RESERVED'::character varying  |
| expires_at        | timestamp(3) with time zone | Có       | —                              |
| confirmed_at      | timestamp(3) with time zone | Không    | —                              |
| released_at       | timestamp(3) with time zone | Không    | —                              |
| created_at        | timestamp(3) with time zone | Có       | now()                          |
| updated_at        | timestamp(3) with time zone | Có       | now()                          |
| deleted_at        | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `storage_reservations_check`: `CHECK ((((status)::text <> 'CONFIRMED'::text) OR ((confirmed_at IS NOT NULL) AND (consumed_bytes IS NOT NULL))))`
- `storage_reservations_check1`: `CHECK ((expires_at > created_at))`
- `storage_reservations_consumed_bytes_check`: `CHECK ((consumed_bytes >= 0))`
- `storage_reservations_reserved_bytes_check`: `CHECK ((reserved_bytes >= 0))`
- `storage_reservations_status_check`: `CHECK (((status)::text = ANY ((ARRAY['RESERVED'::character varying, 'CONFIRMED'::character varying, 'EXPIRED'::character varying, 'RELEASED'::character varying])::text[])))`
- `storage_reservations_asset_id_family_id_fkey`: `FOREIGN KEY (asset_id, family_id) REFERENCES app.assets(id, family_id)`
- `storage_reservations_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `storage_reservations_requester_user_id_fkey`: `FOREIGN KEY (requester_user_id) REFERENCES app.users(id)`
- `storage_reservations_asset_id_not_null`: `NOT NULL asset_id`
- `storage_reservations_created_at_not_null`: `NOT NULL created_at`
- `storage_reservations_expires_at_not_null`: `NOT NULL expires_at`
- `storage_reservations_family_id_not_null`: `NOT NULL family_id`
- `storage_reservations_id_not_null`: `NOT NULL id`
- `storage_reservations_idempotency_key_not_null`: `NOT NULL idempotency_key`
- `storage_reservations_reserved_bytes_not_null`: `NOT NULL reserved_bytes`
- `storage_reservations_status_not_null`: `NOT NULL status`
- `storage_reservations_updated_at_not_null`: `NOT NULL updated_at`
- `storage_reservations_pkey`: `PRIMARY KEY (id)`
- `storage_reservations_asset_id_key`: `UNIQUE (asset_id)`
- `storage_reservations_idempotency_key_key`: `UNIQUE (idempotency_key)`

Indexes:

- `ix_storage_reservation_expire`: `CREATE INDEX ix_storage_reservation_expire ON app.storage_reservations USING btree (expires_at) WHERE (((status)::text = 'RESERVED'::text) AND (deleted_at IS NULL))`
- `storage_reservations_asset_id_key`: `CREATE UNIQUE INDEX storage_reservations_asset_id_key ON app.storage_reservations USING btree (asset_id)`
- `storage_reservations_idempotency_key_key`: `CREATE UNIQUE INDEX storage_reservations_idempotency_key_key ON app.storage_reservations USING btree (idempotency_key)`
- `storage_reservations_pkey`: `CREATE UNIQUE INDEX storage_reservations_pkey ON app.storage_reservations USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.storage_reservations FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.storage_reservations FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.story_views — StoryView

| Cột          | PostgreSQL type             | NOT NULL | Default                        |
| ------------ | --------------------------- | -------- | ------------------------------ |
| user_id      | uuid                        | Có       | —                              |
| subject_type | character varying(10)       | Có       | —                              |
| subject_id   | uuid                        | Có       | —                              |
| family_id    | uuid                        | Có       | —                              |
| child_id     | uuid                        | Không    | —                              |
| pregnancy_id | uuid                        | Không    | —                              |
| local_date   | date                        | Có       | —                              |
| seen_until   | timestamp(3) with time zone | Có       | —                              |
| updated_at   | timestamp(3) with time zone | Có       | now()                          |
| created_at   | timestamp(3) with time zone | Có       | now()                          |
| deleted_at   | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `story_views_check`: `CHECK (((((subject_type)::text = 'CHILD'::text) AND (child_id IS NOT NULL) AND (subject_id = child_id) AND (pregnancy_id IS NULL)) OR (((subject_type)::text = 'PREGNANCY'::text) AND (pregnancy_id IS NOT NULL) AND (subject_id = pregnancy_id) AND (child_id IS NULL))))`
- `story_views_child_id_family_id_fkey`: `FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)`
- `story_views_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `story_views_pregnancy_id_family_id_fkey`: `FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id)`
- `story_views_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `story_views_created_at_not_null`: `NOT NULL created_at`
- `story_views_family_id_not_null`: `NOT NULL family_id`
- `story_views_local_date_not_null`: `NOT NULL local_date`
- `story_views_seen_until_not_null`: `NOT NULL seen_until`
- `story_views_subject_id_not_null`: `NOT NULL subject_id`
- `story_views_subject_type_not_null`: `NOT NULL subject_type`
- `story_views_updated_at_not_null`: `NOT NULL updated_at`
- `story_views_user_id_not_null`: `NOT NULL user_id`
- `story_views_pkey`: `PRIMARY KEY (user_id, subject_type, subject_id, local_date)`

Indexes:

- `story_views_pkey`: `CREATE UNIQUE INDEX story_views_pkey ON app.story_views USING btree (user_id, subject_type, subject_id, local_date)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.story_views FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.story_views FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.support_ticket_attachments — SupportTicketAttachment

| Cột           | PostgreSQL type             | NOT NULL | Default                        |
| ------------- | --------------------------- | -------- | ------------------------------ |
| id            | uuid                        | Có       | uuidv7()                       |
| ticket_id     | uuid                        | Có       | —                              |
| owner_user_id | uuid                        | Có       | —                              |
| asset_id      | uuid                        | Có       | —                              |
| created_at    | timestamp(3) with time zone | Có       | now()                          |
| updated_at    | timestamp(3) with time zone | Có       | now()                          |
| deleted_at    | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `support_ticket_attachments_asset_id_owner_user_id_fkey`: `FOREIGN KEY (asset_id, owner_user_id) REFERENCES app.user_assets(id, owner_user_id)`
- `support_ticket_attachments_owner_user_id_fkey`: `FOREIGN KEY (owner_user_id) REFERENCES app.users(id)`
- `support_ticket_attachments_ticket_id_owner_user_id_fkey`: `FOREIGN KEY (ticket_id, owner_user_id) REFERENCES app.support_tickets(id, requester_user_id)`
- `support_ticket_attachments_asset_id_not_null`: `NOT NULL asset_id`
- `support_ticket_attachments_created_at_not_null`: `NOT NULL created_at`
- `support_ticket_attachments_id_not_null`: `NOT NULL id`
- `support_ticket_attachments_owner_user_id_not_null`: `NOT NULL owner_user_id`
- `support_ticket_attachments_ticket_id_not_null`: `NOT NULL ticket_id`
- `support_ticket_attachments_updated_at_not_null`: `NOT NULL updated_at`
- `support_ticket_attachments_pkey`: `PRIMARY KEY (id)`
- `support_ticket_attachments_ticket_id_asset_id_key`: `UNIQUE (ticket_id, asset_id)`

Indexes:

- `support_ticket_attachments_pkey`: `CREATE UNIQUE INDEX support_ticket_attachments_pkey ON app.support_ticket_attachments USING btree (id)`
- `support_ticket_attachments_ticket_id_asset_id_key`: `CREATE UNIQUE INDEX support_ticket_attachments_ticket_id_asset_id_key ON app.support_ticket_attachments USING btree (ticket_id, asset_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.support_ticket_attachments FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_support_attachment_purpose`: `CREATE TRIGGER trg_support_attachment_purpose BEFORE INSERT OR UPDATE ON app.support_ticket_attachments FOR EACH ROW EXECUTE FUNCTION app.check_user_asset_purpose()`

## app.support_ticket_messages — SupportTicketMessage

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| id              | uuid                        | Có       | uuidv7()                       |
| ticket_id       | uuid                        | Có       | —                              |
| sender_user_id  | uuid                        | Không    | —                              |
| sender_admin_id | uuid                        | Không    | —                              |
| body_enc        | bytea                       | Có       | —                              |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `support_ticket_messages_check`: `CHECK ((num_nonnulls(sender_user_id, sender_admin_id) = 1))`
- `support_ticket_messages_sender_admin_id_fkey`: `FOREIGN KEY (sender_admin_id) REFERENCES ops.admin_users(id)`
- `support_ticket_messages_sender_user_id_fkey`: `FOREIGN KEY (sender_user_id) REFERENCES app.users(id)`
- `support_ticket_messages_ticket_id_fkey`: `FOREIGN KEY (ticket_id) REFERENCES app.support_tickets(id)`
- `support_ticket_messages_body_enc_not_null`: `NOT NULL body_enc`
- `support_ticket_messages_created_at_not_null`: `NOT NULL created_at`
- `support_ticket_messages_id_not_null`: `NOT NULL id`
- `support_ticket_messages_ticket_id_not_null`: `NOT NULL ticket_id`
- `support_ticket_messages_updated_at_not_null`: `NOT NULL updated_at`
- `support_ticket_messages_pkey`: `PRIMARY KEY (id)`

Indexes:

- `support_ticket_messages_pkey`: `CREATE UNIQUE INDEX support_ticket_messages_pkey ON app.support_ticket_messages USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.support_ticket_messages FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## app.support_tickets — SupportTicket

| Cột               | PostgreSQL type             | NOT NULL | Default                        |
| ----------------- | --------------------------- | -------- | ------------------------------ |
| id                | uuid                        | Có       | uuidv7()                       |
| requester_user_id | uuid                        | Không    | —                              |
| family_id         | uuid                        | Không    | —                              |
| category          | character varying(40)       | Có       | —                              |
| status            | character varying(20)       | Có       | 'OPEN'::character varying      |
| message_enc       | bytea                       | Có       | —                              |
| assigned_admin_id | uuid                        | Không    | —                              |
| closed_at         | timestamp(3) with time zone | Không    | —                              |
| created_at        | timestamp(3) with time zone | Có       | now()                          |
| updated_at        | timestamp(3) with time zone | Có       | now()                          |
| deleted_at        | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `support_tickets_status_check`: `CHECK (((status)::text = ANY ((ARRAY['OPEN'::character varying, 'IN_PROGRESS'::character varying, 'WAITING_USER'::character varying, 'RESOLVED'::character varying, 'CLOSED'::character varying])::text[])))`
- `support_tickets_assigned_admin_id_fkey`: `FOREIGN KEY (assigned_admin_id) REFERENCES ops.admin_users(id)`
- `support_tickets_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `support_tickets_requester_user_id_fkey`: `FOREIGN KEY (requester_user_id) REFERENCES app.users(id)`
- `support_tickets_category_not_null`: `NOT NULL category`
- `support_tickets_created_at_not_null`: `NOT NULL created_at`
- `support_tickets_id_not_null`: `NOT NULL id`
- `support_tickets_message_enc_not_null`: `NOT NULL message_enc`
- `support_tickets_status_not_null`: `NOT NULL status`
- `support_tickets_updated_at_not_null`: `NOT NULL updated_at`
- `support_tickets_pkey`: `PRIMARY KEY (id)`
- `support_tickets_id_requester_user_id_key`: `UNIQUE (id, requester_user_id)`

Indexes:

- `support_tickets_id_requester_user_id_key`: `CREATE UNIQUE INDEX support_tickets_id_requester_user_id_key ON app.support_tickets USING btree (id, requester_user_id)`
- `support_tickets_pkey`: `CREATE UNIQUE INDEX support_tickets_pkey ON app.support_tickets USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.support_tickets FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON app.support_tickets FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## app.user_assets — UserAsset

| Cột            | PostgreSQL type             | NOT NULL | Default                            |
| -------------- | --------------------------- | -------- | ---------------------------------- |
| id             | uuid                        | Có       | uuidv7()                           |
| owner_user_id  | uuid                        | Có       | —                                  |
| purpose        | character varying(10)       | Có       | —                                  |
| status         | app.asset_status            | Có       | 'PENDING_UPLOAD'::app.asset_status |
| storage_bucket | character varying(80)       | Có       | 'bf-user-media'::character varying |
| storage_key    | text                        | Có       | —                                  |
| mime           | character varying(60)       | Có       | —                                  |
| declared_size  | bigint                      | Có       | —                                  |
| size_bytes     | bigint                      | Không    | —                                  |
| sha256         | bytea                       | Không    | —                                  |
| ready_at       | timestamp(3) with time zone | Không    | —                                  |
| purge_after    | timestamp(3) with time zone | Không    | —                                  |
| created_at     | timestamp(3) with time zone | Có       | now()                              |
| updated_at     | timestamp(3) with time zone | Có       | now()                              |
| deleted_at     | timestamp(3) with time zone | Không    | NULL::timestamp with time zone     |

Constraints:

- `user_assets_declared_size_check`: `CHECK ((declared_size >= 0))`
- `user_assets_purpose_check`: `CHECK (((purpose)::text = ANY ((ARRAY['AVATAR'::character varying, 'SUPPORT'::character varying])::text[])))`
- `user_assets_sha256_check`: `CHECK (((sha256 IS NULL) OR (octet_length(sha256) = 32)))`
- `user_assets_size_bytes_check`: `CHECK ((size_bytes >= 0))`
- `user_assets_owner_user_id_fkey`: `FOREIGN KEY (owner_user_id) REFERENCES app.users(id)`
- `user_assets_created_at_not_null`: `NOT NULL created_at`
- `user_assets_declared_size_not_null`: `NOT NULL declared_size`
- `user_assets_id_not_null`: `NOT NULL id`
- `user_assets_mime_not_null`: `NOT NULL mime`
- `user_assets_owner_user_id_not_null`: `NOT NULL owner_user_id`
- `user_assets_purpose_not_null`: `NOT NULL purpose`
- `user_assets_status_not_null`: `NOT NULL status`
- `user_assets_storage_bucket_not_null`: `NOT NULL storage_bucket`
- `user_assets_storage_key_not_null`: `NOT NULL storage_key`
- `user_assets_updated_at_not_null`: `NOT NULL updated_at`
- `user_assets_pkey`: `PRIMARY KEY (id)`
- `user_assets_id_owner_user_id_key`: `UNIQUE (id, owner_user_id)`
- `user_assets_storage_bucket_storage_key_key`: `UNIQUE (storage_bucket, storage_key)`

Indexes:

- `ix_user_assets_owner`: `CREATE INDEX ix_user_assets_owner ON app.user_assets USING btree (owner_user_id, purpose) WHERE (deleted_at IS NULL)`
- `user_assets_id_owner_user_id_key`: `CREATE UNIQUE INDEX user_assets_id_owner_user_id_key ON app.user_assets USING btree (id, owner_user_id)`
- `user_assets_pkey`: `CREATE UNIQUE INDEX user_assets_pkey ON app.user_assets USING btree (id)`
- `user_assets_storage_bucket_storage_key_key`: `CREATE UNIQUE INDEX user_assets_storage_bucket_storage_key_key ON app.user_assets USING btree (storage_bucket, storage_key)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.user_assets FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_user_asset_owner`: `CREATE TRIGGER trg_immutable_user_asset_owner BEFORE UPDATE ON app.user_assets FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('owner_user_id', 'purpose', 'storage_bucket', 'storage_key')`

## app.user_consents — UserConsent

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| id         | uuid                        | Có       | uuidv7()                       |
| user_id    | uuid                        | Có       | —                              |
| document   | character varying(40)       | Có       | —                              |
| version    | character varying(20)       | Có       | —                              |
| granted    | boolean                     | Có       | —                              |
| ip         | inet                        | Không    | —                              |
| platform   | app.platform                | Không    | —                              |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `user_consents_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `user_consents_created_at_not_null`: `NOT NULL created_at`
- `user_consents_document_not_null`: `NOT NULL document`
- `user_consents_granted_not_null`: `NOT NULL granted`
- `user_consents_id_not_null`: `NOT NULL id`
- `user_consents_updated_at_not_null`: `NOT NULL updated_at`
- `user_consents_user_id_not_null`: `NOT NULL user_id`
- `user_consents_version_not_null`: `NOT NULL version`
- `user_consents_pkey`: `PRIMARY KEY (id)`

Indexes:

- `user_consents_pkey`: `CREATE UNIQUE INDEX user_consents_pkey ON app.user_consents USING btree (id)`
- `user_consents_user_id_document_created_at_idx`: `CREATE INDEX user_consents_user_id_document_created_at_idx ON app.user_consents USING btree (user_id, document, created_at DESC)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.user_consents FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## app.user_devices — UserDevice

| Cột          | PostgreSQL type             | NOT NULL | Default                        |
| ------------ | --------------------------- | -------- | ------------------------------ |
| id           | uuid                        | Có       | uuidv7()                       |
| user_id      | uuid                        | Có       | —                              |
| platform     | app.platform                | Có       | —                              |
| push_token   | text                        | Không    | —                              |
| push_enabled | boolean                     | Có       | false                          |
| app_version  | character varying(20)       | Không    | —                              |
| os_version   | character varying(40)       | Không    | —                              |
| device_model | character varying(80)       | Không    | —                              |
| locale       | character varying(10)       | Không    | —                              |
| timezone     | character varying(64)       | Không    | —                              |
| last_seen_at | timestamp(3) with time zone | Có       | now()                          |
| created_at   | timestamp(3) with time zone | Có       | now()                          |
| updated_at   | timestamp(3) with time zone | Có       | now()                          |
| deleted_at   | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `user_devices_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `user_devices_created_at_not_null`: `NOT NULL created_at`
- `user_devices_id_not_null`: `NOT NULL id`
- `user_devices_last_seen_at_not_null`: `NOT NULL last_seen_at`
- `user_devices_platform_not_null`: `NOT NULL platform`
- `user_devices_push_enabled_not_null`: `NOT NULL push_enabled`
- `user_devices_updated_at_not_null`: `NOT NULL updated_at`
- `user_devices_user_id_not_null`: `NOT NULL user_id`
- `user_devices_pkey`: `PRIMARY KEY (id)`
- `user_devices_id_user_id_key`: `UNIQUE (id, user_id)`
- `user_devices_push_token_key`: `UNIQUE (push_token)`

Indexes:

- `user_devices_id_user_id_key`: `CREATE UNIQUE INDEX user_devices_id_user_id_key ON app.user_devices USING btree (id, user_id)`
- `user_devices_pkey`: `CREATE UNIQUE INDEX user_devices_pkey ON app.user_devices USING btree (id)`
- `user_devices_push_token_key`: `CREATE UNIQUE INDEX user_devices_push_token_key ON app.user_devices USING btree (push_token)`
- `user_devices_user_id_idx`: `CREATE INDEX user_devices_user_id_idx ON app.user_devices USING btree (user_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.user_devices FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## app.user_sessions — UserSession

| Cột                 | PostgreSQL type             | NOT NULL | Default                        |
| ------------------- | --------------------------- | -------- | ------------------------------ |
| id                  | uuid                        | Có       | uuidv7()                       |
| user_id             | uuid                        | Có       | —                              |
| device_id           | uuid                        | Không    | —                              |
| refresh_token_hash  | bytea                       | Có       | —                              |
| replaced_by         | uuid                        | Không    | —                              |
| platform            | app.platform                | Không    | —                              |
| app_version         | character varying(20)       | Không    | —                              |
| ip_created          | inet                        | Không    | —                              |
| created_at          | timestamp(3) with time zone | Có       | now()                          |
| last_used_at        | timestamp(3) with time zone | Có       | now()                          |
| expires_at          | timestamp(3) with time zone | Có       | —                              |
| absolute_expires_at | timestamp(3) with time zone | Có       | —                              |
| revoked_at          | timestamp(3) with time zone | Không    | —                              |
| revoke_reason       | character varying(40)       | Không    | —                              |
| updated_at          | timestamp(3) with time zone | Có       | now()                          |
| deleted_at          | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `user_sessions_device_id_user_id_fkey`: `FOREIGN KEY (device_id, user_id) REFERENCES app.user_devices(id, user_id)`
- `user_sessions_replaced_by_user_id_fkey`: `FOREIGN KEY (replaced_by, user_id) REFERENCES app.user_sessions(id, user_id)`
- `user_sessions_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `user_sessions_absolute_expires_at_not_null`: `NOT NULL absolute_expires_at`
- `user_sessions_created_at_not_null`: `NOT NULL created_at`
- `user_sessions_expires_at_not_null`: `NOT NULL expires_at`
- `user_sessions_id_not_null`: `NOT NULL id`
- `user_sessions_last_used_at_not_null`: `NOT NULL last_used_at`
- `user_sessions_refresh_token_hash_not_null`: `NOT NULL refresh_token_hash`
- `user_sessions_updated_at_not_null`: `NOT NULL updated_at`
- `user_sessions_user_id_not_null`: `NOT NULL user_id`
- `user_sessions_pkey`: `PRIMARY KEY (id)`
- `user_sessions_id_user_id_key`: `UNIQUE (id, user_id)`
- `user_sessions_refresh_token_hash_key`: `UNIQUE (refresh_token_hash)`

Indexes:

- `user_sessions_id_user_id_key`: `CREATE UNIQUE INDEX user_sessions_id_user_id_key ON app.user_sessions USING btree (id, user_id)`
- `user_sessions_pkey`: `CREATE UNIQUE INDEX user_sessions_pkey ON app.user_sessions USING btree (id)`
- `user_sessions_refresh_token_hash_key`: `CREATE UNIQUE INDEX user_sessions_refresh_token_hash_key ON app.user_sessions USING btree (refresh_token_hash)`
- `user_sessions_user_id_idx`: `CREATE INDEX user_sessions_user_id_idx ON app.user_sessions USING btree (user_id) WHERE ((revoked_at IS NULL) AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.user_sessions FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## app.user_settings — UserSetting

| Cột                       | PostgreSQL type             | NOT NULL | Default                            |
| ------------------------- | --------------------------- | -------- | ---------------------------------- |
| user_id                   | uuid                        | Có       | —                                  |
| notification_prefs        | jsonb                       | Có       | '{}'::jsonb                        |
| quiet_start               | time without time zone      | Có       | '22:00:00'::time without time zone |
| quiet_end                 | time without time zone      | Có       | '06:30:00'::time without time zone |
| hide_sensitive_preview    | boolean                     | Có       | true                               |
| circle_digest_mode        | character varying(10)       | Có       | 'DIGEST'::character varying        |
| circle_digest_time        | time without time zone      | Có       | '19:00:00'::time without time zone |
| mood_share_default        | character varying(10)       | Có       | 'ASK'::character varying           |
| request_soon_bypass_quiet | boolean                     | Có       | false                              |
| us_lock_enabled           | boolean                     | Có       | false                              |
| ai_enabled                | boolean                     | Có       | true                               |
| ai_features               | jsonb                       | Có       | '{}'::jsonb                        |
| theme                     | character varying(10)       | Có       | 'SYSTEM'::character varying        |
| text_scale                | numeric(3,2)                | Có       | 1.00                               |
| show_lunar                | boolean                     | Có       | true                               |
| memory_prompts_enabled    | boolean                     | Có       | true                               |
| perspective_suggest       | boolean                     | Có       | true                               |
| daily_story_suggest       | boolean                     | Có       | true                               |
| updated_at                | timestamp(3) with time zone | Có       | now()                              |
| created_at                | timestamp(3) with time zone | Có       | now()                              |
| deleted_at                | timestamp(3) with time zone | Không    | NULL::timestamp with time zone     |

Constraints:

- `user_settings_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `user_settings_ai_enabled_not_null`: `NOT NULL ai_enabled`
- `user_settings_ai_features_not_null`: `NOT NULL ai_features`
- `user_settings_circle_digest_mode_not_null`: `NOT NULL circle_digest_mode`
- `user_settings_circle_digest_time_not_null`: `NOT NULL circle_digest_time`
- `user_settings_created_at_not_null`: `NOT NULL created_at`
- `user_settings_daily_story_suggest_not_null`: `NOT NULL daily_story_suggest`
- `user_settings_hide_sensitive_preview_not_null`: `NOT NULL hide_sensitive_preview`
- `user_settings_memory_prompts_enabled_not_null`: `NOT NULL memory_prompts_enabled`
- `user_settings_mood_share_default_not_null`: `NOT NULL mood_share_default`
- `user_settings_notification_prefs_not_null`: `NOT NULL notification_prefs`
- `user_settings_perspective_suggest_not_null`: `NOT NULL perspective_suggest`
- `user_settings_quiet_end_not_null`: `NOT NULL quiet_end`
- `user_settings_quiet_start_not_null`: `NOT NULL quiet_start`
- `user_settings_request_soon_bypass_quiet_not_null`: `NOT NULL request_soon_bypass_quiet`
- `user_settings_show_lunar_not_null`: `NOT NULL show_lunar`
- `user_settings_text_scale_not_null`: `NOT NULL text_scale`
- `user_settings_theme_not_null`: `NOT NULL theme`
- `user_settings_updated_at_not_null`: `NOT NULL updated_at`
- `user_settings_us_lock_enabled_not_null`: `NOT NULL us_lock_enabled`
- `user_settings_user_id_not_null`: `NOT NULL user_id`
- `user_settings_pkey`: `PRIMARY KEY (user_id)`

Indexes:

- `user_settings_pkey`: `CREATE UNIQUE INDEX user_settings_pkey ON app.user_settings USING btree (user_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.user_settings FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## app.users — User

| Cột             | PostgreSQL type             | NOT NULL | Default                               |
| --------------- | --------------------------- | -------- | ------------------------------------- |
| id              | uuid                        | Có       | uuidv7()                              |
| display_name    | character varying(80)       | Có       | —                                     |
| avatar_asset_id | uuid                        | Không    | —                                     |
| locale          | character varying(10)       | Có       | 'vi'::character varying               |
| timezone        | character varying(64)       | Có       | 'Asia/Ho_Chi_Minh'::character varying |
| status          | app.user_status             | Có       | 'ACTIVE'::app.user_status             |
| onboarding_role | app.onboarding_role         | Không    | —                                     |
| token_version   | integer                     | Có       | 1                                     |
| last_active_at  | timestamp(3) with time zone | Không    | —                                     |
| created_at      | timestamp(3) with time zone | Có       | now()                                 |
| updated_at      | timestamp(3) with time zone | Có       | now()                                 |
| deleted_at      | timestamp(3) with time zone | Không    | —                                     |

Constraints:

- `users_display_name_check`: `CHECK (((display_name IS NULL) OR (char_length(btrim((display_name)::text)) > 0)))`
- `users_avatar_asset_id_id_fkey`: `FOREIGN KEY (avatar_asset_id, id) REFERENCES app.user_assets(id, owner_user_id)`
- `users_created_at_not_null`: `NOT NULL created_at`
- `users_display_name_not_null`: `NOT NULL display_name`
- `users_id_not_null`: `NOT NULL id`
- `users_locale_not_null`: `NOT NULL locale`
- `users_status_not_null`: `NOT NULL status`
- `users_timezone_not_null`: `NOT NULL timezone`
- `users_token_version_not_null`: `NOT NULL token_version`
- `users_updated_at_not_null`: `NOT NULL updated_at`
- `users_pkey`: `PRIMARY KEY (id)`

Indexes:

- `users_pkey`: `CREATE UNIQUE INDEX users_pkey ON app.users USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.users FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_avatar_purpose`: `CREATE TRIGGER trg_avatar_purpose BEFORE INSERT OR UPDATE OF avatar_asset_id ON app.users FOR EACH ROW EXECUTE FUNCTION app.check_user_asset_purpose()`

## billing.family_entitlements — FamilyEntitlement

| Cột                       | PostgreSQL type             | NOT NULL | Default                            |
| ------------------------- | --------------------------- | -------- | ---------------------------------- |
| family_id                 | uuid                        | Có       | —                                  |
| license_id                | uuid                        | Có       | —                                  |
| access_phase              | billing.access_phase        | Có       | 'INCOMPLETE'::billing.access_phase |
| effective_plan_version_id | uuid                        | Không    | —                                  |
| source_grant_id           | uuid                        | Không    | —                                  |
| trial_started_at          | timestamp(3) with time zone | Không    | —                                  |
| trial_ends_at             | timestamp(3) with time zone | Không    | —                                  |
| valid_until               | timestamp(3) with time zone | Không    | —                                  |
| in_grace                  | boolean                     | Có       | false                              |
| computed_at               | timestamp(3) with time zone | Có       | now()                              |
| version                   | bigint                      | Có       | 1                                  |
| created_at                | timestamp(3) with time zone | Có       | now()                              |
| updated_at                | timestamp(3) with time zone | Có       | now()                              |
| deleted_at                | timestamp(3) with time zone | Không    | NULL::timestamp with time zone     |

Constraints:

- `family_entitlements_check`: `CHECK (((trial_ends_at IS NULL) OR (trial_started_at IS NULL) OR (trial_ends_at > trial_started_at)))`
- `family_entitlements_check1`: `CHECK (((access_phase <> ALL (ARRAY['TRIAL'::billing.access_phase, 'PAID'::billing.access_phase])) OR (effective_plan_version_id IS NOT NULL)))`
- `family_entitlements_version_check`: `CHECK ((version > 0))`
- `family_entitlements_effective_plan_version_id_fkey`: `FOREIGN KEY (effective_plan_version_id) REFERENCES billing.plan_versions(id)`
- `family_entitlements_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `family_entitlements_license_id_family_id_fkey`: `FOREIGN KEY (license_id, family_id) REFERENCES billing.family_licenses(id, family_id)`
- `family_entitlements_source_grant_id_family_id_fkey`: `FOREIGN KEY (source_grant_id, family_id) REFERENCES billing.license_grants(id, family_id)`
- `family_entitlements_access_phase_not_null`: `NOT NULL access_phase`
- `family_entitlements_computed_at_not_null`: `NOT NULL computed_at`
- `family_entitlements_created_at_not_null`: `NOT NULL created_at`
- `family_entitlements_family_id_not_null`: `NOT NULL family_id`
- `family_entitlements_in_grace_not_null`: `NOT NULL in_grace`
- `family_entitlements_license_id_not_null`: `NOT NULL license_id`
- `family_entitlements_updated_at_not_null`: `NOT NULL updated_at`
- `family_entitlements_version_not_null`: `NOT NULL version`
- `family_entitlements_pkey`: `PRIMARY KEY (family_id)`
- `family_entitlements_license_id_key`: `UNIQUE (license_id)`

Indexes:

- `family_entitlements_license_id_key`: `CREATE UNIQUE INDEX family_entitlements_license_id_key ON billing.family_entitlements USING btree (license_id)`
- `family_entitlements_pkey`: `CREATE UNIQUE INDEX family_entitlements_pkey ON billing.family_entitlements USING btree (family_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON billing.family_entitlements FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON billing.family_entitlements FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## billing.family_licenses — FamilyLicense

| Cột               | PostgreSQL type             | NOT NULL | Default                        |
| ----------------- | --------------------------- | -------- | ------------------------------ |
| id                | uuid                        | Có       | uuidv7()                       |
| family_id         | uuid                        | Có       | —                              |
| blocked_at        | timestamp(3) with time zone | Không    | —                              |
| block_reason_code | character varying(80)       | Không    | —                              |
| created_at        | timestamp(3) with time zone | Có       | now()                          |
| updated_at        | timestamp(3) with time zone | Có       | now()                          |
| deleted_at        | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `family_licenses_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `family_licenses_created_at_not_null`: `NOT NULL created_at`
- `family_licenses_family_id_not_null`: `NOT NULL family_id`
- `family_licenses_id_not_null`: `NOT NULL id`
- `family_licenses_updated_at_not_null`: `NOT NULL updated_at`
- `family_licenses_pkey`: `PRIMARY KEY (id)`
- `family_licenses_family_id_key`: `UNIQUE (family_id)`
- `family_licenses_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `family_licenses_family_id_key`: `CREATE UNIQUE INDEX family_licenses_family_id_key ON billing.family_licenses USING btree (family_id)`
- `family_licenses_id_family_id_key`: `CREATE UNIQUE INDEX family_licenses_id_family_id_key ON billing.family_licenses USING btree (id, family_id)`
- `family_licenses_pkey`: `CREATE UNIQUE INDEX family_licenses_pkey ON billing.family_licenses USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON billing.family_licenses FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON billing.family_licenses FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_no_delete`: `CREATE TRIGGER trg_no_delete BEFORE DELETE ON billing.family_licenses FOR EACH ROW EXECUTE FUNCTION ops.deny_physical_delete()`

## billing.family_usage — FamilyUsage

| Cột                    | PostgreSQL type             | NOT NULL | Default                        |
| ---------------------- | --------------------------- | -------- | ------------------------------ |
| family_id              | uuid                        | Có       | —                              |
| storage_bytes          | bigint                      | Có       | 0                              |
| reserved_storage_bytes | bigint                      | Có       | 0                              |
| memory_count           | integer                     | Có       | 0                              |
| album_count            | integer                     | Có       | 0                              |
| active_series          | integer                     | Có       | 0                              |
| letter_count           | integer                     | Có       | 0                              |
| version                | bigint                      | Có       | 1                              |
| created_at             | timestamp(3) with time zone | Có       | now()                          |
| updated_at             | timestamp(3) with time zone | Có       | now()                          |
| deleted_at             | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `family_usage_check`: `CHECK (((storage_bytes >= 0) AND (reserved_storage_bytes >= 0) AND (memory_count >= 0) AND (album_count >= 0) AND (active_series >= 0) AND (letter_count >= 0)))`
- `family_usage_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `family_usage_active_series_not_null`: `NOT NULL active_series`
- `family_usage_album_count_not_null`: `NOT NULL album_count`
- `family_usage_created_at_not_null`: `NOT NULL created_at`
- `family_usage_family_id_not_null`: `NOT NULL family_id`
- `family_usage_letter_count_not_null`: `NOT NULL letter_count`
- `family_usage_memory_count_not_null`: `NOT NULL memory_count`
- `family_usage_reserved_storage_bytes_not_null`: `NOT NULL reserved_storage_bytes`
- `family_usage_storage_bytes_not_null`: `NOT NULL storage_bytes`
- `family_usage_updated_at_not_null`: `NOT NULL updated_at`
- `family_usage_version_not_null`: `NOT NULL version`
- `family_usage_pkey`: `PRIMARY KEY (family_id)`

Indexes:

- `family_usage_pkey`: `CREATE UNIQUE INDEX family_usage_pkey ON billing.family_usage USING btree (family_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON billing.family_usage FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON billing.family_usage FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## billing.license_grants — LicenseGrant

| Cột                 | PostgreSQL type             | NOT NULL | Default                        |
| ------------------- | --------------------------- | -------- | ------------------------------ |
| id                  | uuid                        | Có       | uuidv7()                       |
| family_id           | uuid                        | Có       | —                              |
| license_id          | uuid                        | Có       | —                              |
| plan_version_id     | uuid                        | Có       | —                              |
| source              | billing.grant_source        | Có       | —                              |
| trial_policy_id     | uuid                        | Không    | —                              |
| subscription_id     | uuid                        | Không    | —                              |
| transaction_id      | uuid                        | Không    | —                              |
| provenance_key      | character varying(255)      | Có       | —                              |
| valid_from          | timestamp(3) with time zone | Có       | —                              |
| valid_until         | timestamp(3) with time zone | Có       | —                              |
| revoked_at          | timestamp(3) with time zone | Không    | —                              |
| revoke_reason_code  | character varying(80)       | Không    | —                              |
| granted_by_admin_id | uuid                        | Không    | —                              |
| justification       | character varying(500)      | Không    | —                              |
| created_at          | timestamp(3) with time zone | Có       | now()                          |
| updated_at          | timestamp(3) with time zone | Có       | now()                          |
| deleted_at          | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `license_grants_check`: `CHECK ((valid_until > valid_from))`
- `license_grants_check1`: `CHECK (((source <> 'STORE'::billing.grant_source) OR ((subscription_id IS NOT NULL) AND (transaction_id IS NOT NULL))))`
- `license_grants_check2`: `CHECK (((source = 'TRIAL'::billing.grant_source) = (trial_policy_id IS NOT NULL)))`
- `license_grants_check3`: `CHECK (((source <> 'MANUAL'::billing.grant_source) OR ((granted_by_admin_id IS NOT NULL) AND (justification IS NOT NULL))))`
- `license_grants_granted_by_admin_id_fkey`: `FOREIGN KEY (granted_by_admin_id) REFERENCES ops.admin_users(id)`
- `license_grants_license_id_family_id_fkey`: `FOREIGN KEY (license_id, family_id) REFERENCES billing.family_licenses(id, family_id)`
- `license_grants_plan_version_id_fkey`: `FOREIGN KEY (plan_version_id) REFERENCES billing.plan_versions(id)`
- `license_grants_subscription_id_family_id_license_id_fkey`: `FOREIGN KEY (subscription_id, family_id, license_id) REFERENCES billing.subscriptions(id, family_id, license_id)`
- `license_grants_transaction_id_family_id_license_id_fkey`: `FOREIGN KEY (transaction_id, family_id, license_id) REFERENCES billing.subscription_transactions(id, family_id, license_id)`
- `license_grants_transaction_id_family_id_license_id_plan_ve_fkey`: `FOREIGN KEY (transaction_id, family_id, license_id, plan_version_id) REFERENCES billing.subscription_transactions(id, family_id, license_id, plan_version_id)`
- `license_grants_transaction_id_subscription_id_family_id_li_fkey`: `FOREIGN KEY (transaction_id, subscription_id, family_id, license_id, plan_version_id) REFERENCES billing.subscription_transactions(id, subscription_id, family_id, license_id, plan_version_id)`
- `license_grants_trial_policy_id_plan_version_id_fkey`: `FOREIGN KEY (trial_policy_id, plan_version_id) REFERENCES billing.trial_policies(id, plan_version_id)`
- `license_grants_created_at_not_null`: `NOT NULL created_at`
- `license_grants_family_id_not_null`: `NOT NULL family_id`
- `license_grants_id_not_null`: `NOT NULL id`
- `license_grants_license_id_not_null`: `NOT NULL license_id`
- `license_grants_plan_version_id_not_null`: `NOT NULL plan_version_id`
- `license_grants_provenance_key_not_null`: `NOT NULL provenance_key`
- `license_grants_source_not_null`: `NOT NULL source`
- `license_grants_updated_at_not_null`: `NOT NULL updated_at`
- `license_grants_valid_from_not_null`: `NOT NULL valid_from`
- `license_grants_valid_until_not_null`: `NOT NULL valid_until`
- `license_grants_pkey`: `PRIMARY KEY (id)`
- `license_grants_id_family_id_key`: `UNIQUE (id, family_id)`
- `license_grants_provenance_key_key`: `UNIQUE (provenance_key)`

Indexes:

- `ix_license_grants_validity`: `CREATE INDEX ix_license_grants_validity ON billing.license_grants USING btree (family_id, valid_from, valid_until) WHERE ((revoked_at IS NULL) AND (deleted_at IS NULL))`
- `license_grants_id_family_id_key`: `CREATE UNIQUE INDEX license_grants_id_family_id_key ON billing.license_grants USING btree (id, family_id)`
- `license_grants_pkey`: `CREATE UNIQUE INDEX license_grants_pkey ON billing.license_grants USING btree (id)`
- `license_grants_provenance_key_key`: `CREATE UNIQUE INDEX license_grants_provenance_key_key ON billing.license_grants USING btree (provenance_key)`
- `uq_family_trial_once`: `CREATE UNIQUE INDEX uq_family_trial_once ON billing.license_grants USING btree (family_id) WHERE (source = 'TRIAL'::billing.grant_source)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON billing.license_grants FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_grant_no_soft_delete`: `CREATE TRIGGER trg_grant_no_soft_delete BEFORE UPDATE ON billing.license_grants FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('deleted_at')`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON billing.license_grants FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_immutable_grant`: `CREATE TRIGGER trg_immutable_grant BEFORE UPDATE ON billing.license_grants FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('license_id', 'plan_version_id', 'trial_policy_id', 'source', 'subscription_id', 'transaction_id', 'provenance_key', 'valid_from', 'valid_until')`
- `trg_no_delete`: `CREATE TRIGGER trg_no_delete BEFORE DELETE ON billing.license_grants FOR EACH ROW EXECUTE FUNCTION ops.deny_physical_delete()`
- `trg_trial_duration`: `CREATE TRIGGER trg_trial_duration BEFORE INSERT ON billing.license_grants FOR EACH ROW EXECUTE FUNCTION billing.check_trial_duration()`

## billing.plan_versions — PlanVersion

| Cột              | PostgreSQL type             | NOT NULL | Default                        |
| ---------------- | --------------------------- | -------- | ------------------------------ |
| id               | uuid                        | Có       | uuidv7()                       |
| plan_id          | uuid                        | Có       | —                              |
| version          | integer                     | Có       | —                              |
| quotas           | jsonb                       | Có       | —                              |
| entitlement_rank | integer                     | Có       | 0                              |
| features         | jsonb                       | Có       | '{}'::jsonb                    |
| available_from   | timestamp(3) with time zone | Có       | now()                          |
| retired_at       | timestamp(3) with time zone | Không    | —                              |
| created_at       | timestamp(3) with time zone | Có       | now()                          |
| updated_at       | timestamp(3) with time zone | Có       | now()                          |
| deleted_at       | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `plan_versions_check`: `CHECK (((jsonb_typeof(quotas) = 'object'::text) AND (jsonb_typeof(features) = 'object'::text)))`
- `plan_versions_check1`: `CHECK (((retired_at IS NULL) OR (retired_at >= available_from)))`
- `plan_versions_entitlement_rank_check`: `CHECK ((entitlement_rank >= 0))`
- `plan_versions_version_check`: `CHECK ((version > 0))`
- `plan_versions_plan_id_fkey`: `FOREIGN KEY (plan_id) REFERENCES billing.plans(id)`
- `plan_versions_available_from_not_null`: `NOT NULL available_from`
- `plan_versions_created_at_not_null`: `NOT NULL created_at`
- `plan_versions_entitlement_rank_not_null`: `NOT NULL entitlement_rank`
- `plan_versions_features_not_null`: `NOT NULL features`
- `plan_versions_id_not_null`: `NOT NULL id`
- `plan_versions_plan_id_not_null`: `NOT NULL plan_id`
- `plan_versions_quotas_not_null`: `NOT NULL quotas`
- `plan_versions_updated_at_not_null`: `NOT NULL updated_at`
- `plan_versions_version_not_null`: `NOT NULL version`
- `plan_versions_pkey`: `PRIMARY KEY (id)`
- `plan_versions_plan_id_version_key`: `UNIQUE (plan_id, version)`

Indexes:

- `plan_versions_pkey`: `CREATE UNIQUE INDEX plan_versions_pkey ON billing.plan_versions USING btree (id)`
- `plan_versions_plan_id_version_key`: `CREATE UNIQUE INDEX plan_versions_plan_id_version_key ON billing.plan_versions USING btree (plan_id, version)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON billing.plan_versions FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_plan_version`: `CREATE TRIGGER trg_immutable_plan_version BEFORE UPDATE ON billing.plan_versions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('plan_id', 'version', 'quotas', 'features', 'entitlement_rank')`

## billing.plans — Plan

| Cột               | PostgreSQL type             | NOT NULL | Default                        |
| ----------------- | --------------------------- | -------- | ------------------------------ |
| id                | uuid                        | Có       | uuidv7()                       |
| code              | character varying(40)       | Có       | —                              |
| display_name_i18n | jsonb                       | Có       | —                              |
| display_order     | integer                     | Có       | 0                              |
| purchase_enabled  | boolean                     | Có       | true                           |
| active            | boolean                     | Có       | true                           |
| created_at        | timestamp(3) with time zone | Có       | now()                          |
| updated_at        | timestamp(3) with time zone | Có       | now()                          |
| deleted_at        | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `plans_active_not_null`: `NOT NULL active`
- `plans_code_not_null`: `NOT NULL code`
- `plans_created_at_not_null`: `NOT NULL created_at`
- `plans_display_name_i18n_not_null`: `NOT NULL display_name_i18n`
- `plans_display_order_not_null`: `NOT NULL display_order`
- `plans_id_not_null`: `NOT NULL id`
- `plans_purchase_enabled_not_null`: `NOT NULL purchase_enabled`
- `plans_updated_at_not_null`: `NOT NULL updated_at`
- `plans_pkey`: `PRIMARY KEY (id)`
- `plans_code_key`: `UNIQUE (code)`

Indexes:

- `plans_code_key`: `CREATE UNIQUE INDEX plans_code_key ON billing.plans USING btree (code)`
- `plans_pkey`: `CREATE UNIQUE INDEX plans_pkey ON billing.plans USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON billing.plans FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_plan_code`: `CREATE TRIGGER trg_immutable_plan_code BEFORE UPDATE ON billing.plans FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('code')`

## billing.products — Product

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| id              | uuid                        | Có       | uuidv7()                       |
| product_id      | character varying(255)      | Có       | —                              |
| store           | billing.store               | Có       | —                              |
| environment     | character varying(12)       | Có       | —                              |
| app_namespace   | character varying(255)      | Có       | —                              |
| plan_version_id | uuid                        | Có       | —                              |
| base_plan_id    | character varying(255)      | Không    | —                              |
| period          | character varying(30)       | Có       | —                              |
| active          | boolean                     | Có       | true                           |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `products_check`: `CHECK (((store = 'GOOGLE'::billing.store) = (base_plan_id IS NOT NULL)))`
- `products_environment_check`: `CHECK (((environment)::text = ANY ((ARRAY['PRODUCTION'::character varying, 'SANDBOX'::character varying])::text[])))`
- `products_plan_version_id_fkey`: `FOREIGN KEY (plan_version_id) REFERENCES billing.plan_versions(id)`
- `products_active_not_null`: `NOT NULL active`
- `products_app_namespace_not_null`: `NOT NULL app_namespace`
- `products_created_at_not_null`: `NOT NULL created_at`
- `products_environment_not_null`: `NOT NULL environment`
- `products_id_not_null`: `NOT NULL id`
- `products_period_not_null`: `NOT NULL period`
- `products_plan_version_id_not_null`: `NOT NULL plan_version_id`
- `products_product_id_not_null`: `NOT NULL product_id`
- `products_store_not_null`: `NOT NULL store`
- `products_updated_at_not_null`: `NOT NULL updated_at`
- `products_pkey`: `PRIMARY KEY (id)`
- `products_id_store_environment_app_namespace_key`: `UNIQUE (id, store, environment, app_namespace)`
- `products_store_environment_app_namespace_product_id_base_pl_key`: `UNIQUE NULLS NOT DISTINCT (store, environment, app_namespace, product_id, base_plan_id)`

Indexes:

- `products_id_store_environment_app_namespace_key`: `CREATE UNIQUE INDEX products_id_store_environment_app_namespace_key ON billing.products USING btree (id, store, environment, app_namespace)`
- `products_pkey`: `CREATE UNIQUE INDEX products_pkey ON billing.products USING btree (id)`
- `products_store_environment_app_namespace_product_id_base_pl_key`: `CREATE UNIQUE INDEX products_store_environment_app_namespace_product_id_base_pl_key ON billing.products USING btree (store, environment, app_namespace, product_id, base_plan_id) NULLS NOT DISTINCT`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON billing.products FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## billing.purchase_intents — PurchaseIntent

| Cột                    | PostgreSQL type             | NOT NULL | Default                        |
| ---------------------- | --------------------------- | -------- | ------------------------------ |
| id                     | uuid                        | Có       | uuidv7()                       |
| family_id              | uuid                        | Có       | —                              |
| license_id             | uuid                        | Có       | —                              |
| purchaser_user_id      | uuid                        | Không    | —                              |
| product_id             | uuid                        | Có       | —                              |
| store                  | billing.store               | Có       | —                              |
| environment            | character varying(12)       | Có       | —                              |
| app_namespace          | character varying(255)      | Có       | —                              |
| app_account_token      | uuid                        | Có       | uuidv7()                       |
| obfuscated_account_id  | character varying(128)      | Không    | —                              |
| client_idempotency_key | uuid                        | Có       | —                              |
| status                 | character varying(16)       | Có       | 'CREATED'::character varying   |
| expires_at             | timestamp(3) with time zone | Có       | —                              |
| verified_at            | timestamp(3) with time zone | Không    | —                              |
| failure_code           | character varying(80)       | Không    | —                              |
| created_at             | timestamp(3) with time zone | Có       | now()                          |
| updated_at             | timestamp(3) with time zone | Có       | now()                          |
| deleted_at             | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `purchase_intents_check`: `CHECK ((expires_at > created_at))`
- `purchase_intents_status_check`: `CHECK (((status)::text = ANY ((ARRAY['CREATED'::character varying, 'PENDING'::character varying, 'VERIFIED'::character varying, 'CANCELLED'::character varying, 'EXPIRED'::character varying, 'FAILED'::character varying])::text[])))`
- `purchase_intents_license_id_family_id_fkey`: `FOREIGN KEY (license_id, family_id) REFERENCES billing.family_licenses(id, family_id)`
- `purchase_intents_product_id_store_environment_app_namespac_fkey`: `FOREIGN KEY (product_id, store, environment, app_namespace) REFERENCES billing.products(id, store, environment, app_namespace)`
- `purchase_intents_purchaser_user_id_fkey`: `FOREIGN KEY (purchaser_user_id) REFERENCES app.users(id) ON DELETE SET NULL`
- `purchase_intents_app_account_token_not_null`: `NOT NULL app_account_token`
- `purchase_intents_app_namespace_not_null`: `NOT NULL app_namespace`
- `purchase_intents_client_idempotency_key_not_null`: `NOT NULL client_idempotency_key`
- `purchase_intents_created_at_not_null`: `NOT NULL created_at`
- `purchase_intents_environment_not_null`: `NOT NULL environment`
- `purchase_intents_expires_at_not_null`: `NOT NULL expires_at`
- `purchase_intents_family_id_not_null`: `NOT NULL family_id`
- `purchase_intents_id_not_null`: `NOT NULL id`
- `purchase_intents_license_id_not_null`: `NOT NULL license_id`
- `purchase_intents_product_id_not_null`: `NOT NULL product_id`
- `purchase_intents_status_not_null`: `NOT NULL status`
- `purchase_intents_store_not_null`: `NOT NULL store`
- `purchase_intents_updated_at_not_null`: `NOT NULL updated_at`
- `purchase_intents_pkey`: `PRIMARY KEY (id)`
- `purchase_intents_app_account_token_key`: `UNIQUE (app_account_token)`
- `purchase_intents_client_idempotency_key_key`: `UNIQUE (client_idempotency_key)`
- `purchase_intents_id_family_id_license_id_key`: `UNIQUE (id, family_id, license_id)`
- `purchase_intents_id_family_id_license_id_store_environment__key`: `UNIQUE (id, family_id, license_id, store, environment, app_namespace)`

Indexes:

- `purchase_intents_app_account_token_key`: `CREATE UNIQUE INDEX purchase_intents_app_account_token_key ON billing.purchase_intents USING btree (app_account_token)`
- `purchase_intents_client_idempotency_key_key`: `CREATE UNIQUE INDEX purchase_intents_client_idempotency_key_key ON billing.purchase_intents USING btree (client_idempotency_key)`
- `purchase_intents_id_family_id_license_id_key`: `CREATE UNIQUE INDEX purchase_intents_id_family_id_license_id_key ON billing.purchase_intents USING btree (id, family_id, license_id)`
- `purchase_intents_id_family_id_license_id_store_environment__key`: `CREATE UNIQUE INDEX purchase_intents_id_family_id_license_id_store_environment__key ON billing.purchase_intents USING btree (id, family_id, license_id, store, environment, app_namespace)`
- `purchase_intents_pkey`: `CREATE UNIQUE INDEX purchase_intents_pkey ON billing.purchase_intents USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON billing.purchase_intents FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON billing.purchase_intents FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_immutable_purchase_intent`: `CREATE TRIGGER trg_immutable_purchase_intent BEFORE UPDATE ON billing.purchase_intents FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('license_id', 'product_id', 'store', 'environment', 'app_namespace', 'app_account_token', 'client_idempotency_key')`
- `trg_no_delete`: `CREATE TRIGGER trg_no_delete BEFORE DELETE ON billing.purchase_intents FOR EACH ROW EXECUTE FUNCTION ops.deny_physical_delete()`

## billing.store_notifications — StoreNotification

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| id              | uuid                        | Có       | uuidv7()                       |
| store           | billing.store               | Có       | —                              |
| environment     | character varying(12)       | Có       | —                              |
| app_namespace   | character varying(255)      | Có       | —                              |
| notification_id | character varying(255)      | Có       | —                              |
| type            | character varying(100)      | Không    | —                              |
| subtype         | character varying(100)      | Không    | —                              |
| payload_hash    | bytea                       | Có       | —                              |
| payload_enc     | bytea                       | Không    | —                              |
| subscription_id | uuid                        | Không    | —                              |
| received_at     | timestamp(3) with time zone | Có       | now()                          |
| processed_at    | timestamp(3) with time zone | Không    | —                              |
| status          | character varying(16)       | Có       | 'PENDING'::character varying   |
| attempts        | integer                     | Có       | 0                              |
| next_attempt_at | timestamp(3) with time zone | Không    | —                              |
| last_error_code | character varying(80)       | Không    | —                              |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `store_notifications_check`: `CHECK (((attempts >= 0) AND (octet_length(payload_hash) = 32)))`
- `store_notifications_environment_check`: `CHECK (((environment)::text = ANY ((ARRAY['PRODUCTION'::character varying, 'SANDBOX'::character varying])::text[])))`
- `store_notifications_status_check`: `CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'PROCESSING'::character varying, 'PROCESSED'::character varying, 'RETRY_WAIT'::character varying, 'QUARANTINED'::character varying, 'FAILED'::character varying])::text[])))`
- `store_notifications_subscription_id_fkey`: `FOREIGN KEY (subscription_id) REFERENCES billing.subscriptions(id)`
- `store_notifications_subscription_id_store_environment_app__fkey`: `FOREIGN KEY (subscription_id, store, environment, app_namespace) REFERENCES billing.subscriptions(id, store, environment, app_namespace)`
- `store_notifications_app_namespace_not_null`: `NOT NULL app_namespace`
- `store_notifications_attempts_not_null`: `NOT NULL attempts`
- `store_notifications_created_at_not_null`: `NOT NULL created_at`
- `store_notifications_environment_not_null`: `NOT NULL environment`
- `store_notifications_id_not_null`: `NOT NULL id`
- `store_notifications_notification_id_not_null`: `NOT NULL notification_id`
- `store_notifications_payload_hash_not_null`: `NOT NULL payload_hash`
- `store_notifications_received_at_not_null`: `NOT NULL received_at`
- `store_notifications_status_not_null`: `NOT NULL status`
- `store_notifications_store_not_null`: `NOT NULL store`
- `store_notifications_updated_at_not_null`: `NOT NULL updated_at`
- `store_notifications_pkey`: `PRIMARY KEY (id)`
- `store_notifications_store_environment_app_namespace_notific_key`: `UNIQUE (store, environment, app_namespace, notification_id)`

Indexes:

- `ix_store_notification_pending`: `CREATE INDEX ix_store_notification_pending ON billing.store_notifications USING btree (next_attempt_at, received_at) WHERE (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'RETRY_WAIT'::character varying])::text[])) AND (deleted_at IS NULL))`
- `store_notifications_pkey`: `CREATE UNIQUE INDEX store_notifications_pkey ON billing.store_notifications USING btree (id)`
- `store_notifications_store_environment_app_namespace_notific_key`: `CREATE UNIQUE INDEX store_notifications_store_environment_app_namespace_notific_key ON billing.store_notifications USING btree (store, environment, app_namespace, notification_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON billing.store_notifications FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_store_notification`: `CREATE TRIGGER trg_immutable_store_notification BEFORE UPDATE ON billing.store_notifications FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('store', 'environment', 'app_namespace', 'notification_id', 'payload_hash')`
- `trg_no_delete`: `CREATE TRIGGER trg_no_delete BEFORE DELETE ON billing.store_notifications FOR EACH ROW EXECUTE FUNCTION ops.deny_physical_delete()`

## billing.subscription_transactions — SubscriptionTransaction

| Cột                     | PostgreSQL type             | NOT NULL | Default                        |
| ----------------------- | --------------------------- | -------- | ------------------------------ |
| id                      | uuid                        | Có       | uuidv7()                       |
| subscription_id         | uuid                        | Có       | —                              |
| family_id               | uuid                        | Có       | —                              |
| license_id              | uuid                        | Có       | —                              |
| store                   | billing.store               | Có       | —                              |
| environment             | character varying(12)       | Có       | —                              |
| app_namespace           | character varying(255)      | Có       | —                              |
| provider_transaction_id | character varying(255)      | Có       | —                              |
| kind                    | character varying(30)       | Có       | —                              |
| product_id              | uuid                        | Có       | —                              |
| period_start            | timestamp(3) with time zone | Không    | —                              |
| period_end              | timestamp(3) with time zone | Không    | —                              |
| purchased_at            | timestamp(3) with time zone | Có       | —                              |
| revoked_at              | timestamp(3) with time zone | Không    | —                              |
| verified_at             | timestamp(3) with time zone | Có       | —                              |
| amount_minor            | bigint                      | Không    | —                              |
| currency                | character(3)                | Không    | —                              |
| payload_hash            | bytea                       | Có       | —                              |
| replaces_transaction_id | uuid                        | Không    | —                              |
| created_at              | timestamp(3) with time zone | Có       | now()                          |
| updated_at              | timestamp(3) with time zone | Có       | now()                          |
| deleted_at              | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| plan_version_id         | uuid                        | Có       | —                              |

Constraints:

- `subscription_transactions_amount_minor_check`: `CHECK (((amount_minor IS NULL) OR (amount_minor >= 0)))`
- `subscription_transactions_check`: `CHECK (((period_end IS NULL) OR (period_start IS NULL) OR (period_end >= period_start)))`
- `subscription_transactions_check1`: `CHECK (((replaces_transaction_id IS NULL) OR (replaces_transaction_id <> id)))`
- `subscription_transactions_payload_hash_check`: `CHECK ((octet_length(payload_hash) = 32))`
- `subscription_transactions_plan_version_id_fkey`: `FOREIGN KEY (plan_version_id) REFERENCES billing.plan_versions(id)`
- `subscription_transactions_product_id_fkey`: `FOREIGN KEY (product_id) REFERENCES billing.products(id)`
- `subscription_transactions_product_id_store_environment_app_fkey`: `FOREIGN KEY (product_id, store, environment, app_namespace) REFERENCES billing.products(id, store, environment, app_namespace)`
- `subscription_transactions_replaces_transaction_id_family_i_fkey`: `FOREIGN KEY (replaces_transaction_id, family_id, license_id, store, environment, app_namespace) REFERENCES billing.subscription_transactions(id, family_id, license_id, store, environment, app_namespace)`
- `subscription_transactions_replaces_transaction_id_fkey`: `FOREIGN KEY (replaces_transaction_id) REFERENCES billing.subscription_transactions(id)`
- `subscription_transactions_subscription_id_family_id_licens_fkey`: `FOREIGN KEY (subscription_id, family_id, license_id) REFERENCES billing.subscriptions(id, family_id, license_id)`
- `subscription_transactions_subscription_id_store_environmen_fkey`: `FOREIGN KEY (subscription_id, store, environment, app_namespace) REFERENCES billing.subscriptions(id, store, environment, app_namespace)`
- `subscription_transactions_app_namespace_not_null`: `NOT NULL app_namespace`
- `subscription_transactions_created_at_not_null`: `NOT NULL created_at`
- `subscription_transactions_environment_not_null`: `NOT NULL environment`
- `subscription_transactions_family_id_not_null`: `NOT NULL family_id`
- `subscription_transactions_id_not_null`: `NOT NULL id`
- `subscription_transactions_kind_not_null`: `NOT NULL kind`
- `subscription_transactions_license_id_not_null`: `NOT NULL license_id`
- `subscription_transactions_payload_hash_not_null`: `NOT NULL payload_hash`
- `subscription_transactions_plan_version_id_not_null`: `NOT NULL plan_version_id`
- `subscription_transactions_product_id_not_null`: `NOT NULL product_id`
- `subscription_transactions_provider_transaction_id_not_null`: `NOT NULL provider_transaction_id`
- `subscription_transactions_purchased_at_not_null`: `NOT NULL purchased_at`
- `subscription_transactions_store_not_null`: `NOT NULL store`
- `subscription_transactions_subscription_id_not_null`: `NOT NULL subscription_id`
- `subscription_transactions_updated_at_not_null`: `NOT NULL updated_at`
- `subscription_transactions_verified_at_not_null`: `NOT NULL verified_at`
- `subscription_transactions_pkey`: `PRIMARY KEY (id)`
- `subscription_transactions_id_family_id_license_id_key`: `UNIQUE (id, family_id, license_id)`
- `subscription_transactions_id_family_id_license_id_plan_vers_key`: `UNIQUE (id, family_id, license_id, plan_version_id)`
- `subscription_transactions_id_family_id_license_id_store_env_key`: `UNIQUE (id, family_id, license_id, store, environment, app_namespace)`
- `subscription_transactions_id_subscription_id_family_id_lice_key`: `UNIQUE (id, subscription_id, family_id, license_id, plan_version_id)`
- `subscription_transactions_store_environment_app_namespace_p_key`: `UNIQUE (store, environment, app_namespace, provider_transaction_id)`

Indexes:

- `subscription_transactions_id_family_id_license_id_key`: `CREATE UNIQUE INDEX subscription_transactions_id_family_id_license_id_key ON billing.subscription_transactions USING btree (id, family_id, license_id)`
- `subscription_transactions_id_family_id_license_id_plan_vers_key`: `CREATE UNIQUE INDEX subscription_transactions_id_family_id_license_id_plan_vers_key ON billing.subscription_transactions USING btree (id, family_id, license_id, plan_version_id)`
- `subscription_transactions_id_family_id_license_id_store_env_key`: `CREATE UNIQUE INDEX subscription_transactions_id_family_id_license_id_store_env_key ON billing.subscription_transactions USING btree (id, family_id, license_id, store, environment, app_namespace)`
- `subscription_transactions_id_subscription_id_family_id_lice_key`: `CREATE UNIQUE INDEX subscription_transactions_id_subscription_id_family_id_lice_key ON billing.subscription_transactions USING btree (id, subscription_id, family_id, license_id, plan_version_id)`
- `subscription_transactions_pkey`: `CREATE UNIQUE INDEX subscription_transactions_pkey ON billing.subscription_transactions USING btree (id)`
- `subscription_transactions_store_environment_app_namespace_p_key`: `CREATE UNIQUE INDEX subscription_transactions_store_environment_app_namespace_p_key ON billing.subscription_transactions USING btree (store, environment, app_namespace, provider_transaction_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON billing.subscription_transactions FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON billing.subscription_transactions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_immutable_transaction`: `CREATE TRIGGER trg_immutable_transaction BEFORE UPDATE ON billing.subscription_transactions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('subscription_id', 'license_id', 'store', 'environment', 'app_namespace', 'provider_transaction_id', 'product_id', 'purchased_at', 'period_start', 'period_end')`
- `trg_immutable_transaction_plan`: `CREATE TRIGGER trg_immutable_transaction_plan BEFORE UPDATE ON billing.subscription_transactions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('plan_version_id')`
- `trg_no_delete`: `CREATE TRIGGER trg_no_delete BEFORE DELETE ON billing.subscription_transactions FOR EACH ROW EXECUTE FUNCTION ops.deny_physical_delete()`

## billing.subscriptions — Subscription

| Cột                     | PostgreSQL type             | NOT NULL | Default                        |
| ----------------------- | --------------------------- | -------- | ------------------------------ |
| id                      | uuid                        | Có       | uuidv7()                       |
| family_id               | uuid                        | Có       | —                              |
| license_id              | uuid                        | Có       | —                              |
| purchase_intent_id      | uuid                        | Có       | —                              |
| purchaser_user_id       | uuid                        | Không    | —                              |
| product_id              | uuid                        | Có       | —                              |
| store                   | billing.store               | Có       | —                              |
| environment             | character varying(12)       | Có       | —                              |
| app_namespace           | character varying(255)      | Có       | —                              |
| original_transaction_id | character varying(255)      | Không    | —                              |
| purchase_token_enc      | bytea                       | Không    | —                              |
| purchase_token_hash     | bytea                       | Không    | —                              |
| store_binding_key       | bytea                       | Có       | —                              |
| app_account_token       | uuid                        | Không    | —                              |
| status                  | billing.sub_status          | Có       | —                              |
| auto_renew              | boolean                     | Có       | true                           |
| in_trial                | boolean                     | Có       | false                          |
| current_period_start    | timestamp(3) with time zone | Không    | —                              |
| current_period_end      | timestamp(3) with time zone | Không    | —                              |
| grace_until             | timestamp(3) with time zone | Không    | —                              |
| last_verified_at        | timestamp(3) with time zone | Không    | —                              |
| superseded_by           | uuid                        | Không    | —                              |
| detached_purchaser_at   | timestamp(3) with time zone | Không    | —                              |
| created_at              | timestamp(3) with time zone | Có       | now()                          |
| updated_at              | timestamp(3) with time zone | Có       | now()                          |
| deleted_at              | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `subscriptions_check`: `CHECK (((current_period_end IS NULL) OR (current_period_start IS NULL) OR (current_period_end >= current_period_start)))`
- `subscriptions_check1`: `CHECK ((((store = 'APPLE'::billing.store) AND (original_transaction_id IS NOT NULL)) OR ((store = 'GOOGLE'::billing.store) AND (purchase_token_hash IS NOT NULL) AND (purchase_token_enc IS NOT NULL))))`
- `subscriptions_check2`: `CHECK (((superseded_by IS NULL) OR (superseded_by <> id)))`
- `subscriptions_purchase_token_hash_check`: `CHECK (((purchase_token_hash IS NULL) OR (octet_length(purchase_token_hash) = 32)))`
- `subscriptions_store_binding_key_check`: `CHECK ((octet_length(store_binding_key) = 32))`
- `subscriptions_license_id_family_id_fkey`: `FOREIGN KEY (license_id, family_id) REFERENCES billing.family_licenses(id, family_id)`
- `subscriptions_product_id_store_environment_app_namespace_fkey`: `FOREIGN KEY (product_id, store, environment, app_namespace) REFERENCES billing.products(id, store, environment, app_namespace)`
- `subscriptions_purchase_intent_id_family_id_license_id_fkey`: `FOREIGN KEY (purchase_intent_id, family_id, license_id) REFERENCES billing.purchase_intents(id, family_id, license_id)`
- `subscriptions_purchase_intent_id_family_id_license_id_stor_fkey`: `FOREIGN KEY (purchase_intent_id, family_id, license_id, store, environment, app_namespace) REFERENCES billing.purchase_intents(id, family_id, license_id, store, environment, app_namespace)`
- `subscriptions_purchaser_user_id_fkey`: `FOREIGN KEY (purchaser_user_id) REFERENCES app.users(id) ON DELETE SET NULL`
- `subscriptions_superseded_by_family_id_license_id_store_env_fkey`: `FOREIGN KEY (superseded_by, family_id, license_id, store, environment, app_namespace) REFERENCES billing.subscriptions(id, family_id, license_id, store, environment, app_namespace)`
- `subscriptions_superseded_by_fkey`: `FOREIGN KEY (superseded_by) REFERENCES billing.subscriptions(id)`
- `subscriptions_app_namespace_not_null`: `NOT NULL app_namespace`
- `subscriptions_auto_renew_not_null`: `NOT NULL auto_renew`
- `subscriptions_created_at_not_null`: `NOT NULL created_at`
- `subscriptions_environment_not_null`: `NOT NULL environment`
- `subscriptions_family_id_not_null`: `NOT NULL family_id`
- `subscriptions_id_not_null`: `NOT NULL id`
- `subscriptions_in_trial_not_null`: `NOT NULL in_trial`
- `subscriptions_license_id_not_null`: `NOT NULL license_id`
- `subscriptions_product_id_not_null`: `NOT NULL product_id`
- `subscriptions_purchase_intent_id_not_null`: `NOT NULL purchase_intent_id`
- `subscriptions_status_not_null`: `NOT NULL status`
- `subscriptions_store_binding_key_not_null`: `NOT NULL store_binding_key`
- `subscriptions_store_not_null`: `NOT NULL store`
- `subscriptions_updated_at_not_null`: `NOT NULL updated_at`
- `subscriptions_pkey`: `PRIMARY KEY (id)`
- `subscriptions_id_family_id_license_id_key`: `UNIQUE (id, family_id, license_id)`
- `subscriptions_id_family_id_license_id_store_environment_app_key`: `UNIQUE (id, family_id, license_id, store, environment, app_namespace)`
- `subscriptions_id_store_environment_app_namespace_key`: `UNIQUE (id, store, environment, app_namespace)`
- `subscriptions_store_environment_app_namespace_store_binding_key`: `UNIQUE (store, environment, app_namespace, store_binding_key)`

Indexes:

- `ix_subscription_family`: `CREATE INDEX ix_subscription_family ON billing.subscriptions USING btree (family_id, status, current_period_end) WHERE (deleted_at IS NULL)`
- `subscriptions_id_family_id_license_id_key`: `CREATE UNIQUE INDEX subscriptions_id_family_id_license_id_key ON billing.subscriptions USING btree (id, family_id, license_id)`
- `subscriptions_id_family_id_license_id_store_environment_app_key`: `CREATE UNIQUE INDEX subscriptions_id_family_id_license_id_store_environment_app_key ON billing.subscriptions USING btree (id, family_id, license_id, store, environment, app_namespace)`
- `subscriptions_id_store_environment_app_namespace_key`: `CREATE UNIQUE INDEX subscriptions_id_store_environment_app_namespace_key ON billing.subscriptions USING btree (id, store, environment, app_namespace)`
- `subscriptions_pkey`: `CREATE UNIQUE INDEX subscriptions_pkey ON billing.subscriptions USING btree (id)`
- `subscriptions_store_environment_app_namespace_store_binding_key`: `CREATE UNIQUE INDEX subscriptions_store_environment_app_namespace_store_binding_key ON billing.subscriptions USING btree (store, environment, app_namespace, store_binding_key)`
- `uq_subscription_apple_identity`: `CREATE UNIQUE INDEX uq_subscription_apple_identity ON billing.subscriptions USING btree (store, environment, app_namespace, original_transaction_id) WHERE (original_transaction_id IS NOT NULL)`
- `uq_subscription_google_identity`: `CREATE UNIQUE INDEX uq_subscription_google_identity ON billing.subscriptions USING btree (store, environment, app_namespace, purchase_token_hash) WHERE (purchase_token_hash IS NOT NULL)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON billing.subscriptions FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON billing.subscriptions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_immutable_subscription_binding`: `CREATE TRIGGER trg_immutable_subscription_binding BEFORE UPDATE ON billing.subscriptions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('license_id', 'purchase_intent_id', 'store', 'environment', 'app_namespace', 'store_binding_key', 'original_transaction_id')`
- `trg_no_delete`: `CREATE TRIGGER trg_no_delete BEFORE DELETE ON billing.subscriptions FOR EACH ROW EXECUTE FUNCTION ops.deny_physical_delete()`

## billing.trial_consumptions — TrialConsumption

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| trial_policy_id | uuid                        | Có       | —                              |
| id              | uuid                        | Có       | uuidv7()                       |
| user_id         | uuid                        | Không    | —                              |
| identity_hash   | bytea                       | Có       | —                              |
| family_id       | uuid                        | Có       | —                              |
| grant_id        | uuid                        | Không    | —                              |
| started_at      | timestamp(3) with time zone | Có       | now()                          |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `trial_consumptions_identity_hash_check`: `CHECK ((octet_length(identity_hash) = 32))`
- `trial_consumptions_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `trial_consumptions_grant_id_family_id_fkey`: `FOREIGN KEY (grant_id, family_id) REFERENCES billing.license_grants(id, family_id)`
- `trial_consumptions_trial_policy_id_fkey`: `FOREIGN KEY (trial_policy_id) REFERENCES billing.trial_policies(id)`
- `trial_consumptions_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id) ON DELETE SET NULL`
- `trial_consumptions_created_at_not_null`: `NOT NULL created_at`
- `trial_consumptions_family_id_not_null`: `NOT NULL family_id`
- `trial_consumptions_id_not_null`: `NOT NULL id`
- `trial_consumptions_identity_hash_not_null`: `NOT NULL identity_hash`
- `trial_consumptions_started_at_not_null`: `NOT NULL started_at`
- `trial_consumptions_trial_policy_id_not_null`: `NOT NULL trial_policy_id`
- `trial_consumptions_updated_at_not_null`: `NOT NULL updated_at`
- `trial_consumptions_pkey`: `PRIMARY KEY (id)`
- `trial_consumptions_identity_hash_key`: `UNIQUE (identity_hash)`

Indexes:

- `trial_consumptions_identity_hash_key`: `CREATE UNIQUE INDEX trial_consumptions_identity_hash_key ON billing.trial_consumptions USING btree (identity_hash)`
- `trial_consumptions_pkey`: `CREATE UNIQUE INDEX trial_consumptions_pkey ON billing.trial_consumptions USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON billing.trial_consumptions FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON billing.trial_consumptions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_no_delete`: `CREATE TRIGGER trg_no_delete BEFORE DELETE ON billing.trial_consumptions FOR EACH ROW EXECUTE FUNCTION ops.deny_physical_delete()`

## billing.trial_policies — TrialPolicy

| Cột                      | PostgreSQL type             | NOT NULL | Default                        |
| ------------------------ | --------------------------- | -------- | ------------------------------ |
| id                       | uuid                        | Có       | uuidv7()                       |
| code                     | character varying(60)       | Có       | —                              |
| version                  | integer                     | Có       | —                              |
| plan_version_id          | uuid                        | Có       | —                              |
| duration_seconds         | bigint                      | Có       | —                              |
| reminder_offsets_seconds | integer[]                   | Có       | '{}'::integer[]                |
| active                   | boolean                     | Có       | false                          |
| published_at             | timestamp(3) with time zone | Không    | —                              |
| retired_at               | timestamp(3) with time zone | Không    | —                              |
| created_at               | timestamp(3) with time zone | Có       | now()                          |
| updated_at               | timestamp(3) with time zone | Có       | now()                          |
| deleted_at               | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `trial_policies_check`: `CHECK (((active = false) OR (published_at IS NOT NULL)))`
- `trial_policies_check1`: `CHECK (((retired_at IS NULL) OR (published_at IS NULL) OR (retired_at >= published_at)))`
- `trial_policies_duration_seconds_check`: `CHECK ((duration_seconds > 0))`
- `trial_policies_reminder_offsets_seconds_check`: `CHECK ((0 < ALL (reminder_offsets_seconds)))`
- `trial_policies_version_check`: `CHECK ((version > 0))`
- `trial_policies_plan_version_id_fkey`: `FOREIGN KEY (plan_version_id) REFERENCES billing.plan_versions(id)`
- `trial_policies_active_not_null`: `NOT NULL active`
- `trial_policies_code_not_null`: `NOT NULL code`
- `trial_policies_created_at_not_null`: `NOT NULL created_at`
- `trial_policies_duration_seconds_not_null`: `NOT NULL duration_seconds`
- `trial_policies_id_not_null`: `NOT NULL id`
- `trial_policies_plan_version_id_not_null`: `NOT NULL plan_version_id`
- `trial_policies_reminder_offsets_seconds_not_null`: `NOT NULL reminder_offsets_seconds`
- `trial_policies_updated_at_not_null`: `NOT NULL updated_at`
- `trial_policies_version_not_null`: `NOT NULL version`
- `trial_policies_pkey`: `PRIMARY KEY (id)`
- `trial_policies_code_version_key`: `UNIQUE (code, version)`
- `trial_policies_id_plan_version_id_key`: `UNIQUE (id, plan_version_id)`

Indexes:

- `trial_policies_code_version_key`: `CREATE UNIQUE INDEX trial_policies_code_version_key ON billing.trial_policies USING btree (code, version)`
- `trial_policies_id_plan_version_id_key`: `CREATE UNIQUE INDEX trial_policies_id_plan_version_id_key ON billing.trial_policies USING btree (id, plan_version_id)`
- `trial_policies_pkey`: `CREATE UNIQUE INDEX trial_policies_pkey ON billing.trial_policies USING btree (id)`
- `uq_active_trial_policy`: `CREATE UNIQUE INDEX uq_active_trial_policy ON billing.trial_policies USING btree (code) WHERE (active AND (deleted_at IS NULL))`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON billing.trial_policies FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_trial_policy`: `CREATE TRIGGER trg_immutable_trial_policy BEFORE UPDATE ON billing.trial_policies FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('code', 'version', 'plan_version_id', 'duration_seconds', 'reminder_offsets_seconds')`

## ops.admin_audit_events — AdminAuditEvent

| Cột              | PostgreSQL type             | NOT NULL | Default                        |
| ---------------- | --------------------------- | -------- | ------------------------------ |
| id               | bigint                      | Có       | —                              |
| admin_id         | uuid                        | Không    | —                              |
| action           | character varying(80)       | Có       | —                              |
| entity_type      | character varying(80)       | Có       | —                              |
| entity_id        | character varying(255)      | Không    | —                              |
| trace_id         | character varying(100)      | Không    | —                              |
| reason_code      | character varying(80)       | Không    | —                              |
| redacted_changes | jsonb                       | Có       | '{}'::jsonb                    |
| created_at       | timestamp(3) with time zone | Có       | now()                          |
| updated_at       | timestamp(3) with time zone | Có       | now()                          |
| deleted_at       | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `admin_audit_events_admin_id_fkey`: `FOREIGN KEY (admin_id) REFERENCES ops.admin_users(id)`
- `admin_audit_events_action_not_null`: `NOT NULL action`
- `admin_audit_events_created_at_not_null`: `NOT NULL created_at`
- `admin_audit_events_entity_type_not_null`: `NOT NULL entity_type`
- `admin_audit_events_id_not_null`: `NOT NULL id`
- `admin_audit_events_redacted_changes_not_null`: `NOT NULL redacted_changes`
- `admin_audit_events_updated_at_not_null`: `NOT NULL updated_at`
- `admin_audit_events_pkey`: `PRIMARY KEY (id)`

Indexes:

- `admin_audit_events_pkey`: `CREATE UNIQUE INDEX admin_audit_events_pkey ON ops.admin_audit_events USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.admin_audit_events FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## ops.admin_sessions — AdminSession

| Cột                | PostgreSQL type             | NOT NULL | Default                        |
| ------------------ | --------------------------- | -------- | ------------------------------ |
| id                 | uuid                        | Có       | uuidv7()                       |
| admin_id           | uuid                        | Có       | —                              |
| refresh_token_hash | bytea                       | Có       | —                              |
| mfa_verified_at    | timestamp(3) with time zone | Có       | —                              |
| expires_at         | timestamp(3) with time zone | Có       | —                              |
| revoked_at         | timestamp(3) with time zone | Không    | —                              |
| created_at         | timestamp(3) with time zone | Có       | now()                          |
| updated_at         | timestamp(3) with time zone | Có       | now()                          |
| deleted_at         | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `admin_sessions_admin_id_fkey`: `FOREIGN KEY (admin_id) REFERENCES ops.admin_users(id)`
- `admin_sessions_admin_id_not_null`: `NOT NULL admin_id`
- `admin_sessions_created_at_not_null`: `NOT NULL created_at`
- `admin_sessions_expires_at_not_null`: `NOT NULL expires_at`
- `admin_sessions_id_not_null`: `NOT NULL id`
- `admin_sessions_mfa_verified_at_not_null`: `NOT NULL mfa_verified_at`
- `admin_sessions_refresh_token_hash_not_null`: `NOT NULL refresh_token_hash`
- `admin_sessions_updated_at_not_null`: `NOT NULL updated_at`
- `admin_sessions_pkey`: `PRIMARY KEY (id)`
- `admin_sessions_refresh_token_hash_key`: `UNIQUE (refresh_token_hash)`

Indexes:

- `admin_sessions_pkey`: `CREATE UNIQUE INDEX admin_sessions_pkey ON ops.admin_sessions USING btree (id)`
- `admin_sessions_refresh_token_hash_key`: `CREATE UNIQUE INDEX admin_sessions_refresh_token_hash_key ON ops.admin_sessions USING btree (refresh_token_hash)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.admin_sessions FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## ops.admin_users — AdminUser

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| id              | uuid                        | Có       | uuidv7()                       |
| email           | citext                      | Có       | —                              |
| password_hash   | text                        | Có       | —                              |
| totp_secret_enc | bytea                       | Có       | —                              |
| roles           | text[]                      | Có       | —                              |
| status          | character varying(10)       | Có       | 'ACTIVE'::character varying    |
| last_login_at   | timestamp(3) with time zone | Không    | —                              |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `admin_users_created_at_not_null`: `NOT NULL created_at`
- `admin_users_email_not_null`: `NOT NULL email`
- `admin_users_id_not_null`: `NOT NULL id`
- `admin_users_password_hash_not_null`: `NOT NULL password_hash`
- `admin_users_roles_not_null`: `NOT NULL roles`
- `admin_users_status_not_null`: `NOT NULL status`
- `admin_users_totp_secret_enc_not_null`: `NOT NULL totp_secret_enc`
- `admin_users_updated_at_not_null`: `NOT NULL updated_at`
- `admin_users_pkey`: `PRIMARY KEY (id)`
- `admin_users_email_key`: `UNIQUE (email)`

Indexes:

- `admin_users_email_key`: `CREATE UNIQUE INDEX admin_users_email_key ON ops.admin_users USING btree (email)`
- `admin_users_pkey`: `CREATE UNIQUE INDEX admin_users_pkey ON ops.admin_users USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.admin_users FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## ops.ai_invocations — AiInvocation

| Cột               | PostgreSQL type             | NOT NULL | Default                        |
| ----------------- | --------------------------- | -------- | ------------------------------ |
| id                | uuid                        | Có       | uuidv7()                       |
| family_id         | uuid                        | Có       | —                              |
| requester_user_id | uuid                        | Không    | —                              |
| feature_code      | character varying(60)       | Có       | —                              |
| prompt_version    | character varying(40)       | Có       | —                              |
| model_id          | character varying(100)      | Có       | —                              |
| status            | character varying(16)       | Có       | —                              |
| input_tokens      | integer                     | Không    | —                              |
| output_tokens     | integer                     | Không    | —                              |
| duration_ms       | integer                     | Không    | —                              |
| error_code        | character varying(80)       | Không    | —                              |
| consent_id        | uuid                        | Không    | —                              |
| created_at        | timestamp(3) with time zone | Có       | now()                          |
| updated_at        | timestamp(3) with time zone | Có       | now()                          |
| deleted_at        | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `ai_invocations_check`: `CHECK ((((input_tokens IS NULL) OR (input_tokens >= 0)) AND ((output_tokens IS NULL) OR (output_tokens >= 0)) AND ((duration_ms IS NULL) OR (duration_ms >= 0))))`
- `ai_invocations_status_check`: `CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'SUCCEEDED'::character varying, 'FAILED'::character varying, 'REFUSED'::character varying])::text[])))`
- `ai_invocations_consent_id_fkey`: `FOREIGN KEY (consent_id) REFERENCES app.user_consents(id)`
- `ai_invocations_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `ai_invocations_requester_user_id_fkey`: `FOREIGN KEY (requester_user_id) REFERENCES app.users(id)`
- `ai_invocations_created_at_not_null`: `NOT NULL created_at`
- `ai_invocations_family_id_not_null`: `NOT NULL family_id`
- `ai_invocations_feature_code_not_null`: `NOT NULL feature_code`
- `ai_invocations_id_not_null`: `NOT NULL id`
- `ai_invocations_model_id_not_null`: `NOT NULL model_id`
- `ai_invocations_prompt_version_not_null`: `NOT NULL prompt_version`
- `ai_invocations_status_not_null`: `NOT NULL status`
- `ai_invocations_updated_at_not_null`: `NOT NULL updated_at`
- `ai_invocations_pkey`: `PRIMARY KEY (id)`
- `ai_invocations_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `ai_invocations_id_family_id_key`: `CREATE UNIQUE INDEX ai_invocations_id_family_id_key ON ops.ai_invocations USING btree (id, family_id)`
- `ai_invocations_pkey`: `CREATE UNIQUE INDEX ai_invocations_pkey ON ops.ai_invocations USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.ai_invocations FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON ops.ai_invocations FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## ops.ai_usage_reservations — AiUsageReservation

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| id              | uuid                        | Có       | uuidv7()                       |
| family_id       | uuid                        | Có       | —                              |
| invocation_id   | uuid                        | Có       | —                              |
| idempotency_key | uuid                        | Có       | —                              |
| usage_month     | date                        | Có       | —                              |
| status          | character varying(12)       | Có       | 'RESERVED'::character varying  |
| expires_at      | timestamp(3) with time zone | Có       | —                              |
| consumed_at     | timestamp(3) with time zone | Không    | —                              |
| released_at     | timestamp(3) with time zone | Không    | —                              |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `ai_usage_reservations_status_check`: `CHECK (((status)::text = ANY ((ARRAY['RESERVED'::character varying, 'CONSUMED'::character varying, 'RELEASED'::character varying, 'EXPIRED'::character varying])::text[])))`
- `ai_usage_reservations_usage_month_check`: `CHECK ((EXTRACT(day FROM usage_month) = (1)::numeric))`
- `ai_usage_reservations_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `ai_usage_reservations_invocation_id_family_id_fkey`: `FOREIGN KEY (invocation_id, family_id) REFERENCES ops.ai_invocations(id, family_id)`
- `ai_usage_reservations_invocation_id_fkey`: `FOREIGN KEY (invocation_id) REFERENCES ops.ai_invocations(id)`
- `ai_usage_reservations_created_at_not_null`: `NOT NULL created_at`
- `ai_usage_reservations_expires_at_not_null`: `NOT NULL expires_at`
- `ai_usage_reservations_family_id_not_null`: `NOT NULL family_id`
- `ai_usage_reservations_id_not_null`: `NOT NULL id`
- `ai_usage_reservations_idempotency_key_not_null`: `NOT NULL idempotency_key`
- `ai_usage_reservations_invocation_id_not_null`: `NOT NULL invocation_id`
- `ai_usage_reservations_status_not_null`: `NOT NULL status`
- `ai_usage_reservations_updated_at_not_null`: `NOT NULL updated_at`
- `ai_usage_reservations_usage_month_not_null`: `NOT NULL usage_month`
- `ai_usage_reservations_pkey`: `PRIMARY KEY (id)`
- `ai_usage_reservations_idempotency_key_key`: `UNIQUE (idempotency_key)`
- `ai_usage_reservations_invocation_id_key`: `UNIQUE (invocation_id)`

Indexes:

- `ai_usage_reservations_idempotency_key_key`: `CREATE UNIQUE INDEX ai_usage_reservations_idempotency_key_key ON ops.ai_usage_reservations USING btree (idempotency_key)`
- `ai_usage_reservations_invocation_id_key`: `CREATE UNIQUE INDEX ai_usage_reservations_invocation_id_key ON ops.ai_usage_reservations USING btree (invocation_id)`
- `ai_usage_reservations_pkey`: `CREATE UNIQUE INDEX ai_usage_reservations_pkey ON ops.ai_usage_reservations USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.ai_usage_reservations FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON ops.ai_usage_reservations FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## ops.app_config — AppConfig

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| key        | character varying(60)       | Có       | —                              |
| value      | jsonb                       | Có       | —                              |
| updated_by | uuid                        | Không    | —                              |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `app_config_updated_by_fkey`: `FOREIGN KEY (updated_by) REFERENCES ops.admin_users(id)`
- `app_config_created_at_not_null`: `NOT NULL created_at`
- `app_config_key_not_null`: `NOT NULL key`
- `app_config_updated_at_not_null`: `NOT NULL updated_at`
- `app_config_value_not_null`: `NOT NULL value`
- `app_config_pkey`: `PRIMARY KEY (key)`

Indexes:

- `app_config_pkey`: `CREATE UNIQUE INDEX app_config_pkey ON ops.app_config USING btree (key)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.app_config FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## ops.content_items — ContentItem

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| type       | character varying(30)       | Có       | —                              |
| code       | character varying(40)       | Có       | —                              |
| locale     | character varying(10)       | Có       | —                              |
| data       | jsonb                       | Có       | —                              |
| sort_order | integer                     | Có       | 0                              |
| status     | character varying(10)       | Có       | 'ACTIVE'::character varying    |
| version    | integer                     | Có       | 1                              |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `content_items_code_not_null`: `NOT NULL code`
- `content_items_created_at_not_null`: `NOT NULL created_at`
- `content_items_data_not_null`: `NOT NULL data`
- `content_items_locale_not_null`: `NOT NULL locale`
- `content_items_sort_order_not_null`: `NOT NULL sort_order`
- `content_items_status_not_null`: `NOT NULL status`
- `content_items_type_not_null`: `NOT NULL type`
- `content_items_updated_at_not_null`: `NOT NULL updated_at`
- `content_items_version_not_null`: `NOT NULL version`
- `content_items_pkey`: `PRIMARY KEY (type, code, locale)`

Indexes:

- `content_items_pkey`: `CREATE UNIQUE INDEX content_items_pkey ON ops.content_items USING btree (type, code, locale)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.content_items FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## ops.idempotency_records — IdempotencyRecord

| Cột                | PostgreSQL type             | NOT NULL | Default                        |
| ------------------ | --------------------------- | -------- | ------------------------------ |
| id                 | uuid                        | Có       | uuidv7()                       |
| actor_user_id      | uuid                        | Không    | —                              |
| family_id          | uuid                        | Không    | —                              |
| operation          | character varying(100)      | Có       | —                              |
| scope_key          | character varying(255)      | Có       | —                              |
| idempotency_key    | uuid                        | Có       | —                              |
| request_hash       | bytea                       | Có       | —                              |
| status             | character varying(12)       | Có       | 'PENDING'::character varying   |
| result_entity_type | character varying(80)       | Không    | —                              |
| result_entity_id   | uuid                        | Không    | —                              |
| response_code      | integer                     | Không    | —                              |
| response_reference | jsonb                       | Không    | —                              |
| expires_at         | timestamp(3) with time zone | Không    | —                              |
| created_at         | timestamp(3) with time zone | Có       | now()                          |
| updated_at         | timestamp(3) with time zone | Có       | now()                          |
| deleted_at         | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `idempotency_records_request_hash_check`: `CHECK ((octet_length(request_hash) = 32))`
- `idempotency_records_status_check`: `CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'SUCCEEDED'::character varying, 'FAILED'::character varying])::text[])))`
- `idempotency_records_actor_user_id_fkey`: `FOREIGN KEY (actor_user_id) REFERENCES app.users(id)`
- `idempotency_records_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `idempotency_records_created_at_not_null`: `NOT NULL created_at`
- `idempotency_records_id_not_null`: `NOT NULL id`
- `idempotency_records_idempotency_key_not_null`: `NOT NULL idempotency_key`
- `idempotency_records_operation_not_null`: `NOT NULL operation`
- `idempotency_records_request_hash_not_null`: `NOT NULL request_hash`
- `idempotency_records_scope_key_not_null`: `NOT NULL scope_key`
- `idempotency_records_status_not_null`: `NOT NULL status`
- `idempotency_records_updated_at_not_null`: `NOT NULL updated_at`
- `idempotency_records_pkey`: `PRIMARY KEY (id)`
- `idempotency_records_scope_key_operation_idempotency_key_key`: `UNIQUE (scope_key, operation, idempotency_key)`

Indexes:

- `idempotency_records_pkey`: `CREATE UNIQUE INDEX idempotency_records_pkey ON ops.idempotency_records USING btree (id)`
- `idempotency_records_scope_key_operation_idempotency_key_key`: `CREATE UNIQUE INDEX idempotency_records_scope_key_operation_idempotency_key_key ON ops.idempotency_records USING btree (scope_key, operation, idempotency_key)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.idempotency_records FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON ops.idempotency_records FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## ops.job_attempts — JobAttempt

| Cột                         | PostgreSQL type             | NOT NULL | Default                        |
| --------------------------- | --------------------------- | -------- | ------------------------------ |
| id                          | uuid                        | Có       | uuidv7()                       |
| run_id                      | uuid                        | Có       | —                              |
| attempt_number              | integer                     | Có       | —                              |
| worker_id                   | character varying(100)      | Có       | —                              |
| fencing_token               | bigint                      | Có       | —                              |
| status                      | character varying(12)       | Có       | 'RUNNING'::character varying   |
| started_at                  | timestamp(3) with time zone | Có       | now()                          |
| finished_at                 | timestamp(3) with time zone | Không    | —                              |
| error_code                  | character varying(80)       | Không    | —                              |
| error_summary               | character varying(500)      | Không    | —                              |
| retry_requested_by_admin_id | uuid                        | Không    | —                              |
| created_at                  | timestamp(3) with time zone | Có       | now()                          |
| updated_at                  | timestamp(3) with time zone | Có       | now()                          |
| deleted_at                  | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `job_attempts_attempt_number_check`: `CHECK ((attempt_number > 0))`
- `job_attempts_check`: `CHECK ((((status)::text = 'RUNNING'::text) = (finished_at IS NULL)))`
- `job_attempts_fencing_token_check`: `CHECK ((fencing_token > 0))`
- `job_attempts_status_check`: `CHECK (((status)::text = ANY ((ARRAY['RUNNING'::character varying, 'SUCCEEDED'::character varying, 'FAILED'::character varying, 'TIMED_OUT'::character varying])::text[])))`
- `job_attempts_retry_requested_by_admin_id_fkey`: `FOREIGN KEY (retry_requested_by_admin_id) REFERENCES ops.admin_users(id)`
- `job_attempts_run_id_fkey`: `FOREIGN KEY (run_id) REFERENCES ops.job_runs(id)`
- `job_attempts_attempt_number_not_null`: `NOT NULL attempt_number`
- `job_attempts_created_at_not_null`: `NOT NULL created_at`
- `job_attempts_fencing_token_not_null`: `NOT NULL fencing_token`
- `job_attempts_id_not_null`: `NOT NULL id`
- `job_attempts_run_id_not_null`: `NOT NULL run_id`
- `job_attempts_started_at_not_null`: `NOT NULL started_at`
- `job_attempts_status_not_null`: `NOT NULL status`
- `job_attempts_updated_at_not_null`: `NOT NULL updated_at`
- `job_attempts_worker_id_not_null`: `NOT NULL worker_id`
- `job_attempts_pkey`: `PRIMARY KEY (id)`
- `job_attempts_run_id_attempt_number_key`: `UNIQUE (run_id, attempt_number)`
- `job_attempts_run_id_fencing_token_key`: `UNIQUE (run_id, fencing_token)`

Indexes:

- `job_attempts_pkey`: `CREATE UNIQUE INDEX job_attempts_pkey ON ops.job_attempts USING btree (id)`
- `job_attempts_run_id_attempt_number_key`: `CREATE UNIQUE INDEX job_attempts_run_id_attempt_number_key ON ops.job_attempts USING btree (run_id, attempt_number)`
- `job_attempts_run_id_fencing_token_key`: `CREATE UNIQUE INDEX job_attempts_run_id_fencing_token_key ON ops.job_attempts USING btree (run_id, fencing_token)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.job_attempts FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## ops.job_runs — JobRun

| Cột                | PostgreSQL type             | NOT NULL | Default                        |
| ------------------ | --------------------------- | -------- | ------------------------------ |
| id                 | uuid                        | Có       | uuidv7()                       |
| schedule_id        | uuid                        | Không    | —                              |
| job_name           | character varying(100)      | Có       | —                              |
| scope_key          | character varying(255)      | Có       | —                              |
| family_id          | uuid                        | Không    | —                              |
| scheduled_for      | timestamp(3) with time zone | Có       | —                              |
| idempotency_key    | character varying(255)      | Có       | —                              |
| status             | character varying(16)       | Có       | 'PENDING'::character varying   |
| max_attempts       | integer                     | Có       | 3                              |
| attempts           | integer                     | Có       | 0                              |
| next_attempt_at    | timestamp(3) with time zone | Không    | —                              |
| started_at         | timestamp(3) with time zone | Không    | —                              |
| finished_at        | timestamp(3) with time zone | Không    | —                              |
| lease_owner        | character varying(100)      | Không    | —                              |
| lease_expires_at   | timestamp(3) with time zone | Không    | —                              |
| heartbeat_at       | timestamp(3) with time zone | Không    | —                              |
| fencing_token      | bigint                      | Có       | 0                              |
| last_error_code    | character varying(80)       | Không    | —                              |
| last_error_summary | character varying(500)      | Không    | —                              |
| checkpoint         | jsonb                       | Có       | '{}'::jsonb                    |
| input_reference    | jsonb                       | Có       | '{}'::jsonb                    |
| created_at         | timestamp(3) with time zone | Có       | now()                          |
| updated_at         | timestamp(3) with time zone | Có       | now()                          |
| deleted_at         | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `job_runs_check`: `CHECK (((max_attempts > 0) AND (attempts >= 0) AND (fencing_token >= 0)))`
- `job_runs_check1`: `CHECK ((((status)::text <> 'RUNNING'::text) OR ((lease_owner IS NOT NULL) AND (lease_expires_at IS NOT NULL))))`
- `job_runs_check2`: `CHECK ((((status)::text <> ALL ((ARRAY['SUCCEEDED'::character varying, 'FAILED'::character varying, 'SKIPPED'::character varying])::text[])) OR (finished_at IS NOT NULL)))`
- `job_runs_status_check`: `CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'RUNNING'::character varying, 'RETRY_WAIT'::character varying, 'SUCCEEDED'::character varying, 'FAILED'::character varying, 'SKIPPED'::character varying])::text[])))`
- `job_runs_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `job_runs_schedule_id_fkey`: `FOREIGN KEY (schedule_id) REFERENCES ops.job_schedules(id)`
- `job_runs_attempts_not_null`: `NOT NULL attempts`
- `job_runs_checkpoint_not_null`: `NOT NULL checkpoint`
- `job_runs_created_at_not_null`: `NOT NULL created_at`
- `job_runs_fencing_token_not_null`: `NOT NULL fencing_token`
- `job_runs_id_not_null`: `NOT NULL id`
- `job_runs_idempotency_key_not_null`: `NOT NULL idempotency_key`
- `job_runs_input_reference_not_null`: `NOT NULL input_reference`
- `job_runs_job_name_not_null`: `NOT NULL job_name`
- `job_runs_max_attempts_not_null`: `NOT NULL max_attempts`
- `job_runs_scheduled_for_not_null`: `NOT NULL scheduled_for`
- `job_runs_scope_key_not_null`: `NOT NULL scope_key`
- `job_runs_status_not_null`: `NOT NULL status`
- `job_runs_updated_at_not_null`: `NOT NULL updated_at`
- `job_runs_pkey`: `PRIMARY KEY (id)`
- `job_runs_idempotency_key_key`: `UNIQUE (idempotency_key)`
- `job_runs_job_name_scope_key_scheduled_for_key`: `UNIQUE (job_name, scope_key, scheduled_for)`

Indexes:

- `ix_job_runs_claim`: `CREATE INDEX ix_job_runs_claim ON ops.job_runs USING btree (next_attempt_at, scheduled_for) WHERE (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'RETRY_WAIT'::character varying])::text[])) AND (deleted_at IS NULL))`
- `ix_job_runs_stale`: `CREATE INDEX ix_job_runs_stale ON ops.job_runs USING btree (lease_expires_at) WHERE (((status)::text = 'RUNNING'::text) AND (deleted_at IS NULL))`
- `job_runs_idempotency_key_key`: `CREATE UNIQUE INDEX job_runs_idempotency_key_key ON ops.job_runs USING btree (idempotency_key)`
- `job_runs_job_name_scope_key_scheduled_for_key`: `CREATE UNIQUE INDEX job_runs_job_name_scope_key_scheduled_for_key ON ops.job_runs USING btree (job_name, scope_key, scheduled_for)`
- `job_runs_pkey`: `CREATE UNIQUE INDEX job_runs_pkey ON ops.job_runs USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.job_runs FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON ops.job_runs FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_immutable_job_key`: `CREATE TRIGGER trg_immutable_job_key BEFORE UPDATE ON ops.job_runs FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('job_name', 'scope_key', 'scheduled_for', 'idempotency_key')`
- `trg_pending_work`: `CREATE TRIGGER trg_pending_work BEFORE DELETE OR UPDATE ON ops.job_runs FOR EACH ROW EXECUTE FUNCTION ops.protect_pending_work()`

## ops.job_schedules — JobSchedule

| Cột                  | PostgreSQL type             | NOT NULL | Default                        |
| -------------------- | --------------------------- | -------- | ------------------------------ |
| id                   | uuid                        | Có       | uuidv7()                       |
| job_name             | character varying(100)      | Có       | —                              |
| scope_key            | character varying(255)      | Có       | 'GLOBAL'::character varying    |
| family_id            | uuid                        | Không    | —                              |
| cron_expression      | character varying(100)      | Có       | —                              |
| timezone             | character varying(64)       | Có       | 'UTC'::character varying       |
| misfire_policy       | character varying(12)       | Có       | —                              |
| enabled              | boolean                     | Có       | true                           |
| next_run_at          | timestamp(3) with time zone | Không    | —                              |
| last_materialized_at | timestamp(3) with time zone | Không    | —                              |
| definition_version   | integer                     | Có       | 1                              |
| created_at           | timestamp(3) with time zone | Có       | now()                          |
| updated_at           | timestamp(3) with time zone | Có       | now()                          |
| deleted_at           | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `job_schedules_misfire_policy_check`: `CHECK (((misfire_policy)::text = ANY ((ARRAY['CATCH_UP'::character varying, 'COALESCE'::character varying, 'SKIP'::character varying])::text[])))`
- `job_schedules_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `job_schedules_created_at_not_null`: `NOT NULL created_at`
- `job_schedules_cron_expression_not_null`: `NOT NULL cron_expression`
- `job_schedules_definition_version_not_null`: `NOT NULL definition_version`
- `job_schedules_enabled_not_null`: `NOT NULL enabled`
- `job_schedules_id_not_null`: `NOT NULL id`
- `job_schedules_job_name_not_null`: `NOT NULL job_name`
- `job_schedules_misfire_policy_not_null`: `NOT NULL misfire_policy`
- `job_schedules_scope_key_not_null`: `NOT NULL scope_key`
- `job_schedules_timezone_not_null`: `NOT NULL timezone`
- `job_schedules_updated_at_not_null`: `NOT NULL updated_at`
- `job_schedules_pkey`: `PRIMARY KEY (id)`
- `job_schedules_job_name_scope_key_key`: `UNIQUE (job_name, scope_key)`

Indexes:

- `job_schedules_job_name_scope_key_key`: `CREATE UNIQUE INDEX job_schedules_job_name_scope_key_key ON ops.job_schedules USING btree (job_name, scope_key)`
- `job_schedules_pkey`: `CREATE UNIQUE INDEX job_schedules_pkey ON ops.job_schedules USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.job_schedules FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON ops.job_schedules FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## ops.moderation_actions — ModerationAction

| Cột         | PostgreSQL type             | NOT NULL | Default                        |
| ----------- | --------------------------- | -------- | ------------------------------ |
| id          | uuid                        | Có       | uuidv7()                       |
| case_id     | uuid                        | Có       | —                              |
| admin_id    | uuid                        | Có       | —                              |
| action      | character varying(30)       | Có       | —                              |
| reason_note | character varying(1000)     | Có       | —                              |
| created_at  | timestamp(3) with time zone | Có       | now()                          |
| updated_at  | timestamp(3) with time zone | Có       | now()                          |
| deleted_at  | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `moderation_actions_admin_id_fkey`: `FOREIGN KEY (admin_id) REFERENCES ops.admin_users(id)`
- `moderation_actions_case_id_fkey`: `FOREIGN KEY (case_id) REFERENCES ops.moderation_cases(id)`
- `moderation_actions_action_not_null`: `NOT NULL action`
- `moderation_actions_admin_id_not_null`: `NOT NULL admin_id`
- `moderation_actions_case_id_not_null`: `NOT NULL case_id`
- `moderation_actions_created_at_not_null`: `NOT NULL created_at`
- `moderation_actions_id_not_null`: `NOT NULL id`
- `moderation_actions_reason_note_not_null`: `NOT NULL reason_note`
- `moderation_actions_updated_at_not_null`: `NOT NULL updated_at`
- `moderation_actions_pkey`: `PRIMARY KEY (id)`

Indexes:

- `moderation_actions_pkey`: `CREATE UNIQUE INDEX moderation_actions_pkey ON ops.moderation_actions USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.moderation_actions FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## ops.moderation_case_reports — ModerationCaseReport

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| case_id    | uuid                        | Có       | —                              |
| report_id  | uuid                        | Có       | —                              |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `moderation_case_reports_case_id_fkey`: `FOREIGN KEY (case_id) REFERENCES ops.moderation_cases(id)`
- `moderation_case_reports_report_id_fkey`: `FOREIGN KEY (report_id) REFERENCES app.reports(id)`
- `moderation_case_reports_case_id_not_null`: `NOT NULL case_id`
- `moderation_case_reports_created_at_not_null`: `NOT NULL created_at`
- `moderation_case_reports_report_id_not_null`: `NOT NULL report_id`
- `moderation_case_reports_updated_at_not_null`: `NOT NULL updated_at`
- `moderation_case_reports_pkey`: `PRIMARY KEY (case_id, report_id)`

Indexes:

- `moderation_case_reports_pkey`: `CREATE UNIQUE INDEX moderation_case_reports_pkey ON ops.moderation_case_reports USING btree (case_id, report_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.moderation_case_reports FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## ops.moderation_cases — ModerationCase

| Cột               | PostgreSQL type             | NOT NULL | Default                        |
| ----------------- | --------------------------- | -------- | ------------------------------ |
| id                | uuid                        | Có       | uuidv7()                       |
| target_type       | app.report_target           | Có       | —                              |
| target_id         | uuid                        | Có       | —                              |
| priority          | smallint                    | Có       | —                              |
| status            | character varying(15)       | Có       | 'OPEN'::character varying      |
| assignee_admin_id | uuid                        | Không    | —                              |
| sla_due_at        | timestamp(3) with time zone | Có       | —                              |
| created_at        | timestamp(3) with time zone | Có       | now()                          |
| resolved_at       | timestamp(3) with time zone | Không    | —                              |
| updated_at        | timestamp(3) with time zone | Có       | now()                          |
| deleted_at        | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `moderation_cases_assignee_admin_id_fkey`: `FOREIGN KEY (assignee_admin_id) REFERENCES ops.admin_users(id)`
- `moderation_cases_created_at_not_null`: `NOT NULL created_at`
- `moderation_cases_id_not_null`: `NOT NULL id`
- `moderation_cases_priority_not_null`: `NOT NULL priority`
- `moderation_cases_sla_due_at_not_null`: `NOT NULL sla_due_at`
- `moderation_cases_status_not_null`: `NOT NULL status`
- `moderation_cases_target_id_not_null`: `NOT NULL target_id`
- `moderation_cases_target_type_not_null`: `NOT NULL target_type`
- `moderation_cases_updated_at_not_null`: `NOT NULL updated_at`
- `moderation_cases_pkey`: `PRIMARY KEY (id)`

Indexes:

- `moderation_cases_pkey`: `CREATE UNIQUE INDEX moderation_cases_pkey ON ops.moderation_cases USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.moderation_cases FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## ops.notification_templates — NotificationTemplate

| Cột          | PostgreSQL type             | NOT NULL | Default                        |
| ------------ | --------------------------- | -------- | ------------------------------ |
| code         | character varying(40)       | Có       | —                              |
| locale       | character varying(10)       | Có       | —                              |
| title        | character varying(120)      | Có       | —                              |
| body         | character varying(300)      | Có       | —                              |
| sensitive    | boolean                     | Có       | false                          |
| hidden_title | character varying(120)      | Không    | —                              |
| hidden_body  | character varying(300)      | Không    | —                              |
| category     | character varying(20)       | Có       | —                              |
| priority     | character varying(10)       | Có       | 'NORMAL'::character varying    |
| enabled      | boolean                     | Có       | true                           |
| created_at   | timestamp(3) with time zone | Có       | now()                          |
| updated_at   | timestamp(3) with time zone | Có       | now()                          |
| deleted_at   | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `notification_templates_body_not_null`: `NOT NULL body`
- `notification_templates_category_not_null`: `NOT NULL category`
- `notification_templates_code_not_null`: `NOT NULL code`
- `notification_templates_created_at_not_null`: `NOT NULL created_at`
- `notification_templates_enabled_not_null`: `NOT NULL enabled`
- `notification_templates_locale_not_null`: `NOT NULL locale`
- `notification_templates_priority_not_null`: `NOT NULL priority`
- `notification_templates_sensitive_not_null`: `NOT NULL sensitive`
- `notification_templates_title_not_null`: `NOT NULL title`
- `notification_templates_updated_at_not_null`: `NOT NULL updated_at`
- `notification_templates_pkey`: `PRIMARY KEY (code, locale)`

Indexes:

- `notification_templates_pkey`: `CREATE UNIQUE INDEX notification_templates_pkey ON ops.notification_templates USING btree (code, locale)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.notification_templates FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## ops.outbox_events — OutboxEvent

| Cột              | PostgreSQL type             | NOT NULL | Default                        |
| ---------------- | --------------------------- | -------- | ------------------------------ |
| id               | bigint                      | Có       | —                              |
| event_type       | character varying(60)       | Có       | —                              |
| aggregate_id     | uuid                        | Không    | —                              |
| family_id        | uuid                        | Không    | —                              |
| payload          | jsonb                       | Có       | —                              |
| created_at       | timestamp(3) with time zone | Có       | now()                          |
| published_at     | timestamp(3) with time zone | Không    | —                              |
| attempts         | integer                     | Có       | 0                              |
| updated_at       | timestamp(3) with time zone | Có       | now()                          |
| deleted_at       | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| event_id         | uuid                        | Có       | uuidv7()                       |
| available_at     | timestamp(3) with time zone | Có       | now()                          |
| lease_owner      | character varying(100)      | Không    | —                              |
| lease_expires_at | timestamp(3) with time zone | Không    | —                              |
| fencing_token    | bigint                      | Có       | 0                              |
| last_error_code  | character varying(80)       | Không    | —                              |

Constraints:

- `outbox_events_check`: `CHECK (((attempts >= 0) AND (fencing_token >= 0)))`
- `outbox_events_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `outbox_events_attempts_not_null`: `NOT NULL attempts`
- `outbox_events_available_at_not_null`: `NOT NULL available_at`
- `outbox_events_created_at_not_null`: `NOT NULL created_at`
- `outbox_events_event_id_not_null`: `NOT NULL event_id`
- `outbox_events_event_type_not_null`: `NOT NULL event_type`
- `outbox_events_fencing_token_not_null`: `NOT NULL fencing_token`
- `outbox_events_id_not_null`: `NOT NULL id`
- `outbox_events_payload_not_null`: `NOT NULL payload`
- `outbox_events_updated_at_not_null`: `NOT NULL updated_at`
- `outbox_events_pkey`: `PRIMARY KEY (id)`
- `outbox_events_event_id_key`: `UNIQUE (event_id)`

Indexes:

- `ix_outbox_available`: `CREATE INDEX ix_outbox_available ON ops.outbox_events USING btree (available_at, id) WHERE ((published_at IS NULL) AND (deleted_at IS NULL))`
- `ix_outbox_unpublished`: `CREATE INDEX ix_outbox_unpublished ON ops.outbox_events USING btree (id) WHERE ((published_at IS NULL) AND (deleted_at IS NULL))`
- `outbox_events_event_id_key`: `CREATE UNIQUE INDEX outbox_events_event_id_key ON ops.outbox_events USING btree (event_id)`
- `outbox_events_pkey`: `CREATE UNIQUE INDEX outbox_events_pkey ON ops.outbox_events USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.outbox_events FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON ops.outbox_events FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## ops.sync_tombstones — SyncTombstone

| Cột              | PostgreSQL type             | NOT NULL | Default                        |
| ---------------- | --------------------------- | -------- | ------------------------------ |
| id               | bigint                      | Có       | —                              |
| family_id        | uuid                        | Có       | —                              |
| entity_type      | character varying(20)       | Có       | —                              |
| entity_id        | uuid                        | Có       | —                              |
| audience         | character varying(10)       | Có       | 'ALL'::character varying       |
| created_at       | timestamp(3) with time zone | Có       | now()                          |
| updated_at       | timestamp(3) with time zone | Có       | now()                          |
| deleted_at       | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| audience_user_id | uuid                        | Không    | —                              |

Constraints:

- `sync_tombstones_audience_user_id_fkey`: `FOREIGN KEY (audience_user_id) REFERENCES app.users(id)`
- `sync_tombstones_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `sync_tombstones_audience_not_null`: `NOT NULL audience`
- `sync_tombstones_created_at_not_null`: `NOT NULL created_at`
- `sync_tombstones_entity_id_not_null`: `NOT NULL entity_id`
- `sync_tombstones_entity_type_not_null`: `NOT NULL entity_type`
- `sync_tombstones_family_id_not_null`: `NOT NULL family_id`
- `sync_tombstones_id_not_null`: `NOT NULL id`
- `sync_tombstones_updated_at_not_null`: `NOT NULL updated_at`
- `sync_tombstones_pkey`: `PRIMARY KEY (id)`

Indexes:

- `sync_tombstones_family_id_id_idx`: `CREATE INDEX sync_tombstones_family_id_id_idx ON ops.sync_tombstones USING btree (family_id, id)`
- `sync_tombstones_pkey`: `CREATE UNIQUE INDEX sync_tombstones_pkey ON ops.sync_tombstones USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON ops.sync_tombstones FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON ops.sync_tombstones FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## public.notes — Note

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| id         | uuid                        | Có       | —                              |
| title      | character varying(200)      | Có       | —                              |
| content    | text                        | Không    | —                              |
| created_at | timestamp(3) with time zone | Có       | CURRENT_TIMESTAMP              |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `notes_created_at_not_null`: `NOT NULL created_at`
- `notes_id_not_null`: `NOT NULL id`
- `notes_title_not_null`: `NOT NULL title`
- `notes_updated_at_not_null`: `NOT NULL updated_at`
- `notes_pkey`: `PRIMARY KEY (id)`

Indexes:

- `ix_notes_active_created`: `CREATE INDEX ix_notes_active_created ON public.notes USING btree (created_at DESC, id DESC) WHERE (deleted_at IS NULL)`
- `notes_pkey`: `CREATE UNIQUE INDEX notes_pkey ON public.notes USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON public.notes FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`

## us.appreciations — Appreciation

| Cột                 | PostgreSQL type             | NOT NULL | Default                        |
| ------------------- | --------------------------- | -------- | ------------------------------ |
| id                  | uuid                        | Có       | uuidv7()                       |
| couple_space_id     | uuid                        | Có       | —                              |
| from_user_id        | uuid                        | Có       | —                              |
| to_user_id          | uuid                        | Có       | —                              |
| body_enc            | bytea                       | Có       | —                              |
| sticker             | character varying(40)       | Không    | —                              |
| linked_type         | character varying(10)       | Không    | —                              |
| linked_id           | uuid                        | Không    | —                              |
| family_share_status | character varying(10)       | Có       | 'NONE'::character varying      |
| family_memory_id    | uuid                        | Không    | —                              |
| seen_at             | timestamp(3) with time zone | Không    | —                              |
| reaction            | character varying(20)       | Không    | —                              |
| created_at          | timestamp(3) with time zone | Có       | now()                          |
| deleted_by_from_at  | timestamp(3) with time zone | Không    | —                              |
| deleted_by_to_at    | timestamp(3) with time zone | Không    | —                              |
| updated_at          | timestamp(3) with time zone | Có       | now()                          |
| deleted_at          | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| family_id           | uuid                        | Có       | —                              |

Constraints:

- `appreciations_check`: `CHECK ((from_user_id <> to_user_id))`
- `appreciations_couple_space_id_family_id_fkey`: `FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id)`
- `appreciations_couple_space_id_fkey`: `FOREIGN KEY (couple_space_id) REFERENCES app.couple_spaces(id)`
- `appreciations_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `appreciations_family_memory_id_family_id_fkey`: `FOREIGN KEY (family_memory_id, family_id) REFERENCES app.memories(id, family_id)`
- `appreciations_from_user_id_fkey`: `FOREIGN KEY (from_user_id) REFERENCES app.users(id)`
- `appreciations_to_user_id_fkey`: `FOREIGN KEY (to_user_id) REFERENCES app.users(id)`
- `appreciations_body_enc_not_null`: `NOT NULL body_enc`
- `appreciations_couple_space_id_not_null`: `NOT NULL couple_space_id`
- `appreciations_created_at_not_null`: `NOT NULL created_at`
- `appreciations_family_id_not_null`: `NOT NULL family_id`
- `appreciations_family_share_status_not_null`: `NOT NULL family_share_status`
- `appreciations_from_user_id_not_null`: `NOT NULL from_user_id`
- `appreciations_id_not_null`: `NOT NULL id`
- `appreciations_to_user_id_not_null`: `NOT NULL to_user_id`
- `appreciations_updated_at_not_null`: `NOT NULL updated_at`
- `appreciations_pkey`: `PRIMARY KEY (id)`

Indexes:

- `appreciations_couple_space_id_created_at_idx`: `CREATE INDEX appreciations_couple_space_id_created_at_idx ON us.appreciations USING btree (couple_space_id, created_at DESC)`
- `appreciations_pkey`: `CREATE UNIQUE INDEX appreciations_pkey ON us.appreciations USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.appreciations FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_couple`: `CREATE TRIGGER trg_immutable_couple BEFORE UPDATE ON us.appreciations FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('couple_space_id')`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON us.appreciations FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_pair_check`: `CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.appreciations FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('from_user_id', 'to_user_id')`

## us.conflict_confirmations — ConflictConfirmation

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| session_id      | uuid                        | Có       | —                              |
| family_id       | uuid                        | Có       | —                              |
| couple_space_id | uuid                        | Có       | —                              |
| user_id         | uuid                        | Có       | —                              |
| step_version    | integer                     | Có       | —                              |
| confirmed_at    | timestamp(3) with time zone | Có       | now()                          |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `conflict_confirmations_step_version_check`: `CHECK ((step_version > 0))`
- `conflict_confirmations_session_id_family_id_couple_space_i_fkey`: `FOREIGN KEY (session_id, family_id, couple_space_id) REFERENCES us.conflict_sessions(id, family_id, couple_space_id)`
- `conflict_confirmations_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `conflict_confirmations_confirmed_at_not_null`: `NOT NULL confirmed_at`
- `conflict_confirmations_couple_space_id_not_null`: `NOT NULL couple_space_id`
- `conflict_confirmations_created_at_not_null`: `NOT NULL created_at`
- `conflict_confirmations_family_id_not_null`: `NOT NULL family_id`
- `conflict_confirmations_session_id_not_null`: `NOT NULL session_id`
- `conflict_confirmations_step_version_not_null`: `NOT NULL step_version`
- `conflict_confirmations_updated_at_not_null`: `NOT NULL updated_at`
- `conflict_confirmations_user_id_not_null`: `NOT NULL user_id`
- `conflict_confirmations_pkey`: `PRIMARY KEY (session_id, user_id, step_version)`

Indexes:

- `conflict_confirmations_pkey`: `CREATE UNIQUE INDEX conflict_confirmations_pkey ON us.conflict_confirmations USING btree (session_id, user_id, step_version)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.conflict_confirmations FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_couple`: `CREATE TRIGGER trg_immutable_couple BEFORE UPDATE ON us.conflict_confirmations FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('couple_space_id')`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON us.conflict_confirmations FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_pair_check`: `CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.conflict_confirmations FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('user_id')`

## us.conflict_entries — ConflictEntry

| Cột                  | PostgreSQL type             | NOT NULL | Default                        |
| -------------------- | --------------------------- | -------- | ------------------------------ |
| id                   | uuid                        | Có       | uuidv7()                       |
| session_id           | uuid                        | Có       | —                              |
| user_id              | uuid                        | Có       | —                              |
| feelings             | text[]                      | Có       | '{}'::text[]                   |
| needs                | text[]                      | Có       | '{}'::text[]                   |
| draft_enc            | bytea                       | Không    | —                              |
| shared_points_enc    | bytea                       | Không    | —                              |
| share_status         | character varying(10)       | Có       | 'PRIVATE'::character varying   |
| understood_at        | timestamp(3) with time zone | Không    | —                              |
| clarify_requested_at | timestamp(3) with time zone | Không    | —                              |
| created_at           | timestamp(3) with time zone | Có       | now()                          |
| updated_at           | timestamp(3) with time zone | Có       | now()                          |
| deleted_at           | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| family_id            | uuid                        | Có       | —                              |
| couple_space_id      | uuid                        | Có       | —                              |

Constraints:

- `conflict_entries_couple_space_id_family_id_fkey`: `FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id)`
- `conflict_entries_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `conflict_entries_session_id_family_id_couple_space_id_fkey`: `FOREIGN KEY (session_id, family_id, couple_space_id) REFERENCES us.conflict_sessions(id, family_id, couple_space_id)`
- `conflict_entries_session_id_fkey`: `FOREIGN KEY (session_id) REFERENCES us.conflict_sessions(id) ON DELETE CASCADE`
- `conflict_entries_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `conflict_entries_couple_space_id_not_null`: `NOT NULL couple_space_id`
- `conflict_entries_created_at_not_null`: `NOT NULL created_at`
- `conflict_entries_family_id_not_null`: `NOT NULL family_id`
- `conflict_entries_feelings_not_null`: `NOT NULL feelings`
- `conflict_entries_id_not_null`: `NOT NULL id`
- `conflict_entries_needs_not_null`: `NOT NULL needs`
- `conflict_entries_session_id_not_null`: `NOT NULL session_id`
- `conflict_entries_share_status_not_null`: `NOT NULL share_status`
- `conflict_entries_updated_at_not_null`: `NOT NULL updated_at`
- `conflict_entries_user_id_not_null`: `NOT NULL user_id`
- `conflict_entries_pkey`: `PRIMARY KEY (id)`
- `conflict_entries_id_family_id_key`: `UNIQUE (id, family_id)`
- `conflict_entries_session_id_user_id_key`: `UNIQUE (session_id, user_id)`

Indexes:

- `conflict_entries_id_family_id_key`: `CREATE UNIQUE INDEX conflict_entries_id_family_id_key ON us.conflict_entries USING btree (id, family_id)`
- `conflict_entries_pkey`: `CREATE UNIQUE INDEX conflict_entries_pkey ON us.conflict_entries USING btree (id)`
- `conflict_entries_session_id_user_id_key`: `CREATE UNIQUE INDEX conflict_entries_session_id_user_id_key ON us.conflict_entries USING btree (session_id, user_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.conflict_entries FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_couple`: `CREATE TRIGGER trg_immutable_couple BEFORE UPDATE ON us.conflict_entries FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('couple_space_id')`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON us.conflict_entries FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_pair_check`: `CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.conflict_entries FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('user_id')`

## us.conflict_sessions — ConflictSession

| Cột              | PostgreSQL type             | NOT NULL | Default                             |
| ---------------- | --------------------------- | -------- | ----------------------------------- |
| id               | uuid                        | Có       | uuidv7()                            |
| couple_space_id  | uuid                        | Có       | —                                   |
| opened_by        | uuid                        | Có       | —                                   |
| status           | us.conflict_status          | Có       | 'PRIVATE_DRAFT'::us.conflict_status |
| topic            | character varying(20)       | Không    | —                                   |
| next_step        | jsonb                       | Không    | —                                   |
| retention_days   | smallint                    | Có       | 30                                  |
| purge_at         | timestamp(3) with time zone | Không    | —                                   |
| invited_at       | timestamp(3) with time zone | Không    | —                                   |
| joined_at        | timestamp(3) with time zone | Không    | —                                   |
| closed_at        | timestamp(3) with time zone | Không    | —                                   |
| last_activity_at | timestamp(3) with time zone | Có       | now()                               |
| created_at       | timestamp(3) with time zone | Có       | now()                               |
| updated_at       | timestamp(3) with time zone | Có       | now()                               |
| deleted_at       | timestamp(3) with time zone | Không    | NULL::timestamp with time zone      |
| family_id        | uuid                        | Có       | —                                   |

Constraints:

- `conflict_sessions_retention_days_check`: `CHECK ((retention_days = ANY (ARRAY[0, 7, 30, 90])))`
- `conflict_sessions_couple_space_id_family_id_fkey`: `FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id)`
- `conflict_sessions_couple_space_id_fkey`: `FOREIGN KEY (couple_space_id) REFERENCES app.couple_spaces(id)`
- `conflict_sessions_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `conflict_sessions_opened_by_fkey`: `FOREIGN KEY (opened_by) REFERENCES app.users(id)`
- `conflict_sessions_couple_space_id_not_null`: `NOT NULL couple_space_id`
- `conflict_sessions_created_at_not_null`: `NOT NULL created_at`
- `conflict_sessions_family_id_not_null`: `NOT NULL family_id`
- `conflict_sessions_id_not_null`: `NOT NULL id`
- `conflict_sessions_last_activity_at_not_null`: `NOT NULL last_activity_at`
- `conflict_sessions_opened_by_not_null`: `NOT NULL opened_by`
- `conflict_sessions_retention_days_not_null`: `NOT NULL retention_days`
- `conflict_sessions_status_not_null`: `NOT NULL status`
- `conflict_sessions_updated_at_not_null`: `NOT NULL updated_at`
- `conflict_sessions_pkey`: `PRIMARY KEY (id)`
- `conflict_sessions_id_family_id_couple_space_id_key`: `UNIQUE (id, family_id, couple_space_id)`
- `conflict_sessions_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `conflict_sessions_id_family_id_couple_space_id_key`: `CREATE UNIQUE INDEX conflict_sessions_id_family_id_couple_space_id_key ON us.conflict_sessions USING btree (id, family_id, couple_space_id)`
- `conflict_sessions_id_family_id_key`: `CREATE UNIQUE INDEX conflict_sessions_id_family_id_key ON us.conflict_sessions USING btree (id, family_id)`
- `conflict_sessions_pkey`: `CREATE UNIQUE INDEX conflict_sessions_pkey ON us.conflict_sessions USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.conflict_sessions FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_couple`: `CREATE TRIGGER trg_immutable_couple BEFORE UPDATE ON us.conflict_sessions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('couple_space_id')`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON us.conflict_sessions FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_pair_check`: `CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.conflict_sessions FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('opened_by')`

## us.connection_answers — ConnectionAnswer

| Cột               | PostgreSQL type             | NOT NULL | Default                        |
| ----------------- | --------------------------- | -------- | ------------------------------ |
| couple_space_id   | uuid                        | Có       | —                              |
| prompt_code       | character varying(30)       | Có       | —                              |
| local_date        | date                        | Có       | —                              |
| user_id           | uuid                        | Có       | —                              |
| answer_enc        | bytea                       | Có       | —                              |
| created_at        | timestamp(3) with time zone | Có       | now()                          |
| updated_at        | timestamp(3) with time zone | Có       | now()                          |
| deleted_at        | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| family_id         | uuid                        | Có       | —                              |
| shared_answer_enc | bytea                       | Không    | —                              |
| shared_at         | timestamp(3) with time zone | Không    | —                              |

Constraints:

- `connection_answers_couple_space_id_family_id_fkey`: `FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id)`
- `connection_answers_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `connection_answers_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `connection_answers_answer_enc_not_null`: `NOT NULL answer_enc`
- `connection_answers_couple_space_id_not_null`: `NOT NULL couple_space_id`
- `connection_answers_created_at_not_null`: `NOT NULL created_at`
- `connection_answers_family_id_not_null`: `NOT NULL family_id`
- `connection_answers_local_date_not_null`: `NOT NULL local_date`
- `connection_answers_prompt_code_not_null`: `NOT NULL prompt_code`
- `connection_answers_updated_at_not_null`: `NOT NULL updated_at`
- `connection_answers_user_id_not_null`: `NOT NULL user_id`
- `connection_answers_pkey`: `PRIMARY KEY (couple_space_id, local_date, user_id)`

Indexes:

- `connection_answers_pkey`: `CREATE UNIQUE INDEX connection_answers_pkey ON us.connection_answers USING btree (couple_space_id, local_date, user_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.connection_answers FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_couple`: `CREATE TRIGGER trg_immutable_couple BEFORE UPDATE ON us.connection_answers FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('couple_space_id')`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON us.connection_answers FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_pair_check`: `CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.connection_answers FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('user_id')`

## us.data_keys — DataKey

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| id              | uuid                        | Có       | uuidv7()                       |
| owner_type      | character varying(10)       | Có       | —                              |
| user_id         | uuid                        | Không    | —                              |
| couple_space_id | uuid                        | Không    | —                              |
| key_version     | integer                     | Có       | 1                              |
| wrapped_dek     | bytea                       | Không    | —                              |
| kek_version     | integer                     | Có       | —                              |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| destroyed_at    | timestamp(3) with time zone | Không    | —                              |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `data_keys_check`: `CHECK (((((owner_type)::text = 'USER'::text) AND (user_id IS NOT NULL) AND (couple_space_id IS NULL)) OR (((owner_type)::text = 'COUPLE'::text) AND (couple_space_id IS NOT NULL) AND (user_id IS NULL))))`
- `data_keys_check1`: `CHECK (((destroyed_at IS NULL) = (wrapped_dek IS NOT NULL)))`
- `data_keys_key_version_check`: `CHECK ((key_version > 0))`
- `data_keys_couple_space_id_fkey`: `FOREIGN KEY (couple_space_id) REFERENCES app.couple_spaces(id)`
- `data_keys_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `data_keys_created_at_not_null`: `NOT NULL created_at`
- `data_keys_id_not_null`: `NOT NULL id`
- `data_keys_kek_version_not_null`: `NOT NULL kek_version`
- `data_keys_key_version_not_null`: `NOT NULL key_version`
- `data_keys_owner_type_not_null`: `NOT NULL owner_type`
- `data_keys_updated_at_not_null`: `NOT NULL updated_at`
- `data_keys_pkey`: `PRIMARY KEY (id)`
- `data_keys_id_couple_space_id_key`: `UNIQUE (id, couple_space_id)`
- `data_keys_owner_type_user_id_couple_space_id_key_version_key`: `UNIQUE NULLS NOT DISTINCT (owner_type, user_id, couple_space_id, key_version)`

Indexes:

- `data_keys_id_couple_space_id_key`: `CREATE UNIQUE INDEX data_keys_id_couple_space_id_key ON us.data_keys USING btree (id, couple_space_id)`
- `data_keys_owner_type_user_id_couple_space_id_key_version_key`: `CREATE UNIQUE INDEX data_keys_owner_type_user_id_couple_space_id_key_version_key ON us.data_keys USING btree (owner_type, user_id, couple_space_id, key_version) NULLS NOT DISTINCT`
- `data_keys_pkey`: `CREATE UNIQUE INDEX data_keys_pkey ON us.data_keys USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.data_keys FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_couple`: `CREATE TRIGGER trg_immutable_couple BEFORE UPDATE ON us.data_keys FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('couple_space_id')`
- `trg_immutable_key_owner`: `CREATE TRIGGER trg_immutable_key_owner BEFORE UPDATE ON us.data_keys FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('owner_type', 'user_id', 'couple_space_id', 'key_version')`

## us.journal_assets — JournalAsset

| Cột           | PostgreSQL type             | NOT NULL | Default                        |
| ------------- | --------------------------- | -------- | ------------------------------ |
| entry_id      | uuid                        | Có       | —                              |
| asset_id      | uuid                        | Có       | —                              |
| family_id     | uuid                        | Có       | —                              |
| owner_user_id | uuid                        | Có       | —                              |
| sort_order    | smallint                    | Có       | 0                              |
| created_at    | timestamp(3) with time zone | Có       | now()                          |
| updated_at    | timestamp(3) with time zone | Có       | now()                          |
| deleted_at    | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `journal_assets_asset_id_family_id_owner_user_id_fkey`: `FOREIGN KEY (asset_id, family_id, owner_user_id) REFERENCES app.assets(id, family_id, uploader_user_id)`
- `journal_assets_entry_id_family_id_owner_user_id_fkey`: `FOREIGN KEY (entry_id, family_id, owner_user_id) REFERENCES us.journal_entries(id, family_id, user_id)`
- `journal_assets_owner_user_id_fkey`: `FOREIGN KEY (owner_user_id) REFERENCES app.users(id)`
- `journal_assets_asset_id_not_null`: `NOT NULL asset_id`
- `journal_assets_created_at_not_null`: `NOT NULL created_at`
- `journal_assets_entry_id_not_null`: `NOT NULL entry_id`
- `journal_assets_family_id_not_null`: `NOT NULL family_id`
- `journal_assets_owner_user_id_not_null`: `NOT NULL owner_user_id`
- `journal_assets_sort_order_not_null`: `NOT NULL sort_order`
- `journal_assets_updated_at_not_null`: `NOT NULL updated_at`
- `journal_assets_pkey`: `PRIMARY KEY (entry_id, asset_id)`

Indexes:

- `journal_assets_pkey`: `CREATE UNIQUE INDEX journal_assets_pkey ON us.journal_assets USING btree (entry_id, asset_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.journal_assets FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON us.journal_assets FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_immutable_journal_asset_owner`: `CREATE TRIGGER trg_immutable_journal_asset_owner BEFORE UPDATE ON us.journal_assets FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('owner_user_id')`
- `trg_journal_asset_owner`: `CREATE TRIGGER trg_journal_asset_owner BEFORE INSERT OR UPDATE ON us.journal_assets FOR EACH ROW EXECUTE FUNCTION us.check_journal_asset_owner()`

## us.journal_entries — JournalEntry

| Cột        | PostgreSQL type             | NOT NULL | Default  |
| ---------- | --------------------------- | -------- | -------- |
| id         | uuid                        | Có       | uuidv7() |
| user_id    | uuid                        | Có       | —        |
| family_id  | uuid                        | Có       | —        |
| title_enc  | bytea                       | Không    | —        |
| body_enc   | bytea                       | Có       | —        |
| mood       | us.mood                     | Không    | —        |
| created_at | timestamp(3) with time zone | Có       | now()    |
| updated_at | timestamp(3) with time zone | Có       | now()    |
| deleted_at | timestamp(3) with time zone | Không    | —        |

Constraints:

- `journal_entries_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `journal_entries_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `journal_entries_body_enc_not_null`: `NOT NULL body_enc`
- `journal_entries_created_at_not_null`: `NOT NULL created_at`
- `journal_entries_family_id_not_null`: `NOT NULL family_id`
- `journal_entries_id_not_null`: `NOT NULL id`
- `journal_entries_updated_at_not_null`: `NOT NULL updated_at`
- `journal_entries_user_id_not_null`: `NOT NULL user_id`
- `journal_entries_pkey`: `PRIMARY KEY (id)`
- `journal_entries_id_family_id_key`: `UNIQUE (id, family_id)`
- `journal_entries_id_family_id_user_id_key`: `UNIQUE (id, family_id, user_id)`

Indexes:

- `ix_private_journal_owner`: `CREATE INDEX ix_private_journal_owner ON us.journal_entries USING btree (user_id, created_at DESC, id DESC) WHERE (deleted_at IS NULL)`
- `journal_entries_id_family_id_key`: `CREATE UNIQUE INDEX journal_entries_id_family_id_key ON us.journal_entries USING btree (id, family_id)`
- `journal_entries_id_family_id_user_id_key`: `CREATE UNIQUE INDEX journal_entries_id_family_id_user_id_key ON us.journal_entries USING btree (id, family_id, user_id)`
- `journal_entries_pkey`: `CREATE UNIQUE INDEX journal_entries_pkey ON us.journal_entries USING btree (id)`
- `journal_entries_user_id_created_at_idx`: `CREATE INDEX journal_entries_user_id_created_at_idx ON us.journal_entries USING btree (user_id, created_at DESC)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.journal_entries FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON us.journal_entries FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_immutable_journal_owner`: `CREATE TRIGGER trg_immutable_journal_owner BEFORE UPDATE ON us.journal_entries FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('user_id')`

## us.journal_shares — JournalShare

| Cột                  | PostgreSQL type             | NOT NULL | Default                        |
| -------------------- | --------------------------- | -------- | ------------------------------ |
| id                   | uuid                        | Có       | uuidv7()                       |
| entry_id             | uuid                        | Có       | —                              |
| family_id            | uuid                        | Có       | —                              |
| couple_space_id      | uuid                        | Có       | —                              |
| owner_user_id        | uuid                        | Có       | —                              |
| recipient_user_id    | uuid                        | Có       | —                              |
| snippet_enc          | bytea                       | Có       | —                              |
| explicitly_shared_at | timestamp(3) with time zone | Có       | now()                          |
| revoked_at           | timestamp(3) with time zone | Không    | —                              |
| created_at           | timestamp(3) with time zone | Có       | now()                          |
| updated_at           | timestamp(3) with time zone | Có       | now()                          |
| deleted_at           | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `journal_shares_check`: `CHECK ((owner_user_id <> recipient_user_id))`
- `journal_shares_couple_space_id_family_id_fkey`: `FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id)`
- `journal_shares_entry_id_family_id_owner_user_id_fkey`: `FOREIGN KEY (entry_id, family_id, owner_user_id) REFERENCES us.journal_entries(id, family_id, user_id)`
- `journal_shares_owner_user_id_fkey`: `FOREIGN KEY (owner_user_id) REFERENCES app.users(id)`
- `journal_shares_recipient_user_id_fkey`: `FOREIGN KEY (recipient_user_id) REFERENCES app.users(id)`
- `journal_shares_couple_space_id_not_null`: `NOT NULL couple_space_id`
- `journal_shares_created_at_not_null`: `NOT NULL created_at`
- `journal_shares_entry_id_not_null`: `NOT NULL entry_id`
- `journal_shares_explicitly_shared_at_not_null`: `NOT NULL explicitly_shared_at`
- `journal_shares_family_id_not_null`: `NOT NULL family_id`
- `journal_shares_id_not_null`: `NOT NULL id`
- `journal_shares_owner_user_id_not_null`: `NOT NULL owner_user_id`
- `journal_shares_recipient_user_id_not_null`: `NOT NULL recipient_user_id`
- `journal_shares_snippet_enc_not_null`: `NOT NULL snippet_enc`
- `journal_shares_updated_at_not_null`: `NOT NULL updated_at`
- `journal_shares_pkey`: `PRIMARY KEY (id)`

Indexes:

- `journal_shares_pkey`: `CREATE UNIQUE INDEX journal_shares_pkey ON us.journal_shares USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.journal_shares FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_couple`: `CREATE TRIGGER trg_immutable_couple BEFORE UPDATE ON us.journal_shares FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('couple_space_id')`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON us.journal_shares FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_pair_check`: `CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.journal_shares FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('owner_user_id', 'recipient_user_id')`

## us.mood_checkins — MoodCheckin

| Cột                | PostgreSQL type             | NOT NULL | Default         |
| ------------------ | --------------------------- | -------- | --------------- |
| id                 | uuid                        | Có       | uuidv7()        |
| couple_space_id    | uuid                        | Có       | —               |
| user_id            | uuid                        | Có       | —               |
| mood               | us.mood                     | Có       | —               |
| energy             | smallint                    | Không    | —               |
| needs              | us.need[]                   | Có       | '{}'::us.need[] |
| note_enc           | bytea                       | Không    | —               |
| shared             | boolean                     | Có       | false           |
| shared_fields      | text[]                      | Có       | '{}'::text[]    |
| shared_note_enc    | bytea                       | Không    | —               |
| expires_at         | timestamp(3) with time zone | Có       | —               |
| seen_by_partner_at | timestamp(3) with time zone | Không    | —               |
| created_at         | timestamp(3) with time zone | Có       | now()           |
| deleted_at         | timestamp(3) with time zone | Không    | —               |
| updated_at         | timestamp(3) with time zone | Có       | now()           |
| family_id          | uuid                        | Có       | —               |

Constraints:

- `mood_checkins_check`: `CHECK ((expires_at > created_at))`
- `mood_checkins_energy_check`: `CHECK (((energy >= 1) AND (energy <= 5)))`
- `mood_checkins_couple_space_id_family_id_fkey`: `FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id)`
- `mood_checkins_couple_space_id_fkey`: `FOREIGN KEY (couple_space_id) REFERENCES app.couple_spaces(id)`
- `mood_checkins_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `mood_checkins_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `mood_checkins_couple_space_id_not_null`: `NOT NULL couple_space_id`
- `mood_checkins_created_at_not_null`: `NOT NULL created_at`
- `mood_checkins_expires_at_not_null`: `NOT NULL expires_at`
- `mood_checkins_family_id_not_null`: `NOT NULL family_id`
- `mood_checkins_id_not_null`: `NOT NULL id`
- `mood_checkins_mood_not_null`: `NOT NULL mood`
- `mood_checkins_needs_not_null`: `NOT NULL needs`
- `mood_checkins_shared_fields_not_null`: `NOT NULL shared_fields`
- `mood_checkins_shared_not_null`: `NOT NULL shared`
- `mood_checkins_updated_at_not_null`: `NOT NULL updated_at`
- `mood_checkins_user_id_not_null`: `NOT NULL user_id`
- `mood_checkins_pkey`: `PRIMARY KEY (id)`
- `mood_checkins_id_family_id_couple_space_id_key`: `UNIQUE (id, family_id, couple_space_id)`
- `mood_checkins_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `mood_checkins_couple_space_id_created_at_idx`: `CREATE INDEX mood_checkins_couple_space_id_created_at_idx ON us.mood_checkins USING btree (couple_space_id, created_at DESC)`
- `mood_checkins_id_family_id_couple_space_id_key`: `CREATE UNIQUE INDEX mood_checkins_id_family_id_couple_space_id_key ON us.mood_checkins USING btree (id, family_id, couple_space_id)`
- `mood_checkins_id_family_id_key`: `CREATE UNIQUE INDEX mood_checkins_id_family_id_key ON us.mood_checkins USING btree (id, family_id)`
- `mood_checkins_pkey`: `CREATE UNIQUE INDEX mood_checkins_pkey ON us.mood_checkins USING btree (id)`
- `mood_checkins_user_id_created_at_idx`: `CREATE INDEX mood_checkins_user_id_created_at_idx ON us.mood_checkins USING btree (user_id, created_at DESC)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.mood_checkins FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_couple`: `CREATE TRIGGER trg_immutable_couple BEFORE UPDATE ON us.mood_checkins FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('couple_space_id')`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON us.mood_checkins FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_pair_check`: `CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.mood_checkins FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('user_id')`

## us.mood_responses — MoodResponse

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| id              | uuid                        | Có       | uuidv7()                       |
| checkin_id      | uuid                        | Có       | —                              |
| user_id         | uuid                        | Có       | —                              |
| type            | character varying(20)       | Có       | —                              |
| request_id      | uuid                        | Không    | —                              |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| family_id       | uuid                        | Có       | —                              |
| couple_space_id | uuid                        | Có       | —                              |

Constraints:

- `mood_responses_checkin_id_family_id_couple_space_id_fkey`: `FOREIGN KEY (checkin_id, family_id, couple_space_id) REFERENCES us.mood_checkins(id, family_id, couple_space_id)`
- `mood_responses_checkin_id_fkey`: `FOREIGN KEY (checkin_id) REFERENCES us.mood_checkins(id) ON DELETE CASCADE`
- `mood_responses_couple_space_id_family_id_fkey`: `FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id)`
- `mood_responses_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `mood_responses_request_id_family_id_couple_space_id_fkey`: `FOREIGN KEY (request_id, family_id, couple_space_id) REFERENCES us.requests(id, family_id, couple_space_id)`
- `mood_responses_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `mood_responses_checkin_id_not_null`: `NOT NULL checkin_id`
- `mood_responses_couple_space_id_not_null`: `NOT NULL couple_space_id`
- `mood_responses_created_at_not_null`: `NOT NULL created_at`
- `mood_responses_family_id_not_null`: `NOT NULL family_id`
- `mood_responses_id_not_null`: `NOT NULL id`
- `mood_responses_type_not_null`: `NOT NULL type`
- `mood_responses_updated_at_not_null`: `NOT NULL updated_at`
- `mood_responses_user_id_not_null`: `NOT NULL user_id`
- `mood_responses_pkey`: `PRIMARY KEY (id)`

Indexes:

- `mood_responses_pkey`: `CREATE UNIQUE INDEX mood_responses_pkey ON us.mood_responses USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.mood_responses FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_couple`: `CREATE TRIGGER trg_immutable_couple BEFORE UPDATE ON us.mood_responses FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('couple_space_id')`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON us.mood_responses FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_pair_check`: `CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.mood_responses FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('user_id')`

## us.pregnancy_name_candidates — PregnancyNameCandidate

| Cột             | PostgreSQL type             | NOT NULL | Default  |
| --------------- | --------------------------- | -------- | -------- |
| id              | uuid                        | Có       | uuidv7() |
| family_id       | uuid                        | Có       | —        |
| couple_space_id | uuid                        | Có       | —        |
| pregnancy_id    | uuid                        | Có       | —        |
| name_enc        | bytea                       | Có       | —        |
| meaning_enc     | bytea                       | Không    | —        |
| added_by        | uuid                        | Có       | —        |
| chosen_at       | timestamp(3) with time zone | Không    | —        |
| chosen_by       | uuid                        | Không    | —        |
| deleted_at      | timestamp(3) with time zone | Không    | —        |
| created_at      | timestamp(3) with time zone | Có       | now()    |
| updated_at      | timestamp(3) with time zone | Có       | now()    |

Constraints:

- `pregnancy_name_candidates_added_by_fkey`: `FOREIGN KEY (added_by) REFERENCES app.users(id)`
- `pregnancy_name_candidates_chosen_by_fkey`: `FOREIGN KEY (chosen_by) REFERENCES app.users(id)`
- `pregnancy_name_candidates_couple_space_id_family_id_fkey`: `FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id)`
- `pregnancy_name_candidates_couple_space_id_fkey`: `FOREIGN KEY (couple_space_id) REFERENCES app.couple_spaces(id)`
- `pregnancy_name_candidates_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `pregnancy_name_candidates_pregnancy_id_family_id_fkey`: `FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id)`
- `pregnancy_name_candidates_added_by_not_null`: `NOT NULL added_by`
- `pregnancy_name_candidates_couple_space_id_not_null`: `NOT NULL couple_space_id`
- `pregnancy_name_candidates_created_at_not_null`: `NOT NULL created_at`
- `pregnancy_name_candidates_family_id_not_null`: `NOT NULL family_id`
- `pregnancy_name_candidates_id_not_null`: `NOT NULL id`
- `pregnancy_name_candidates_name_enc_not_null`: `NOT NULL name_enc`
- `pregnancy_name_candidates_pregnancy_id_not_null`: `NOT NULL pregnancy_id`
- `pregnancy_name_candidates_updated_at_not_null`: `NOT NULL updated_at`
- `pregnancy_name_candidates_pkey`: `PRIMARY KEY (id)`
- `pregnancy_name_candidates_id_family_id_couple_space_id_key`: `UNIQUE (id, family_id, couple_space_id)`
- `pregnancy_name_candidates_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `pregnancy_name_candidates_id_family_id_couple_space_id_key`: `CREATE UNIQUE INDEX pregnancy_name_candidates_id_family_id_couple_space_id_key ON us.pregnancy_name_candidates USING btree (id, family_id, couple_space_id)`
- `pregnancy_name_candidates_id_family_id_key`: `CREATE UNIQUE INDEX pregnancy_name_candidates_id_family_id_key ON us.pregnancy_name_candidates USING btree (id, family_id)`
- `pregnancy_name_candidates_pkey`: `CREATE UNIQUE INDEX pregnancy_name_candidates_pkey ON us.pregnancy_name_candidates USING btree (id)`
- `pregnancy_name_candidates_pregnancy_id_idx`: `CREATE INDEX pregnancy_name_candidates_pregnancy_id_idx ON us.pregnancy_name_candidates USING btree (pregnancy_id) WHERE (deleted_at IS NULL)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.pregnancy_name_candidates FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_couple`: `CREATE TRIGGER trg_immutable_couple BEFORE UPDATE ON us.pregnancy_name_candidates FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('couple_space_id')`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON us.pregnancy_name_candidates FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_pair_check`: `CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.pregnancy_name_candidates FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('added_by', 'chosen_by')`

## us.pregnancy_name_votes — PregnancyNameVote

| Cột             | PostgreSQL type             | NOT NULL | Default                        |
| --------------- | --------------------------- | -------- | ------------------------------ |
| candidate_id    | uuid                        | Có       | —                              |
| user_id         | uuid                        | Có       | —                              |
| created_at      | timestamp(3) with time zone | Có       | now()                          |
| updated_at      | timestamp(3) with time zone | Có       | now()                          |
| deleted_at      | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |
| family_id       | uuid                        | Có       | —                              |
| couple_space_id | uuid                        | Có       | —                              |

Constraints:

- `pregnancy_name_votes_candidate_id_family_id_couple_space_i_fkey`: `FOREIGN KEY (candidate_id, family_id, couple_space_id) REFERENCES us.pregnancy_name_candidates(id, family_id, couple_space_id)`
- `pregnancy_name_votes_candidate_id_fkey`: `FOREIGN KEY (candidate_id) REFERENCES us.pregnancy_name_candidates(id) ON DELETE CASCADE`
- `pregnancy_name_votes_couple_space_id_family_id_fkey`: `FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id)`
- `pregnancy_name_votes_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `pregnancy_name_votes_user_id_fkey`: `FOREIGN KEY (user_id) REFERENCES app.users(id)`
- `pregnancy_name_votes_candidate_id_not_null`: `NOT NULL candidate_id`
- `pregnancy_name_votes_couple_space_id_not_null`: `NOT NULL couple_space_id`
- `pregnancy_name_votes_created_at_not_null`: `NOT NULL created_at`
- `pregnancy_name_votes_family_id_not_null`: `NOT NULL family_id`
- `pregnancy_name_votes_updated_at_not_null`: `NOT NULL updated_at`
- `pregnancy_name_votes_user_id_not_null`: `NOT NULL user_id`
- `pregnancy_name_votes_pkey`: `PRIMARY KEY (candidate_id, user_id)`

Indexes:

- `pregnancy_name_votes_pkey`: `CREATE UNIQUE INDEX pregnancy_name_votes_pkey ON us.pregnancy_name_votes USING btree (candidate_id, user_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.pregnancy_name_votes FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_couple`: `CREATE TRIGGER trg_immutable_couple BEFORE UPDATE ON us.pregnancy_name_votes FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('couple_space_id')`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON us.pregnancy_name_votes FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_pair_check`: `CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.pregnancy_name_votes FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('user_id')`

## us.request_children — RequestChild

| Cột        | PostgreSQL type             | NOT NULL | Default                        |
| ---------- | --------------------------- | -------- | ------------------------------ |
| request_id | uuid                        | Có       | —                              |
| child_id   | uuid                        | Có       | —                              |
| family_id  | uuid                        | Có       | —                              |
| created_at | timestamp(3) with time zone | Có       | now()                          |
| updated_at | timestamp(3) with time zone | Có       | now()                          |
| deleted_at | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `request_children_child_id_family_id_fkey`: `FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)`
- `request_children_request_id_family_id_fkey`: `FOREIGN KEY (request_id, family_id) REFERENCES us.requests(id, family_id) ON DELETE CASCADE`
- `request_children_child_id_not_null`: `NOT NULL child_id`
- `request_children_created_at_not_null`: `NOT NULL created_at`
- `request_children_family_id_not_null`: `NOT NULL family_id`
- `request_children_request_id_not_null`: `NOT NULL request_id`
- `request_children_updated_at_not_null`: `NOT NULL updated_at`
- `request_children_pkey`: `PRIMARY KEY (request_id, child_id)`

Indexes:

- `request_children_pkey`: `CREATE UNIQUE INDEX request_children_pkey ON us.request_children USING btree (request_id, child_id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.request_children FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON us.request_children FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`

## us.requests — Request

| Cột              | PostgreSQL type             | NOT NULL | Default                        |
| ---------------- | --------------------------- | -------- | ------------------------------ |
| id               | uuid                        | Có       | uuidv7()                       |
| family_id        | uuid                        | Có       | —                              |
| couple_space_id  | uuid                        | Có       | —                              |
| sender_user_id   | uuid                        | Có       | —                              |
| receiver_user_id | uuid                        | Có       | —                              |
| kind             | us.request_kind             | Có       | —                              |
| need_code        | us.need                     | Không    | —                              |
| template_id      | uuid                        | Không    | —                              |
| title_enc        | bytea                       | Không    | —                              |
| duration_min     | smallint                    | Không    | —                              |
| content_key      | bytea                       | Có       | —                              |
| message_enc      | bytea                       | Không    | —                              |
| due_kind         | us.request_due_kind         | Không    | —                              |
| due_at           | timestamp(3) with time zone | Không    | —                              |
| urgency          | us.request_urgency          | Có       | 'NORMAL'::us.request_urgency   |
| status           | us.request_status           | Có       | 'SENT'::us.request_status      |
| volunteered      | boolean                     | Có       | false                          |
| decline_reason   | character varying(30)       | Không    | —                              |
| ack_type         | character varying(15)       | Không    | —                              |
| talk_at          | timestamp(3) with time zone | Không    | —                              |
| reminder_at      | timestamp(3) with time zone | Không    | —                              |
| hearts_awarded   | smallint                    | Có       | 0                              |
| self_mission_id  | uuid                        | Không    | —                              |
| seen_at          | timestamp(3) with time zone | Không    | —                              |
| responded_at     | timestamp(3) with time zone | Không    | —                              |
| done_at          | timestamp(3) with time zone | Không    | —                              |
| cancelled_at     | timestamp(3) with time zone | Không    | —                              |
| expires_at       | timestamp(3) with time zone | Có       | —                              |
| created_at       | timestamp(3) with time zone | Có       | now()                          |
| updated_at       | timestamp(3) with time zone | Có       | now()                          |
| version          | integer                     | Có       | 1                              |
| deleted_at       | timestamp(3) with time zone | Không    | NULL::timestamp with time zone |

Constraints:

- `requests_check`: `CHECK ((sender_user_id <> receiver_user_id))`
- `requests_check1`: `CHECK (((due_at IS NULL) OR (due_at <= (created_at + '7 days'::interval))))`
- `requests_check2`: `CHECK ((((kind = 'NEED'::us.request_kind) AND (need_code = ANY (ARRAY['QUIET'::us.need, 'HUG'::us.need, 'TALK'::us.need, 'REASSURANCE'::us.need]))) OR ((kind = 'TASK'::us.request_kind) AND ((need_code IS NULL) OR (need_code = ANY (ARRAY['BREAK'::us.need, 'HELP_CHILD'::us.need]))))))`
- `requests_check3`: `CHECK (((kind = 'NEED'::us.request_kind) OR (template_id IS NOT NULL) OR (title_enc IS NOT NULL) OR (need_code IS NOT NULL)))`
- `requests_check4`: `CHECK (((kind = 'TASK'::us.request_kind) OR ((hearts_awarded = 0) AND (template_id IS NULL) AND (due_kind IS NULL))))`
- `requests_check5`: `CHECK (((status <> ALL (ARRAY['ACCEPTED'::us.request_status, 'DONE'::us.request_status])) OR (kind = 'TASK'::us.request_kind)))`
- `requests_check6`: `CHECK (((status <> 'ACKNOWLEDGED'::us.request_status) OR (kind = 'NEED'::us.request_kind)))`
- `requests_check7`: `CHECK (((NOT volunteered) OR (kind = 'TASK'::us.request_kind)))`
- `requests_check8`: `CHECK (((kind <> 'NEED'::us.request_kind) OR (need_code IS NOT NULL)))`
- `requests_duration_min_check`: `CHECK ((duration_min = ANY (ARRAY[15, 30, 60])))`
- `requests_hearts_awarded_check`: `CHECK ((hearts_awarded >= 0))`
- `requests_couple_space_id_family_id_fkey`: `FOREIGN KEY (couple_space_id, family_id) REFERENCES app.couple_spaces(id, family_id)`
- `requests_couple_space_id_fkey`: `FOREIGN KEY (couple_space_id) REFERENCES app.couple_spaces(id)`
- `requests_family_id_fkey`: `FOREIGN KEY (family_id) REFERENCES app.families(id)`
- `requests_receiver_user_id_fkey`: `FOREIGN KEY (receiver_user_id) REFERENCES app.users(id)`
- `requests_self_mission_id_family_id_fkey`: `FOREIGN KEY (self_mission_id, family_id) REFERENCES app.missions(id, family_id)`
- `requests_sender_user_id_fkey`: `FOREIGN KEY (sender_user_id) REFERENCES app.users(id)`
- `requests_template_id_fkey`: `FOREIGN KEY (template_id) REFERENCES app.mission_templates(id)`
- `requests_content_key_not_null`: `NOT NULL content_key`
- `requests_couple_space_id_not_null`: `NOT NULL couple_space_id`
- `requests_created_at_not_null`: `NOT NULL created_at`
- `requests_expires_at_not_null`: `NOT NULL expires_at`
- `requests_family_id_not_null`: `NOT NULL family_id`
- `requests_hearts_awarded_not_null`: `NOT NULL hearts_awarded`
- `requests_id_not_null`: `NOT NULL id`
- `requests_kind_not_null`: `NOT NULL kind`
- `requests_receiver_user_id_not_null`: `NOT NULL receiver_user_id`
- `requests_sender_user_id_not_null`: `NOT NULL sender_user_id`
- `requests_status_not_null`: `NOT NULL status`
- `requests_updated_at_not_null`: `NOT NULL updated_at`
- `requests_urgency_not_null`: `NOT NULL urgency`
- `requests_version_not_null`: `NOT NULL version`
- `requests_volunteered_not_null`: `NOT NULL volunteered`
- `requests_pkey`: `PRIMARY KEY (id)`
- `requests_id_family_id_couple_space_id_key`: `UNIQUE (id, family_id, couple_space_id)`
- `requests_id_family_id_key`: `UNIQUE (id, family_id)`

Indexes:

- `ix_req_couple`: `CREATE INDEX ix_req_couple ON us.requests USING btree (couple_space_id, status, created_at DESC)`
- `ix_req_expire`: `CREATE INDEX ix_req_expire ON us.requests USING btree (expires_at) WHERE ((status = ANY (ARRAY['SENT'::us.request_status, 'SEEN'::us.request_status, 'ACCEPTED'::us.request_status])) AND (deleted_at IS NULL))`
- `ix_req_open_sender`: `CREATE INDEX ix_req_open_sender ON us.requests USING btree (sender_user_id) WHERE ((status = ANY (ARRAY['SENT'::us.request_status, 'SEEN'::us.request_status, 'ACCEPTED'::us.request_status])) AND (volunteered = false) AND (deleted_at IS NULL))`
- `ix_req_resend_block`: `CREATE INDEX ix_req_resend_block ON us.requests USING btree (sender_user_id, content_key, responded_at DESC) WHERE ((status = 'DECLINED'::us.request_status) AND (deleted_at IS NULL))`
- `requests_id_family_id_couple_space_id_key`: `CREATE UNIQUE INDEX requests_id_family_id_couple_space_id_key ON us.requests USING btree (id, family_id, couple_space_id)`
- `requests_id_family_id_key`: `CREATE UNIQUE INDEX requests_id_family_id_key ON us.requests USING btree (id, family_id)`
- `requests_pkey`: `CREATE UNIQUE INDEX requests_pkey ON us.requests USING btree (id)`

Triggers:

- `trg_audit_update`: `CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.requests FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns()`
- `trg_immutable_couple`: `CREATE TRIGGER trg_immutable_couple BEFORE UPDATE ON us.requests FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('couple_space_id')`
- `trg_immutable_family`: `CREATE TRIGGER trg_immutable_family BEFORE UPDATE ON us.requests FOR EACH ROW EXECUTE FUNCTION ops.reject_changed_columns('family_id')`
- `trg_pair_check`: `CREATE TRIGGER trg_pair_check BEFORE INSERT OR UPDATE ON us.requests FOR EACH ROW EXECUTE FUNCTION us.check_pair_participants('sender_user_id', 'receiver_user_id')`
