// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiSettings {

@JsonKey(name: 'enabled') bool get enabled;@JsonKey(name: 'remaining') int get remaining;@JsonKey(name: 'total') int get total;@JsonKey(name: 'renewsAt') DateTime? get renewsAt;@JsonKey(name: 'features') List<AiFeatureSetting> get features;
/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiSettingsCopyWith<AiSettings> get copyWith => _$AiSettingsCopyWithImpl<AiSettings>(this as AiSettings, _$identity);

  /// Serializes this AiSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.total, total) || other.total == total)&&(identical(other.renewsAt, renewsAt) || other.renewsAt == renewsAt)&&const DeepCollectionEquality().equals(other.features, features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,remaining,total,renewsAt,const DeepCollectionEquality().hash(features));

@override
String toString() {
  return 'AiSettings(enabled: $enabled, remaining: $remaining, total: $total, renewsAt: $renewsAt, features: $features)';
}


}

/// @nodoc
abstract mixin class $AiSettingsCopyWith<$Res>  {
  factory $AiSettingsCopyWith(AiSettings value, $Res Function(AiSettings) _then) = _$AiSettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'enabled') bool enabled,@JsonKey(name: 'remaining') int remaining,@JsonKey(name: 'total') int total,@JsonKey(name: 'renewsAt') DateTime? renewsAt,@JsonKey(name: 'features') List<AiFeatureSetting> features
});




}
/// @nodoc
class _$AiSettingsCopyWithImpl<$Res>
    implements $AiSettingsCopyWith<$Res> {
  _$AiSettingsCopyWithImpl(this._self, this._then);

  final AiSettings _self;
  final $Res Function(AiSettings) _then;

/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? remaining = null,Object? total = null,Object? renewsAt = freezed,Object? features = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,renewsAt: freezed == renewsAt ? _self.renewsAt : renewsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<AiFeatureSetting>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiSettings].
extension AiSettingsPatterns on AiSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiSettings value)  $default,){
final _that = this;
switch (_that) {
case _AiSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AiSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AiSettings implements AiSettings {
  const _AiSettings({@JsonKey(name: 'enabled') this.enabled = true, @JsonKey(name: 'remaining') this.remaining = 0, @JsonKey(name: 'total') this.total = 0, @JsonKey(name: 'renewsAt') this.renewsAt, @JsonKey(name: 'features') final  List<AiFeatureSetting> features = const []}): _features = features;
  factory _AiSettings.fromJson(Map<String, dynamic> json) => _$AiSettingsFromJson(json);

@override@JsonKey(name: 'enabled') final  bool enabled;
@override@JsonKey(name: 'remaining') final  int remaining;
@override@JsonKey(name: 'total') final  int total;
@override@JsonKey(name: 'renewsAt') final  DateTime? renewsAt;
 final  List<AiFeatureSetting> _features;
@override@JsonKey(name: 'features') List<AiFeatureSetting> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}


/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiSettingsCopyWith<_AiSettings> get copyWith => __$AiSettingsCopyWithImpl<_AiSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.total, total) || other.total == total)&&(identical(other.renewsAt, renewsAt) || other.renewsAt == renewsAt)&&const DeepCollectionEquality().equals(other._features, _features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,remaining,total,renewsAt,const DeepCollectionEquality().hash(_features));

@override
String toString() {
  return 'AiSettings(enabled: $enabled, remaining: $remaining, total: $total, renewsAt: $renewsAt, features: $features)';
}


}

/// @nodoc
abstract mixin class _$AiSettingsCopyWith<$Res> implements $AiSettingsCopyWith<$Res> {
  factory _$AiSettingsCopyWith(_AiSettings value, $Res Function(_AiSettings) _then) = __$AiSettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'enabled') bool enabled,@JsonKey(name: 'remaining') int remaining,@JsonKey(name: 'total') int total,@JsonKey(name: 'renewsAt') DateTime? renewsAt,@JsonKey(name: 'features') List<AiFeatureSetting> features
});




}
/// @nodoc
class __$AiSettingsCopyWithImpl<$Res>
    implements _$AiSettingsCopyWith<$Res> {
  __$AiSettingsCopyWithImpl(this._self, this._then);

  final _AiSettings _self;
  final $Res Function(_AiSettings) _then;

/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? remaining = null,Object? total = null,Object? renewsAt = freezed,Object? features = null,}) {
  return _then(_AiSettings(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,renewsAt: freezed == renewsAt ? _self.renewsAt : renewsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<AiFeatureSetting>,
  ));
}


}

// dart format on
