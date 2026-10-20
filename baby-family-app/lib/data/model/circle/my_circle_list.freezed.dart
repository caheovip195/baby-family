// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_circle_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyCircleList {

@JsonKey(name: 'items') List<MyCircleRecord> get items;
/// Create a copy of MyCircleList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyCircleListCopyWith<MyCircleList> get copyWith => _$MyCircleListCopyWithImpl<MyCircleList>(this as MyCircleList, _$identity);

  /// Serializes this MyCircleList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyCircleList&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'MyCircleList(items: $items)';
}


}

/// @nodoc
abstract mixin class $MyCircleListCopyWith<$Res>  {
  factory $MyCircleListCopyWith(MyCircleList value, $Res Function(MyCircleList) _then) = _$MyCircleListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items') List<MyCircleRecord> items
});




}
/// @nodoc
class _$MyCircleListCopyWithImpl<$Res>
    implements $MyCircleListCopyWith<$Res> {
  _$MyCircleListCopyWithImpl(this._self, this._then);

  final MyCircleList _self;
  final $Res Function(MyCircleList) _then;

/// Create a copy of MyCircleList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MyCircleRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [MyCircleList].
extension MyCircleListPatterns on MyCircleList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyCircleList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyCircleList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyCircleList value)  $default,){
final _that = this;
switch (_that) {
case _MyCircleList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyCircleList value)?  $default,){
final _that = this;
switch (_that) {
case _MyCircleList() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MyCircleList implements MyCircleList {
  const _MyCircleList({@JsonKey(name: 'items') final  List<MyCircleRecord> items = const <MyCircleRecord>[]}): _items = items;
  factory _MyCircleList.fromJson(Map<String, dynamic> json) => _$MyCircleListFromJson(json);

 final  List<MyCircleRecord> _items;
@override@JsonKey(name: 'items') List<MyCircleRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of MyCircleList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyCircleListCopyWith<_MyCircleList> get copyWith => __$MyCircleListCopyWithImpl<_MyCircleList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyCircleListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyCircleList&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'MyCircleList(items: $items)';
}


}

/// @nodoc
abstract mixin class _$MyCircleListCopyWith<$Res> implements $MyCircleListCopyWith<$Res> {
  factory _$MyCircleListCopyWith(_MyCircleList value, $Res Function(_MyCircleList) _then) = __$MyCircleListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items') List<MyCircleRecord> items
});




}
/// @nodoc
class __$MyCircleListCopyWithImpl<$Res>
    implements _$MyCircleListCopyWith<$Res> {
  __$MyCircleListCopyWithImpl(this._self, this._then);

  final _MyCircleList _self;
  final $Res Function(_MyCircleList) _then;

/// Create a copy of MyCircleList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_MyCircleList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MyCircleRecord>,
  ));
}


}

// dart format on
