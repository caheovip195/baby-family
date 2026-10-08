# Skill 8: Design System Compliance (Baby Family)

## Nguồn sự thật

- Tài liệu nghiệp vụ `../docs/01_DAC_TA_NGHIEP_VU_BABY_FAMILY_v3.md` — mục 10
  (Nguyên tắc thiết kế & Design System) và mục 9 (đặc tả từng màn).
- Token trong code: `lib/utils/constants/colors.dart`,
  `lib/utils/helper/theme.dart` (`AppTypography`, `AppRadius`, `AppSpacing`,
  `AppShadows`, `AppTheme`).
- File thiết kế Pencil: `../desgin/appdesgin.pen` (component `component/*`,
  màn đặt tên theo mã màn `ONB-01 · Welcome 1`...). Đây là nguồn cao nhất về hình
  ảnh; trước khi code một màn, mở frame cùng mã màn để đối chiếu; mọi token mới phải cập nhật đồng thời tài liệu mục 10 và 2 file code trên.

## Định hướng

Ấm áp • dịu dàng • tin cậy • ảnh là nhân vật chính • dành cho người lớn (không
trẻ con hoá). Riêng tư nhìn thấy được: vùng Papa & Mama dùng nền tím oải hương
`kColorUs50F6F2FC` + biểu tượng khoá.

## Bắt buộc

- **Màu:** chỉ dùng hằng `kColor...` trong `colors.dart`. Không viết
  `Color(0x...)` trong page/widget. Nút chính `kColorPrimary600C2513F` chữ
  trắng; `kColorPrimary500EE7B67` chỉ cho icon/minh hoạ/FAB.
- **Không** dùng đỏ (`kColorErrorD14B4B`) cho nhiệm vụ chưa làm hay trạng thái
  trung tính — chỉ cho lỗi hệ thống/validate.
- **Màu bé** lấy từ `kChildPalette` theo `colorIndex`; luôn kèm tên/avatar,
  không dùng màu làm cách phân biệt duy nhất.
- **Font:** tiêu đề `AppTypography.h1/h2/h3/display` (Nunito), nội dung
  `body/bodyLarge/caption/label` (Be Vietnam Pro). Không tự đặt `fontFamily`.
- **Bo góc:** `AppRadius` — nút 16, thẻ nội dung 20, bottom sheet 28, dialog 24,
  chip/avatar `full`. Không tự đặt số bo góc khác.
- **Khoảng cách:** hệ 4pt `AppSpacing`; lề màn 20; vùng chạm ≥ 48.
- **Icon:** chỉ `lucide_flutter` (`LucideIcons`), style outline, cỡ 24 (UI),
  20 (chip), 16 (metadata). Không trộn `Icons.*` Material / Cupertino / emoji
  trong UI sản phẩm (emoji chỉ dùng cho cảm xúc & reaction theo đặc tả).
- **Component dùng chung:** `BaseScaffold`, `BaseAppBar`, `AppButton`
  (`.secondary`, `.us`), `AppDialog`, `CircleLoadingProgress`. Thiếu component
  thì thêm vào `lib/utils/widget/` rồi tái sử dụng — không tạo bản riêng trong
  màn.
- **Trạng thái màn:** mọi màn có danh sách phải có loading (skeleton/progress),
  empty (minh hoạ + 1 CTA), error (thử lại), offline (theo đặc tả mục 9).
- **Chữ:** tiếng Việt đầy đủ dấu, giọng văn mục 11 (ấm áp, không phán xét,
  không “phải/thất bại”). Hỗ trợ cỡ chữ hệ thống tới 200% — không cố định chiều
  cao làm cắt chữ.
- **Accessibility:** tương phản WCAG 2.2 AA; icon/ảnh có `Semantics` label.

## Cấm

- Gradient, neon, glow, bóng đổ đậm, nhiều màu nền sặc sỡ.
- Thêm màu thương hiệu mới, đổi tông chủ đạo, đổi icon library.
- Hiển thị bảng xếp hạng/so sánh Bố – Mẹ (vi phạm nguyên tắc sản phẩm P2).
- Lộ nội dung Papa & Mama ở màn/feed của người thân.

## Checklist bàn giao UI

- Dùng đúng token màu/font/radius/spacing; không hard-code.
- Không overflow ở màn 360dp và cỡ chữ 130%.
- Có đủ trạng thái loading/empty/error.
- So ảnh chụp màn hình với thiết kế trước khi báo hoàn thành.
