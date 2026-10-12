import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pending_invite.freezed.dart';
part 'pending_invite.g.dart';

/// Mã mời nhập trước khi đăng nhập (INV-05) — áp dụng sau AUTH-03/04.
@Freezed(when: FreezedWhenOptions.none)
abstract class PendingInvite with _$PendingInvite {
  @JsonSerializable(explicitToJson: true)
  const factory PendingInvite({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'kind') required InviteKind kind,
    @JsonKey(name: 'familyId') String? familyId,
  }) = _PendingInvite;

  factory PendingInvite.fromJson(Map<String, dynamic> json) =>
      _$PendingInviteFromJson(json);
}
