// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrivacySettings {

@JsonKey(name: 'defaultVisibility') MemoryVisibility get defaultVisibility;@JsonKey(name: 'audiences') List<ChildAudience> get audiences;@JsonKey(name: 'downloadAllowed') List<String> get downloadAllowed;@JsonKey(name: 'postAllowed') List<String> get postAllowed;@JsonKey(name: 'familyVisibleMemories') int get familyVisibleMemories;@JsonKey(name: 'deviceCount') int get deviceCount;@JsonKey(name: 'aiFeatures') int get aiFeatures;@JsonKey(name: 'blockedCount') int get blockedCount;
/// Create a copy of PrivacySettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivacySettingsCopyWith<PrivacySettings> get copyWith => _$PrivacySettingsCopyWithImpl<PrivacySettings>(this as PrivacySettings, _$identity);

  /// Serializes this PrivacySettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivacySettings&&(identical(other.defaultVisibility, defaultVisibility) || other.defaultVisibility == defaultVisibility)&&const DeepCollectionEquality().equals(other.audiences, audiences)&&const DeepCollectionEquality().equals(other.downloadAllowed, downloadAllowed)&&const DeepCollectionEquality().equals(other.postAllowed, postAllowed)&&(identical(other.familyVisibleMemories, familyVisibleMemories) || other.familyVisibleMemories == familyVisibleMemories)&&(identical(other.deviceCount, deviceCount) || other.deviceCount == deviceCount)&&(identical(other.aiFeatures, aiFeatures) || other.aiFeatures == aiFeatures)&&(identical(other.blockedCount, blockedCount) || other.blockedCount == blockedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultVisibility,const DeepCollectionEquality().hash(audiences),const DeepCollectionEquality().hash(downloadAllowed),const DeepCollectionEquality().hash(postAllowed),familyVisibleMemories,deviceCount,aiFeatures,blockedCount);

@override
String toString() {
  return 'PrivacySettings(defaultVisibility: $defaultVisibility, audiences: $audiences, downloadAllowed: $downloadAllowed, postAllowed: $postAllowed, familyVisibleMemories: $familyVisibleMemories, deviceCount: $deviceCount, aiFeatures: $aiFeatures, blockedCount: $blockedCount)';
}


}

/// @nodoc
abstract mixin class $PrivacySettingsCopyWith<$Res>  {
  factory $PrivacySettingsCopyWith(PrivacySettings value, $Res Function(PrivacySettings) _then) = _$PrivacySettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'defaultVisibility') MemoryVisibility defaultVisibility,@JsonKey(name: 'audiences') List<ChildAudience> audiences,@JsonKey(name: 'downloadAllowed') List<String> downloadAllowed,@JsonKey(name: 'postAllowed') List<String> postAllowed,@JsonKey(name: 'familyVisibleMemories') int familyVisibleMemories,@JsonKey(name: 'deviceCount') int deviceCount,@JsonKey(name: 'aiFeatures') int aiFeatures,@JsonKey(name: 'blockedCount') int blockedCount
});




}
/// @nodoc
class _$PrivacySettingsCopyWithImpl<$Res>
    implements $PrivacySettingsCopyWith<$Res> {
  _$PrivacySettingsCopyWithImpl(this._self, this._then);

  final PrivacySettings _self;
  final $Res Function(PrivacySettings) _then;

/// Create a copy of PrivacySettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? defaultVisibility = null,Object? audiences = null,Object? downloadAllowed = null,Object? postAllowed = null,Object? familyVisibleMemories = null,Object? deviceCount = null,Object? aiFeatures = null,Object? blockedCount = null,}) {
  return _then(_self.copyWith(
defaultVisibility: null == defaultVisibility ? _self.defaultVisibility : defaultVisibility // ignore: cast_nullable_to_non_nullable
as MemoryVisibility,audiences: null == audiences ? _self.audiences : audiences // ignore: cast_nullable_to_non_nullable
as List<ChildAudience>,downloadAllowed: null == downloadAllowed ? _self.downloadAllowed : downloadAllowed // ignore: cast_nullable_to_non_nullable
as List<String>,postAllowed: null == postAllowed ? _self.postAllowed : postAllowed // ignore: cast_nullable_to_non_nullable
as List<String>,familyVisibleMemories: null == familyVisibleMemories ? _self.familyVisibleMemories : familyVisibleMemories // ignore: cast_nullable_to_non_nullable
as int,deviceCount: null == deviceCount ? _self.deviceCount : deviceCount // ignore: cast_nullable_to_non_nullable
as int,aiFeatures: null == aiFeatures ? _self.aiFeatures : aiFeatures // ignore: cast_nullable_to_non_nullable
as int,blockedCount: null == blockedCount ? _self.blockedCount : blockedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivacySettings].
extension PrivacySettingsPatterns on PrivacySettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivacySettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivacySettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivacySettings value)  $default,){
final _that = this;
switch (_that) {
case _PrivacySettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivacySettings value)?  $default,){
final _that = this;
switch (_that) {
case _PrivacySettings() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PrivacySettings implements PrivacySettings {
  const _PrivacySettings({@JsonKey(name: 'defaultVisibility') this.defaultVisibility = MemoryVisibility.family, @JsonKey(name: 'audiences') final  List<ChildAudience> audiences = const [], @JsonKey(name: 'downloadAllowed') final  List<String> downloadAllowed = const [], @JsonKey(name: 'postAllowed') final  List<String> postAllowed = const [], @JsonKey(name: 'familyVisibleMemories') this.familyVisibleMemories = 0, @JsonKey(name: 'deviceCount') this.deviceCount = 0, @JsonKey(name: 'aiFeatures') this.aiFeatures = 0, @JsonKey(name: 'blockedCount') this.blockedCount = 0}): _audiences = audiences,_downloadAllowed = downloadAllowed,_postAllowed = postAllowed;
  factory _PrivacySettings.fromJson(Map<String, dynamic> json) => _$PrivacySettingsFromJson(json);

@override@JsonKey(name: 'defaultVisibility') final  MemoryVisibility defaultVisibility;
 final  List<ChildAudience> _audiences;
@override@JsonKey(name: 'audiences') List<ChildAudience> get audiences {
  if (_audiences is EqualUnmodifiableListView) return _audiences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_audiences);
}

 final  List<String> _downloadAllowed;
@override@JsonKey(name: 'downloadAllowed') List<String> get downloadAllowed {
  if (_downloadAllowed is EqualUnmodifiableListView) return _downloadAllowed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_downloadAllowed);
}

 final  List<String> _postAllowed;
@override@JsonKey(name: 'postAllowed') List<String> get postAllowed {
  if (_postAllowed is EqualUnmodifiableListView) return _postAllowed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_postAllowed);
}

