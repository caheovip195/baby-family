// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_swap_options_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionSwapOptionsRecord {

@JsonKey(name: 'options') List<MissionTemplateRecord> get options;@JsonKey(name: 'optionsToken') String? get optionsToken;@JsonKey(name: 'swapsLeft') int get swapsLeft;
/// Create a copy of MissionSwapOptionsRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionSwapOptionsRecordCopyWith<MissionSwapOptionsRecord> get copyWith => _$MissionSwapOptionsRecordCopyWithImpl<MissionSwapOptionsRecord>(this as MissionSwapOptionsRecord, _$identity);

  /// Serializes this MissionSwapOptionsRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionSwapOptionsRecord&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.optionsToken, optionsToken) || other.optionsToken == optionsToken)&&(identical(other.swapsLeft, swapsLeft) || other.swapsLeft == swapsLeft));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(options),optionsToken,swapsLeft);

@override
String toString() {
  return 'MissionSwapOptionsRecord(options: $options, optionsToken: $optionsToken, swapsLeft: $swapsLeft)';
}


}

/// @nodoc
abstract mixin class $MissionSwapOptionsRecordCopyWith<$Res>  {
  factory $MissionSwapOptionsRecordCopyWith(MissionSwapOptionsRecord value, $Res Function(MissionSwapOptionsRecord) _then) = _$MissionSwapOptionsRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'options') List<MissionTemplateRecord> options,@JsonKey(name: 'optionsToken') String? optionsToken,@JsonKey(name: 'swapsLeft') int swapsLeft
});




}
/// @nodoc
class _$MissionSwapOptionsRecordCopyWithImpl<$Res>
    implements $MissionSwapOptionsRecordCopyWith<$Res> {
  _$MissionSwapOptionsRecordCopyWithImpl(this._self, this._then);

  final MissionSwapOptionsRecord _self;
  final $Res Function(MissionSwapOptionsRecord) _then;

/// Create a copy of MissionSwapOptionsRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? options = null,Object? optionsToken = freezed,Object? swapsLeft = null,}) {
  return _then(_self.copyWith(
options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<MissionTemplateRecord>,optionsToken: freezed == optionsToken ? _self.optionsToken : optionsToken // ignore: cast_nullable_to_non_nullable
as String?,swapsLeft: null == swapsLeft ? _self.swapsLeft : swapsLeft // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionSwapOptionsRecord].
extension MissionSwapOptionsRecordPatterns on MissionSwapOptionsRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionSwapOptionsRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionSwapOptionsRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionSwapOptionsRecord value)  $default,){
final _that = this;
switch (_that) {
case _MissionSwapOptionsRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionSwapOptionsRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MissionSwapOptionsRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MissionSwapOptionsRecord implements MissionSwapOptionsRecord {
  const _MissionSwapOptionsRecord({@JsonKey(name: 'options') final  List<MissionTemplateRecord> options = const <MissionTemplateRecord>[], @JsonKey(name: 'optionsToken') this.optionsToken, @JsonKey(name: 'swapsLeft') this.swapsLeft = 0}): _options = options;
  factory _MissionSwapOptionsRecord.fromJson(Map<String, dynamic> json) => _$MissionSwapOptionsRecordFromJson(json);

 final  List<MissionTemplateRecord> _options;
@override@JsonKey(name: 'options') List<MissionTemplateRecord> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override@JsonKey(name: 'optionsToken') final  String? optionsToken;
@override@JsonKey(name: 'swapsLeft') final  int swapsLeft;

/// Create a copy of MissionSwapOptionsRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionSwapOptionsRecordCopyWith<_MissionSwapOptionsRecord> get copyWith => __$MissionSwapOptionsRecordCopyWithImpl<_MissionSwapOptionsRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionSwapOptionsRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionSwapOptionsRecord&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.optionsToken, optionsToken) || other.optionsToken == optionsToken)&&(identical(other.swapsLeft, swapsLeft) || other.swapsLeft == swapsLeft));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_options),optionsToken,swapsLeft);

@override
String toString() {
  return 'MissionSwapOptionsRecord(options: $options, optionsToken: $optionsToken, swapsLeft: $swapsLeft)';
}


}

/// @nodoc
abstract mixin class _$MissionSwapOptionsRecordCopyWith<$Res> implements $MissionSwapOptionsRecordCopyWith<$Res> {
  factory _$MissionSwapOptionsRecordCopyWith(_MissionSwapOptionsRecord value, $Res Function(_MissionSwapOptionsRecord) _then) = __$MissionSwapOptionsRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'options') List<MissionTemplateRecord> options,@JsonKey(name: 'optionsToken') String? optionsToken,@JsonKey(name: 'swapsLeft') int swapsLeft
});




}
/// @nodoc
class __$MissionSwapOptionsRecordCopyWithImpl<$Res>
    implements _$MissionSwapOptionsRecordCopyWith<$Res> {
  __$MissionSwapOptionsRecordCopyWithImpl(this._self, this._then);

  final _MissionSwapOptionsRecord _self;
  final $Res Function(_MissionSwapOptionsRecord) _then;

/// Create a copy of MissionSwapOptionsRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? options = null,Object? optionsToken = freezed,Object? swapsLeft = null,}) {
  return _then(_MissionSwapOptionsRecord(
options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<MissionTemplateRecord>,optionsToken: freezed == optionsToken ? _self.optionsToken : optionsToken // ignore: cast_nullable_to_non_nullable
as String?,swapsLeft: null == swapsLeft ? _self.swapsLeft : swapsLeft // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
