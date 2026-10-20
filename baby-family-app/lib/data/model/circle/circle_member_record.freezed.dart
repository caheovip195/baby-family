// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circle_member_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CircleMemberRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'userId') String? get userId;@JsonKey(name: 'displayName') String? get displayName;@JsonKey(name: 'relation') String? get relation;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'allowDownload') bool get allowDownload;@JsonKey(name: 'grants') List<CircleGrantRecord> get grants;@JsonKey(name: 'joinedAt') DateTime? get joinedAt;
/// Create a copy of CircleMemberRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleMemberRecordCopyWith<CircleMemberRecord> get copyWith => _$CircleMemberRecordCopyWithImpl<CircleMemberRecord>(this as CircleMemberRecord, _$identity);

  /// Serializes this CircleMemberRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleMemberRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.relation, relation) || other.relation == relation)&&(identical(other.status, status) || other.status == status)&&(identical(other.allowDownload, allowDownload) || other.allowDownload == allowDownload)&&const DeepCollectionEquality().equals(other.grants, grants)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,displayName,relation,status,allowDownload,const DeepCollectionEquality().hash(grants),joinedAt);

@override
String toString() {
  return 'CircleMemberRecord(id: $id, userId: $userId, displayName: $displayName, relation: $relation, status: $status, allowDownload: $allowDownload, grants: $grants, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class $CircleMemberRecordCopyWith<$Res>  {
  factory $CircleMemberRecordCopyWith(CircleMemberRecord value, $Res Function(CircleMemberRecord) _then) = _$CircleMemberRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'displayName') String? displayName,@JsonKey(name: 'relation') String? relation,@JsonKey(name: 'status') String? status,@JsonKey(name: 'allowDownload') bool allowDownload,@JsonKey(name: 'grants') List<CircleGrantRecord> grants,@JsonKey(name: 'joinedAt') DateTime? joinedAt
});




}
/// @nodoc
class _$CircleMemberRecordCopyWithImpl<$Res>
    implements $CircleMemberRecordCopyWith<$Res> {
  _$CircleMemberRecordCopyWithImpl(this._self, this._then);

  final CircleMemberRecord _self;
  final $Res Function(CircleMemberRecord) _then;

/// Create a copy of CircleMemberRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? displayName = freezed,Object? relation = freezed,Object? status = freezed,Object? allowDownload = null,Object? grants = null,Object? joinedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,relation: freezed == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,allowDownload: null == allowDownload ? _self.allowDownload : allowDownload // ignore: cast_nullable_to_non_nullable
as bool,grants: null == grants ? _self.grants : grants // ignore: cast_nullable_to_non_nullable
as List<CircleGrantRecord>,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CircleMemberRecord].
extension CircleMemberRecordPatterns on CircleMemberRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircleMemberRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircleMemberRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircleMemberRecord value)  $default,){
final _that = this;
switch (_that) {
case _CircleMemberRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircleMemberRecord value)?  $default,){
final _that = this;
switch (_that) {
case _CircleMemberRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CircleMemberRecord implements CircleMemberRecord {
  const _CircleMemberRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'userId') this.userId, @JsonKey(name: 'displayName') this.displayName, @JsonKey(name: 'relation') this.relation, @JsonKey(name: 'status') this.status, @JsonKey(name: 'allowDownload') this.allowDownload = false, @JsonKey(name: 'grants') final  List<CircleGrantRecord> grants = const <CircleGrantRecord>[], @JsonKey(name: 'joinedAt') this.joinedAt}): _grants = grants;
  factory _CircleMemberRecord.fromJson(Map<String, dynamic> json) => _$CircleMemberRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'userId') final  String? userId;
@override@JsonKey(name: 'displayName') final  String? displayName;
@override@JsonKey(name: 'relation') final  String? relation;
@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'allowDownload') final  bool allowDownload;
 final  List<CircleGrantRecord> _grants;
@override@JsonKey(name: 'grants') List<CircleGrantRecord> get grants {
  if (_grants is EqualUnmodifiableListView) return _grants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grants);
}

@override@JsonKey(name: 'joinedAt') final  DateTime? joinedAt;

/// Create a copy of CircleMemberRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircleMemberRecordCopyWith<_CircleMemberRecord> get copyWith => __$CircleMemberRecordCopyWithImpl<_CircleMemberRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircleMemberRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircleMemberRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.relation, relation) || other.relation == relation)&&(identical(other.status, status) || other.status == status)&&(identical(other.allowDownload, allowDownload) || other.allowDownload == allowDownload)&&const DeepCollectionEquality().equals(other._grants, _grants)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,displayName,relation,status,allowDownload,const DeepCollectionEquality().hash(_grants),joinedAt);

@override
String toString() {
  return 'CircleMemberRecord(id: $id, userId: $userId, displayName: $displayName, relation: $relation, status: $status, allowDownload: $allowDownload, grants: $grants, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class _$CircleMemberRecordCopyWith<$Res> implements $CircleMemberRecordCopyWith<$Res> {
  factory _$CircleMemberRecordCopyWith(_CircleMemberRecord value, $Res Function(_CircleMemberRecord) _then) = __$CircleMemberRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'displayName') String? displayName,@JsonKey(name: 'relation') String? relation,@JsonKey(name: 'status') String? status,@JsonKey(name: 'allowDownload') bool allowDownload,@JsonKey(name: 'grants') List<CircleGrantRecord> grants,@JsonKey(name: 'joinedAt') DateTime? joinedAt
});




}
/// @nodoc
class __$CircleMemberRecordCopyWithImpl<$Res>
    implements _$CircleMemberRecordCopyWith<$Res> {
  __$CircleMemberRecordCopyWithImpl(this._self, this._then);

  final _CircleMemberRecord _self;
  final $Res Function(_CircleMemberRecord) _then;

/// Create a copy of CircleMemberRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? displayName = freezed,Object? relation = freezed,Object? status = freezed,Object? allowDownload = null,Object? grants = null,Object? joinedAt = freezed,}) {
  return _then(_CircleMemberRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,relation: freezed == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,allowDownload: null == allowDownload ? _self.allowDownload : allowDownload // ignore: cast_nullable_to_non_nullable
as bool,grants: null == grants ? _self._grants : grants // ignore: cast_nullable_to_non_nullable
as List<CircleGrantRecord>,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
