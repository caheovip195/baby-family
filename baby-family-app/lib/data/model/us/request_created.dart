import 'package:baby_family/data/model/us/request_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_created.freezed.dart';
part 'request_created.g.dart';

/// Kết quả gửi lời nhờ: lời nhờ mới + số đang mở (BR-067).
@Freezed(when: FreezedWhenOptions.none)
abstract class RequestCreated with _$RequestCreated {
  @JsonSerializable(explicitToJson: true)
  const factory RequestCreated({
    @JsonKey(name: 'request') RequestRecord? request,
    @JsonKey(name: 'openCount') int? openCount,
    @JsonKey(name: 'openLimit') int? openLimit,
  }) = _RequestCreated;

  factory RequestCreated.fromJson(Map<String, dynamic> json) =>
      _$RequestCreatedFromJson(json);
}
