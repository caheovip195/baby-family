// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestList _$RequestListFromJson(Map<String, dynamic> json) => _RequestList(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => RequestRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <RequestRecord>[],
  nextCursor: json['nextCursor'] as String?,
);

Map<String, dynamic> _$RequestListToJson(_RequestList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
    };
