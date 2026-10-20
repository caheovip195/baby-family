import 'package:freezed_annotation/freezed_annotation.dart';

part 'me_awaiting_approval.freezed.dart';
part 'me_awaiting_approval.g.dart';

/// Lời mời bạn đời đã nhận, chờ người mời xác nhận lần cuối (INV-04).
@Freezed(when: FreezedWhenOptions.none)
abstract class MeAwaitingApproval with _$MeAwaitingApproval {
  @JsonSerializable(explicitToJson: true)
  const factory MeAwaitingApproval({
    @JsonKey(name: 'inviteId') String? inviteId,
    @JsonKey(name: 'familyName') String? familyName,
    @JsonKey(name: 'kind') String? kind,
  }) = _MeAwaitingApproval;

  factory MeAwaitingApproval.fromJson(Map<String, dynamic> json) =>
      _$MeAwaitingApprovalFromJson(json);
}
