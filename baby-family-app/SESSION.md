# SESSION.md — Nhật ký làm việc Baby Family App

## 2026-10-07 — Khởi tạo base project

**Đã làm**
- Tạo project Flutter 3.44.5 (fvm), package `baby_family`, iOS + Android.
- Flavor: `staging` (`lib/main_dev.dart`, bundle `vn.babyfamily.app.staging`,
  tên “SBaby Family”) và `product` (`lib/main_pro.dart`, bundle
  `vn.babyfamily.app`). Android: productFlavors; iOS: build configurations
  `Debug/Release/Profile-Staging|Product`, scheme `Staging`, `Product`.
- Kiến trúc theo base hanoicheck: auto_route + hooks_riverpod/flutter_hooks +
  dio/retrofit + freezed; tầng data `repository → repository_imp`,
  `service → service_imp`, `provider`; `page/application_base.dart`.
- Remote: `AppServiceDio`, `AppClient` (refresh/logout/me/devices),
  interceptor Device (header chung), Authorization (refresh token xoay vòng,
  một lần gia hạn dùng chung), Error (401 → Welcome, 426), Log.
- LocalStore: Hive + AES-GCM, khoá sinh ngẫu nhiên lưu Keychain/Keystore,
  IV ngẫu nhiên mỗi lần mã hoá.
- Design tokens: `colors.dart`, `theme.dart` (typography Nunito + Be Vietnam
  Pro, radius, spacing, shadows, `AppTheme.light()`).
- Widget dùng chung: BaseScaffold, BaseAppBar, AppButton, AppDialog,
  CircleLoadingProgress, StartupErrorApp.
- Màn mẫu: `page/general/welcome` (ONB-01) minh hoạ chuẩn page/controller/view/widgets.
- Test: Result, DeviceLayoutHelper, serverErrorMessage.

- **Đa ngôn ngữ (l10n):** `flutter gen-l10n` (`l10n.yaml`, ARB `lib/l10n/arb/app_vi.arb`
  template + `app_en.arb`, sinh vào `lib/generated/l10n/`), enum `AppLanguage`,
  `appLanguageProvider` (đổi ngôn ngữ áp dụng ngay, lưu LocalStore, đồng bộ
  `PATCH /v1/me {locale}`), header `Accept-Language`, `context.l10n` /
  `currentL10n()`, định dạng ngày theo locale, bộ chọn ngôn ngữ ở Welcome,
  `CFBundleLocalizations` (iOS) + `locales_config.xml` (Android 13).
  Test: đủ key mọi ARB, plural, AppLanguage ↔ supportedLocales. Skill 10.

- Kiểm chứng build: Android `assembleStagingDebug` OK; iOS `--flavor staging` và
  `--flavor product` (no-codesign) OK — bundle `vn.babyfamily.app(.staging)`, tên
  “SBaby Family”/“Baby Family”, `CFBundleLocalizations` vi/en. Plugin iOS dùng
  Swift Package Manager (không có Podfile).

- Nhãn mặc định Bố/Mẹ = **Papa / Mama** (mọi ngôn ngữ, `kValueDefaultCallName*`),
  khu vực riêng của hai người tên **“Papa & Mama”** (tài liệu C-13).

**Việc còn mở**
- Firebase chưa cấu hình: chạy `flutterfire configure` cho 2 flavor, thêm
  `google-services.json` (android/app/src/staging|product) và
  `GoogleService-Info.plist`, bật plugin gradle trong `android/app/build.gradle.kts`.
- Keystore release Android (`android/keystore.properties`), signing iOS.
- App icon / splash (`make icon` sau khi có ảnh).
- Header `X-Timezone` dạng IANA (cần package timezone thiết bị).
- Màn SET-06 (Cài đặt ngôn ngữ) dùng lại `LanguagePickerSheet`.
- Các màn theo tài liệu nghiệp vụ mục 9 (bắt đầu từ AUTH-01, ONB-03…).
- Thư viện tính năng sẽ thêm khi làm màn (cần duyệt): sign_in_with_apple,
  google_sign_in, in_app_purchase, local_auth, app_links, background upload,
  record/just_audio, qr_flutter.

## 2026-10-08 — Dựng màn Flutter với dữ liệu mẫu theo Pencil và tài liệu v3

**Đã làm**
- Đối chiếu `../desgin/appdesgin.pen`, tài liệu nghiệp vụ và kỹ thuật v3; dựng
  30 Page cùng các biến thể mã màn: Splash/Welcome/Auth/Onboarding/Invite,
  Home, Kỷ niệm, Chăm con, Papa & Mama, Gia đình, Thai kỳ, người thân,
  Gói, Cài đặt, Thông báo và các trạng thái loading/rỗng/lỗi/offline.
- Giữ cấu trúc `general/parent/circle`, Page → Controller (`BaseNotifier`,
  `ChangeNotifierProvider.autoDispose`) → Service → Repository. `DemoNotifier`
  dùng chung quản lý loading/lỗi, dispose, cập nhật locale/dữ liệu và chủ thể.
  Model mock Freezed/JSON nằm ở `data/model`, provider/service/repository đầy đủ;
  không thêm dependency. Sinh lại route, model và assets bằng `make runner`.
- Dữ liệu mẫu trong `assets/data/demo_family.json`: catalog riêng vi/en/zh/ja,
  ảnh offline từ thiết kế, gia đình nhiều bé, thai kỳ, kỷ niệm/ảnh tháng/ảnh
  bụng bầu, nhiệm vụ, tên bé, checklist chuẩn bị và thông báo.
- Hành vi mock lưu trong phiên: thêm nhiều bé, thêm kỷ niệm/ảnh/câu nói,
  bình luận và góc nhìn theo ID kỷ niệm; thêm/đổi/hoàn thành/hoàn tác nhiệm vụ,
  Hearts riêng tư và Together; check-in, lời nhờ, lời cảm ơn và nhật ký;
  chuyển thai kỳ thành sơ sinh, lưu trữ cùng quyền xem. Nguồn mock có guard
  nhiệm vụ bạn đời/đã hoàn thành, ngày thực hiện và giới hạn đổi nhiệm vụ.
- Người thân chỉ thấy các bé được cấp quyền và kỷ niệm public của gia đình,
  không thấy thai kỳ hay dữ liệu riêng Papa & Mama. SW-01 và QC-01 là các
  bottom sheet dùng chung; nội dung mock cập nhật khi quay lại tab.
- Bổ sung tiếng Trung giản thể và tiếng Nhật: 421 key UI mỗi ARB, enum,
  supportedLocales, lưu locale, định dạng ngày, iOS/Android declarations.
  Bản mock không gọi PATCH locale lên API. Bổ sung dark theme và on-primary
  tương phản AA; cài đặt theme/cỡ chữ có tác dụng trên RootApp.
- README và `MOCK_SCREENS.md` mô tả route, luồng thử, giới hạn mô phỏng.
  `make mock-run` mở trực tiếp Home; OTP `123456`, mã lời mời `K7Q29MXA`.

**Kiểm chứng**
- `make runner`: thành công. `make check`: format/analyze sạch, **103 test pass**.
  Bao gồm mutation/validation/privacy, ma trận màn 360dp và text scale 130%
  với vi/en/zh/ja, theme sáng/tối, OTP/invite/onboarding cùng các màn MEM/PREG.
- Build Android staging debug thành công:
  `build/app/outputs/flutter-apk/app-staging-debug.apk`.
- Build và chạy iOS staging debug trên iPhone Air/iOS 26.5 thành công. Kiểm tra
  Home, Gia đình, Cài đặt; đổi Trung/Nhật, dark theme và cỡ chữ lớn bằng UI,
  trả bản thử về Việt + cỡ chữ chuẩn + theme hệ thống.
- Đã sửa lỗi thanh điều hướng chiếm toàn bộ chiều cao, panel che ink ListTile,
  chọn bé trong CARE-03, overflow Welcome/country code ở chữ lớn. Test kiểm
  tra chiều cao navigation và thao tác chọn/bỏ chọn/lưu nhiệm vụ phòng hồi quy.

**Phạm vi hiện tại**
- Đăng nhập xã hội, OTP/SMS, gửi lời mời, camera/gallery, thông báo, mua/khôi
  phục gói và export là mô phỏng. Nội dung mới reset khi khởi động lại app;
  locale được lưu LocalStore. Chưa kết nối API nghiệp vụ cho các màn mới.
