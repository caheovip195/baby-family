// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'couple_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoupleSettings {

@JsonKey(name: 'checkinShareMode') CheckinShareMode get checkinShareMode;@JsonKey(name: 'hideOnLockScreen') bool get hideOnLockScreen;@JsonKey(name: 'faceIdLock') bool get faceIdLock;@JsonKey(name: 'urgentBypassQuiet') bool get urgentBypassQuiet;@JsonKey(name: 'quietFrom') String get quietFrom;@JsonKey(name: 'quietTo') String get quietTo;@JsonKey(name: 'bridgeRetentionDays') int get bridgeRetentionDays;@JsonKey(name: 'journalFaceIdLock') bool get journalFaceIdLock;
/// Create a copy of CoupleSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoupleSettingsCopyWith<CoupleSettings> get copyWith => _$CoupleSettingsCopyWithImpl<CoupleSettings>(this as CoupleSettings, _$identity);

  /// Serializes this CoupleSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoupleSettings&&(identical(other.checkinShareMode, checkinShareMode) || other.checkinShareMode == checkinShareMode)&&(identical(other.hideOnLockScreen, hideOnLockScreen) || other.hideOnLockScreen == hideOnLockScreen)&&(identical(other.faceIdLock, faceIdLock) || other.faceIdLock == faceIdLock)&&(identical(other.urgentBypassQuiet, urgentBypassQuiet) || other.urgentBypassQuiet == urgentBypassQuiet)&&(identical(other.quietFrom, quietFrom) || other.quietFrom == quietFrom)&&(identical(other.quietTo, quietTo) || other.quietTo == quietTo)&&(identical(other.bridgeRetentionDays, bridgeRetentionDays) || other.bridgeRetentionDays == bridgeRetentionDays)&&(identical(other.journalFaceIdLock, journalFaceIdLock) || other.journalFaceIdLock == journalFaceIdLock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,checkinShareMode,hideOnLockScreen,faceIdLock,urgentBypassQuiet,quietFrom,quietTo,bridgeRetentionDays,journalFaceIdLock);

@override
String toString() {
  return 'CoupleSettings(checkinShareMode: $checkinShareMode, hideOnLockScreen: $hideOnLockScreen, faceIdLock: $faceIdLock, urgentBypassQuiet: $urgentBypassQuiet, quietFrom: $quietFrom, quietTo: $quietTo, bridgeRetentionDays: $bridgeRetentionDays, journalFaceIdLock: $journalFaceIdLock)';
}


}

