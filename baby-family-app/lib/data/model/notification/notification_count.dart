import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_count.freezed.dart';
part 'notification_count.g.dart';

/// `GET /v1/notifications/unread-count`.
@Freezed(when: FreezedWhenOptions.none)
abstract class NotificationCount with _$NotificationCount {
  @JsonSerializable(explicitToJson: true)
  const factory NotificationCount({
    @JsonKey(name: 'count') @Default(0) int count,
  }) = _NotificationCount;

  factory NotificationCount.fromJson(Map<String, dynamic> json) =>
      _$NotificationCountFromJson(json);
}
