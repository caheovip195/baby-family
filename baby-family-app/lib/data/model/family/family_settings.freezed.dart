// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilySettings {

@JsonKey(name: 'name') String get name;@JsonKey(name: 'coverAsset') String? get coverAsset;@JsonKey(name: 'defaultVisibility') MemoryVisibility get defaultVisibility;@JsonKey(name: 'approveRelativePhotos') bool get approveRelativePhotos;@JsonKey(name: 'relativesSeeTree') bool get relativesSeeTree;@JsonKey(name: 'milestoneSuggestions') bool get milestoneSuggestions;@JsonKey(name: 'timezoneLabel') String get timezoneLabel;@JsonKey(name: 'showLunar') bool get showLunar;@JsonKey(name: 'milestonesByLunar') bool get milestonesByLunar;@JsonKey(name: 'contentLanguage') String get contentLanguage;
/// Create a copy of FamilySettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilySettingsCopyWith<FamilySettings> get copyWith => _$FamilySettingsCopyWithImpl<FamilySettings>(this as FamilySettings, _$identity);

  /// Serializes this FamilySettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilySettings&&(identical(other.name, name) || other.name == name)&&(identical(other.coverAsset, coverAsset) || other.coverAsset == coverAsset)&&(identical(other.defaultVisibility, defaultVisibility) || other.defaultVisibility == defaultVisibility)&&(identical(other.approveRelativePhotos, approveRelativePhotos) || other.approveRelativePhotos == approveRelativePhotos)&&(identical(other.relativesSeeTree, relativesSeeTree) || other.relativesSeeTree == relativesSeeTree)&&(identical(other.milestoneSuggestions, milestoneSuggestions) || other.milestoneSuggestions == milestoneSuggestions)&&(identical(other.timezoneLabel, timezoneLabel) || other.timezoneLabel == timezoneLabel)&&(identical(other.showLunar, showLunar) || other.showLunar == showLunar)&&(identical(other.milestonesByLunar, milestonesByLunar) || other.milestonesByLunar == milestonesByLunar)&&(identical(other.contentLanguage, contentLanguage) || other.contentLanguage == contentLanguage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,coverAsset,defaultVisibility,approveRelativePhotos,relativesSeeTree,milestoneSuggestions,timezoneLabel,showLunar,milestonesByLunar,contentLanguage);

@override
String toString() {
  return 'FamilySettings(name: $name, coverAsset: $coverAsset, defaultVisibility: $defaultVisibility, approveRelativePhotos: $approveRelativePhotos, relativesSeeTree: $relativesSeeTree, milestoneSuggestions: $milestoneSuggestions, timezoneLabel: $timezoneLabel, showLunar: $showLunar, milestonesByLunar: $milestonesByLunar, contentLanguage: $contentLanguage)';
}


}

