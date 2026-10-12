// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Child _$ChildFromJson(Map<String, dynamic> json) => _Child(
  id: json['id'] as String,
  familyId: json['familyId'] as String,
  name: json['name'] as String,
  nickname: json['nickname'] as String?,
  kind: $enumDecodeNullable(_$ChildKindEnumMap, json['kind']) ?? ChildKind.baby,
  birthDate: json['birthDate'] == null
      ? null
      : DateTime.parse(json['birthDate'] as String),
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  colorIndex: (json['colorIndex'] as num?)?.toInt() ?? 0,
  avatarAsset: json['avatarAsset'] as String?,
  coverAsset: json['coverAsset'] as String?,
  gender:
      $enumDecodeNullable(_$ChildGenderEnumMap, json['gender']) ??
      ChildGender.unknown,
  archived: json['archived'] as bool? ?? false,
  carrierUserId: json['carrierUserId'] as String?,
  pregnancyOrder: (json['pregnancyOrder'] as num?)?.toInt(),
  babyCount: (json['babyCount'] as num?)?.toInt() ?? 1,
  lunarBirthDay: (json['lunarBirthDay'] as num?)?.toInt(),
  lunarBirthMonth: (json['lunarBirthMonth'] as num?)?.toInt(),
  birthWeightKg: (json['birthWeightKg'] as num?)?.toDouble(),
  birthHeightCm: (json['birthHeightCm'] as num?)?.toDouble(),
  birthTime: json['birthTime'] as String?,
  archivedAt: json['archivedAt'] == null
      ? null
      : DateTime.parse(json['archivedAt'] as String),
);

Map<String, dynamic> _$ChildToJson(_Child instance) => <String, dynamic>{
  'id': instance.id,
  'familyId': instance.familyId,
  'name': instance.name,
  'nickname': instance.nickname,
  'kind': _$ChildKindEnumMap[instance.kind]!,
  'birthDate': instance.birthDate?.toIso8601String(),
  'dueDate': instance.dueDate?.toIso8601String(),
  'colorIndex': instance.colorIndex,
  'avatarAsset': instance.avatarAsset,
  'coverAsset': instance.coverAsset,
  'gender': _$ChildGenderEnumMap[instance.gender]!,
  'archived': instance.archived,
  'carrierUserId': instance.carrierUserId,
  'pregnancyOrder': instance.pregnancyOrder,
  'babyCount': instance.babyCount,
  'lunarBirthDay': instance.lunarBirthDay,
  'lunarBirthMonth': instance.lunarBirthMonth,
  'birthWeightKg': instance.birthWeightKg,
  'birthHeightCm': instance.birthHeightCm,
  'birthTime': instance.birthTime,
  'archivedAt': instance.archivedAt?.toIso8601String(),
};

const _$ChildKindEnumMap = {
  ChildKind.baby: 'baby',
  ChildKind.pregnancy: 'pregnancy',
};

const _$ChildGenderEnumMap = {
  ChildGender.boy: 'boy',
  ChildGender.girl: 'girl',
  ChildGender.unknown: 'unknown',
};
