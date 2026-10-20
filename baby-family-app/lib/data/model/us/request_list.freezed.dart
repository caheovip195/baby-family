// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestList {

@JsonKey(name: 'items') List<RequestRecord> get items;@JsonKey(name: 'nextCursor') String? get nextCursor;
/// Create a copy of RequestList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestListCopyWith<RequestList> get copyWith => _$RequestListCopyWithImpl<RequestList>(this as RequestList, _$identity);

  /// Serializes this RequestList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestList&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'RequestList(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $RequestListCopyWith<$Res>  {
  factory $RequestListCopyWith(RequestList value, $Res Function(RequestList) _then) = _$RequestListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items') List<RequestRecord> items,@JsonKey(name: 'nextCursor') String? nextCursor
});




}
/// @nodoc
class _$RequestListCopyWithImpl<$Res>
    implements $RequestListCopyWith<$Res> {
  _$RequestListCopyWithImpl(this._self, this._then);

  final RequestList _self;
  final $Res Function(RequestList) _then;

/// Create a copy of RequestList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<RequestRecord>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestList].
extension RequestListPatterns on RequestList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestList value)  $default,){
final _that = this;
switch (_that) {
case _RequestList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestList value)?  $default,){
final _that = this;
switch (_that) {
case _RequestList() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _RequestList implements RequestList {
  const _RequestList({@JsonKey(name: 'items') final  List<RequestRecord> items = const <RequestRecord>[], @JsonKey(name: 'nextCursor') this.nextCursor}): _items = items;
  factory _RequestList.fromJson(Map<String, dynamic> json) => _$RequestListFromJson(json);

 final  List<RequestRecord> _items;
@override@JsonKey(name: 'items') List<RequestRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'nextCursor') final  String? nextCursor;

/// Create a copy of RequestList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestListCopyWith<_RequestList> get copyWith => __$RequestListCopyWithImpl<_RequestList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestList&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);

@override
String toString() {
  return 'RequestList(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$RequestListCopyWith<$Res> implements $RequestListCopyWith<$Res> {
  factory _$RequestListCopyWith(_RequestList value, $Res Function(_RequestList) _then) = __$RequestListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items') List<RequestRecord> items,@JsonKey(name: 'nextCursor') String? nextCursor
});




}
/// @nodoc
class __$RequestListCopyWithImpl<$Res>
    implements _$RequestListCopyWith<$Res> {
  __$RequestListCopyWithImpl(this._self, this._then);

  final _RequestList _self;
  final $Res Function(_RequestList) _then;

/// Create a copy of RequestList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_RequestList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<RequestRecord>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
