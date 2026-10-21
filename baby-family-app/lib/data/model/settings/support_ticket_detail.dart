import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_ticket_detail.freezed.dart';
part 'support_ticket_detail.g.dart';

/// `GET /v1/support/tickets/{id}`: nội dung người gửi + trao đổi với CSKH.
@Freezed(when: FreezedWhenOptions.none)
abstract class SupportTicketDetail with _$SupportTicketDetail {
  @JsonSerializable(explicitToJson: true)
  const factory SupportTicketDetail({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'category') String? category,
    @JsonKey(name: 'subject') @Default('') String subject,
    @JsonKey(name: 'body') @Default('') String body,
    @JsonKey(name: 'messages')
    @Default(<SupportMessage>[])
    List<SupportMessage> messages,
  }) = _SupportTicketDetail;

  factory SupportTicketDetail.fromJson(Map<String, dynamic> json) =>
      _$SupportTicketDetailFromJson(json);
}

/// Một tin trong ticket: `sender` USER | SUPPORT.
@Freezed(when: FreezedWhenOptions.none)
abstract class SupportMessage with _$SupportMessage {
  @JsonSerializable(explicitToJson: true)
  const factory SupportMessage({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'sender') String? sender,
    @JsonKey(name: 'body') @Default('') String body,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  }) = _SupportMessage;

  factory SupportMessage.fromJson(Map<String, dynamic> json) =>
      _$SupportMessageFromJson(json);
}
