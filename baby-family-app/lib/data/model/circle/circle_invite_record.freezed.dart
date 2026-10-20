// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circle_invite_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CircleInviteRecord {

@JsonKey(name: 'inviteId') String? get inviteId;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'relation') String? get relation;@JsonKey(name: 'displayName') String? get displayName;@JsonKey(name: 'grants') List<CircleGrantRecord> get grants;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'expiresAt') DateTime? get expiresAt;
/// Create a copy of CircleInviteRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleInviteRecordCopyWith<CircleInviteRecord> get copyWith => _$CircleInviteRecordCopyWithImpl<CircleInviteRecord>(this as CircleInviteRecord, _$identity);

  /// Serializes this CircleInviteRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleInviteRecord&&(identical(other.inviteId, inviteId) || other.inviteId == inviteId)&&(identical(other.status, status) || other.status == status)&&(identical(other.relation, relation) || other.relation == relation)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other.grants, grants)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inviteId,status,relation,displayName,const DeepCollectionEquality().hash(grants),createdAt,expiresAt);

@override
String toString() {
  return 'CircleInviteRecord(inviteId: $inviteId, status: $status, relation: $relation, displayName: $displayName, grants: $grants, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $CircleInviteRecordCopyWith<$Res>  {
  factory $CircleInviteRecordCopyWith(CircleInviteRecord value, $Res Function(CircleInviteRecord) _then) = _$CircleInviteRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'inviteId') String? inviteId,@JsonKey(name: 'status') String? status,@JsonKey(name: 'relation') String? relation,@JsonKey(name: 'displayName') String? displayName,@JsonKey(name: 'grants') List<CircleGrantRecord> grants,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'expiresAt') DateTime? expiresAt
});




}
/// @nodoc
class _$CircleInviteRecordCopyWithImpl<$Res>
    implements $CircleInviteRecordCopyWith<$Res> {
  _$CircleInviteRecordCopyWithImpl(this._self, this._then);

  final CircleInviteRecord _self;
  final $Res Function(CircleInviteRecord) _then;

/// Create a copy of CircleInviteRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inviteId = freezed,Object? status = freezed,Object? relation = freezed,Object? displayName = freezed,Object? grants = null,Object? createdAt = freezed,Object? expiresAt = freezed,}) {
  return _then(_self.copyWith(
inviteId: freezed == inviteId ? _self.inviteId : inviteId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,relation: freezed == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,grants: null == grants ? _self.grants : grants // ignore: cast_nullable_to_non_nullable
as List<CircleGrantRecord>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CircleInviteRecord].
extension CircleInviteRecordPatterns on CircleInviteRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircleInviteRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircleInviteRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircleInviteRecord value)  $default,){
final _that = this;
switch (_that) {
case _CircleInviteRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircleInviteRecord value)?  $default,){
final _that = this;
switch (_that) {
case _CircleInviteRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CircleInviteRecord implements CircleInviteRecord {
  const _CircleInviteRecord({@JsonKey(name: 'inviteId') this.inviteId, @JsonKey(name: 'status') this.status, @JsonKey(name: 'relation') this.relation, @JsonKey(name: 'displayName') this.displayName, @JsonKey(name: 'grants') final  List<CircleGrantRecord> grants = const <CircleGrantRecord>[], @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'expiresAt') this.expiresAt}): _grants = grants;
  factory _CircleInviteRecord.fromJson(Map<String, dynamic> json) => _$CircleInviteRecordFromJson(json);

@override@JsonKey(name: 'inviteId') final  String? inviteId;
@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'relation') final  String? relation;
@override@JsonKey(name: 'displayName') final  String? displayName;
 final  List<CircleGrantRecord> _grants;
@override@JsonKey(name: 'grants') List<CircleGrantRecord> get grants {
  if (_grants is EqualUnmodifiableListView) return _grants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grants);
}

@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
@override@JsonKey(name: 'expiresAt') final  DateTime? expiresAt;

/// Create a copy of CircleInviteRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircleInviteRecordCopyWith<_CircleInviteRecord> get copyWith => __$CircleInviteRecordCopyWithImpl<_CircleInviteRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircleInviteRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircleInviteRecord&&(identical(other.inviteId, inviteId) || other.inviteId == inviteId)&&(identical(other.status, status) || other.status == status)&&(identical(other.relation, relation) || other.relation == relation)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other._grants, _grants)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inviteId,status,relation,displayName,const DeepCollectionEquality().hash(_grants),createdAt,expiresAt);

@override
String toString() {
  return 'CircleInviteRecord(inviteId: $inviteId, status: $status, relation: $relation, displayName: $displayName, grants: $grants, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$CircleInviteRecordCopyWith<$Res> implements $CircleInviteRecordCopyWith<$Res> {
  factory _$CircleInviteRecordCopyWith(_CircleInviteRecord value, $Res Function(_CircleInviteRecord) _then) = __$CircleInviteRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'inviteId') String? inviteId,@JsonKey(name: 'status') String? status,@JsonKey(name: 'relation') String? relation,@JsonKey(name: 'displayName') String? displayName,@JsonKey(name: 'grants') List<CircleGrantRecord> grants,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'expiresAt') DateTime? expiresAt
});




}
/// @nodoc
class __$CircleInviteRecordCopyWithImpl<$Res>
    implements _$CircleInviteRecordCopyWith<$Res> {
  __$CircleInviteRecordCopyWithImpl(this._self, this._then);

  final _CircleInviteRecord _self;
  final $Res Function(_CircleInviteRecord) _then;

/// Create a copy of CircleInviteRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inviteId = freezed,Object? status = freezed,Object? relation = freezed,Object? displayName = freezed,Object? grants = null,Object? createdAt = freezed,Object? expiresAt = freezed,}) {
  return _then(_CircleInviteRecord(
inviteId: freezed == inviteId ? _self.inviteId : inviteId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,relation: freezed == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,grants: null == grants ? _self._grants : grants // ignore: cast_nullable_to_non_nullable
as List<CircleGrantRecord>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
