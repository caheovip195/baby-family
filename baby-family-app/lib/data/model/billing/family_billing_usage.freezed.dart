// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_billing_usage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyBillingUsage {

@JsonKey(name: 'storageBytes') String? get storageBytes;@JsonKey(name: 'memoryCount') int get memoryCount;
/// Create a copy of FamilyBillingUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyBillingUsageCopyWith<FamilyBillingUsage> get copyWith => _$FamilyBillingUsageCopyWithImpl<FamilyBillingUsage>(this as FamilyBillingUsage, _$identity);

  /// Serializes this FamilyBillingUsage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyBillingUsage&&(identical(other.storageBytes, storageBytes) || other.storageBytes == storageBytes)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storageBytes,memoryCount);

@override
String toString() {
  return 'FamilyBillingUsage(storageBytes: $storageBytes, memoryCount: $memoryCount)';
}


}

/// @nodoc
abstract mixin class $FamilyBillingUsageCopyWith<$Res>  {
  factory $FamilyBillingUsageCopyWith(FamilyBillingUsage value, $Res Function(FamilyBillingUsage) _then) = _$FamilyBillingUsageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'storageBytes') String? storageBytes,@JsonKey(name: 'memoryCount') int memoryCount
});




}
/// @nodoc
class _$FamilyBillingUsageCopyWithImpl<$Res>
    implements $FamilyBillingUsageCopyWith<$Res> {
  _$FamilyBillingUsageCopyWithImpl(this._self, this._then);

  final FamilyBillingUsage _self;
  final $Res Function(FamilyBillingUsage) _then;

/// Create a copy of FamilyBillingUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storageBytes = freezed,Object? memoryCount = null,}) {
  return _then(_self.copyWith(
storageBytes: freezed == storageBytes ? _self.storageBytes : storageBytes // ignore: cast_nullable_to_non_nullable
as String?,memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyBillingUsage].
extension FamilyBillingUsagePatterns on FamilyBillingUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyBillingUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyBillingUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyBillingUsage value)  $default,){
final _that = this;
switch (_that) {
case _FamilyBillingUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyBillingUsage value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyBillingUsage() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FamilyBillingUsage implements FamilyBillingUsage {
  const _FamilyBillingUsage({@JsonKey(name: 'storageBytes') this.storageBytes, @JsonKey(name: 'memoryCount') this.memoryCount = 0});
  factory _FamilyBillingUsage.fromJson(Map<String, dynamic> json) => _$FamilyBillingUsageFromJson(json);

@override@JsonKey(name: 'storageBytes') final  String? storageBytes;
@override@JsonKey(name: 'memoryCount') final  int memoryCount;

/// Create a copy of FamilyBillingUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyBillingUsageCopyWith<_FamilyBillingUsage> get copyWith => __$FamilyBillingUsageCopyWithImpl<_FamilyBillingUsage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyBillingUsageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyBillingUsage&&(identical(other.storageBytes, storageBytes) || other.storageBytes == storageBytes)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storageBytes,memoryCount);

@override
String toString() {
  return 'FamilyBillingUsage(storageBytes: $storageBytes, memoryCount: $memoryCount)';
}


}

/// @nodoc
abstract mixin class _$FamilyBillingUsageCopyWith<$Res> implements $FamilyBillingUsageCopyWith<$Res> {
  factory _$FamilyBillingUsageCopyWith(_FamilyBillingUsage value, $Res Function(_FamilyBillingUsage) _then) = __$FamilyBillingUsageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'storageBytes') String? storageBytes,@JsonKey(name: 'memoryCount') int memoryCount
});




}
/// @nodoc
class __$FamilyBillingUsageCopyWithImpl<$Res>
    implements _$FamilyBillingUsageCopyWith<$Res> {
  __$FamilyBillingUsageCopyWithImpl(this._self, this._then);

  final _FamilyBillingUsage _self;
  final $Res Function(_FamilyBillingUsage) _then;

/// Create a copy of FamilyBillingUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storageBytes = freezed,Object? memoryCount = null,}) {
  return _then(_FamilyBillingUsage(
storageBytes: freezed == storageBytes ? _self.storageBytes : storageBytes // ignore: cast_nullable_to_non_nullable
as String?,memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
