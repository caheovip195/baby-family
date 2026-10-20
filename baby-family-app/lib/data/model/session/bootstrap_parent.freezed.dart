// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bootstrap_parent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BootstrapParent {

@JsonKey(name: 'userId') String? get userId;@JsonKey(name: 'slot') String? get slot;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'callName') String? get callName;@JsonKey(name: 'displayName') String? get displayName;
/// Create a copy of BootstrapParent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BootstrapParentCopyWith<BootstrapParent> get copyWith => _$BootstrapParentCopyWithImpl<BootstrapParent>(this as BootstrapParent, _$identity);

  /// Serializes this BootstrapParent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BootstrapParent&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.callName, callName) || other.callName == callName)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,slot,kind,callName,displayName);

@override
String toString() {
  return 'BootstrapParent(userId: $userId, slot: $slot, kind: $kind, callName: $callName, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class $BootstrapParentCopyWith<$Res>  {
  factory $BootstrapParentCopyWith(BootstrapParent value, $Res Function(BootstrapParent) _then) = _$BootstrapParentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'slot') String? slot,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'callName') String? callName,@JsonKey(name: 'displayName') String? displayName
});




}
/// @nodoc
class _$BootstrapParentCopyWithImpl<$Res>
    implements $BootstrapParentCopyWith<$Res> {
  _$BootstrapParentCopyWithImpl(this._self, this._then);

  final BootstrapParent _self;
  final $Res Function(BootstrapParent) _then;

/// Create a copy of BootstrapParent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = freezed,Object? slot = freezed,Object? kind = freezed,Object? callName = freezed,Object? displayName = freezed,}) {
  return _then(_self.copyWith(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,slot: freezed == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,callName: freezed == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BootstrapParent].
extension BootstrapParentPatterns on BootstrapParent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BootstrapParent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BootstrapParent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BootstrapParent value)  $default,){
final _that = this;
switch (_that) {
case _BootstrapParent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BootstrapParent value)?  $default,){
final _that = this;
switch (_that) {
case _BootstrapParent() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BootstrapParent implements BootstrapParent {
  const _BootstrapParent({@JsonKey(name: 'userId') this.userId, @JsonKey(name: 'slot') this.slot, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'callName') this.callName, @JsonKey(name: 'displayName') this.displayName});
  factory _BootstrapParent.fromJson(Map<String, dynamic> json) => _$BootstrapParentFromJson(json);

@override@JsonKey(name: 'userId') final  String? userId;
@override@JsonKey(name: 'slot') final  String? slot;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'callName') final  String? callName;
@override@JsonKey(name: 'displayName') final  String? displayName;

/// Create a copy of BootstrapParent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BootstrapParentCopyWith<_BootstrapParent> get copyWith => __$BootstrapParentCopyWithImpl<_BootstrapParent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BootstrapParentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BootstrapParent&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.callName, callName) || other.callName == callName)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,slot,kind,callName,displayName);

@override
String toString() {
  return 'BootstrapParent(userId: $userId, slot: $slot, kind: $kind, callName: $callName, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$BootstrapParentCopyWith<$Res> implements $BootstrapParentCopyWith<$Res> {
  factory _$BootstrapParentCopyWith(_BootstrapParent value, $Res Function(_BootstrapParent) _then) = __$BootstrapParentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'slot') String? slot,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'callName') String? callName,@JsonKey(name: 'displayName') String? displayName
});




}
/// @nodoc
class __$BootstrapParentCopyWithImpl<$Res>
    implements _$BootstrapParentCopyWith<$Res> {
  __$BootstrapParentCopyWithImpl(this._self, this._then);

  final _BootstrapParent _self;
  final $Res Function(_BootstrapParent) _then;

/// Create a copy of BootstrapParent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = freezed,Object? slot = freezed,Object? kind = freezed,Object? callName = freezed,Object? displayName = freezed,}) {
  return _then(_BootstrapParent(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,slot: freezed == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,callName: freezed == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
