import 'package:baby_family/data/model/care/badge_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge_list.freezed.dart';
part 'badge_list.g.dart';

/// `{items: [...]}` của `GET …/badges`.
@Freezed(when: FreezedWhenOptions.none)
abstract class BadgeList with _$BadgeList {
  @JsonSerializable(explicitToJson: true)
  const factory BadgeList({
    @JsonKey(name: 'items') @Default(<BadgeRecord>[]) List<BadgeRecord> items,
  }) = _BadgeList;

  factory BadgeList.fromJson(Map<String, dynamic> json) =>
      _$BadgeListFromJson(json);
}
