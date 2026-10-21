// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_family_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyFamilyRecord _$MyFamilyRecordFromJson(Map<String, dynamic> json) =>
    _MyFamilyRecord(
      familyId: json['familyId'] as String?,
      name: json['name'] as String?,
      role: json['role'] as String?,
      status: json['status'] == null
          ? null
          : MyFamilyStatusRecord.fromJson(
              json['status'] as Map<String, dynamic>,
            ),
      coverUrl: json['coverUrl'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$MyFamilyRecordToJson(_MyFamilyRecord instance) =>
    <String, dynamic>{
      'familyId': instance.familyId,
      'name': instance.name,
      'role': instance.role,
      'status': instance.status?.toJson(),
      'coverUrl': instance.coverUrl,
      'isDefault': instance.isDefault,
    };

_MyFamilyStatusRecord _$MyFamilyStatusRecordFromJson(
  Map<String, dynamic> json,
) => _MyFamilyStatusRecord(
  family: json['family'] as String?,
  membership: json['membership'] as String?,
);

Map<String, dynamic> _$MyFamilyStatusRecordToJson(
  _MyFamilyStatusRecord instance,
) => <String, dynamic>{
  'family': instance.family,
  'membership': instance.membership,
};

_MyFamilyList _$MyFamilyListFromJson(Map<String, dynamic> json) =>
    _MyFamilyList(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => MyFamilyRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MyFamilyRecord>[],
    );

Map<String, dynamic> _$MyFamilyListToJson(_MyFamilyList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
