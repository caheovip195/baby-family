// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HelpInfo _$HelpInfoFromJson(Map<String, dynamic> json) => _HelpInfo(
  faqs:
      (json['faqs'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  openReports: (json['openReports'] as num?)?.toInt() ?? 0,
  email: json['email'] as String? ?? '',
  hotline: json['hotline'] as String? ?? '',
);

Map<String, dynamic> _$HelpInfoToJson(_HelpInfo instance) => <String, dynamic>{
  'faqs': instance.faqs,
  'openReports': instance.openReports,
  'email': instance.email,
  'hotline': instance.hotline,
};
