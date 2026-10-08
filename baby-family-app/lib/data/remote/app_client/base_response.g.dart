// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthCertificateRespond _$AuthCertificateRespondFromJson(
  Map<String, dynamic> json,
) => AuthCertificateRespond(
  auth: json['data'] == null
      ? null
      : AuthCertificate.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$AuthCertificateRespondToJson(
  AuthCertificateRespond instance,
) => <String, dynamic>{'data': instance.auth, 'runtimeType': instance.$type};

UserRespond _$UserRespondFromJson(Map<String, dynamic> json) => UserRespond(
  user: json['data'] == null
      ? null
      : User.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$UserRespondToJson(UserRespond instance) =>
    <String, dynamic>{'data': instance.user, 'runtimeType': instance.$type};
