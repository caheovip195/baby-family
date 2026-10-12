// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_draft_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemoryDraftItem {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'kind') MemoryKind get kind;@JsonKey(name: 'title') String get title;@JsonKey(name: 'childIds') List<String> get childIds;@JsonKey(name: 'updatedAt') DateTime get updatedAt;@JsonKey(name: 'location') DraftLocation get location;@JsonKey(name: 'deviceName') String? get deviceName;@JsonKey(name: 'mediaAssets') List<String> get mediaAssets;@JsonKey(name: 'extraCount') int get extraCount;@JsonKey(name: 'voiceDurationSec') int? get voiceDurationSec;
/// Create a copy of MemoryDraftItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryDraftItemCopyWith<MemoryDraftItem> get copyWith => _$MemoryDraftItemCopyWithImpl<MemoryDraftItem>(this as MemoryDraftItem, _$identity);

  /// Serializes this MemoryDraftItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryDraftItem&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.childIds, childIds)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.location, location) || other.location == location)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&const DeepCollectionEquality().equals(other.mediaAssets, mediaAssets)&&(identical(other.extraCount, extraCount) || other.extraCount == extraCount)&&(identical(other.voiceDurationSec, voiceDurationSec) || other.voiceDurationSec == voiceDurationSec));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,title,const DeepCollectionEquality().hash(childIds),updatedAt,location,deviceName,const DeepCollectionEquality().hash(mediaAssets),extraCount,voiceDurationSec);

@override
String toString() {
  return 'MemoryDraftItem(id: $id, kind: $kind, title: $title, childIds: $childIds, updatedAt: $updatedAt, location: $location, deviceName: $deviceName, mediaAssets: $mediaAssets, extraCount: $extraCount, voiceDurationSec: $voiceDurationSec)';
}


}

/// @nodoc
abstract mixin class $MemoryDraftItemCopyWith<$Res>  {
  factory $MemoryDraftItemCopyWith(MemoryDraftItem value, $Res Function(MemoryDraftItem) _then) = _$MemoryDraftItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'kind') MemoryKind kind,@JsonKey(name: 'title') String title,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'updatedAt') DateTime updatedAt,@JsonKey(name: 'location') DraftLocation location,@JsonKey(name: 'deviceName') String? deviceName,@JsonKey(name: 'mediaAssets') List<String> mediaAssets,@JsonKey(name: 'extraCount') int extraCount,@JsonKey(name: 'voiceDurationSec') int? voiceDurationSec
});




}
/// @nodoc
class _$MemoryDraftItemCopyWithImpl<$Res>
    implements $MemoryDraftItemCopyWith<$Res> {
  _$MemoryDraftItemCopyWithImpl(this._self, this._then);

  final MemoryDraftItem _self;
  final $Res Function(MemoryDraftItem) _then;

/// Create a copy of MemoryDraftItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? title = null,Object? childIds = null,Object? updatedAt = null,Object? location = null,Object? deviceName = freezed,Object? mediaAssets = null,Object? extraCount = null,Object? voiceDurationSec = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MemoryKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as DraftLocation,deviceName: freezed == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String?,mediaAssets: null == mediaAssets ? _self.mediaAssets : mediaAssets // ignore: cast_nullable_to_non_nullable
as List<String>,extraCount: null == extraCount ? _self.extraCount : extraCount // ignore: cast_nullable_to_non_nullable
as int,voiceDurationSec: freezed == voiceDurationSec ? _self.voiceDurationSec : voiceDurationSec // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryDraftItem].
extension MemoryDraftItemPatterns on MemoryDraftItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryDraftItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryDraftItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryDraftItem value)  $default,){
final _that = this;
switch (_that) {
case _MemoryDraftItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryDraftItem value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryDraftItem() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MemoryDraftItem implements MemoryDraftItem {
  const _MemoryDraftItem({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'kind') this.kind = MemoryKind.photo, @JsonKey(name: 'title') this.title = '', @JsonKey(name: 'childIds') final  List<String> childIds = const [], @JsonKey(name: 'updatedAt') required this.updatedAt, @JsonKey(name: 'location') this.location = DraftLocation.device, @JsonKey(name: 'deviceName') this.deviceName, @JsonKey(name: 'mediaAssets') final  List<String> mediaAssets = const [], @JsonKey(name: 'extraCount') this.extraCount = 0, @JsonKey(name: 'voiceDurationSec') this.voiceDurationSec}): _childIds = childIds,_mediaAssets = mediaAssets;
  factory _MemoryDraftItem.fromJson(Map<String, dynamic> json) => _$MemoryDraftItemFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'kind') final  MemoryKind kind;
@override@JsonKey(name: 'title') final  String title;
 final  List<String> _childIds;
@override@JsonKey(name: 'childIds') List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}

