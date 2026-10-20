// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perspective_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PerspectiveList _$PerspectiveListFromJson(Map<String, dynamic> json) =>
    _PerspectiveList(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => PerspectiveRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <PerspectiveRecord>[],
    );

Map<String, dynamic> _$PerspectiveListToJson(_PerspectiveList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
