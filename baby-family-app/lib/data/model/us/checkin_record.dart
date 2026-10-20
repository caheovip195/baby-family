import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkin_record.freezed.dart';
part 'checkin_record.g.dart';

/// Check-in cảm xúc do server trả (`/v1/families/{fid}/us/checkins`, US-02). Bản của bạn đời chỉ có trường đã chia sẻ.
@Freezed(when: FreezedWhenOptions.none)
abstract class CheckinRecord with _$CheckinRecord {
  @JsonSerializable(explicitToJson: true)
  const factory CheckinRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'expiresAt') DateTime? expiresAt,
    @JsonKey(name: 'mood') String? mood,
    @JsonKey(name: 'energy') int? energy,
    @JsonKey(name: 'needs') @Default(<String>[]) List<String> needs,
    @JsonKey(name: 'note') String? note,
    @JsonKey(name: 'shared') bool? shared,
    @JsonKey(name: 'sharedFields')
    @Default(<String>[])
    List<String> sharedFields,
  }) = _CheckinRecord;

  factory CheckinRecord.fromJson(Map<String, dynamic> json) =>
      _$CheckinRecordFromJson(json);
}
