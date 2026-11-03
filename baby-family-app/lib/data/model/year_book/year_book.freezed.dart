// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'year_book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$YearBookPhoto {

@JsonKey(name: 'assetId') String get assetId;@JsonKey(name: 'url') String? get url;
/// Create a copy of YearBookPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearBookPhotoCopyWith<YearBookPhoto> get copyWith => _$YearBookPhotoCopyWithImpl<YearBookPhoto>(this as YearBookPhoto, _$identity);

  /// Serializes this YearBookPhoto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearBookPhoto&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,url);

@override
String toString() {
  return 'YearBookPhoto(assetId: $assetId, url: $url)';
}


}

/// @nodoc
abstract mixin class $YearBookPhotoCopyWith<$Res>  {
  factory $YearBookPhotoCopyWith(YearBookPhoto value, $Res Function(YearBookPhoto) _then) = _$YearBookPhotoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'assetId') String assetId,@JsonKey(name: 'url') String? url
});




}
/// @nodoc
class _$YearBookPhotoCopyWithImpl<$Res>
    implements $YearBookPhotoCopyWith<$Res> {
  _$YearBookPhotoCopyWithImpl(this._self, this._then);

  final YearBookPhoto _self;
  final $Res Function(YearBookPhoto) _then;

/// Create a copy of YearBookPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetId = null,Object? url = freezed,}) {
  return _then(_self.copyWith(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [YearBookPhoto].
extension YearBookPhotoPatterns on YearBookPhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearBookPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearBookPhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearBookPhoto value)  $default,){
final _that = this;
switch (_that) {
case _YearBookPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearBookPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _YearBookPhoto() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _YearBookPhoto implements YearBookPhoto {
  const _YearBookPhoto({@JsonKey(name: 'assetId') required this.assetId, @JsonKey(name: 'url') this.url});
  factory _YearBookPhoto.fromJson(Map<String, dynamic> json) => _$YearBookPhotoFromJson(json);

@override@JsonKey(name: 'assetId') final  String assetId;
@override@JsonKey(name: 'url') final  String? url;

/// Create a copy of YearBookPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearBookPhotoCopyWith<_YearBookPhoto> get copyWith => __$YearBookPhotoCopyWithImpl<_YearBookPhoto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearBookPhotoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearBookPhoto&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,url);

@override
String toString() {
  return 'YearBookPhoto(assetId: $assetId, url: $url)';
}


}

/// @nodoc
abstract mixin class _$YearBookPhotoCopyWith<$Res> implements $YearBookPhotoCopyWith<$Res> {
  factory _$YearBookPhotoCopyWith(_YearBookPhoto value, $Res Function(_YearBookPhoto) _then) = __$YearBookPhotoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'assetId') String assetId,@JsonKey(name: 'url') String? url
});




}
/// @nodoc
class __$YearBookPhotoCopyWithImpl<$Res>
    implements _$YearBookPhotoCopyWith<$Res> {
  __$YearBookPhotoCopyWithImpl(this._self, this._then);

  final _YearBookPhoto _self;
  final $Res Function(_YearBookPhoto) _then;

/// Create a copy of YearBookPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = null,Object? url = freezed,}) {
  return _then(_YearBookPhoto(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$YearBookItem {

@JsonKey(name: 'memoryId') String get memoryId;@JsonKey(name: 'kind') String get kind;@JsonKey(name: 'occurredAt') String? get occurredAt;@JsonKey(name: 'caption') String get caption;@JsonKey(name: 'included') bool get included;@JsonKey(name: 'selectedAssetIds') List<String> get selectedAssetIds;@JsonKey(name: 'photos', fromJson: _yearBookPhotos) List<YearBookPhoto> get photos;
/// Create a copy of YearBookItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearBookItemCopyWith<YearBookItem> get copyWith => _$YearBookItemCopyWithImpl<YearBookItem>(this as YearBookItem, _$identity);

  /// Serializes this YearBookItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearBookItem&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.included, included) || other.included == included)&&const DeepCollectionEquality().equals(other.selectedAssetIds, selectedAssetIds)&&const DeepCollectionEquality().equals(other.photos, photos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memoryId,kind,occurredAt,caption,included,const DeepCollectionEquality().hash(selectedAssetIds),const DeepCollectionEquality().hash(photos));

@override
String toString() {
  return 'YearBookItem(memoryId: $memoryId, kind: $kind, occurredAt: $occurredAt, caption: $caption, included: $included, selectedAssetIds: $selectedAssetIds, photos: $photos)';
}


}

/// @nodoc
abstract mixin class $YearBookItemCopyWith<$Res>  {
  factory $YearBookItemCopyWith(YearBookItem value, $Res Function(YearBookItem) _then) = _$YearBookItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'memoryId') String memoryId,@JsonKey(name: 'kind') String kind,@JsonKey(name: 'occurredAt') String? occurredAt,@JsonKey(name: 'caption') String caption,@JsonKey(name: 'included') bool included,@JsonKey(name: 'selectedAssetIds') List<String> selectedAssetIds,@JsonKey(name: 'photos', fromJson: _yearBookPhotos) List<YearBookPhoto> photos
});




}
/// @nodoc
class _$YearBookItemCopyWithImpl<$Res>
    implements $YearBookItemCopyWith<$Res> {
  _$YearBookItemCopyWithImpl(this._self, this._then);

  final YearBookItem _self;
  final $Res Function(YearBookItem) _then;

/// Create a copy of YearBookItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memoryId = null,Object? kind = null,Object? occurredAt = freezed,Object? caption = null,Object? included = null,Object? selectedAssetIds = null,Object? photos = null,}) {
  return _then(_self.copyWith(
memoryId: null == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,occurredAt: freezed == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as String?,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,included: null == included ? _self.included : included // ignore: cast_nullable_to_non_nullable
as bool,selectedAssetIds: null == selectedAssetIds ? _self.selectedAssetIds : selectedAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<YearBookPhoto>,
  ));
}

}


