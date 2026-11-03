// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'perspective_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PerspectiveRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'memoryId') String? get memoryId;@JsonKey(name: 'authorUserId') String? get authorUserId;@JsonKey(name: 'body') String? get body;/// Ghi âm góc nhìn (BF-20261030-004): asset + URL nghe có hạn.
@JsonKey(name: 'audioAssetId') String? get audioAssetId;@JsonKey(name: 'audioUrl') String? get audioUrl;@JsonKey(name: 'audioDurationSec') int? get audioDurationSec;/// Ảnh/video của góc nhìn (BF-20261030-006).
@JsonKey(name: 'assets', fromJson: _perspectiveAssets) List<PerspectiveAssetRecord> get assets;@JsonKey(name: 'hiddenFromCircle') bool get hiddenFromCircle;@JsonKey(name: 'createdAt') DateTime? get createdAt;
/// Create a copy of PerspectiveRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PerspectiveRecordCopyWith<PerspectiveRecord> get copyWith => _$PerspectiveRecordCopyWithImpl<PerspectiveRecord>(this as PerspectiveRecord, _$identity);

  /// Serializes this PerspectiveRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PerspectiveRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.body, body) || other.body == body)&&(identical(other.audioAssetId, audioAssetId) || other.audioAssetId == audioAssetId)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.audioDurationSec, audioDurationSec) || other.audioDurationSec == audioDurationSec)&&const DeepCollectionEquality().equals(other.assets, assets)&&(identical(other.hiddenFromCircle, hiddenFromCircle) || other.hiddenFromCircle == hiddenFromCircle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memoryId,authorUserId,body,audioAssetId,audioUrl,audioDurationSec,const DeepCollectionEquality().hash(assets),hiddenFromCircle,createdAt);

@override
String toString() {
  return 'PerspectiveRecord(id: $id, memoryId: $memoryId, authorUserId: $authorUserId, body: $body, audioAssetId: $audioAssetId, audioUrl: $audioUrl, audioDurationSec: $audioDurationSec, assets: $assets, hiddenFromCircle: $hiddenFromCircle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PerspectiveRecordCopyWith<$Res>  {
  factory $PerspectiveRecordCopyWith(PerspectiveRecord value, $Res Function(PerspectiveRecord) _then) = _$PerspectiveRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'authorUserId') String? authorUserId,@JsonKey(name: 'body') String? body,@JsonKey(name: 'audioAssetId') String? audioAssetId,@JsonKey(name: 'audioUrl') String? audioUrl,@JsonKey(name: 'audioDurationSec') int? audioDurationSec,@JsonKey(name: 'assets', fromJson: _perspectiveAssets) List<PerspectiveAssetRecord> assets,@JsonKey(name: 'hiddenFromCircle') bool hiddenFromCircle,@JsonKey(name: 'createdAt') DateTime? createdAt
});




}
/// @nodoc
class _$PerspectiveRecordCopyWithImpl<$Res>
    implements $PerspectiveRecordCopyWith<$Res> {
  _$PerspectiveRecordCopyWithImpl(this._self, this._then);

  final PerspectiveRecord _self;
  final $Res Function(PerspectiveRecord) _then;

/// Create a copy of PerspectiveRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? memoryId = freezed,Object? authorUserId = freezed,Object? body = freezed,Object? audioAssetId = freezed,Object? audioUrl = freezed,Object? audioDurationSec = freezed,Object? assets = null,Object? hiddenFromCircle = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,authorUserId: freezed == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,audioAssetId: freezed == audioAssetId ? _self.audioAssetId : audioAssetId // ignore: cast_nullable_to_non_nullable
as String?,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,audioDurationSec: freezed == audioDurationSec ? _self.audioDurationSec : audioDurationSec // ignore: cast_nullable_to_non_nullable
as int?,assets: null == assets ? _self.assets : assets // ignore: cast_nullable_to_non_nullable
as List<PerspectiveAssetRecord>,hiddenFromCircle: null == hiddenFromCircle ? _self.hiddenFromCircle : hiddenFromCircle // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PerspectiveRecord].
extension PerspectiveRecordPatterns on PerspectiveRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PerspectiveRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PerspectiveRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PerspectiveRecord value)  $default,){
final _that = this;
switch (_that) {
case _PerspectiveRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PerspectiveRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PerspectiveRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PerspectiveRecord implements PerspectiveRecord {
  const _PerspectiveRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'memoryId') this.memoryId, @JsonKey(name: 'authorUserId') this.authorUserId, @JsonKey(name: 'body') this.body, @JsonKey(name: 'audioAssetId') this.audioAssetId, @JsonKey(name: 'audioUrl') this.audioUrl, @JsonKey(name: 'audioDurationSec') this.audioDurationSec, @JsonKey(name: 'assets', fromJson: _perspectiveAssets) final  List<PerspectiveAssetRecord> assets = const <PerspectiveAssetRecord>[], @JsonKey(name: 'hiddenFromCircle') this.hiddenFromCircle = false, @JsonKey(name: 'createdAt') this.createdAt}): _assets = assets;
  factory _PerspectiveRecord.fromJson(Map<String, dynamic> json) => _$PerspectiveRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'memoryId') final  String? memoryId;
