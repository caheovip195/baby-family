import 'package:freezed_annotation/freezed_annotation.dart';

part 'blocked_person.freezed.dart';
part 'blocked_person.g.dart';

/// Người bị chặn (SET-13, RPT-02).
@Freezed(when: FreezedWhenOptions.none)
abstract class BlockedPerson with _$BlockedPerson {
  @JsonSerializable(explicitToJson: true)
  const factory BlockedPerson({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'context') String? context,
    @JsonKey(name: 'blockedAt') DateTime? blockedAt,
  }) = _BlockedPerson;

  factory BlockedPerson.fromJson(Map<String, dynamic> json) =>
      _$BlockedPersonFromJson(json);
}
