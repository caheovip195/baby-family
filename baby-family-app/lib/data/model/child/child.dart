import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'child.freezed.dart';
part 'child.g.dart';

/// Bé hoặc thai kỳ (mục 7.3). Tuổi/tuần thai tính bằng `child_age.dart`.
@Freezed(when: FreezedWhenOptions.none)
abstract class Child with _$Child {
  @JsonSerializable(explicitToJson: true)
  const factory Child({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'familyId') required String familyId,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'nickname') String? nickname,
    @JsonKey(name: 'kind') @Default(ChildKind.baby) ChildKind kind,
    @JsonKey(name: 'birthDate') DateTime? birthDate,
    @JsonKey(name: 'dueDate') DateTime? dueDate,
    @JsonKey(name: 'colorIndex') @Default(0) int colorIndex,
    @JsonKey(name: 'avatarAsset') String? avatarAsset,
    @JsonKey(name: 'coverAsset') String? coverAsset,
    @JsonKey(name: 'gender') @Default(ChildGender.unknown) ChildGender gender,
    @JsonKey(name: 'archived') @Default(false) bool archived,
    @JsonKey(name: 'carrierUserId') String? carrierUserId,
    @JsonKey(name: 'pregnancyOrder') int? pregnancyOrder,
    @JsonKey(name: 'babyCount') @Default(1) int babyCount,
    @JsonKey(name: 'lunarBirthDay') int? lunarBirthDay,
    @JsonKey(name: 'lunarBirthMonth') int? lunarBirthMonth,
    @JsonKey(name: 'birthWeightKg') double? birthWeightKg,
    @JsonKey(name: 'birthHeightCm') double? birthHeightCm,
    @JsonKey(name: 'birthTime') String? birthTime,

    /// CHD-03: ngày lưu trữ hồ sơ.
    @JsonKey(name: 'archivedAt') DateTime? archivedAt,
  }) = _Child;

  const Child._();

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);

  bool get isPregnancy => kind == ChildKind.pregnancy;
}
