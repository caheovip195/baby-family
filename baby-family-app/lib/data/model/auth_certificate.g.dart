// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_certificate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthCertificate _$AuthCertificateFromJson(Map<String, dynamic> json) =>
    _AuthCertificate(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      expiresIn: (json['expiresIn'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      expiredAccessTokenDateTime: json['expiredAccessTokenDateTime'] == null
          ? null
          : DateTime.parse(json['expiredAccessTokenDateTime'] as String),
    );

Map<String, dynamic> _$AuthCertificateToJson(_AuthCertificate instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
      'user': instance.user?.toJson(),
      'expiredAccessTokenDateTime': instance.expiredAccessTokenDateTime
          ?.toIso8601String(),
    };
