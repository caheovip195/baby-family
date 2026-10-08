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
