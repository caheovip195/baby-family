// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionList {

@JsonKey(name: 'items') List<SessionRecord> get items;
/// Create a copy of SessionList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionListCopyWith<SessionList> get copyWith => _$SessionListCopyWithImpl<SessionList>(this as SessionList, _$identity);

  /// Serializes this SessionList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionList&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'SessionList(items: $items)';
}


}

/// @nodoc
abstract mixin class $SessionListCopyWith<$Res>  {
  factory $SessionListCopyWith(SessionList value, $Res Function(SessionList) _then) = _$SessionListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items') List<SessionRecord> items
});




}
/// @nodoc
class _$SessionListCopyWithImpl<$Res>
    implements $SessionListCopyWith<$Res> {
  _$SessionListCopyWithImpl(this._self, this._then);

  final SessionList _self;
  final $Res Function(SessionList) _then;

/// Create a copy of SessionList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SessionRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionList].
extension SessionListPatterns on SessionList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionList value)  $default,){
final _that = this;
switch (_that) {
case _SessionList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionList value)?  $default,){
final _that = this;
switch (_that) {
case _SessionList() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SessionList implements SessionList {
  const _SessionList({@JsonKey(name: 'items') final  List<SessionRecord> items = const <SessionRecord>[]}): _items = items;
  factory _SessionList.fromJson(Map<String, dynamic> json) => _$SessionListFromJson(json);

 final  List<SessionRecord> _items;
@override@JsonKey(name: 'items') List<SessionRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SessionList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionListCopyWith<_SessionList> get copyWith => __$SessionListCopyWithImpl<_SessionList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionList&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'SessionList(items: $items)';
}


}

/// @nodoc
abstract mixin class _$SessionListCopyWith<$Res> implements $SessionListCopyWith<$Res> {
  factory _$SessionListCopyWith(_SessionList value, $Res Function(_SessionList) _then) = __$SessionListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items') List<SessionRecord> items
});




}
/// @nodoc
class __$SessionListCopyWithImpl<$Res>
    implements _$SessionListCopyWith<$Res> {
  __$SessionListCopyWithImpl(this._self, this._then);

  final _SessionList _self;
  final $Res Function(_SessionList) _then;

/// Create a copy of SessionList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_SessionList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SessionRecord>,
  ));
}


}

// dart format on