- Việc Firebase, release signing, native icon/splash và các SDK tính năng
  thực tế từ phiên trước vẫn chờ cấu hình khi chuyển sang tích hợp production.

## 2026-10-08 — Rebuild UI: nền tảng (foundation) cho các agent khu vực

**Đã làm**
- **Dữ liệu mock có kiểu** (thay DemoFamily/DemoEntry cho code mới; lớp demo cũ
  vẫn biên dịch): model freezed `lib/data/model/{session,family,child,memory,care,us,pregnancy,notification}/`,
  DTO `care_board`, `mission_completion`, `couple_today`, `circle_view`,
  `invite_preview_data`, 30 enum mới trong `enum_part`. `MockStore`
  (`repository_imp/mock_store.dart`) nạp `assets/data/mock/*.json` (câu chuyện
  Pencil: Nhà Lan, Mama Lan, Papa Minh, Hana 2 tuổi 4 tháng, Haru 5 tháng 6 ngày,
  Bơ tuần 24 + 3 ngày; catalog vi/en/zh/ja), `mockRevisionProvider` làm mới UI
  sau mỗi thay đổi/đổi ngôn ngữ. Repository + service + provider cho session,
  family, child, memory, care, us, pregnancy, notification, circle. Quy tắc nhẹ
  (UI-first): Hearts riêng tư (BR-018), chỉ ME/TOGETHER (BR-020), đổi nhiệm vụ
  ±1 Hearts tối đa 3/ngày, hoàn tác 10 s, tối đa 5 lời nhờ mở (BR-067), 1 góc
  nhìn/Parent (BR-071), 1 ảnh tháng/bé/tháng (BR-072), gợi ý 1/ngày (BR-073),
  dùng thử không có người thân (C-07), trạng thái phiên suy ra từ dữ liệu (BR-052).
- Seed dev `--dart-define=BABY_FAMILY_DEMO=fresh|active|pregnant|circle|expired`
  (mặc định `fresh`), `BABY_FAMILY_ACTOR=mama|papa`; `make mock-run` dùng `active`.
  “Hôm nay” cố định 07/10/2026 20:25 (`AppClock`, `kValueDemoToday`).
- `lib/utils/helper/child_age.dart`: tuổi bé, tuần thai, ngày còn lại, tháng
  tuổi, tam cá nguyệt (+ test).
- **Router** viết lại theo bảng kế hoạch (53 route), `SplashPage` initial điều
  hướng bằng `routeForSession`; không dùng guard chặn (luồng mock đi xuyên qua).
  51 màn khung (page/controller/view) có nút đi tiếp theo luồng.
- **Main shell**: `AutoTabsRouter` 4 tab + `AppTabBar` (Pencil `luKhc`), FAB mở
  QC-01 (`QuickCreateSheet`), giữ trạng thái tab, nút back Android về Trang chủ.
- **Bộ widget dùng chung** khớp component Pencil: `AppButton`
  (primary/secondary/social/us/text), `AppTextField`, `AppChip`,
  `AppLanguageChip`, `AppTopBar`, `AppChoiceCard`, `AppTabBar`, `MissionCard`,
  `ChildAvatar`, `ChildSwitcher` + SW-01, `AppBottomSheet`/`showAppBottomSheet`,
  `SectionHeader`, `AppCard`, `SegmentedTabs`, `UnderlineTabs`,
  `AppProgressBar`, `AppSwitch`, `EmptyState`, `ErrorState`, `SkeletonBlock`,
  `MemoryListSkeleton`, `OfflineBanner`, `MemoryCard`, `QuoteCard`, `VoiceCard`,
  `StoryRing`, `AppLogo`, `QuickCreateSheet`; token mới trong `colors.dart` /
  `theme.dart` (bóng TabBar/FAB, kích thước 52/56/84/60…).
- **Màn cũ** chuyển sang `lib/page/**/legacy_*`, đổi tên class `Legacy*`, bỏ
  `@RoutePage`; widget cũ trùng tên đổi thành `legacy_*.dart`. Test cũ của các
  màn `?screen=` đã xoá.

**Kiểm chứng**: `make runner`, `make check` (114 test pass), build iOS simulator
staging debug.

### Design QA — so ảnh màn Flutter với Pencil

1. Trong test của khu vực (`test/page/<area>_test.dart`):
   ```dart
   import '../helpers/design_qa.dart';
   setUpAll(loadAppFonts); // Nunito, Be Vietnam Pro, Lucide
   testWidgets('design qa HOME-01', (tester) async {
     await pumpRoute(tester, const MainShellRoute()); // hoặc pumpScreen(widget)
     await saveDesignShot(tester, 'home_01');
   });
   ```
   Tuỳ chọn: `size: kNarrowSize`, `themeMode: ThemeMode.dark`,
   `language: AppLanguage.en`, `seed: DemoSeed.pregnant`, `actor: 'papa'`,
   `textScale: 1.3`.
2. Chạy `fvm flutter test test/page/<area>_test.dart --update-goldens --plain-name 'design qa'`
   → ảnh `build/design_qa/home_01.png` (thư mục `build/` bị git-ignore; không
   commit golden; chạy thường thì `saveDesignShot` bỏ qua).
3. Mở PNG bằng công cụ đọc ảnh, so với `TakeScreenshot(["ClpJ6"])` qua Pencil MCP
   (`mcp__pencil__execute`), đọc số đo bằng `Get(id)`. Lưu ý: bóng đổ có blur
   hiển thị “cứng” trong golden (renderer test), ảnh Pencil dùng ảnh Unsplash —
   app dùng ảnh xuất trong `assets/images/design_*`.

**Việc còn mở**: dựng UI từng màn (agent khu vực), xoá `legacy_*` và widget
`legacy_*`, `AppSkeletonScreen`, lớp demo cũ (`DemoNotifier`, `demo_*`) khi
không còn tham chiếu.

## 2026-10-10 — Rebuild UI: dựng lại toàn bộ màn theo Pencil (UI-first, mock)

**Đã làm**
- 7 khu vực dựng lại theo frame Pencil (copy đúng chữ/số/ảnh, không thêm nội dung
  ngoài thiết kế; nút đi tiếp luôn qua màn):
  Auth/Onboarding (SPL-01, ONB-01, AUTH-01..04, ONB-03..10, ONB-09, INV-05,
  INV-01 ×2, CIR-WAIT) • Home (HOME-01/02/03, NOTI-01, tab bar, SW-01, QC-01,
  STATE-01..05) • Ký ức (MEM-01 + tab Ảnh/Bộ sưu tập, MEM-05, 07, 12, 20..25,
  chi tiết bộ sưu tập) • Chăm con (CARE-01/01b/02/03/04/05/06/09) • Papa & Mama
  (US-01..04b, US-05) • Thai kỳ (PREG-01..07, tab Siêu âm) • Gia đình/Gói/Cài
  đặt/Người thân (FAM-01/03, SUB-01/07, SET-01/06, CIR-01).
- Màn không có trong Pencil dựng theo tài liệu nghiệp vụ, cùng ngôn ngữ thiết kế:
  ONB-09, MEM-02, MEM-12, chi tiết bộ sưu tập, CARE-02, CARE-04, US-05, PREG-03,
  PREG-05 B1.
- Xoá toàn bộ code cũ: trang `legacy_*`, widget `legacy_*`/thừa, lớp demo
  (`DemoNotifier`, `demo_*`, `assets/data/demo_family.json`, test cũ).

**Kiểm chứng**: `flutter analyze` sạch; **308 test pass**; build iOS simulator
(seed `active`) và đi tay 4 tab + QC-01 trên iPhone Air.

**Lệch thiết kế còn mở (dữ liệu trong thiết kế mâu thuẫn nhau — app đang tính theo dữ liệu)**
- "Ngày mai Haru tròn 6 tháng" vs tuổi 5 tháng 6 ngày → app hiện "Còn 25 ngày".
- SUB-01 "còn 12 ngày" vs FAM-01 "còn 62 ngày"; SUB-07 "08/12/2027".
- HOME-03 "5 tên dự định" vs PREG-07 có 4 tên; MEM-25 "3/5" vs 4 story.
- ONB-07/ONB-ACT dùng mã mời/ngày hết hạn sinh ra trong luồng mới, không phải
  "K7Q2 · 9MXA" / "08/12/2026".
