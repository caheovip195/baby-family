// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'storage_usage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StorageUsage {

@JsonKey(name: 'kind') String get kind;@JsonKey(name: 'usedMb') int get usedMb;
/// Create a copy of StorageUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageUsageCopyWith<StorageUsage> get copyWith => _$StorageUsageCopyWithImpl<StorageUsage>(this as StorageUsage, _$identity);

  /// Serializes this StorageUsage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageUsage&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.usedMb, usedMb) || other.usedMb == usedMb));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,usedMb);

@override
String toString() {
  return 'StorageUsage(kind: $kind, usedMb: $usedMb)';
}


}

/// @nodoc
abstract mixin class $StorageUsageCopyWith<$Res>  {
  factory $StorageUsageCopyWith(StorageUsage value, $Res Function(StorageUsage) _then) = _$StorageUsageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'kind') String kind,@JsonKey(name: 'usedMb') int usedMb
});




}
/// @nodoc
class _$StorageUsageCopyWithImpl<$Res>
    implements $StorageUsageCopyWith<$Res> {
  _$StorageUsageCopyWithImpl(this._self, this._then);

  final StorageUsage _self;
  final $Res Function(StorageUsage) _then;

/// Create a copy of StorageUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? usedMb = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,usedMb: null == usedMb ? _self.usedMb : usedMb // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageUsage].
extension StorageUsagePatterns on StorageUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageUsage value)  $default,){
final _that = this;
switch (_that) {
case _StorageUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageUsage value)?  $default,){
final _that = this;
switch (_that) {
case _StorageUsage() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _StorageUsage implements StorageUsage {
  const _StorageUsage({@JsonKey(name: 'kind') required this.kind, @JsonKey(name: 'usedMb') this.usedMb = 0});
  factory _StorageUsage.fromJson(Map<String, dynamic> json) => _$StorageUsageFromJson(json);

@override@JsonKey(name: 'kind') final  String kind;
@override@JsonKey(name: 'usedMb') final  int usedMb;

/// Create a copy of StorageUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageUsageCopyWith<_StorageUsage> get copyWith => __$StorageUsageCopyWithImpl<_StorageUsage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageUsageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageUsage&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.usedMb, usedMb) || other.usedMb == usedMb));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,usedMb);

@override
String toString() {
  return 'StorageUsage(kind: $kind, usedMb: $usedMb)';
}


}

/// @nodoc
abstract mixin class _$StorageUsageCopyWith<$Res> implements $StorageUsageCopyWith<$Res> {
  factory _$StorageUsageCopyWith(_StorageUsage value, $Res Function(_StorageUsage) _then) = __$StorageUsageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'kind') String kind,@JsonKey(name: 'usedMb') int usedMb
});




}
/// @nodoc
class __$StorageUsageCopyWithImpl<$Res>
    implements _$StorageUsageCopyWith<$Res> {
  __$StorageUsageCopyWithImpl(this._self, this._then);

  final _StorageUsage _self;
  final $Res Function(_StorageUsage) _then;

/// Create a copy of StorageUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? usedMb = null,}) {
  return _then(_StorageUsage(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,usedMb: null == usedMb ? _self.usedMb : usedMb // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
