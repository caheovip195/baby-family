// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'milestone_achieved_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MilestoneAchievedRecord {

@JsonKey(name: 'milestoneId') String? get milestoneId;@JsonKey(name: 'memoryId') String? get memoryId;@JsonKey(name: 'occurredOn') DateTime? get occurredOn;
/// Create a copy of MilestoneAchievedRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MilestoneAchievedRecordCopyWith<MilestoneAchievedRecord> get copyWith => _$MilestoneAchievedRecordCopyWithImpl<MilestoneAchievedRecord>(this as MilestoneAchievedRecord, _$identity);

  /// Serializes this MilestoneAchievedRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MilestoneAchievedRecord&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,milestoneId,memoryId,occurredOn);

@override
String toString() {
  return 'MilestoneAchievedRecord(milestoneId: $milestoneId, memoryId: $memoryId, occurredOn: $occurredOn)';
}


}

/// @nodoc
abstract mixin class $MilestoneAchievedRecordCopyWith<$Res>  {
  factory $MilestoneAchievedRecordCopyWith(MilestoneAchievedRecord value, $Res Function(MilestoneAchievedRecord) _then) = _$MilestoneAchievedRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'milestoneId') String? milestoneId,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'occurredOn') DateTime? occurredOn
});




}
/// @nodoc
class _$MilestoneAchievedRecordCopyWithImpl<$Res>
    implements $MilestoneAchievedRecordCopyWith<$Res> {
  _$MilestoneAchievedRecordCopyWithImpl(this._self, this._then);

  final MilestoneAchievedRecord _self;
  final $Res Function(MilestoneAchievedRecord) _then;

/// Create a copy of MilestoneAchievedRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? milestoneId = freezed,Object? memoryId = freezed,Object? occurredOn = freezed,}) {
  return _then(_self.copyWith(
milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,occurredOn: freezed == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MilestoneAchievedRecord].
extension MilestoneAchievedRecordPatterns on MilestoneAchievedRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MilestoneAchievedRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MilestoneAchievedRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MilestoneAchievedRecord value)  $default,){
final _that = this;
switch (_that) {
case _MilestoneAchievedRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MilestoneAchievedRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MilestoneAchievedRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MilestoneAchievedRecord implements MilestoneAchievedRecord {
  const _MilestoneAchievedRecord({@JsonKey(name: 'milestoneId') this.milestoneId, @JsonKey(name: 'memoryId') this.memoryId, @JsonKey(name: 'occurredOn') this.occurredOn});
  factory _MilestoneAchievedRecord.fromJson(Map<String, dynamic> json) => _$MilestoneAchievedRecordFromJson(json);

@override@JsonKey(name: 'milestoneId') final  String? milestoneId;
@override@JsonKey(name: 'memoryId') final  String? memoryId;
@override@JsonKey(name: 'occurredOn') final  DateTime? occurredOn;

/// Create a copy of MilestoneAchievedRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MilestoneAchievedRecordCopyWith<_MilestoneAchievedRecord> get copyWith => __$MilestoneAchievedRecordCopyWithImpl<_MilestoneAchievedRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MilestoneAchievedRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MilestoneAchievedRecord&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,milestoneId,memoryId,occurredOn);

@override
String toString() {
  return 'MilestoneAchievedRecord(milestoneId: $milestoneId, memoryId: $memoryId, occurredOn: $occurredOn)';
}


}

/// @nodoc
abstract mixin class _$MilestoneAchievedRecordCopyWith<$Res> implements $MilestoneAchievedRecordCopyWith<$Res> {
  factory _$MilestoneAchievedRecordCopyWith(_MilestoneAchievedRecord value, $Res Function(_MilestoneAchievedRecord) _then) = __$MilestoneAchievedRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'milestoneId') String? milestoneId,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'occurredOn') DateTime? occurredOn
});




}
/// @nodoc
class __$MilestoneAchievedRecordCopyWithImpl<$Res>
    implements _$MilestoneAchievedRecordCopyWith<$Res> {
  __$MilestoneAchievedRecordCopyWithImpl(this._self, this._then);

  final _MilestoneAchievedRecord _self;
  final $Res Function(_MilestoneAchievedRecord) _then;

/// Create a copy of MilestoneAchievedRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? milestoneId = freezed,Object? memoryId = freezed,Object? occurredOn = freezed,}) {
  return _then(_MilestoneAchievedRecord(
milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,occurredOn: freezed == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
