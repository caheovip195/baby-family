// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_intent_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PurchaseIntentRecord {

@JsonKey(name: 'intentId') String? get intentId;@JsonKey(name: 'productId') String? get productId;@JsonKey(name: 'appAccountToken') String? get appAccountToken;@JsonKey(name: 'obfuscatedAccountId') String? get obfuscatedAccountId;
/// Create a copy of PurchaseIntentRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseIntentRecordCopyWith<PurchaseIntentRecord> get copyWith => _$PurchaseIntentRecordCopyWithImpl<PurchaseIntentRecord>(this as PurchaseIntentRecord, _$identity);

  /// Serializes this PurchaseIntentRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseIntentRecord&&(identical(other.intentId, intentId) || other.intentId == intentId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.appAccountToken, appAccountToken) || other.appAccountToken == appAccountToken)&&(identical(other.obfuscatedAccountId, obfuscatedAccountId) || other.obfuscatedAccountId == obfuscatedAccountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,intentId,productId,appAccountToken,obfuscatedAccountId);

@override
String toString() {
  return 'PurchaseIntentRecord(intentId: $intentId, productId: $productId, appAccountToken: $appAccountToken, obfuscatedAccountId: $obfuscatedAccountId)';
}


}

/// @nodoc
abstract mixin class $PurchaseIntentRecordCopyWith<$Res>  {
  factory $PurchaseIntentRecordCopyWith(PurchaseIntentRecord value, $Res Function(PurchaseIntentRecord) _then) = _$PurchaseIntentRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'intentId') String? intentId,@JsonKey(name: 'productId') String? productId,@JsonKey(name: 'appAccountToken') String? appAccountToken,@JsonKey(name: 'obfuscatedAccountId') String? obfuscatedAccountId
});




}
/// @nodoc
class _$PurchaseIntentRecordCopyWithImpl<$Res>
    implements $PurchaseIntentRecordCopyWith<$Res> {
  _$PurchaseIntentRecordCopyWithImpl(this._self, this._then);

  final PurchaseIntentRecord _self;
  final $Res Function(PurchaseIntentRecord) _then;

/// Create a copy of PurchaseIntentRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? intentId = freezed,Object? productId = freezed,Object? appAccountToken = freezed,Object? obfuscatedAccountId = freezed,}) {
  return _then(_self.copyWith(
intentId: freezed == intentId ? _self.intentId : intentId // ignore: cast_nullable_to_non_nullable
as String?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,appAccountToken: freezed == appAccountToken ? _self.appAccountToken : appAccountToken // ignore: cast_nullable_to_non_nullable
as String?,obfuscatedAccountId: freezed == obfuscatedAccountId ? _self.obfuscatedAccountId : obfuscatedAccountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseIntentRecord].
extension PurchaseIntentRecordPatterns on PurchaseIntentRecord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseIntentRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseIntentRecord() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseIntentRecord value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseIntentRecord():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseIntentRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseIntentRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PurchaseIntentRecord implements PurchaseIntentRecord {
  const _PurchaseIntentRecord({@JsonKey(name: 'intentId') this.intentId, @JsonKey(name: 'productId') this.productId, @JsonKey(name: 'appAccountToken') this.appAccountToken, @JsonKey(name: 'obfuscatedAccountId') this.obfuscatedAccountId});
  factory _PurchaseIntentRecord.fromJson(Map<String, dynamic> json) => _$PurchaseIntentRecordFromJson(json);

@override@JsonKey(name: 'intentId') final  String? intentId;
@override@JsonKey(name: 'productId') final  String? productId;
@override@JsonKey(name: 'appAccountToken') final  String? appAccountToken;
@override@JsonKey(name: 'obfuscatedAccountId') final  String? obfuscatedAccountId;

/// Create a copy of PurchaseIntentRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseIntentRecordCopyWith<_PurchaseIntentRecord> get copyWith => __$PurchaseIntentRecordCopyWithImpl<_PurchaseIntentRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseIntentRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseIntentRecord&&(identical(other.intentId, intentId) || other.intentId == intentId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.appAccountToken, appAccountToken) || other.appAccountToken == appAccountToken)&&(identical(other.obfuscatedAccountId, obfuscatedAccountId) || other.obfuscatedAccountId == obfuscatedAccountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,intentId,productId,appAccountToken,obfuscatedAccountId);

@override
String toString() {
  return 'PurchaseIntentRecord(intentId: $intentId, productId: $productId, appAccountToken: $appAccountToken, obfuscatedAccountId: $obfuscatedAccountId)';
}


}

/// @nodoc
abstract mixin class _$PurchaseIntentRecordCopyWith<$Res> implements $PurchaseIntentRecordCopyWith<$Res> {
  factory _$PurchaseIntentRecordCopyWith(_PurchaseIntentRecord value, $Res Function(_PurchaseIntentRecord) _then) = __$PurchaseIntentRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'intentId') String? intentId,@JsonKey(name: 'productId') String? productId,@JsonKey(name: 'appAccountToken') String? appAccountToken,@JsonKey(name: 'obfuscatedAccountId') String? obfuscatedAccountId
});




}
/// @nodoc
class __$PurchaseIntentRecordCopyWithImpl<$Res>
    implements _$PurchaseIntentRecordCopyWith<$Res> {
  __$PurchaseIntentRecordCopyWithImpl(this._self, this._then);

  final _PurchaseIntentRecord _self;
  final $Res Function(_PurchaseIntentRecord) _then;

/// Create a copy of PurchaseIntentRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? intentId = freezed,Object? productId = freezed,Object? appAccountToken = freezed,Object? obfuscatedAccountId = freezed,}) {
  return _then(_PurchaseIntentRecord(
intentId: freezed == intentId ? _self.intentId : intentId // ignore: cast_nullable_to_non_nullable
as String?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,appAccountToken: freezed == appAccountToken ? _self.appAccountToken : appAccountToken // ignore: cast_nullable_to_non_nullable
as String?,obfuscatedAccountId: freezed == obfuscatedAccountId ? _self.obfuscatedAccountId : obfuscatedAccountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
