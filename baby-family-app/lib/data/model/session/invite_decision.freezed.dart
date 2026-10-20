// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite_decision.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InviteDecision {

@JsonKey(name: 'status') String? get status;@JsonKey(name: 'familyId') String? get familyId;@JsonKey(name: 'trialEndsAt') DateTime? get trialEndsAt;
/// Create a copy of InviteDecision
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InviteDecisionCopyWith<InviteDecision> get copyWith => _$InviteDecisionCopyWithImpl<InviteDecision>(this as InviteDecision, _$identity);

  /// Serializes this InviteDecision to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InviteDecision&&(identical(other.status, status) || other.status == status)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.trialEndsAt, trialEndsAt) || other.trialEndsAt == trialEndsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,familyId,trialEndsAt);

@override
String toString() {
  return 'InviteDecision(status: $status, familyId: $familyId, trialEndsAt: $trialEndsAt)';
}


}

/// @nodoc
abstract mixin class $InviteDecisionCopyWith<$Res>  {
  factory $InviteDecisionCopyWith(InviteDecision value, $Res Function(InviteDecision) _then) = _$InviteDecisionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'status') String? status,@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'trialEndsAt') DateTime? trialEndsAt
});




}
/// @nodoc
class _$InviteDecisionCopyWithImpl<$Res>
    implements $InviteDecisionCopyWith<$Res> {
  _$InviteDecisionCopyWithImpl(this._self, this._then);

  final InviteDecision _self;
  final $Res Function(InviteDecision) _then;

/// Create a copy of InviteDecision
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? familyId = freezed,Object? trialEndsAt = freezed,}) {
  return _then(_self.copyWith(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,trialEndsAt: freezed == trialEndsAt ? _self.trialEndsAt : trialEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [InviteDecision].
extension InviteDecisionPatterns on InviteDecision {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InviteDecision value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InviteDecision() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InviteDecision value)  $default,){
final _that = this;
switch (_that) {
case _InviteDecision():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InviteDecision value)?  $default,){
final _that = this;
switch (_that) {
case _InviteDecision() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _InviteDecision implements InviteDecision {
  const _InviteDecision({@JsonKey(name: 'status') this.status, @JsonKey(name: 'familyId') this.familyId, @JsonKey(name: 'trialEndsAt') this.trialEndsAt});
  factory _InviteDecision.fromJson(Map<String, dynamic> json) => _$InviteDecisionFromJson(json);

@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'familyId') final  String? familyId;
@override@JsonKey(name: 'trialEndsAt') final  DateTime? trialEndsAt;

/// Create a copy of InviteDecision
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteDecisionCopyWith<_InviteDecision> get copyWith => __$InviteDecisionCopyWithImpl<_InviteDecision>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InviteDecisionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteDecision&&(identical(other.status, status) || other.status == status)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.trialEndsAt, trialEndsAt) || other.trialEndsAt == trialEndsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,familyId,trialEndsAt);

@override
String toString() {
  return 'InviteDecision(status: $status, familyId: $familyId, trialEndsAt: $trialEndsAt)';
}


}

/// @nodoc
abstract mixin class _$InviteDecisionCopyWith<$Res> implements $InviteDecisionCopyWith<$Res> {
  factory _$InviteDecisionCopyWith(_InviteDecision value, $Res Function(_InviteDecision) _then) = __$InviteDecisionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'status') String? status,@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'trialEndsAt') DateTime? trialEndsAt
});




}
/// @nodoc
class __$InviteDecisionCopyWithImpl<$Res>
    implements _$InviteDecisionCopyWith<$Res> {
  __$InviteDecisionCopyWithImpl(this._self, this._then);

  final _InviteDecision _self;
  final $Res Function(_InviteDecision) _then;

/// Create a copy of InviteDecision
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? familyId = freezed,Object? trialEndsAt = freezed,}) {
  return _then(_InviteDecision(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,trialEndsAt: freezed == trialEndsAt ? _self.trialEndsAt : trialEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
