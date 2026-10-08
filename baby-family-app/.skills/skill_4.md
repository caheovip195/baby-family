# Skill 4: Project Structure Compliance

The existing project structure is the highest priority.

Never assume a new architecture is better than the current one.

When multiple implementations are possible, always choose the one that matches the existing project, even if another approach is considered more modern.

## Goal

Strictly follow the existing project architecture, folder structure, naming conventions, and coding patterns.

## Rules

- Never change the project architecture unless explicitly requested.
- Never create new folders, layers, modules, or packages without permission.
- Never move, rename, or reorganize existing files unless explicitly requested.
- Always reuse the existing project structure.
- Always follow the project's dependency flow.
- Always place new files in the correct existing directory.
- Always follow existing naming conventions.
- Always follow the same code style and implementation pattern already used in the project.
- Never introduce a different architecture, design pattern, or coding style.

## Before Coding

Before implementing any feature:

- Analyze the current project structure.
- Locate similar existing implementations.
- Reuse existing patterns whenever possible.
- Determine the correct location for every new file.
- Follow existing dependency injection, routing, repository, service, model, state management, and networking patterns.

## Forbidden

Never:

- Create duplicate implementations.
- Create parallel architectures.
- Introduce another state management solution.
- Introduce another networking solution.
- Introduce another dependency injection framework.
- Replace existing patterns with personal preferences.
- Create temporary or backup files.
- Guess the project structure.

If the required structure is unclear, inspect the project first before writing code.

## Self Validation

Before finishing, verify:

- No existing architecture was changed.
- Every new file is in the correct location.
- Every modified file follows the existing coding style.
- No unnecessary files or folders were created.
- No duplicate implementations exist.
- The final implementation is indistinguishable from the rest of the project.

If any rule is violated, refactor the implementation before responding.

## Tách widget theo màn (bắt buộc)

Mỗi file view chỉ giữ: import, hằng số/dữ liệu của màn, helper dùng chung và widget
public của màn (`XxxMobileView` / `XxxTabletView`).

Mọi widget private (`class _Xxx extends StatelessWidget/HookWidget/...`) phải nằm
trong thư mục `widgets/` của màn đó, mỗi widget một file:

```
lib/page/<role>/<screen>/
  <screen>_page.dart
  <screen>_controller.dart
  mobile/<screen>_mobile_view.dart
  widgets/<ten_widget>.dart
```

- File view khai báo `part 'widgets/<ten_widget>.dart';` (hoặc `part '../widgets/...'`
  khi view nằm trong `mobile/`), xếp theo thứ tự alphabet ngay sau phần import.
- File widget mở đầu bằng `part of '<đường dẫn tới file view>';`, không tự import
  (part file dùng chung import của file view).
- Tên file theo snake_case của tên class, bỏ dấu `_` đầu: `_ItemCard` -> `item_card.dart`.
- `StatefulWidget` và class `State` đi kèm nằm chung một file.
- Nếu một màn có nhiều view cùng tách widget, đặt thêm thư mục con theo tên view:
  `widgets/<ten_view>/<ten_widget>.dart` để tránh trùng tên file.

Không viết dồn nhiều widget vào một file view dài.
