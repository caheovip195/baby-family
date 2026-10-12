// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_recap.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeeklyRecap {

@JsonKey(name: 'start') DateTime get start;@JsonKey(name: 'end') DateTime get end;@JsonKey(name: 'headline') String get headline;@JsonKey(name: 'moments') int get moments;@JsonKey(name: 'firsts') int get firsts;@JsonKey(name: 'quotes') int get quotes;@JsonKey(name: 'heroAssets') List<String> get heroAssets;@JsonKey(name: 'highlights') List<Memory> get highlights;@JsonKey(name: 'togetherTitle') String? get togetherTitle;@JsonKey(name: 'togetherBody') String? get togetherBody;@JsonKey(name: 'pageCount') int get pageCount;
/// Create a copy of WeeklyRecap
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyRecapCopyWith<WeeklyRecap> get copyWith => _$WeeklyRecapCopyWithImpl<WeeklyRecap>(this as WeeklyRecap, _$identity);

  /// Serializes this WeeklyRecap to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyRecap&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.moments, moments) || other.moments == moments)&&(identical(other.firsts, firsts) || other.firsts == firsts)&&(identical(other.quotes, quotes) || other.quotes == quotes)&&const DeepCollectionEquality().equals(other.heroAssets, heroAssets)&&const DeepCollectionEquality().equals(other.highlights, highlights)&&(identical(other.togetherTitle, togetherTitle) || other.togetherTitle == togetherTitle)&&(identical(other.togetherBody, togetherBody) || other.togetherBody == togetherBody)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end,headline,moments,firsts,quotes,const DeepCollectionEquality().hash(heroAssets),const DeepCollectionEquality().hash(highlights),togetherTitle,togetherBody,pageCount);

@override
String toString() {
  return 'WeeklyRecap(start: $start, end: $end, headline: $headline, moments: $moments, firsts: $firsts, quotes: $quotes, heroAssets: $heroAssets, highlights: $highlights, togetherTitle: $togetherTitle, togetherBody: $togetherBody, pageCount: $pageCount)';
}


}

/// @nodoc
abstract mixin class $WeeklyRecapCopyWith<$Res>  {
  factory $WeeklyRecapCopyWith(WeeklyRecap value, $Res Function(WeeklyRecap) _then) = _$WeeklyRecapCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'start') DateTime start,@JsonKey(name: 'end') DateTime end,@JsonKey(name: 'headline') String headline,@JsonKey(name: 'moments') int moments,@JsonKey(name: 'firsts') int firsts,@JsonKey(name: 'quotes') int quotes,@JsonKey(name: 'heroAssets') List<String> heroAssets,@JsonKey(name: 'highlights') List<Memory> highlights,@JsonKey(name: 'togetherTitle') String? togetherTitle,@JsonKey(name: 'togetherBody') String? togetherBody,@JsonKey(name: 'pageCount') int pageCount
});




}
/// @nodoc
class _$WeeklyRecapCopyWithImpl<$Res>
    implements $WeeklyRecapCopyWith<$Res> {
  _$WeeklyRecapCopyWithImpl(this._self, this._then);

  final WeeklyRecap _self;
  final $Res Function(WeeklyRecap) _then;

/// Create a copy of WeeklyRecap
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,Object? headline = null,Object? moments = null,Object? firsts = null,Object? quotes = null,Object? heroAssets = null,Object? highlights = null,Object? togetherTitle = freezed,Object? togetherBody = freezed,Object? pageCount = null,}) {
  return _then(_self.copyWith(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,moments: null == moments ? _self.moments : moments // ignore: cast_nullable_to_non_nullable
as int,firsts: null == firsts ? _self.firsts : firsts // ignore: cast_nullable_to_non_nullable
as int,quotes: null == quotes ? _self.quotes : quotes // ignore: cast_nullable_to_non_nullable
as int,heroAssets: null == heroAssets ? _self.heroAssets : heroAssets // ignore: cast_nullable_to_non_nullable
as List<String>,highlights: null == highlights ? _self.highlights : highlights // ignore: cast_nullable_to_non_nullable
as List<Memory>,togetherTitle: freezed == togetherTitle ? _self.togetherTitle : togetherTitle // ignore: cast_nullable_to_non_nullable
as String?,togetherBody: freezed == togetherBody ? _self.togetherBody : togetherBody // ignore: cast_nullable_to_non_nullable
as String?,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyRecap].
extension WeeklyRecapPatterns on WeeklyRecap {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyRecap value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyRecap() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyRecap value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyRecap():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyRecap value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyRecap() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _WeeklyRecap implements WeeklyRecap {
  const _WeeklyRecap({@JsonKey(name: 'start') required this.start, @JsonKey(name: 'end') required this.end, @JsonKey(name: 'headline') this.headline = '', @JsonKey(name: 'moments') this.moments = 0, @JsonKey(name: 'firsts') this.firsts = 0, @JsonKey(name: 'quotes') this.quotes = 0, @JsonKey(name: 'heroAssets') final  List<String> heroAssets = const [], @JsonKey(name: 'highlights') final  List<Memory> highlights = const [], @JsonKey(name: 'togetherTitle') this.togetherTitle, @JsonKey(name: 'togetherBody') this.togetherBody, @JsonKey(name: 'pageCount') this.pageCount = 1}): _heroAssets = heroAssets,_highlights = highlights;
  factory _WeeklyRecap.fromJson(Map<String, dynamic> json) => _$WeeklyRecapFromJson(json);

@override@JsonKey(name: 'start') final  DateTime start;
@override@JsonKey(name: 'end') final  DateTime end;
@override@JsonKey(name: 'headline') final  String headline;
@override@JsonKey(name: 'moments') final  int moments;
@override@JsonKey(name: 'firsts') final  int firsts;
@override@JsonKey(name: 'quotes') final  int quotes;
 final  List<String> _heroAssets;
@override@JsonKey(name: 'heroAssets') List<String> get heroAssets {
  if (_heroAssets is EqualUnmodifiableListView) return _heroAssets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_heroAssets);
}

 final  List<Memory> _highlights;
@override@JsonKey(name: 'highlights') List<Memory> get highlights {
  if (_highlights is EqualUnmodifiableListView) return _highlights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_highlights);
}

@override@JsonKey(name: 'togetherTitle') final  String? togetherTitle;
@override@JsonKey(name: 'togetherBody') final  String? togetherBody;
@override@JsonKey(name: 'pageCount') final  int pageCount;

/// Create a copy of WeeklyRecap
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyRecapCopyWith<_WeeklyRecap> get copyWith => __$WeeklyRecapCopyWithImpl<_WeeklyRecap>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyRecapToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyRecap&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.moments, moments) || other.moments == moments)&&(identical(other.firsts, firsts) || other.firsts == firsts)&&(identical(other.quotes, quotes) || other.quotes == quotes)&&const DeepCollectionEquality().equals(other._heroAssets, _heroAssets)&&const DeepCollectionEquality().equals(other._highlights, _highlights)&&(identical(other.togetherTitle, togetherTitle) || other.togetherTitle == togetherTitle)&&(identical(other.togetherBody, togetherBody) || other.togetherBody == togetherBody)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end,headline,moments,firsts,quotes,const DeepCollectionEquality().hash(_heroAssets),const DeepCollectionEquality().hash(_highlights),togetherTitle,togetherBody,pageCount);

