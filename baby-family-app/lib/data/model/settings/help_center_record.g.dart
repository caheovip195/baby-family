// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_center_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HelpCenterRecord _$HelpCenterRecordFromJson(Map<String, dynamic> json) =>
    _HelpCenterRecord(
      version: (json['version'] as num?)?.toInt(),
      faqs:
          (json['faqs'] as List<dynamic>?)
              ?.map((e) => HelpFaqRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <HelpFaqRecord>[],
      contact: json['contact'] == null
          ? null
          : HelpContactRecord.fromJson(json['contact'] as Map<String, dynamic>),
      legal: json['legal'] == null
          ? null
          : HelpLegalRecord.fromJson(json['legal'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HelpCenterRecordToJson(_HelpCenterRecord instance) =>
    <String, dynamic>{
      'version': instance.version,
      'faqs': instance.faqs.map((e) => e.toJson()).toList(),
      'contact': instance.contact?.toJson(),
      'legal': instance.legal?.toJson(),
    };

_HelpFaqRecord _$HelpFaqRecordFromJson(Map<String, dynamic> json) =>
    _HelpFaqRecord(
      id: json['id'] as String?,
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
    );

Map<String, dynamic> _$HelpFaqRecordToJson(_HelpFaqRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
    };

_HelpContactRecord _$HelpContactRecordFromJson(Map<String, dynamic> json) =>
    _HelpContactRecord(
      email: json['email'] as String?,
      hotline: json['hotline'] as String?,
    );

Map<String, dynamic> _$HelpContactRecordToJson(_HelpContactRecord instance) =>
    <String, dynamic>{'email': instance.email, 'hotline': instance.hotline};

_HelpLegalRecord _$HelpLegalRecordFromJson(Map<String, dynamic> json) =>
    _HelpLegalRecord(
      termsUrl: json['termsUrl'] as String?,
      privacyUrl: json['privacyUrl'] as String?,
      licensesUrl: json['licensesUrl'] as String?,
    );

Map<String, dynamic> _$HelpLegalRecordToJson(_HelpLegalRecord instance) =>
    <String, dynamic>{
      'termsUrl': instance.termsUrl,
      'privacyUrl': instance.privacyUrl,
      'licensesUrl': instance.licensesUrl,
    };
