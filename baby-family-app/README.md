# Baby Family App

Ứng dụng Flutter (iOS + Android) — nhật ký em bé, cùng chăm con, gắn kết Papa & Mama.

- Tài liệu nghiệp vụ: [`../docs/01_DAC_TA_NGHIEP_VU_BABY_FAMILY_v3.md`](../docs/01_DAC_TA_NGHIEP_VU_BABY_FAMILY_v3.md)
- Tài liệu kỹ thuật: [`../docs/02_TAI_LIEU_KY_THUAT_BABY_FAMILY_v3.md`](../docs/02_TAI_LIEU_KY_THUAT_BABY_FAMILY_v3.md)
- Quy tắc code (bắt buộc): [`AGENTS.md`](AGENTS.md), [`.skills/`](.skills/index.md)

## Yêu cầu

- [fvm](https://fvm.app) — Flutter **3.44.5** (khai báo trong `.fvmrc`)
- Xcode (iOS 15+; plugin iOS qua Swift Package Manager), Android SDK (minSdk 26, targetSdk theo Flutter)

## Bắt đầu

```bash
make setup      # cài Flutter đúng version + pub get
make runner     # sinh code (freezed, json, retrofit, auto_route, flutter_gen)
make l10n       # sinh AppLocalizations từ lib/l10n/arb
make stg-run    # chạy flavor staging (lib/main_dev.dart)
make check      # format + analyze + test trước khi tạo MR
```

| Flavor | Entry | Bundle / applicationId | Tên app | API |
|---|---|---|---|---|
| staging | `lib/main_dev.dart` | `vn.babyfamily.app.staging` | SBaby Family | `https://api-staging.babyfamily.vn` |
| product | `lib/main_pro.dart` | `vn.babyfamily.app` | Baby Family | `https://api.babyfamily.vn` |

## Chạy bản mock các màn

Bản hiện tại bật dữ liệu mẫu mặc định, chạy offline với dữ liệu ở
`assets/data/demo_family.json`. Các thao tác thêm/sửa/hoàn thành giữ trong bộ nhớ
cho tới khi đóng app; ngôn ngữ được lưu qua LocalStore.

```bash
make stg-run   # seed `fresh`: Splash → Welcome, đi qua luồng đăng nhập/onboarding mẫu
make mock-run  # seed `active`: Splash → Main shell (Mama Lan, “Nhà Lan”)
```

Chọn bộ dữ liệu mẫu bằng `--dart-define=BABY_FAMILY_DEMO=fresh|active|pregnant|circle|expired`
và người đăng nhập bằng `--dart-define=BABY_FAMILY_ACTOR=mama|papa`. Luồng mock
“đi xuyên qua”: OTP/mã mời nhận mọi giá trị (mẫu: OTP **123456**, mã bạn đời
**K7Q29MXA**, mã người thân **B4N0I123**). Bảng route, seed và quy ước xem
[MOCK_SCREENS.md](MOCK_SCREENS.md).

## Cấu trúc

```
lib/
├── main_dev.dart / main_pro.dart   # khởi tạo theo flavor
├── app.dart                        # RootApp, appRouter, scaffoldMessengerKey
├── firebase_options/               # sinh bằng `flutterfire configure`
├── gen/                            # flutter_gen (assets, fonts) — generated
├── generated/l10n/                 # AppLocalizations — generated (make l10n)
├── l10n/arb/                       # app_vi.arb (template), app_en.arb...
├── data/
│   ├── dto/                        # class dữ liệu không JSON (view data, Result)
│   ├── model/                      # freezed + json (API/local)
│   ├── remote/
│   │   ├── app_client/             # Retrofit AppClient + BaseRespond
│   │   ├── dio_config/             # BaseDio, AppServiceDio
│   │   ├── interceptor/            # device, authorization, error, log
│   │   └── request_options.dart    # khoá @Extra
│   ├── repository/ + repository_imp/   # nơi duy nhất gọi AppClient
│   ├── service/ + service_imp/         # nghiệp vụ, kết hợp repository
│   └── provider/                       # Riverpod provider của service
├── page/
│   ├── application_base.dart       # BaseNotifier, BaseHookWidget
│   ├── general/                    # màn dùng chung (welcome, auth, invite...)
│   ├── parent/                     # màn của Bố/Mẹ
│   └── circle/                     # màn của người thân
└── utils/
    ├── constants/                  # colors, enum (+enum_part), server, values
    ├── extension/
    ├── helper/                     # local_store, device, flavor_config, theme...
    ├── router/                     # app_router (+ .gr.dart generated)
    └── widget/                     # widget dùng chung
```

Luồng bắt buộc: **Page → Controller → Service → Repository → AppClient/LocalStore**.

## Đa ngôn ngữ

- Hỗ trợ **Tiếng Việt** (mặc định), **English**, **简体中文** (tiếng Trung giản thể)
  và **日本語** (tiếng Nhật). Lần đầu mở app theo ngôn ngữ
  thiết bị (nếu hỗ trợ), người dùng đổi ở Welcome / Cài đặt — áp dụng ngay.
- Thêm chuỗi: sửa `lib/l10n/arb/app_vi.arb` + dịch ở mọi file ARB → `make l10n`.
- Dùng `context.l10n.xxx` trong widget, `currentL10n().xxx` ngoài widget.
- Thêm ngôn ngữ: giá trị mới trong `AppLanguage` + `app_<code>.arb` +
  `ios/Runner/Info.plist` (`CFBundleLocalizations`) +
  `android/app/src/main/res/xml/locales_config.xml` + bản dịch catalog ở server.
- Quy tắc chi tiết: [`.skills/skill_10.md`](.skills/skill_10.md).

## Việc cần làm trước khi chạy đầy đủ

1. `flutterfire configure` cho 2 flavor (push, Crashlytics). Khi chưa cấu hình,
   app vẫn chạy và bỏ qua Firebase.
2. Android release: tạo `android/keystore.properties` (không commit).
3. Icon & splash: thêm `assets/images/app_icon.png` rồi `make icon`.