@override
String toString() {
  return 'WeeklyRecap(start: $start, end: $end, headline: $headline, moments: $moments, firsts: $firsts, quotes: $quotes, heroAssets: $heroAssets, highlights: $highlights, togetherTitle: $togetherTitle, togetherBody: $togetherBody, pageCount: $pageCount)';
}


}

/// @nodoc
abstract mixin class _$WeeklyRecapCopyWith<$Res> implements $WeeklyRecapCopyWith<$Res> {
  factory _$WeeklyRecapCopyWith(_WeeklyRecap value, $Res Function(_WeeklyRecap) _then) = __$WeeklyRecapCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'start') DateTime start,@JsonKey(name: 'end') DateTime end,@JsonKey(name: 'headline') String headline,@JsonKey(name: 'moments') int moments,@JsonKey(name: 'firsts') int firsts,@JsonKey(name: 'quotes') int quotes,@JsonKey(name: 'heroAssets') List<String> heroAssets,@JsonKey(name: 'highlights') List<Memory> highlights,@JsonKey(name: 'togetherTitle') String? togetherTitle,@JsonKey(name: 'togetherBody') String? togetherBody,@JsonKey(name: 'pageCount') int pageCount
});




}
/// @nodoc
class __$WeeklyRecapCopyWithImpl<$Res>
    implements _$WeeklyRecapCopyWith<$Res> {
  __$WeeklyRecapCopyWithImpl(this._self, this._then);

  final _WeeklyRecap _self;
  final $Res Function(_WeeklyRecap) _then;

/// Create a copy of WeeklyRecap
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,Object? headline = null,Object? moments = null,Object? firsts = null,Object? quotes = null,Object? heroAssets = null,Object? highlights = null,Object? togetherTitle = freezed,Object? togetherBody = freezed,Object? pageCount = null,}) {
  return _then(_WeeklyRecap(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,moments: null == moments ? _self.moments : moments // ignore: cast_nullable_to_non_nullable
as int,firsts: null == firsts ? _self.firsts : firsts // ignore: cast_nullable_to_non_nullable
as int,quotes: null == quotes ? _self.quotes : quotes // ignore: cast_nullable_to_non_nullable
as int,heroAssets: null == heroAssets ? _self._heroAssets : heroAssets // ignore: cast_nullable_to_non_nullable
as List<String>,highlights: null == highlights ? _self._highlights : highlights // ignore: cast_nullable_to_non_nullable
as List<Memory>,togetherTitle: freezed == togetherTitle ? _self.togetherTitle : togetherTitle // ignore: cast_nullable_to_non_nullable
as String?,togetherBody: freezed == togetherBody ? _self.togetherBody : togetherBody // ignore: cast_nullable_to_non_nullable
as String?,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
