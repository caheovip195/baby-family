import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_intent_record.freezed.dart';
part 'purchase_intent_record.g.dart';

/// `POST /v1/families/{fid}/purchase-intents`: mã Store và token gắn với lần
/// mua (App Store: appAccountToken; Play: obfuscatedAccountId).
@Freezed(when: FreezedWhenOptions.none)
abstract class PurchaseIntentRecord with _$PurchaseIntentRecord {
  @JsonSerializable(explicitToJson: true)
  const factory PurchaseIntentRecord({
    @JsonKey(name: 'intentId') String? intentId,
    @JsonKey(name: 'productId') String? productId,
    @JsonKey(name: 'appAccountToken') String? appAccountToken,
    @JsonKey(name: 'obfuscatedAccountId') String? obfuscatedAccountId,
  }) = _PurchaseIntentRecord;

  factory PurchaseIntentRecord.fromJson(Map<String, dynamic> json) =>
      _$PurchaseIntentRecordFromJson(json);
}
