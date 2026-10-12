// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Album {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'title') String get title;@JsonKey(name: 'isAuto') bool get isAuto;@JsonKey(name: 'autoCode') String? get autoCode;@JsonKey(name: 'coverAsset') String? get coverAsset;@JsonKey(name: 'coverIcon') String? get coverIcon;@JsonKey(name: 'memoryCount') int get memoryCount;@JsonKey(name: 'childIds') List<String> get childIds;@JsonKey(name: 'createdByUserId') String? get createdByUserId;@JsonKey(name: 'startDate') DateTime? get startDate;@JsonKey(name: 'endDate') DateTime? get endDate;@JsonKey(name: 'visibility') MemoryVisibility get visibility;@JsonKey(name: 'items') List<AlbumItem> get items;
/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumCopyWith<Album> get copyWith => _$AlbumCopyWithImpl<Album>(this as Album, _$identity);

  /// Serializes this Album to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Album&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.isAuto, isAuto) || other.isAuto == isAuto)&&(identical(other.autoCode, autoCode) || other.autoCode == autoCode)&&(identical(other.coverAsset, coverAsset) || other.coverAsset == coverAsset)&&(identical(other.coverIcon, coverIcon) || other.coverIcon == coverIcon)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&const DeepCollectionEquality().equals(other.childIds, childIds)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,isAuto,autoCode,coverAsset,coverIcon,memoryCount,const DeepCollectionEquality().hash(childIds),createdByUserId,startDate,endDate,visibility,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'Album(id: $id, title: $title, isAuto: $isAuto, autoCode: $autoCode, coverAsset: $coverAsset, coverIcon: $coverIcon, memoryCount: $memoryCount, childIds: $childIds, createdByUserId: $createdByUserId, startDate: $startDate, endDate: $endDate, visibility: $visibility, items: $items)';
}


}

/// @nodoc
abstract mixin class $AlbumCopyWith<$Res>  {
  factory $AlbumCopyWith(Album value, $Res Function(Album) _then) = _$AlbumCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'title') String title,@JsonKey(name: 'isAuto') bool isAuto,@JsonKey(name: 'autoCode') String? autoCode,@JsonKey(name: 'coverAsset') String? coverAsset,@JsonKey(name: 'coverIcon') String? coverIcon,@JsonKey(name: 'memoryCount') int memoryCount,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'createdByUserId') String? createdByUserId,@JsonKey(name: 'startDate') DateTime? startDate,@JsonKey(name: 'endDate') DateTime? endDate,@JsonKey(name: 'visibility') MemoryVisibility visibility,@JsonKey(name: 'items') List<AlbumItem> items
});




}
/// @nodoc
class _$AlbumCopyWithImpl<$Res>
    implements $AlbumCopyWith<$Res> {
  _$AlbumCopyWithImpl(this._self, this._then);

  final Album _self;
  final $Res Function(Album) _then;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? isAuto = null,Object? autoCode = freezed,Object? coverAsset = freezed,Object? coverIcon = freezed,Object? memoryCount = null,Object? childIds = null,Object? createdByUserId = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? visibility = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isAuto: null == isAuto ? _self.isAuto : isAuto // ignore: cast_nullable_to_non_nullable
as bool,autoCode: freezed == autoCode ? _self.autoCode : autoCode // ignore: cast_nullable_to_non_nullable
as String?,coverAsset: freezed == coverAsset ? _self.coverAsset : coverAsset // ignore: cast_nullable_to_non_nullable
as String?,coverIcon: freezed == coverIcon ? _self.coverIcon : coverIcon // ignore: cast_nullable_to_non_nullable
as String?,memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as MemoryVisibility,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AlbumItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [Album].
extension AlbumPatterns on Album {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Album value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Album() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Album value)  $default,){
final _that = this;
switch (_that) {
case _Album():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Album value)?  $default,){
final _that = this;
switch (_that) {
case _Album() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Album implements Album {
  const _Album({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'isAuto') this.isAuto = false, @JsonKey(name: 'autoCode') this.autoCode, @JsonKey(name: 'coverAsset') this.coverAsset, @JsonKey(name: 'coverIcon') this.coverIcon, @JsonKey(name: 'memoryCount') this.memoryCount = 0, @JsonKey(name: 'childIds') final  List<String> childIds = const [], @JsonKey(name: 'createdByUserId') this.createdByUserId, @JsonKey(name: 'startDate') this.startDate, @JsonKey(name: 'endDate') this.endDate, @JsonKey(name: 'visibility') this.visibility = MemoryVisibility.family, @JsonKey(name: 'items') final  List<AlbumItem> items = const []}): _childIds = childIds,_items = items;
  factory _Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'isAuto') final  bool isAuto;
@override@JsonKey(name: 'autoCode') final  String? autoCode;
@override@JsonKey(name: 'coverAsset') final  String? coverAsset;
@override@JsonKey(name: 'coverIcon') final  String? coverIcon;
@override@JsonKey(name: 'memoryCount') final  int memoryCount;
 final  List<String> _childIds;
@override@JsonKey(name: 'childIds') List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}

