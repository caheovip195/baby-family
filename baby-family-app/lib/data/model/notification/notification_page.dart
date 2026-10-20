import 'package:baby_family/data/model/notification/notification_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_page.freezed.dart';
part 'notification_page.g.dart';

/// Một trang hộp thông báo (`{items, nextCursor}`).
@Freezed(when: FreezedWhenOptions.none)
abstract class NotificationPage with _$NotificationPage {
  @JsonSerializable(explicitToJson: true)
  const factory NotificationPage({
    @JsonKey(name: 'items')
    @Default(<NotificationRecord>[])
    List<NotificationRecord> items,
    @JsonKey(name: 'nextCursor') String? nextCursor,
  }) = _NotificationPage;

  factory NotificationPage.fromJson(Map<String, dynamic> json) =>
      _$NotificationPageFromJson(json);
}
