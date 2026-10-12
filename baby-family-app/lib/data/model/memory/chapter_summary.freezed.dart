// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChapterSummary {

@JsonKey(name: 'childId') String get childId;@JsonKey(name: 'monthIndex') int get monthIndex;@JsonKey(name: 'start') DateTime get start;@JsonKey(name: 'end') DateTime get end;@JsonKey(name: 'memoryCount') int get memoryCount;@JsonKey(name: 'firstsCount') int get firstsCount;@JsonKey(name: 'voiceCount') int get voiceCount;@JsonKey(name: 'hasMonthlyPhoto') bool get hasMonthlyPhoto;@JsonKey(name: 'coverAsset') String? get coverAsset;@JsonKey(name: 'current') bool get current;
/// Create a copy of ChapterSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterSummaryCopyWith<ChapterSummary> get copyWith => _$ChapterSummaryCopyWithImpl<ChapterSummary>(this as ChapterSummary, _$identity);

  /// Serializes this ChapterSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterSummary&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&(identical(other.firstsCount, firstsCount) || other.firstsCount == firstsCount)&&(identical(other.voiceCount, voiceCount) || other.voiceCount == voiceCount)&&(identical(other.hasMonthlyPhoto, hasMonthlyPhoto) || other.hasMonthlyPhoto == hasMonthlyPhoto)&&(identical(other.coverAsset, coverAsset) || other.coverAsset == coverAsset)&&(identical(other.current, current) || other.current == current));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,monthIndex,start,end,memoryCount,firstsCount,voiceCount,hasMonthlyPhoto,coverAsset,current);

@override
String toString() {
  return 'ChapterSummary(childId: $childId, monthIndex: $monthIndex, start: $start, end: $end, memoryCount: $memoryCount, firstsCount: $firstsCount, voiceCount: $voiceCount, hasMonthlyPhoto: $hasMonthlyPhoto, coverAsset: $coverAsset, current: $current)';
}


}

