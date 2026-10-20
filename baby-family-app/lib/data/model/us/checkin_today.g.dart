// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_today.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CheckinToday _$CheckinTodayFromJson(Map<String, dynamic> json) =>
    _CheckinToday(
      mine: json['mine'] == null
          ? null
          : CheckinRecord.fromJson(json['mine'] as Map<String, dynamic>),
      partner: json['partner'] == null
          ? null
          : CheckinRecord.fromJson(json['partner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckinTodayToJson(_CheckinToday instance) =>
    <String, dynamic>{
      'mine': instance.mine?.toJson(),
      'partner': instance.partner?.toJson(),
    };
