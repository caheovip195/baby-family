// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prep_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrepItem _$PrepItemFromJson(Map<String, dynamic> json) => _PrepItem(
  id: json['id'] as String,
  pregnancyId: json['pregnancyId'] as String,
  group:
      $enumDecodeNullable(_$PrepGroupEnumMap, json['group']) ?? PrepGroup.bag,
  title: json['title'] as String,
  done: json['done'] as bool? ?? false,
  ownerKind: $enumDecodeNullable(_$MissionOwnerKindEnumMap, json['ownerKind']),
  requestedFromPartner: json['requestedFromPartner'] as bool? ?? false,
  isCustom: json['isCustom'] as bool? ?? false,
);

Map<String, dynamic> _$PrepItemToJson(_PrepItem instance) => <String, dynamic>{
  'id': instance.id,
  'pregnancyId': instance.pregnancyId,
  'group': _$PrepGroupEnumMap[instance.group]!,
  'title': instance.title,
  'done': instance.done,
  'ownerKind': _$MissionOwnerKindEnumMap[instance.ownerKind],
  'requestedFromPartner': instance.requestedFromPartner,
  'isCustom': instance.isCustom,
};

const _$PrepGroupEnumMap = {
  PrepGroup.bag: 'bag',
  PrepGroup.papers: 'papers',
  PrepGroup.nursery: 'nursery',
  PrepGroup.health: 'health',
};

const _$MissionOwnerKindEnumMap = {
  MissionOwnerKind.me: 'me',
  MissionOwnerKind.partner: 'partner',
  MissionOwnerKind.together: 'together',
};
