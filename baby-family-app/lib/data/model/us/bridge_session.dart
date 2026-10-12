import 'package:baby_family/data/model/us/bridge_next_step.dart';
import 'package:baby_family/data/model/us/bridge_share.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bridge_session.freezed.dart';
part 'bridge_session.g.dart';

/// Phiên Cầu nối (US-08…12) — chỉ Papa & Mama thấy; tự xoá sau `retentionDays`.
@Freezed(when: FreezedWhenOptions.none)
abstract class BridgeSession with _$BridgeSession {
  @JsonSerializable(explicitToJson: true)
  const factory BridgeSession({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'status') @Default(BridgeStatus.draft) BridgeStatus status,
    @JsonKey(name: 'initiatorUserId') required String initiatorUserId,
    @JsonKey(name: 'startedAt') DateTime? startedAt,
    @JsonKey(name: 'wizardStep') @Default(1) int wizardStep,
    @JsonKey(name: 'privateNote') String? privateNote,
    @JsonKey(name: 'shares') @Default([]) List<BridgeShare> shares,
    @JsonKey(name: 'nextStep') BridgeNextStep? nextStep,
    @JsonKey(name: 'closeAgreedUserIds')
    @Default([])
    List<String> closeAgreedUserIds,
    @JsonKey(name: 'retentionDays') @Default(30) int retentionDays,
  }) = _BridgeSession;

  factory BridgeSession.fromJson(Map<String, dynamic> json) =>
      _$BridgeSessionFromJson(json);
}
