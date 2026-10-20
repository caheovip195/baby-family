// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocked_user_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockedUserList {

@JsonKey(name: 'items') List<BlockedUserRecord> get items;
/// Create a copy of BlockedUserList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockedUserListCopyWith<BlockedUserList> get copyWith => _$BlockedUserListCopyWithImpl<BlockedUserList>(this as BlockedUserList, _$identity);

  /// Serializes this BlockedUserList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockedUserList&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'BlockedUserList(items: $items)';
}


}

/// @nodoc
abstract mixin class $BlockedUserListCopyWith<$Res>  {
  factory $BlockedUserListCopyWith(BlockedUserList value, $Res Function(BlockedUserList) _then) = _$BlockedUserListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items') List<BlockedUserRecord> items
});




}
/// @nodoc
class _$BlockedUserListCopyWithImpl<$Res>
    implements $BlockedUserListCopyWith<$Res> {
  _$BlockedUserListCopyWithImpl(this._self, this._then);

  final BlockedUserList _self;
  final $Res Function(BlockedUserList) _then;

/// Create a copy of BlockedUserList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BlockedUserRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [BlockedUserList].
extension BlockedUserListPatterns on BlockedUserList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlockedUserList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlockedUserList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlockedUserList value)  $default,){
final _that = this;
switch (_that) {
case _BlockedUserList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlockedUserList value)?  $default,){
final _that = this;
switch (_that) {
case _BlockedUserList() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BlockedUserList implements BlockedUserList {
  const _BlockedUserList({@JsonKey(name: 'items') final  List<BlockedUserRecord> items = const <BlockedUserRecord>[]}): _items = items;
  factory _BlockedUserList.fromJson(Map<String, dynamic> json) => _$BlockedUserListFromJson(json);

 final  List<BlockedUserRecord> _items;
@override@JsonKey(name: 'items') List<BlockedUserRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of BlockedUserList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockedUserListCopyWith<_BlockedUserList> get copyWith => __$BlockedUserListCopyWithImpl<_BlockedUserList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockedUserListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockedUserList&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'BlockedUserList(items: $items)';
}


}

/// @nodoc
abstract mixin class _$BlockedUserListCopyWith<$Res> implements $BlockedUserListCopyWith<$Res> {
  factory _$BlockedUserListCopyWith(_BlockedUserList value, $Res Function(_BlockedUserList) _then) = __$BlockedUserListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items') List<BlockedUserRecord> items
});




}
/// @nodoc
class __$BlockedUserListCopyWithImpl<$Res>
    implements _$BlockedUserListCopyWith<$Res> {
  __$BlockedUserListCopyWithImpl(this._self, this._then);

  final _BlockedUserList _self;
  final $Res Function(_BlockedUserList) _then;

/// Create a copy of BlockedUserList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_BlockedUserList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BlockedUserRecord>,
  ));
}


}

// dart format on
