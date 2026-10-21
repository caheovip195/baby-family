// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_intent_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PurchaseIntentRecord _$PurchaseIntentRecordFromJson(
  Map<String, dynamic> json,
) => _PurchaseIntentRecord(
  intentId: json['intentId'] as String?,
  productId: json['productId'] as String?,
  appAccountToken: json['appAccountToken'] as String?,
  obfuscatedAccountId: json['obfuscatedAccountId'] as String?,
);

Map<String, dynamic> _$PurchaseIntentRecordToJson(
  _PurchaseIntentRecord instance,
) => <String, dynamic>{
  'intentId': instance.intentId,
  'productId': instance.productId,
  'appAccountToken': instance.appAccountToken,
  'obfuscatedAccountId': instance.obfuscatedAccountId,
};
