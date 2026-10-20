// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'platform') String? get platform;@JsonKey(name: 'appVersion') String? get appVersion;@JsonKey(name: 'deviceModel') String? get deviceModel;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'lastUsedAt') DateTime? get lastUsedAt;@JsonKey(name: 'current') bool get current;
/// Create a copy of SessionRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionRecordCopyWith<SessionRecord> get copyWith => _$SessionRecordCopyWithImpl<SessionRecord>(this as SessionRecord, _$identity);

  /// Serializes this SessionRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.deviceModel, deviceModel) || other.deviceModel == deviceModel)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastUsedAt, lastUsedAt) || other.lastUsedAt == lastUsedAt)&&(identical(other.current, current) || other.current == current));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,platform,appVersion,deviceModel,createdAt,lastUsedAt,current);

@override
String toString() {
  return 'SessionRecord(id: $id, platform: $platform, appVersion: $appVersion, deviceModel: $deviceModel, createdAt: $createdAt, lastUsedAt: $lastUsedAt, current: $current)';
}


}

/// @nodoc
abstract mixin class $SessionRecordCopyWith<$Res>  {
  factory $SessionRecordCopyWith(SessionRecord value, $Res Function(SessionRecord) _then) = _$SessionRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'platform') String? platform,@JsonKey(name: 'appVersion') String? appVersion,@JsonKey(name: 'deviceModel') String? deviceModel,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'lastUsedAt') DateTime? lastUsedAt,@JsonKey(name: 'current') bool current
});




}
/// @nodoc
class _$SessionRecordCopyWithImpl<$Res>
    implements $SessionRecordCopyWith<$Res> {
  _$SessionRecordCopyWithImpl(this._self, this._then);

  final SessionRecord _self;
  final $Res Function(SessionRecord) _then;

/// Create a copy of SessionRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? platform = freezed,Object? appVersion = freezed,Object? deviceModel = freezed,Object? createdAt = freezed,Object? lastUsedAt = freezed,Object? current = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,deviceModel: freezed == deviceModel ? _self.deviceModel : deviceModel // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastUsedAt: freezed == lastUsedAt ? _self.lastUsedAt : lastUsedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionRecord].
extension SessionRecordPatterns on SessionRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionRecord value)  $default,){
final _that = this;
switch (_that) {
case _SessionRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionRecord value)?  $default,){
final _that = this;
switch (_that) {
case _SessionRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SessionRecord implements SessionRecord {
  const _SessionRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'platform') this.platform, @JsonKey(name: 'appVersion') this.appVersion, @JsonKey(name: 'deviceModel') this.deviceModel, @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'lastUsedAt') this.lastUsedAt, @JsonKey(name: 'current') this.current = false});
  factory _SessionRecord.fromJson(Map<String, dynamic> json) => _$SessionRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'platform') final  String? platform;
@override@JsonKey(name: 'appVersion') final  String? appVersion;
@override@JsonKey(name: 'deviceModel') final  String? deviceModel;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
@override@JsonKey(name: 'lastUsedAt') final  DateTime? lastUsedAt;
@override@JsonKey(name: 'current') final  bool current;

/// Create a copy of SessionRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionRecordCopyWith<_SessionRecord> get copyWith => __$SessionRecordCopyWithImpl<_SessionRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.deviceModel, deviceModel) || other.deviceModel == deviceModel)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastUsedAt, lastUsedAt) || other.lastUsedAt == lastUsedAt)&&(identical(other.current, current) || other.current == current));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,platform,appVersion,deviceModel,createdAt,lastUsedAt,current);

@override
String toString() {
  return 'SessionRecord(id: $id, platform: $platform, appVersion: $appVersion, deviceModel: $deviceModel, createdAt: $createdAt, lastUsedAt: $lastUsedAt, current: $current)';
}


}

/// @nodoc
abstract mixin class _$SessionRecordCopyWith<$Res> implements $SessionRecordCopyWith<$Res> {
  factory _$SessionRecordCopyWith(_SessionRecord value, $Res Function(_SessionRecord) _then) = __$SessionRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'platform') String? platform,@JsonKey(name: 'appVersion') String? appVersion,@JsonKey(name: 'deviceModel') String? deviceModel,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'lastUsedAt') DateTime? lastUsedAt,@JsonKey(name: 'current') bool current
});




}
/// @nodoc
class __$SessionRecordCopyWithImpl<$Res>
    implements _$SessionRecordCopyWith<$Res> {
  __$SessionRecordCopyWithImpl(this._self, this._then);

  final _SessionRecord _self;
  final $Res Function(_SessionRecord) _then;

/// Create a copy of SessionRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? platform = freezed,Object? appVersion = freezed,Object? deviceModel = freezed,Object? createdAt = freezed,Object? lastUsedAt = freezed,Object? current = null,}) {
  return _then(_SessionRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,deviceModel: freezed == deviceModel ? _self.deviceModel : deviceModel // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastUsedAt: freezed == lastUsedAt ? _self.lastUsedAt : lastUsedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
