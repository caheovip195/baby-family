// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'month_recap.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthRecap {

@JsonKey(name: 'childId') String get childId;@JsonKey(name: 'monthIndex') int get monthIndex;@JsonKey(name: 'start') DateTime get start;@JsonKey(name: 'end') DateTime get end;@JsonKey(name: 'headline') String get headline;@JsonKey(name: 'moments') int get moments;@JsonKey(name: 'firsts') int get firsts;@JsonKey(name: 'voices') int get voices;@JsonKey(name: 'previousPhotoAsset') String? get previousPhotoAsset;@JsonKey(name: 'currentPhotoAsset') String? get currentPhotoAsset;@JsonKey(name: 'firstMemories') List<Memory> get firstMemories;@JsonKey(name: 'voiceMemories') List<Memory> get voiceMemories;@JsonKey(name: 'pageCount') int get pageCount;
/// Create a copy of MonthRecap
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthRecapCopyWith<MonthRecap> get copyWith => _$MonthRecapCopyWithImpl<MonthRecap>(this as MonthRecap, _$identity);

  /// Serializes this MonthRecap to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthRecap&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.moments, moments) || other.moments == moments)&&(identical(other.firsts, firsts) || other.firsts == firsts)&&(identical(other.voices, voices) || other.voices == voices)&&(identical(other.previousPhotoAsset, previousPhotoAsset) || other.previousPhotoAsset == previousPhotoAsset)&&(identical(other.currentPhotoAsset, currentPhotoAsset) || other.currentPhotoAsset == currentPhotoAsset)&&const DeepCollectionEquality().equals(other.firstMemories, firstMemories)&&const DeepCollectionEquality().equals(other.voiceMemories, voiceMemories)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,monthIndex,start,end,headline,moments,firsts,voices,previousPhotoAsset,currentPhotoAsset,const DeepCollectionEquality().hash(firstMemories),const DeepCollectionEquality().hash(voiceMemories),pageCount);

@override
String toString() {
  return 'MonthRecap(childId: $childId, monthIndex: $monthIndex, start: $start, end: $end, headline: $headline, moments: $moments, firsts: $firsts, voices: $voices, previousPhotoAsset: $previousPhotoAsset, currentPhotoAsset: $currentPhotoAsset, firstMemories: $firstMemories, voiceMemories: $voiceMemories, pageCount: $pageCount)';
}


}

