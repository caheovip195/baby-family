// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignInMethod _$SignInMethodFromJson(Map<String, dynamic> json) =>
    _SignInMethod(
      method: $enumDecode(_$AuthMethodEnumMap, json['method']),
      linked: json['linked'] as bool? ?? false,
      maskedAccount: json['maskedAccount'] as String?,
    );

Map<String, dynamic> _$SignInMethodToJson(_SignInMethod instance) =>
    <String, dynamic>{
      'method': _$AuthMethodEnumMap[instance.method]!,
      'linked': instance.linked,
      'maskedAccount': instance.maskedAccount,
    };

const _$AuthMethodEnumMap = {
  AuthMethod.apple: 'apple',
  AuthMethod.google: 'google',
  AuthMethod.phone: 'phone',
};
