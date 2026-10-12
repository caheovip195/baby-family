import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_info.freezed.dart';
part 'invite_info.g.dart';

/// Lời mời bạn đời/người thân (ONB-07, ONB-WAIT, INV-01, FAM-03).
@Freezed(when: FreezedWhenOptions.none)
abstract class InviteInfo with _$InviteInfo {
  @JsonSerializable(explicitToJson: true)
  const factory InviteInfo({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'kind') required InviteKind kind,
    @JsonKey(name: 'familyId') required String familyId,
    @JsonKey(name: 'familyName') String? familyName,
    @JsonKey(name: 'inviterName') String? inviterName,
    @JsonKey(name: 'inviterCallName') String? inviterCallName,
    @JsonKey(name: 'inviterAvatarAsset') String? inviterAvatarAsset,
    @JsonKey(name: 'memberId') String? memberId,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'role') @Default(FamilyRole.relative) FamilyRole role,
    @JsonKey(name: 'relation') RelativeRelation? relation,
    @JsonKey(name: 'callName') String? callName,
    @JsonKey(name: 'grantedChildIds') @Default([]) List<String> grantedChildIds,
    @JsonKey(name: 'canComment') @Default(false) bool canComment,
    @JsonKey(name: 'canPost') @Default(false) bool canPost,
    @JsonKey(name: 'link') String? link,
    @JsonKey(name: 'sentAt') DateTime? sentAt,
    @JsonKey(name: 'openedAt') DateTime? openedAt,
    @JsonKey(name: 'expiresAt') DateTime? expiresAt,
    @JsonKey(name: 'status') @Default('open') String status,

    /// Ghi chú quan hệ do bố mẹ nhập (“Bố của Papa”) — FAM-05.
    @JsonKey(name: 'relationNote') String? relationNote,

    /// Bố/Mẹ xác nhận lần cuối khi người được mời tham gia (INV-04).
    @JsonKey(name: 'requiresApproval') @Default(false) bool requiresApproval,
  }) = _InviteInfo;

  factory InviteInfo.fromJson(Map<String, dynamic> json) =>
      _$InviteInfoFromJson(json);
}
