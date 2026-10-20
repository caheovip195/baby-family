// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'billing_plan_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BillingPlanRecord {

@JsonKey(name: 'code') String? get code;@JsonKey(name: 'displayName') Map<String, String> get displayName;@JsonKey(name: 'displayOrder') int get displayOrder;@JsonKey(name: 'version') int? get version;@JsonKey(name: 'quotas') Map<String, num> get quotas;@JsonKey(name: 'features') Map<String, bool> get features;
/// Create a copy of BillingPlanRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillingPlanRecordCopyWith<BillingPlanRecord> get copyWith => _$BillingPlanRecordCopyWithImpl<BillingPlanRecord>(this as BillingPlanRecord, _$identity);

  /// Serializes this BillingPlanRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillingPlanRecord&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.displayName, displayName)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.quotas, quotas)&&const DeepCollectionEquality().equals(other.features, features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,const DeepCollectionEquality().hash(displayName),displayOrder,version,const DeepCollectionEquality().hash(quotas),const DeepCollectionEquality().hash(features));

@override
String toString() {
  return 'BillingPlanRecord(code: $code, displayName: $displayName, displayOrder: $displayOrder, version: $version, quotas: $quotas, features: $features)';
}


}

/// @nodoc
abstract mixin class $BillingPlanRecordCopyWith<$Res>  {
  factory $BillingPlanRecordCopyWith(BillingPlanRecord value, $Res Function(BillingPlanRecord) _then) = _$BillingPlanRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String? code,@JsonKey(name: 'displayName') Map<String, String> displayName,@JsonKey(name: 'displayOrder') int displayOrder,@JsonKey(name: 'version') int? version,@JsonKey(name: 'quotas') Map<String, num> quotas,@JsonKey(name: 'features') Map<String, bool> features
});




}
/// @nodoc
class _$BillingPlanRecordCopyWithImpl<$Res>
    implements $BillingPlanRecordCopyWith<$Res> {
  _$BillingPlanRecordCopyWithImpl(this._self, this._then);

  final BillingPlanRecord _self;
  final $Res Function(BillingPlanRecord) _then;

/// Create a copy of BillingPlanRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = freezed,Object? displayName = null,Object? displayOrder = null,Object? version = freezed,Object? quotas = null,Object? features = null,}) {
  return _then(_self.copyWith(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as Map<String, String>,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,quotas: null == quotas ? _self.quotas : quotas // ignore: cast_nullable_to_non_nullable
as Map<String, num>,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}

}


/// Adds pattern-matching-related methods to [BillingPlanRecord].
extension BillingPlanRecordPatterns on BillingPlanRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BillingPlanRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillingPlanRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BillingPlanRecord value)  $default,){
final _that = this;
switch (_that) {
case _BillingPlanRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BillingPlanRecord value)?  $default,){
final _that = this;
switch (_that) {
case _BillingPlanRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BillingPlanRecord implements BillingPlanRecord {
  const _BillingPlanRecord({@JsonKey(name: 'code') this.code, @JsonKey(name: 'displayName') final  Map<String, String> displayName = const <String, String>{}, @JsonKey(name: 'displayOrder') this.displayOrder = 0, @JsonKey(name: 'version') this.version, @JsonKey(name: 'quotas') final  Map<String, num> quotas = const <String, num>{}, @JsonKey(name: 'features') final  Map<String, bool> features = const <String, bool>{}}): _displayName = displayName,_quotas = quotas,_features = features;
  factory _BillingPlanRecord.fromJson(Map<String, dynamic> json) => _$BillingPlanRecordFromJson(json);

@override@JsonKey(name: 'code') final  String? code;
 final  Map<String, String> _displayName;
@override@JsonKey(name: 'displayName') Map<String, String> get displayName {
  if (_displayName is EqualUnmodifiableMapView) return _displayName;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_displayName);
}

@override@JsonKey(name: 'displayOrder') final  int displayOrder;
@override@JsonKey(name: 'version') final  int? version;
 final  Map<String, num> _quotas;
@override@JsonKey(name: 'quotas') Map<String, num> get quotas {
  if (_quotas is EqualUnmodifiableMapView) return _quotas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_quotas);
}

 final  Map<String, bool> _features;
@override@JsonKey(name: 'features') Map<String, bool> get features {
  if (_features is EqualUnmodifiableMapView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_features);
}


/// Create a copy of BillingPlanRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillingPlanRecordCopyWith<_BillingPlanRecord> get copyWith => __$BillingPlanRecordCopyWithImpl<_BillingPlanRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BillingPlanRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillingPlanRecord&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._displayName, _displayName)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._quotas, _quotas)&&const DeepCollectionEquality().equals(other._features, _features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,const DeepCollectionEquality().hash(_displayName),displayOrder,version,const DeepCollectionEquality().hash(_quotas),const DeepCollectionEquality().hash(_features));

@override
String toString() {
  return 'BillingPlanRecord(code: $code, displayName: $displayName, displayOrder: $displayOrder, version: $version, quotas: $quotas, features: $features)';
}


}

/// @nodoc
abstract mixin class _$BillingPlanRecordCopyWith<$Res> implements $BillingPlanRecordCopyWith<$Res> {
  factory _$BillingPlanRecordCopyWith(_BillingPlanRecord value, $Res Function(_BillingPlanRecord) _then) = __$BillingPlanRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String? code,@JsonKey(name: 'displayName') Map<String, String> displayName,@JsonKey(name: 'displayOrder') int displayOrder,@JsonKey(name: 'version') int? version,@JsonKey(name: 'quotas') Map<String, num> quotas,@JsonKey(name: 'features') Map<String, bool> features
});




}
/// @nodoc
class __$BillingPlanRecordCopyWithImpl<$Res>
    implements _$BillingPlanRecordCopyWith<$Res> {
  __$BillingPlanRecordCopyWithImpl(this._self, this._then);

  final _BillingPlanRecord _self;
  final $Res Function(_BillingPlanRecord) _then;

/// Create a copy of BillingPlanRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? displayName = null,Object? displayOrder = null,Object? version = freezed,Object? quotas = null,Object? features = null,}) {
  return _then(_BillingPlanRecord(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,displayName: null == displayName ? _self._displayName : displayName // ignore: cast_nullable_to_non_nullable
as Map<String, String>,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,quotas: null == quotas ? _self._quotas : quotas // ignore: cast_nullable_to_non_nullable
as Map<String, num>,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}


}

// dart format on
