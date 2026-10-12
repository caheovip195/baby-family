// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rewrite_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RewriteSuggestion {

@JsonKey(name: 'original') String get original;@JsonKey(name: 'options') List<RewriteOption> get options;@JsonKey(name: 'selected') RewriteTone get selected;@JsonKey(name: 'edited') String? get edited;
/// Create a copy of RewriteSuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RewriteSuggestionCopyWith<RewriteSuggestion> get copyWith => _$RewriteSuggestionCopyWithImpl<RewriteSuggestion>(this as RewriteSuggestion, _$identity);

  /// Serializes this RewriteSuggestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RewriteSuggestion&&(identical(other.original, original) || other.original == original)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.edited, edited) || other.edited == edited));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,original,const DeepCollectionEquality().hash(options),selected,edited);

@override
String toString() {
  return 'RewriteSuggestion(original: $original, options: $options, selected: $selected, edited: $edited)';
}


}

/// @nodoc
abstract mixin class $RewriteSuggestionCopyWith<$Res>  {
  factory $RewriteSuggestionCopyWith(RewriteSuggestion value, $Res Function(RewriteSuggestion) _then) = _$RewriteSuggestionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'original') String original,@JsonKey(name: 'options') List<RewriteOption> options,@JsonKey(name: 'selected') RewriteTone selected,@JsonKey(name: 'edited') String? edited
});




}
/// @nodoc
class _$RewriteSuggestionCopyWithImpl<$Res>
    implements $RewriteSuggestionCopyWith<$Res> {
  _$RewriteSuggestionCopyWithImpl(this._self, this._then);

  final RewriteSuggestion _self;
  final $Res Function(RewriteSuggestion) _then;

/// Create a copy of RewriteSuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? original = null,Object? options = null,Object? selected = null,Object? edited = freezed,}) {
  return _then(_self.copyWith(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<RewriteOption>,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as RewriteTone,edited: freezed == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RewriteSuggestion].
extension RewriteSuggestionPatterns on RewriteSuggestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RewriteSuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RewriteSuggestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RewriteSuggestion value)  $default,){
final _that = this;
switch (_that) {
case _RewriteSuggestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RewriteSuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _RewriteSuggestion() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _RewriteSuggestion implements RewriteSuggestion {
  const _RewriteSuggestion({@JsonKey(name: 'original') required this.original, @JsonKey(name: 'options') final  List<RewriteOption> options = const [], @JsonKey(name: 'selected') this.selected = RewriteTone.neutral, @JsonKey(name: 'edited') this.edited}): _options = options;
  factory _RewriteSuggestion.fromJson(Map<String, dynamic> json) => _$RewriteSuggestionFromJson(json);

@override@JsonKey(name: 'original') final  String original;
 final  List<RewriteOption> _options;
@override@JsonKey(name: 'options') List<RewriteOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override@JsonKey(name: 'selected') final  RewriteTone selected;
@override@JsonKey(name: 'edited') final  String? edited;

/// Create a copy of RewriteSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RewriteSuggestionCopyWith<_RewriteSuggestion> get copyWith => __$RewriteSuggestionCopyWithImpl<_RewriteSuggestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RewriteSuggestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RewriteSuggestion&&(identical(other.original, original) || other.original == original)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.edited, edited) || other.edited == edited));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,original,const DeepCollectionEquality().hash(_options),selected,edited);

@override
String toString() {
  return 'RewriteSuggestion(original: $original, options: $options, selected: $selected, edited: $edited)';
}


}

/// @nodoc
abstract mixin class _$RewriteSuggestionCopyWith<$Res> implements $RewriteSuggestionCopyWith<$Res> {
  factory _$RewriteSuggestionCopyWith(_RewriteSuggestion value, $Res Function(_RewriteSuggestion) _then) = __$RewriteSuggestionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'original') String original,@JsonKey(name: 'options') List<RewriteOption> options,@JsonKey(name: 'selected') RewriteTone selected,@JsonKey(name: 'edited') String? edited
});




}
/// @nodoc
class __$RewriteSuggestionCopyWithImpl<$Res>
    implements _$RewriteSuggestionCopyWith<$Res> {
  __$RewriteSuggestionCopyWithImpl(this._self, this._then);

  final _RewriteSuggestion _self;
  final $Res Function(_RewriteSuggestion) _then;

/// Create a copy of RewriteSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? original = null,Object? options = null,Object? selected = null,Object? edited = freezed,}) {
  return _then(_RewriteSuggestion(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<RewriteOption>,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as RewriteTone,edited: freezed == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
