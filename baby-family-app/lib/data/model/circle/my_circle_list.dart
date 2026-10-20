import 'package:baby_family/data/model/circle/my_circle_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_circle_list.freezed.dart';
part 'my_circle_list.g.dart';

/// `{items: [...]}`.
@Freezed(when: FreezedWhenOptions.none)
abstract class MyCircleList with _$MyCircleList {
  @JsonSerializable(explicitToJson: true)
  const factory MyCircleList({
    @JsonKey(name: 'items')
    @Default(<MyCircleRecord>[])
    List<MyCircleRecord> items,
  }) = _MyCircleList;

  factory MyCircleList.fromJson(Map<String, dynamic> json) =>
      _$MyCircleListFromJson(json);
}
