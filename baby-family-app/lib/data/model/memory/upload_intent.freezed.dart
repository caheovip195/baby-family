// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UploadIntent {

@JsonKey(name: 'assetId') String? get assetId;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'deduplicated') bool get deduplicated;@JsonKey(name: 'upload') UploadInstruction? get upload;
/// Create a copy of UploadIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadIntentCopyWith<UploadIntent> get copyWith => _$UploadIntentCopyWithImpl<UploadIntent>(this as UploadIntent, _$identity);

  /// Serializes this UploadIntent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadIntent&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.status, status) || other.status == status)&&(identical(other.deduplicated, deduplicated) || other.deduplicated == deduplicated)&&(identical(other.upload, upload) || other.upload == upload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,status,deduplicated,upload);

@override
String toString() {
  return 'UploadIntent(assetId: $assetId, status: $status, deduplicated: $deduplicated, upload: $upload)';
}


}

/// @nodoc
abstract mixin class $UploadIntentCopyWith<$Res>  {
  factory $UploadIntentCopyWith(UploadIntent value, $Res Function(UploadIntent) _then) = _$UploadIntentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'assetId') String? assetId,@JsonKey(name: 'status') String? status,@JsonKey(name: 'deduplicated') bool deduplicated,@JsonKey(name: 'upload') UploadInstruction? upload
});


$UploadInstructionCopyWith<$Res>? get upload;

}
/// @nodoc
class _$UploadIntentCopyWithImpl<$Res>
    implements $UploadIntentCopyWith<$Res> {
  _$UploadIntentCopyWithImpl(this._self, this._then);

  final UploadIntent _self;
  final $Res Function(UploadIntent) _then;

/// Create a copy of UploadIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetId = freezed,Object? status = freezed,Object? deduplicated = null,Object? upload = freezed,}) {
  return _then(_self.copyWith(
assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,deduplicated: null == deduplicated ? _self.deduplicated : deduplicated // ignore: cast_nullable_to_non_nullable
as bool,upload: freezed == upload ? _self.upload : upload // ignore: cast_nullable_to_non_nullable
as UploadInstruction?,
  ));
}
/// Create a copy of UploadIntent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadInstructionCopyWith<$Res>? get upload {
    if (_self.upload == null) {
    return null;
  }

  return $UploadInstructionCopyWith<$Res>(_self.upload!, (value) {
    return _then(_self.copyWith(upload: value));
  });
}
}


/// Adds pattern-matching-related methods to [UploadIntent].
extension UploadIntentPatterns on UploadIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadIntent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadIntent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadIntent value)  $default,){
final _that = this;
switch (_that) {
case _UploadIntent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadIntent value)?  $default,){
final _that = this;
switch (_that) {
case _UploadIntent() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _UploadIntent implements UploadIntent {
  const _UploadIntent({@JsonKey(name: 'assetId') this.assetId, @JsonKey(name: 'status') this.status, @JsonKey(name: 'deduplicated') this.deduplicated = false, @JsonKey(name: 'upload') this.upload});
  factory _UploadIntent.fromJson(Map<String, dynamic> json) => _$UploadIntentFromJson(json);

@override@JsonKey(name: 'assetId') final  String? assetId;
@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'deduplicated') final  bool deduplicated;
@override@JsonKey(name: 'upload') final  UploadInstruction? upload;

/// Create a copy of UploadIntent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadIntentCopyWith<_UploadIntent> get copyWith => __$UploadIntentCopyWithImpl<_UploadIntent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadIntentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadIntent&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.status, status) || other.status == status)&&(identical(other.deduplicated, deduplicated) || other.deduplicated == deduplicated)&&(identical(other.upload, upload) || other.upload == upload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,status,deduplicated,upload);

@override
String toString() {
  return 'UploadIntent(assetId: $assetId, status: $status, deduplicated: $deduplicated, upload: $upload)';
}


}

/// @nodoc
abstract mixin class _$UploadIntentCopyWith<$Res> implements $UploadIntentCopyWith<$Res> {
  factory _$UploadIntentCopyWith(_UploadIntent value, $Res Function(_UploadIntent) _then) = __$UploadIntentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'assetId') String? assetId,@JsonKey(name: 'status') String? status,@JsonKey(name: 'deduplicated') bool deduplicated,@JsonKey(name: 'upload') UploadInstruction? upload
});


@override $UploadInstructionCopyWith<$Res>? get upload;

}
/// @nodoc
class __$UploadIntentCopyWithImpl<$Res>
    implements _$UploadIntentCopyWith<$Res> {
  __$UploadIntentCopyWithImpl(this._self, this._then);

  final _UploadIntent _self;
  final $Res Function(_UploadIntent) _then;

/// Create a copy of UploadIntent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = freezed,Object? status = freezed,Object? deduplicated = null,Object? upload = freezed,}) {
  return _then(_UploadIntent(
assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,deduplicated: null == deduplicated ? _self.deduplicated : deduplicated // ignore: cast_nullable_to_non_nullable
as bool,upload: freezed == upload ? _self.upload : upload // ignore: cast_nullable_to_non_nullable
as UploadInstruction?,
  ));
}

/// Create a copy of UploadIntent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadInstructionCopyWith<$Res>? get upload {
    if (_self.upload == null) {
    return null;
  }

  return $UploadInstructionCopyWith<$Res>(_self.upload!, (value) {
    return _then(_self.copyWith(upload: value));
  });
}
}

// dart format on