/// Adds pattern-matching-related methods to [YearBookItem].
extension YearBookItemPatterns on YearBookItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearBookItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearBookItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearBookItem value)  $default,){
final _that = this;
switch (_that) {
case _YearBookItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearBookItem value)?  $default,){
final _that = this;
switch (_that) {
case _YearBookItem() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _YearBookItem implements YearBookItem {
  const _YearBookItem({@JsonKey(name: 'memoryId') required this.memoryId, @JsonKey(name: 'kind') this.kind = '', @JsonKey(name: 'occurredAt') this.occurredAt, @JsonKey(name: 'caption') this.caption = '', @JsonKey(name: 'included') this.included = false, @JsonKey(name: 'selectedAssetIds') final  List<String> selectedAssetIds = const <String>[], @JsonKey(name: 'photos', fromJson: _yearBookPhotos) final  List<YearBookPhoto> photos = const <YearBookPhoto>[]}): _selectedAssetIds = selectedAssetIds,_photos = photos;
  factory _YearBookItem.fromJson(Map<String, dynamic> json) => _$YearBookItemFromJson(json);

@override@JsonKey(name: 'memoryId') final  String memoryId;
@override@JsonKey(name: 'kind') final  String kind;
@override@JsonKey(name: 'occurredAt') final  String? occurredAt;
@override@JsonKey(name: 'caption') final  String caption;
@override@JsonKey(name: 'included') final  bool included;
 final  List<String> _selectedAssetIds;
@override@JsonKey(name: 'selectedAssetIds') List<String> get selectedAssetIds {
  if (_selectedAssetIds is EqualUnmodifiableListView) return _selectedAssetIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedAssetIds);
}

 final  List<YearBookPhoto> _photos;
@override@JsonKey(name: 'photos', fromJson: _yearBookPhotos) List<YearBookPhoto> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}


/// Create a copy of YearBookItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearBookItemCopyWith<_YearBookItem> get copyWith => __$YearBookItemCopyWithImpl<_YearBookItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearBookItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearBookItem&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.included, included) || other.included == included)&&const DeepCollectionEquality().equals(other._selectedAssetIds, _selectedAssetIds)&&const DeepCollectionEquality().equals(other._photos, _photos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memoryId,kind,occurredAt,caption,included,const DeepCollectionEquality().hash(_selectedAssetIds),const DeepCollectionEquality().hash(_photos));

@override
String toString() {
  return 'YearBookItem(memoryId: $memoryId, kind: $kind, occurredAt: $occurredAt, caption: $caption, included: $included, selectedAssetIds: $selectedAssetIds, photos: $photos)';
}


}

