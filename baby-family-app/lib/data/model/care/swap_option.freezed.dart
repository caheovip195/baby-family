// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'swap_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SwapOption {

@JsonKey(name: 'missionId') String get missionId;@JsonKey(name: 'options') List<MissionTemplate> get options;@JsonKey(name: 'swapsLeft') int get swapsLeft;
/// Create a copy of SwapOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwapOptionCopyWith<SwapOption> get copyWith => _$SwapOptionCopyWithImpl<SwapOption>(this as SwapOption, _$identity);

  /// Serializes this SwapOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwapOption&&(identical(other.missionId, missionId) || other.missionId == missionId)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.swapsLeft, swapsLeft) || other.swapsLeft == swapsLeft));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,missionId,const DeepCollectionEquality().hash(options),swapsLeft);

@override
String toString() {
  return 'SwapOption(missionId: $missionId, options: $options, swapsLeft: $swapsLeft)';
}


}

/// @nodoc
abstract mixin class $SwapOptionCopyWith<$Res>  {
  factory $SwapOptionCopyWith(SwapOption value, $Res Function(SwapOption) _then) = _$SwapOptionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'missionId') String missionId,@JsonKey(name: 'options') List<MissionTemplate> options,@JsonKey(name: 'swapsLeft') int swapsLeft
});




}
/// @nodoc
class _$SwapOptionCopyWithImpl<$Res>
    implements $SwapOptionCopyWith<$Res> {
  _$SwapOptionCopyWithImpl(this._self, this._then);

  final SwapOption _self;
  final $Res Function(SwapOption) _then;

/// Create a copy of SwapOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? missionId = null,Object? options = null,Object? swapsLeft = null,}) {
  return _then(_self.copyWith(
missionId: null == missionId ? _self.missionId : missionId // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<MissionTemplate>,swapsLeft: null == swapsLeft ? _self.swapsLeft : swapsLeft // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SwapOption].
extension SwapOptionPatterns on SwapOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SwapOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwapOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SwapOption value)  $default,){
final _that = this;
switch (_that) {
case _SwapOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SwapOption value)?  $default,){
final _that = this;
switch (_that) {
case _SwapOption() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SwapOption implements SwapOption {
  const _SwapOption({@JsonKey(name: 'missionId') required this.missionId, @JsonKey(name: 'options') final  List<MissionTemplate> options = const [], @JsonKey(name: 'swapsLeft') this.swapsLeft = 0}): _options = options;
  factory _SwapOption.fromJson(Map<String, dynamic> json) => _$SwapOptionFromJson(json);

@override@JsonKey(name: 'missionId') final  String missionId;
 final  List<MissionTemplate> _options;
@override@JsonKey(name: 'options') List<MissionTemplate> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override@JsonKey(name: 'swapsLeft') final  int swapsLeft;

/// Create a copy of SwapOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwapOptionCopyWith<_SwapOption> get copyWith => __$SwapOptionCopyWithImpl<_SwapOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SwapOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwapOption&&(identical(other.missionId, missionId) || other.missionId == missionId)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.swapsLeft, swapsLeft) || other.swapsLeft == swapsLeft));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,missionId,const DeepCollectionEquality().hash(_options),swapsLeft);

@override
String toString() {
  return 'SwapOption(missionId: $missionId, options: $options, swapsLeft: $swapsLeft)';
}


}

/// @nodoc
abstract mixin class _$SwapOptionCopyWith<$Res> implements $SwapOptionCopyWith<$Res> {
  factory _$SwapOptionCopyWith(_SwapOption value, $Res Function(_SwapOption) _then) = __$SwapOptionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'missionId') String missionId,@JsonKey(name: 'options') List<MissionTemplate> options,@JsonKey(name: 'swapsLeft') int swapsLeft
});




}
/// @nodoc
class __$SwapOptionCopyWithImpl<$Res>
    implements _$SwapOptionCopyWith<$Res> {
  __$SwapOptionCopyWithImpl(this._self, this._then);

  final _SwapOption _self;
  final $Res Function(_SwapOption) _then;

/// Create a copy of SwapOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? missionId = null,Object? options = null,Object? swapsLeft = null,}) {
  return _then(_SwapOption(
missionId: null == missionId ? _self.missionId : missionId // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<MissionTemplate>,swapsLeft: null == swapsLeft ? _self.swapsLeft : swapsLeft // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
