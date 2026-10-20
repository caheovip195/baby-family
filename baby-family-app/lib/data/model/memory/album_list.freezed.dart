// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlbumList {

@JsonKey(name: 'items') List<AlbumRecord> get items;
/// Create a copy of AlbumList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumListCopyWith<AlbumList> get copyWith => _$AlbumListCopyWithImpl<AlbumList>(this as AlbumList, _$identity);

  /// Serializes this AlbumList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlbumList&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'AlbumList(items: $items)';
}


}

/// @nodoc
abstract mixin class $AlbumListCopyWith<$Res>  {
  factory $AlbumListCopyWith(AlbumList value, $Res Function(AlbumList) _then) = _$AlbumListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items') List<AlbumRecord> items
});




}
/// @nodoc
class _$AlbumListCopyWithImpl<$Res>
    implements $AlbumListCopyWith<$Res> {
  _$AlbumListCopyWithImpl(this._self, this._then);

  final AlbumList _self;
  final $Res Function(AlbumList) _then;

/// Create a copy of AlbumList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AlbumRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [AlbumList].
extension AlbumListPatterns on AlbumList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlbumList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlbumList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlbumList value)  $default,){
final _that = this;
switch (_that) {
case _AlbumList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlbumList value)?  $default,){
final _that = this;
switch (_that) {
case _AlbumList() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AlbumList implements AlbumList {
  const _AlbumList({@JsonKey(name: 'items') final  List<AlbumRecord> items = const <AlbumRecord>[]}): _items = items;
  factory _AlbumList.fromJson(Map<String, dynamic> json) => _$AlbumListFromJson(json);

 final  List<AlbumRecord> _items;
@override@JsonKey(name: 'items') List<AlbumRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of AlbumList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumListCopyWith<_AlbumList> get copyWith => __$AlbumListCopyWithImpl<_AlbumList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlbumListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlbumList&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'AlbumList(items: $items)';
}


}

/// @nodoc
abstract mixin class _$AlbumListCopyWith<$Res> implements $AlbumListCopyWith<$Res> {
  factory _$AlbumListCopyWith(_AlbumList value, $Res Function(_AlbumList) _then) = __$AlbumListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items') List<AlbumRecord> items
});




}
/// @nodoc
class __$AlbumListCopyWithImpl<$Res>
    implements _$AlbumListCopyWith<$Res> {
  __$AlbumListCopyWithImpl(this._self, this._then);

  final _AlbumList _self;
  final $Res Function(_AlbumList) _then;

/// Create a copy of AlbumList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_AlbumList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AlbumRecord>,
  ));
}


}

// dart format on