/// @nodoc
abstract mixin class _$YearBookItemCopyWith<$Res> implements $YearBookItemCopyWith<$Res> {
  factory _$YearBookItemCopyWith(_YearBookItem value, $Res Function(_YearBookItem) _then) = __$YearBookItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'memoryId') String memoryId,@JsonKey(name: 'kind') String kind,@JsonKey(name: 'occurredAt') String? occurredAt,@JsonKey(name: 'caption') String caption,@JsonKey(name: 'included') bool included,@JsonKey(name: 'selectedAssetIds') List<String> selectedAssetIds,@JsonKey(name: 'photos', fromJson: _yearBookPhotos) List<YearBookPhoto> photos
});




}
/// @nodoc
class __$YearBookItemCopyWithImpl<$Res>
    implements _$YearBookItemCopyWith<$Res> {
  __$YearBookItemCopyWithImpl(this._self, this._then);

  final _YearBookItem _self;
  final $Res Function(_YearBookItem) _then;

/// Create a copy of YearBookItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memoryId = null,Object? kind = null,Object? occurredAt = freezed,Object? caption = null,Object? included = null,Object? selectedAssetIds = null,Object? photos = null,}) {
  return _then(_YearBookItem(
memoryId: null == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,occurredAt: freezed == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as String?,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,included: null == included ? _self.included : included // ignore: cast_nullable_to_non_nullable
as bool,selectedAssetIds: null == selectedAssetIds ? _self._selectedAssetIds : selectedAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<YearBookPhoto>,
  ));
}


}


/// @nodoc
mixin _$YearBookChapter {

@JsonKey(name: 'month') int get month;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'items', fromJson: _yearBookItems) List<YearBookItem> get items;
/// Create a copy of YearBookChapter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearBookChapterCopyWith<YearBookChapter> get copyWith => _$YearBookChapterCopyWithImpl<YearBookChapter>(this as YearBookChapter, _$identity);

  /// Serializes this YearBookChapter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearBookChapter&&(identical(other.month, month) || other.month == month)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,title,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'YearBookChapter(month: $month, title: $title, items: $items)';
}


}

/// @nodoc
abstract mixin class $YearBookChapterCopyWith<$Res>  {
  factory $YearBookChapterCopyWith(YearBookChapter value, $Res Function(YearBookChapter) _then) = _$YearBookChapterCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'month') int month,@JsonKey(name: 'title') String? title,@JsonKey(name: 'items', fromJson: _yearBookItems) List<YearBookItem> items
});




}
/// @nodoc
class _$YearBookChapterCopyWithImpl<$Res>
    implements $YearBookChapterCopyWith<$Res> {
  _$YearBookChapterCopyWithImpl(this._self, this._then);

  final YearBookChapter _self;
  final $Res Function(YearBookChapter) _then;

/// Create a copy of YearBookChapter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? title = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<YearBookItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [YearBookChapter].
extension YearBookChapterPatterns on YearBookChapter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearBookChapter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearBookChapter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearBookChapter value)  $default,){
final _that = this;
switch (_that) {
case _YearBookChapter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearBookChapter value)?  $default,){
final _that = this;
switch (_that) {
case _YearBookChapter() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _YearBookChapter implements YearBookChapter {
  const _YearBookChapter({@JsonKey(name: 'month') required this.month, @JsonKey(name: 'title') this.title, @JsonKey(name: 'items', fromJson: _yearBookItems) final  List<YearBookItem> items = const <YearBookItem>[]}): _items = items;
  factory _YearBookChapter.fromJson(Map<String, dynamic> json) => _$YearBookChapterFromJson(json);

@override@JsonKey(name: 'month') final  int month;
@override@JsonKey(name: 'title') final  String? title;
 final  List<YearBookItem> _items;
@override@JsonKey(name: 'items', fromJson: _yearBookItems) List<YearBookItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of YearBookChapter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearBookChapterCopyWith<_YearBookChapter> get copyWith => __$YearBookChapterCopyWithImpl<_YearBookChapter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearBookChapterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearBookChapter&&(identical(other.month, month) || other.month == month)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,title,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'YearBookChapter(month: $month, title: $title, items: $items)';
}


}

/// @nodoc
abstract mixin class _$YearBookChapterCopyWith<$Res> implements $YearBookChapterCopyWith<$Res> {
  factory _$YearBookChapterCopyWith(_YearBookChapter value, $Res Function(_YearBookChapter) _then) = __$YearBookChapterCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'month') int month,@JsonKey(name: 'title') String? title,@JsonKey(name: 'items', fromJson: _yearBookItems) List<YearBookItem> items
});




}
/// @nodoc
class __$YearBookChapterCopyWithImpl<$Res>
    implements _$YearBookChapterCopyWith<$Res> {
  __$YearBookChapterCopyWithImpl(this._self, this._then);

  final _YearBookChapter _self;
  final $Res Function(_YearBookChapter) _then;

/// Create a copy of YearBookChapter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? title = freezed,Object? items = null,}) {
  return _then(_YearBookChapter(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<YearBookItem>,
  ));
}


}


