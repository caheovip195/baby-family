// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_tree_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilyTreeRecord _$FamilyTreeRecordFromJson(Map<String, dynamic> json) =>
    _FamilyTreeRecord(
      level: (json['level'] as num?)?.toInt() ?? 1,
      levelName: json['levelName'] as String?,
      progressPercent: (json['progressPercent'] as num?)?.toInt() ?? 0,
      fruits: (json['fruits'] as num?)?.toInt() ?? 0,
      flowers: (json['flowers'] as num?)?.toInt() ?? 0,
      bloomedDaysThisWeek: (json['bloomedDaysThisWeek'] as num?)?.toInt() ?? 0,
      today: json['today'] == null
          ? null
          : FamilyTreeTodayRecord.fromJson(
              json['today'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$FamilyTreeRecordToJson(_FamilyTreeRecord instance) =>
    <String, dynamic>{
      'level': instance.level,
      'levelName': instance.levelName,
      'progressPercent': instance.progressPercent,
      'fruits': instance.fruits,
      'flowers': instance.flowers,
      'bloomedDaysThisWeek': instance.bloomedDaysThisWeek,
      'today': instance.today?.toJson(),
    };
