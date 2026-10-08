# Skill 10: Đa ngôn ngữ (l10n) — bắt buộc

## Mục tiêu

Mọi chuỗi người dùng nhìn thấy phải đi qua hệ thống l10n. App hỗ trợ **vi**
(mặc định, template) và **en**; thêm ngôn ngữ không cần sửa code màn hình.
Đặc tả: tài liệu nghiệp vụ mục 7.27, tài liệu kỹ thuật mục 22.12 và 11.8.

## Cấu trúc

- ARB: `lib/l10n/arb/app_vi.arb` (template, có `@key.description`),
  `app_en.arb`, ... — cấu hình `l10n.yaml`.
- Code sinh: `lib/generated/l10n/` (`AppLocalizations`) — không sửa tay; sinh
  bằng `make l10n` (hoặc tự sinh khi `flutter pub get`).
- Ngôn ngữ: enum `AppLanguage` (`enum_part/app_language.dart`), trạng thái
  `appLanguageProvider` (`data/provider/app_setting.dart`).

## Quy tắc

1. **Không hard-code** chuỗi hiển thị trong page/controller/widget/helper.
   Trong widget: `context.l10n.<key>`. Nơi không có `BuildContext`
   (interceptor, service tạo thông báo cục bộ): `currentL10n().<key>`.
   Ngoại lệ: log/dev message, `AppLanguage.nativeName`, nhãn mặc định
   `Papa`/`Mama` (`kValueDefaultCallName*` — không dịch), dữ liệu do người dùng
   nhập, nội dung server trả về (đã dịch theo `Accept-Language`).
2. Thêm key: thêm vào `app_vi.arb` kèm `"@key": {"description": ...}` → dịch
   ở **mọi** file ARB khác cùng lúc (test `l10n_test.dart` sẽ fail nếu thiếu).
3. Tên key: `<khuVuc><Man/ChucNang><MucDich>` camelCase, ví dụ
   `welcomeSlide1Title`, `careMissionAssignedTitle`, `errorNetwork`,
   `commonCancel`. Chuỗi dùng nhiều màn → tiền tố `common`; lỗi → `error`.
4. Có biến → placeholder có kiểu (`String`, `int`, `DateTime` + `format`).
   Không ghép chuỗi bằng `+` hay nội suy cắt câu (ngữ pháp mỗi ngôn ngữ khác).
5. Số lượng → ICU plural `{count, plural, =0{...} =1{...} other{...}}`;
   lựa chọn theo giới/vai trò → ICU `select`. Tên gọi Bố/Mẹ trong câu luôn là
   placeholder `{callName}` (nhãn người dùng chọn, mặc định Papa/Mama), không
   viết cứng “Bố”, “Mẹ”, “Dad”, “Mom” trong ARB.
6. Ngày/giờ/số/tiền: dùng `intl` với locale hiện hành
   (`DateTimeFormatExt` + `context.localeName`, `NumberFormat`). Ngày gửi API
   luôn `yyyy-MM-dd` không phụ thuộc locale.
7. Dữ liệu từ server (catalog nhiệm vụ, cột mốc, mood, thông báo) đã được dịch
   theo `Accept-Language` — không dịch lại ở client, không tự map mã → chữ.
   Mã lỗi `error.code` dùng để rẽ nhánh logic; câu hiển thị lấy `message` từ
   server hoặc chuỗi l10n của app.
8. Layout phải chịu được chuỗi dài hơn ~40% (tiếng Anh/khác thường dài hơn
   tiếng Việt): không cố định width cho text, dùng `Flexible`/`maxLines` +
   `ellipsis` có chủ đích.
9. Đổi ngôn ngữ có hiệu lực ngay (watch `appLanguageProvider`), không yêu cầu
   khởi động lại app; không lưu chuỗi đã dịch vào state lâu dài (lưu key/mã).

## Self Validation

```bash
make l10n
fvm flutter test test/utils/l10n_test.dart
# Chuỗi tiếng Việt còn hard-code (ngoài comment, ARB, generated):
grep -rnP "['\"][^'\"]*[àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđĐ][^'\"]*['\"]" lib --include=*.dart \
  | grep -v 'lib/generated/' | grep -v '//'
```

Mọi chuỗi hiển thị mới tìm thấy phải chuyển vào ARB trước khi báo hoàn thành.
