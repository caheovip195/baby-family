// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_settings_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionSettingsRecord {

@JsonKey(name: 'boardLevel') String? get boardLevel;@JsonKey(name: 'preferences') MissionPreferencesRecord? get preferences;
/// Create a copy of MissionSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionSettingsRecordCopyWith<MissionSettingsRecord> get copyWith => _$MissionSettingsRecordCopyWithImpl<MissionSettingsRecord>(this as MissionSettingsRecord, _$identity);

  /// Serializes this MissionSettingsRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionSettingsRecord&&(identical(other.boardLevel, boardLevel) || other.boardLevel == boardLevel)&&(identical(other.preferences, preferences) || other.preferences == preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,boardLevel,preferences);

@override
String toString() {
  return 'MissionSettingsRecord(boardLevel: $boardLevel, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class $MissionSettingsRecordCopyWith<$Res>  {
  factory $MissionSettingsRecordCopyWith(MissionSettingsRecord value, $Res Function(MissionSettingsRecord) _then) = _$MissionSettingsRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'boardLevel') String? boardLevel,@JsonKey(name: 'preferences') MissionPreferencesRecord? preferences
});


$MissionPreferencesRecordCopyWith<$Res>? get preferences;

}
/// @nodoc
class _$MissionSettingsRecordCopyWithImpl<$Res>
    implements $MissionSettingsRecordCopyWith<$Res> {
  _$MissionSettingsRecordCopyWithImpl(this._self, this._then);

  final MissionSettingsRecord _self;
  final $Res Function(MissionSettingsRecord) _then;

/// Create a copy of MissionSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? boardLevel = freezed,Object? preferences = freezed,}) {
  return _then(_self.copyWith(
boardLevel: freezed == boardLevel ? _self.boardLevel : boardLevel // ignore: cast_nullable_to_non_nullable
as String?,preferences: freezed == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as MissionPreferencesRecord?,
  ));
}
/// Create a copy of MissionSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MissionPreferencesRecordCopyWith<$Res>? get preferences {
    if (_self.preferences == null) {
    return null;
  }

  return $MissionPreferencesRecordCopyWith<$Res>(_self.preferences!, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}
}


/// Adds pattern-matching-related methods to [MissionSettingsRecord].
extension MissionSettingsRecordPatterns on MissionSettingsRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionSettingsRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionSettingsRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionSettingsRecord value)  $default,){
final _that = this;
switch (_that) {
case _MissionSettingsRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionSettingsRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MissionSettingsRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MissionSettingsRecord implements MissionSettingsRecord {
  const _MissionSettingsRecord({@JsonKey(name: 'boardLevel') this.boardLevel, @JsonKey(name: 'preferences') this.preferences});
  factory _MissionSettingsRecord.fromJson(Map<String, dynamic> json) => _$MissionSettingsRecordFromJson(json);

@override@JsonKey(name: 'boardLevel') final  String? boardLevel;
@override@JsonKey(name: 'preferences') final  MissionPreferencesRecord? preferences;

/// Create a copy of MissionSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionSettingsRecordCopyWith<_MissionSettingsRecord> get copyWith => __$MissionSettingsRecordCopyWithImpl<_MissionSettingsRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionSettingsRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionSettingsRecord&&(identical(other.boardLevel, boardLevel) || other.boardLevel == boardLevel)&&(identical(other.preferences, preferences) || other.preferences == preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,boardLevel,preferences);

@override
String toString() {
  return 'MissionSettingsRecord(boardLevel: $boardLevel, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class _$MissionSettingsRecordCopyWith<$Res> implements $MissionSettingsRecordCopyWith<$Res> {
  factory _$MissionSettingsRecordCopyWith(_MissionSettingsRecord value, $Res Function(_MissionSettingsRecord) _then) = __$MissionSettingsRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'boardLevel') String? boardLevel,@JsonKey(name: 'preferences') MissionPreferencesRecord? preferences
});


@override $MissionPreferencesRecordCopyWith<$Res>? get preferences;

}
/// @nodoc
class __$MissionSettingsRecordCopyWithImpl<$Res>
    implements _$MissionSettingsRecordCopyWith<$Res> {
  __$MissionSettingsRecordCopyWithImpl(this._self, this._then);

  final _MissionSettingsRecord _self;
  final $Res Function(_MissionSettingsRecord) _then;

/// Create a copy of MissionSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? boardLevel = freezed,Object? preferences = freezed,}) {
  return _then(_MissionSettingsRecord(
boardLevel: freezed == boardLevel ? _self.boardLevel : boardLevel // ignore: cast_nullable_to_non_nullable
as String?,preferences: freezed == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as MissionPreferencesRecord?,
  ));
}

/// Create a copy of MissionSettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MissionPreferencesRecordCopyWith<$Res>? get preferences {
    if (_self.preferences == null) {
    return null;
  }

  return $MissionPreferencesRecordCopyWith<$Res>(_self.preferences!, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}
}

// dart format on
