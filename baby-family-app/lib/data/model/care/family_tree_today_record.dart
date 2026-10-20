import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_tree_today_record.freezed.dart';
part 'family_tree_today_record.g.dart';

/// Lá/hoa hôm nay của cây gia đình.
@Freezed(when: FreezedWhenOptions.none)
abstract class FamilyTreeTodayRecord with _$FamilyTreeTodayRecord {
  @JsonSerializable(explicitToJson: true)
  const factory FamilyTreeTodayRecord({
    @JsonKey(name: 'leaves') @Default(0) int leaves,
    @JsonKey(name: 'total') @Default(0) int total,
    @JsonKey(name: 'bloomed') @Default(false) bool bloomed,
  }) = _FamilyTreeTodayRecord;

  factory FamilyTreeTodayRecord.fromJson(Map<String, dynamic> json) =>
      _$FamilyTreeTodayRecordFromJson(json);
}
