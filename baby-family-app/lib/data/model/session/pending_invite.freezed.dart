// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_invite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PendingInvite {

@JsonKey(name: 'code') String get code;@JsonKey(name: 'kind') InviteKind get kind;@JsonKey(name: 'familyId') String? get familyId;
/// Create a copy of PendingInvite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingInviteCopyWith<PendingInvite> get copyWith => _$PendingInviteCopyWithImpl<PendingInvite>(this as PendingInvite, _$identity);

  /// Serializes this PendingInvite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingInvite&&(identical(other.code, code) || other.code == code)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.familyId, familyId) || other.familyId == familyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,kind,familyId);

@override
String toString() {
  return 'PendingInvite(code: $code, kind: $kind, familyId: $familyId)';
}


}

/// @nodoc
abstract mixin class $PendingInviteCopyWith<$Res>  {
  factory $PendingInviteCopyWith(PendingInvite value, $Res Function(PendingInvite) _then) = _$PendingInviteCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'kind') InviteKind kind,@JsonKey(name: 'familyId') String? familyId
});




}
/// @nodoc
class _$PendingInviteCopyWithImpl<$Res>
    implements $PendingInviteCopyWith<$Res> {
  _$PendingInviteCopyWithImpl(this._self, this._then);

  final PendingInvite _self;
  final $Res Function(PendingInvite) _then;

/// Create a copy of PendingInvite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? kind = null,Object? familyId = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as InviteKind,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingInvite].
extension PendingInvitePatterns on PendingInvite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingInvite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingInvite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingInvite value)  $default,){
final _that = this;
switch (_that) {
case _PendingInvite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingInvite value)?  $default,){
final _that = this;
switch (_that) {
case _PendingInvite() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PendingInvite implements PendingInvite {
  const _PendingInvite({@JsonKey(name: 'code') required this.code, @JsonKey(name: 'kind') required this.kind, @JsonKey(name: 'familyId') this.familyId});
  factory _PendingInvite.fromJson(Map<String, dynamic> json) => _$PendingInviteFromJson(json);

@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'kind') final  InviteKind kind;
@override@JsonKey(name: 'familyId') final  String? familyId;

/// Create a copy of PendingInvite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingInviteCopyWith<_PendingInvite> get copyWith => __$PendingInviteCopyWithImpl<_PendingInvite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PendingInviteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingInvite&&(identical(other.code, code) || other.code == code)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.familyId, familyId) || other.familyId == familyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,kind,familyId);

@override
String toString() {
  return 'PendingInvite(code: $code, kind: $kind, familyId: $familyId)';
}


}

/// @nodoc
abstract mixin class _$PendingInviteCopyWith<$Res> implements $PendingInviteCopyWith<$Res> {
  factory _$PendingInviteCopyWith(_PendingInvite value, $Res Function(_PendingInvite) _then) = __$PendingInviteCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'kind') InviteKind kind,@JsonKey(name: 'familyId') String? familyId
});




}
/// @nodoc
class __$PendingInviteCopyWithImpl<$Res>
    implements _$PendingInviteCopyWith<$Res> {
  __$PendingInviteCopyWithImpl(this._self, this._then);

  final _PendingInvite _self;
  final $Res Function(_PendingInvite) _then;

/// Create a copy of PendingInvite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? kind = null,Object? familyId = freezed,}) {
  return _then(_PendingInvite(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as InviteKind,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
