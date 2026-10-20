import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_invite_issued.freezed.dart';
part 'circle_invite_issued.g.dart';

/// Lời mời người thân vừa tạo / gia hạn (mã + link).
@Freezed(when: FreezedWhenOptions.none)
abstract class CircleInviteIssued with _$CircleInviteIssued {
  @JsonSerializable(explicitToJson: true)
  const factory CircleInviteIssued({
    @JsonKey(name: 'inviteId') String? inviteId,
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'expiresAt') DateTime? expiresAt,
  }) = _CircleInviteIssued;

  factory CircleInviteIssued.fromJson(Map<String, dynamic> json) =>
      _$CircleInviteIssuedFromJson(json);
}
