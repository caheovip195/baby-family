import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_ticket.freezed.dart';
part 'support_ticket.g.dart';

/// Yêu cầu hỗ trợ đã gửi (`/v1/me/support/tickets`): mã tra cứu, trạng thái
/// OPEN | IN_PROGRESS | WAITING_USER | RESOLVED | CLOSED.
@Freezed(when: FreezedWhenOptions.none)
abstract class SupportTicket with _$SupportTicket {
  @JsonSerializable(explicitToJson: true)
  const factory SupportTicket({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  }) = _SupportTicket;

  factory SupportTicket.fromJson(Map<String, dynamic> json) =>
      _$SupportTicketFromJson(json);
}
