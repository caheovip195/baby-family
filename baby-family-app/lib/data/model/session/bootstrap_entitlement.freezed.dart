// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bootstrap_entitlement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BootstrapEntitlement {

@JsonKey(name: 'accessPhase') String? get accessPhase;@JsonKey(name: 'trialEndsAt') DateTime? get trialEndsAt;@JsonKey(name: 'validUntil') DateTime? get validUntil;
/// Create a copy of BootstrapEntitlement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BootstrapEntitlementCopyWith<BootstrapEntitlement> get copyWith => _$BootstrapEntitlementCopyWithImpl<BootstrapEntitlement>(this as BootstrapEntitlement, _$identity);

  /// Serializes this BootstrapEntitlement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BootstrapEntitlement&&(identical(other.accessPhase, accessPhase) || other.accessPhase == accessPhase)&&(identical(other.trialEndsAt, trialEndsAt) || other.trialEndsAt == trialEndsAt)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessPhase,trialEndsAt,validUntil);

@override
String toString() {
  return 'BootstrapEntitlement(accessPhase: $accessPhase, trialEndsAt: $trialEndsAt, validUntil: $validUntil)';
}


}

/// @nodoc
abstract mixin class $BootstrapEntitlementCopyWith<$Res>  {
  factory $BootstrapEntitlementCopyWith(BootstrapEntitlement value, $Res Function(BootstrapEntitlement) _then) = _$BootstrapEntitlementCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'accessPhase') String? accessPhase,@JsonKey(name: 'trialEndsAt') DateTime? trialEndsAt,@JsonKey(name: 'validUntil') DateTime? validUntil
});




}
/// @nodoc
class _$BootstrapEntitlementCopyWithImpl<$Res>
    implements $BootstrapEntitlementCopyWith<$Res> {
  _$BootstrapEntitlementCopyWithImpl(this._self, this._then);

  final BootstrapEntitlement _self;
  final $Res Function(BootstrapEntitlement) _then;

/// Create a copy of BootstrapEntitlement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessPhase = freezed,Object? trialEndsAt = freezed,Object? validUntil = freezed,}) {
  return _then(_self.copyWith(
accessPhase: freezed == accessPhase ? _self.accessPhase : accessPhase // ignore: cast_nullable_to_non_nullable
as String?,trialEndsAt: freezed == trialEndsAt ? _self.trialEndsAt : trialEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,validUntil: freezed == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BootstrapEntitlement].
extension BootstrapEntitlementPatterns on BootstrapEntitlement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BootstrapEntitlement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BootstrapEntitlement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BootstrapEntitlement value)  $default,){
final _that = this;
switch (_that) {
case _BootstrapEntitlement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BootstrapEntitlement value)?  $default,){
final _that = this;
switch (_that) {
case _BootstrapEntitlement() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BootstrapEntitlement implements BootstrapEntitlement {
  const _BootstrapEntitlement({@JsonKey(name: 'accessPhase') this.accessPhase, @JsonKey(name: 'trialEndsAt') this.trialEndsAt, @JsonKey(name: 'validUntil') this.validUntil});
  factory _BootstrapEntitlement.fromJson(Map<String, dynamic> json) => _$BootstrapEntitlementFromJson(json);

@override@JsonKey(name: 'accessPhase') final  String? accessPhase;
@override@JsonKey(name: 'trialEndsAt') final  DateTime? trialEndsAt;
@override@JsonKey(name: 'validUntil') final  DateTime? validUntil;

/// Create a copy of BootstrapEntitlement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BootstrapEntitlementCopyWith<_BootstrapEntitlement> get copyWith => __$BootstrapEntitlementCopyWithImpl<_BootstrapEntitlement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BootstrapEntitlementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BootstrapEntitlement&&(identical(other.accessPhase, accessPhase) || other.accessPhase == accessPhase)&&(identical(other.trialEndsAt, trialEndsAt) || other.trialEndsAt == trialEndsAt)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessPhase,trialEndsAt,validUntil);

@override
String toString() {
  return 'BootstrapEntitlement(accessPhase: $accessPhase, trialEndsAt: $trialEndsAt, validUntil: $validUntil)';
}


}

/// @nodoc
abstract mixin class _$BootstrapEntitlementCopyWith<$Res> implements $BootstrapEntitlementCopyWith<$Res> {
  factory _$BootstrapEntitlementCopyWith(_BootstrapEntitlement value, $Res Function(_BootstrapEntitlement) _then) = __$BootstrapEntitlementCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'accessPhase') String? accessPhase,@JsonKey(name: 'trialEndsAt') DateTime? trialEndsAt,@JsonKey(name: 'validUntil') DateTime? validUntil
});




}
/// @nodoc
class __$BootstrapEntitlementCopyWithImpl<$Res>
    implements _$BootstrapEntitlementCopyWith<$Res> {
  __$BootstrapEntitlementCopyWithImpl(this._self, this._then);

  final _BootstrapEntitlement _self;
  final $Res Function(_BootstrapEntitlement) _then;

/// Create a copy of BootstrapEntitlement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessPhase = freezed,Object? trialEndsAt = freezed,Object? validUntil = freezed,}) {
  return _then(_BootstrapEntitlement(
accessPhase: freezed == accessPhase ? _self.accessPhase : accessPhase // ignore: cast_nullable_to_non_nullable
as String?,trialEndsAt: freezed == trialEndsAt ? _self.trialEndsAt : trialEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,validUntil: freezed == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
