// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'perspective_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PerspectiveList {

@JsonKey(name: 'items') List<PerspectiveRecord> get items;
/// Create a copy of PerspectiveList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PerspectiveListCopyWith<PerspectiveList> get copyWith => _$PerspectiveListCopyWithImpl<PerspectiveList>(this as PerspectiveList, _$identity);

  /// Serializes this PerspectiveList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PerspectiveList&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'PerspectiveList(items: $items)';
}


}

/// @nodoc
abstract mixin class $PerspectiveListCopyWith<$Res>  {
  factory $PerspectiveListCopyWith(PerspectiveList value, $Res Function(PerspectiveList) _then) = _$PerspectiveListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items') List<PerspectiveRecord> items
});




}
/// @nodoc
class _$PerspectiveListCopyWithImpl<$Res>
    implements $PerspectiveListCopyWith<$Res> {
  _$PerspectiveListCopyWithImpl(this._self, this._then);

  final PerspectiveList _self;
  final $Res Function(PerspectiveList) _then;

/// Create a copy of PerspectiveList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PerspectiveRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [PerspectiveList].
extension PerspectiveListPatterns on PerspectiveList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PerspectiveList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PerspectiveList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PerspectiveList value)  $default,){
final _that = this;
switch (_that) {
case _PerspectiveList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PerspectiveList value)?  $default,){
final _that = this;
switch (_that) {
case _PerspectiveList() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PerspectiveList implements PerspectiveList {
  const _PerspectiveList({@JsonKey(name: 'items') final  List<PerspectiveRecord> items = const <PerspectiveRecord>[]}): _items = items;
  factory _PerspectiveList.fromJson(Map<String, dynamic> json) => _$PerspectiveListFromJson(json);

 final  List<PerspectiveRecord> _items;
@override@JsonKey(name: 'items') List<PerspectiveRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PerspectiveList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PerspectiveListCopyWith<_PerspectiveList> get copyWith => __$PerspectiveListCopyWithImpl<_PerspectiveList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PerspectiveListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PerspectiveList&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PerspectiveList(items: $items)';
}


}

/// @nodoc
abstract mixin class _$PerspectiveListCopyWith<$Res> implements $PerspectiveListCopyWith<$Res> {
  factory _$PerspectiveListCopyWith(_PerspectiveList value, $Res Function(_PerspectiveList) _then) = __$PerspectiveListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items') List<PerspectiveRecord> items
});




}
/// @nodoc
class __$PerspectiveListCopyWithImpl<$Res>
    implements _$PerspectiveListCopyWith<$Res> {
  __$PerspectiveListCopyWithImpl(this._self, this._then);

  final _PerspectiveList _self;
  final $Res Function(_PerspectiveList) _then;

/// Create a copy of PerspectiveList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_PerspectiveList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PerspectiveRecord>,
  ));
}


}

// dart format on
