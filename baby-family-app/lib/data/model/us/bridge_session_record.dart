import 'package:baby_family/utils/helper/lenient_json.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bridge_session_record.freezed.dart';
part 'bridge_session_record.g.dart';

/// Phiên Cầu nối từ server (`/families/{id}/us/bridges`, BF-20261028-008):
/// chỉ các ý đã chọn chia sẻ — nháp riêng không lên server.
@Freezed(when: FreezedWhenOptions.none)
abstract class BridgeSessionRecord with _$BridgeSessionRecord {
  @JsonSerializable(explicitToJson: true)
  const factory BridgeSessionRecord({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'initiatorUserId') String? initiatorUserId,
    @JsonKey(name: 'startedAt') DateTime? startedAt,
    @JsonKey(name: 'retentionDays') @Default(30) int retentionDays,
    @JsonKey(name: 'contentPurged') @Default(false) bool contentPurged,
    @JsonKey(name: 'shares', fromJson: _bridgeShares)
    @Default(<BridgeShareRecord>[])
    List<BridgeShareRecord> shares,
    @JsonKey(name: 'nextStep') BridgeNextStepRecord? nextStep,
    @JsonKey(name: 'closeAgreedUserIds')
    @Default(<String>[])
    List<String> closeAgreedUserIds,
  }) = _BridgeSessionRecord;

  factory BridgeSessionRecord.fromJson(Map<String, dynamic> json) =>
      _$BridgeSessionRecordFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class BridgeShareRecord with _$BridgeShareRecord {
  @JsonSerializable(explicitToJson: true)
  const factory BridgeShareRecord({
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'feelings') @Default(<String>[]) List<String> feelings,
    @JsonKey(name: 'needs') @Default(<String>[]) List<String> needs,
    @JsonKey(name: 'topic') String? topic,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'understood') @Default(false) bool understood,
  }) = _BridgeShareRecord;

  factory BridgeShareRecord.fromJson(Map<String, dynamic> json) =>
      _$BridgeShareRecordFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class BridgeNextStepRecord with _$BridgeNextStepRecord {
  @JsonSerializable(explicitToJson: true)
  const factory BridgeNextStepRecord({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'text') String? text,
    @JsonKey(name: 'at') DateTime? at,
    @JsonKey(name: 'agreedUserIds')
    @Default(<String>[])
    List<String> agreedUserIds,
  }) = _BridgeNextStepRecord;

  factory BridgeNextStepRecord.fromJson(Map<String, dynamic> json) =>
      _$BridgeNextStepRecordFromJson(json);
}

List<BridgeShareRecord> _bridgeShares(Object? json) =>
    lenientList(json, BridgeShareRecord.fromJson, label: 'ý Cầu nối');

/// Danh sách phiên: phiên không đọc được bị bỏ qua.
List<BridgeSessionRecord> bridgeSessionList(Object? json) =>
    lenientList(json, BridgeSessionRecord.fromJson, label: 'phiên Cầu nối');
