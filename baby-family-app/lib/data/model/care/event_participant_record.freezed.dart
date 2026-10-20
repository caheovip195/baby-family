// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_participant_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventParticipantRecord {

@JsonKey(name: 'userId') String? get userId;
/// Create a copy of EventParticipantRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventParticipantRecordCopyWith<EventParticipantRecord> get copyWith => _$EventParticipantRecordCopyWithImpl<EventParticipantRecord>(this as EventParticipantRecord, _$identity);

  /// Serializes this EventParticipantRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventParticipantRecord&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'EventParticipantRecord(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $EventParticipantRecordCopyWith<$Res>  {
  factory $EventParticipantRecordCopyWith(EventParticipantRecord value, $Res Function(EventParticipantRecord) _then) = _$EventParticipantRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'userId') String? userId
});




}
/// @nodoc
class _$EventParticipantRecordCopyWithImpl<$Res>
    implements $EventParticipantRecordCopyWith<$Res> {
  _$EventParticipantRecordCopyWithImpl(this._self, this._then);

  final EventParticipantRecord _self;
  final $Res Function(EventParticipantRecord) _then;

/// Create a copy of EventParticipantRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = freezed,}) {
  return _then(_self.copyWith(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EventParticipantRecord].
extension EventParticipantRecordPatterns on EventParticipantRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventParticipantRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventParticipantRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventParticipantRecord value)  $default,){
final _that = this;
switch (_that) {
case _EventParticipantRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventParticipantRecord value)?  $default,){
final _that = this;
switch (_that) {
case _EventParticipantRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _EventParticipantRecord implements EventParticipantRecord {
  const _EventParticipantRecord({@JsonKey(name: 'userId') this.userId});
  factory _EventParticipantRecord.fromJson(Map<String, dynamic> json) => _$EventParticipantRecordFromJson(json);

@override@JsonKey(name: 'userId') final  String? userId;

/// Create a copy of EventParticipantRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventParticipantRecordCopyWith<_EventParticipantRecord> get copyWith => __$EventParticipantRecordCopyWithImpl<_EventParticipantRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventParticipantRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventParticipantRecord&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'EventParticipantRecord(userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$EventParticipantRecordCopyWith<$Res> implements $EventParticipantRecordCopyWith<$Res> {
  factory _$EventParticipantRecordCopyWith(_EventParticipantRecord value, $Res Function(_EventParticipantRecord) _then) = __$EventParticipantRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'userId') String? userId
});




}
/// @nodoc
class __$EventParticipantRecordCopyWithImpl<$Res>
    implements _$EventParticipantRecordCopyWith<$Res> {
  __$EventParticipantRecordCopyWithImpl(this._self, this._then);

  final _EventParticipantRecord _self;
  final $Res Function(_EventParticipantRecord) _then;

/// Create a copy of EventParticipantRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = freezed,}) {
  return _then(_EventParticipantRecord(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
