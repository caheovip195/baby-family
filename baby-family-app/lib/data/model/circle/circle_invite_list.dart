import 'package:baby_family/data/model/circle/circle_invite_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_invite_list.freezed.dart';
part 'circle_invite_list.g.dart';

/// `{items: [...]}` của `GET /families/:fid/invites/circle`.
@Freezed(when: FreezedWhenOptions.none)
abstract class CircleInviteList with _$CircleInviteList {
  @JsonSerializable(explicitToJson: true)
  const factory CircleInviteList({
    @JsonKey(name: 'items')
    @Default(<CircleInviteRecord>[])
    List<CircleInviteRecord> items,
  }) = _CircleInviteList;

  factory CircleInviteList.fromJson(Map<String, dynamic> json) =>
      _$CircleInviteListFromJson(json);
}
