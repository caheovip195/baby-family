// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_ticket_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupportTicketDetail _$SupportTicketDetailFromJson(Map<String, dynamic> json) =>
    _SupportTicketDetail(
      id: json['id'] as String?,
      code: json['code'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      category: json['category'] as String?,
      subject: json['subject'] as String? ?? '',
      body: json['body'] as String? ?? '',
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => SupportMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SupportMessage>[],
    );

Map<String, dynamic> _$SupportTicketDetailToJson(
  _SupportTicketDetail instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'status': instance.status,
  'createdAt': instance.createdAt?.toIso8601String(),
  'category': instance.category,
  'subject': instance.subject,
  'body': instance.body,
  'messages': instance.messages.map((e) => e.toJson()).toList(),
};

_SupportMessage _$SupportMessageFromJson(Map<String, dynamic> json) =>
    _SupportMessage(
      id: json['id'] as String?,
      sender: json['sender'] as String?,
      body: json['body'] as String? ?? '',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SupportMessageToJson(_SupportMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'body': instance.body,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
