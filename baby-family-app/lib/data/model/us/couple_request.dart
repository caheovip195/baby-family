import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'couple_request.freezed.dart';
part 'couple_request.g.dart';

/// Lời nhờ (US-03/04, mục 7.16.2).
@Freezed(when: FreezedWhenOptions.none)
abstract class CoupleRequest with _$CoupleRequest {
  @JsonSerializable(explicitToJson: true)
  const factory CoupleRequest({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'kind') @Default(RequestKind.task) RequestKind kind,
    @JsonKey(name: 'templateCode') String? templateCode,
    @JsonKey(name: 'needCode') CoupleNeed? needCode,
    @JsonKey(name: 'title') @Default('') String title,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'childIds') @Default([]) List<String> childIds,
    @JsonKey(name: 'dueLabel') String? dueLabel,
    @JsonKey(name: 'dueAt') DateTime? dueAt,
    @JsonKey(name: 'durationMin') int? durationMin,
    @JsonKey(name: 'urgency')
    @Default(RequestUrgency.normal)
    RequestUrgency urgency,
    @JsonKey(name: 'status') @Default(RequestStatus.sent) RequestStatus status,
    @JsonKey(name: 'senderId') required String senderId,
    @JsonKey(name: 'receiverId') required String receiverId,
    @JsonKey(name: 'volunteered') @Default(false) bool volunteered,
    @JsonKey(name: 'declineReason') String? declineReason,
    @JsonKey(name: 'sentAt') required DateTime sentAt,
    @JsonKey(name: 'seenAt') DateTime? seenAt,
    @JsonKey(name: 'acceptedAt') DateTime? acceptedAt,
    @JsonKey(name: 'doneAt') DateTime? doneAt,
    @JsonKey(name: 'declinedAt') DateTime? declinedAt,
    @JsonKey(name: 'remindAt') DateTime? remindAt,
  }) = _CoupleRequest;

  factory CoupleRequest.fromJson(Map<String, dynamic> json) =>
      _$CoupleRequestFromJson(json);
}
