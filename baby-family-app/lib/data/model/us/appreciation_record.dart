import 'package:freezed_annotation/freezed_annotation.dart';

part 'appreciation_record.freezed.dart';
part 'appreciation_record.g.dart';

/// Lời cảm ơn do server trả (`/v1/families/{fid}/us/appreciations`, US-05/06).
@Freezed(when: FreezedWhenOptions.none)
abstract class AppreciationRecord with _$AppreciationRecord {
  @JsonSerializable(explicitToJson: true)
  const factory AppreciationRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'fromUserId') String? fromUserId,
    @JsonKey(name: 'toUserId') String? toUserId,
    @JsonKey(name: 'body') String? body,
    @JsonKey(name: 'sticker') String? sticker,
    @JsonKey(name: 'linkedType') String? linkedType,
    @JsonKey(name: 'linkedId') String? linkedId,
    @JsonKey(name: 'familyShareStatus') String? familyShareStatus,
    @JsonKey(name: 'reaction') String? reaction,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'isMine') @Default(false) bool isMine,
  }) = _AppreciationRecord;

  factory AppreciationRecord.fromJson(Map<String, dynamic> json) =>
      _$AppreciationRecordFromJson(json);
}
