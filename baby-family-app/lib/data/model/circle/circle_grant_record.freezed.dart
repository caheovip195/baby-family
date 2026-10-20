// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circle_grant_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CircleGrantRecord {

@JsonKey(name: 'childId') String? get childId;@JsonKey(name: 'pregnancyId') String? get pregnancyId;@JsonKey(name: 'allowDownload') bool get allowDownload;@JsonKey(name: 'permission') String? get permission;
/// Create a copy of CircleGrantRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleGrantRecordCopyWith<CircleGrantRecord> get copyWith => _$CircleGrantRecordCopyWithImpl<CircleGrantRecord>(this as CircleGrantRecord, _$identity);

  /// Serializes this CircleGrantRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleGrantRecord&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.allowDownload, allowDownload) || other.allowDownload == allowDownload)&&(identical(other.permission, permission) || other.permission == permission));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,pregnancyId,allowDownload,permission);

@override
String toString() {
  return 'CircleGrantRecord(childId: $childId, pregnancyId: $pregnancyId, allowDownload: $allowDownload, permission: $permission)';
}


}

/// @nodoc
abstract mixin class $CircleGrantRecordCopyWith<$Res>  {
  factory $CircleGrantRecordCopyWith(CircleGrantRecord value, $Res Function(CircleGrantRecord) _then) = _$CircleGrantRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'pregnancyId') String? pregnancyId,@JsonKey(name: 'allowDownload') bool allowDownload,@JsonKey(name: 'permission') String? permission
});




}
/// @nodoc
class _$CircleGrantRecordCopyWithImpl<$Res>
    implements $CircleGrantRecordCopyWith<$Res> {
  _$CircleGrantRecordCopyWithImpl(this._self, this._then);

  final CircleGrantRecord _self;
  final $Res Function(CircleGrantRecord) _then;

/// Create a copy of CircleGrantRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childId = freezed,Object? pregnancyId = freezed,Object? allowDownload = null,Object? permission = freezed,}) {
  return _then(_self.copyWith(
childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,pregnancyId: freezed == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String?,allowDownload: null == allowDownload ? _self.allowDownload : allowDownload // ignore: cast_nullable_to_non_nullable
as bool,permission: freezed == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CircleGrantRecord].
extension CircleGrantRecordPatterns on CircleGrantRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircleGrantRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircleGrantRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircleGrantRecord value)  $default,){
final _that = this;
switch (_that) {
case _CircleGrantRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircleGrantRecord value)?  $default,){
final _that = this;
switch (_that) {
case _CircleGrantRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CircleGrantRecord implements CircleGrantRecord {
  const _CircleGrantRecord({@JsonKey(name: 'childId') this.childId, @JsonKey(name: 'pregnancyId') this.pregnancyId, @JsonKey(name: 'allowDownload') this.allowDownload = false, @JsonKey(name: 'permission') this.permission});
  factory _CircleGrantRecord.fromJson(Map<String, dynamic> json) => _$CircleGrantRecordFromJson(json);

@override@JsonKey(name: 'childId') final  String? childId;
@override@JsonKey(name: 'pregnancyId') final  String? pregnancyId;
@override@JsonKey(name: 'allowDownload') final  bool allowDownload;
@override@JsonKey(name: 'permission') final  String? permission;

/// Create a copy of CircleGrantRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircleGrantRecordCopyWith<_CircleGrantRecord> get copyWith => __$CircleGrantRecordCopyWithImpl<_CircleGrantRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircleGrantRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircleGrantRecord&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.allowDownload, allowDownload) || other.allowDownload == allowDownload)&&(identical(other.permission, permission) || other.permission == permission));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,pregnancyId,allowDownload,permission);

@override
String toString() {
  return 'CircleGrantRecord(childId: $childId, pregnancyId: $pregnancyId, allowDownload: $allowDownload, permission: $permission)';
}


}

/// @nodoc
abstract mixin class _$CircleGrantRecordCopyWith<$Res> implements $CircleGrantRecordCopyWith<$Res> {
  factory _$CircleGrantRecordCopyWith(_CircleGrantRecord value, $Res Function(_CircleGrantRecord) _then) = __$CircleGrantRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'pregnancyId') String? pregnancyId,@JsonKey(name: 'allowDownload') bool allowDownload,@JsonKey(name: 'permission') String? permission
});




}
/// @nodoc
class __$CircleGrantRecordCopyWithImpl<$Res>
    implements _$CircleGrantRecordCopyWith<$Res> {
  __$CircleGrantRecordCopyWithImpl(this._self, this._then);

  final _CircleGrantRecord _self;
  final $Res Function(_CircleGrantRecord) _then;

/// Create a copy of CircleGrantRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childId = freezed,Object? pregnancyId = freezed,Object? allowDownload = null,Object? permission = freezed,}) {
  return _then(_CircleGrantRecord(
childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,pregnancyId: freezed == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String?,allowDownload: null == allowDownload ? _self.allowDownload : allowDownload // ignore: cast_nullable_to_non_nullable
as bool,permission: freezed == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