/// @nodoc
abstract mixin class $CoupleSettingsCopyWith<$Res>  {
  factory $CoupleSettingsCopyWith(CoupleSettings value, $Res Function(CoupleSettings) _then) = _$CoupleSettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'checkinShareMode') CheckinShareMode checkinShareMode,@JsonKey(name: 'hideOnLockScreen') bool hideOnLockScreen,@JsonKey(name: 'faceIdLock') bool faceIdLock,@JsonKey(name: 'urgentBypassQuiet') bool urgentBypassQuiet,@JsonKey(name: 'quietFrom') String quietFrom,@JsonKey(name: 'quietTo') String quietTo,@JsonKey(name: 'bridgeRetentionDays') int bridgeRetentionDays,@JsonKey(name: 'journalFaceIdLock') bool journalFaceIdLock
});




}
/// @nodoc
class _$CoupleSettingsCopyWithImpl<$Res>
    implements $CoupleSettingsCopyWith<$Res> {
  _$CoupleSettingsCopyWithImpl(this._self, this._then);

  final CoupleSettings _self;
  final $Res Function(CoupleSettings) _then;

/// Create a copy of CoupleSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? checkinShareMode = null,Object? hideOnLockScreen = null,Object? faceIdLock = null,Object? urgentBypassQuiet = null,Object? quietFrom = null,Object? quietTo = null,Object? bridgeRetentionDays = null,Object? journalFaceIdLock = null,}) {
  return _then(_self.copyWith(
checkinShareMode: null == checkinShareMode ? _self.checkinShareMode : checkinShareMode // ignore: cast_nullable_to_non_nullable
as CheckinShareMode,hideOnLockScreen: null == hideOnLockScreen ? _self.hideOnLockScreen : hideOnLockScreen // ignore: cast_nullable_to_non_nullable
as bool,faceIdLock: null == faceIdLock ? _self.faceIdLock : faceIdLock // ignore: cast_nullable_to_non_nullable
as bool,urgentBypassQuiet: null == urgentBypassQuiet ? _self.urgentBypassQuiet : urgentBypassQuiet // ignore: cast_nullable_to_non_nullable
as bool,quietFrom: null == quietFrom ? _self.quietFrom : quietFrom // ignore: cast_nullable_to_non_nullable
as String,quietTo: null == quietTo ? _self.quietTo : quietTo // ignore: cast_nullable_to_non_nullable
as String,bridgeRetentionDays: null == bridgeRetentionDays ? _self.bridgeRetentionDays : bridgeRetentionDays // ignore: cast_nullable_to_non_nullable
as int,journalFaceIdLock: null == journalFaceIdLock ? _self.journalFaceIdLock : journalFaceIdLock // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CoupleSettings].
extension CoupleSettingsPatterns on CoupleSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoupleSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoupleSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoupleSettings value)  $default,){
final _that = this;
switch (_that) {
case _CoupleSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoupleSettings value)?  $default,){
final _that = this;
switch (_that) {
case _CoupleSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CoupleSettings implements CoupleSettings {
  const _CoupleSettings({@JsonKey(name: 'checkinShareMode') this.checkinShareMode = CheckinShareMode.askEachTime, @JsonKey(name: 'hideOnLockScreen') this.hideOnLockScreen = true, @JsonKey(name: 'faceIdLock') this.faceIdLock = false, @JsonKey(name: 'urgentBypassQuiet') this.urgentBypassQuiet = false, @JsonKey(name: 'quietFrom') this.quietFrom = '22:00', @JsonKey(name: 'quietTo') this.quietTo = '06:30', @JsonKey(name: 'bridgeRetentionDays') this.bridgeRetentionDays = 30, @JsonKey(name: 'journalFaceIdLock') this.journalFaceIdLock = true});
  factory _CoupleSettings.fromJson(Map<String, dynamic> json) => _$CoupleSettingsFromJson(json);

@override@JsonKey(name: 'checkinShareMode') final  CheckinShareMode checkinShareMode;
@override@JsonKey(name: 'hideOnLockScreen') final  bool hideOnLockScreen;
@override@JsonKey(name: 'faceIdLock') final  bool faceIdLock;
@override@JsonKey(name: 'urgentBypassQuiet') final  bool urgentBypassQuiet;
@override@JsonKey(name: 'quietFrom') final  String quietFrom;
@override@JsonKey(name: 'quietTo') final  String quietTo;
@override@JsonKey(name: 'bridgeRetentionDays') final  int bridgeRetentionDays;
@override@JsonKey(name: 'journalFaceIdLock') final  bool journalFaceIdLock;

/// Create a copy of CoupleSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoupleSettingsCopyWith<_CoupleSettings> get copyWith => __$CoupleSettingsCopyWithImpl<_CoupleSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoupleSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoupleSettings&&(identical(other.checkinShareMode, checkinShareMode) || other.checkinShareMode == checkinShareMode)&&(identical(other.hideOnLockScreen, hideOnLockScreen) || other.hideOnLockScreen == hideOnLockScreen)&&(identical(other.faceIdLock, faceIdLock) || other.faceIdLock == faceIdLock)&&(identical(other.urgentBypassQuiet, urgentBypassQuiet) || other.urgentBypassQuiet == urgentBypassQuiet)&&(identical(other.quietFrom, quietFrom) || other.quietFrom == quietFrom)&&(identical(other.quietTo, quietTo) || other.quietTo == quietTo)&&(identical(other.bridgeRetentionDays, bridgeRetentionDays) || other.bridgeRetentionDays == bridgeRetentionDays)&&(identical(other.journalFaceIdLock, journalFaceIdLock) || other.journalFaceIdLock == journalFaceIdLock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,checkinShareMode,hideOnLockScreen,faceIdLock,urgentBypassQuiet,quietFrom,quietTo,bridgeRetentionDays,journalFaceIdLock);

@override
String toString() {
  return 'CoupleSettings(checkinShareMode: $checkinShareMode, hideOnLockScreen: $hideOnLockScreen, faceIdLock: $faceIdLock, urgentBypassQuiet: $urgentBypassQuiet, quietFrom: $quietFrom, quietTo: $quietTo, bridgeRetentionDays: $bridgeRetentionDays, journalFaceIdLock: $journalFaceIdLock)';
}


}

/// @nodoc
abstract mixin class _$CoupleSettingsCopyWith<$Res> implements $CoupleSettingsCopyWith<$Res> {
  factory _$CoupleSettingsCopyWith(_CoupleSettings value, $Res Function(_CoupleSettings) _then) = __$CoupleSettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'checkinShareMode') CheckinShareMode checkinShareMode,@JsonKey(name: 'hideOnLockScreen') bool hideOnLockScreen,@JsonKey(name: 'faceIdLock') bool faceIdLock,@JsonKey(name: 'urgentBypassQuiet') bool urgentBypassQuiet,@JsonKey(name: 'quietFrom') String quietFrom,@JsonKey(name: 'quietTo') String quietTo,@JsonKey(name: 'bridgeRetentionDays') int bridgeRetentionDays,@JsonKey(name: 'journalFaceIdLock') bool journalFaceIdLock
});




}
/// @nodoc
class __$CoupleSettingsCopyWithImpl<$Res>
    implements _$CoupleSettingsCopyWith<$Res> {
  __$CoupleSettingsCopyWithImpl(this._self, this._then);

  final _CoupleSettings _self;
  final $Res Function(_CoupleSettings) _then;

/// Create a copy of CoupleSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? checkinShareMode = null,Object? hideOnLockScreen = null,Object? faceIdLock = null,Object? urgentBypassQuiet = null,Object? quietFrom = null,Object? quietTo = null,Object? bridgeRetentionDays = null,Object? journalFaceIdLock = null,}) {
  return _then(_CoupleSettings(
checkinShareMode: null == checkinShareMode ? _self.checkinShareMode : checkinShareMode // ignore: cast_nullable_to_non_nullable
as CheckinShareMode,hideOnLockScreen: null == hideOnLockScreen ? _self.hideOnLockScreen : hideOnLockScreen // ignore: cast_nullable_to_non_nullable
as bool,faceIdLock: null == faceIdLock ? _self.faceIdLock : faceIdLock // ignore: cast_nullable_to_non_nullable
as bool,urgentBypassQuiet: null == urgentBypassQuiet ? _self.urgentBypassQuiet : urgentBypassQuiet // ignore: cast_nullable_to_non_nullable
as bool,quietFrom: null == quietFrom ? _self.quietFrom : quietFrom // ignore: cast_nullable_to_non_nullable
as String,quietTo: null == quietTo ? _self.quietTo : quietTo // ignore: cast_nullable_to_non_nullable
as String,bridgeRetentionDays: null == bridgeRetentionDays ? _self.bridgeRetentionDays : bridgeRetentionDays // ignore: cast_nullable_to_non_nullable
as int,journalFaceIdLock: null == journalFaceIdLock ? _self.journalFaceIdLock : journalFaceIdLock // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
