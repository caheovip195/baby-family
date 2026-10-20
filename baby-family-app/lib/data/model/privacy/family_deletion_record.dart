import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_deletion_record.freezed.dart';
part 'family_deletion_record.g.dart';

/// Xoá gia đình (`/v1/families/{fid}/deletion`): `status` NONE |
/// AWAITING_PARTNER | SCHEDULED | CANCELLED.
@Freezed(when: FreezedWhenOptions.none)
abstract class FamilyDeletionRecord with _$FamilyDeletionRecord {
  @JsonSerializable(explicitToJson: true)
  const factory FamilyDeletionRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'requestedBy') String? requestedBy,
    @JsonKey(name: 'scheduledFor') DateTime? scheduledFor,
    @JsonKey(name: 'graceDays') int? graceDays,
  }) = _FamilyDeletionRecord;

  factory FamilyDeletionRecord.fromJson(Map<String, dynamic> json) =>
      _$FamilyDeletionRecordFromJson(json);
}
