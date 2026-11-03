// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'month_recap_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthRecapRecord {

@JsonKey(name: 'childId') String? get childId;@JsonKey(name: 'monthIndex') int? get monthIndex;@JsonKey(name: 'start') String? get start;@JsonKey(name: 'end') String? get end;@JsonKey(name: 'moments') int get moments;@JsonKey(name: 'firsts') int get firsts;@JsonKey(name: 'voices') int get voices;@JsonKey(name: 'firstMemoryIds') List<String> get firstMemoryIds;@JsonKey(name: 'voiceMemoryIds') List<String> get voiceMemoryIds;
/// Create a copy of MonthRecapRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthRecapRecordCopyWith<MonthRecapRecord> get copyWith => _$MonthRecapRecordCopyWithImpl<MonthRecapRecord>(this as MonthRecapRecord, _$identity);

  /// Serializes this MonthRecapRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthRecapRecord&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.moments, moments) || other.moments == moments)&&(identical(other.firsts, firsts) || other.firsts == firsts)&&(identical(other.voices, voices) || other.voices == voices)&&const DeepCollectionEquality().equals(other.firstMemoryIds, firstMemoryIds)&&const DeepCollectionEquality().equals(other.voiceMemoryIds, voiceMemoryIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,monthIndex,start,end,moments,firsts,voices,const DeepCollectionEquality().hash(firstMemoryIds),const DeepCollectionEquality().hash(voiceMemoryIds));

@override
String toString() {
  return 'MonthRecapRecord(childId: $childId, monthIndex: $monthIndex, start: $start, end: $end, moments: $moments, firsts: $firsts, voices: $voices, firstMemoryIds: $firstMemoryIds, voiceMemoryIds: $voiceMemoryIds)';
}


}

/// @nodoc
abstract mixin class $MonthRecapRecordCopyWith<$Res>  {
  factory $MonthRecapRecordCopyWith(MonthRecapRecord value, $Res Function(MonthRecapRecord) _then) = _$MonthRecapRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'monthIndex') int? monthIndex,@JsonKey(name: 'start') String? start,@JsonKey(name: 'end') String? end,@JsonKey(name: 'moments') int moments,@JsonKey(name: 'firsts') int firsts,@JsonKey(name: 'voices') int voices,@JsonKey(name: 'firstMemoryIds') List<String> firstMemoryIds,@JsonKey(name: 'voiceMemoryIds') List<String> voiceMemoryIds
});




}
/// @nodoc
class _$MonthRecapRecordCopyWithImpl<$Res>
    implements $MonthRecapRecordCopyWith<$Res> {
  _$MonthRecapRecordCopyWithImpl(this._self, this._then);

  final MonthRecapRecord _self;
  final $Res Function(MonthRecapRecord) _then;

/// Create a copy of MonthRecapRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childId = freezed,Object? monthIndex = freezed,Object? start = freezed,Object? end = freezed,Object? moments = null,Object? firsts = null,Object? voices = null,Object? firstMemoryIds = null,Object? voiceMemoryIds = null,}) {
  return _then(_self.copyWith(
childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,monthIndex: freezed == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int?,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String?,moments: null == moments ? _self.moments : moments // ignore: cast_nullable_to_non_nullable
as int,firsts: null == firsts ? _self.firsts : firsts // ignore: cast_nullable_to_non_nullable
as int,voices: null == voices ? _self.voices : voices // ignore: cast_nullable_to_non_nullable
as int,firstMemoryIds: null == firstMemoryIds ? _self.firstMemoryIds : firstMemoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,voiceMemoryIds: null == voiceMemoryIds ? _self.voiceMemoryIds : voiceMemoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthRecapRecord].
extension MonthRecapRecordPatterns on MonthRecapRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthRecapRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthRecapRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthRecapRecord value)  $default,){
final _that = this;
switch (_that) {
case _MonthRecapRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthRecapRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MonthRecapRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MonthRecapRecord implements MonthRecapRecord {
  const _MonthRecapRecord({@JsonKey(name: 'childId') this.childId, @JsonKey(name: 'monthIndex') this.monthIndex, @JsonKey(name: 'start') this.start, @JsonKey(name: 'end') this.end, @JsonKey(name: 'moments') this.moments = 0, @JsonKey(name: 'firsts') this.firsts = 0, @JsonKey(name: 'voices') this.voices = 0, @JsonKey(name: 'firstMemoryIds') final  List<String> firstMemoryIds = const <String>[], @JsonKey(name: 'voiceMemoryIds') final  List<String> voiceMemoryIds = const <String>[]}): _firstMemoryIds = firstMemoryIds,_voiceMemoryIds = voiceMemoryIds;
  factory _MonthRecapRecord.fromJson(Map<String, dynamic> json) => _$MonthRecapRecordFromJson(json);

@override@JsonKey(name: 'childId') final  String? childId;
@override@JsonKey(name: 'monthIndex') final  int? monthIndex;
@override@JsonKey(name: 'start') final  String? start;
@override@JsonKey(name: 'end') final  String? end;
@override@JsonKey(name: 'moments') final  int moments;
@override@JsonKey(name: 'firsts') final  int firsts;
@override@JsonKey(name: 'voices') final  int voices;
 final  List<String> _firstMemoryIds;
@override@JsonKey(name: 'firstMemoryIds') List<String> get firstMemoryIds {
  if (_firstMemoryIds is EqualUnmodifiableListView) return _firstMemoryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_firstMemoryIds);
}

 final  List<String> _voiceMemoryIds;
@override@JsonKey(name: 'voiceMemoryIds') List<String> get voiceMemoryIds {
  if (_voiceMemoryIds is EqualUnmodifiableListView) return _voiceMemoryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_voiceMemoryIds);
}


/// Create a copy of MonthRecapRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthRecapRecordCopyWith<_MonthRecapRecord> get copyWith => __$MonthRecapRecordCopyWithImpl<_MonthRecapRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthRecapRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthRecapRecord&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.moments, moments) || other.moments == moments)&&(identical(other.firsts, firsts) || other.firsts == firsts)&&(identical(other.voices, voices) || other.voices == voices)&&const DeepCollectionEquality().equals(other._firstMemoryIds, _firstMemoryIds)&&const DeepCollectionEquality().equals(other._voiceMemoryIds, _voiceMemoryIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,monthIndex,start,end,moments,firsts,voices,const DeepCollectionEquality().hash(_firstMemoryIds),const DeepCollectionEquality().hash(_voiceMemoryIds));

@override
String toString() {
  return 'MonthRecapRecord(childId: $childId, monthIndex: $monthIndex, start: $start, end: $end, moments: $moments, firsts: $firsts, voices: $voices, firstMemoryIds: $firstMemoryIds, voiceMemoryIds: $voiceMemoryIds)';
}


}

