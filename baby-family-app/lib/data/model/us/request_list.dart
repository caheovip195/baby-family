import 'package:baby_family/data/model/us/request_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_list.freezed.dart';
part 'request_list.g.dart';

/// Một trang lời nhờ (`{items, nextCursor}`).
@Freezed(when: FreezedWhenOptions.none)
abstract class RequestList with _$RequestList {
  @JsonSerializable(explicitToJson: true)
  const factory RequestList({
    @JsonKey(name: 'items')
    @Default(<RequestRecord>[])
    List<RequestRecord> items,
    @JsonKey(name: 'nextCursor') String? nextCursor,
  }) = _RequestList;

  factory RequestList.fromJson(Map<String, dynamic> json) =>
      _$RequestListFromJson(json);
}