@override@JsonKey(name: 'authorUserId') final  String? authorUserId;
@override@JsonKey(name: 'body') final  String? body;
/// Ghi âm góc nhìn (BF-20261030-004): asset + URL nghe có hạn.
@override@JsonKey(name: 'audioAssetId') final  String? audioAssetId;
@override@JsonKey(name: 'audioUrl') final  String? audioUrl;
@override@JsonKey(name: 'audioDurationSec') final  int? audioDurationSec;
/// Ảnh/video của góc nhìn (BF-20261030-006).
 final  List<PerspectiveAssetRecord> _assets;
/// Ảnh/video của góc nhìn (BF-20261030-006).
@override@JsonKey(name: 'assets', fromJson: _perspectiveAssets) List<PerspectiveAssetRecord> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}

@override@JsonKey(name: 'hiddenFromCircle') final  bool hiddenFromCircle;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;

/// Create a copy of PerspectiveRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PerspectiveRecordCopyWith<_PerspectiveRecord> get copyWith => __$PerspectiveRecordCopyWithImpl<_PerspectiveRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PerspectiveRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PerspectiveRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.body, body) || other.body == body)&&(identical(other.audioAssetId, audioAssetId) || other.audioAssetId == audioAssetId)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.audioDurationSec, audioDurationSec) || other.audioDurationSec == audioDurationSec)&&const DeepCollectionEquality().equals(other._assets, _assets)&&(identical(other.hiddenFromCircle, hiddenFromCircle) || other.hiddenFromCircle == hiddenFromCircle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memoryId,authorUserId,body,audioAssetId,audioUrl,audioDurationSec,const DeepCollectionEquality().hash(_assets),hiddenFromCircle,createdAt);

