import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_badge.freezed.dart';
part 'family_badge.g.dart';

/// Huy hiệu của gia đình (CARE-10).
@Freezed(when: FreezedWhenOptions.none)
abstract class FamilyBadge with _$FamilyBadge {
  @JsonSerializable(explicitToJson: true)
  const factory FamilyBadge({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'achievedAt') DateTime? achievedAt,
    @JsonKey(name: 'childId') String? childId,
    @JsonKey(name: 'hint') String? hint,
    @JsonKey(name: 'progress') int? progress,
    @JsonKey(name: 'target') int? target,
  }) = _FamilyBadge;

  const FamilyBadge._();

  factory FamilyBadge.fromJson(Map<String, dynamic> json) =>
      _$FamilyBadgeFromJson(json);

  bool get achieved => achievedAt != null;
}
