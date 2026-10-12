// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hearts_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HeartsSummary {

@JsonKey(name: 'today') int get today;@JsonKey(name: 'week') int get week;@JsonKey(name: 'total') int get total;@JsonKey(name: 'recent') List<HeartsEntry> get recent;
/// Create a copy of HeartsSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeartsSummaryCopyWith<HeartsSummary> get copyWith => _$HeartsSummaryCopyWithImpl<HeartsSummary>(this as HeartsSummary, _$identity);

  /// Serializes this HeartsSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeartsSummary&&(identical(other.today, today) || other.today == today)&&(identical(other.week, week) || other.week == week)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.recent, recent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,today,week,total,const DeepCollectionEquality().hash(recent));

@override
String toString() {
  return 'HeartsSummary(today: $today, week: $week, total: $total, recent: $recent)';
}


}

/// @nodoc
abstract mixin class $HeartsSummaryCopyWith<$Res>  {
  factory $HeartsSummaryCopyWith(HeartsSummary value, $Res Function(HeartsSummary) _then) = _$HeartsSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'today') int today,@JsonKey(name: 'week') int week,@JsonKey(name: 'total') int total,@JsonKey(name: 'recent') List<HeartsEntry> recent
});




}
/// @nodoc
class _$HeartsSummaryCopyWithImpl<$Res>
    implements $HeartsSummaryCopyWith<$Res> {
  _$HeartsSummaryCopyWithImpl(this._self, this._then);

  final HeartsSummary _self;
  final $Res Function(HeartsSummary) _then;

/// Create a copy of HeartsSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? today = null,Object? week = null,Object? total = null,Object? recent = null,}) {
  return _then(_self.copyWith(
today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as int,week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,recent: null == recent ? _self.recent : recent // ignore: cast_nullable_to_non_nullable
as List<HeartsEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [HeartsSummary].
extension HeartsSummaryPatterns on HeartsSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeartsSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeartsSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeartsSummary value)  $default,){
final _that = this;
switch (_that) {
case _HeartsSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeartsSummary value)?  $default,){
final _that = this;
switch (_that) {
case _HeartsSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _HeartsSummary implements HeartsSummary {
  const _HeartsSummary({@JsonKey(name: 'today') this.today = 0, @JsonKey(name: 'week') this.week = 0, @JsonKey(name: 'total') this.total = 0, @JsonKey(name: 'recent') final  List<HeartsEntry> recent = const []}): _recent = recent;
  factory _HeartsSummary.fromJson(Map<String, dynamic> json) => _$HeartsSummaryFromJson(json);

@override@JsonKey(name: 'today') final  int today;
@override@JsonKey(name: 'week') final  int week;
@override@JsonKey(name: 'total') final  int total;
 final  List<HeartsEntry> _recent;
@override@JsonKey(name: 'recent') List<HeartsEntry> get recent {
  if (_recent is EqualUnmodifiableListView) return _recent;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recent);
}


/// Create a copy of HeartsSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeartsSummaryCopyWith<_HeartsSummary> get copyWith => __$HeartsSummaryCopyWithImpl<_HeartsSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeartsSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeartsSummary&&(identical(other.today, today) || other.today == today)&&(identical(other.week, week) || other.week == week)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._recent, _recent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,today,week,total,const DeepCollectionEquality().hash(_recent));

@override
String toString() {
  return 'HeartsSummary(today: $today, week: $week, total: $total, recent: $recent)';
}


}

/// @nodoc
abstract mixin class _$HeartsSummaryCopyWith<$Res> implements $HeartsSummaryCopyWith<$Res> {
  factory _$HeartsSummaryCopyWith(_HeartsSummary value, $Res Function(_HeartsSummary) _then) = __$HeartsSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'today') int today,@JsonKey(name: 'week') int week,@JsonKey(name: 'total') int total,@JsonKey(name: 'recent') List<HeartsEntry> recent
});




}
/// @nodoc
class __$HeartsSummaryCopyWithImpl<$Res>
    implements _$HeartsSummaryCopyWith<$Res> {
  __$HeartsSummaryCopyWithImpl(this._self, this._then);

  final _HeartsSummary _self;
  final $Res Function(_HeartsSummary) _then;

/// Create a copy of HeartsSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? today = null,Object? week = null,Object? total = null,Object? recent = null,}) {
  return _then(_HeartsSummary(
today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as int,week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,recent: null == recent ? _self._recent : recent // ignore: cast_nullable_to_non_nullable
as List<HeartsEntry>,
  ));
}


}

// dart format on
