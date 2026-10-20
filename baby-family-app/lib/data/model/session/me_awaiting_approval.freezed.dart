// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'me_awaiting_approval.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeAwaitingApproval {

@JsonKey(name: 'inviteId') String? get inviteId;@JsonKey(name: 'familyName') String? get familyName;@JsonKey(name: 'kind') String? get kind;
/// Create a copy of MeAwaitingApproval
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeAwaitingApprovalCopyWith<MeAwaitingApproval> get copyWith => _$MeAwaitingApprovalCopyWithImpl<MeAwaitingApproval>(this as MeAwaitingApproval, _$identity);

  /// Serializes this MeAwaitingApproval to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeAwaitingApproval&&(identical(other.inviteId, inviteId) || other.inviteId == inviteId)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inviteId,familyName,kind);

@override
String toString() {
  return 'MeAwaitingApproval(inviteId: $inviteId, familyName: $familyName, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $MeAwaitingApprovalCopyWith<$Res>  {
  factory $MeAwaitingApprovalCopyWith(MeAwaitingApproval value, $Res Function(MeAwaitingApproval) _then) = _$MeAwaitingApprovalCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'inviteId') String? inviteId,@JsonKey(name: 'familyName') String? familyName,@JsonKey(name: 'kind') String? kind
});




}
/// @nodoc
class _$MeAwaitingApprovalCopyWithImpl<$Res>
    implements $MeAwaitingApprovalCopyWith<$Res> {
  _$MeAwaitingApprovalCopyWithImpl(this._self, this._then);

  final MeAwaitingApproval _self;
  final $Res Function(MeAwaitingApproval) _then;

/// Create a copy of MeAwaitingApproval
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inviteId = freezed,Object? familyName = freezed,Object? kind = freezed,}) {
  return _then(_self.copyWith(
inviteId: freezed == inviteId ? _self.inviteId : inviteId // ignore: cast_nullable_to_non_nullable
as String?,familyName: freezed == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeAwaitingApproval].
extension MeAwaitingApprovalPatterns on MeAwaitingApproval {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeAwaitingApproval value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeAwaitingApproval() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeAwaitingApproval value)  $default,){
final _that = this;
switch (_that) {
case _MeAwaitingApproval():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeAwaitingApproval value)?  $default,){
final _that = this;
switch (_that) {
case _MeAwaitingApproval() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MeAwaitingApproval implements MeAwaitingApproval {
  const _MeAwaitingApproval({@JsonKey(name: 'inviteId') this.inviteId, @JsonKey(name: 'familyName') this.familyName, @JsonKey(name: 'kind') this.kind});
  factory _MeAwaitingApproval.fromJson(Map<String, dynamic> json) => _$MeAwaitingApprovalFromJson(json);

@override@JsonKey(name: 'inviteId') final  String? inviteId;
@override@JsonKey(name: 'familyName') final  String? familyName;
@override@JsonKey(name: 'kind') final  String? kind;

/// Create a copy of MeAwaitingApproval
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeAwaitingApprovalCopyWith<_MeAwaitingApproval> get copyWith => __$MeAwaitingApprovalCopyWithImpl<_MeAwaitingApproval>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeAwaitingApprovalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeAwaitingApproval&&(identical(other.inviteId, inviteId) || other.inviteId == inviteId)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inviteId,familyName,kind);

@override
String toString() {
  return 'MeAwaitingApproval(inviteId: $inviteId, familyName: $familyName, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$MeAwaitingApprovalCopyWith<$Res> implements $MeAwaitingApprovalCopyWith<$Res> {
  factory _$MeAwaitingApprovalCopyWith(_MeAwaitingApproval value, $Res Function(_MeAwaitingApproval) _then) = __$MeAwaitingApprovalCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'inviteId') String? inviteId,@JsonKey(name: 'familyName') String? familyName,@JsonKey(name: 'kind') String? kind
});




}
/// @nodoc
class __$MeAwaitingApprovalCopyWithImpl<$Res>
    implements _$MeAwaitingApprovalCopyWith<$Res> {
  __$MeAwaitingApprovalCopyWithImpl(this._self, this._then);

  final _MeAwaitingApproval _self;
  final $Res Function(_MeAwaitingApproval) _then;

/// Create a copy of MeAwaitingApproval
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inviteId = freezed,Object? familyName = freezed,Object? kind = freezed,}) {
  return _then(_MeAwaitingApproval(
inviteId: freezed == inviteId ? _self.inviteId : inviteId // ignore: cast_nullable_to_non_nullable
as String?,familyName: freezed == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
