// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UploadStatus {

@JsonKey(name: 'assetId') String? get assetId;@JsonKey(name: 'status') String? get status;
/// Create a copy of UploadStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadStatusCopyWith<UploadStatus> get copyWith => _$UploadStatusCopyWithImpl<UploadStatus>(this as UploadStatus, _$identity);

  /// Serializes this UploadStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadStatus&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,status);

@override
String toString() {
  return 'UploadStatus(assetId: $assetId, status: $status)';
}


}

/// @nodoc
abstract mixin class $UploadStatusCopyWith<$Res>  {
  factory $UploadStatusCopyWith(UploadStatus value, $Res Function(UploadStatus) _then) = _$UploadStatusCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'assetId') String? assetId,@JsonKey(name: 'status') String? status
});




}
/// @nodoc
class _$UploadStatusCopyWithImpl<$Res>
    implements $UploadStatusCopyWith<$Res> {
  _$UploadStatusCopyWithImpl(this._self, this._then);

  final UploadStatus _self;
  final $Res Function(UploadStatus) _then;

/// Create a copy of UploadStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetId = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadStatus].
extension UploadStatusPatterns on UploadStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadStatus value)  $default,){
final _that = this;
switch (_that) {
case _UploadStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadStatus value)?  $default,){
final _that = this;
switch (_that) {
case _UploadStatus() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _UploadStatus implements UploadStatus {
  const _UploadStatus({@JsonKey(name: 'assetId') this.assetId, @JsonKey(name: 'status') this.status});
  factory _UploadStatus.fromJson(Map<String, dynamic> json) => _$UploadStatusFromJson(json);

@override@JsonKey(name: 'assetId') final  String? assetId;
@override@JsonKey(name: 'status') final  String? status;

/// Create a copy of UploadStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadStatusCopyWith<_UploadStatus> get copyWith => __$UploadStatusCopyWithImpl<_UploadStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadStatus&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,status);

@override
String toString() {
  return 'UploadStatus(assetId: $assetId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UploadStatusCopyWith<$Res> implements $UploadStatusCopyWith<$Res> {
  factory _$UploadStatusCopyWith(_UploadStatus value, $Res Function(_UploadStatus) _then) = __$UploadStatusCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'assetId') String? assetId,@JsonKey(name: 'status') String? status
});




}
/// @nodoc
class __$UploadStatusCopyWithImpl<$Res>
    implements _$UploadStatusCopyWith<$Res> {
  __$UploadStatusCopyWithImpl(this._self, this._then);

  final _UploadStatus _self;
  final $Res Function(_UploadStatus) _then;

/// Create a copy of UploadStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = freezed,Object? status = freezed,}) {
  return _then(_UploadStatus(
assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
