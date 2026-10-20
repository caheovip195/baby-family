// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'display_settings_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DisplaySettingsRecord {

@JsonKey(name: 'theme') String? get theme;@JsonKey(name: 'textScale') double? get textScale;@JsonKey(name: 'showLunar') bool? get showLunar;
/// Create a copy of DisplaySettingsRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DisplaySettingsRecordCopyWith<DisplaySettingsRecord> get copyWith => _$DisplaySettingsRecordCopyWithImpl<DisplaySettingsRecord>(this as DisplaySettingsRecord, _$identity);

  /// Serializes this DisplaySettingsRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisplaySettingsRecord&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.textScale, textScale) || other.textScale == textScale)&&(identical(other.showLunar, showLunar) || other.showLunar == showLunar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,theme,textScale,showLunar);

@override
String toString() {
  return 'DisplaySettingsRecord(theme: $theme, textScale: $textScale, showLunar: $showLunar)';
}


}

/// @nodoc
abstract mixin class $DisplaySettingsRecordCopyWith<$Res>  {
  factory $DisplaySettingsRecordCopyWith(DisplaySettingsRecord value, $Res Function(DisplaySettingsRecord) _then) = _$DisplaySettingsRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'theme') String? theme,@JsonKey(name: 'textScale') double? textScale,@JsonKey(name: 'showLunar') bool? showLunar
});




}
/// @nodoc
class _$DisplaySettingsRecordCopyWithImpl<$Res>
    implements $DisplaySettingsRecordCopyWith<$Res> {
  _$DisplaySettingsRecordCopyWithImpl(this._self, this._then);

  final DisplaySettingsRecord _self;
  final $Res Function(DisplaySettingsRecord) _then;

/// Create a copy of DisplaySettingsRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? theme = freezed,Object? textScale = freezed,Object? showLunar = freezed,}) {
  return _then(_self.copyWith(
theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String?,textScale: freezed == textScale ? _self.textScale : textScale // ignore: cast_nullable_to_non_nullable
as double?,showLunar: freezed == showLunar ? _self.showLunar : showLunar // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [DisplaySettingsRecord].
extension DisplaySettingsRecordPatterns on DisplaySettingsRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DisplaySettingsRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DisplaySettingsRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DisplaySettingsRecord value)  $default,){
final _that = this;
switch (_that) {
case _DisplaySettingsRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DisplaySettingsRecord value)?  $default,){
final _that = this;
switch (_that) {
case _DisplaySettingsRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DisplaySettingsRecord implements DisplaySettingsRecord {
  const _DisplaySettingsRecord({@JsonKey(name: 'theme') this.theme, @JsonKey(name: 'textScale') this.textScale, @JsonKey(name: 'showLunar') this.showLunar});
  factory _DisplaySettingsRecord.fromJson(Map<String, dynamic> json) => _$DisplaySettingsRecordFromJson(json);

@override@JsonKey(name: 'theme') final  String? theme;
@override@JsonKey(name: 'textScale') final  double? textScale;
@override@JsonKey(name: 'showLunar') final  bool? showLunar;

/// Create a copy of DisplaySettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DisplaySettingsRecordCopyWith<_DisplaySettingsRecord> get copyWith => __$DisplaySettingsRecordCopyWithImpl<_DisplaySettingsRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DisplaySettingsRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DisplaySettingsRecord&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.textScale, textScale) || other.textScale == textScale)&&(identical(other.showLunar, showLunar) || other.showLunar == showLunar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,theme,textScale,showLunar);

@override
String toString() {
  return 'DisplaySettingsRecord(theme: $theme, textScale: $textScale, showLunar: $showLunar)';
}


}

/// @nodoc
abstract mixin class _$DisplaySettingsRecordCopyWith<$Res> implements $DisplaySettingsRecordCopyWith<$Res> {
  factory _$DisplaySettingsRecordCopyWith(_DisplaySettingsRecord value, $Res Function(_DisplaySettingsRecord) _then) = __$DisplaySettingsRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'theme') String? theme,@JsonKey(name: 'textScale') double? textScale,@JsonKey(name: 'showLunar') bool? showLunar
});




}
/// @nodoc
class __$DisplaySettingsRecordCopyWithImpl<$Res>
    implements _$DisplaySettingsRecordCopyWith<$Res> {
  __$DisplaySettingsRecordCopyWithImpl(this._self, this._then);

  final _DisplaySettingsRecord _self;
  final $Res Function(_DisplaySettingsRecord) _then;

/// Create a copy of DisplaySettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? theme = freezed,Object? textScale = freezed,Object? showLunar = freezed,}) {
  return _then(_DisplaySettingsRecord(
theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String?,textScale: freezed == textScale ? _self.textScale : textScale // ignore: cast_nullable_to_non_nullable
as double?,showLunar: freezed == showLunar ? _self.showLunar : showLunar // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
