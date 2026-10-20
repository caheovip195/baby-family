import 'package:baby_family/data/model/us/appreciation_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'appreciation_wall.freezed.dart';
part 'appreciation_wall.g.dart';

/// Một trang bức tường cảm ơn (`{items, nextCursor}`).
@Freezed(when: FreezedWhenOptions.none)
abstract class AppreciationWall with _$AppreciationWall {
  @JsonSerializable(explicitToJson: true)
  const factory AppreciationWall({
    @JsonKey(name: 'items')
    @Default(<AppreciationRecord>[])
    List<AppreciationRecord> items,
    @JsonKey(name: 'nextCursor') String? nextCursor,
  }) = _AppreciationWall;

  factory AppreciationWall.fromJson(Map<String, dynamic> json) =>
      _$AppreciationWallFromJson(json);
}
