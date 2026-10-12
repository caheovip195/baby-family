// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_memory_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChildMemoryStats {

@JsonKey(name: 'childId') String get childId;@JsonKey(name: 'memories') int get memories;@JsonKey(name: 'firsts') int get firsts;@JsonKey(name: 'voices') int get voices;@JsonKey(name: 'quotes') int get quotes;
/// Create a copy of ChildMemoryStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildMemoryStatsCopyWith<ChildMemoryStats> get copyWith => _$ChildMemoryStatsCopyWithImpl<ChildMemoryStats>(this as ChildMemoryStats, _$identity);

  /// Serializes this ChildMemoryStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChildMemoryStats&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.memories, memories) || other.memories == memories)&&(identical(other.firsts, firsts) || other.firsts == firsts)&&(identical(other.voices, voices) || other.voices == voices)&&(identical(other.quotes, quotes) || other.quotes == quotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,memories,firsts,voices,quotes);

@override
String toString() {
  return 'ChildMemoryStats(childId: $childId, memories: $memories, firsts: $firsts, voices: $voices, quotes: $quotes)';
}


}

/// @nodoc
abstract mixin class $ChildMemoryStatsCopyWith<$Res>  {
  factory $ChildMemoryStatsCopyWith(ChildMemoryStats value, $Res Function(ChildMemoryStats) _then) = _$ChildMemoryStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'childId') String childId,@JsonKey(name: 'memories') int memories,@JsonKey(name: 'firsts') int firsts,@JsonKey(name: 'voices') int voices,@JsonKey(name: 'quotes') int quotes
});




}
/// @nodoc
class _$ChildMemoryStatsCopyWithImpl<$Res>
    implements $ChildMemoryStatsCopyWith<$Res> {
  _$ChildMemoryStatsCopyWithImpl(this._self, this._then);

  final ChildMemoryStats _self;
  final $Res Function(ChildMemoryStats) _then;

/// Create a copy of ChildMemoryStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childId = null,Object? memories = null,Object? firsts = null,Object? voices = null,Object? quotes = null,}) {
  return _then(_self.copyWith(
childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,memories: null == memories ? _self.memories : memories // ignore: cast_nullable_to_non_nullable
as int,firsts: null == firsts ? _self.firsts : firsts // ignore: cast_nullable_to_non_nullable
as int,voices: null == voices ? _self.voices : voices // ignore: cast_nullable_to_non_nullable
as int,quotes: null == quotes ? _self.quotes : quotes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChildMemoryStats].
extension ChildMemoryStatsPatterns on ChildMemoryStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChildMemoryStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChildMemoryStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChildMemoryStats value)  $default,){
final _that = this;
switch (_that) {
case _ChildMemoryStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChildMemoryStats value)?  $default,){
final _that = this;
switch (_that) {
case _ChildMemoryStats() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChildMemoryStats implements ChildMemoryStats {
  const _ChildMemoryStats({@JsonKey(name: 'childId') required this.childId, @JsonKey(name: 'memories') this.memories = 0, @JsonKey(name: 'firsts') this.firsts = 0, @JsonKey(name: 'voices') this.voices = 0, @JsonKey(name: 'quotes') this.quotes = 0});
  factory _ChildMemoryStats.fromJson(Map<String, dynamic> json) => _$ChildMemoryStatsFromJson(json);

@override@JsonKey(name: 'childId') final  String childId;
@override@JsonKey(name: 'memories') final  int memories;
@override@JsonKey(name: 'firsts') final  int firsts;
@override@JsonKey(name: 'voices') final  int voices;
@override@JsonKey(name: 'quotes') final  int quotes;

/// Create a copy of ChildMemoryStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildMemoryStatsCopyWith<_ChildMemoryStats> get copyWith => __$ChildMemoryStatsCopyWithImpl<_ChildMemoryStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChildMemoryStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChildMemoryStats&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.memories, memories) || other.memories == memories)&&(identical(other.firsts, firsts) || other.firsts == firsts)&&(identical(other.voices, voices) || other.voices == voices)&&(identical(other.quotes, quotes) || other.quotes == quotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,memories,firsts,voices,quotes);

@override
String toString() {
  return 'ChildMemoryStats(childId: $childId, memories: $memories, firsts: $firsts, voices: $voices, quotes: $quotes)';
}


}

/// @nodoc
abstract mixin class _$ChildMemoryStatsCopyWith<$Res> implements $ChildMemoryStatsCopyWith<$Res> {
  factory _$ChildMemoryStatsCopyWith(_ChildMemoryStats value, $Res Function(_ChildMemoryStats) _then) = __$ChildMemoryStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'childId') String childId,@JsonKey(name: 'memories') int memories,@JsonKey(name: 'firsts') int firsts,@JsonKey(name: 'voices') int voices,@JsonKey(name: 'quotes') int quotes
});




}
/// @nodoc
class __$ChildMemoryStatsCopyWithImpl<$Res>
    implements _$ChildMemoryStatsCopyWith<$Res> {
  __$ChildMemoryStatsCopyWithImpl(this._self, this._then);

  final _ChildMemoryStats _self;
  final $Res Function(_ChildMemoryStats) _then;

/// Create a copy of ChildMemoryStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childId = null,Object? memories = null,Object? firsts = null,Object? voices = null,Object? quotes = null,}) {
  return _then(_ChildMemoryStats(
childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,memories: null == memories ? _self.memories : memories // ignore: cast_nullable_to_non_nullable
as int,firsts: null == firsts ? _self.firsts : firsts // ignore: cast_nullable_to_non_nullable
as int,voices: null == voices ? _self.voices : voices // ignore: cast_nullable_to_non_nullable
as int,quotes: null == quotes ? _self.quotes : quotes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
