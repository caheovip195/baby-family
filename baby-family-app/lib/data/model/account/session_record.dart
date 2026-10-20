import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_record.freezed.dart';
part 'session_record.g.dart';

/// Một phiên đăng nhập của chính tôi (`GET /me/sessions`, SET-07).
@Freezed(when: FreezedWhenOptions.none)
abstract class SessionRecord with _$SessionRecord {
  @JsonSerializable(explicitToJson: true)
  const factory SessionRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'platform') String? platform,
    @JsonKey(name: 'appVersion') String? appVersion,
    @JsonKey(name: 'deviceModel') String? deviceModel,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'lastUsedAt') DateTime? lastUsedAt,
    @JsonKey(name: 'current') @Default(false) bool current,
  }) = _SessionRecord;

  factory SessionRecord.fromJson(Map<String, dynamic> json) =>
      _$SessionRecordFromJson(json);
}