@override
String toString() {
  return 'PerspectiveRecord(id: $id, memoryId: $memoryId, authorUserId: $authorUserId, body: $body, audioAssetId: $audioAssetId, audioUrl: $audioUrl, audioDurationSec: $audioDurationSec, assets: $assets, hiddenFromCircle: $hiddenFromCircle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PerspectiveRecordCopyWith<$Res> implements $PerspectiveRecordCopyWith<$Res> {
  factory _$PerspectiveRecordCopyWith(_PerspectiveRecord value, $Res Function(_PerspectiveRecord) _then) = __$PerspectiveRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'authorUserId') String? authorUserId,@JsonKey(name: 'body') String? body,@JsonKey(name: 'audioAssetId') String? audioAssetId,@JsonKey(name: 'audioUrl') String? audioUrl,@JsonKey(name: 'audioDurationSec') int? audioDurationSec,@JsonKey(name: 'assets', fromJson: _perspectiveAssets) List<PerspectiveAssetRecord> assets,@JsonKey(name: 'hiddenFromCircle') bool hiddenFromCircle,@JsonKey(name: 'createdAt') DateTime? createdAt
});




}
/// @nodoc
class __$PerspectiveRecordCopyWithImpl<$Res>
    implements _$PerspectiveRecordCopyWith<$Res> {
  __$PerspectiveRecordCopyWithImpl(this._self, this._then);

  final _PerspectiveRecord _self;
  final $Res Function(_PerspectiveRecord) _then;

/// Create a copy of PerspectiveRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? memoryId = freezed,Object? authorUserId = freezed,Object? body = freezed,Object? audioAssetId = freezed,Object? audioUrl = freezed,Object? audioDurationSec = freezed,Object? assets = null,Object? hiddenFromCircle = null,Object? createdAt = freezed,}) {
  return _then(_PerspectiveRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,authorUserId: freezed == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,audioAssetId: freezed == audioAssetId ? _self.audioAssetId : audioAssetId // ignore: cast_nullable_to_non_nullable
as String?,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,audioDurationSec: freezed == audioDurationSec ? _self.audioDurationSec : audioDurationSec // ignore: cast_nullable_to_non_nullable
as int?,assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<PerspectiveAssetRecord>,hiddenFromCircle: null == hiddenFromCircle ? _self.hiddenFromCircle : hiddenFromCircle // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$PerspectiveAssetRecord {

@JsonKey(name: 'assetId') String get assetId;@JsonKey(name: 'kind') String get kind;@JsonKey(name: 'url') String? get url;@JsonKey(name: 'videoUrl') String? get videoUrl;
/// Create a copy of PerspectiveAssetRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PerspectiveAssetRecordCopyWith<PerspectiveAssetRecord> get copyWith => _$PerspectiveAssetRecordCopyWithImpl<PerspectiveAssetRecord>(this as PerspectiveAssetRecord, _$identity);

  /// Serializes this PerspectiveAssetRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PerspectiveAssetRecord&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.url, url) || other.url == url)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,kind,url,videoUrl);

@override
String toString() {
  return 'PerspectiveAssetRecord(assetId: $assetId, kind: $kind, url: $url, videoUrl: $videoUrl)';
}


}

/// @nodoc
abstract mixin class $PerspectiveAssetRecordCopyWith<$Res>  {
  factory $PerspectiveAssetRecordCopyWith(PerspectiveAssetRecord value, $Res Function(PerspectiveAssetRecord) _then) = _$PerspectiveAssetRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'assetId') String assetId,@JsonKey(name: 'kind') String kind,@JsonKey(name: 'url') String? url,@JsonKey(name: 'videoUrl') String? videoUrl
});




}
/// @nodoc
class _$PerspectiveAssetRecordCopyWithImpl<$Res>
    implements $PerspectiveAssetRecordCopyWith<$Res> {
  _$PerspectiveAssetRecordCopyWithImpl(this._self, this._then);

  final PerspectiveAssetRecord _self;
  final $Res Function(PerspectiveAssetRecord) _then;

/// Create a copy of PerspectiveAssetRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetId = null,Object? kind = null,Object? url = freezed,Object? videoUrl = freezed,}) {
  return _then(_self.copyWith(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PerspectiveAssetRecord].
extension PerspectiveAssetRecordPatterns on PerspectiveAssetRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PerspectiveAssetRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PerspectiveAssetRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PerspectiveAssetRecord value)  $default,){
final _that = this;
switch (_that) {
case _PerspectiveAssetRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PerspectiveAssetRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PerspectiveAssetRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PerspectiveAssetRecord implements PerspectiveAssetRecord {
  const _PerspectiveAssetRecord({@JsonKey(name: 'assetId') required this.assetId, @JsonKey(name: 'kind') this.kind = 'IMAGE', @JsonKey(name: 'url') this.url, @JsonKey(name: 'videoUrl') this.videoUrl});
  factory _PerspectiveAssetRecord.fromJson(Map<String, dynamic> json) => _$PerspectiveAssetRecordFromJson(json);

@override@JsonKey(name: 'assetId') final  String assetId;
@override@JsonKey(name: 'kind') final  String kind;
@override@JsonKey(name: 'url') final  String? url;
@override@JsonKey(name: 'videoUrl') final  String? videoUrl;

/// Create a copy of PerspectiveAssetRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PerspectiveAssetRecordCopyWith<_PerspectiveAssetRecord> get copyWith => __$PerspectiveAssetRecordCopyWithImpl<_PerspectiveAssetRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PerspectiveAssetRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PerspectiveAssetRecord&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.url, url) || other.url == url)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,kind,url,videoUrl);

@override
String toString() {
  return 'PerspectiveAssetRecord(assetId: $assetId, kind: $kind, url: $url, videoUrl: $videoUrl)';
}


}

/// @nodoc
abstract mixin class _$PerspectiveAssetRecordCopyWith<$Res> implements $PerspectiveAssetRecordCopyWith<$Res> {
  factory _$PerspectiveAssetRecordCopyWith(_PerspectiveAssetRecord value, $Res Function(_PerspectiveAssetRecord) _then) = __$PerspectiveAssetRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'assetId') String assetId,@JsonKey(name: 'kind') String kind,@JsonKey(name: 'url') String? url,@JsonKey(name: 'videoUrl') String? videoUrl
});




}
/// @nodoc
class __$PerspectiveAssetRecordCopyWithImpl<$Res>
    implements _$PerspectiveAssetRecordCopyWith<$Res> {
  __$PerspectiveAssetRecordCopyWithImpl(this._self, this._then);

  final _PerspectiveAssetRecord _self;
  final $Res Function(_PerspectiveAssetRecord) _then;

/// Create a copy of PerspectiveAssetRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = null,Object? kind = null,Object? url = freezed,Object? videoUrl = freezed,}) {
  return _then(_PerspectiveAssetRecord(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
