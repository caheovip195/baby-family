// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_settings_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiSettingsRecord {

@JsonKey(name: 'aiEnabled') bool? get aiEnabled;@JsonKey(name: 'features') Map<String, bool> get features;
/// Create a copy of AiSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiSettingsRecordCopyWith<AiSettingsRecord> get copyWith => _$AiSettingsRecordCopyWithImpl<AiSettingsRecord>(this as AiSettingsRecord, _$identity);

  /// Serializes this AiSettingsRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiSettingsRecord&&(identical(other.aiEnabled, aiEnabled) || other.aiEnabled == aiEnabled)&&const DeepCollectionEquality().equals(other.features, features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,aiEnabled,const DeepCollectionEquality().hash(features));

@override
String toString() {
  return 'AiSettingsRecord(aiEnabled: $aiEnabled, features: $features)';
}


}

/// @nodoc
abstract mixin class $AiSettingsRecordCopyWith<$Res>  {
  factory $AiSettingsRecordCopyWith(AiSettingsRecord value, $Res Function(AiSettingsRecord) _then) = _$AiSettingsRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'aiEnabled') bool? aiEnabled,@JsonKey(name: 'features') Map<String, bool> features
});




}
/// @nodoc
class _$AiSettingsRecordCopyWithImpl<$Res>
    implements $AiSettingsRecordCopyWith<$Res> {
  _$AiSettingsRecordCopyWithImpl(this._self, this._then);

  final AiSettingsRecord _self;
  final $Res Function(AiSettingsRecord) _then;

/// Create a copy of AiSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? aiEnabled = freezed,Object? features = null,}) {
  return _then(_self.copyWith(
aiEnabled: freezed == aiEnabled ? _self.aiEnabled : aiEnabled // ignore: cast_nullable_to_non_nullable
as bool?,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiSettingsRecord].
extension AiSettingsRecordPatterns on AiSettingsRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiSettingsRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiSettingsRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiSettingsRecord value)  $default,){
final _that = this;
switch (_that) {
case _AiSettingsRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiSettingsRecord value)?  $default,){
final _that = this;
switch (_that) {
case _AiSettingsRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AiSettingsRecord implements AiSettingsRecord {
  const _AiSettingsRecord({@JsonKey(name: 'aiEnabled') this.aiEnabled, @JsonKey(name: 'features') final  Map<String, bool> features = const <String, bool>{}}): _features = features;
  factory _AiSettingsRecord.fromJson(Map<String, dynamic> json) => _$AiSettingsRecordFromJson(json);

@override@JsonKey(name: 'aiEnabled') final  bool? aiEnabled;
 final  Map<String, bool> _features;
@override@JsonKey(name: 'features') Map<String, bool> get features {
  if (_features is EqualUnmodifiableMapView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_features);
}


/// Create a copy of AiSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiSettingsRecordCopyWith<_AiSettingsRecord> get copyWith => __$AiSettingsRecordCopyWithImpl<_AiSettingsRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiSettingsRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiSettingsRecord&&(identical(other.aiEnabled, aiEnabled) || other.aiEnabled == aiEnabled)&&const DeepCollectionEquality().equals(other._features, _features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,aiEnabled,const DeepCollectionEquality().hash(_features));

@override
String toString() {
  return 'AiSettingsRecord(aiEnabled: $aiEnabled, features: $features)';
}


}

/// @nodoc
abstract mixin class _$AiSettingsRecordCopyWith<$Res> implements $AiSettingsRecordCopyWith<$Res> {
  factory _$AiSettingsRecordCopyWith(_AiSettingsRecord value, $Res Function(_AiSettingsRecord) _then) = __$AiSettingsRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'aiEnabled') bool? aiEnabled,@JsonKey(name: 'features') Map<String, bool> features
});




}
/// @nodoc
class __$AiSettingsRecordCopyWithImpl<$Res>
    implements _$AiSettingsRecordCopyWith<$Res> {
  __$AiSettingsRecordCopyWithImpl(this._self, this._then);

  final _AiSettingsRecord _self;
  final $Res Function(_AiSettingsRecord) _then;

/// Create a copy of AiSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? aiEnabled = freezed,Object? features = null,}) {
  return _then(_AiSettingsRecord(
aiEnabled: freezed == aiEnabled ? _self.aiEnabled : aiEnabled // ignore: cast_nullable_to_non_nullable
as bool?,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}


}

// dart format on
