// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_instruction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UploadInstruction {

@JsonKey(name: 'mode') String? get mode;@JsonKey(name: 'method') String? get method;@JsonKey(name: 'url') String? get url;@JsonKey(name: 'headers') Map<String, String> get headers;@JsonKey(name: 'partSize') int? get partSize;@JsonKey(name: 'partCount') int? get partCount;@JsonKey(name: 'parts') List<UploadPartUrl> get parts;@JsonKey(name: 'expiresAt') DateTime? get expiresAt;
/// Create a copy of UploadInstruction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadInstructionCopyWith<UploadInstruction> get copyWith => _$UploadInstructionCopyWithImpl<UploadInstruction>(this as UploadInstruction, _$identity);

  /// Serializes this UploadInstruction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadInstruction&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.method, method) || other.method == method)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other.headers, headers)&&(identical(other.partSize, partSize) || other.partSize == partSize)&&(identical(other.partCount, partCount) || other.partCount == partCount)&&const DeepCollectionEquality().equals(other.parts, parts)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,method,url,const DeepCollectionEquality().hash(headers),partSize,partCount,const DeepCollectionEquality().hash(parts),expiresAt);

@override
String toString() {
  return 'UploadInstruction(mode: $mode, method: $method, url: $url, headers: $headers, partSize: $partSize, partCount: $partCount, parts: $parts, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $UploadInstructionCopyWith<$Res>  {
  factory $UploadInstructionCopyWith(UploadInstruction value, $Res Function(UploadInstruction) _then) = _$UploadInstructionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'mode') String? mode,@JsonKey(name: 'method') String? method,@JsonKey(name: 'url') String? url,@JsonKey(name: 'headers') Map<String, String> headers,@JsonKey(name: 'partSize') int? partSize,@JsonKey(name: 'partCount') int? partCount,@JsonKey(name: 'parts') List<UploadPartUrl> parts,@JsonKey(name: 'expiresAt') DateTime? expiresAt
});




}
/// @nodoc
class _$UploadInstructionCopyWithImpl<$Res>
    implements $UploadInstructionCopyWith<$Res> {
  _$UploadInstructionCopyWithImpl(this._self, this._then);

  final UploadInstruction _self;
  final $Res Function(UploadInstruction) _then;

/// Create a copy of UploadInstruction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = freezed,Object? method = freezed,Object? url = freezed,Object? headers = null,Object? partSize = freezed,Object? partCount = freezed,Object? parts = null,Object? expiresAt = freezed,}) {
  return _then(_self.copyWith(
mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,headers: null == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,partSize: freezed == partSize ? _self.partSize : partSize // ignore: cast_nullable_to_non_nullable
as int?,partCount: freezed == partCount ? _self.partCount : partCount // ignore: cast_nullable_to_non_nullable
as int?,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<UploadPartUrl>,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadInstruction].
extension UploadInstructionPatterns on UploadInstruction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadInstruction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadInstruction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadInstruction value)  $default,){
final _that = this;
switch (_that) {
case _UploadInstruction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadInstruction value)?  $default,){
final _that = this;
switch (_that) {
case _UploadInstruction() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _UploadInstruction implements UploadInstruction {
  const _UploadInstruction({@JsonKey(name: 'mode') this.mode, @JsonKey(name: 'method') this.method, @JsonKey(name: 'url') this.url, @JsonKey(name: 'headers') final  Map<String, String> headers = const <String, String>{}, @JsonKey(name: 'partSize') this.partSize, @JsonKey(name: 'partCount') this.partCount, @JsonKey(name: 'parts') final  List<UploadPartUrl> parts = const <UploadPartUrl>[], @JsonKey(name: 'expiresAt') this.expiresAt}): _headers = headers,_parts = parts;
  factory _UploadInstruction.fromJson(Map<String, dynamic> json) => _$UploadInstructionFromJson(json);

@override@JsonKey(name: 'mode') final  String? mode;
@override@JsonKey(name: 'method') final  String? method;
@override@JsonKey(name: 'url') final  String? url;
 final  Map<String, String> _headers;
@override@JsonKey(name: 'headers') Map<String, String> get headers {
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_headers);
}

@override@JsonKey(name: 'partSize') final  int? partSize;
@override@JsonKey(name: 'partCount') final  int? partCount;
 final  List<UploadPartUrl> _parts;
@override@JsonKey(name: 'parts') List<UploadPartUrl> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}

@override@JsonKey(name: 'expiresAt') final  DateTime? expiresAt;

/// Create a copy of UploadInstruction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadInstructionCopyWith<_UploadInstruction> get copyWith => __$UploadInstructionCopyWithImpl<_UploadInstruction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadInstructionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadInstruction&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.method, method) || other.method == method)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other._headers, _headers)&&(identical(other.partSize, partSize) || other.partSize == partSize)&&(identical(other.partCount, partCount) || other.partCount == partCount)&&const DeepCollectionEquality().equals(other._parts, _parts)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,method,url,const DeepCollectionEquality().hash(_headers),partSize,partCount,const DeepCollectionEquality().hash(_parts),expiresAt);

@override
String toString() {
  return 'UploadInstruction(mode: $mode, method: $method, url: $url, headers: $headers, partSize: $partSize, partCount: $partCount, parts: $parts, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$UploadInstructionCopyWith<$Res> implements $UploadInstructionCopyWith<$Res> {
  factory _$UploadInstructionCopyWith(_UploadInstruction value, $Res Function(_UploadInstruction) _then) = __$UploadInstructionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'mode') String? mode,@JsonKey(name: 'method') String? method,@JsonKey(name: 'url') String? url,@JsonKey(name: 'headers') Map<String, String> headers,@JsonKey(name: 'partSize') int? partSize,@JsonKey(name: 'partCount') int? partCount,@JsonKey(name: 'parts') List<UploadPartUrl> parts,@JsonKey(name: 'expiresAt') DateTime? expiresAt
});




}
/// @nodoc
class __$UploadInstructionCopyWithImpl<$Res>
    implements _$UploadInstructionCopyWith<$Res> {
  __$UploadInstructionCopyWithImpl(this._self, this._then);

  final _UploadInstruction _self;
  final $Res Function(_UploadInstruction) _then;

/// Create a copy of UploadInstruction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = freezed,Object? method = freezed,Object? url = freezed,Object? headers = null,Object? partSize = freezed,Object? partCount = freezed,Object? parts = null,Object? expiresAt = freezed,}) {
  return _then(_UploadInstruction(
mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,headers: null == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,partSize: freezed == partSize ? _self.partSize : partSize // ignore: cast_nullable_to_non_nullable
as int?,partCount: freezed == partCount ? _self.partCount : partCount // ignore: cast_nullable_to_non_nullable
as int?,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<UploadPartUrl>,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
