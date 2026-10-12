import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_summary.freezed.dart';
part 'collection_summary.g.dart';

/// Bộ sưu tập (MEM-22).
@Freezed(when: FreezedWhenOptions.none)
abstract class CollectionSummary with _$CollectionSummary {
  @JsonSerializable(explicitToJson: true)
  const factory CollectionSummary({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'coverAsset') String? coverAsset,
    @JsonKey(name: 'count') @Default(0) int count,
  }) = _CollectionSummary;

  factory CollectionSummary.fromJson(Map<String, dynamic> json) =>
      _$CollectionSummaryFromJson(json);
}