- Seed `active` (đang dùng thử) không có người thân → PREG-05 ẩn khối báo tin,
  MEM-05 hiện "Cả nhà" thay vì "· 4 người thân".
- Một số frame vẽ từ góc nhìn Papa (CARE-01, US-04), seed mặc định là Mama;
  dùng `BABY_FAMILY_ACTOR=papa` để xem góc Papa.
- Nhật ký riêng, Cầu nối, Tuần của hai ta, So sánh/Ghép ảnh, tìm kiếm… chưa có
  màn → snackbar "Sắp ra mắt".

## 2026-10-10 — Foundation batch 2 + story v2

- 32 route + màn khung mới cho 33 frame Pencil (MEM-03/03a/08/10/11/13/14/15/16,
  REC-02, CARE-07/08/10/12, CAL-02, US-06/07/15, CHD-01…04, FAM-04/07,
  SET-02/03/04/07/08/09(b,c)/11/12) — khung dùng `AppSkeletonScreen` (tạm).
- Dữ liệu mock có kiểu cho các màn trên: album, luồng bình luận có trả lời,
  bộ chọn cột mốc (nhóm + ngày đã ghi/dự kiến), bản nháp nhật ký/thư, tìm kiếm,
  ngày này năm xưa, tổng kết tuần, lịch + sự kiện âm lịch, lịch sử nhiệm vụ,
  huy hiệu, cài đặt nhiệm vụ, bức tường cảm ơn, nhật ký riêng, cài đặt Papa &
  Mama, hồ sơ bé chi tiết + bé lưu trữ, quyền người thân theo từng bé, cài đặt
  gia đình, `ISettingsService` (hồ sơ, thông báo, quyền riêng tư, thiết bị, xuất
  dữ liệu, xoá tài khoản, trợ giúp) — fixture mới `assets/data/mock/settings.json`.
- Helper `lunar_date.dart` (âm lịch Việt Nam, can chi) + test; nhãn tuổi theo
  bảng 7.3 (ngày tuổi / tuần / 3–23 tháng / ≥ 2 tuổi).
- Story v2: Haru sinh 08/04/2025 (17 tháng 29 ngày, ảnh tháng 1–17, chương 18),
  lần đầu “Bước đi đầu tiên”/“Gọi “Mẹ””, Thôi nôi đã ghi; seed `active` = gói
  Family có người thân, seed mới `trial` cho biến thể dùng thử; MEM-20 chip
  “Năm thứ hai”; CARE gợi ý “· 17 THÁNG”.
- Kiểm chứng: `make runner`, `make check` (348 test pass).


## 2026-10-11 — Đợt 2: 33 màn mới + câu chuyện v2

**Đã làm**
- Vẽ 33 màn mới trên Pencil (mục 13–18): MEM-03/03a/08/10/11/13/14/15/16,
  REC-02, CARE-07/08/10/12, CAL-02, US-06/07/15, CHD-01..04, FAM-04/07,
  SET-02/03/04/07/08/09/09b/09c/11/12 — và code đủ vào app, nối các lối vào
  (không còn "Sắp ra mắt" ngoại trừ AI hỗ trợ, Cầu nối, Tuần của hai ta…).
- Câu chuyện v2 (`scratchpad/story_v2.md`) áp dụng cho thiết kế + dữ liệu:
  Haru sinh 08/04/2025 (17 tháng 29 ngày, mai tròn 18 tháng), góc nhìn Mama ở
  mọi màn, seed `active` = gói Family có Bà nội/Bà ngoại/Ông ngoại; thêm seed
  `trial`.
- Dải tuần CARE-01 dùng tuần thật T2–CN (07/10/2026 là Thứ Tư) — sửa cả Pencil.
- AppButton có tham số `color` (nút xoá tài khoản màu đỏ).

**Kiểm chứng**: analyze sạch, 508 test pass; build simulator, kiểm tra Trang
chủ, Chăm con, Lịch.

**Còn mở**: font viết tay Dancing Script (MEM-14) chưa đóng gói (cần thêm
font vào pubspec); AppTopBar/AppChoiceCard lệch nhẹ ở SET-09; ghi chú sự
kiện (CAL-02) chưa lưu được (model chưa có trường note); 3 sự kiện lịch mẫu
do agent tự đặt tên (06/10, 09/10, 11/10).

## 2026-10-11 — BF-20261011-006: Role chung và lịch sử dự án

- Yêu cầu: Bộ role chuyên môn và quy tắc ghi từng câu hỏi, phân tích, kết quả,
  ngày làm vào hai file lịch sử chung của repository.
- Phân tích/role: PM/BA/ARCHITECT xây catalog; ORCHESTRATOR/TECH_WRITER tổng hợp;
  TESTER/QUALITY review độc lập. Giữ nguyên kiến trúc và 11 skills Flutter.
- Đã làm: Bổ sung mục Project roles and mandatory history trong `AGENTS.md`
  của app, tham chiếu skill `../.agents/skills/baby-family-team/SKILL.md`,
  `../SESSIONS.md` và `../PRODUCT_ANALYTICS_HISTORY.md`. `DEV_FLUTTER` tương ứng
  `MOBILE`, `QUALITY_GATE` tương ứng `QUALITY`. SESSION local tiếp tục được ghi.
- Kiểm chứng: Task chỉ sửa hướng dẫn/lịch sử; review link, routing và quy tắc
  bảo toàn lịch sử. Không chạy lại Flutter runtime/analyze/test cho thay đổi
  Markdown; kết quả validation cuối lưu tại session chung BF-20261011-006.
- Liên quan BF-20261011-007: Thêm root `.gitignore` cho local env/build/cache;
  giữ source, file generated Flutter được quản lý và các file lịch sử.

## 2026-10-12 — Dọn việc còn lại sau đợt 2 (cleanup & đồng bộ story v2)

- Font Dancing Script (OFL, google/fonts) đóng gói: `assets/fonts/DancingScript-Variable.ttf`
  + `DancingScript-OFL.txt`, family `DancingScript` trong pubspec; token
  `AppTypography.handwriting` (24/700) / `handwritingSmall` (20/400) dùng ở MEM-14
  (giấy thư, phong bì) thay Nunito nghiêng; `design_qa.dart` nạp font. Golden khớp `Q4HQel`.
- CAL-02: `CalendarEvent.note` (freezed/json), lưu từ form; bản nháp mẫu có ghi chú
  trong `care.json` (bỏ key l10n `calendarDraftNote`). CARE-07 không hiện ghi chú (frame không vẽ).
- CARE-01: nút ⋯ 40 cạnh nút lịch → sheet dùng chung `lib/utils/widget/care_more_sheet.dart`
  (Lịch sử nhiệm vụ / Huy hiệu / Cài đặt nhiệm vụ), CARE-09 dùng chung sheet này;
  tiêu đề không còn khoảng cách cố định để vừa 390 dp (như Pencil). Pencil: thêm ⋯ vào
  jhh4V, J0I7c, qkr1a, b75gi7, AJPzj.
- Kit: `AppTopBar(currentStepOnly:)` (SET-09: chỉ bước hiện tại dài; onboarding giữ
  mặc định), `AppChoiceCard(titleFontSize, selectedBorderColor, selectedBorderWidth)` (SET-09b `sA3Ch`).
- Dữ liệu/thiết kế: CHD-01 lấy số ký ức/cột mốc từ stats (186 · 6, Pencil sửa theo);
  HOME-03 Pencil “4 tên dự định”; MEM-25 Pencil “4/4” (dữ liệu 4 story, story 20:05 là
  cuối); INV-01 Bà nội theo dõi Hana + Haru (fixture + Pencil BSCuD), bỏ bé lưu trữ khỏi
  “không thấy”; ONB-07 lời mời đầu tiên của phiên dùng mã K7Q29MXA; seed trial/pregnant
  hết hạn hôm nay + 90 ngày = 05/01/2027 (Pencil XwXfH, OUXZg, zKXgc; SUB-07 aZ9MZ
  06/10/2027); ảnh Haru (toddler) mới cho Pencil (42 node) và `demo_haru.jpg`.
