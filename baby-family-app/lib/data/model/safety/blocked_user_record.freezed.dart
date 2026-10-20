// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocked_user_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockedUserRecord {

@JsonKey(name: 'userId') String? get userId;@JsonKey(name: 'displayName') String? get displayName;@JsonKey(name: 'blockedAt') DateTime? get blockedAt;
/// Create a copy of BlockedUserRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockedUserRecordCopyWith<BlockedUserRecord> get copyWith => _$BlockedUserRecordCopyWithImpl<BlockedUserRecord>(this as BlockedUserRecord, _$identity);

  /// Serializes this BlockedUserRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockedUserRecord&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.blockedAt, blockedAt) || other.blockedAt == blockedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,blockedAt);

@override
String toString() {
  return 'BlockedUserRecord(userId: $userId, displayName: $displayName, blockedAt: $blockedAt)';
}


}

/// @nodoc
abstract mixin class $BlockedUserRecordCopyWith<$Res>  {
  factory $BlockedUserRecordCopyWith(BlockedUserRecord value, $Res Function(BlockedUserRecord) _then) = _$BlockedUserRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'displayName') String? displayName,@JsonKey(name: 'blockedAt') DateTime? blockedAt
});




}
/// @nodoc
class _$BlockedUserRecordCopyWithImpl<$Res>
    implements $BlockedUserRecordCopyWith<$Res> {
  _$BlockedUserRecordCopyWithImpl(this._self, this._then);

  final BlockedUserRecord _self;
  final $Res Function(BlockedUserRecord) _then;

/// Create a copy of BlockedUserRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = freezed,Object? displayName = freezed,Object? blockedAt = freezed,}) {
  return _then(_self.copyWith(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,blockedAt: freezed == blockedAt ? _self.blockedAt : blockedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BlockedUserRecord].
extension BlockedUserRecordPatterns on BlockedUserRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlockedUserRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlockedUserRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlockedUserRecord value)  $default,){
final _that = this;
switch (_that) {
case _BlockedUserRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlockedUserRecord value)?  $default,){
final _that = this;
switch (_that) {
case _BlockedUserRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BlockedUserRecord implements BlockedUserRecord {
  const _BlockedUserRecord({@JsonKey(name: 'userId') this.userId, @JsonKey(name: 'displayName') this.displayName, @JsonKey(name: 'blockedAt') this.blockedAt});
  factory _BlockedUserRecord.fromJson(Map<String, dynamic> json) => _$BlockedUserRecordFromJson(json);

@override@JsonKey(name: 'userId') final  String? userId;
@override@JsonKey(name: 'displayName') final  String? displayName;
@override@JsonKey(name: 'blockedAt') final  DateTime? blockedAt;

/// Create a copy of BlockedUserRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockedUserRecordCopyWith<_BlockedUserRecord> get copyWith => __$BlockedUserRecordCopyWithImpl<_BlockedUserRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockedUserRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockedUserRecord&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.blockedAt, blockedAt) || other.blockedAt == blockedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,blockedAt);

@override
String toString() {
  return 'BlockedUserRecord(userId: $userId, displayName: $displayName, blockedAt: $blockedAt)';
}


}

/// @nodoc
abstract mixin class _$BlockedUserRecordCopyWith<$Res> implements $BlockedUserRecordCopyWith<$Res> {
  factory _$BlockedUserRecordCopyWith(_BlockedUserRecord value, $Res Function(_BlockedUserRecord) _then) = __$BlockedUserRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'displayName') String? displayName,@JsonKey(name: 'blockedAt') DateTime? blockedAt
});




}
/// @nodoc
class __$BlockedUserRecordCopyWithImpl<$Res>
    implements _$BlockedUserRecordCopyWith<$Res> {
  __$BlockedUserRecordCopyWithImpl(this._self, this._then);

  final _BlockedUserRecord _self;
  final $Res Function(_BlockedUserRecord) _then;

/// Create a copy of BlockedUserRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = freezed,Object? displayName = freezed,Object? blockedAt = freezed,}) {
  return _then(_BlockedUserRecord(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,blockedAt: freezed == blockedAt ? _self.blockedAt : blockedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
