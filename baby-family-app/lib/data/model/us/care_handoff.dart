import 'package:baby_family/utils/helper/lenient_json.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'care_handoff.freezed.dart';
part 'care_handoff.g.dart';

/// Bàn giao ca (7.13.8, BF-20261028-007): tình trạng bé Parent ghi nhanh cho
/// bạn đời. [direction] `SENT` | `RECEIVED` theo người xem; [pending] = lưu
/// trên máy, chờ gửi.
@Freezed(when: FreezedWhenOptions.none)
abstract class CareHandoff with _$CareHandoff {
  @JsonSerializable(explicitToJson: true)
  const factory CareHandoff({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'direction') @Default('SENT') String direction,
    @JsonKey(name: 'childIds') @Default(<String>[]) List<String> childIds,
    @JsonKey(name: 'fedAt') DateTime? fedAt,
    @JsonKey(name: 'sleptAt') DateTime? sleptAt,
    @JsonKey(name: 'wokeAt') DateTime? wokeAt,
    @JsonKey(name: 'note') String? note,
    @JsonKey(name: 'acknowledgedAt') DateTime? acknowledgedAt,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'pending') @Default(false) bool pending,
  }) = _CareHandoff;

  factory CareHandoff.fromJson(Map<String, dynamic> json) =>
      _$CareHandoffFromJson(json);

  const CareHandoff._();

  bool get received => direction == 'RECEIVED';
}

/// Danh sách bàn giao từ server: dòng không đọc được bị bỏ qua.
List<CareHandoff> careHandoffList(Object? json) =>
    lenientList(json, CareHandoff.fromJson, label: 'bàn giao ca');