@override@JsonKey(name: 'updatedAt') final  DateTime updatedAt;
@override@JsonKey(name: 'location') final  DraftLocation location;
@override@JsonKey(name: 'deviceName') final  String? deviceName;
 final  List<String> _mediaAssets;
@override@JsonKey(name: 'mediaAssets') List<String> get mediaAssets {
  if (_mediaAssets is EqualUnmodifiableListView) return _mediaAssets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaAssets);
}

@override@JsonKey(name: 'extraCount') final  int extraCount;
@override@JsonKey(name: 'voiceDurationSec') final  int? voiceDurationSec;

/// Create a copy of MemoryDraftItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryDraftItemCopyWith<_MemoryDraftItem> get copyWith => __$MemoryDraftItemCopyWithImpl<_MemoryDraftItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryDraftItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryDraftItem&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._childIds, _childIds)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.location, location) || other.location == location)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&const DeepCollectionEquality().equals(other._mediaAssets, _mediaAssets)&&(identical(other.extraCount, extraCount) || other.extraCount == extraCount)&&(identical(other.voiceDurationSec, voiceDurationSec) || other.voiceDurationSec == voiceDurationSec));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,title,const DeepCollectionEquality().hash(_childIds),updatedAt,location,deviceName,const DeepCollectionEquality().hash(_mediaAssets),extraCount,voiceDurationSec);

@override
String toString() {
  return 'MemoryDraftItem(id: $id, kind: $kind, title: $title, childIds: $childIds, updatedAt: $updatedAt, location: $location, deviceName: $deviceName, mediaAssets: $mediaAssets, extraCount: $extraCount, voiceDurationSec: $voiceDurationSec)';
}


}

/// @nodoc
abstract mixin class _$MemoryDraftItemCopyWith<$Res> implements $MemoryDraftItemCopyWith<$Res> {
  factory _$MemoryDraftItemCopyWith(_MemoryDraftItem value, $Res Function(_MemoryDraftItem) _then) = __$MemoryDraftItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'kind') MemoryKind kind,@JsonKey(name: 'title') String title,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'updatedAt') DateTime updatedAt,@JsonKey(name: 'location') DraftLocation location,@JsonKey(name: 'deviceName') String? deviceName,@JsonKey(name: 'mediaAssets') List<String> mediaAssets,@JsonKey(name: 'extraCount') int extraCount,@JsonKey(name: 'voiceDurationSec') int? voiceDurationSec
});




}
/// @nodoc
class __$MemoryDraftItemCopyWithImpl<$Res>
    implements _$MemoryDraftItemCopyWith<$Res> {
  __$MemoryDraftItemCopyWithImpl(this._self, this._then);

  final _MemoryDraftItem _self;
  final $Res Function(_MemoryDraftItem) _then;

/// Create a copy of MemoryDraftItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? title = null,Object? childIds = null,Object? updatedAt = null,Object? location = null,Object? deviceName = freezed,Object? mediaAssets = null,Object? extraCount = null,Object? voiceDurationSec = freezed,}) {
  return _then(_MemoryDraftItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MemoryKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as DraftLocation,deviceName: freezed == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String?,mediaAssets: null == mediaAssets ? _self._mediaAssets : mediaAssets // ignore: cast_nullable_to_non_nullable
as List<String>,extraCount: null == extraCount ? _self.extraCount : extraCount // ignore: cast_nullable_to_non_nullable
as int,voiceDurationSec: freezed == voiceDurationSec ? _self.voiceDurationSec : voiceDurationSec // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
