import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_record.freezed.dart';
part 'notification_record.g.dart';

/// Một mục hộp thông báo do server trả (`GET /v1/notifications`, NOTI-01): app tự dựng câu theo `templateCode` + `params` (l10n).
@Freezed(when: FreezedWhenOptions.none)
abstract class NotificationRecord with _$NotificationRecord {
  @JsonSerializable(explicitToJson: true)
  const factory NotificationRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'tab') String? tab,
    @JsonKey(name: 'category') String? category,
    @JsonKey(name: 'templateCode') String? templateCode,
    @JsonKey(name: 'params')
    @Default(<String, dynamic>{})
    Map<String, dynamic> params,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'readAt') DateTime? readAt,
    @JsonKey(name: 'deepLink') String? deepLink,
  }) = _NotificationRecord;

  factory NotificationRecord.fromJson(Map<String, dynamic> json) =>
      _$NotificationRecordFromJson(json);
}
