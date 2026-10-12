import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

/// Thông báo trong app (NOTI-01). `text` là catalog đã dịch.
@Freezed(when: FreezedWhenOptions.none)
abstract class AppNotification with _$AppNotification {
  @JsonSerializable(explicitToJson: true)
  const factory AppNotification({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'group')
    @Default(NotificationGroup.family)
    NotificationGroup group,
    @JsonKey(name: 'kind')
    @Default(NotificationKind.system)
    NotificationKind kind,
    @JsonKey(name: 'text') required String text,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'unread') @Default(false) bool unread,
    @JsonKey(name: 'route') String? route,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
