import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_entry.freezed.dart';
part 'journal_entry.g.dart';

/// Trang nhật ký riêng (US-07) — chỉ người viết thấy.
@Freezed(when: FreezedWhenOptions.none)
abstract class JournalEntry with _$JournalEntry {
  @JsonSerializable(explicitToJson: true)
  const factory JournalEntry({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'showTime') @Default(false) bool showTime,
    @JsonKey(name: 'mood') @Default(JournalMood.calm) JournalMood mood,
    @JsonKey(name: 'title') @Default('') String title,
    @JsonKey(name: 'body') @Default('') String body,
    @JsonKey(name: 'photoAsset') String? photoAsset,
    @JsonKey(name: 'sharedExcerpt') @Default(false) bool sharedExcerpt,
  }) = _JournalEntry;

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);
}
