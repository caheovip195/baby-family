// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupportTicket _$SupportTicketFromJson(Map<String, dynamic> json) =>
    _SupportTicket(
      id: json['id'] as String?,
      code: json['code'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SupportTicketToJson(_SupportTicket instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