- Kiểm chứng: `make runner`, `make check` (509 test pass), build iOS simulator staging (active).
- Còn mở: ảnh stock Haru trông khoảng 2–3 tuổi (hơi lớn so với 18 tháng); golden CHD-01
  chưa hiện ảnh avatar/cover (có từ trước).

## 2026-10-15 — BF-20261012-001 / BF-20261012-002 / BF-20261015-002: Đợt 3 UI + trial 7 ngày

- Đợt 3 (BF-20261012-001): 41 frame Pencil mới; app có 26 route mới + shell người thân
  `/circle` (home/child/post/me). Màn: Cầu nối US-08…12b, US-13 hỗ trợ an toàn, US-14,
  REC-01/03, CARE-11, SUB-02…06, INV-02/03/04, FAM-02/05/08, SET-05/13, MEM-17/18/19,
  RPT-01/02, CHD-05, CIR-02…06, SET-10. Widget dùng chung mới trong `lib/utils/widget`:
  `report_sheet`, `block_dialog`, `app_dialog_card`, `app_check_mark`, `memory_thumb`,
  `circle_big_action`, `plan_confirm_sheet`, `plan_limit_sheet`, `plan_status_banner`,
  `switch_family_sheet`; helper `input_decoration.dart`, `external_launcher.dart`.
  Đã xoá `app_skeleton_screen.dart` (không còn màn nào dùng).
- Việc tồn đợt 2 (BF-20261012-002): ghi ở mục 2026-10-12 bên trên.
- Trial 7 ngày (BF-20261015-002): `catalog.json` `trialPolicy` → `IFamilyService.trialDuration()`;
  `kValueDefaultTrialDuration` chỉ là dự phòng; mock hết hạn 14/10/2026 “Còn 7 ngày”.
- Token mới `kColorError50FBE4E4` đã ghi vào đặc tả mục 10.2 (`error-50`). Đổi tên widget
  private trùng tên: `_CircleChildHeader`, `_CircleFirstCard`, `_HomeChapterCard`.
- Kiểm chứng: `make check` 679/679; build iOS simulator staging (active) thành công; mở app
  kiểm tra Trang chủ, Papa & Mama, Cầu nối.
- Còn mở: quyền ảnh Bà ngoại cho Hana (CIR-04, fixture `pp-meo`); báo cáo nội dung AI
  (`ReportTarget`); câu “Đến hết ngày” ở ONB-ACT; lối vào MEM-19 trên FAM-01/NOTI-01;
  `PlanInfo` chưa có trường phiên bản policy; có thể thay các `InputDecoration` bỏ viền lặp
  lại bằng `bareInputDecoration`.

## 2026-10-16 — BF-20261015-012 / BF-20261016-001: Đăng nhập/onboarding nối API thật

- Chế độ server: chạy với `--dart-define=BABY_FAMILY_API_URL=<base>/api` (`make local-run`,
  mặc định `http://localhost:3000/api`; emulator Android `http://10.0.2.2:3000/api`). Không
  có define → giữ nguyên bản mock như trước.
- `SessionRemoteServiceImp` (`data/service_imp/session_remote.dart`) gọi server cho OTP
  (AUTH-02/03), hồ sơ + đồng ý TERMS/PRIVACY (AUTH-04), vai trò (ONB-03), tạo/huỷ gia đình
  (ONB-06/ONB-WAIT), lời mời bạn đời (ONB-07, mã chỉ trả một lần → lưu mã hoá trên máy),
  xem/nhận/từ chối lời mời (INV-01/04/05), xác nhận lần cuối và kích hoạt + dùng thử 7 ngày.
  Trạng thái server được phản chiếu vào `SessionServiceImp` (mock) để các màn chưa có API vẫn
  chạy theo đúng giai đoạn; các màn đó vẫn dùng dữ liệu cục bộ.
- Model mới `data/model/session/*` (me_profile, family_bootstrap, partner_invite_*, invite_*,
  otp_dispatch…), repository `IOnboardingRepository`, `IAuthRepository` mở rộng, endpoint ở
  `Api`, Retrofit trong `AppClient`, envelope trong `BaseRespond`.
- ONB-WAIT: poll 30 giây (`kValuePartnerStatusPollInterval`), hộp thoại “{callName} muốn tham
  gia nhà mình” (Đồng ý/Không phải); nút mô phỏng chỉ còn ở bản mock. ONB-07: tắt “xác nhận
  lần cuối” trước khi gửi → tạo lời mời mới. INV-01: chờ xác nhận → INV-04 tại chỗ.
- Lỗi server: `runWithErrorSnackBar` + `actionErrorMessage` (rẽ nhánh `error.code` → l10n;
  backend chưa dịch message). 11 key l10n mới đủ vi/en/ja/zh.
- Đồng hồ: chế độ server dùng giờ hệ thống (`AppClock.system()`).
- Kiểm chứng: `make runner`, `make check` (679 test cũ) + `test/data/session_remote_test.dart`
  (6 test); build iOS simulator; chạy thật trên simulator với backend Docker: OTP qua Mailpit →
  AUTH-04 → ONB-03 → ONB-06 → ONB-07 (mã thật) → ONB-WAIT → Parent B nhận qua API → hộp thoại
  xác nhận → ONB-ACT “dùng thử đến hết 23/10/2026”; mở lại app khôi phục đúng trạng thái.
- Còn mở: Apple/Google (báo chưa hỗ trợ); tạo bé/thai kỳ ONB-04/05 vẫn ghi mock (API có sẵn,
  chưa nối); hết hạn/EXPIRED chưa phản chiếu vào mock; mất mạng khi mở app → về Welcome (mirror
  là bộ nhớ tạm); người thân (CIRCLE) chưa có lời mời phía server; avatar AUTH-04 chưa upload.

## 2026-10-16 — BF-20261016-002: Bé/Thai kỳ và Ký ức có ảnh nối API thật

- Chỉ khi chạy với `BABY_FAMILY_API_URL` (`make local-run`); bản mock giữ nguyên.
- Bé/thai kỳ: `ChildRemoteServiceImp` (`data/service_imp/child_remote.dart`) — ONB-05a/b,
  CHD/PREG “Thêm con/thai kỳ”, sửa hồ sơ gọi `POST/PATCH /v1/families/{fid}/children|pregnancies`
  qua `ISubjectRepository`, thành công mới ghi vào kho trên máy với id của server (màu server
  1…8 ↔ chỉ số 0… của `kChildPalette`). `bootstrap.subjects` là nguồn sự thật khi mở app
  (`SessionRemoteServiceImp._mirrorSubjects`: thêm bản thiếu, cập nhật bản đổi). Lưu
  trữ/xoá/sắp xếp bé chưa có API → vẫn chỉ trên máy. ONB-05a/b báo lỗi server bằng snackbar,
  không điều hướng tiếp.
- Ký ức: `MemoryRemoteServiceImp` (`data/service_imp/memory_remote.dart`) — MEM-05 loại Ảnh,
  Nhật ký, Kỷ vật, Câu nói: tải từng ảnh (`IMediaRepository`: upload-intent → PUT presigned URL
  qua `StorageDio` → complete; trùng SHA-256 thì dùng lại) rồi `POST /v1/memories`
  (`IMemoryFeedRepository`, `Idempotency-Key`). Ảnh hiển thị ngay từ file vừa chọn; feed của
  server (`GET /v1/families/{fid}/feed`) được đồng bộ vào kho trên máy tối đa mỗi 10 giây, URL
  đã ký (`m1080`) thay file khi server xử lý xong, ký lại trước khi hết hạn 5 phút. Loại
  khác (ghi âm, thư, cột mốc, ảnh tháng) vẫn chỉ lưu trên máy.
- MEM-04: chế độ server dùng photo picker hệ thống (`image_picker.pickMultiImage`, cạnh dài
  2048, JPEG 88 — `kValueUploadImage*`); bản mock giữ luồng mẫu SUB-05. Lỗi lưu hiện snackbar.
- Hiển thị ảnh: helper `utils/helper/media_image.dart` (`mediaImageProvider`: URL ký → cache
  theo đường dẫn không chữ ký, file trên máy, asset mẫu); các widget ảnh ký ức/bé chuyển từ
  `Image.asset` sang `Image(image: mediaImageProvider(...))`.
