// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_tree_today_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilyTreeTodayRecord _$FamilyTreeTodayRecordFromJson(
  Map<String, dynamic> json,
) => _FamilyTreeTodayRecord(
  leaves: (json['leaves'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num?)?.toInt() ?? 0,
  bloomed: json['bloomed'] as bool? ?? false,
);

Map<String, dynamic> _$FamilyTreeTodayRecordToJson(
  _FamilyTreeTodayRecord instance,
) => <String, dynamic>{
  'leaves': instance.leaves,
  'total': instance.total,
  'bloomed': instance.bloomed,
};
