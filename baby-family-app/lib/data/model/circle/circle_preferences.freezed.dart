// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circle_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CirclePreferences {

@JsonKey(name: 'instantPhotos') bool get instantPhotos;@JsonKey(name: 'dailyDigest') bool get dailyDigest;@JsonKey(name: 'digestTime') String get digestTime;@JsonKey(name: 'relationNote') String? get relationNote;@JsonKey(name: 'postedPhotos') int get postedPhotos;@JsonKey(name: 'postedComments') int get postedComments;
/// Create a copy of CirclePreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CirclePreferencesCopyWith<CirclePreferences> get copyWith => _$CirclePreferencesCopyWithImpl<CirclePreferences>(this as CirclePreferences, _$identity);

  /// Serializes this CirclePreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CirclePreferences&&(identical(other.instantPhotos, instantPhotos) || other.instantPhotos == instantPhotos)&&(identical(other.dailyDigest, dailyDigest) || other.dailyDigest == dailyDigest)&&(identical(other.digestTime, digestTime) || other.digestTime == digestTime)&&(identical(other.relationNote, relationNote) || other.relationNote == relationNote)&&(identical(other.postedPhotos, postedPhotos) || other.postedPhotos == postedPhotos)&&(identical(other.postedComments, postedComments) || other.postedComments == postedComments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instantPhotos,dailyDigest,digestTime,relationNote,postedPhotos,postedComments);

@override
String toString() {
  return 'CirclePreferences(instantPhotos: $instantPhotos, dailyDigest: $dailyDigest, digestTime: $digestTime, relationNote: $relationNote, postedPhotos: $postedPhotos, postedComments: $postedComments)';
}


}

