// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'week_stats_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeekStatsRecord {

@JsonKey(name: 'weekStart') String? get weekStart;@JsonKey(name: 'memoryCount') int get memoryCount;@JsonKey(name: 'photoCount') int get photoCount;@JsonKey(name: 'videoCount') int get videoCount;@JsonKey(name: 'milestoneCount') int get milestoneCount;@JsonKey(name: 'missionsDone') int? get missionsDone;
/// Create a copy of WeekStatsRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekStatsRecordCopyWith<WeekStatsRecord> get copyWith => _$WeekStatsRecordCopyWithImpl<WeekStatsRecord>(this as WeekStatsRecord, _$identity);

  /// Serializes this WeekStatsRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekStatsRecord&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&(identical(other.photoCount, photoCount) || other.photoCount == photoCount)&&(identical(other.videoCount, videoCount) || other.videoCount == videoCount)&&(identical(other.milestoneCount, milestoneCount) || other.milestoneCount == milestoneCount)&&(identical(other.missionsDone, missionsDone) || other.missionsDone == missionsDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weekStart,memoryCount,photoCount,videoCount,milestoneCount,missionsDone);

@override
String toString() {
  return 'WeekStatsRecord(weekStart: $weekStart, memoryCount: $memoryCount, photoCount: $photoCount, videoCount: $videoCount, milestoneCount: $milestoneCount, missionsDone: $missionsDone)';
}


}

/// @nodoc
abstract mixin class $WeekStatsRecordCopyWith<$Res>  {
  factory $WeekStatsRecordCopyWith(WeekStatsRecord value, $Res Function(WeekStatsRecord) _then) = _$WeekStatsRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'weekStart') String? weekStart,@JsonKey(name: 'memoryCount') int memoryCount,@JsonKey(name: 'photoCount') int photoCount,@JsonKey(name: 'videoCount') int videoCount,@JsonKey(name: 'milestoneCount') int milestoneCount,@JsonKey(name: 'missionsDone') int? missionsDone
});




}
/// @nodoc
class _$WeekStatsRecordCopyWithImpl<$Res>
    implements $WeekStatsRecordCopyWith<$Res> {
  _$WeekStatsRecordCopyWithImpl(this._self, this._then);

  final WeekStatsRecord _self;
  final $Res Function(WeekStatsRecord) _then;

/// Create a copy of WeekStatsRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekStart = freezed,Object? memoryCount = null,Object? photoCount = null,Object? videoCount = null,Object? milestoneCount = null,Object? missionsDone = freezed,}) {
  return _then(_self.copyWith(
weekStart: freezed == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as String?,memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,photoCount: null == photoCount ? _self.photoCount : photoCount // ignore: cast_nullable_to_non_nullable
as int,videoCount: null == videoCount ? _self.videoCount : videoCount // ignore: cast_nullable_to_non_nullable
as int,milestoneCount: null == milestoneCount ? _self.milestoneCount : milestoneCount // ignore: cast_nullable_to_non_nullable
as int,missionsDone: freezed == missionsDone ? _self.missionsDone : missionsDone // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekStatsRecord].
extension WeekStatsRecordPatterns on WeekStatsRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekStatsRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekStatsRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekStatsRecord value)  $default,){
final _that = this;
switch (_that) {
case _WeekStatsRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekStatsRecord value)?  $default,){
final _that = this;
switch (_that) {
case _WeekStatsRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _WeekStatsRecord implements WeekStatsRecord {
  const _WeekStatsRecord({@JsonKey(name: 'weekStart') this.weekStart, @JsonKey(name: 'memoryCount') this.memoryCount = 0, @JsonKey(name: 'photoCount') this.photoCount = 0, @JsonKey(name: 'videoCount') this.videoCount = 0, @JsonKey(name: 'milestoneCount') this.milestoneCount = 0, @JsonKey(name: 'missionsDone') this.missionsDone});
  factory _WeekStatsRecord.fromJson(Map<String, dynamic> json) => _$WeekStatsRecordFromJson(json);

@override@JsonKey(name: 'weekStart') final  String? weekStart;
@override@JsonKey(name: 'memoryCount') final  int memoryCount;
@override@JsonKey(name: 'photoCount') final  int photoCount;
@override@JsonKey(name: 'videoCount') final  int videoCount;
@override@JsonKey(name: 'milestoneCount') final  int milestoneCount;
@override@JsonKey(name: 'missionsDone') final  int? missionsDone;

/// Create a copy of WeekStatsRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekStatsRecordCopyWith<_WeekStatsRecord> get copyWith => __$WeekStatsRecordCopyWithImpl<_WeekStatsRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeekStatsRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekStatsRecord&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&(identical(other.photoCount, photoCount) || other.photoCount == photoCount)&&(identical(other.videoCount, videoCount) || other.videoCount == videoCount)&&(identical(other.milestoneCount, milestoneCount) || other.milestoneCount == milestoneCount)&&(identical(other.missionsDone, missionsDone) || other.missionsDone == missionsDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weekStart,memoryCount,photoCount,videoCount,milestoneCount,missionsDone);

@override
String toString() {
  return 'WeekStatsRecord(weekStart: $weekStart, memoryCount: $memoryCount, photoCount: $photoCount, videoCount: $videoCount, milestoneCount: $milestoneCount, missionsDone: $missionsDone)';
}


}

/// @nodoc
abstract mixin class _$WeekStatsRecordCopyWith<$Res> implements $WeekStatsRecordCopyWith<$Res> {
  factory _$WeekStatsRecordCopyWith(_WeekStatsRecord value, $Res Function(_WeekStatsRecord) _then) = __$WeekStatsRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'weekStart') String? weekStart,@JsonKey(name: 'memoryCount') int memoryCount,@JsonKey(name: 'photoCount') int photoCount,@JsonKey(name: 'videoCount') int videoCount,@JsonKey(name: 'milestoneCount') int milestoneCount,@JsonKey(name: 'missionsDone') int? missionsDone
});




}
/// @nodoc
class __$WeekStatsRecordCopyWithImpl<$Res>
    implements _$WeekStatsRecordCopyWith<$Res> {
  __$WeekStatsRecordCopyWithImpl(this._self, this._then);

  final _WeekStatsRecord _self;
  final $Res Function(_WeekStatsRecord) _then;

/// Create a copy of WeekStatsRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekStart = freezed,Object? memoryCount = null,Object? photoCount = null,Object? videoCount = null,Object? milestoneCount = null,Object? missionsDone = freezed,}) {
  return _then(_WeekStatsRecord(
weekStart: freezed == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as String?,memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,photoCount: null == photoCount ? _self.photoCount : photoCount // ignore: cast_nullable_to_non_nullable
as int,videoCount: null == videoCount ? _self.videoCount : videoCount // ignore: cast_nullable_to_non_nullable
as int,milestoneCount: null == milestoneCount ? _self.milestoneCount : milestoneCount // ignore: cast_nullable_to_non_nullable
as int,missionsDone: freezed == missionsDone ? _self.missionsDone : missionsDone // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
