import 'package:baby_family/data/model/privacy/family_deletion_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_overview_record.freezed.dart';
part 'privacy_overview_record.g.dart';

/// `GET /v1/families/{fid}/privacy-overview` (SET-04, chỉ Parent) — phần app
/// dùng: mặc định ai xem, số người tôi đã chặn, trạng thái xoá gia đình.
@Freezed(when: FreezedWhenOptions.none)
abstract class PrivacyOverviewRecord with _$PrivacyOverviewRecord {
  @JsonSerializable(explicitToJson: true)
  const factory PrivacyOverviewRecord({
    @JsonKey(name: 'defaults') PrivacyDefaultsRecord? defaults,
    @JsonKey(name: 'pendingInvites') @Default(0) int pendingInvites,
    @JsonKey(name: 'blockedCount') @Default(0) int blockedCount,
    @JsonKey(name: 'deletion') FamilyDeletionRecord? deletion,
  }) = _PrivacyOverviewRecord;

  factory PrivacyOverviewRecord.fromJson(Map<String, dynamic> json) =>
      _$PrivacyOverviewRecordFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class PrivacyDefaultsRecord with _$PrivacyDefaultsRecord {
  @JsonSerializable(explicitToJson: true)
  const factory PrivacyDefaultsRecord({
    @JsonKey(name: 'defaultVisibility') String? defaultVisibility,
    @JsonKey(name: 'requireCircleReview') bool? requireCircleReview,
  }) = _PrivacyDefaultsRecord;

  factory PrivacyDefaultsRecord.fromJson(Map<String, dynamic> json) =>
      _$PrivacyDefaultsRecordFromJson(json);
}