@override@JsonKey(name: 'familyVisibleMemories') final  int familyVisibleMemories;
@override@JsonKey(name: 'deviceCount') final  int deviceCount;
@override@JsonKey(name: 'aiFeatures') final  int aiFeatures;
@override@JsonKey(name: 'blockedCount') final  int blockedCount;

/// Create a copy of PrivacySettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivacySettingsCopyWith<_PrivacySettings> get copyWith => __$PrivacySettingsCopyWithImpl<_PrivacySettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrivacySettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivacySettings&&(identical(other.defaultVisibility, defaultVisibility) || other.defaultVisibility == defaultVisibility)&&const DeepCollectionEquality().equals(other._audiences, _audiences)&&const DeepCollectionEquality().equals(other._downloadAllowed, _downloadAllowed)&&const DeepCollectionEquality().equals(other._postAllowed, _postAllowed)&&(identical(other.familyVisibleMemories, familyVisibleMemories) || other.familyVisibleMemories == familyVisibleMemories)&&(identical(other.deviceCount, deviceCount) || other.deviceCount == deviceCount)&&(identical(other.aiFeatures, aiFeatures) || other.aiFeatures == aiFeatures)&&(identical(other.blockedCount, blockedCount) || other.blockedCount == blockedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultVisibility,const DeepCollectionEquality().hash(_audiences),const DeepCollectionEquality().hash(_downloadAllowed),const DeepCollectionEquality().hash(_postAllowed),familyVisibleMemories,deviceCount,aiFeatures,blockedCount);

@override
String toString() {
  return 'PrivacySettings(defaultVisibility: $defaultVisibility, audiences: $audiences, downloadAllowed: $downloadAllowed, postAllowed: $postAllowed, familyVisibleMemories: $familyVisibleMemories, deviceCount: $deviceCount, aiFeatures: $aiFeatures, blockedCount: $blockedCount)';
}


}

/// @nodoc
abstract mixin class _$PrivacySettingsCopyWith<$Res> implements $PrivacySettingsCopyWith<$Res> {
  factory _$PrivacySettingsCopyWith(_PrivacySettings value, $Res Function(_PrivacySettings) _then) = __$PrivacySettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'defaultVisibility') MemoryVisibility defaultVisibility,@JsonKey(name: 'audiences') List<ChildAudience> audiences,@JsonKey(name: 'downloadAllowed') List<String> downloadAllowed,@JsonKey(name: 'postAllowed') List<String> postAllowed,@JsonKey(name: 'familyVisibleMemories') int familyVisibleMemories,@JsonKey(name: 'deviceCount') int deviceCount,@JsonKey(name: 'aiFeatures') int aiFeatures,@JsonKey(name: 'blockedCount') int blockedCount
});




}
/// @nodoc
class __$PrivacySettingsCopyWithImpl<$Res>
    implements _$PrivacySettingsCopyWith<$Res> {
  __$PrivacySettingsCopyWithImpl(this._self, this._then);

  final _PrivacySettings _self;
  final $Res Function(_PrivacySettings) _then;

/// Create a copy of PrivacySettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? defaultVisibility = null,Object? audiences = null,Object? downloadAllowed = null,Object? postAllowed = null,Object? familyVisibleMemories = null,Object? deviceCount = null,Object? aiFeatures = null,Object? blockedCount = null,}) {
  return _then(_PrivacySettings(
defaultVisibility: null == defaultVisibility ? _self.defaultVisibility : defaultVisibility // ignore: cast_nullable_to_non_nullable
as MemoryVisibility,audiences: null == audiences ? _self._audiences : audiences // ignore: cast_nullable_to_non_nullable
as List<ChildAudience>,downloadAllowed: null == downloadAllowed ? _self._downloadAllowed : downloadAllowed // ignore: cast_nullable_to_non_nullable
as List<String>,postAllowed: null == postAllowed ? _self._postAllowed : postAllowed // ignore: cast_nullable_to_non_nullable
as List<String>,familyVisibleMemories: null == familyVisibleMemories ? _self.familyVisibleMemories : familyVisibleMemories // ignore: cast_nullable_to_non_nullable
as int,deviceCount: null == deviceCount ? _self.deviceCount : deviceCount // ignore: cast_nullable_to_non_nullable
as int,aiFeatures: null == aiFeatures ? _self.aiFeatures : aiFeatures // ignore: cast_nullable_to_non_nullable
as int,blockedCount: null == blockedCount ? _self.blockedCount : blockedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
