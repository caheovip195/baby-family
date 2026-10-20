import 'package:baby_family/data/model/memory/perspective_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'perspective_list.freezed.dart';
part 'perspective_list.g.dart';

/// `{items: [...]}` của `GET /memories/:id/perspectives`.
@Freezed(when: FreezedWhenOptions.none)
abstract class PerspectiveList with _$PerspectiveList {
  @JsonSerializable(explicitToJson: true)
  const factory PerspectiveList({
    @JsonKey(name: 'items')
    @Default(<PerspectiveRecord>[])
    List<PerspectiveRecord> items,
  }) = _PerspectiveList;

  factory PerspectiveList.fromJson(Map<String, dynamic> json) =>
      _$PerspectiveListFromJson(json);
}