/// @nodoc
mixin _$YearBookRecord {

/// null = sách cả nhà (BF-20261030-001).
@JsonKey(name: 'childId') String? get childId;@JsonKey(name: 'year') int get year;@JsonKey(name: 'childName') String get childName;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'canExport') bool get canExport;/// Bản cho ông bà (BF-20261030-002): gói cho phép chia sẻ / đang chia sẻ
/// / người thân đang đọc (chỉ đọc).
@JsonKey(name: 'canShare') bool get canShare;@JsonKey(name: 'sharedWithCircle') bool get sharedWithCircle;@JsonKey(name: 'readOnly') bool get readOnly;@JsonKey(name: 'saved') bool get saved;@JsonKey(name: 'pending') bool get pending;@JsonKey(name: 'chapters', fromJson: _yearBookChapters) List<YearBookChapter> get chapters;
/// Create a copy of YearBookRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearBookRecordCopyWith<YearBookRecord> get copyWith => _$YearBookRecordCopyWithImpl<YearBookRecord>(this as YearBookRecord, _$identity);

  /// Serializes this YearBookRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearBookRecord&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.year, year) || other.year == year)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.title, title) || other.title == title)&&(identical(other.canExport, canExport) || other.canExport == canExport)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.sharedWithCircle, sharedWithCircle) || other.sharedWithCircle == sharedWithCircle)&&(identical(other.readOnly, readOnly) || other.readOnly == readOnly)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.pending, pending) || other.pending == pending)&&const DeepCollectionEquality().equals(other.chapters, chapters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,year,childName,title,canExport,canShare,sharedWithCircle,readOnly,saved,pending,const DeepCollectionEquality().hash(chapters));

@override
String toString() {
  return 'YearBookRecord(childId: $childId, year: $year, childName: $childName, title: $title, canExport: $canExport, canShare: $canShare, sharedWithCircle: $sharedWithCircle, readOnly: $readOnly, saved: $saved, pending: $pending, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class $YearBookRecordCopyWith<$Res>  {
  factory $YearBookRecordCopyWith(YearBookRecord value, $Res Function(YearBookRecord) _then) = _$YearBookRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'year') int year,@JsonKey(name: 'childName') String childName,@JsonKey(name: 'title') String? title,@JsonKey(name: 'canExport') bool canExport,@JsonKey(name: 'canShare') bool canShare,@JsonKey(name: 'sharedWithCircle') bool sharedWithCircle,@JsonKey(name: 'readOnly') bool readOnly,@JsonKey(name: 'saved') bool saved,@JsonKey(name: 'pending') bool pending,@JsonKey(name: 'chapters', fromJson: _yearBookChapters) List<YearBookChapter> chapters
});




}
/// @nodoc
class _$YearBookRecordCopyWithImpl<$Res>
    implements $YearBookRecordCopyWith<$Res> {
  _$YearBookRecordCopyWithImpl(this._self, this._then);

  final YearBookRecord _self;
  final $Res Function(YearBookRecord) _then;

/// Create a copy of YearBookRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childId = freezed,Object? year = null,Object? childName = null,Object? title = freezed,Object? canExport = null,Object? canShare = null,Object? sharedWithCircle = null,Object? readOnly = null,Object? saved = null,Object? pending = null,Object? chapters = null,}) {
  return _then(_self.copyWith(
childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,canExport: null == canExport ? _self.canExport : canExport // ignore: cast_nullable_to_non_nullable
as bool,canShare: null == canShare ? _self.canShare : canShare // ignore: cast_nullable_to_non_nullable
as bool,sharedWithCircle: null == sharedWithCircle ? _self.sharedWithCircle : sharedWithCircle // ignore: cast_nullable_to_non_nullable
as bool,readOnly: null == readOnly ? _self.readOnly : readOnly // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as bool,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<YearBookChapter>,
  ));
}

}