- Model mới: `session/bootstrap_subject`, `child/child_record`, `pregnancy/pregnancy_record`,
  `memory/{memory_record, media_asset_record, upload_intent, upload_instruction, upload_status}`.
- Nháp mẫu của catalog (MEM-05 điền sẵn ảnh/chú thích theo thiết kế) tắt ở chế độ server.
- Sau review Codex: giữ Idempotency-Key khi bấm Lưu lại sau lỗi; bỏ kết quả feed nếu phiên đổi.
- Test: `test/data/subject_memory_remote_test.dart` (6), `session_remote_test.dart` thêm 1;
  `make check` 694 pass. Chạy thật iPhone Air simulator: tạo bé May → đăng ký ức có ảnh →
  ảnh hiện ở “Mới trong nhà”, khởi động lại vẫn hiện (URL ký của server).
- Còn mở: xoá ký ức/bé phía server chưa phản chiếu; chỉ đồng bộ trang feed đầu (50); ký ức
  `PROCESSING` không tự làm mới khi đứng yên màn hình; video/ghi âm chưa tải lên; chỉ upload đơn
  (≤ 20 MiB); “Tuần này” (HOME-01) và câu “Hồ sơ của … giữ nguyên” (Thêm bé) còn lấy dữ liệu mẫu.

## 2026-10-17 — BF-20261017-001: Feed ký ức đồng bộ đủ trang, gỡ bản đã xoá, tự làm mới

- `MemoryRemoteServiceImp`: trang đầu tối đa mỗi 10 giây; đủ mọi trang theo `nextCursor`
  (tối đa `kValueRemoteFeedMaxPages`, dừng nếu cursor lặp) mỗi `kValueRemoteFeedFullSyncInterval`
  (2 phút) hoặc khi URL ký sắp hết hạn. Chỉ khi tải đủ trang mới đối soát: bản có `remoteStatus`
  không còn trên server bị gỡ (`IMemoryRepository.removeMemory`); ký ức chỉ có trên máy và ký ức
  vừa tạo trong lúc đồng bộ được giữ. Mốc thời gian dùng `AppClock` (tiêm được trong test).
- `IMemoryService.refreshDelay()` (bản mock trả null) + `memoriesProvider` hẹn `Timer` đọc lại,
  huỷ khi provider dispose/đọc lại: còn ký ức PROCESSING (tối đa `kValueRemoteProcessingPollWindow`
  = 10 phút) → 10 giây; không còn → chờ tới lúc URL ký sớm hết hạn nhất cần ký lại; không có gì
  → dừng.
- Test: `test/data/subject_memory_remote_test.dart` +5 (11 tổng); `make check` 699 pass.
- Backend cùng mã: dedup ảnh theo người tải + dùng lại bản bạn đời đã thấy, đọc ký ức khi gói
  hết hạn, quota `memoryCount` — xem root `SESSIONS.md`.
- Còn mở: chưa chạy lại trên simulator (DB dev cần migration `20261017090000_asset_dedup_per_uploader`
  và build lại api/worker); quét đủ trang mỗi 2 phút tốn request khi số ký ức lớn (cân nhắc
  tombstone/delta sync).

## 2026-10-18 — BF-20261018-001: Thùng rác ký ức qua server + checklist tính năng

- Checklist toàn dự án: `../docs/03_CHECKLIST_TINH_NANG.md` (tick khi BE + App + kiểm chứng xong).
- `MemoryRemoteServiceImp`: MEM-07 “Xoá” ký ức của server → `DELETE /v1/memories/{id}` rồi gỡ khỏi kho
  trên máy; MEM-17 `trash()` = thùng rác server (mọi trang, `trashedBy` đổi về id trên máy) + ký ức chỉ có
  trên máy; `restoreMemory` → `POST …/restore` và phản chiếu lại; `deleteForever` → `DELETE …/purge`.
  Ký ức chỉ có trên máy giữ luồng cũ. `MemoryRecord` thêm `trashedAt/trashedBy/purgeAfter`; endpoint
  `Api.familyTrash/memoryRestore/memoryPurge`; Retrofit `trashMemory/getTrash/restoreMemory/purgeMemory`.
- Test: `test/data/subject_memory_remote_test.dart` +1 (12); `make check` 700 pass.
- Còn mở: MEM-09 sửa ký ức chưa có màn trong app; chưa chạy simulator.

## 2026-10-18 — BF-20261018-002: MEM-09 sửa ký ức

- Màn MEM-09 = composer MEM-05 với query `memoryId` (`MemoryComposerRoute(memoryId:)`): điền sẵn, tiêu đề
  “Sửa ký ức”; người không phải tác giả: chú thích/tiêu đề readOnly, ngày không đổi được, sheet người xem
  bỏ “Chỉ mình tôi” (`showMemoryVisibilitySheet(options:)`), có dòng giải thích. Khi sửa ẩn ô “+” ảnh,
  cột mốc, album, ghi âm; đóng không tạo nháp. Lối vào: MEM-07 ⋯ “Sửa ký ức” (`canEdit`), lưu xong đọc lại.
- `IMemoryService.updateMemory` (mock: patch kho trên máy; server: `PATCH /v1/memories/{id}` với
  `If-Match: remoteVersion`, chỉ gửi trường đổi, 412 → tải bản mới vào kho rồi báo `errorVersionConflict`).
- 6 key l10n mới (vi/en/ja/zh). Test: `subject_memory_remote_test.dart` +1, `memories_circle_batch3_test.dart` +2;
  `make check` 703 pass.
- Còn mở: đổi ảnh khi sửa; chưa chạy simulator.

## 2026-10-18 — BF-20261018-003/005: Bình luận, cảm xúc, Papa & Mama qua server

- BF-20261018-003: `MemoryRemoteServiceImp` react/comments/addComment/editComment/deleteComment qua server
  cho ký ức server (`kValueReactionTypes` emoji ↔ loại server; mỗi người 1 cảm xúc, chạm lại để bỏ — mock
  cũng theo quy tắc này); `Memory.myReaction`; model `CommentRecord`, `ReactionState`.
- BF-20261018-005: `UsRemoteServiceImp` (`data/service_imp/us_remote.dart`) cho US-01/02/03/04: check-in
  (chia sẻ mặc định mood/năng lượng/nhu cầu, ghi chú không chia sẻ), check-in hôm nay của bạn đời chỉ phần
  đã chia sẻ, lời nhờ gửi (Idempotency-Key giữ khi gửi lại) và chuyển trạng thái qua API; phản chiếu vào kho
  trên máy (cờ `remote`). `ICoupleRemoteRepository` + imp; US-03/04 hiện lỗi server theo mã (3 key l10n).
- Test: `test/data/couple_remote_test.dart` (4), `subject_memory_remote_test.dart` +2; `make check` 709 pass.
- Còn mở: câu hỏi hôm nay, cảm ơn, nhật ký riêng, Cầu nối vẫn trên máy; phản hồi nhanh check-in chưa nối;
  MEM-01/02 chưa dùng API timeline/lưới ảnh; chưa chạy simulator.

## 2026-10-18 — BF-20261018-006: MEM-01/02 dùng API timeline + lưới ảnh

- `IMemoryService.timeline({childId})` / `photos({childId})` (bản mock giữ logic trên máy). Bản server:
  `timeline` đọc `GET /v1/families/{fid}/timeline` (đủ trang, ≤ 10 giây/lần theo bé; thai kỳ → `pregnancyId`),
  phản chiếu ký ức vào kho rồi trả theo ngày xảy ra (thẻ hệ thống bỏ qua — app tự dựng chương/tròn tháng);
  `photos` đọc `GET /v1/families/{fid}/media-grid` (ảnh `t320` đã ký) + ảnh của ký ức chỉ có trên máy.
- MEM-01/02 (`memories_tab_controller.dart`) dùng hai hàm này; DTO `MemoryGridPhoto`; model
  `TimelineItemRecord`, `MediaGridItemRecord`; endpoint `Api.familyTimeline/familyMediaGrid`.
- Test: `subject_memory_remote_test.dart` +1 (16); `make check` 710 pass.
- Còn mở: bộ lọc chip vẫn lọc trên máy (server có `filter` nhưng chưa dùng); chưa chạy simulator.

