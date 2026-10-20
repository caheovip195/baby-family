import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner_invite_status.freezed.dart';
part 'partner_invite_status.g.dart';

/// Trạng thái lời mời bạn đời mới nhất (ONB-WAIT).
@Freezed(when: FreezedWhenOptions.none)
abstract class PartnerInviteStatus with _$PartnerInviteStatus {
  @JsonSerializable(explicitToJson: true)
  const factory PartnerInviteStatus({
    @JsonKey(name: 'inviteId') String? inviteId,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'requireFinalApproval')
    @Default(true)
    bool requireFinalApproval,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'expiresAt') DateTime? expiresAt,
    @JsonKey(name: 'acceptedCallName') String? acceptedCallName,
  }) = _PartnerInviteStatus;

  factory PartnerInviteStatus.fromJson(Map<String, dynamic> json) =>
      _$PartnerInviteStatusFromJson(json);
}
