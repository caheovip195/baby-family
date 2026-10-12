import 'package:freezed_annotation/freezed_annotation.dart';

part 'hearts_entry.freezed.dart';
part 'hearts_entry.g.dart';

/// Một lần góp Hearts của chính mình (CARE-09).
@Freezed(when: FreezedWhenOptions.none)
abstract class HeartsEntry with _$HeartsEntry {
  @JsonSerializable(explicitToJson: true)
  const factory HeartsEntry({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'hearts') @Default(0) int hearts,
    @JsonKey(name: 'title') @Default('') String title,
    @JsonKey(name: 'at') required DateTime at,
    @JsonKey(name: 'together') @Default(false) bool together,
    @JsonKey(name: 'missionId') String? missionId,
    @JsonKey(name: 'requestId') String? requestId,
  }) = _HeartsEntry;

  factory HeartsEntry.fromJson(Map<String, dynamic> json) =>
      _$HeartsEntryFromJson(json);
}
