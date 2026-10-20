// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_dispatch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OtpDispatch _$OtpDispatchFromJson(Map<String, dynamic> json) => _OtpDispatch(
  expiresIn: (json['expiresIn'] as num?)?.toInt(),
  resendIn: (json['resendIn'] as num?)?.toInt(),
  channelUsed: json['channelUsed'] as String?,
);

Map<String, dynamic> _$OtpDispatchToJson(_OtpDispatch instance) =>
    <String, dynamic>{
      'expiresIn': instance.expiresIn,
      'resendIn': instance.resendIn,
      'channelUsed': instance.channelUsed,
    };
