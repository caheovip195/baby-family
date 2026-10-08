# Skill 9: Model, DTO & Enum Placement (bắt buộc sửa)

## Mục tiêu

Mọi class dữ liệu và mọi `enum` phải nằm đúng thư mục của nó. Không được viết
model, DTO hay enum trong page, controller, view, widget, provider, service,
repository hay helper.

Skill này là **bắt buộc sửa**: bất kỳ ai (agent hoặc dev) tạo mới hay chỉnh sửa
một file có class/enum đặt sai chỗ đều phải chuyển nó về đúng vị trí **trong
cùng task**, trước khi báo hoàn thành. Không được để lại với lý do "ngoài phạm
vi" hay "làm sau".

## Phân loại

| Loại | Nhận biết | Vị trí | Quy ước |
| --- | --- | --- | --- |
| **Model** | Ánh xạ JSON load từ server/local storage: có `fromJson`, `@JsonKey`, `@JsonSerializable` | `lib/data/model/` (tạo thư mục con theo module khi cần: `family/`, `memory/`, `care/`, `us/`...) | Theo Skill 3: `freezed` + `json_serializable`, `.freezed.dart` + `.g.dart` |
| **DTO** | Class dữ liệu **không có JSON key**: dữ liệu hiển thị của màn (view data), style/màu/icon theo trạng thái, bộ lọc, kết quả domain (`Result`, `LoginResult`), dữ liệu từ platform channel (`fromMap`), payload builder | `lib/data/dto/` (phẳng, tên file có tiền tố vai trò/tính năng khi tên chung chung) | Plain immutable class (`const` constructor, field `final`) hoặc `@freezed` không có `fromJson` |
| **Enum** | Mọi khai báo `enum` (kể cả enum private chỉ dùng trong 1 màn) | `lib/utils/constants/enum_part/<ten_enum>.dart` | Mở đầu `part of '../enum.dart';`, khai báo `part 'enum_part/<ten_enum>.dart';` trong `lib/utils/constants/enum.dart`; import qua `package:baby_family/utils/constants/enum.dart` |

Ngoại lệ được phép (không phải model/DTO):

- Widget, `State`, controller/notifier, service, repository, provider, router,
  interceptor, exception, painter/clipper.
- Helper thực sự trong `lib/utils/helper/` (class chỉ có static method hoặc
  class tính toán như `DeviceLayout` trả về từ `DeviceLayoutHelper`).
- Response envelope Retrofit trong `lib/data/remote/app_client/base_response.dart`.

## Quy tắc bắt buộc

1. Mỗi file chỉ một model/DTO/enum. Tên file là snake_case của tên class/enum.
2. Extension của một enum (`extension XxxCapability on Xxx`) đặt chung file
   `enum_part` của enum đó. Hằng số/hàm dùng enum để map JSON
    ở lại file model/DTO
   đang dùng nó.
3. Enum `part` file không được tự import; nếu cần thêm import thì thêm vào
   `lib/utils/constants/enum.dart`.
4. Class/enum private (`_Xxx`) khi chuyển ra phải đổi thành public và đặt tên
   rõ nghĩa để không trùng toàn project: `_SlideData` ->
   `WelcomeSlideData`, `_ButtonStyle` -> `AppButtonStyle`.
5. Class/enum giống hệt nhau ở nhiều màn  phải gộp thành **một** DTO/enum dùng chung, không tạo bản sao.
6. Import dùng dạng `package:baby_family/...`. Không để lại import cũ trỏ tới
   file đã chuyển; sau khi chuyển chạy `fvm dart fix --apply lib` để sắp xếp
   directive.
7. Model không có JSON đang nằm trong `lib/data/model/` phải chuyển sang
   `lib/data/dto/` (hoặc `enum_part` nếu là enum). Bản nháp form (`*_draft`)
   đang dùng `freezed` + `fromJson` theo Skill 3 thì giữ ở `lib/data/model/`.
8. Dùng `git mv` khi chuyển nguyên file để giữ lịch sử; chuyển kèm file
   `.freezed.dart`/`.g.dart` rồi chạy build_runner.
9. Không tạo thư mục mới trong `lib/data/dto/` hay `enum_part/` khi chưa được
   duyệt (Skill 4).

## Dữ liệu mẫu (mock)

Bổ sung cho Skill 6 ("Do not invent mock fallback data"):

- Không hardcode dữ liệu nghiệp vụ mẫu (tên bé, ngày sinh, ảnh, số liệu...) trong page/controller/widget.
- Không dùng giá trị giả làm fallback khi thiếu dữ liệu (`'Hana'`, `'8 tháng'`, `100%`). Dùng `'Chưa cập nhật'`, `'--'`, ẩn
  phần tử hoặc empty state.
- Màn chưa có API không được mở từ UI thật; nếu phải giữ để tham khảo thì ghi
  rõ trong `SESSION.md`.

## Quan hệ với các skill khác

- Skill 2/4 cấm move/rename file: với vi phạm của Skill 9, việc chuyển file và
  đổi class private -> public là **được phép và bắt buộc**, nhưng chỉ trong
  phạm vi class/enum vi phạm; không refactor phần khác.
- Skill 3 (freezed + JSON) chỉ áp dụng cho **Model** trong `lib/data/model/`.
  DTO không cần `fromJson`.
- Skill 7 ghi `lib/data/models`; đường dẫn thực tế của project là
  `lib/data/model`.

## Khi không tự sửa được

Nếu việc sửa cần xoá file (file trùng, file rỗng, model mồ côi) mà phiên làm
việc không có quyền xoá, hoặc class thuộc màn đang chờ quyết định xoá: dừng lại,
liệt kê chính xác file/class và lý do trong câu trả lời và `SESSION.md`. Không
được im lặng bỏ qua.

## Self Validation

Chạy trước khi báo hoàn thành; mọi kết quả mới phải được sửa:

```bash
# 1. Enum nằm ngoài enum_part
grep -rnE "^\s*enum\s+\w+" lib --include='*.dart' \
  | grep -vE '\.(g|freezed|gr)\.dart:' \
  | grep -v 'lib/utils/constants/enum_part/'

# 2. File trong data/model không có JSON (phải chuyển sang dto / enum_part)
for f in $(find lib/data/model -name '*.dart' ! -name '*.g.dart' ! -name '*.freezed.dart'); do
  grep -q 'fromJson' "$f" || echo "$f"
done

# 3. Class dữ liệu viết ngoài data/model, data/dto (xem từng dòng: class chỉ
#    chứa field/constructor/getter là DTO và phải chuyển). Class mới trong
#    lib/utils/helper cũng phải tự rà theo cùng tiêu chí.
grep -rnE "^(abstract |sealed |final |base )*class\s+\w+" \
  lib/page lib/data/provider lib/data/service lib/data/service_imp \
  lib/data/repository lib/data/repository_imp lib/utils/widget \
  --include='*.dart' \
  | grep -vE '\.(g|freezed|gr)\.dart:' \
  | grep -vE 'extends\s+(\w*Widget|State<|ConsumerState<|\w*Notifier|ChangeNotifier|CustomPainter|CustomClipper|NavigatorObserver)' \
  | grep -vE 'class _*(Base\w+|\w+(Page|Controller|View|Widget|State|Repository|RepositoryImp|Service|ServiceImp|Provider|Notifier|Painter|Helper|Channel|Store|Dialog))\b'

fvm dart fix --apply lib
fvm dart format <các file đã sửa>
fvm flutter analyze
```
