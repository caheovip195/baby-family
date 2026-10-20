// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_template_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionTemplateList _$MissionTemplateListFromJson(Map<String, dynamic> json) =>
    _MissionTemplateList(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) =>
                    MissionTemplateRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <MissionTemplateRecord>[],
    );

Map<String, dynamic> _$MissionTemplateListToJson(
  _MissionTemplateList instance,
) => <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
