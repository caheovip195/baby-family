// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bootstrap_subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BootstrapSubject _$BootstrapSubjectFromJson(Map<String, dynamic> json) =>
    _BootstrapSubject(
      type: json['type'] as String?,
      id: json['id'] as String?,
      displayName: json['displayName'] as String?,
      name: json['name'] as String?,
      nickname: json['nickname'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      colorIndex: (json['colorIndex'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      expectedCount: (json['expectedCount'] as num?)?.toInt(),
      seqNo: (json['seqNo'] as num?)?.toInt(),
      status: json['status'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
    );

Map<String, dynamic> _$BootstrapSubjectToJson(_BootstrapSubject instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'displayName': instance.displayName,
      'name': instance.name,
      'nickname': instance.nickname,
      'birthDate': instance.birthDate?.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'colorIndex': instance.colorIndex,
      'gender': instance.gender,
      'expectedCount': instance.expectedCount,
      'seqNo': instance.seqNo,
      'status': instance.status,
      'avatarUrl': instance.avatarUrl,
      'coverUrl': instance.coverUrl,
    };