/// @nodoc
abstract mixin class $ChapterSummaryCopyWith<$Res>  {
  factory $ChapterSummaryCopyWith(ChapterSummary value, $Res Function(ChapterSummary) _then) = _$ChapterSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'childId') String childId,@JsonKey(name: 'monthIndex') int monthIndex,@JsonKey(name: 'start') DateTime start,@JsonKey(name: 'end') DateTime end,@JsonKey(name: 'memoryCount') int memoryCount,@JsonKey(name: 'firstsCount') int firstsCount,@JsonKey(name: 'voiceCount') int voiceCount,@JsonKey(name: 'hasMonthlyPhoto') bool hasMonthlyPhoto,@JsonKey(name: 'coverAsset') String? coverAsset,@JsonKey(name: 'current') bool current
});




}
/// @nodoc
class _$ChapterSummaryCopyWithImpl<$Res>
    implements $ChapterSummaryCopyWith<$Res> {
  _$ChapterSummaryCopyWithImpl(this._self, this._then);

  final ChapterSummary _self;
  final $Res Function(ChapterSummary) _then;

/// Create a copy of ChapterSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childId = null,Object? monthIndex = null,Object? start = null,Object? end = null,Object? memoryCount = null,Object? firstsCount = null,Object? voiceCount = null,Object? hasMonthlyPhoto = null,Object? coverAsset = freezed,Object? current = null,}) {
  return _then(_self.copyWith(
childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,monthIndex: null == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,firstsCount: null == firstsCount ? _self.firstsCount : firstsCount // ignore: cast_nullable_to_non_nullable
as int,voiceCount: null == voiceCount ? _self.voiceCount : voiceCount // ignore: cast_nullable_to_non_nullable
as int,hasMonthlyPhoto: null == hasMonthlyPhoto ? _self.hasMonthlyPhoto : hasMonthlyPhoto // ignore: cast_nullable_to_non_nullable
as bool,coverAsset: freezed == coverAsset ? _self.coverAsset : coverAsset // ignore: cast_nullable_to_non_nullable
as String?,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterSummary].
extension ChapterSummaryPatterns on ChapterSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterSummary value)  $default,){
final _that = this;
switch (_that) {
case _ChapterSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChapterSummary implements ChapterSummary {
  const _ChapterSummary({@JsonKey(name: 'childId') required this.childId, @JsonKey(name: 'monthIndex') required this.monthIndex, @JsonKey(name: 'start') required this.start, @JsonKey(name: 'end') required this.end, @JsonKey(name: 'memoryCount') this.memoryCount = 0, @JsonKey(name: 'firstsCount') this.firstsCount = 0, @JsonKey(name: 'voiceCount') this.voiceCount = 0, @JsonKey(name: 'hasMonthlyPhoto') this.hasMonthlyPhoto = false, @JsonKey(name: 'coverAsset') this.coverAsset, @JsonKey(name: 'current') this.current = false});
  factory _ChapterSummary.fromJson(Map<String, dynamic> json) => _$ChapterSummaryFromJson(json);

@override@JsonKey(name: 'childId') final  String childId;
@override@JsonKey(name: 'monthIndex') final  int monthIndex;
@override@JsonKey(name: 'start') final  DateTime start;
@override@JsonKey(name: 'end') final  DateTime end;
@override@JsonKey(name: 'memoryCount') final  int memoryCount;
@override@JsonKey(name: 'firstsCount') final  int firstsCount;
@override@JsonKey(name: 'voiceCount') final  int voiceCount;
@override@JsonKey(name: 'hasMonthlyPhoto') final  bool hasMonthlyPhoto;
@override@JsonKey(name: 'coverAsset') final  String? coverAsset;
@override@JsonKey(name: 'current') final  bool current;

/// Create a copy of ChapterSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterSummaryCopyWith<_ChapterSummary> get copyWith => __$ChapterSummaryCopyWithImpl<_ChapterSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterSummary&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&(identical(other.firstsCount, firstsCount) || other.firstsCount == firstsCount)&&(identical(other.voiceCount, voiceCount) || other.voiceCount == voiceCount)&&(identical(other.hasMonthlyPhoto, hasMonthlyPhoto) || other.hasMonthlyPhoto == hasMonthlyPhoto)&&(identical(other.coverAsset, coverAsset) || other.coverAsset == coverAsset)&&(identical(other.current, current) || other.current == current));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,monthIndex,start,end,memoryCount,firstsCount,voiceCount,hasMonthlyPhoto,coverAsset,current);

@override
String toString() {
  return 'ChapterSummary(childId: $childId, monthIndex: $monthIndex, start: $start, end: $end, memoryCount: $memoryCount, firstsCount: $firstsCount, voiceCount: $voiceCount, hasMonthlyPhoto: $hasMonthlyPhoto, coverAsset: $coverAsset, current: $current)';
}


}

/// @nodoc
abstract mixin class _$ChapterSummaryCopyWith<$Res> implements $ChapterSummaryCopyWith<$Res> {
  factory _$ChapterSummaryCopyWith(_ChapterSummary value, $Res Function(_ChapterSummary) _then) = __$ChapterSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'childId') String childId,@JsonKey(name: 'monthIndex') int monthIndex,@JsonKey(name: 'start') DateTime start,@JsonKey(name: 'end') DateTime end,@JsonKey(name: 'memoryCount') int memoryCount,@JsonKey(name: 'firstsCount') int firstsCount,@JsonKey(name: 'voiceCount') int voiceCount,@JsonKey(name: 'hasMonthlyPhoto') bool hasMonthlyPhoto,@JsonKey(name: 'coverAsset') String? coverAsset,@JsonKey(name: 'current') bool current
});




}
/// @nodoc
class __$ChapterSummaryCopyWithImpl<$Res>
    implements _$ChapterSummaryCopyWith<$Res> {
  __$ChapterSummaryCopyWithImpl(this._self, this._then);

  final _ChapterSummary _self;
  final $Res Function(_ChapterSummary) _then;

/// Create a copy of ChapterSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childId = null,Object? monthIndex = null,Object? start = null,Object? end = null,Object? memoryCount = null,Object? firstsCount = null,Object? voiceCount = null,Object? hasMonthlyPhoto = null,Object? coverAsset = freezed,Object? current = null,}) {
  return _then(_ChapterSummary(
childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,monthIndex: null == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,firstsCount: null == firstsCount ? _self.firstsCount : firstsCount // ignore: cast_nullable_to_non_nullable
as int,voiceCount: null == voiceCount ? _self.voiceCount : voiceCount // ignore: cast_nullable_to_non_nullable
as int,hasMonthlyPhoto: null == hasMonthlyPhoto ? _self.hasMonthlyPhoto : hasMonthlyPhoto // ignore: cast_nullable_to_non_nullable
as bool,coverAsset: freezed == coverAsset ? _self.coverAsset : coverAsset // ignore: cast_nullable_to_non_nullable
as String?,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
