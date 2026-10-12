// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_checkin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MoodCheckin _$MoodCheckinFromJson(Map<String, dynamic> json) => _MoodCheckin(
  id: json['id'] as String,
  userId: json['userId'] as String,
  mood: $enumDecode(_$MoodCodeEnumMap, json['mood']),
  energy: (json['energy'] as num?)?.toInt() ?? 3,
  needs:
      (json['needs'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$CoupleNeedEnumMap, e))
          .toList() ??
      const [],
  needMinutes: (json['needMinutes'] as num?)?.toInt(),
  note: json['note'] as String?,
  shared: json['shared'] as bool? ?? true,
  createdAt: DateTime.parse(json['createdAt'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$MoodCheckinToJson(_MoodCheckin instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'mood': _$MoodCodeEnumMap[instance.mood]!,
      'energy': instance.energy,
      'needs': instance.needs.map((e) => _$CoupleNeedEnumMap[e]!).toList(),
      'needMinutes': instance.needMinutes,
      'note': instance.note,
      'shared': instance.shared,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

const _$MoodCodeEnumMap = {
  MoodCode.ok: 'ok',
  MoodCode.normal: 'normal',
  MoodCode.tired: 'tired',
  MoodCode.exhausted: 'exhausted',
  MoodCode.stressed: 'stressed',
  MoodCode.sad: 'sad',
  MoodCode.annoyed: 'annoyed',
  MoodCode.overwhelmed: 'overwhelmed',
  MoodCode.lonely: 'lonely',
  MoodCode.missYou: 'missYou',
};

const _$CoupleNeedEnumMap = {
  CoupleNeed.rest: 'rest',
  CoupleNeed.childcare: 'childcare',
  CoupleNeed.quiet: 'quiet',
  CoupleNeed.hug: 'hug',
  CoupleNeed.talk: 'talk',
  CoupleNeed.encouragement: 'encouragement',
};
