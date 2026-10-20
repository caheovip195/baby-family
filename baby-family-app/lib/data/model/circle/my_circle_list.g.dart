// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_circle_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyCircleList _$MyCircleListFromJson(Map<String, dynamic> json) =>
    _MyCircleList(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => MyCircleRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MyCircleRecord>[],
    );

Map<String, dynamic> _$MyCircleListToJson(_MyCircleList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
