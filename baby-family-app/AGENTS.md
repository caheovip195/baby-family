# AGENTS.md

You are working on the **Baby Family** Flutter app.

Always answer in Vietnamese unless code/comments require English.

## Mandatory Skill Loading

Before starting ANY task, you MUST read:

1. `.skills/index.md`
2. Every skill file listed inside `.skills/index.md`

The `.skills` rules are mandatory project rules, not suggestions. If a task
violates any skill rule, stop and explain the conflict.

Never rely only on conversation memory. `SESSION.md`, `.skills` and the product
documents are the source of truth.

## Source documents

- Nghiệp vụ, màn hình, Design System: `../docs/01_DAC_TA_NGHIEP_VU_BABY_FAMILY_v3.md`
- Kỹ thuật, API, phân quyền, DB: `../docs/02_TAI_LIEU_KY_THUAT_BABY_FAMILY_v3.md`
- Mã màn (`HOME-01`, `CARE-03`...), quy tắc (`BR-xxx`), tiêu chí (`AC-xxx`) dùng
  chung giữa 2 tài liệu và code (tên thư mục màn, comment controller).

## Startup Checklist

1. Read `.skills/index.md` and all skill files
2. Read `SESSION.md`
3. Read the relevant sections of the 2 source documents (screen spec + API)
4. Inspect similar existing implementations in `lib/`
5. Work in small steps
6. Update `SESSION.md` after important progress

## Workflow Rule

For every non-trivial task:

BA (đọc đặc tả màn + BR/AC) → ARCHITECT (xác định layer/file) → DEV_FLUTTER →
TESTER → QUALITY_GATE → SESSION UPDATE

Small bug fix: short summary → DEV_FLUTTER → TESTER → QUALITY_GATE → SESSION UPDATE.

## Architecture (bắt buộc)

```
Page (@RoutePage, BaseHookWidget)
  → Controller (BaseNotifier + ChangeNotifierProvider.autoDispose)
    → Service (data/service + data/service_imp, expose qua data/provider)
      → Repository (data/repository + data/repository_imp)
        → AppClient (Retrofit) / LocalStore (Hive)
```

- Routing: `auto_route` (`lib/utils/router/app_router.dart`).
- State: `hooks_riverpod` + `flutter_hooks`.
- Network: `dio` + `retrofit`, endpoint trong `lib/utils/constants/server.dart`.
- Model: `freezed` + `json_serializable` trong `lib/data/model/`.
- DTO: `lib/data/dto/`. Enum: `lib/utils/constants/enum_part/`.
- Đa ngôn ngữ: `flutter gen-l10n` (ARB `lib/l10n/arb/`, mặc định `vi`, có `en`);
  mọi chuỗi hiển thị qua `context.l10n` (Skill 10).
- Màn: `lib/page/<general|parent|circle>/<screen>/` gồm `<screen>_page.dart`,
  `<screen>_controller.dart`, `mobile/<screen>_mobile_view.dart`,
  `widgets/<widget>.dart`.

## Before Coding

1. Confirm which skill files apply
2. Inspect similar existing implementations
3. Identify exact files to modify
4. Make a short implementation plan
5. Make minimal targeted changes only

## After Coding

1. Review `git diff`
2. Check compliance with all loaded skills
3. Run `make runner` (khi đổi model/retrofit/route) và `make check`
4. Fix any syntax, logic, UI, architecture, or hidden issues
5. Summarize changed files
6. Update `SESSION.md`

## Hard Rules

* Never skip reading `.skills/index.md`
* Never create backup/copy/temp files
* Never rewrite unrelated code
* Never change project architecture without explicit permission
* Never add a new package without explicit approval
* Never place files outside the defined project structure
* Never hard-code business mock data (tên bé, ảnh, số liệu) in UI
* Never hard-code user-facing strings — add them to every ARB file (Skill 10)
