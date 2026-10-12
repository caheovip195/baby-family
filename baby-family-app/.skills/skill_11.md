# Skill 11: Dùng chung Widget, Helper, Extension & Constant (bắt buộc sửa)

## Mục tiêu

Không có hai bản code làm cùng một việc. Thứ gì được dùng ở **từ 2 màn trở
lên** (widget, hàm, extension, hằng số, style) phải nằm ở thư mục dùng chung
trong `lib/utils/` và được import từ đó, không copy sang màn khác.

Skill này là **bắt buộc sửa** giống Skill 9: khi tạo mới hoặc chỉnh một màn mà
phát hiện code trùng/đặt sai chỗ thì phải đưa về chỗ dùng chung **trong cùng
task**, trước khi báo hoàn thành.

## Đặt ở đâu

| Loại | Chỉ 1 màn dùng | Từ 2 màn trở lên dùng | Quy ước |
| --- | --- | --- | --- |
| **Widget** | `lib/page/<nhóm>/<màn>/widgets/<widget>.dart` | `lib/utils/widget/<widget>.dart` | Class public, tên rõ nghĩa theo chức năng (`ChildAvatar`, `MissionCard`, `HeartsBadge`, `EmptyState`), widget nền tảng tiền tố `App` (`AppButton`, `AppDialog`). Mỗi file 1 widget chính |
| **Hàm tiện ích / tính toán** (không UI, không gọi API) | Private method trong controller của màn | `lib/utils/helper/<chủ_đề>.dart` | Hàm top-level (như `serverErrorMessage`) hoặc class chỉ có `static`. Đặt theo chủ đề: `child_age.dart`, `pregnancy_week.dart`, `lunar_date.dart`… |
| **Extension** | — (không viết extension trong màn) | `lib/utils/extension/<kiểu>.dart` | Một file theo kiểu được mở rộng: `date_time.dart`, `string.dart`, `num.dart`, `l10n.dart`. Tên `XxxExt` |
| **Hằng số giá trị** (thời gian, giới hạn, kích thước, key) | `static const` private trong class của màn **chỉ khi** không có ý nghĩa nghiệp vụ | `lib/utils/constants/values.dart` | `kValue<TênRõNghĩa>`, có `///` mô tả và dẫn mục tài liệu nếu là quy tắc nghiệp vụ (vd. `kValueMaxOpenRequests = 5 // BR-067`) |
| **Màu** | Không bao giờ khai báo màu trong màn | `lib/utils/constants/colors.dart` | `kColor<VaiTrò><HEX>` theo Design System (Skill 8) |
| **Endpoint** | Không bao giờ | `lib/utils/constants/server.dart` | Theo Skill 6 |
| **Enum** | Không bao giờ | `lib/utils/constants/enum_part/` | Theo Skill 9 |
| **Style chữ, bo góc, khoảng cách** | Không viết số cứng lặp lại | `lib/utils/helper/theme.dart` (`AppTypography`, `AppRadius`, `AppSpacing`) | Thiếu token thì bổ sung vào theme, không tự đặt số trong màn |
| **Logic dữ liệu dùng chung** (gọi API, cache, quy đổi dữ liệu server) | — | Service/Repository (Skill 6, 7) | Không đưa logic gọi API vào helper hay widget |
| **Hành vi chung của controller/màn** | — | `lib/page/application_base.dart` (`BaseNotifier`, `BaseHookWidget`) | Chỉ thêm khi **mọi** màn cần; hành vi của một nhóm màn thì dùng helper/service |

## Quy tắc bắt buộc

1. **Tìm trước khi viết.** Trước khi tạo widget/hàm/hằng số mới, tìm trong
   `lib/utils/` và `lib/page/**/widgets/` xem đã có cái tương tự chưa
   (`grep -rn "class .*Avatar" lib`, `grep -rn "kValue" lib/utils/constants`).
   Có rồi thì dùng lại; thiếu một chút thì **mở rộng bằng tham số/named
   constructor** (như `AppButton.secondary`, `AppButton.us`), không tạo bản sao.
2. **Quy tắc lần dùng thứ hai.** Màn thứ hai cần một widget/hàm đang nằm trong
   `widgets/` hoặc controller của màn khác → **chuyển nó lên `lib/utils/`** trong
   task đó và cho cả hai màn import từ chỗ mới. Cấm import chéo
   `lib/page/<màn A>/widgets/...` từ màn B.
3. **Gộp bản trùng.** Hai widget/hàm/hằng số giống nhau (hoặc chỉ khác màu,
   chữ, padding) ở hai nơi → gộp thành một bản dùng chung có tham số, xoá bản
   cũ, cập nhật mọi chỗ gọi.
4. **Widget dùng chung phải "sạch":**
   - Nhận dữ liệu qua tham số (model/DTO/giá trị), trả sự kiện qua callback
     (`onTap`, `onChanged`). **Không** gọi API, không đọc provider nghiệp vụ,
     không tự điều hướng (trừ widget hệ thống như `AppDialog`).
   - Không hard-code chuỗi (Skill 10): nhận chuỗi qua tham số hoặc lấy
     `context.l10n.common…`.
   - Dùng token màu/chữ/bo góc của Design System (Skill 8).
   - `const` constructor khi có thể; ưu tiên `StatelessWidget`
     (`HookWidget` chỉ khi cần state UI cục bộ).
   - Có `///` mô tả công dụng, các biến thể và màn đang dùng tiêu biểu.
