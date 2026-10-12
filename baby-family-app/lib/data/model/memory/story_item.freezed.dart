// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoryItem {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'childId') String get childId;@JsonKey(name: 'asset') String get asset;@JsonKey(name: 'memoryId') String? get memoryId;@JsonKey(name: 'caption') String? get caption;@JsonKey(name: 'authorId') String get authorId;@JsonKey(name: 'createdAt') DateTime get createdAt;@JsonKey(name: 'seen') bool get seen;
/// Create a copy of StoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryItemCopyWith<StoryItem> get copyWith => _$StoryItemCopyWithImpl<StoryItem>(this as StoryItem, _$identity);

  /// Serializes this StoryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.asset, asset) || other.asset == asset)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.seen, seen) || other.seen == seen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,childId,asset,memoryId,caption,authorId,createdAt,seen);

@override
String toString() {
  return 'StoryItem(id: $id, childId: $childId, asset: $asset, memoryId: $memoryId, caption: $caption, authorId: $authorId, createdAt: $createdAt, seen: $seen)';
}


}

/// @nodoc
abstract mixin class $StoryItemCopyWith<$Res>  {
  factory $StoryItemCopyWith(StoryItem value, $Res Function(StoryItem) _then) = _$StoryItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'childId') String childId,@JsonKey(name: 'asset') String asset,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'caption') String? caption,@JsonKey(name: 'authorId') String authorId,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'seen') bool seen
});




}
/// @nodoc
class _$StoryItemCopyWithImpl<$Res>
    implements $StoryItemCopyWith<$Res> {
  _$StoryItemCopyWithImpl(this._self, this._then);

  final StoryItem _self;
  final $Res Function(StoryItem) _then;

/// Create a copy of StoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? childId = null,Object? asset = null,Object? memoryId = freezed,Object? caption = freezed,Object? authorId = null,Object? createdAt = null,Object? seen = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,asset: null == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as String,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,seen: null == seen ? _self.seen : seen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryItem].
extension StoryItemPatterns on StoryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryItem value)  $default,){
final _that = this;
switch (_that) {
case _StoryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _StoryItem() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _StoryItem implements StoryItem {
  const _StoryItem({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'childId') required this.childId, @JsonKey(name: 'asset') required this.asset, @JsonKey(name: 'memoryId') this.memoryId, @JsonKey(name: 'caption') this.caption, @JsonKey(name: 'authorId') required this.authorId, @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'seen') this.seen = false});
  factory _StoryItem.fromJson(Map<String, dynamic> json) => _$StoryItemFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'childId') final  String childId;
@override@JsonKey(name: 'asset') final  String asset;
@override@JsonKey(name: 'memoryId') final  String? memoryId;
@override@JsonKey(name: 'caption') final  String? caption;
@override@JsonKey(name: 'authorId') final  String authorId;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;
@override@JsonKey(name: 'seen') final  bool seen;

/// Create a copy of StoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryItemCopyWith<_StoryItem> get copyWith => __$StoryItemCopyWithImpl<_StoryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.asset, asset) || other.asset == asset)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.seen, seen) || other.seen == seen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,childId,asset,memoryId,caption,authorId,createdAt,seen);

@override
String toString() {
  return 'StoryItem(id: $id, childId: $childId, asset: $asset, memoryId: $memoryId, caption: $caption, authorId: $authorId, createdAt: $createdAt, seen: $seen)';
}


}

/// @nodoc
abstract mixin class _$StoryItemCopyWith<$Res> implements $StoryItemCopyWith<$Res> {
  factory _$StoryItemCopyWith(_StoryItem value, $Res Function(_StoryItem) _then) = __$StoryItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'childId') String childId,@JsonKey(name: 'asset') String asset,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'caption') String? caption,@JsonKey(name: 'authorId') String authorId,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'seen') bool seen
});




}
/// @nodoc
class __$StoryItemCopyWithImpl<$Res>
    implements _$StoryItemCopyWith<$Res> {
  __$StoryItemCopyWithImpl(this._self, this._then);

  final _StoryItem _self;
  final $Res Function(_StoryItem) _then;

/// Create a copy of StoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? childId = null,Object? asset = null,Object? memoryId = freezed,Object? caption = freezed,Object? authorId = null,Object? createdAt = null,Object? seen = null,}) {
  return _then(_StoryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,asset: null == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as String,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,seen: null == seen ? _self.seen : seen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
