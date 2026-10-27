// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite_resolution.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InviteResolution {

@JsonKey(name: 'inviteId') String? get inviteId;@JsonKey(name: 'type') String? get type;@JsonKey(name: 'state') String? get state;@JsonKey(name: 'familyName') String? get familyName;@JsonKey(name: 'inviterCallName') String? get inviterCallName;@JsonKey(name: 'inviterKind') String? get inviterKind;@JsonKey(name: 'proposedKind') String? get proposedKind;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'expiresAt') DateTime? get expiresAt;/// Lời mời CIRCLE: quan hệ + chỉ bé/thai kỳ được cấp quyền (kèm quyền
/// xem/tải ảnh từng bé) + tên gọi Bố/Mẹ đặt cho người được mời
/// (BF-20261026-006).
@JsonKey(name: 'relation') String? get relation;@JsonKey(name: 'displayName') String? get displayName;@JsonKey(name: 'children') List<CircleSubjectRecord> get children;
/// Create a copy of InviteResolution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InviteResolutionCopyWith<InviteResolution> get copyWith => _$InviteResolutionCopyWithImpl<InviteResolution>(this as InviteResolution, _$identity);

  /// Serializes this InviteResolution to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InviteResolution&&(identical(other.inviteId, inviteId) || other.inviteId == inviteId)&&(identical(other.type, type) || other.type == type)&&(identical(other.state, state) || other.state == state)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.inviterCallName, inviterCallName) || other.inviterCallName == inviterCallName)&&(identical(other.inviterKind, inviterKind) || other.inviterKind == inviterKind)&&(identical(other.proposedKind, proposedKind) || other.proposedKind == proposedKind)&&(identical(other.message, message) || other.message == message)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.relation, relation) || other.relation == relation)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inviteId,type,state,familyName,inviterCallName,inviterKind,proposedKind,message,expiresAt,relation,displayName,const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'InviteResolution(inviteId: $inviteId, type: $type, state: $state, familyName: $familyName, inviterCallName: $inviterCallName, inviterKind: $inviterKind, proposedKind: $proposedKind, message: $message, expiresAt: $expiresAt, relation: $relation, displayName: $displayName, children: $children)';
}


}

/// @nodoc
abstract mixin class $InviteResolutionCopyWith<$Res>  {
  factory $InviteResolutionCopyWith(InviteResolution value, $Res Function(InviteResolution) _then) = _$InviteResolutionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'inviteId') String? inviteId,@JsonKey(name: 'type') String? type,@JsonKey(name: 'state') String? state,@JsonKey(name: 'familyName') String? familyName,@JsonKey(name: 'inviterCallName') String? inviterCallName,@JsonKey(name: 'inviterKind') String? inviterKind,@JsonKey(name: 'proposedKind') String? proposedKind,@JsonKey(name: 'message') String? message,@JsonKey(name: 'expiresAt') DateTime? expiresAt,@JsonKey(name: 'relation') String? relation,@JsonKey(name: 'displayName') String? displayName,@JsonKey(name: 'children') List<CircleSubjectRecord> children
});




}
/// @nodoc
class _$InviteResolutionCopyWithImpl<$Res>
    implements $InviteResolutionCopyWith<$Res> {
  _$InviteResolutionCopyWithImpl(this._self, this._then);

  final InviteResolution _self;
  final $Res Function(InviteResolution) _then;

/// Create a copy of InviteResolution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inviteId = freezed,Object? type = freezed,Object? state = freezed,Object? familyName = freezed,Object? inviterCallName = freezed,Object? inviterKind = freezed,Object? proposedKind = freezed,Object? message = freezed,Object? expiresAt = freezed,Object? relation = freezed,Object? displayName = freezed,Object? children = null,}) {
  return _then(_self.copyWith(
inviteId: freezed == inviteId ? _self.inviteId : inviteId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,familyName: freezed == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String?,inviterCallName: freezed == inviterCallName ? _self.inviterCallName : inviterCallName // ignore: cast_nullable_to_non_nullable
as String?,inviterKind: freezed == inviterKind ? _self.inviterKind : inviterKind // ignore: cast_nullable_to_non_nullable
as String?,proposedKind: freezed == proposedKind ? _self.proposedKind : proposedKind // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,relation: freezed == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<CircleSubjectRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [InviteResolution].
extension InviteResolutionPatterns on InviteResolution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InviteResolution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InviteResolution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InviteResolution value)  $default,){
final _that = this;
switch (_that) {
case _InviteResolution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InviteResolution value)?  $default,){
final _that = this;
switch (_that) {
case _InviteResolution() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _InviteResolution implements InviteResolution {
  const _InviteResolution({@JsonKey(name: 'inviteId') this.inviteId, @JsonKey(name: 'type') this.type, @JsonKey(name: 'state') this.state, @JsonKey(name: 'familyName') this.familyName, @JsonKey(name: 'inviterCallName') this.inviterCallName, @JsonKey(name: 'inviterKind') this.inviterKind, @JsonKey(name: 'proposedKind') this.proposedKind, @JsonKey(name: 'message') this.message, @JsonKey(name: 'expiresAt') this.expiresAt, @JsonKey(name: 'relation') this.relation, @JsonKey(name: 'displayName') this.displayName, @JsonKey(name: 'children') final  List<CircleSubjectRecord> children = const <CircleSubjectRecord>[]}): _children = children;
  factory _InviteResolution.fromJson(Map<String, dynamic> json) => _$InviteResolutionFromJson(json);

@override@JsonKey(name: 'inviteId') final  String? inviteId;
@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'state') final  String? state;
@override@JsonKey(name: 'familyName') final  String? familyName;
@override@JsonKey(name: 'inviterCallName') final  String? inviterCallName;
@override@JsonKey(name: 'inviterKind') final  String? inviterKind;
@override@JsonKey(name: 'proposedKind') final  String? proposedKind;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'expiresAt') final  DateTime? expiresAt;
/// Lời mời CIRCLE: quan hệ + chỉ bé/thai kỳ được cấp quyền (kèm quyền
/// xem/tải ảnh từng bé) + tên gọi Bố/Mẹ đặt cho người được mời
/// (BF-20261026-006).
@override@JsonKey(name: 'relation') final  String? relation;
@override@JsonKey(name: 'displayName') final  String? displayName;
 final  List<CircleSubjectRecord> _children;
@override@JsonKey(name: 'children') List<CircleSubjectRecord> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of InviteResolution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteResolutionCopyWith<_InviteResolution> get copyWith => __$InviteResolutionCopyWithImpl<_InviteResolution>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InviteResolutionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteResolution&&(identical(other.inviteId, inviteId) || other.inviteId == inviteId)&&(identical(other.type, type) || other.type == type)&&(identical(other.state, state) || other.state == state)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.inviterCallName, inviterCallName) || other.inviterCallName == inviterCallName)&&(identical(other.inviterKind, inviterKind) || other.inviterKind == inviterKind)&&(identical(other.proposedKind, proposedKind) || other.proposedKind == proposedKind)&&(identical(other.message, message) || other.message == message)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.relation, relation) || other.relation == relation)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other._children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inviteId,type,state,familyName,inviterCallName,inviterKind,proposedKind,message,expiresAt,relation,displayName,const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'InviteResolution(inviteId: $inviteId, type: $type, state: $state, familyName: $familyName, inviterCallName: $inviterCallName, inviterKind: $inviterKind, proposedKind: $proposedKind, message: $message, expiresAt: $expiresAt, relation: $relation, displayName: $displayName, children: $children)';
}


}

