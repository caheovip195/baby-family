import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_decision.freezed.dart';
part 'invite_decision.g.dart';

/// Kết quả nhận/từ chối/duyệt lời mời (`JOINED|AWAITING_APPROVAL|DECLINED`).
@Freezed(when: FreezedWhenOptions.none)
abstract class InviteDecision with _$InviteDecision {
  @JsonSerializable(explicitToJson: true)
  const factory InviteDecision({
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'familyId') String? familyId,
    @JsonKey(name: 'trialEndsAt') DateTime? trialEndsAt,
  }) = _InviteDecision;

  factory InviteDecision.fromJson(Map<String, dynamic> json) =>
      _$InviteDecisionFromJson(json);
}
