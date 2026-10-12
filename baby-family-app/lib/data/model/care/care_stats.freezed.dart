// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CareStats {

@JsonKey(name: 'weekStart') DateTime get weekStart;@JsonKey(name: 'weekEnd') DateTime get weekEnd;@JsonKey(name: 'total') int get total;@JsonKey(name: 'categories') List<CategoryCount> get categories;@JsonKey(name: 'bloomDays') int get bloomDays;@JsonKey(name: 'bloomed') List<bool> get bloomed;
/// Create a copy of CareStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareStatsCopyWith<CareStats> get copyWith => _$CareStatsCopyWithImpl<CareStats>(this as CareStats, _$identity);

  /// Serializes this CareStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareStats&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.bloomDays, bloomDays) || other.bloomDays == bloomDays)&&const DeepCollectionEquality().equals(other.bloomed, bloomed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weekStart,weekEnd,total,const DeepCollectionEquality().hash(categories),bloomDays,const DeepCollectionEquality().hash(bloomed));

@override
String toString() {
  return 'CareStats(weekStart: $weekStart, weekEnd: $weekEnd, total: $total, categories: $categories, bloomDays: $bloomDays, bloomed: $bloomed)';
}


}

/// @nodoc
abstract mixin class $CareStatsCopyWith<$Res>  {
  factory $CareStatsCopyWith(CareStats value, $Res Function(CareStats) _then) = _$CareStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'weekStart') DateTime weekStart,@JsonKey(name: 'weekEnd') DateTime weekEnd,@JsonKey(name: 'total') int total,@JsonKey(name: 'categories') List<CategoryCount> categories,@JsonKey(name: 'bloomDays') int bloomDays,@JsonKey(name: 'bloomed') List<bool> bloomed
});




}
/// @nodoc
class _$CareStatsCopyWithImpl<$Res>
    implements $CareStatsCopyWith<$Res> {
  _$CareStatsCopyWithImpl(this._self, this._then);

  final CareStats _self;
  final $Res Function(CareStats) _then;

/// Create a copy of CareStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekStart = null,Object? weekEnd = null,Object? total = null,Object? categories = null,Object? bloomDays = null,Object? bloomed = null,}) {
  return _then(_self.copyWith(
weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,weekEnd: null == weekEnd ? _self.weekEnd : weekEnd // ignore: cast_nullable_to_non_nullable
as DateTime,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryCount>,bloomDays: null == bloomDays ? _self.bloomDays : bloomDays // ignore: cast_nullable_to_non_nullable
as int,bloomed: null == bloomed ? _self.bloomed : bloomed // ignore: cast_nullable_to_non_nullable
as List<bool>,
  ));
}

}


/// Adds pattern-matching-related methods to [CareStats].
extension CareStatsPatterns on CareStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareStats value)  $default,){
final _that = this;
switch (_that) {
case _CareStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareStats value)?  $default,){
final _that = this;
switch (_that) {
case _CareStats() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CareStats implements CareStats {
  const _CareStats({@JsonKey(name: 'weekStart') required this.weekStart, @JsonKey(name: 'weekEnd') required this.weekEnd, @JsonKey(name: 'total') this.total = 0, @JsonKey(name: 'categories') final  List<CategoryCount> categories = const [], @JsonKey(name: 'bloomDays') this.bloomDays = 0, @JsonKey(name: 'bloomed') final  List<bool> bloomed = const []}): _categories = categories,_bloomed = bloomed;
  factory _CareStats.fromJson(Map<String, dynamic> json) => _$CareStatsFromJson(json);

@override@JsonKey(name: 'weekStart') final  DateTime weekStart;
@override@JsonKey(name: 'weekEnd') final  DateTime weekEnd;
@override@JsonKey(name: 'total') final  int total;
 final  List<CategoryCount> _categories;
@override@JsonKey(name: 'categories') List<CategoryCount> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override@JsonKey(name: 'bloomDays') final  int bloomDays;
 final  List<bool> _bloomed;
@override@JsonKey(name: 'bloomed') List<bool> get bloomed {
  if (_bloomed is EqualUnmodifiableListView) return _bloomed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bloomed);
}


/// Create a copy of CareStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareStatsCopyWith<_CareStats> get copyWith => __$CareStatsCopyWithImpl<_CareStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CareStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareStats&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.bloomDays, bloomDays) || other.bloomDays == bloomDays)&&const DeepCollectionEquality().equals(other._bloomed, _bloomed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weekStart,weekEnd,total,const DeepCollectionEquality().hash(_categories),bloomDays,const DeepCollectionEquality().hash(_bloomed));

@override
String toString() {
  return 'CareStats(weekStart: $weekStart, weekEnd: $weekEnd, total: $total, categories: $categories, bloomDays: $bloomDays, bloomed: $bloomed)';
}


}

/// @nodoc
abstract mixin class _$CareStatsCopyWith<$Res> implements $CareStatsCopyWith<$Res> {
  factory _$CareStatsCopyWith(_CareStats value, $Res Function(_CareStats) _then) = __$CareStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'weekStart') DateTime weekStart,@JsonKey(name: 'weekEnd') DateTime weekEnd,@JsonKey(name: 'total') int total,@JsonKey(name: 'categories') List<CategoryCount> categories,@JsonKey(name: 'bloomDays') int bloomDays,@JsonKey(name: 'bloomed') List<bool> bloomed
});




}
/// @nodoc
class __$CareStatsCopyWithImpl<$Res>
    implements _$CareStatsCopyWith<$Res> {
  __$CareStatsCopyWithImpl(this._self, this._then);

  final _CareStats _self;
  final $Res Function(_CareStats) _then;

/// Create a copy of CareStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekStart = null,Object? weekEnd = null,Object? total = null,Object? categories = null,Object? bloomDays = null,Object? bloomed = null,}) {
  return _then(_CareStats(
weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,weekEnd: null == weekEnd ? _self.weekEnd : weekEnd // ignore: cast_nullable_to_non_nullable
as DateTime,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryCount>,bloomDays: null == bloomDays ? _self.bloomDays : bloomDays // ignore: cast_nullable_to_non_nullable
as int,bloomed: null == bloomed ? _self._bloomed : bloomed // ignore: cast_nullable_to_non_nullable
as List<bool>,
  ));
}


}

// dart format on
