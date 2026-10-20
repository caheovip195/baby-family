// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_overview_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrivacyOverviewRecord _$PrivacyOverviewRecordFromJson(
  Map<String, dynamic> json,
) => _PrivacyOverviewRecord(
  defaults: json['defaults'] == null
      ? null
      : PrivacyDefaultsRecord.fromJson(
          json['defaults'] as Map<String, dynamic>,
        ),
  pendingInvites: (json['pendingInvites'] as num?)?.toInt() ?? 0,
  blockedCount: (json['blockedCount'] as num?)?.toInt() ?? 0,
  deletion: json['deletion'] == null
      ? null
      : FamilyDeletionRecord.fromJson(json['deletion'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PrivacyOverviewRecordToJson(
  _PrivacyOverviewRecord instance,
) => <String, dynamic>{
  'defaults': instance.defaults?.toJson(),
  'pendingInvites': instance.pendingInvites,
  'blockedCount': instance.blockedCount,
  'deletion': instance.deletion?.toJson(),
};

_PrivacyDefaultsRecord _$PrivacyDefaultsRecordFromJson(
  Map<String, dynamic> json,
) => _PrivacyDefaultsRecord(
  defaultVisibility: json['defaultVisibility'] as String?,
  requireCircleReview: json['requireCircleReview'] as bool?,
);

Map<String, dynamic> _$PrivacyDefaultsRecordToJson(
  _PrivacyDefaultsRecord instance,
) => <String, dynamic>{
  'defaultVisibility': instance.defaultVisibility,
  'requireCircleReview': instance.requireCircleReview,
};
