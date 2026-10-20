// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'us_settings_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsSettingsRecord {

@JsonKey(name: 'usLockEnabled') bool? get usLockEnabled;@JsonKey(name: 'moodShareDefault') String? get moodShareDefault;@JsonKey(name: 'requestSoonBypassQuiet') bool? get requestSoonBypassQuiet;@JsonKey(name: 'hideSensitivePreview') bool? get hideSensitivePreview;
/// Create a copy of UsSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsSettingsRecordCopyWith<UsSettingsRecord> get copyWith => _$UsSettingsRecordCopyWithImpl<UsSettingsRecord>(this as UsSettingsRecord, _$identity);

  /// Serializes this UsSettingsRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsSettingsRecord&&(identical(other.usLockEnabled, usLockEnabled) || other.usLockEnabled == usLockEnabled)&&(identical(other.moodShareDefault, moodShareDefault) || other.moodShareDefault == moodShareDefault)&&(identical(other.requestSoonBypassQuiet, requestSoonBypassQuiet) || other.requestSoonBypassQuiet == requestSoonBypassQuiet)&&(identical(other.hideSensitivePreview, hideSensitivePreview) || other.hideSensitivePreview == hideSensitivePreview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,usLockEnabled,moodShareDefault,requestSoonBypassQuiet,hideSensitivePreview);

@override
String toString() {
  return 'UsSettingsRecord(usLockEnabled: $usLockEnabled, moodShareDefault: $moodShareDefault, requestSoonBypassQuiet: $requestSoonBypassQuiet, hideSensitivePreview: $hideSensitivePreview)';
}


}

/// @nodoc
abstract mixin class $UsSettingsRecordCopyWith<$Res>  {
  factory $UsSettingsRecordCopyWith(UsSettingsRecord value, $Res Function(UsSettingsRecord) _then) = _$UsSettingsRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'usLockEnabled') bool? usLockEnabled,@JsonKey(name: 'moodShareDefault') String? moodShareDefault,@JsonKey(name: 'requestSoonBypassQuiet') bool? requestSoonBypassQuiet,@JsonKey(name: 'hideSensitivePreview') bool? hideSensitivePreview
});




}
/// @nodoc
class _$UsSettingsRecordCopyWithImpl<$Res>
    implements $UsSettingsRecordCopyWith<$Res> {
  _$UsSettingsRecordCopyWithImpl(this._self, this._then);

  final UsSettingsRecord _self;
  final $Res Function(UsSettingsRecord) _then;

/// Create a copy of UsSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? usLockEnabled = freezed,Object? moodShareDefault = freezed,Object? requestSoonBypassQuiet = freezed,Object? hideSensitivePreview = freezed,}) {
  return _then(_self.copyWith(
usLockEnabled: freezed == usLockEnabled ? _self.usLockEnabled : usLockEnabled // ignore: cast_nullable_to_non_nullable
as bool?,moodShareDefault: freezed == moodShareDefault ? _self.moodShareDefault : moodShareDefault // ignore: cast_nullable_to_non_nullable
as String?,requestSoonBypassQuiet: freezed == requestSoonBypassQuiet ? _self.requestSoonBypassQuiet : requestSoonBypassQuiet // ignore: cast_nullable_to_non_nullable
as bool?,hideSensitivePreview: freezed == hideSensitivePreview ? _self.hideSensitivePreview : hideSensitivePreview // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UsSettingsRecord].
extension UsSettingsRecordPatterns on UsSettingsRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsSettingsRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsSettingsRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsSettingsRecord value)  $default,){
final _that = this;
switch (_that) {
case _UsSettingsRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsSettingsRecord value)?  $default,){
final _that = this;
switch (_that) {
case _UsSettingsRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _UsSettingsRecord implements UsSettingsRecord {
  const _UsSettingsRecord({@JsonKey(name: 'usLockEnabled') this.usLockEnabled, @JsonKey(name: 'moodShareDefault') this.moodShareDefault, @JsonKey(name: 'requestSoonBypassQuiet') this.requestSoonBypassQuiet, @JsonKey(name: 'hideSensitivePreview') this.hideSensitivePreview});
  factory _UsSettingsRecord.fromJson(Map<String, dynamic> json) => _$UsSettingsRecordFromJson(json);

@override@JsonKey(name: 'usLockEnabled') final  bool? usLockEnabled;
@override@JsonKey(name: 'moodShareDefault') final  String? moodShareDefault;
@override@JsonKey(name: 'requestSoonBypassQuiet') final  bool? requestSoonBypassQuiet;
@override@JsonKey(name: 'hideSensitivePreview') final  bool? hideSensitivePreview;

/// Create a copy of UsSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsSettingsRecordCopyWith<_UsSettingsRecord> get copyWith => __$UsSettingsRecordCopyWithImpl<_UsSettingsRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsSettingsRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsSettingsRecord&&(identical(other.usLockEnabled, usLockEnabled) || other.usLockEnabled == usLockEnabled)&&(identical(other.moodShareDefault, moodShareDefault) || other.moodShareDefault == moodShareDefault)&&(identical(other.requestSoonBypassQuiet, requestSoonBypassQuiet) || other.requestSoonBypassQuiet == requestSoonBypassQuiet)&&(identical(other.hideSensitivePreview, hideSensitivePreview) || other.hideSensitivePreview == hideSensitivePreview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,usLockEnabled,moodShareDefault,requestSoonBypassQuiet,hideSensitivePreview);

@override
String toString() {
  return 'UsSettingsRecord(usLockEnabled: $usLockEnabled, moodShareDefault: $moodShareDefault, requestSoonBypassQuiet: $requestSoonBypassQuiet, hideSensitivePreview: $hideSensitivePreview)';
}


}

/// @nodoc
abstract mixin class _$UsSettingsRecordCopyWith<$Res> implements $UsSettingsRecordCopyWith<$Res> {
  factory _$UsSettingsRecordCopyWith(_UsSettingsRecord value, $Res Function(_UsSettingsRecord) _then) = __$UsSettingsRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'usLockEnabled') bool? usLockEnabled,@JsonKey(name: 'moodShareDefault') String? moodShareDefault,@JsonKey(name: 'requestSoonBypassQuiet') bool? requestSoonBypassQuiet,@JsonKey(name: 'hideSensitivePreview') bool? hideSensitivePreview
});




}
/// @nodoc
class __$UsSettingsRecordCopyWithImpl<$Res>
    implements _$UsSettingsRecordCopyWith<$Res> {
  __$UsSettingsRecordCopyWithImpl(this._self, this._then);

  final _UsSettingsRecord _self;
  final $Res Function(_UsSettingsRecord) _then;

/// Create a copy of UsSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? usLockEnabled = freezed,Object? moodShareDefault = freezed,Object? requestSoonBypassQuiet = freezed,Object? hideSensitivePreview = freezed,}) {
  return _then(_UsSettingsRecord(
usLockEnabled: freezed == usLockEnabled ? _self.usLockEnabled : usLockEnabled // ignore: cast_nullable_to_non_nullable
as bool?,moodShareDefault: freezed == moodShareDefault ? _self.moodShareDefault : moodShareDefault // ignore: cast_nullable_to_non_nullable
as String?,requestSoonBypassQuiet: freezed == requestSoonBypassQuiet ? _self.requestSoonBypassQuiet : requestSoonBypassQuiet // ignore: cast_nullable_to_non_nullable
as bool?,hideSensitivePreview: freezed == hideSensitivePreview ? _self.hideSensitivePreview : hideSensitivePreview // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
