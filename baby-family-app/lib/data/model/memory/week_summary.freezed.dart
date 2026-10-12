// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'week_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeekSummary {

@JsonKey(name: 'moments') int get moments;@JsonKey(name: 'firsts') int get firsts;@JsonKey(name: 'quotes') int get quotes;@JsonKey(name: 'thumbnails') List<String> get thumbnails;
/// Create a copy of WeekSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekSummaryCopyWith<WeekSummary> get copyWith => _$WeekSummaryCopyWithImpl<WeekSummary>(this as WeekSummary, _$identity);

  /// Serializes this WeekSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekSummary&&(identical(other.moments, moments) || other.moments == moments)&&(identical(other.firsts, firsts) || other.firsts == firsts)&&(identical(other.quotes, quotes) || other.quotes == quotes)&&const DeepCollectionEquality().equals(other.thumbnails, thumbnails));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,moments,firsts,quotes,const DeepCollectionEquality().hash(thumbnails));

@override
String toString() {
  return 'WeekSummary(moments: $moments, firsts: $firsts, quotes: $quotes, thumbnails: $thumbnails)';
}


}

/// @nodoc
abstract mixin class $WeekSummaryCopyWith<$Res>  {
  factory $WeekSummaryCopyWith(WeekSummary value, $Res Function(WeekSummary) _then) = _$WeekSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'moments') int moments,@JsonKey(name: 'firsts') int firsts,@JsonKey(name: 'quotes') int quotes,@JsonKey(name: 'thumbnails') List<String> thumbnails
});




}
/// @nodoc
class _$WeekSummaryCopyWithImpl<$Res>
    implements $WeekSummaryCopyWith<$Res> {
  _$WeekSummaryCopyWithImpl(this._self, this._then);

  final WeekSummary _self;
  final $Res Function(WeekSummary) _then;

/// Create a copy of WeekSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? moments = null,Object? firsts = null,Object? quotes = null,Object? thumbnails = null,}) {
  return _then(_self.copyWith(
moments: null == moments ? _self.moments : moments // ignore: cast_nullable_to_non_nullable
as int,firsts: null == firsts ? _self.firsts : firsts // ignore: cast_nullable_to_non_nullable
as int,quotes: null == quotes ? _self.quotes : quotes // ignore: cast_nullable_to_non_nullable
as int,thumbnails: null == thumbnails ? _self.thumbnails : thumbnails // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekSummary].
extension WeekSummaryPatterns on WeekSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekSummary value)  $default,){
final _that = this;
switch (_that) {
case _WeekSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekSummary value)?  $default,){
final _that = this;
switch (_that) {
case _WeekSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _WeekSummary implements WeekSummary {
  const _WeekSummary({@JsonKey(name: 'moments') this.moments = 0, @JsonKey(name: 'firsts') this.firsts = 0, @JsonKey(name: 'quotes') this.quotes = 0, @JsonKey(name: 'thumbnails') final  List<String> thumbnails = const []}): _thumbnails = thumbnails;
  factory _WeekSummary.fromJson(Map<String, dynamic> json) => _$WeekSummaryFromJson(json);

@override@JsonKey(name: 'moments') final  int moments;
@override@JsonKey(name: 'firsts') final  int firsts;
@override@JsonKey(name: 'quotes') final  int quotes;
 final  List<String> _thumbnails;
@override@JsonKey(name: 'thumbnails') List<String> get thumbnails {
  if (_thumbnails is EqualUnmodifiableListView) return _thumbnails;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_thumbnails);
}


/// Create a copy of WeekSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekSummaryCopyWith<_WeekSummary> get copyWith => __$WeekSummaryCopyWithImpl<_WeekSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeekSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekSummary&&(identical(other.moments, moments) || other.moments == moments)&&(identical(other.firsts, firsts) || other.firsts == firsts)&&(identical(other.quotes, quotes) || other.quotes == quotes)&&const DeepCollectionEquality().equals(other._thumbnails, _thumbnails));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,moments,firsts,quotes,const DeepCollectionEquality().hash(_thumbnails));

@override
String toString() {
  return 'WeekSummary(moments: $moments, firsts: $firsts, quotes: $quotes, thumbnails: $thumbnails)';
}


}

/// @nodoc
abstract mixin class _$WeekSummaryCopyWith<$Res> implements $WeekSummaryCopyWith<$Res> {
  factory _$WeekSummaryCopyWith(_WeekSummary value, $Res Function(_WeekSummary) _then) = __$WeekSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'moments') int moments,@JsonKey(name: 'firsts') int firsts,@JsonKey(name: 'quotes') int quotes,@JsonKey(name: 'thumbnails') List<String> thumbnails
});




}
/// @nodoc
class __$WeekSummaryCopyWithImpl<$Res>
    implements _$WeekSummaryCopyWith<$Res> {
  __$WeekSummaryCopyWithImpl(this._self, this._then);

  final _WeekSummary _self;
  final $Res Function(_WeekSummary) _then;

/// Create a copy of WeekSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? moments = null,Object? firsts = null,Object? quotes = null,Object? thumbnails = null,}) {
  return _then(_WeekSummary(
moments: null == moments ? _self.moments : moments // ignore: cast_nullable_to_non_nullable
as int,firsts: null == firsts ? _self.firsts : firsts // ignore: cast_nullable_to_non_nullable
as int,quotes: null == quotes ? _self.quotes : quotes // ignore: cast_nullable_to_non_nullable
as int,thumbnails: null == thumbnails ? _self._thumbnails : thumbnails // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
