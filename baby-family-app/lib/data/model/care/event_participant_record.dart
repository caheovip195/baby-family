import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_participant_record.freezed.dart';
part 'event_participant_record.g.dart';

/// Người tham gia sự kiện (id người dùng server).
@Freezed(when: FreezedWhenOptions.none)
abstract class EventParticipantRecord with _$EventParticipantRecord {
  @JsonSerializable(explicitToJson: true)
  const factory EventParticipantRecord({
    @JsonKey(name: 'userId') String? userId,
  }) = _EventParticipantRecord;

  factory EventParticipantRecord.fromJson(Map<String, dynamic> json) =>
      _$EventParticipantRecordFromJson(json);
}
