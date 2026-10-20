import 'package:baby_family/data/model/memory/milestone_category_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'milestone_catalog.freezed.dart';
part 'milestone_catalog.g.dart';

/// `GET /milestone-templates?childId`.
@Freezed(when: FreezedWhenOptions.none)
abstract class MilestoneCatalog with _$MilestoneCatalog {
  @JsonSerializable(explicitToJson: true)
  const factory MilestoneCatalog({
    @JsonKey(name: 'categories')
    @Default(<MilestoneCategoryRecord>[])
    List<MilestoneCategoryRecord> categories,
  }) = _MilestoneCatalog;

  factory MilestoneCatalog.fromJson(Map<String, dynamic> json) =>
      _$MilestoneCatalogFromJson(json);
}
