// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_grid_item_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaGridItemRecord {

@JsonKey(name: 'assetId') String? get assetId;@JsonKey(name: 'memoryId') String? get memoryId;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'width') int? get width;@JsonKey(name: 'height') int? get height;@JsonKey(name: 'durationMs') int? get durationMs;@JsonKey(name: 'blurhash') String? get blurhash;@JsonKey(name: 'occurredAt') DateTime? get occurredAt;@JsonKey(name: 'urls') Map<String, String> get urls;@JsonKey(name: 'urlsExpireAt') DateTime? get urlsExpireAt;
/// Create a copy of MediaGridItemRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaGridItemRecordCopyWith<MediaGridItemRecord> get copyWith => _$MediaGridItemRecordCopyWithImpl<MediaGridItemRecord>(this as MediaGridItemRecord, _$identity);

  /// Serializes this MediaGridItemRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaGridItemRecord&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.blurhash, blurhash) || other.blurhash == blurhash)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&const DeepCollectionEquality().equals(other.urls, urls)&&(identical(other.urlsExpireAt, urlsExpireAt) || other.urlsExpireAt == urlsExpireAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,memoryId,kind,width,height,durationMs,blurhash,occurredAt,const DeepCollectionEquality().hash(urls),urlsExpireAt);

@override
String toString() {
  return 'MediaGridItemRecord(assetId: $assetId, memoryId: $memoryId, kind: $kind, width: $width, height: $height, durationMs: $durationMs, blurhash: $blurhash, occurredAt: $occurredAt, urls: $urls, urlsExpireAt: $urlsExpireAt)';
}


}

/// @nodoc
abstract mixin class $MediaGridItemRecordCopyWith<$Res>  {
  factory $MediaGridItemRecordCopyWith(MediaGridItemRecord value, $Res Function(MediaGridItemRecord) _then) = _$MediaGridItemRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'assetId') String? assetId,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'width') int? width,@JsonKey(name: 'height') int? height,@JsonKey(name: 'durationMs') int? durationMs,@JsonKey(name: 'blurhash') String? blurhash,@JsonKey(name: 'occurredAt') DateTime? occurredAt,@JsonKey(name: 'urls') Map<String, String> urls,@JsonKey(name: 'urlsExpireAt') DateTime? urlsExpireAt
});




}
/// @nodoc
class _$MediaGridItemRecordCopyWithImpl<$Res>
    implements $MediaGridItemRecordCopyWith<$Res> {
  _$MediaGridItemRecordCopyWithImpl(this._self, this._then);

  final MediaGridItemRecord _self;
  final $Res Function(MediaGridItemRecord) _then;

/// Create a copy of MediaGridItemRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetId = freezed,Object? memoryId = freezed,Object? kind = freezed,Object? width = freezed,Object? height = freezed,Object? durationMs = freezed,Object? blurhash = freezed,Object? occurredAt = freezed,Object? urls = null,Object? urlsExpireAt = freezed,}) {
  return _then(_self.copyWith(
assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,blurhash: freezed == blurhash ? _self.blurhash : blurhash // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: freezed == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,urls: null == urls ? _self.urls : urls // ignore: cast_nullable_to_non_nullable
as Map<String, String>,urlsExpireAt: freezed == urlsExpireAt ? _self.urlsExpireAt : urlsExpireAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaGridItemRecord].
extension MediaGridItemRecordPatterns on MediaGridItemRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaGridItemRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaGridItemRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaGridItemRecord value)  $default,){
final _that = this;
switch (_that) {
case _MediaGridItemRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaGridItemRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MediaGridItemRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MediaGridItemRecord implements MediaGridItemRecord {
  const _MediaGridItemRecord({@JsonKey(name: 'assetId') this.assetId, @JsonKey(name: 'memoryId') this.memoryId, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'width') this.width, @JsonKey(name: 'height') this.height, @JsonKey(name: 'durationMs') this.durationMs, @JsonKey(name: 'blurhash') this.blurhash, @JsonKey(name: 'occurredAt') this.occurredAt, @JsonKey(name: 'urls') final  Map<String, String> urls = const <String, String>{}, @JsonKey(name: 'urlsExpireAt') this.urlsExpireAt}): _urls = urls;
  factory _MediaGridItemRecord.fromJson(Map<String, dynamic> json) => _$MediaGridItemRecordFromJson(json);

@override@JsonKey(name: 'assetId') final  String? assetId;
@override@JsonKey(name: 'memoryId') final  String? memoryId;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'width') final  int? width;
@override@JsonKey(name: 'height') final  int? height;
@override@JsonKey(name: 'durationMs') final  int? durationMs;
@override@JsonKey(name: 'blurhash') final  String? blurhash;
@override@JsonKey(name: 'occurredAt') final  DateTime? occurredAt;
 final  Map<String, String> _urls;
@override@JsonKey(name: 'urls') Map<String, String> get urls {
  if (_urls is EqualUnmodifiableMapView) return _urls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_urls);
}