/// @nodoc
abstract mixin class $FamilySettingsCopyWith<$Res>  {
  factory $FamilySettingsCopyWith(FamilySettings value, $Res Function(FamilySettings) _then) = _$FamilySettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'coverAsset') String? coverAsset,@JsonKey(name: 'defaultVisibility') MemoryVisibility defaultVisibility,@JsonKey(name: 'approveRelativePhotos') bool approveRelativePhotos,@JsonKey(name: 'relativesSeeTree') bool relativesSeeTree,@JsonKey(name: 'milestoneSuggestions') bool milestoneSuggestions,@JsonKey(name: 'timezoneLabel') String timezoneLabel,@JsonKey(name: 'showLunar') bool showLunar,@JsonKey(name: 'milestonesByLunar') bool milestonesByLunar,@JsonKey(name: 'contentLanguage') String contentLanguage
});




}
/// @nodoc
class _$FamilySettingsCopyWithImpl<$Res>
    implements $FamilySettingsCopyWith<$Res> {
  _$FamilySettingsCopyWithImpl(this._self, this._then);

  final FamilySettings _self;
  final $Res Function(FamilySettings) _then;

/// Create a copy of FamilySettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? coverAsset = freezed,Object? defaultVisibility = null,Object? approveRelativePhotos = null,Object? relativesSeeTree = null,Object? milestoneSuggestions = null,Object? timezoneLabel = null,Object? showLunar = null,Object? milestonesByLunar = null,Object? contentLanguage = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coverAsset: freezed == coverAsset ? _self.coverAsset : coverAsset // ignore: cast_nullable_to_non_nullable
as String?,defaultVisibility: null == defaultVisibility ? _self.defaultVisibility : defaultVisibility // ignore: cast_nullable_to_non_nullable
as MemoryVisibility,approveRelativePhotos: null == approveRelativePhotos ? _self.approveRelativePhotos : approveRelativePhotos // ignore: cast_nullable_to_non_nullable
as bool,relativesSeeTree: null == relativesSeeTree ? _self.relativesSeeTree : relativesSeeTree // ignore: cast_nullable_to_non_nullable
as bool,milestoneSuggestions: null == milestoneSuggestions ? _self.milestoneSuggestions : milestoneSuggestions // ignore: cast_nullable_to_non_nullable
as bool,timezoneLabel: null == timezoneLabel ? _self.timezoneLabel : timezoneLabel // ignore: cast_nullable_to_non_nullable
as String,showLunar: null == showLunar ? _self.showLunar : showLunar // ignore: cast_nullable_to_non_nullable
as bool,milestonesByLunar: null == milestonesByLunar ? _self.milestonesByLunar : milestonesByLunar // ignore: cast_nullable_to_non_nullable
as bool,contentLanguage: null == contentLanguage ? _self.contentLanguage : contentLanguage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilySettings].
extension FamilySettingsPatterns on FamilySettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilySettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilySettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilySettings value)  $default,){
final _that = this;
switch (_that) {
case _FamilySettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilySettings value)?  $default,){
final _that = this;
switch (_that) {
case _FamilySettings() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FamilySettings implements FamilySettings {
  const _FamilySettings({@JsonKey(name: 'name') this.name = '', @JsonKey(name: 'coverAsset') this.coverAsset, @JsonKey(name: 'defaultVisibility') this.defaultVisibility = MemoryVisibility.family, @JsonKey(name: 'approveRelativePhotos') this.approveRelativePhotos = true, @JsonKey(name: 'relativesSeeTree') this.relativesSeeTree = true, @JsonKey(name: 'milestoneSuggestions') this.milestoneSuggestions = true, @JsonKey(name: 'timezoneLabel') this.timezoneLabel = '', @JsonKey(name: 'showLunar') this.showLunar = true, @JsonKey(name: 'milestonesByLunar') this.milestonesByLunar = true, @JsonKey(name: 'contentLanguage') this.contentLanguage = 'vi'});
  factory _FamilySettings.fromJson(Map<String, dynamic> json) => _$FamilySettingsFromJson(json);

@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'coverAsset') final  String? coverAsset;
@override@JsonKey(name: 'defaultVisibility') final  MemoryVisibility defaultVisibility;
@override@JsonKey(name: 'approveRelativePhotos') final  bool approveRelativePhotos;
@override@JsonKey(name: 'relativesSeeTree') final  bool relativesSeeTree;
@override@JsonKey(name: 'milestoneSuggestions') final  bool milestoneSuggestions;
@override@JsonKey(name: 'timezoneLabel') final  String timezoneLabel;
@override@JsonKey(name: 'showLunar') final  bool showLunar;
@override@JsonKey(name: 'milestonesByLunar') final  bool milestonesByLunar;
@override@JsonKey(name: 'contentLanguage') final  String contentLanguage;

/// Create a copy of FamilySettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilySettingsCopyWith<_FamilySettings> get copyWith => __$FamilySettingsCopyWithImpl<_FamilySettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilySettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilySettings&&(identical(other.name, name) || other.name == name)&&(identical(other.coverAsset, coverAsset) || other.coverAsset == coverAsset)&&(identical(other.defaultVisibility, defaultVisibility) || other.defaultVisibility == defaultVisibility)&&(identical(other.approveRelativePhotos, approveRelativePhotos) || other.approveRelativePhotos == approveRelativePhotos)&&(identical(other.relativesSeeTree, relativesSeeTree) || other.relativesSeeTree == relativesSeeTree)&&(identical(other.milestoneSuggestions, milestoneSuggestions) || other.milestoneSuggestions == milestoneSuggestions)&&(identical(other.timezoneLabel, timezoneLabel) || other.timezoneLabel == timezoneLabel)&&(identical(other.showLunar, showLunar) || other.showLunar == showLunar)&&(identical(other.milestonesByLunar, milestonesByLunar) || other.milestonesByLunar == milestonesByLunar)&&(identical(other.contentLanguage, contentLanguage) || other.contentLanguage == contentLanguage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,coverAsset,defaultVisibility,approveRelativePhotos,relativesSeeTree,milestoneSuggestions,timezoneLabel,showLunar,milestonesByLunar,contentLanguage);

@override
String toString() {
  return 'FamilySettings(name: $name, coverAsset: $coverAsset, defaultVisibility: $defaultVisibility, approveRelativePhotos: $approveRelativePhotos, relativesSeeTree: $relativesSeeTree, milestoneSuggestions: $milestoneSuggestions, timezoneLabel: $timezoneLabel, showLunar: $showLunar, milestonesByLunar: $milestonesByLunar, contentLanguage: $contentLanguage)';
}


}

/// @nodoc
abstract mixin class _$FamilySettingsCopyWith<$Res> implements $FamilySettingsCopyWith<$Res> {
  factory _$FamilySettingsCopyWith(_FamilySettings value, $Res Function(_FamilySettings) _then) = __$FamilySettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'coverAsset') String? coverAsset,@JsonKey(name: 'defaultVisibility') MemoryVisibility defaultVisibility,@JsonKey(name: 'approveRelativePhotos') bool approveRelativePhotos,@JsonKey(name: 'relativesSeeTree') bool relativesSeeTree,@JsonKey(name: 'milestoneSuggestions') bool milestoneSuggestions,@JsonKey(name: 'timezoneLabel') String timezoneLabel,@JsonKey(name: 'showLunar') bool showLunar,@JsonKey(name: 'milestonesByLunar') bool milestonesByLunar,@JsonKey(name: 'contentLanguage') String contentLanguage
});




}
/// @nodoc
class __$FamilySettingsCopyWithImpl<$Res>
    implements _$FamilySettingsCopyWith<$Res> {
  __$FamilySettingsCopyWithImpl(this._self, this._then);

  final _FamilySettings _self;
  final $Res Function(_FamilySettings) _then;

/// Create a copy of FamilySettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? coverAsset = freezed,Object? defaultVisibility = null,Object? approveRelativePhotos = null,Object? relativesSeeTree = null,Object? milestoneSuggestions = null,Object? timezoneLabel = null,Object? showLunar = null,Object? milestonesByLunar = null,Object? contentLanguage = null,}) {
  return _then(_FamilySettings(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coverAsset: freezed == coverAsset ? _self.coverAsset : coverAsset // ignore: cast_nullable_to_non_nullable
as String?,defaultVisibility: null == defaultVisibility ? _self.defaultVisibility : defaultVisibility // ignore: cast_nullable_to_non_nullable
as MemoryVisibility,approveRelativePhotos: null == approveRelativePhotos ? _self.approveRelativePhotos : approveRelativePhotos // ignore: cast_nullable_to_non_nullable
as bool,relativesSeeTree: null == relativesSeeTree ? _self.relativesSeeTree : relativesSeeTree // ignore: cast_nullable_to_non_nullable
as bool,milestoneSuggestions: null == milestoneSuggestions ? _self.milestoneSuggestions : milestoneSuggestions // ignore: cast_nullable_to_non_nullable
as bool,timezoneLabel: null == timezoneLabel ? _self.timezoneLabel : timezoneLabel // ignore: cast_nullable_to_non_nullable
as String,showLunar: null == showLunar ? _self.showLunar : showLunar // ignore: cast_nullable_to_non_nullable
as bool,milestonesByLunar: null == milestonesByLunar ? _self.milestonesByLunar : milestonesByLunar // ignore: cast_nullable_to_non_nullable
as bool,contentLanguage: null == contentLanguage ? _self.contentLanguage : contentLanguage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
