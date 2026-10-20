import 'package:baby_family/data/model/circle/circle_member_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_member_list.freezed.dart';
part 'circle_member_list.g.dart';

/// `{members: [...]}`.
@Freezed(when: FreezedWhenOptions.none)
abstract class CircleMemberList with _$CircleMemberList {
  @JsonSerializable(explicitToJson: true)
  const factory CircleMemberList({
    @JsonKey(name: 'members')
    @Default(<CircleMemberRecord>[])
    List<CircleMemberRecord> members,
  }) = _CircleMemberList;

  factory CircleMemberList.fromJson(Map<String, dynamic> json) =>
      _$CircleMemberListFromJson(json);
}
