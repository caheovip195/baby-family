// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_stats_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChildStatsRecord {

@JsonKey(name: 'memoryCount') int get memoryCount;@JsonKey(name: 'milestoneCount') int get milestoneCount;@JsonKey(name: 'photoCount') int get photoCount;@JsonKey(name: 'firstMemoryAt') DateTime? get firstMemoryAt;
/// Create a copy of ChildStatsRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildStatsRecordCopyWith<ChildStatsRecord> get copyWith => _$ChildStatsRecordCopyWithImpl<ChildStatsRecord>(this as ChildStatsRecord, _$identity);

  /// Serializes this ChildStatsRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChildStatsRecord&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&(identical(other.milestoneCount, milestoneCount) || other.milestoneCount == milestoneCount)&&(identical(other.photoCount, photoCount) || other.photoCount == photoCount)&&(identical(other.firstMemoryAt, firstMemoryAt) || other.firstMemoryAt == firstMemoryAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memoryCount,milestoneCount,photoCount,firstMemoryAt);

@override
String toString() {
  return 'ChildStatsRecord(memoryCount: $memoryCount, milestoneCount: $milestoneCount, photoCount: $photoCount, firstMemoryAt: $firstMemoryAt)';
}


}

/// @nodoc
abstract mixin class $ChildStatsRecordCopyWith<$Res>  {
  factory $ChildStatsRecordCopyWith(ChildStatsRecord value, $Res Function(ChildStatsRecord) _then) = _$ChildStatsRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'memoryCount') int memoryCount,@JsonKey(name: 'milestoneCount') int milestoneCount,@JsonKey(name: 'photoCount') int photoCount,@JsonKey(name: 'firstMemoryAt') DateTime? firstMemoryAt
});




}
/// @nodoc
class _$ChildStatsRecordCopyWithImpl<$Res>
    implements $ChildStatsRecordCopyWith<$Res> {
  _$ChildStatsRecordCopyWithImpl(this._self, this._then);

  final ChildStatsRecord _self;
  final $Res Function(ChildStatsRecord) _then;

/// Create a copy of ChildStatsRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memoryCount = null,Object? milestoneCount = null,Object? photoCount = null,Object? firstMemoryAt = freezed,}) {
  return _then(_self.copyWith(
memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,milestoneCount: null == milestoneCount ? _self.milestoneCount : milestoneCount // ignore: cast_nullable_to_non_nullable
as int,photoCount: null == photoCount ? _self.photoCount : photoCount // ignore: cast_nullable_to_non_nullable
as int,firstMemoryAt: freezed == firstMemoryAt ? _self.firstMemoryAt : firstMemoryAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChildStatsRecord].
extension ChildStatsRecordPatterns on ChildStatsRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChildStatsRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChildStatsRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChildStatsRecord value)  $default,){
final _that = this;
switch (_that) {
case _ChildStatsRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChildStatsRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ChildStatsRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChildStatsRecord implements ChildStatsRecord {
  const _ChildStatsRecord({@JsonKey(name: 'memoryCount') this.memoryCount = 0, @JsonKey(name: 'milestoneCount') this.milestoneCount = 0, @JsonKey(name: 'photoCount') this.photoCount = 0, @JsonKey(name: 'firstMemoryAt') this.firstMemoryAt});
  factory _ChildStatsRecord.fromJson(Map<String, dynamic> json) => _$ChildStatsRecordFromJson(json);

@override@JsonKey(name: 'memoryCount') final  int memoryCount;
@override@JsonKey(name: 'milestoneCount') final  int milestoneCount;
@override@JsonKey(name: 'photoCount') final  int photoCount;
@override@JsonKey(name: 'firstMemoryAt') final  DateTime? firstMemoryAt;

/// Create a copy of ChildStatsRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildStatsRecordCopyWith<_ChildStatsRecord> get copyWith => __$ChildStatsRecordCopyWithImpl<_ChildStatsRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChildStatsRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChildStatsRecord&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&(identical(other.milestoneCount, milestoneCount) || other.milestoneCount == milestoneCount)&&(identical(other.photoCount, photoCount) || other.photoCount == photoCount)&&(identical(other.firstMemoryAt, firstMemoryAt) || other.firstMemoryAt == firstMemoryAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memoryCount,milestoneCount,photoCount,firstMemoryAt);

@override
String toString() {
  return 'ChildStatsRecord(memoryCount: $memoryCount, milestoneCount: $milestoneCount, photoCount: $photoCount, firstMemoryAt: $firstMemoryAt)';
}


}

/// @nodoc
abstract mixin class _$ChildStatsRecordCopyWith<$Res> implements $ChildStatsRecordCopyWith<$Res> {
  factory _$ChildStatsRecordCopyWith(_ChildStatsRecord value, $Res Function(_ChildStatsRecord) _then) = __$ChildStatsRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'memoryCount') int memoryCount,@JsonKey(name: 'milestoneCount') int milestoneCount,@JsonKey(name: 'photoCount') int photoCount,@JsonKey(name: 'firstMemoryAt') DateTime? firstMemoryAt
});




}
/// @nodoc
class __$ChildStatsRecordCopyWithImpl<$Res>
    implements _$ChildStatsRecordCopyWith<$Res> {
  __$ChildStatsRecordCopyWithImpl(this._self, this._then);

  final _ChildStatsRecord _self;
  final $Res Function(_ChildStatsRecord) _then;

/// Create a copy of ChildStatsRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memoryCount = null,Object? milestoneCount = null,Object? photoCount = null,Object? firstMemoryAt = freezed,}) {
  return _then(_ChildStatsRecord(
memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,milestoneCount: null == milestoneCount ? _self.milestoneCount : milestoneCount // ignore: cast_nullable_to_non_nullable
as int,photoCount: null == photoCount ? _self.photoCount : photoCount // ignore: cast_nullable_to_non_nullable
as int,firstMemoryAt: freezed == firstMemoryAt ? _self.firstMemoryAt : firstMemoryAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
