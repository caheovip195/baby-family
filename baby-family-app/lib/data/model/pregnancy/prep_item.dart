import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prep_item.freezed.dart';
part 'prep_item.g.dart';

/// Mục chuẩn bị đón bé (PREG-04).
@Freezed(when: FreezedWhenOptions.none)
abstract class PrepItem with _$PrepItem {
  @JsonSerializable(explicitToJson: true)
  const factory PrepItem({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'pregnancyId') required String pregnancyId,
    @JsonKey(name: 'group') @Default(PrepGroup.bag) PrepGroup group,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'done') @Default(false) bool done,
    @JsonKey(name: 'ownerKind') MissionOwnerKind? ownerKind,
    @JsonKey(name: 'requestedFromPartner')
    @Default(false)
    bool requestedFromPartner,
    @JsonKey(name: 'isCustom') @Default(false) bool isCustom,
  }) = _PrepItem;

  factory PrepItem.fromJson(Map<String, dynamic> json) =>
      _$PrepItemFromJson(json);
}