## 2026-10-18 — BF-20261018-007: Nhiệm vụ CARE-01…06 qua server

- `CareRemoteServiceImp` (`data/service_imp/care_remote.dart`): bảng ngày đọc 3 tab
  `GET /v1/families/{fid}/missions/board?tab=MINE|PARTNER|TOGETHER` (server tự bày, chia đều), nhiệm vụ của bạn
  đời không có Hearts; thư viện `GET /v1/missions/templates`; tự thêm `POST /v1/missions` (chỉ ME/TOGETHER,
  BR-020); hoàn thành giữ `Idempotency-Key` khi thử lại; hoàn tác/đổi (`optionsToken`)/bỏ khỏi hôm nay qua API.
  Loại nhiệm vụ server ánh xạ về `MissionCategory` của app. Sau mỗi thao tác server, `ICareRepository.touch()`
  báo các màn đọc lại (`mockRevisionProvider`).
- Model `care/mission_record`, `mission_board_record`, `mission_template_record`, `mission_template_list`,
  `mission_result_record`, `mission_swap_options_record`; `ICareRemoteRepository` + imp; endpoint `Api.mission*`.
- Test `test/data/care_remote_test.dart` (3); `make check` 713 pass.
- Còn mở: Hearts/cây gia đình/huy hiệu/lịch sử/lịch/cài đặt và “lưu khoảnh khắc” vẫn trên máy; 💛 cảm ơn trên
  việc bạn đời chờ API cảm ơn; chưa chạy simulator.

## 2026-10-18 — BF-20261018-009: Cảm ơn US-05/06 + Nhật ký riêng US-07 qua server

- `UsRemoteServiceImp`: `sendThanks` → `POST /v1/families/{fid}/us/appreciations` (gắn nhiệm vụ/ký ức qua
  `linkedType/linkedId`); `thanks()`/`thanksWall()` đồng bộ bức tường hai chiều (đủ trang, ≤ 10 giây/lần) rồi đọc kho;
  `toggleThanksHeart` → người nhận thả ❤️ (`…/react`; server chưa có bỏ tim). Nhật ký riêng: `journal()` đồng bộ
  trang của chính mình; `addJournalEntry` → `POST …/us/journal` (cảm xúc app ↔ mood server); `shareJournalExcerpt`
  gửi đúng nội dung trang (`…/share {excerpt}`). Ảnh trang nhật ký chưa tải lên server (chỉ giữ trên máy).
- `CareRemoteServiceImp.thankPartner`: 💛 trên việc bạn đời đã xong → lời cảm ơn nhanh (`quick: true`, gắn nhiệm vụ);
  giữ cờ đã cảm ơn trong phiên vì board server chưa trả cờ này.
- Model `us/appreciation_record`, `appreciation_wall`, `journal_entry_record`, `journal_list`; Retrofit 6 hàm.
- Test: `couple_remote_test.dart` +2 (6), `care_remote_test.dart` +1 (4); `make check` 716 pass.
- Còn mở: ảnh nhật ký (upload JOURNAL), bỏ tim, đăng lời cảm ơn thành khoảnh khắc gia đình trên app; chưa chạy simulator.

## 2026-10-18 — BF-20261018-011: Hộp thông báo NOTI-01 qua server

- `NotificationRemoteServiceImp` (`data/service_imp/notification_remote.dart`): đọc `GET /v1/notifications` (≤ 10 trang),
  dựng câu theo `templateCode` + `params` bằng l10n (12 key `noti*`, mẫu lạ → `notiGeneric`), route từ `deepLink`
  (`babyfamily://memories/{id}` → `/memory/{id}`) hoặc `entityId` (lời nhờ → `/us/request/{id}`); số chưa đọc
  `GET …/unread-count`; đánh dấu đã đọc `POST …/read` rồi `INotificationRepository.touch()`.
- Model `notification/notification_record`, `notification_page`, `notification_count`; test
  `test/data/notification_remote_test.dart` (2); `make check` 718 pass.
- Còn mở: push/quyền thông báo (ONB-10); chưa chạy simulator.

## 2026-10-18 — BF-20261018-012: Hearts / Cây gia đình / Huy hiệu / Lịch sử nhiệm vụ qua server

- `CareRemoteServiceImp`: `myHearts` → `GET /v1/families/{fid}/hearts/me` (chỉ của tôi, BR-018; dòng không có tiêu đề
  dùng l10n `heartsReason*`); `tree` → `…/family-tree` (cấp + %, số liệu tuần chưa có API để 0); `badges` → `…/badges`
  (tên theo ngôn ngữ app); `missionHistory` → `…/missions?owner=ME|PARTNER|TOGETHER` 30 ngày, nhóm theo ngày, việc của
  bạn đời không Hearts.
- Model `care/heart_history_record`, `hearts_me_record`, `family_tree_record`, `family_tree_today_record`,
  `badge_record`, `badge_progress_record`, `badge_list`, `mission_history_page`; Retrofit 4 hàm; 3 key l10n.
- Test `care_remote_test.dart` +1 (5); `make check` 719 pass. Chưa chạy simulator.

## 2026-10-18 — BF-20261018-013: Xoá tài khoản + Xuất dữ liệu + Lịch CARE-07/CAL-02 qua server

- `SettingsRemoteServiceImp` (`data/service_imp/settings_remote.dart`, repo `account_remote`): xuất dữ liệu `POST /v1/exports`
  (PERSONAL/FAMILY), nhớ `exportId` trong mục `dataExport`, `GET /v1/exports/{id}` làm mới trạng thái và lấy link tải mới
  (mở bằng `launchExternalUrl`); xoá tài khoản: `POST /v1/auth/reauth/otp` → nhập 6 số → `POST …/verify` (mã chỉ trong bộ
  nhớ) → `POST /v1/me/deletion` (lựa chọn gia đình theo `deletion-preview`) → `ISessionService.signOut()`.
- Màn SET-09c: ô nhập OTP sau khi gửi mã; nút Apple chỉ hiện khi có tài khoản Apple; “Xoá tài khoản” chỉ bật khi đã xác
  thực + đã tích xác nhận. SET-08: lỗi server qua snack bar.
- `CareRemoteServiceImp.calendarEvents/createEvent`: `GET /v1/families/{fid}/calendar` (sự kiện, nhiệm vụ — bạn đời không
  Hearts — sinh nhật/tròn tháng), `POST /v1/events` (loại ↔ `CHILD/FAMILY/COUPLE/MEMORY_REMINDER/NOTE`, âm lịch, mã nhắc ↔
  số phút, nhắc cho chính tôi, sự kiện riêng tư không mời Circle). Thông báo `NOTI_EVENT_REMINDER` → `/calendar`.
- Model `account/*` (4), `care/calendar_record`, `calendar_event_record`, `calendar_special_day_record`,
  `event_reminder_rule_record`; 10 key l10n; mã lỗi `REAUTH_*`, `EXPORT_*`, `EVENT_*_INVALID`.
- Test mới `settings_remote_test.dart` (2), `care_remote_test.dart` +1, `notification_remote_test.dart` mở rộng, widget
  SET-09 cập nhật; `make check` 722 pass. Chưa chạy simulator; chưa chọn người tham gia/nhắc cho bạn đời trên server.

## 2026-10-18 — BF-20261018-014: Bật thông báo ONB-10 (push token) + nhắc bạn đời trên lịch

- `IPushService` (`data/service/push.dart`): mock `PushServiceImp` chỉ xin quyền; `PushRemoteServiceImp` xin quyền FCM, gửi
  `POST /v1/me/devices {platform, locale, pushToken, pushEnabled}`, theo dõi `onTokenRefresh`, từ chối → xoá token trên
  server; `RootApp` gọi `syncIfAuthorized()` khi mở app. FCM tách sau `IPushTokenRepository` (`repository_imp/push_token.dart`).
- Lịch: `SessionRemoteServiceImp` lưu id server của bạn đời từ `bootstrap.parents` (`kValueSessionKeyServerPartnerUserId`);
  `CareRemoteServiceImp.createEvent` gửi `participants` + quy tắc nhắc cho từng người tham gia; đọc lại người tham gia và
  chỉ hiện mã nhắc của chính tôi. Thông báo `NOTI_BADGE_EARNED` → `/care/badges`.
