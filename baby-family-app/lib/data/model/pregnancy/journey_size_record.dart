import 'package:freezed_annotation/freezed_annotation.dart';

part 'journey_size_record.freezed.dart';
part 'journey_size_record.g.dart';

/// Kích thước thai tham khảo của một tuần (đã dịch theo ngôn ngữ).
@Freezed(when: FreezedWhenOptions.none)
abstract class JourneySizeRecord with _$JourneySizeRecord {
  @JsonSerializable(explicitToJson: true)
  const factory JourneySizeRecord({
    @JsonKey(name: 'emoji') String? emoji,
    @JsonKey(name: 'lengthCm') num? lengthCm,
    @JsonKey(name: 'weightG') num? weightG,
    @JsonKey(name: 'label') String? label,
  }) = _JourneySizeRecord;

  factory JourneySizeRecord.fromJson(Map<String, dynamic> json) =>
      _$JourneySizeRecordFromJson(json);
}