@override@JsonKey(name: 'urlsExpireAt') final  DateTime? urlsExpireAt;

/// Create a copy of MediaGridItemRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaGridItemRecordCopyWith<_MediaGridItemRecord> get copyWith => __$MediaGridItemRecordCopyWithImpl<_MediaGridItemRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaGridItemRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaGridItemRecord&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.blurhash, blurhash) || other.blurhash == blurhash)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&const DeepCollectionEquality().equals(other._urls, _urls)&&(identical(other.urlsExpireAt, urlsExpireAt) || other.urlsExpireAt == urlsExpireAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,memoryId,kind,width,height,durationMs,blurhash,occurredAt,const DeepCollectionEquality().hash(_urls),urlsExpireAt);

@override
String toString() {
  return 'MediaGridItemRecord(assetId: $assetId, memoryId: $memoryId, kind: $kind, width: $width, height: $height, durationMs: $durationMs, blurhash: $blurhash, occurredAt: $occurredAt, urls: $urls, urlsExpireAt: $urlsExpireAt)';
}


}

/// @nodoc
abstract mixin class _$MediaGridItemRecordCopyWith<$Res> implements $MediaGridItemRecordCopyWith<$Res> {
  factory _$MediaGridItemRecordCopyWith(_MediaGridItemRecord value, $Res Function(_MediaGridItemRecord) _then) = __$MediaGridItemRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'assetId') String? assetId,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'width') int? width,@JsonKey(name: 'height') int? height,@JsonKey(name: 'durationMs') int? durationMs,@JsonKey(name: 'blurhash') String? blurhash,@JsonKey(name: 'occurredAt') DateTime? occurredAt,@JsonKey(name: 'urls') Map<String, String> urls,@JsonKey(name: 'urlsExpireAt') DateTime? urlsExpireAt
});




}
/// @nodoc
class __$MediaGridItemRecordCopyWithImpl<$Res>
    implements _$MediaGridItemRecordCopyWith<$Res> {
  __$MediaGridItemRecordCopyWithImpl(this._self, this._then);

  final _MediaGridItemRecord _self;
  final $Res Function(_MediaGridItemRecord) _then;

/// Create a copy of MediaGridItemRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = freezed,Object? memoryId = freezed,Object? kind = freezed,Object? width = freezed,Object? height = freezed,Object? durationMs = freezed,Object? blurhash = freezed,Object? occurredAt = freezed,Object? urls = null,Object? urlsExpireAt = freezed,}) {
  return _then(_MediaGridItemRecord(
assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,blurhash: freezed == blurhash ? _self.blurhash : blurhash // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: freezed == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,urls: null == urls ? _self._urls : urls // ignore: cast_nullable_to_non_nullable
as Map<String, String>,urlsExpireAt: freezed == urlsExpireAt ? _self.urlsExpireAt : urlsExpireAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
