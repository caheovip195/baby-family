// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couple_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoupleSettings _$CoupleSettingsFromJson(Map<String, dynamic> json) =>
    _CoupleSettings(
      checkinShareMode:
          $enumDecodeNullable(
            _$CheckinShareModeEnumMap,
            json['checkinShareMode'],
          ) ??
          CheckinShareMode.askEachTime,
      hideOnLockScreen: json['hideOnLockScreen'] as bool? ?? true,
      faceIdLock: json['faceIdLock'] as bool? ?? false,
      urgentBypassQuiet: json['urgentBypassQuiet'] as bool? ?? false,
      quietFrom: json['quietFrom'] as String? ?? '22:00',
      quietTo: json['quietTo'] as String? ?? '06:30',
      bridgeRetentionDays: (json['bridgeRetentionDays'] as num?)?.toInt() ?? 30,
      journalFaceIdLock: json['journalFaceIdLock'] as bool? ?? true,
    );

Map<String, dynamic> _$CoupleSettingsToJson(_CoupleSettings instance) =>
    <String, dynamic>{
      'checkinShareMode': _$CheckinShareModeEnumMap[instance.checkinShareMode]!,
      'hideOnLockScreen': instance.hideOnLockScreen,
      'faceIdLock': instance.faceIdLock,
      'urgentBypassQuiet': instance.urgentBypassQuiet,
      'quietFrom': instance.quietFrom,
      'quietTo': instance.quietTo,
      'bridgeRetentionDays': instance.bridgeRetentionDays,
      'journalFaceIdLock': instance.journalFaceIdLock,
    };

const _$CheckinShareModeEnumMap = {
  CheckinShareMode.askEachTime: 'askEachTime',
  CheckinShareMode.alwaysShare: 'alwaysShare',
  CheckinShareMode.alwaysPrivate: 'alwaysPrivate',
};
