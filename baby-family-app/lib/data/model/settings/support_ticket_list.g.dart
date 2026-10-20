// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_ticket_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupportTicketList _$SupportTicketListFromJson(Map<String, dynamic> json) =>
    _SupportTicketList(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => SupportTicket.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SupportTicket>[],
      nextOffset: (json['nextOffset'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SupportTicketListToJson(_SupportTicketList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextOffset': instance.nextOffset,
    };