/// Adds pattern-matching-related methods to [YearBookRecord].
extension YearBookRecordPatterns on YearBookRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearBookRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearBookRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearBookRecord value)  $default,){
final _that = this;
switch (_that) {
case _YearBookRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearBookRecord value)?  $default,){
final _that = this;
switch (_that) {
case _YearBookRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _YearBookRecord extends YearBookRecord {
  const _YearBookRecord({@JsonKey(name: 'childId') this.childId, @JsonKey(name: 'year') required this.year, @JsonKey(name: 'childName') this.childName = '', @JsonKey(name: 'title') this.title, @JsonKey(name: 'canExport') this.canExport = false, @JsonKey(name: 'canShare') this.canShare = false, @JsonKey(name: 'sharedWithCircle') this.sharedWithCircle = false, @JsonKey(name: 'readOnly') this.readOnly = false, @JsonKey(name: 'saved') this.saved = false, @JsonKey(name: 'pending') this.pending = false, @JsonKey(name: 'chapters', fromJson: _yearBookChapters) final  List<YearBookChapter> chapters = const <YearBookChapter>[]}): _chapters = chapters,super._();
  factory _YearBookRecord.fromJson(Map<String, dynamic> json) => _$YearBookRecordFromJson(json);

/// null = sách cả nhà (BF-20261030-001).
@override@JsonKey(name: 'childId') final  String? childId;
@override@JsonKey(name: 'year') final  int year;
@override@JsonKey(name: 'childName') final  String childName;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'canExport') final  bool canExport;
/// Bản cho ông bà (BF-20261030-002): gói cho phép chia sẻ / đang chia sẻ
/// / người thân đang đọc (chỉ đọc).
@override@JsonKey(name: 'canShare') final  bool canShare;
@override@JsonKey(name: 'sharedWithCircle') final  bool sharedWithCircle;
@override@JsonKey(name: 'readOnly') final  bool readOnly;
@override@JsonKey(name: 'saved') final  bool saved;
@override@JsonKey(name: 'pending') final  bool pending;
 final  List<YearBookChapter> _chapters;
@override@JsonKey(name: 'chapters', fromJson: _yearBookChapters) List<YearBookChapter> get chapters {
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chapters);
}


/// Create a copy of YearBookRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearBookRecordCopyWith<_YearBookRecord> get copyWith => __$YearBookRecordCopyWithImpl<_YearBookRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearBookRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearBookRecord&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.year, year) || other.year == year)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.title, title) || other.title == title)&&(identical(other.canExport, canExport) || other.canExport == canExport)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.sharedWithCircle, sharedWithCircle) || other.sharedWithCircle == sharedWithCircle)&&(identical(other.readOnly, readOnly) || other.readOnly == readOnly)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.pending, pending) || other.pending == pending)&&const DeepCollectionEquality().equals(other._chapters, _chapters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,year,childName,title,canExport,canShare,sharedWithCircle,readOnly,saved,pending,const DeepCollectionEquality().hash(_chapters));

@override
String toString() {
  return 'YearBookRecord(childId: $childId, year: $year, childName: $childName, title: $title, canExport: $canExport, canShare: $canShare, sharedWithCircle: $sharedWithCircle, readOnly: $readOnly, saved: $saved, pending: $pending, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class _$YearBookRecordCopyWith<$Res> implements $YearBookRecordCopyWith<$Res> {
  factory _$YearBookRecordCopyWith(_YearBookRecord value, $Res Function(_YearBookRecord) _then) = __$YearBookRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'year') int year,@JsonKey(name: 'childName') String childName,@JsonKey(name: 'title') String? title,@JsonKey(name: 'canExport') bool canExport,@JsonKey(name: 'canShare') bool canShare,@JsonKey(name: 'sharedWithCircle') bool sharedWithCircle,@JsonKey(name: 'readOnly') bool readOnly,@JsonKey(name: 'saved') bool saved,@JsonKey(name: 'pending') bool pending,@JsonKey(name: 'chapters', fromJson: _yearBookChapters) List<YearBookChapter> chapters
});




}
/// @nodoc
class __$YearBookRecordCopyWithImpl<$Res>
    implements _$YearBookRecordCopyWith<$Res> {
  __$YearBookRecordCopyWithImpl(this._self, this._then);

  final _YearBookRecord _self;
  final $Res Function(_YearBookRecord) _then;

/// Create a copy of YearBookRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childId = freezed,Object? year = null,Object? childName = null,Object? title = freezed,Object? canExport = null,Object? canShare = null,Object? sharedWithCircle = null,Object? readOnly = null,Object? saved = null,Object? pending = null,Object? chapters = null,}) {
  return _then(_YearBookRecord(
childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,canExport: null == canExport ? _self.canExport : canExport // ignore: cast_nullable_to_non_nullable
as bool,canShare: null == canShare ? _self.canShare : canShare // ignore: cast_nullable_to_non_nullable
as bool,sharedWithCircle: null == sharedWithCircle ? _self.sharedWithCircle : sharedWithCircle // ignore: cast_nullable_to_non_nullable
as bool,readOnly: null == readOnly ? _self.readOnly : readOnly // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as bool,chapters: null == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<YearBookChapter>,
  ));
}


}


