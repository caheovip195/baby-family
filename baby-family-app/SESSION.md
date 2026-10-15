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
