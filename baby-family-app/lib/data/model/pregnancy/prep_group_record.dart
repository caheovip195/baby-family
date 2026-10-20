import 'package:baby_family/data/model/pregnancy/prep_item_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prep_group_record.freezed.dart';
part 'prep_group_record.g.dart';

/// `GET /pregnancies/:id/prep-items` → `[{groupCode, items}]`.
@Freezed(when: FreezedWhenOptions.none)
abstract class PrepGroupRecord with _$PrepGroupRecord {
  @JsonSerializable(explicitToJson: true)
  const factory PrepGroupRecord({
    @JsonKey(name: 'groupCode') String? groupCode,
    @JsonKey(name: 'items')
    @Default(<PrepItemRecord>[])
    List<PrepItemRecord> items,
  }) = _PrepGroupRecord;

  factory PrepGroupRecord.fromJson(Map<String, dynamic> json) =>
      _$PrepGroupRecordFromJson(json);
}
