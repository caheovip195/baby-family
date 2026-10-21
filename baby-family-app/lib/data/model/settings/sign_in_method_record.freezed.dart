// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_in_method_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignInMethodRecord {

@JsonKey(name: 'provider') String? get provider;@JsonKey(name: 'linkedAt') DateTime? get linkedAt;@JsonKey(name: 'maskedHint') String? get maskedHint;
/// Create a copy of SignInMethodRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignInMethodRecordCopyWith<SignInMethodRecord> get copyWith => _$SignInMethodRecordCopyWithImpl<SignInMethodRecord>(this as SignInMethodRecord, _$identity);

  /// Serializes this SignInMethodRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignInMethodRecord&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.linkedAt, linkedAt) || other.linkedAt == linkedAt)&&(identical(other.maskedHint, maskedHint) || other.maskedHint == maskedHint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,linkedAt,maskedHint);

@override
String toString() {
  return 'SignInMethodRecord(provider: $provider, linkedAt: $linkedAt, maskedHint: $maskedHint)';
}


}

/// @nodoc
abstract mixin class $SignInMethodRecordCopyWith<$Res>  {
  factory $SignInMethodRecordCopyWith(SignInMethodRecord value, $Res Function(SignInMethodRecord) _then) = _$SignInMethodRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'provider') String? provider,@JsonKey(name: 'linkedAt') DateTime? linkedAt,@JsonKey(name: 'maskedHint') String? maskedHint
});




}
/// @nodoc
class _$SignInMethodRecordCopyWithImpl<$Res>
    implements $SignInMethodRecordCopyWith<$Res> {
  _$SignInMethodRecordCopyWithImpl(this._self, this._then);

  final SignInMethodRecord _self;
  final $Res Function(SignInMethodRecord) _then;

/// Create a copy of SignInMethodRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = freezed,Object? linkedAt = freezed,Object? maskedHint = freezed,}) {
  return _then(_self.copyWith(
provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,linkedAt: freezed == linkedAt ? _self.linkedAt : linkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,maskedHint: freezed == maskedHint ? _self.maskedHint : maskedHint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SignInMethodRecord].
extension SignInMethodRecordPatterns on SignInMethodRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignInMethodRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignInMethodRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignInMethodRecord value)  $default,){
final _that = this;
switch (_that) {
case _SignInMethodRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignInMethodRecord value)?  $default,){
final _that = this;
switch (_that) {
case _SignInMethodRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SignInMethodRecord implements SignInMethodRecord {
  const _SignInMethodRecord({@JsonKey(name: 'provider') this.provider, @JsonKey(name: 'linkedAt') this.linkedAt, @JsonKey(name: 'maskedHint') this.maskedHint});
  factory _SignInMethodRecord.fromJson(Map<String, dynamic> json) => _$SignInMethodRecordFromJson(json);

@override@JsonKey(name: 'provider') final  String? provider;
@override@JsonKey(name: 'linkedAt') final  DateTime? linkedAt;
@override@JsonKey(name: 'maskedHint') final  String? maskedHint;

/// Create a copy of SignInMethodRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignInMethodRecordCopyWith<_SignInMethodRecord> get copyWith => __$SignInMethodRecordCopyWithImpl<_SignInMethodRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignInMethodRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignInMethodRecord&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.linkedAt, linkedAt) || other.linkedAt == linkedAt)&&(identical(other.maskedHint, maskedHint) || other.maskedHint == maskedHint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,linkedAt,maskedHint);

@override
String toString() {
  return 'SignInMethodRecord(provider: $provider, linkedAt: $linkedAt, maskedHint: $maskedHint)';
}


}

/// @nodoc
abstract mixin class _$SignInMethodRecordCopyWith<$Res> implements $SignInMethodRecordCopyWith<$Res> {
  factory _$SignInMethodRecordCopyWith(_SignInMethodRecord value, $Res Function(_SignInMethodRecord) _then) = __$SignInMethodRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'provider') String? provider,@JsonKey(name: 'linkedAt') DateTime? linkedAt,@JsonKey(name: 'maskedHint') String? maskedHint
});




}
/// @nodoc
class __$SignInMethodRecordCopyWithImpl<$Res>
    implements _$SignInMethodRecordCopyWith<$Res> {
  __$SignInMethodRecordCopyWithImpl(this._self, this._then);

  final _SignInMethodRecord _self;
  final $Res Function(_SignInMethodRecord) _then;

/// Create a copy of SignInMethodRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = freezed,Object? linkedAt = freezed,Object? maskedHint = freezed,}) {
  return _then(_SignInMethodRecord(
provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,linkedAt: freezed == linkedAt ? _self.linkedAt : linkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,maskedHint: freezed == maskedHint ? _self.maskedHint : maskedHint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
