import 'package:baby_family/data/model/settings/support_ticket.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_ticket_list.freezed.dart';
part 'support_ticket_list.g.dart';

/// `{items, nextOffset}`.
@Freezed(when: FreezedWhenOptions.none)
abstract class SupportTicketList with _$SupportTicketList {
  @JsonSerializable(explicitToJson: true)
  const factory SupportTicketList({
    @JsonKey(name: 'items')
    @Default(<SupportTicket>[])
    List<SupportTicket> items,
    @JsonKey(name: 'nextOffset') int? nextOffset,
  }) = _SupportTicketList;

  factory SupportTicketList.fromJson(Map<String, dynamic> json) =>
      _$SupportTicketListFromJson(json);
}
