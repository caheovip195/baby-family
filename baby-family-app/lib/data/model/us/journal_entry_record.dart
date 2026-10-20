import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_entry_record.freezed.dart';
part 'journal_entry_record.g.dart';

/// Trang nhật ký riêng do server trả (`/v1/families/{fid}/us/journal`, US-07) — chỉ của người viết.
@Freezed(when: FreezedWhenOptions.none)
abstract class JournalEntryRecord with _$JournalEntryRecord {
  @JsonSerializable(explicitToJson: true)
  const factory JournalEntryRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'body') String? body,
    @JsonKey(name: 'mood') String? mood,
    @JsonKey(name: 'assetIds') @Default(<String>[]) List<String> assetIds,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
  }) = _JournalEntryRecord;

  factory JournalEntryRecord.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryRecordFromJson(json);
}