@override@JsonKey(name: 'createdByUserId') final  String? createdByUserId;
@override@JsonKey(name: 'startDate') final  DateTime? startDate;
@override@JsonKey(name: 'endDate') final  DateTime? endDate;
@override@JsonKey(name: 'visibility') final  MemoryVisibility visibility;
 final  List<AlbumItem> _items;
@override@JsonKey(name: 'items') List<AlbumItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumCopyWith<_Album> get copyWith => __$AlbumCopyWithImpl<_Album>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlbumToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Album&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.isAuto, isAuto) || other.isAuto == isAuto)&&(identical(other.autoCode, autoCode) || other.autoCode == autoCode)&&(identical(other.coverAsset, coverAsset) || other.coverAsset == coverAsset)&&(identical(other.coverIcon, coverIcon) || other.coverIcon == coverIcon)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&const DeepCollectionEquality().equals(other._childIds, _childIds)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,isAuto,autoCode,coverAsset,coverIcon,memoryCount,const DeepCollectionEquality().hash(_childIds),createdByUserId,startDate,endDate,visibility,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'Album(id: $id, title: $title, isAuto: $isAuto, autoCode: $autoCode, coverAsset: $coverAsset, coverIcon: $coverIcon, memoryCount: $memoryCount, childIds: $childIds, createdByUserId: $createdByUserId, startDate: $startDate, endDate: $endDate, visibility: $visibility, items: $items)';
}


}

/// @nodoc
abstract mixin class _$AlbumCopyWith<$Res> implements $AlbumCopyWith<$Res> {
  factory _$AlbumCopyWith(_Album value, $Res Function(_Album) _then) = __$AlbumCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'title') String title,@JsonKey(name: 'isAuto') bool isAuto,@JsonKey(name: 'autoCode') String? autoCode,@JsonKey(name: 'coverAsset') String? coverAsset,@JsonKey(name: 'coverIcon') String? coverIcon,@JsonKey(name: 'memoryCount') int memoryCount,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'createdByUserId') String? createdByUserId,@JsonKey(name: 'startDate') DateTime? startDate,@JsonKey(name: 'endDate') DateTime? endDate,@JsonKey(name: 'visibility') MemoryVisibility visibility,@JsonKey(name: 'items') List<AlbumItem> items
});




}
/// @nodoc
class __$AlbumCopyWithImpl<$Res>
    implements _$AlbumCopyWith<$Res> {
  __$AlbumCopyWithImpl(this._self, this._then);

  final _Album _self;
  final $Res Function(_Album) _then;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? isAuto = null,Object? autoCode = freezed,Object? coverAsset = freezed,Object? coverIcon = freezed,Object? memoryCount = null,Object? childIds = null,Object? createdByUserId = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? visibility = null,Object? items = null,}) {
  return _then(_Album(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isAuto: null == isAuto ? _self.isAuto : isAuto // ignore: cast_nullable_to_non_nullable
as bool,autoCode: freezed == autoCode ? _self.autoCode : autoCode // ignore: cast_nullable_to_non_nullable
as String?,coverAsset: freezed == coverAsset ? _self.coverAsset : coverAsset // ignore: cast_nullable_to_non_nullable
as String?,coverIcon: freezed == coverIcon ? _self.coverIcon : coverIcon // ignore: cast_nullable_to_non_nullable
as String?,memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as MemoryVisibility,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AlbumItem>,
  ));
}


}

// dart format on
