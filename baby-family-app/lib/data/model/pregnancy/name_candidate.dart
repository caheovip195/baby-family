import 'package:freezed_annotation/freezed_annotation.dart';

part 'name_candidate.freezed.dart';
part 'name_candidate.g.dart';

/// Tên dự định (PREG-07) — chỉ Papa & Mama thấy.
@Freezed(when: FreezedWhenOptions.none)
abstract class NameCandidate with _$NameCandidate {
  @JsonSerializable(explicitToJson: true)
  const factory NameCandidate({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'pregnancyId') required String pregnancyId,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'meaning') String? meaning,
    @JsonKey(name: 'addedByUserId') required String addedByUserId,
    @JsonKey(name: 'addedByCallName') String? addedByCallName,
    @JsonKey(name: 'likedByMe') @Default(false) bool likedByMe,
    @JsonKey(name: 'likedByPartner') @Default(false) bool likedByPartner,
    @JsonKey(name: 'chosen') @Default(false) bool chosen,
  }) = _NameCandidate;

  const NameCandidate._();

  factory NameCandidate.fromJson(Map<String, dynamic> json) =>
      _$NameCandidateFromJson(json);

  bool get bothLike => likedByMe && likedByPartner;
}