5. **Helper phải thuần.** Hàm trong `lib/utils/helper/` không phụ thuộc
   `BuildContext` trừ khi bắt buộc (khi đó nhận `BuildContext` làm tham số),
   không giữ state, có thể viết unit test (`test/utils/<helper>_test.dart`).
   Quy tắc nghiệp vụ dùng ở nhiều màn (tính tuổi bé “5 tháng 6 ngày”, tuần
   thai, tháng tuổi cho ảnh tháng, ngày âm lịch) **chỉ được viết một lần**
   trong helper và phải có test.
6. **Hằng số nghiệp vụ không viết số trần trong code.** Giới hạn như 5 lời
   nhờ đang mở, 3 lần đổi nhiệm vụ, 10 giây hoàn tác, 75 Hearts/ngày… phải là
   `kValue…` trong `values.dart` có chú thích mã BR/mục tài liệu. Giá trị có
   thể đổi từ server (`app-config`) thì hằng số chỉ là **giá trị mặc định**.
7. **Đặt tên & import.** Tên file snake_case trùng tên class/chủ đề; import
   `package:baby_family/...`; widget dùng chung có thể re-export trong file
   export hiện có nếu thư mục đó đã có file export (không tự tạo file export
   mới khi chưa được duyệt).
8. **Không tạo thư mục con mới** trong `lib/utils/` khi chưa được duyệt
   (Skill 4). Chuyển file từ màn lên `lib/utils/` là thao tác **được phép và
   bắt buộc** theo skill này (ngoại lệ của Skill 2/4), chỉ trong phạm vi code
   trùng/dùng chung, không refactor phần khác.

## Ví dụ trong Baby Family (dự kiến dùng nhiều màn)

| Thành phần | Dùng ở | Vị trí đúng |
| --- | --- | --- |
| Avatar bé (ảnh/chữ cái, viền màu bé, icon mầm cho thai kỳ) | Trang chủ, Ký ức, Chăm con, Gia đình, Người thân | `lib/utils/widget/child_avatar.dart` |
| Bộ chuyển bé (chip + bottom sheet SW-01) | HOME, MEM, CARE | `lib/utils/widget/child_switcher.dart` |
| Thẻ nhiệm vụ | CARE-01, HOME-01/02 | `lib/utils/widget/mission_card.dart` |
| Thẻ ký ức / thẻ câu nói / thẻ giọng nói | HOME feed, MEM-01, Người thân | `lib/utils/widget/memory_card.dart`, `quote_card.dart`, `voice_card.dart` |
| Empty state chuẩn (minh hoạ + tiêu đề + nút) | Mọi danh sách | `lib/utils/widget/empty_state.dart` |
| Bottom sheet chuẩn (tay cầm, bo 28) | QC-01, SW-01, CARE-05/06, US-02… | `lib/utils/widget/app_bottom_sheet.dart` |
| Tính tuổi bé / tuần thai / tháng tuổi | Mọi nơi hiển thị tuổi | `lib/utils/helper/child_age.dart` (+ test) |
| Định dạng số Hearts, số đếm | CARE, HOME | `lib/utils/extension/num.dart` |

## Self Validation

Chạy trước khi báo hoàn thành; mọi kết quả mới phải được sửa:

```bash
# 1. Import chéo widget/controller giữa các màn (phải chuyển lên lib/utils)
for d in $(find lib/page -mindepth 2 -maxdepth 2 -type d); do
  grep -rln "package:baby_family/page/" "$d" --include='*.dart' \
    | xargs grep -n "package:baby_family/page/" 2>/dev/null \
    | grep -v "$(echo "$d" | sed 's#^lib/##')" \
    | grep -v "page/application_base.dart"
done

# 2. Widget trùng tên/na ná ở nhiều màn
grep -rhoE "^class \w+ extends (StatelessWidget|StatefulWidget|HookWidget|HookConsumerWidget|ConsumerWidget)" \
  lib/page --include='*.dart' | awk '{print $2}' | sort | uniq -d

# 3. Màu / hằng số khai báo ngoài constants
grep -rnE "Color\(0x|const k(Value|Color)\w+ =" lib --include='*.dart' \
  | grep -vE "lib/utils/constants/|lib/generated/|\.(g|freezed|gr)\.dart:"

# 4. Extension viết ngoài lib/utils/extension
grep -rnE "^extension \w+ on " lib --include='*.dart' \
  | grep -vE "lib/utils/extension/|lib/utils/constants/enum_part/|\.(g|freezed|gr)\.dart:"

# 5. Số giới hạn nghiệp vụ viết trần (rà thủ công các kết quả)
grep -rnE "(Duration\((seconds|minutes|hours): *[0-9]+\)|[<>]=? *[0-9]{1,3}\b)" lib/page --include='*.dart'

fvm dart fix --apply lib
fvm flutter analyze
fvm flutter test
```

Kết quả (1), (2), (3), (4) phải rỗng. Kết quả (5) phải được rà: số nào là quy
tắc nghiệp vụ hoặc dùng ≥ 2 nơi thì chuyển thành `kValue…`.

## Quan hệ với các skill khác

- Skill 4 (không tạo cấu trúc mới): skill này chỉ dùng các thư mục **đã có**
  `lib/utils/widget`, `helper`, `extension`, `constants`.
- Skill 8: widget dùng chung là nơi áp dụng Design System; sửa token ở một chỗ.
- Skill 9: class dữ liệu/enum phát hiện khi gom code dùng chung vẫn phải về
  `data/model`, `data/dto`, `enum_part`.
- Skill 10: widget/helper dùng chung không chứa chuỗi hiển thị cứng.
