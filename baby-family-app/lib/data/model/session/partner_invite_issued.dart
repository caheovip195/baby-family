import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner_invite_issued.freezed.dart';
part 'partner_invite_issued.g.dart';

/// Lời mời bạn đời vừa tạo — mã/link chỉ trả một lần (ONB-07).
@Freezed(when: FreezedWhenOptions.none)
abstract class PartnerInviteIssued with _$PartnerInviteIssued {
  @JsonSerializable(explicitToJson: true)
  const factory PartnerInviteIssued({
    @JsonKey(name: 'inviteId') String? inviteId,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'qrPayload') String? qrPayload,
    @JsonKey(name: 'expiresAt') DateTime? expiresAt,
  }) = _PartnerInviteIssued;

  factory PartnerInviteIssued.fromJson(Map<String, dynamic> json) =>
      _$PartnerInviteIssuedFromJson(json);
}
