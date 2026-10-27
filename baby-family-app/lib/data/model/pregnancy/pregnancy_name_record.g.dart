// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pregnancy_name_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PregnancyNameRecord _$PregnancyNameRecordFromJson(Map<String, dynamic> json) =>
    _PregnancyNameRecord(
      id: json['id'] as String?,
      name: json['name'] as String?,
      meaning: json['meaning'] as String?,
      addedByUserId: json['addedByUserId'] as String?,
      likedByMe: json['likedByMe'] as bool? ?? false,
      likedByPartner: json['likedByPartner'] as bool? ?? false,
      chosen: json['chosen'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PregnancyNameRecordToJson(
  _PregnancyNameRecord instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'meaning': instance.meaning,
  'addedByUserId': instance.addedByUserId,
  'likedByMe': instance.likedByMe,
  'likedByPartner': instance.likedByPartner,
  'chosen': instance.chosen,
  'createdAt': instance.createdAt?.toIso8601String(),
};

_PregnancyNameList _$PregnancyNameListFromJson(Map<String, dynamic> json) =>
    _PregnancyNameList(
      items: json['items'] == null
          ? const <PregnancyNameRecord>[]
          : _nameItems(json['items']),
      chosenLimit: (json['chosenLimit'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$PregnancyNameListToJson(_PregnancyNameList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'chosenLimit': instance.chosenLimit,
    };
