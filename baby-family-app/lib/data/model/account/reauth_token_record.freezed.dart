// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reauth_token_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReauthTokenRecord {

@JsonKey(name: 'reauthToken') String? get reauthToken;@JsonKey(name: 'expiresAt') DateTime? get expiresAt;
/// Create a copy of ReauthTokenRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReauthTokenRecordCopyWith<ReauthTokenRecord> get copyWith => _$ReauthTokenRecordCopyWithImpl<ReauthTokenRecord>(this as ReauthTokenRecord, _$identity);

  /// Serializes this ReauthTokenRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReauthTokenRecord&&(identical(other.reauthToken, reauthToken) || other.reauthToken == reauthToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reauthToken,expiresAt);

@override
String toString() {
  return 'ReauthTokenRecord(reauthToken: $reauthToken, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $ReauthTokenRecordCopyWith<$Res>  {
  factory $ReauthTokenRecordCopyWith(ReauthTokenRecord value, $Res Function(ReauthTokenRecord) _then) = _$ReauthTokenRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'reauthToken') String? reauthToken,@JsonKey(name: 'expiresAt') DateTime? expiresAt
});




}
/// @nodoc
class _$ReauthTokenRecordCopyWithImpl<$Res>
    implements $ReauthTokenRecordCopyWith<$Res> {
  _$ReauthTokenRecordCopyWithImpl(this._self, this._then);

  final ReauthTokenRecord _self;
  final $Res Function(ReauthTokenRecord) _then;

/// Create a copy of ReauthTokenRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reauthToken = freezed,Object? expiresAt = freezed,}) {
  return _then(_self.copyWith(
reauthToken: freezed == reauthToken ? _self.reauthToken : reauthToken // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReauthTokenRecord].
extension ReauthTokenRecordPatterns on ReauthTokenRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReauthTokenRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReauthTokenRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReauthTokenRecord value)  $default,){
final _that = this;
switch (_that) {
case _ReauthTokenRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReauthTokenRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ReauthTokenRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ReauthTokenRecord implements ReauthTokenRecord {
  const _ReauthTokenRecord({@JsonKey(name: 'reauthToken') this.reauthToken, @JsonKey(name: 'expiresAt') this.expiresAt});
  factory _ReauthTokenRecord.fromJson(Map<String, dynamic> json) => _$ReauthTokenRecordFromJson(json);

@override@JsonKey(name: 'reauthToken') final  String? reauthToken;
@override@JsonKey(name: 'expiresAt') final  DateTime? expiresAt;

/// Create a copy of ReauthTokenRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReauthTokenRecordCopyWith<_ReauthTokenRecord> get copyWith => __$ReauthTokenRecordCopyWithImpl<_ReauthTokenRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReauthTokenRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReauthTokenRecord&&(identical(other.reauthToken, reauthToken) || other.reauthToken == reauthToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reauthToken,expiresAt);

@override
String toString() {
  return 'ReauthTokenRecord(reauthToken: $reauthToken, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$ReauthTokenRecordCopyWith<$Res> implements $ReauthTokenRecordCopyWith<$Res> {
  factory _$ReauthTokenRecordCopyWith(_ReauthTokenRecord value, $Res Function(_ReauthTokenRecord) _then) = __$ReauthTokenRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'reauthToken') String? reauthToken,@JsonKey(name: 'expiresAt') DateTime? expiresAt
});




}
/// @nodoc
class __$ReauthTokenRecordCopyWithImpl<$Res>
    implements _$ReauthTokenRecordCopyWith<$Res> {
  __$ReauthTokenRecordCopyWithImpl(this._self, this._then);

  final _ReauthTokenRecord _self;
  final $Res Function(_ReauthTokenRecord) _then;

/// Create a copy of ReauthTokenRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reauthToken = freezed,Object? expiresAt = freezed,}) {
  return _then(_ReauthTokenRecord(
reauthToken: freezed == reauthToken ? _self.reauthToken : reauthToken // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
