// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionSettings {

@JsonKey(name: 'level') MissionLoadLevel get level;@JsonKey(name: 'categories') List<MissionCategorySetting> get categories;@JsonKey(name: 'boardTime') String get boardTime;@JsonKey(name: 'askAtNight') bool get askAtNight;@JsonKey(name: 'defaultReminder') MissionReminder get defaultReminder;
/// Create a copy of MissionSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionSettingsCopyWith<MissionSettings> get copyWith => _$MissionSettingsCopyWithImpl<MissionSettings>(this as MissionSettings, _$identity);

  /// Serializes this MissionSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionSettings&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.boardTime, boardTime) || other.boardTime == boardTime)&&(identical(other.askAtNight, askAtNight) || other.askAtNight == askAtNight)&&(identical(other.defaultReminder, defaultReminder) || other.defaultReminder == defaultReminder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,const DeepCollectionEquality().hash(categories),boardTime,askAtNight,defaultReminder);

@override
String toString() {
  return 'MissionSettings(level: $level, categories: $categories, boardTime: $boardTime, askAtNight: $askAtNight, defaultReminder: $defaultReminder)';
}


}

/// @nodoc
abstract mixin class $MissionSettingsCopyWith<$Res>  {
  factory $MissionSettingsCopyWith(MissionSettings value, $Res Function(MissionSettings) _then) = _$MissionSettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'level') MissionLoadLevel level,@JsonKey(name: 'categories') List<MissionCategorySetting> categories,@JsonKey(name: 'boardTime') String boardTime,@JsonKey(name: 'askAtNight') bool askAtNight,@JsonKey(name: 'defaultReminder') MissionReminder defaultReminder
});




}
/// @nodoc
class _$MissionSettingsCopyWithImpl<$Res>
    implements $MissionSettingsCopyWith<$Res> {
  _$MissionSettingsCopyWithImpl(this._self, this._then);

  final MissionSettings _self;
  final $Res Function(MissionSettings) _then;

/// Create a copy of MissionSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? categories = null,Object? boardTime = null,Object? askAtNight = null,Object? defaultReminder = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as MissionLoadLevel,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<MissionCategorySetting>,boardTime: null == boardTime ? _self.boardTime : boardTime // ignore: cast_nullable_to_non_nullable
as String,askAtNight: null == askAtNight ? _self.askAtNight : askAtNight // ignore: cast_nullable_to_non_nullable
as bool,defaultReminder: null == defaultReminder ? _self.defaultReminder : defaultReminder // ignore: cast_nullable_to_non_nullable
as MissionReminder,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionSettings].
extension MissionSettingsPatterns on MissionSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionSettings value)  $default,){
final _that = this;
switch (_that) {
case _MissionSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionSettings value)?  $default,){
final _that = this;
switch (_that) {
case _MissionSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MissionSettings implements MissionSettings {
  const _MissionSettings({@JsonKey(name: 'level') this.level = MissionLoadLevel.medium, @JsonKey(name: 'categories') final  List<MissionCategorySetting> categories = const [], @JsonKey(name: 'boardTime') this.boardTime = '07:00', @JsonKey(name: 'askAtNight') this.askAtNight = true, @JsonKey(name: 'defaultReminder') this.defaultReminder = MissionReminder.before15}): _categories = categories;
  factory _MissionSettings.fromJson(Map<String, dynamic> json) => _$MissionSettingsFromJson(json);

@override@JsonKey(name: 'level') final  MissionLoadLevel level;
 final  List<MissionCategorySetting> _categories;
@override@JsonKey(name: 'categories') List<MissionCategorySetting> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override@JsonKey(name: 'boardTime') final  String boardTime;
@override@JsonKey(name: 'askAtNight') final  bool askAtNight;
@override@JsonKey(name: 'defaultReminder') final  MissionReminder defaultReminder;

/// Create a copy of MissionSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionSettingsCopyWith<_MissionSettings> get copyWith => __$MissionSettingsCopyWithImpl<_MissionSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionSettings&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.boardTime, boardTime) || other.boardTime == boardTime)&&(identical(other.askAtNight, askAtNight) || other.askAtNight == askAtNight)&&(identical(other.defaultReminder, defaultReminder) || other.defaultReminder == defaultReminder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,const DeepCollectionEquality().hash(_categories),boardTime,askAtNight,defaultReminder);

@override
String toString() {
  return 'MissionSettings(level: $level, categories: $categories, boardTime: $boardTime, askAtNight: $askAtNight, defaultReminder: $defaultReminder)';
}


}

/// @nodoc
abstract mixin class _$MissionSettingsCopyWith<$Res> implements $MissionSettingsCopyWith<$Res> {
  factory _$MissionSettingsCopyWith(_MissionSettings value, $Res Function(_MissionSettings) _then) = __$MissionSettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'level') MissionLoadLevel level,@JsonKey(name: 'categories') List<MissionCategorySetting> categories,@JsonKey(name: 'boardTime') String boardTime,@JsonKey(name: 'askAtNight') bool askAtNight,@JsonKey(name: 'defaultReminder') MissionReminder defaultReminder
});




}
/// @nodoc
class __$MissionSettingsCopyWithImpl<$Res>
    implements _$MissionSettingsCopyWith<$Res> {
  __$MissionSettingsCopyWithImpl(this._self, this._then);

  final _MissionSettings _self;
  final $Res Function(_MissionSettings) _then;

/// Create a copy of MissionSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? categories = null,Object? boardTime = null,Object? askAtNight = null,Object? defaultReminder = null,}) {
  return _then(_MissionSettings(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as MissionLoadLevel,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<MissionCategorySetting>,boardTime: null == boardTime ? _self.boardTime : boardTime // ignore: cast_nullable_to_non_nullable
as String,askAtNight: null == askAtNight ? _self.askAtNight : askAtNight // ignore: cast_nullable_to_non_nullable
as bool,defaultReminder: null == defaultReminder ? _self.defaultReminder : defaultReminder // ignore: cast_nullable_to_non_nullable
as MissionReminder,
  ));
}


}

// dart format on