/// @nodoc
abstract mixin class _$InviteResolutionCopyWith<$Res> implements $InviteResolutionCopyWith<$Res> {
  factory _$InviteResolutionCopyWith(_InviteResolution value, $Res Function(_InviteResolution) _then) = __$InviteResolutionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'inviteId') String? inviteId,@JsonKey(name: 'type') String? type,@JsonKey(name: 'state') String? state,@JsonKey(name: 'familyName') String? familyName,@JsonKey(name: 'inviterCallName') String? inviterCallName,@JsonKey(name: 'inviterKind') String? inviterKind,@JsonKey(name: 'proposedKind') String? proposedKind,@JsonKey(name: 'message') String? message,@JsonKey(name: 'expiresAt') DateTime? expiresAt,@JsonKey(name: 'relation') String? relation,@JsonKey(name: 'displayName') String? displayName,@JsonKey(name: 'children') List<CircleSubjectRecord> children
});




}
/// @nodoc
class __$InviteResolutionCopyWithImpl<$Res>
    implements _$InviteResolutionCopyWith<$Res> {
  __$InviteResolutionCopyWithImpl(this._self, this._then);

  final _InviteResolution _self;
  final $Res Function(_InviteResolution) _then;

/// Create a copy of InviteResolution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inviteId = freezed,Object? type = freezed,Object? state = freezed,Object? familyName = freezed,Object? inviterCallName = freezed,Object? inviterKind = freezed,Object? proposedKind = freezed,Object? message = freezed,Object? expiresAt = freezed,Object? relation = freezed,Object? displayName = freezed,Object? children = null,}) {
  return _then(_InviteResolution(
inviteId: freezed == inviteId ? _self.inviteId : inviteId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,familyName: freezed == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String?,inviterCallName: freezed == inviterCallName ? _self.inviterCallName : inviterCallName // ignore: cast_nullable_to_non_nullable
as String?,inviterKind: freezed == inviterKind ? _self.inviterKind : inviterKind // ignore: cast_nullable_to_non_nullable
as String?,proposedKind: freezed == proposedKind ? _self.proposedKind : proposedKind // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,relation: freezed == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<CircleSubjectRecord>,
  ));
}


}

// dart format on