- Test mới `push_remote_test.dart` (3), `care_remote_test.dart` +1, `session_remote_test.dart` (id bạn đời),
  `notification_remote_test.dart` mở rộng; `make check` 726 pass. Chưa thử push thật trên thiết bị/simulator.

## 2026-10-18 — BF-20261018-015: Phiên/thiết bị, cài đặt gia đình ONB-08/FAM-07, INV-02/03, FAM-02, PARTNER_LEFT

- `SettingsRemoteServiceImp`: thiết bị SET-07 = `GET /v1/me/sessions` (tên máy hoặc nền tảng, phiên hiện tại), đăng xuất
  một máy `DELETE …/{id}`, mọi máy khác `POST …/revoke-others`; Face ID/PIN vẫn trên máy.
- `FamilyRemoteServiceImp` (mới, repo `family_remote`): cài đặt quyền riêng tư `GET/PATCH /v1/families/{fid}/settings`
  (chỉ gửi khoá đổi; `family/parents/onlyMe` ↔ `FAMILY/PARENTS/PRIVATE`), tên gia đình `PATCH /v1/families/{fid}`.
- Phiên server: gia đình `PARTNER_LEFT` → `applyServerPartnerLeft()` (US-00); `revokePartnerInvite()` cấp mã mới để server
  thu hồi mã cũ (FAM-02). INV: lỗi `INVITE_EXPIRED/ALREADY_USED` khi nhận → INV-02, `ALREADY_PARENT_OF_ANOTHER_FAMILY` → INV-03.
- Test mới `family_remote_test.dart` (2), `invite_preview_accept_test.dart` (3), `settings_remote_test.dart` +1,
  `session_remote_test.dart` +1; `make check` 733 pass. Chưa có màn đổi số điện thoại; avatar AUTH-04 chờ backend.

## 2026-10-19 — BF-20261019-001: Thai kỳ PREG-01…06 + hồ sơ bé CHD-01/03/05 qua server

- `PregnancyRemoteServiceImp` (repo `pregnancy_remote`): chuẩn bị đón bé `GET/POST /v1/pregnancies/{id}/prep-items`,
  `PATCH /v1/prep-items/{id}` (phản chiếu id server; người phụ trách/“Đã nhờ” còn trên máy; nhóm ↔ `HOSPITAL_BAG/PAPERS/
  NURSERY/HEALTH`); chào đời `POST …/birth` (Idempotency-Key giữ khi thử lại, thêm bé id server, ẩn thai kỳ, chuyển ký
  ức); lưu trữ `POST …/archive` (“chỉ Papa & Mama” → `ENDED_PRIVATE`).
- `ChildRemoteServiceImp`: số đếm hồ sơ `GET /v1/children/{id}/profile-stats`; lưu trữ/khôi phục/xoá (gửi `confirmName`);
  sắp xếp `PATCH /v1/families/{fid}/children/order` (chỉ bé đang hoạt động); ảnh đại diện/ảnh bìa mới → `MediaUploader`
  (AVATAR/COVER) rồi `PUT …/avatar|cover`; kích thước thai tuần này từ `GET …/journey`.
- `MemoryRemoteServiceImp`: ký ức thai kỳ phản chiếu kèm `pregnancyWeek` (PREG-02/03).
- Test mới `pregnancy_remote_test.dart` (3), `subject_memory_remote_test.dart` +3; `make check` 739 pass. Chưa chạy simulator;
  máy khác chưa thấy ảnh bé đã tải (bootstrap chưa trả URL ảnh).

## 2026-10-19 — BF-20261019-002: Album, yêu thích, tải bản gốc, góc nhìn, gợi ý, cột mốc, thư qua server

- `MemoryLibraryRemoteServiceImp` (lớp con của `MemoryRemoteServiceImp`, repo `memory_library_remote`): album server
  (`/v1/families/{fid}/albums`, `/v1/albums/{id}…`; album tự động vẫn trên máy; đổi bìa = ký ức chứa ảnh), yêu thích
  `PUT/DELETE /v1/memories/{id}/favorite` + đồng bộ yêu thích khi mở Bộ sưu tập, `downloadUrls` (`POST …/download-urls`),
  góc nhìn `GET …/perspectives` / `PUT …/perspective`, gợi ý `GET /v1/families/{fid}/memory-prompts` + bỏ qua, cột mốc
  (catalog/nhóm của app, trạng thái đã ghi từ `/v1/milestone-templates`, ghi = tạo ký ức `MILESTONE`), số thư niêm phong.
- `MemoryRemoteServiceImp.create`: thêm `MILESTONE` (`milestone{templateCode|customTitle, occurredOn}`) và `LETTER`
  (`letter{childId, releaseRule: DATE, unlockAt, releaseVisibility}`). `IMemoryRepository.touch()`.
- MEM-08: nút “Tải về” mở bản gốc của ảnh đang xem (`launchExternalUrl`).
- Test mới `memory_library_remote_test.dart` (4); `make check` 743 pass. Chưa nối nháp server và sửa ảnh (màn sửa chưa có
  chọn ảnh); chưa chạy simulator.

## 2026-10-19 — BF-20261019-003: Bình luận theo ký ức, lọc bảng tin theo bé, CARE-06/CARE-12, nhiệm vụ lặp lại

- MEM-07/09: `Memory.commentsEnabled`; màn sửa (tác giả) có `AppToggleRow` “Cho phép bình luận”; chi tiết ẩn ô bình luận
  khi tắt; `updateMemory(commentsEnabled:)` chỉ gửi khi đổi. Lọc bảng tin theo bé/thai kỳ đọc thêm
  `GET /v1/families/{fid}/feed?childId|pregnancyId` (giới hạn theo `kValueRemoteFeedRefreshInterval`).
- `CareRemoteServiceImp`: CARE-06 `saveMoment` → tải ảnh (`MediaUploader`, MEMORY) + `POST /v1/missions/{id}/moment`
  (Idempotency-Key); CARE-12 đọc/lưu `/v1/families/{fid}/mission-settings` (mức bảng) + `/mission-preferences`
  (danh mục tắt, giờ bảng, hỏi lúc tối, nhắc mặc định); việc tự gõ có “Lặp lại” → `POST …/mission-series`
  (`repeatDays` 1…7 → MO…SU; ngày thường/cuối tuần/hằng ngày).
- Test: `care_remote_test.dart` +3, `subject_memory_remote_test.dart` +2; `make check` 748 pass. Chưa có màn tạm dừng/dừng
  chuỗi lặp; chưa chạy simulator.

## 2026-10-19 — BF-20261019-004: Family Circle phía Papa/Mama, duyệt ảnh người thân, US-15, ảnh nhật ký riêng

- `FamilyRemoteServiceImp` (thêm `childRepository`): người thân/lời mời mirror từ `GET /v1/families/{fid}/circle` và
  `/invites/circle`; tạo lời mời (quan hệ/quyền app ↔ server), thu hồi/gia hạn, sửa quyền theo bé, cho tải, tạm dừng/tiếp tục,
  gỡ người thân qua `/circle-members/*`.
- `MemoryLibraryRemoteServiceImp`: MEM-19 `pendingPosts`/`approvePost`/`rejectPost` qua `pending-review`, approve/reject.
- `UsRemoteServiceImp`: ảnh nhật ký tải bằng `MediaUploader` (purpose JOURNAL) và gửi `assetIds`; `sendThanks(proposeFamilyMoment:)`
  gọi share-request; US-15 đọc/lưu `/v1/me/us-settings` (chỉ gửi trường đổi; giờ yên tĩnh còn local).
- Test: family_remote +2, couple_remote +2, memory_library_remote +1; `make check` 753 pass. Chưa có app người thân (CIR-*),
  màn duyệt đăng lời cảm ơn; chưa chạy simulator.

## 2026-10-19 — BF-20261019-005: App người thân qua server (CIR-WAIT, CIR-01…06, CIR-05, rời gia đình), duyệt đăng lời cảm ơn

- `SessionRemoteServiceImp`: xem trước lời mời CIRCLE (bé được cấp quyền, quan hệ); sau đăng nhập/nhận lời mời đọc
  `GET /v1/me/circles` → `SessionServiceImp.applyServerCircle` (gia đình + thành viên người thân trên máy, quyền theo bé,
  tạm dừng) và mirror bé; không còn gia đình → CIR-WAIT.
