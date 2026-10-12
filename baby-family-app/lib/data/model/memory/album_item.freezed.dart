// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlbumItem {

@JsonKey(name: 'asset') String get asset;@JsonKey(name: 'isVideo') bool get isVideo;@JsonKey(name: 'durationSec') int? get durationSec;@JsonKey(name: 'memoryId') String? get memoryId;
/// Create a copy of AlbumItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumItemCopyWith<AlbumItem> get copyWith => _$AlbumItemCopyWithImpl<AlbumItem>(this as AlbumItem, _$identity);

  /// Serializes this AlbumItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlbumItem&&(identical(other.asset, asset) || other.asset == asset)&&(identical(other.isVideo, isVideo) || other.isVideo == isVideo)&&(identical(other.durationSec, durationSec) || other.durationSec == durationSec)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,asset,isVideo,durationSec,memoryId);

@override
String toString() {
  return 'AlbumItem(asset: $asset, isVideo: $isVideo, durationSec: $durationSec, memoryId: $memoryId)';
}


}

/// @nodoc
abstract mixin class $AlbumItemCopyWith<$Res>  {
  factory $AlbumItemCopyWith(AlbumItem value, $Res Function(AlbumItem) _then) = _$AlbumItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'asset') String asset,@JsonKey(name: 'isVideo') bool isVideo,@JsonKey(name: 'durationSec') int? durationSec,@JsonKey(name: 'memoryId') String? memoryId
});




}
/// @nodoc
class _$AlbumItemCopyWithImpl<$Res>
    implements $AlbumItemCopyWith<$Res> {
  _$AlbumItemCopyWithImpl(this._self, this._then);

  final AlbumItem _self;
  final $Res Function(AlbumItem) _then;

/// Create a copy of AlbumItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? asset = null,Object? isVideo = null,Object? durationSec = freezed,Object? memoryId = freezed,}) {
  return _then(_self.copyWith(
asset: null == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as String,isVideo: null == isVideo ? _self.isVideo : isVideo // ignore: cast_nullable_to_non_nullable
as bool,durationSec: freezed == durationSec ? _self.durationSec : durationSec // ignore: cast_nullable_to_non_nullable
as int?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AlbumItem].
extension AlbumItemPatterns on AlbumItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlbumItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlbumItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlbumItem value)  $default,){
final _that = this;
switch (_that) {
case _AlbumItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlbumItem value)?  $default,){
final _that = this;
switch (_that) {
case _AlbumItem() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AlbumItem implements AlbumItem {
  const _AlbumItem({@JsonKey(name: 'asset') required this.asset, @JsonKey(name: 'isVideo') this.isVideo = false, @JsonKey(name: 'durationSec') this.durationSec, @JsonKey(name: 'memoryId') this.memoryId});
  factory _AlbumItem.fromJson(Map<String, dynamic> json) => _$AlbumItemFromJson(json);

@override@JsonKey(name: 'asset') final  String asset;
@override@JsonKey(name: 'isVideo') final  bool isVideo;
@override@JsonKey(name: 'durationSec') final  int? durationSec;
@override@JsonKey(name: 'memoryId') final  String? memoryId;

/// Create a copy of AlbumItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumItemCopyWith<_AlbumItem> get copyWith => __$AlbumItemCopyWithImpl<_AlbumItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlbumItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlbumItem&&(identical(other.asset, asset) || other.asset == asset)&&(identical(other.isVideo, isVideo) || other.isVideo == isVideo)&&(identical(other.durationSec, durationSec) || other.durationSec == durationSec)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,asset,isVideo,durationSec,memoryId);

@override
String toString() {
  return 'AlbumItem(asset: $asset, isVideo: $isVideo, durationSec: $durationSec, memoryId: $memoryId)';
}


}

/// @nodoc
abstract mixin class _$AlbumItemCopyWith<$Res> implements $AlbumItemCopyWith<$Res> {
  factory _$AlbumItemCopyWith(_AlbumItem value, $Res Function(_AlbumItem) _then) = __$AlbumItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'asset') String asset,@JsonKey(name: 'isVideo') bool isVideo,@JsonKey(name: 'durationSec') int? durationSec,@JsonKey(name: 'memoryId') String? memoryId
});




}
/// @nodoc
class __$AlbumItemCopyWithImpl<$Res>
    implements _$AlbumItemCopyWith<$Res> {
  __$AlbumItemCopyWithImpl(this._self, this._then);

  final _AlbumItem _self;
  final $Res Function(_AlbumItem) _then;

/// Create a copy of AlbumItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? asset = null,Object? isVideo = null,Object? durationSec = freezed,Object? memoryId = freezed,}) {
  return _then(_AlbumItem(
asset: null == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as String,isVideo: null == isVideo ? _self.isVideo : isVideo // ignore: cast_nullable_to_non_nullable
as bool,durationSec: freezed == durationSec ? _self.durationSec : durationSec // ignore: cast_nullable_to_non_nullable
as int?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
