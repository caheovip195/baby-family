// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_bootstrap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilyBootstrap _$FamilyBootstrapFromJson(Map<String, dynamic> json) =>
    _FamilyBootstrap(
      family: json['family'] == null
          ? null
          : BootstrapFamily.fromJson(json['family'] as Map<String, dynamic>),
      me: json['me'] == null
          ? null
          : BootstrapParent.fromJson(json['me'] as Map<String, dynamic>),
      parents:
          (json['parents'] as List<dynamic>?)
              ?.map((e) => BootstrapParent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <BootstrapParent>[],
      coupleLinked: json['coupleLinked'] as bool? ?? false,
      subjects:
          (json['subjects'] as List<dynamic>?)
              ?.map((e) => BootstrapSubject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <BootstrapSubject>[],
      entitlement: json['entitlement'] == null
          ? null
          : BootstrapEntitlement.fromJson(
              json['entitlement'] as Map<String, dynamic>,
            ),
      accessVersion: (json['accessVersion'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FamilyBootstrapToJson(_FamilyBootstrap instance) =>
    <String, dynamic>{
      'family': instance.family?.toJson(),
      'me': instance.me?.toJson(),
      'parents': instance.parents.map((e) => e.toJson()).toList(),
      'coupleLinked': instance.coupleLinked,
      'subjects': instance.subjects.map((e) => e.toJson()).toList(),
      'entitlement': instance.entitlement?.toJson(),
      'accessVersion': instance.accessVersion,
    };