/// @nodoc
mixin _$YearBookSummary {

@JsonKey(name: 'scope') String get scope;@JsonKey(name: 'childId') String? get childId;@JsonKey(name: 'name') String get name;@JsonKey(name: 'year') int get year;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'sharedWithCircle') bool get sharedWithCircle;
/// Create a copy of YearBookSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearBookSummaryCopyWith<YearBookSummary> get copyWith => _$YearBookSummaryCopyWithImpl<YearBookSummary>(this as YearBookSummary, _$identity);

  /// Serializes this YearBookSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearBookSummary&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.name, name) || other.name == name)&&(identical(other.year, year) || other.year == year)&&(identical(other.title, title) || other.title == title)&&(identical(other.sharedWithCircle, sharedWithCircle) || other.sharedWithCircle == sharedWithCircle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scope,childId,name,year,title,sharedWithCircle);

@override
String toString() {
  return 'YearBookSummary(scope: $scope, childId: $childId, name: $name, year: $year, title: $title, sharedWithCircle: $sharedWithCircle)';
}


}

/// @nodoc
abstract mixin class $YearBookSummaryCopyWith<$Res>  {
  factory $YearBookSummaryCopyWith(YearBookSummary value, $Res Function(YearBookSummary) _then) = _$YearBookSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'scope') String scope,@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'name') String name,@JsonKey(name: 'year') int year,@JsonKey(name: 'title') String? title,@JsonKey(name: 'sharedWithCircle') bool sharedWithCircle
});




}
/// @nodoc
class _$YearBookSummaryCopyWithImpl<$Res>
    implements $YearBookSummaryCopyWith<$Res> {
  _$YearBookSummaryCopyWithImpl(this._self, this._then);

  final YearBookSummary _self;
  final $Res Function(YearBookSummary) _then;

/// Create a copy of YearBookSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scope = null,Object? childId = freezed,Object? name = null,Object? year = null,Object? title = freezed,Object? sharedWithCircle = null,}) {
  return _then(_self.copyWith(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,sharedWithCircle: null == sharedWithCircle ? _self.sharedWithCircle : sharedWithCircle // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [YearBookSummary].
extension YearBookSummaryPatterns on YearBookSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearBookSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearBookSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearBookSummary value)  $default,){
final _that = this;
switch (_that) {
case _YearBookSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearBookSummary value)?  $default,){
final _that = this;
switch (_that) {
case _YearBookSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _YearBookSummary implements YearBookSummary {
  const _YearBookSummary({@JsonKey(name: 'scope') this.scope = 'CHILD', @JsonKey(name: 'childId') this.childId, @JsonKey(name: 'name') this.name = '', @JsonKey(name: 'year') required this.year, @JsonKey(name: 'title') this.title, @JsonKey(name: 'sharedWithCircle') this.sharedWithCircle = false});
  factory _YearBookSummary.fromJson(Map<String, dynamic> json) => _$YearBookSummaryFromJson(json);

@override@JsonKey(name: 'scope') final  String scope;
@override@JsonKey(name: 'childId') final  String? childId;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'year') final  int year;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'sharedWithCircle') final  bool sharedWithCircle;

/// Create a copy of YearBookSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearBookSummaryCopyWith<_YearBookSummary> get copyWith => __$YearBookSummaryCopyWithImpl<_YearBookSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearBookSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearBookSummary&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.name, name) || other.name == name)&&(identical(other.year, year) || other.year == year)&&(identical(other.title, title) || other.title == title)&&(identical(other.sharedWithCircle, sharedWithCircle) || other.sharedWithCircle == sharedWithCircle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scope,childId,name,year,title,sharedWithCircle);

@override
String toString() {
  return 'YearBookSummary(scope: $scope, childId: $childId, name: $name, year: $year, title: $title, sharedWithCircle: $sharedWithCircle)';
}


}

/// @nodoc
abstract mixin class _$YearBookSummaryCopyWith<$Res> implements $YearBookSummaryCopyWith<$Res> {
  factory _$YearBookSummaryCopyWith(_YearBookSummary value, $Res Function(_YearBookSummary) _then) = __$YearBookSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'scope') String scope,@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'name') String name,@JsonKey(name: 'year') int year,@JsonKey(name: 'title') String? title,@JsonKey(name: 'sharedWithCircle') bool sharedWithCircle
});




}
/// @nodoc
class __$YearBookSummaryCopyWithImpl<$Res>
    implements _$YearBookSummaryCopyWith<$Res> {
  __$YearBookSummaryCopyWithImpl(this._self, this._then);

  final _YearBookSummary _self;
  final $Res Function(_YearBookSummary) _then;

/// Create a copy of YearBookSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scope = null,Object? childId = freezed,Object? name = null,Object? year = null,Object? title = freezed,Object? sharedWithCircle = null,}) {
  return _then(_YearBookSummary(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,sharedWithCircle: null == sharedWithCircle ? _self.sharedWithCircle : sharedWithCircle // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$YearBookList {

@JsonKey(name: 'items', fromJson: _yearBookSummaries) List<YearBookSummary> get items;
/// Create a copy of YearBookList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearBookListCopyWith<YearBookList> get copyWith => _$YearBookListCopyWithImpl<YearBookList>(this as YearBookList, _$identity);

  /// Serializes this YearBookList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearBookList&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'YearBookList(items: $items)';
}


}

/// @nodoc
abstract mixin class $YearBookListCopyWith<$Res>  {
  factory $YearBookListCopyWith(YearBookList value, $Res Function(YearBookList) _then) = _$YearBookListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items', fromJson: _yearBookSummaries) List<YearBookSummary> items
});




}
/// @nodoc
class _$YearBookListCopyWithImpl<$Res>
    implements $YearBookListCopyWith<$Res> {
  _$YearBookListCopyWithImpl(this._self, this._then);

  final YearBookList _self;
  final $Res Function(YearBookList) _then;

/// Create a copy of YearBookList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<YearBookSummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [YearBookList].
extension YearBookListPatterns on YearBookList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearBookList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearBookList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearBookList value)  $default,){
final _that = this;
switch (_that) {
case _YearBookList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearBookList value)?  $default,){
final _that = this;
switch (_that) {
case _YearBookList() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _YearBookList implements YearBookList {
  const _YearBookList({@JsonKey(name: 'items', fromJson: _yearBookSummaries) final  List<YearBookSummary> items = const <YearBookSummary>[]}): _items = items;
  factory _YearBookList.fromJson(Map<String, dynamic> json) => _$YearBookListFromJson(json);

 final  List<YearBookSummary> _items;
@override@JsonKey(name: 'items', fromJson: _yearBookSummaries) List<YearBookSummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of YearBookList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearBookListCopyWith<_YearBookList> get copyWith => __$YearBookListCopyWithImpl<_YearBookList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearBookListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearBookList&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'YearBookList(items: $items)';
}


}

/// @nodoc
abstract mixin class _$YearBookListCopyWith<$Res> implements $YearBookListCopyWith<$Res> {
  factory _$YearBookListCopyWith(_YearBookList value, $Res Function(_YearBookList) _then) = __$YearBookListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items', fromJson: _yearBookSummaries) List<YearBookSummary> items
});




}
/// @nodoc
class __$YearBookListCopyWithImpl<$Res>
    implements _$YearBookListCopyWith<$Res> {
  __$YearBookListCopyWithImpl(this._self, this._then);

  final _YearBookList _self;
  final $Res Function(_YearBookList) _then;

/// Create a copy of YearBookList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_YearBookList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<YearBookSummary>,
  ));
}


}

// dart format on
