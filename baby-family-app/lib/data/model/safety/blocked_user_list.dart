import 'package:baby_family/data/model/safety/blocked_user_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'blocked_user_list.freezed.dart';
part 'blocked_user_list.g.dart';

/// `{items: [...]}`.
@Freezed(when: FreezedWhenOptions.none)
abstract class BlockedUserList with _$BlockedUserList {
  @JsonSerializable(explicitToJson: true)
  const factory BlockedUserList({
    @JsonKey(name: 'items')
    @Default(<BlockedUserRecord>[])
    List<BlockedUserRecord> items,
  }) = _BlockedUserList;

  factory BlockedUserList.fromJson(Map<String, dynamic> json) =>
      _$BlockedUserListFromJson(json);
}
