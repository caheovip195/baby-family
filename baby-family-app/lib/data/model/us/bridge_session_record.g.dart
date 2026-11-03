// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bridge_session_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BridgeSessionRecord _$BridgeSessionRecordFromJson(Map<String, dynamic> json) =>
    _BridgeSessionRecord(
      id: json['id'] as String,
      status: json['status'] as String?,
      initiatorUserId: json['initiatorUserId'] as String?,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      retentionDays: (json['retentionDays'] as num?)?.toInt() ?? 30,
      contentPurged: json['contentPurged'] as bool? ?? false,
      shares: json['shares'] == null
          ? const <BridgeShareRecord>[]
          : _bridgeShares(json['shares']),
      nextStep: json['nextStep'] == null
          ? null
          : BridgeNextStepRecord.fromJson(
              json['nextStep'] as Map<String, dynamic>,
            ),
      closeAgreedUserIds:
          (json['closeAgreedUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$BridgeSessionRecordToJson(
  _BridgeSessionRecord instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'initiatorUserId': instance.initiatorUserId,
  'startedAt': instance.startedAt?.toIso8601String(),
  'retentionDays': instance.retentionDays,
  'contentPurged': instance.contentPurged,
  'shares': instance.shares.map((e) => e.toJson()).toList(),
  'nextStep': instance.nextStep?.toJson(),
  'closeAgreedUserIds': instance.closeAgreedUserIds,
};

_BridgeShareRecord _$BridgeShareRecordFromJson(Map<String, dynamic> json) =>
    _BridgeShareRecord(
      userId: json['userId'] as String,
      feelings:
          (json['feelings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      needs:
          (json['needs'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      topic: json['topic'] as String?,
      message: json['message'] as String?,
      understood: json['understood'] as bool? ?? false,
    );

Map<String, dynamic> _$BridgeShareRecordToJson(_BridgeShareRecord instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'feelings': instance.feelings,
      'needs': instance.needs,
      'topic': instance.topic,
      'message': instance.message,
      'understood': instance.understood,
    };

_BridgeNextStepRecord _$BridgeNextStepRecordFromJson(
  Map<String, dynamic> json,
) => _BridgeNextStepRecord(
  code: json['code'] as String,
  text: json['text'] as String?,
  at: json['at'] == null ? null : DateTime.parse(json['at'] as String),
  agreedUserIds:
      (json['agreedUserIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$BridgeNextStepRecordToJson(
  _BridgeNextStepRecord instance,
) => <String, dynamic>{
  'code': instance.code,
  'text': instance.text,
  'at': instance.at?.toIso8601String(),
  'agreedUserIds': instance.agreedUserIds,
};