/// @nodoc
abstract mixin class $MonthRecapCopyWith<$Res>  {
  factory $MonthRecapCopyWith(MonthRecap value, $Res Function(MonthRecap) _then) = _$MonthRecapCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'childId') String childId,@JsonKey(name: 'monthIndex') int monthIndex,@JsonKey(name: 'start') DateTime start,@JsonKey(name: 'end') DateTime end,@JsonKey(name: 'headline') String headline,@JsonKey(name: 'moments') int moments,@JsonKey(name: 'firsts') int firsts,@JsonKey(name: 'voices') int voices,@JsonKey(name: 'previousPhotoAsset') String? previousPhotoAsset,@JsonKey(name: 'currentPhotoAsset') String? currentPhotoAsset,@JsonKey(name: 'firstMemories') List<Memory> firstMemories,@JsonKey(name: 'voiceMemories') List<Memory> voiceMemories,@JsonKey(name: 'pageCount') int pageCount
});




}
/// @nodoc
class _$MonthRecapCopyWithImpl<$Res>
    implements $MonthRecapCopyWith<$Res> {
  _$MonthRecapCopyWithImpl(this._self, this._then);

  final MonthRecap _self;
  final $Res Function(MonthRecap) _then;

/// Create a copy of MonthRecap
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childId = null,Object? monthIndex = null,Object? start = null,Object? end = null,Object? headline = null,Object? moments = null,Object? firsts = null,Object? voices = null,Object? previousPhotoAsset = freezed,Object? currentPhotoAsset = freezed,Object? firstMemories = null,Object? voiceMemories = null,Object? pageCount = null,}) {
  return _then(_self.copyWith(
childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,monthIndex: null == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,moments: null == moments ? _self.moments : moments // ignore: cast_nullable_to_non_nullable
as int,firsts: null == firsts ? _self.firsts : firsts // ignore: cast_nullable_to_non_nullable
as int,voices: null == voices ? _self.voices : voices // ignore: cast_nullable_to_non_nullable
as int,previousPhotoAsset: freezed == previousPhotoAsset ? _self.previousPhotoAsset : previousPhotoAsset // ignore: cast_nullable_to_non_nullable
as String?,currentPhotoAsset: freezed == currentPhotoAsset ? _self.currentPhotoAsset : currentPhotoAsset // ignore: cast_nullable_to_non_nullable
as String?,firstMemories: null == firstMemories ? _self.firstMemories : firstMemories // ignore: cast_nullable_to_non_nullable
as List<Memory>,voiceMemories: null == voiceMemories ? _self.voiceMemories : voiceMemories // ignore: cast_nullable_to_non_nullable
as List<Memory>,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthRecap].
extension MonthRecapPatterns on MonthRecap {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthRecap value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthRecap() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthRecap value)  $default,){
final _that = this;
switch (_that) {
case _MonthRecap():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthRecap value)?  $default,){
final _that = this;
switch (_that) {
case _MonthRecap() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MonthRecap implements MonthRecap {
  const _MonthRecap({@JsonKey(name: 'childId') required this.childId, @JsonKey(name: 'monthIndex') required this.monthIndex, @JsonKey(name: 'start') required this.start, @JsonKey(name: 'end') required this.end, @JsonKey(name: 'headline') this.headline = '', @JsonKey(name: 'moments') this.moments = 0, @JsonKey(name: 'firsts') this.firsts = 0, @JsonKey(name: 'voices') this.voices = 0, @JsonKey(name: 'previousPhotoAsset') this.previousPhotoAsset, @JsonKey(name: 'currentPhotoAsset') this.currentPhotoAsset, @JsonKey(name: 'firstMemories') final  List<Memory> firstMemories = const [], @JsonKey(name: 'voiceMemories') final  List<Memory> voiceMemories = const [], @JsonKey(name: 'pageCount') this.pageCount = 1}): _firstMemories = firstMemories,_voiceMemories = voiceMemories;
  factory _MonthRecap.fromJson(Map<String, dynamic> json) => _$MonthRecapFromJson(json);

@override@JsonKey(name: 'childId') final  String childId;
@override@JsonKey(name: 'monthIndex') final  int monthIndex;
@override@JsonKey(name: 'start') final  DateTime start;
@override@JsonKey(name: 'end') final  DateTime end;
@override@JsonKey(name: 'headline') final  String headline;
@override@JsonKey(name: 'moments') final  int moments;
@override@JsonKey(name: 'firsts') final  int firsts;
@override@JsonKey(name: 'voices') final  int voices;
@override@JsonKey(name: 'previousPhotoAsset') final  String? previousPhotoAsset;
@override@JsonKey(name: 'currentPhotoAsset') final  String? currentPhotoAsset;
 final  List<Memory> _firstMemories;
@override@JsonKey(name: 'firstMemories') List<Memory> get firstMemories {
  if (_firstMemories is EqualUnmodifiableListView) return _firstMemories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_firstMemories);
}

 final  List<Memory> _voiceMemories;
@override@JsonKey(name: 'voiceMemories') List<Memory> get voiceMemories {
  if (_voiceMemories is EqualUnmodifiableListView) return _voiceMemories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_voiceMemories);
}

@override@JsonKey(name: 'pageCount') final  int pageCount;

/// Create a copy of MonthRecap
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthRecapCopyWith<_MonthRecap> get copyWith => __$MonthRecapCopyWithImpl<_MonthRecap>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthRecapToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthRecap&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.moments, moments) || other.moments == moments)&&(identical(other.firsts, firsts) || other.firsts == firsts)&&(identical(other.voices, voices) || other.voices == voices)&&(identical(other.previousPhotoAsset, previousPhotoAsset) || other.previousPhotoAsset == previousPhotoAsset)&&(identical(other.currentPhotoAsset, currentPhotoAsset) || other.currentPhotoAsset == currentPhotoAsset)&&const DeepCollectionEquality().equals(other._firstMemories, _firstMemories)&&const DeepCollectionEquality().equals(other._voiceMemories, _voiceMemories)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,monthIndex,start,end,headline,moments,firsts,voices,previousPhotoAsset,currentPhotoAsset,const DeepCollectionEquality().hash(_firstMemories),const DeepCollectionEquality().hash(_voiceMemories),pageCount);

