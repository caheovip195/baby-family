// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_asset_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaAssetRecord {

@JsonKey(name: 'assetId') String? get assetId;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'width') int? get width;@JsonKey(name: 'height') int? get height;@JsonKey(name: 'durationMs') int? get durationMs;@JsonKey(name: 'blurhash') String? get blurhash;@JsonKey(name: 'urls') Map<String, String> get urls;@JsonKey(name: 'urlsExpireAt') DateTime? get urlsExpireAt;
/// Create a copy of MediaAssetRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaAssetRecordCopyWith<MediaAssetRecord> get copyWith => _$MediaAssetRecordCopyWithImpl<MediaAssetRecord>(this as MediaAssetRecord, _$identity);

  /// Serializes this MediaAssetRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaAssetRecord&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.blurhash, blurhash) || other.blurhash == blurhash)&&const DeepCollectionEquality().equals(other.urls, urls)&&(identical(other.urlsExpireAt, urlsExpireAt) || other.urlsExpireAt == urlsExpireAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,kind,status,width,height,durationMs,blurhash,const DeepCollectionEquality().hash(urls),urlsExpireAt);

@override
String toString() {
  return 'MediaAssetRecord(assetId: $assetId, kind: $kind, status: $status, width: $width, height: $height, durationMs: $durationMs, blurhash: $blurhash, urls: $urls, urlsExpireAt: $urlsExpireAt)';
}


}

/// @nodoc
abstract mixin class $MediaAssetRecordCopyWith<$Res>  {
  factory $MediaAssetRecordCopyWith(MediaAssetRecord value, $Res Function(MediaAssetRecord) _then) = _$MediaAssetRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'assetId') String? assetId,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'status') String? status,@JsonKey(name: 'width') int? width,@JsonKey(name: 'height') int? height,@JsonKey(name: 'durationMs') int? durationMs,@JsonKey(name: 'blurhash') String? blurhash,@JsonKey(name: 'urls') Map<String, String> urls,@JsonKey(name: 'urlsExpireAt') DateTime? urlsExpireAt
});




}
/// @nodoc
class _$MediaAssetRecordCopyWithImpl<$Res>
    implements $MediaAssetRecordCopyWith<$Res> {
  _$MediaAssetRecordCopyWithImpl(this._self, this._then);

  final MediaAssetRecord _self;
  final $Res Function(MediaAssetRecord) _then;

/// Create a copy of MediaAssetRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetId = freezed,Object? kind = freezed,Object? status = freezed,Object? width = freezed,Object? height = freezed,Object? durationMs = freezed,Object? blurhash = freezed,Object? urls = null,Object? urlsExpireAt = freezed,}) {
  return _then(_self.copyWith(
assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,blurhash: freezed == blurhash ? _self.blurhash : blurhash // ignore: cast_nullable_to_non_nullable
as String?,urls: null == urls ? _self.urls : urls // ignore: cast_nullable_to_non_nullable
as Map<String, String>,urlsExpireAt: freezed == urlsExpireAt ? _self.urlsExpireAt : urlsExpireAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaAssetRecord].
extension MediaAssetRecordPatterns on MediaAssetRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaAssetRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaAssetRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaAssetRecord value)  $default,){
final _that = this;
switch (_that) {
case _MediaAssetRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaAssetRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MediaAssetRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MediaAssetRecord implements MediaAssetRecord {
  const _MediaAssetRecord({@JsonKey(name: 'assetId') this.assetId, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'status') this.status, @JsonKey(name: 'width') this.width, @JsonKey(name: 'height') this.height, @JsonKey(name: 'durationMs') this.durationMs, @JsonKey(name: 'blurhash') this.blurhash, @JsonKey(name: 'urls') final  Map<String, String> urls = const <String, String>{}, @JsonKey(name: 'urlsExpireAt') this.urlsExpireAt}): _urls = urls;
  factory _MediaAssetRecord.fromJson(Map<String, dynamic> json) => _$MediaAssetRecordFromJson(json);

@override@JsonKey(name: 'assetId') final  String? assetId;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'width') final  int? width;
@override@JsonKey(name: 'height') final  int? height;
@override@JsonKey(name: 'durationMs') final  int? durationMs;
@override@JsonKey(name: 'blurhash') final  String? blurhash;
 final  Map<String, String> _urls;
@override@JsonKey(name: 'urls') Map<String, String> get urls {
  if (_urls is EqualUnmodifiableMapView) return _urls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_urls);
}

@override@JsonKey(name: 'urlsExpireAt') final  DateTime? urlsExpireAt;

/// Create a copy of MediaAssetRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaAssetRecordCopyWith<_MediaAssetRecord> get copyWith => __$MediaAssetRecordCopyWithImpl<_MediaAssetRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaAssetRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaAssetRecord&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.blurhash, blurhash) || other.blurhash == blurhash)&&const DeepCollectionEquality().equals(other._urls, _urls)&&(identical(other.urlsExpireAt, urlsExpireAt) || other.urlsExpireAt == urlsExpireAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,kind,status,width,height,durationMs,blurhash,const DeepCollectionEquality().hash(_urls),urlsExpireAt);

@override
String toString() {
  return 'MediaAssetRecord(assetId: $assetId, kind: $kind, status: $status, width: $width, height: $height, durationMs: $durationMs, blurhash: $blurhash, urls: $urls, urlsExpireAt: $urlsExpireAt)';
}


}

/// @nodoc
abstract mixin class _$MediaAssetRecordCopyWith<$Res> implements $MediaAssetRecordCopyWith<$Res> {
  factory _$MediaAssetRecordCopyWith(_MediaAssetRecord value, $Res Function(_MediaAssetRecord) _then) = __$MediaAssetRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'assetId') String? assetId,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'status') String? status,@JsonKey(name: 'width') int? width,@JsonKey(name: 'height') int? height,@JsonKey(name: 'durationMs') int? durationMs,@JsonKey(name: 'blurhash') String? blurhash,@JsonKey(name: 'urls') Map<String, String> urls,@JsonKey(name: 'urlsExpireAt') DateTime? urlsExpireAt
});




}
/// @nodoc
class __$MediaAssetRecordCopyWithImpl<$Res>
    implements _$MediaAssetRecordCopyWith<$Res> {
  __$MediaAssetRecordCopyWithImpl(this._self, this._then);

  final _MediaAssetRecord _self;
  final $Res Function(_MediaAssetRecord) _then;

/// Create a copy of MediaAssetRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = freezed,Object? kind = freezed,Object? status = freezed,Object? width = freezed,Object? height = freezed,Object? durationMs = freezed,Object? blurhash = freezed,Object? urls = null,Object? urlsExpireAt = freezed,}) {
  return _then(_MediaAssetRecord(
assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,blurhash: freezed == blurhash ? _self.blurhash : blurhash // ignore: cast_nullable_to_non_nullable
as String?,urls: null == urls ? _self._urls : urls // ignore: cast_nullable_to_non_nullable
as Map<String, String>,urlsExpireAt: freezed == urlsExpireAt ? _self.urlsExpireAt : urlsExpireAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