- `CircleRemoteServiceImp` (provider chọn theo `kValueUseRemoteSession`): bảng tin qua memory service bản server (ẩn
  `PENDING_REVIEW`), lời chúc/thả tim/đăng ảnh (MEMORY) qua API ký ức, rời gia đình `POST …/circle/leave`; tư cách người thân
  đọc lại tối đa mỗi `kValueRemoteFeedRefreshInterval`. Trang chủ người thân chuyển màn theo phiên khi bị tạm dừng/gỡ.
- Bức tường cảm ơn: `Thanks.shareRequested`; người nhận “Đăng cho cả nhà / Để riêng hai mình” → `share-respond`; l10n 4 ngôn ngữ.
- `FamilyRemoteServiceImp.members` không gọi `/circle` khi là người thân; `appRelation`/`appPermission` dùng chung.
- Test: session_remote +2, couple_remote +1; `make check` 756 pass. Chưa chạy simulator; CIR-06 tuỳ chọn còn trên máy.

## 2026-10-19 — BF-20261019-006: Gói dịch vụ từ server, hồ sơ PATCH /me, cài đặt thông báo/AI, nháp trên tài khoản, tìm kiếm, báo cáo/chặn

- `FamilyRemoteServiceImp`: `planOffers` theo `GET /v1/billing/plans` (quota/feature; giá Store từ catalog trên máy), `currentFamily`/`planDetails`
  phản chiếu `GET /v1/families/{fid}/billing` (gói, hạn, dung lượng, số người thân, ân hạn) vào gói trên máy (≤ mỗi 10 giây).
- `SettingsRemoteServiceImp`: SET-02 tên → `PATCH /v1/me`; SET-03 `/v1/me/notification-settings` (memories/requests/couple/thanks/promotions ↔
  MEMORIES/REQUESTS/US/APPRECIATION/PROMOTIONS; tắt giờ yên tĩnh = start = end); SET-05 `/v1/me/ai-settings`; RPT-02 `/v1/blocks`, `/v1/me/blocks` theo userId.
- `MemoryRemoteServiceImp`: MEM-18 nháp trên tài khoản (`/v1/me/drafts`, xoá = thùng rác + xoá hẳn); MEM-15 `/search` (≥ 2 ký tự), MEM-16
  `/on-this-day`; RPT-01 `POST /v1/reports` (`submitReport(target:)` mới). Chi tiết người thân: chặn rồi gỡ qua Family service.
- Test: family_remote +2, settings_remote +4, subject_memory_remote +3; `make check` 765 pass. Chưa chạy simulator; tiếp tục soạn nháp tài khoản chưa có.

## 2026-10-19 — BF-20261019-007: Video + multipart, đổi ảnh khi sửa, chi tiết từ server, recap tuần, “Tuần này”, avatar hồ sơ, ảnh bé qua bootstrap

- Media: `IMediaRepository.mediaDurationMs` (video_player), `uploadBytes` trả ETag từng part khi multipart, `completeUpload(parts:)`; `MediaUploader.upload`
  nhận ảnh/video (`kind`, `mime`, `durationMs`, bytes đọc sẵn). MEM-04 bản server dùng `pickMultipleMedia`; video quá giới hạn gói → SUB-05.
- MEM-09: tác giả thêm/bớt ảnh, chạm ảnh để đặt bìa, nút ✕ trên ô ảnh; `updateMemory(mediaAssets:)` → `addAssetIds/removeAssetIds/coverAssetId`
  (mirror lưu `mediaAssetIds`). MEM-07: `refreshMemory` cho chi tiết/xem ảnh/bình luận (≤ mỗi 10 giây/ký ức, 404 → gỡ).
- REC-02 `/recaps/weekly/latest` (tiêu đề `recapWeekHeadline`), HOME-01 `/home/week-stats`; AUTH-04 chọn ảnh ở SET-02 → `/me/avatar/*` + `PATCH /me`;
  ảnh bé (`avatarUrl/coverUrl`) và avatar của tôi mirror khi đồng bộ phiên.
- Test: subject_memory_remote +4, memory_library_remote +1, settings_remote +1, session_remote +1; 2 widget test cập nhật; `make check` 770 pass. Chưa có MEM-06.

## 2026-10-19 — BF-20261019-008: Tải nền MEM-06, SW-01, đồng bộ hiển thị, quyền riêng tư, xoá gia đình, ảnh tháng

- MEM-06: `IMemoryService.create(deferUpload:)` (màn soạn bật) → ký ức tạm `uploadDone/uploadTotal/uploadFailed`, hàng đợi tải lần lượt,
  `retryUpload`/`cancelUpload`; thẻ `UploadingMemoryCard` trên dòng thời gian; ký ức tạm mất việc tải (mở lại app) → nháp trên máy.
- SW-01: bé/thai kỳ có trong bootstrap gắn `kValueChildKeyServerSubject`; không còn trong bootstrap → `archived`.
- SET-06: `IAppSettingService.currentDisplay/changeDisplay/pullServerDisplay` (LocalStore `display`, `/v1/me/settings`), splash áp khi mở app.
- SET-04: `/privacy-overview` (số đã chặn, mặc định ai xem); xoá gia đình: màn `FamilyDeletionPage` (`/family/deletion`) + service.
- MEM-20/21: `/children/{id}/monthly-photos` (GET, PUT sau khi tạo ký ức ảnh đúng ngày tròn tháng); ghi `monthIndex` vào ký ức cho thẻ chương.
- Test: settings_remote +2, session_remote (SW-01), subject_memory_remote +1, memory_library_remote +1; `make check` 774 pass. FAM-07 chưa làm.

## 2026-10-20 — BF-20261019-009: MEM-08 video, thẻ chương từ /timeline, giữ phiên khi mất mạng, MEM-25, FAM-07, lời mời sau PARTNER_LEFT

- MEM-08: mirror dùng poster cho video và lưu `Memory.mediaVideos` (URL `v1080`); `PhotoViewerController.videoAt` + `_ViewerVideo` (video_player, chạm phát/dừng, thanh tiến độ).
- Thẻ chương: `MemoryRemoteServiceImp.timeline` giữ thẻ `CHAPTER` → hàng bé `kValueChildKeyServerChapters`; `ChildServiceImp._chapter` ưu tiên số liệu/ảnh bìa server.
- Mất mạng: `MockStore.exportSnapshot/importSnapshot`, `IOfflineSnapshotRepository` (LocalStore mã hoá, hộp auth); `SessionRemoteServiceImp.restore`
  lưu sau đồng bộ thành công, nạp lại khi lỗi mạng mà kho đang trống.
- MEM-25: `stories()` từ `/children/{id}/today-story` (đã xem trên máy). FAM-07: ảnh bìa (COVER) + ngôn ngữ nội dung qua `PATCH /families`.
- Test: subject_memory_remote +3, session_remote (mở nguội lúc mất mạng), family_remote +1; `make check` 778 pass. Chưa có FAM-08, múi giờ.

## 2026-10-20 — BF-20261019-010: đổi số điện thoại, chuỗi nhiệm vụ lặp lại, gửi yêu cầu hỗ trợ

- Đổi số: `ChangePhonePage` (`/settings/phone`) xác thực lại → số mới → OTP; `ISettingsService.requestPhoneChange/confirmPhoneChange` (bản server dùng mã xác thực lại, `/v1/me/phone/otp|verify`).
- CARE-03: `ICareService.missionSeries/pauseSeries/endSeries` (`MissionSeriesInfo`, server `/families/{fid}/mission-series`, `/mission-series/{id}/pause`, `DELETE /mission-series/{id}`); mục “Chuỗi lặp lại” trong `MissionSettings` (chỉ quản lý chuỗi của tôi / Cùng nhau).
- Hỗ trợ: `SupportRequestPage` (`/settings/help/request`) từ Trợ giúp; danh mục `GET /v1/support/categories` (mặc định `kValueSupportCategories` khi chạy mock), gửi `POST /v1/support/tickets`, danh sách `GET /v1/me/support/tickets`.
- Test: care_remote +1, settings_remote +2; `make check` 781 pass. Chưa có xem/nhắn tiếp ticket, ghi âm, MEM-18.
