// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_created.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestCreated _$RequestCreatedFromJson(Map<String, dynamic> json) =>
    _RequestCreated(
      request: json['request'] == null
          ? null
          : RequestRecord.fromJson(json['request'] as Map<String, dynamic>),
      openCount: (json['openCount'] as num?)?.toInt(),
      openLimit: (json['openLimit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RequestCreatedToJson(_RequestCreated instance) =>
    <String, dynamic>{
      'request': instance.request?.toJson(),
      'openCount': instance.openCount,
      'openLimit': instance.openLimit,
    };
