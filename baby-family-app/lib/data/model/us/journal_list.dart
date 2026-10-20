import 'package:baby_family/data/model/us/journal_entry_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_list.freezed.dart';
part 'journal_list.g.dart';

/// Một trang nhật ký riêng (`{items, nextCursor}`).
@Freezed(when: FreezedWhenOptions.none)
abstract class JournalList with _$JournalList {
  @JsonSerializable(explicitToJson: true)
  const factory JournalList({
    @JsonKey(name: 'items')
    @Default(<JournalEntryRecord>[])
    List<JournalEntryRecord> items,
    @JsonKey(name: 'nextCursor') String? nextCursor,
  }) = _JournalList;

  factory JournalList.fromJson(Map<String, dynamic> json) =>
      _$JournalListFromJson(json);
}
