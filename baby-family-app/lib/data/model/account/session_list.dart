import 'package:baby_family/data/model/account/session_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_list.freezed.dart';
part 'session_list.g.dart';

/// `{items: [...]}` của `GET /me/sessions`.
@Freezed(when: FreezedWhenOptions.none)
abstract class SessionList with _$SessionList {
  @JsonSerializable(explicitToJson: true)
  const factory SessionList({
    @JsonKey(name: 'items')
    @Default(<SessionRecord>[])
    List<SessionRecord> items,
  }) = _SessionList;

  factory SessionList.fromJson(Map<String, dynamic> json) =>
      _$SessionListFromJson(json);
}
