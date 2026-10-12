import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';
part 'member.g.dart';

/// Thành viên gia đình (Papa/Mama/người thân).
@Freezed(when: FreezedWhenOptions.none)
abstract class Member with _$Member {
  @JsonSerializable(explicitToJson: true)
  const factory Member({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'familyId') required String familyId,
    @JsonKey(name: 'userId') String? userId,
    @JsonKey(name: 'role') required FamilyRole role,
    @JsonKey(name: 'slot') ParentSlot? slot,
    @JsonKey(name: 'status') @Default(MemberStatus.active) MemberStatus status,
    @JsonKey(name: 'displayName') @Default('') String displayName,
    @JsonKey(name: 'callName') @Default('') String callName,
    @JsonKey(name: 'avatarAsset') String? avatarAsset,
    @JsonKey(name: 'relation') RelativeRelation? relation,
    @JsonKey(name: 'grantedChildIds') @Default([]) List<String> grantedChildIds,
    @JsonKey(name: 'canComment') @Default(false) bool canComment,
    @JsonKey(name: 'canPost') @Default(false) bool canPost,
    @JsonKey(name: 'isAdmin') @Default(false) bool isAdmin,
    @JsonKey(name: 'joinedAt') DateTime? joinedAt,

    /// FAM-04: quyền theo từng bé; bé không có trong map = chưa chia sẻ.
    @JsonKey(name: 'childPermissions')
    @Default({})
    Map<String, RelativePermission> childPermissions,
    @JsonKey(name: 'allowDownload') @Default(false) bool allowDownload,
    @JsonKey(name: 'notificationsMuted')
    @Default(false)
    bool notificationsMuted,
    @JsonKey(name: 'paused') @Default(false) bool paused,
    @JsonKey(name: 'lastActiveAt') DateTime? lastActiveAt,
    @JsonKey(name: 'phoneMasked') String? phoneMasked,
    @JsonKey(name: 'postedCount') @Default(0) int postedCount,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
