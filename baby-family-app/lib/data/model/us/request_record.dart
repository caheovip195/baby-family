import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_record.freezed.dart';
part 'request_record.g.dart';

/// Lời nhờ do server trả (`/v1/families/{fid}/us/requests`, US-03/04).
@Freezed(when: FreezedWhenOptions.none)
abstract class RequestRecord with _$RequestRecord {
  @JsonSerializable(explicitToJson: true)
  const factory RequestRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'senderUserId') String? senderUserId,
    @JsonKey(name: 'receiverUserId') String? receiverUserId,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'needCode') String? needCode,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'durationMin') int? durationMin,
    @JsonKey(name: 'childIds') @Default(<String>[]) List<String> childIds,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'dueKind') String? dueKind,
    @JsonKey(name: 'dueAt') DateTime? dueAt,
    @JsonKey(name: 'urgency') String? urgency,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'volunteered') @Default(false) bool volunteered,
    @JsonKey(name: 'declineReason') String? declineReason,
    @JsonKey(name: 'reminderAt') DateTime? reminderAt,
    @JsonKey(name: 'seenAt') DateTime? seenAt,
    @JsonKey(name: 'respondedAt') DateTime? respondedAt,
    @JsonKey(name: 'doneAt') DateTime? doneAt,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  }) = _RequestRecord;

  factory RequestRecord.fromJson(Map<String, dynamic> json) =>
      _$RequestRecordFromJson(json);
}
