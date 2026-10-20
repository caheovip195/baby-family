// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BadgeList {

@JsonKey(name: 'items') List<BadgeRecord> get items;
/// Create a copy of BadgeList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadgeListCopyWith<BadgeList> get copyWith => _$BadgeListCopyWithImpl<BadgeList>(this as BadgeList, _$identity);

  /// Serializes this BadgeList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadgeList&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'BadgeList(items: $items)';
}


}

/// @nodoc
abstract mixin class $BadgeListCopyWith<$Res>  {
  factory $BadgeListCopyWith(BadgeList value, $Res Function(BadgeList) _then) = _$BadgeListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items') List<BadgeRecord> items
});




}
/// @nodoc
class _$BadgeListCopyWithImpl<$Res>
    implements $BadgeListCopyWith<$Res> {
  _$BadgeListCopyWithImpl(this._self, this._then);

  final BadgeList _self;
  final $Res Function(BadgeList) _then;

/// Create a copy of BadgeList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BadgeRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [BadgeList].
extension BadgeListPatterns on BadgeList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BadgeList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BadgeList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BadgeList value)  $default,){
final _that = this;
switch (_that) {
case _BadgeList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BadgeList value)?  $default,){
final _that = this;
switch (_that) {
case _BadgeList() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BadgeList implements BadgeList {
  const _BadgeList({@JsonKey(name: 'items') final  List<BadgeRecord> items = const <BadgeRecord>[]}): _items = items;
  factory _BadgeList.fromJson(Map<String, dynamic> json) => _$BadgeListFromJson(json);

 final  List<BadgeRecord> _items;
@override@JsonKey(name: 'items') List<BadgeRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of BadgeList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BadgeListCopyWith<_BadgeList> get copyWith => __$BadgeListCopyWithImpl<_BadgeList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BadgeListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BadgeList&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'BadgeList(items: $items)';
}


}

/// @nodoc
abstract mixin class _$BadgeListCopyWith<$Res> implements $BadgeListCopyWith<$Res> {
  factory _$BadgeListCopyWith(_BadgeList value, $Res Function(_BadgeList) _then) = __$BadgeListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items') List<BadgeRecord> items
});




}
/// @nodoc
class __$BadgeListCopyWithImpl<$Res>
    implements _$BadgeListCopyWith<$Res> {
  __$BadgeListCopyWithImpl(this._self, this._then);

  final _BadgeList _self;
  final $Res Function(_BadgeList) _then;

/// Create a copy of BadgeList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_BadgeList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BadgeRecord>,
  ));
}


}

// dart format on