/// @nodoc
abstract mixin class $CirclePreferencesCopyWith<$Res>  {
  factory $CirclePreferencesCopyWith(CirclePreferences value, $Res Function(CirclePreferences) _then) = _$CirclePreferencesCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'instantPhotos') bool instantPhotos,@JsonKey(name: 'dailyDigest') bool dailyDigest,@JsonKey(name: 'digestTime') String digestTime,@JsonKey(name: 'relationNote') String? relationNote,@JsonKey(name: 'postedPhotos') int postedPhotos,@JsonKey(name: 'postedComments') int postedComments
});




}
/// @nodoc
class _$CirclePreferencesCopyWithImpl<$Res>
    implements $CirclePreferencesCopyWith<$Res> {
  _$CirclePreferencesCopyWithImpl(this._self, this._then);

  final CirclePreferences _self;
  final $Res Function(CirclePreferences) _then;

/// Create a copy of CirclePreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instantPhotos = null,Object? dailyDigest = null,Object? digestTime = null,Object? relationNote = freezed,Object? postedPhotos = null,Object? postedComments = null,}) {
  return _then(_self.copyWith(
instantPhotos: null == instantPhotos ? _self.instantPhotos : instantPhotos // ignore: cast_nullable_to_non_nullable
as bool,dailyDigest: null == dailyDigest ? _self.dailyDigest : dailyDigest // ignore: cast_nullable_to_non_nullable
as bool,digestTime: null == digestTime ? _self.digestTime : digestTime // ignore: cast_nullable_to_non_nullable
as String,relationNote: freezed == relationNote ? _self.relationNote : relationNote // ignore: cast_nullable_to_non_nullable
as String?,postedPhotos: null == postedPhotos ? _self.postedPhotos : postedPhotos // ignore: cast_nullable_to_non_nullable
as int,postedComments: null == postedComments ? _self.postedComments : postedComments // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CirclePreferences].
extension CirclePreferencesPatterns on CirclePreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CirclePreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CirclePreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CirclePreferences value)  $default,){
final _that = this;
switch (_that) {
case _CirclePreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CirclePreferences value)?  $default,){
final _that = this;
switch (_that) {
case _CirclePreferences() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CirclePreferences implements CirclePreferences {
  const _CirclePreferences({@JsonKey(name: 'instantPhotos') this.instantPhotos = false, @JsonKey(name: 'dailyDigest') this.dailyDigest = true, @JsonKey(name: 'digestTime') this.digestTime = '19:00', @JsonKey(name: 'relationNote') this.relationNote, @JsonKey(name: 'postedPhotos') this.postedPhotos = 0, @JsonKey(name: 'postedComments') this.postedComments = 0});
  factory _CirclePreferences.fromJson(Map<String, dynamic> json) => _$CirclePreferencesFromJson(json);

@override@JsonKey(name: 'instantPhotos') final  bool instantPhotos;
@override@JsonKey(name: 'dailyDigest') final  bool dailyDigest;
@override@JsonKey(name: 'digestTime') final  String digestTime;
@override@JsonKey(name: 'relationNote') final  String? relationNote;
@override@JsonKey(name: 'postedPhotos') final  int postedPhotos;
@override@JsonKey(name: 'postedComments') final  int postedComments;

/// Create a copy of CirclePreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CirclePreferencesCopyWith<_CirclePreferences> get copyWith => __$CirclePreferencesCopyWithImpl<_CirclePreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CirclePreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CirclePreferences&&(identical(other.instantPhotos, instantPhotos) || other.instantPhotos == instantPhotos)&&(identical(other.dailyDigest, dailyDigest) || other.dailyDigest == dailyDigest)&&(identical(other.digestTime, digestTime) || other.digestTime == digestTime)&&(identical(other.relationNote, relationNote) || other.relationNote == relationNote)&&(identical(other.postedPhotos, postedPhotos) || other.postedPhotos == postedPhotos)&&(identical(other.postedComments, postedComments) || other.postedComments == postedComments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instantPhotos,dailyDigest,digestTime,relationNote,postedPhotos,postedComments);

@override
String toString() {
  return 'CirclePreferences(instantPhotos: $instantPhotos, dailyDigest: $dailyDigest, digestTime: $digestTime, relationNote: $relationNote, postedPhotos: $postedPhotos, postedComments: $postedComments)';
}


}

/// @nodoc
abstract mixin class _$CirclePreferencesCopyWith<$Res> implements $CirclePreferencesCopyWith<$Res> {
  factory _$CirclePreferencesCopyWith(_CirclePreferences value, $Res Function(_CirclePreferences) _then) = __$CirclePreferencesCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'instantPhotos') bool instantPhotos,@JsonKey(name: 'dailyDigest') bool dailyDigest,@JsonKey(name: 'digestTime') String digestTime,@JsonKey(name: 'relationNote') String? relationNote,@JsonKey(name: 'postedPhotos') int postedPhotos,@JsonKey(name: 'postedComments') int postedComments
});




}
/// @nodoc
class __$CirclePreferencesCopyWithImpl<$Res>
    implements _$CirclePreferencesCopyWith<$Res> {
  __$CirclePreferencesCopyWithImpl(this._self, this._then);

  final _CirclePreferences _self;
  final $Res Function(_CirclePreferences) _then;

/// Create a copy of CirclePreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instantPhotos = null,Object? dailyDigest = null,Object? digestTime = null,Object? relationNote = freezed,Object? postedPhotos = null,Object? postedComments = null,}) {
  return _then(_CirclePreferences(
instantPhotos: null == instantPhotos ? _self.instantPhotos : instantPhotos // ignore: cast_nullable_to_non_nullable
as bool,dailyDigest: null == dailyDigest ? _self.dailyDigest : dailyDigest // ignore: cast_nullable_to_non_nullable
as bool,digestTime: null == digestTime ? _self.digestTime : digestTime // ignore: cast_nullable_to_non_nullable
as String,relationNote: freezed == relationNote ? _self.relationNote : relationNote // ignore: cast_nullable_to_non_nullable
as String?,postedPhotos: null == postedPhotos ? _self.postedPhotos : postedPhotos // ignore: cast_nullable_to_non_nullable
as int,postedComments: null == postedComments ? _self.postedComments : postedComments // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