@override
String toString() {
  return 'MonthRecap(childId: $childId, monthIndex: $monthIndex, start: $start, end: $end, headline: $headline, moments: $moments, firsts: $firsts, voices: $voices, previousPhotoAsset: $previousPhotoAsset, currentPhotoAsset: $currentPhotoAsset, firstMemories: $firstMemories, voiceMemories: $voiceMemories, pageCount: $pageCount)';
}


}

/// @nodoc
abstract mixin class _$MonthRecapCopyWith<$Res> implements $MonthRecapCopyWith<$Res> {
  factory _$MonthRecapCopyWith(_MonthRecap value, $Res Function(_MonthRecap) _then) = __$MonthRecapCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'childId') String childId,@JsonKey(name: 'monthIndex') int monthIndex,@JsonKey(name: 'start') DateTime start,@JsonKey(name: 'end') DateTime end,@JsonKey(name: 'headline') String headline,@JsonKey(name: 'moments') int moments,@JsonKey(name: 'firsts') int firsts,@JsonKey(name: 'voices') int voices,@JsonKey(name: 'previousPhotoAsset') String? previousPhotoAsset,@JsonKey(name: 'currentPhotoAsset') String? currentPhotoAsset,@JsonKey(name: 'firstMemories') List<Memory> firstMemories,@JsonKey(name: 'voiceMemories') List<Memory> voiceMemories,@JsonKey(name: 'pageCount') int pageCount
});




}
/// @nodoc
class __$MonthRecapCopyWithImpl<$Res>
    implements _$MonthRecapCopyWith<$Res> {
  __$MonthRecapCopyWithImpl(this._self, this._then);

  final _MonthRecap _self;
  final $Res Function(_MonthRecap) _then;

/// Create a copy of MonthRecap
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childId = null,Object? monthIndex = null,Object? start = null,Object? end = null,Object? headline = null,Object? moments = null,Object? firsts = null,Object? voices = null,Object? previousPhotoAsset = freezed,Object? currentPhotoAsset = freezed,Object? firstMemories = null,Object? voiceMemories = null,Object? pageCount = null,}) {
  return _then(_MonthRecap(
childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,monthIndex: null == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,moments: null == moments ? _self.moments : moments // ignore: cast_nullable_to_non_nullable
as int,firsts: null == firsts ? _self.firsts : firsts // ignore: cast_nullable_to_non_nullable
as int,voices: null == voices ? _self.voices : voices // ignore: cast_nullable_to_non_nullable
as int,previousPhotoAsset: freezed == previousPhotoAsset ? _self.previousPhotoAsset : previousPhotoAsset // ignore: cast_nullable_to_non_nullable
as String?,currentPhotoAsset: freezed == currentPhotoAsset ? _self.currentPhotoAsset : currentPhotoAsset // ignore: cast_nullable_to_non_nullable
as String?,firstMemories: null == firstMemories ? _self._firstMemories : firstMemories // ignore: cast_nullable_to_non_nullable
as List<Memory>,voiceMemories: null == voiceMemories ? _self._voiceMemories : voiceMemories // ignore: cast_nullable_to_non_nullable
as List<Memory>,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