/// @nodoc
abstract mixin class _$MonthRecapRecordCopyWith<$Res> implements $MonthRecapRecordCopyWith<$Res> {
  factory _$MonthRecapRecordCopyWith(_MonthRecapRecord value, $Res Function(_MonthRecapRecord) _then) = __$MonthRecapRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'monthIndex') int? monthIndex,@JsonKey(name: 'start') String? start,@JsonKey(name: 'end') String? end,@JsonKey(name: 'moments') int moments,@JsonKey(name: 'firsts') int firsts,@JsonKey(name: 'voices') int voices,@JsonKey(name: 'firstMemoryIds') List<String> firstMemoryIds,@JsonKey(name: 'voiceMemoryIds') List<String> voiceMemoryIds
});




}
/// @nodoc
class __$MonthRecapRecordCopyWithImpl<$Res>
    implements _$MonthRecapRecordCopyWith<$Res> {
  __$MonthRecapRecordCopyWithImpl(this._self, this._then);

  final _MonthRecapRecord _self;
  final $Res Function(_MonthRecapRecord) _then;

/// Create a copy of MonthRecapRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childId = freezed,Object? monthIndex = freezed,Object? start = freezed,Object? end = freezed,Object? moments = null,Object? firsts = null,Object? voices = null,Object? firstMemoryIds = null,Object? voiceMemoryIds = null,}) {
  return _then(_MonthRecapRecord(
childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,monthIndex: freezed == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int?,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String?,moments: null == moments ? _self.moments : moments // ignore: cast_nullable_to_non_nullable
as int,firsts: null == firsts ? _self.firsts : firsts // ignore: cast_nullable_to_non_nullable
as int,voices: null == voices ? _self.voices : voices // ignore: cast_nullable_to_non_nullable
as int,firstMemoryIds: null == firstMemoryIds ? _self._firstMemoryIds : firstMemoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,voiceMemoryIds: null == voiceMemoryIds ? _self._voiceMemoryIds : voiceMemoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
