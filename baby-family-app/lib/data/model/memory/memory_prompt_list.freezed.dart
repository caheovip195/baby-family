// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_prompt_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemoryPromptList {

@JsonKey(name: 'items') List<MemoryPromptRecord> get items;
/// Create a copy of MemoryPromptList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryPromptListCopyWith<MemoryPromptList> get copyWith => _$MemoryPromptListCopyWithImpl<MemoryPromptList>(this as MemoryPromptList, _$identity);

  /// Serializes this MemoryPromptList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryPromptList&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'MemoryPromptList(items: $items)';
}


}

/// @nodoc
abstract mixin class $MemoryPromptListCopyWith<$Res>  {
  factory $MemoryPromptListCopyWith(MemoryPromptList value, $Res Function(MemoryPromptList) _then) = _$MemoryPromptListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items') List<MemoryPromptRecord> items
});




}
/// @nodoc
class _$MemoryPromptListCopyWithImpl<$Res>
    implements $MemoryPromptListCopyWith<$Res> {
  _$MemoryPromptListCopyWithImpl(this._self, this._then);

  final MemoryPromptList _self;
  final $Res Function(MemoryPromptList) _then;

/// Create a copy of MemoryPromptList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MemoryPromptRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryPromptList].
extension MemoryPromptListPatterns on MemoryPromptList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryPromptList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryPromptList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryPromptList value)  $default,){
final _that = this;
switch (_that) {
case _MemoryPromptList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryPromptList value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryPromptList() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MemoryPromptList implements MemoryPromptList {
  const _MemoryPromptList({@JsonKey(name: 'items') final  List<MemoryPromptRecord> items = const <MemoryPromptRecord>[]}): _items = items;
  factory _MemoryPromptList.fromJson(Map<String, dynamic> json) => _$MemoryPromptListFromJson(json);

 final  List<MemoryPromptRecord> _items;
@override@JsonKey(name: 'items') List<MemoryPromptRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of MemoryPromptList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryPromptListCopyWith<_MemoryPromptList> get copyWith => __$MemoryPromptListCopyWithImpl<_MemoryPromptList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryPromptListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryPromptList&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'MemoryPromptList(items: $items)';
}


}

/// @nodoc
abstract mixin class _$MemoryPromptListCopyWith<$Res> implements $MemoryPromptListCopyWith<$Res> {
  factory _$MemoryPromptListCopyWith(_MemoryPromptList value, $Res Function(_MemoryPromptList) _then) = __$MemoryPromptListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items') List<MemoryPromptRecord> items
});




}
/// @nodoc
class __$MemoryPromptListCopyWithImpl<$Res>
    implements _$MemoryPromptListCopyWith<$Res> {
  __$MemoryPromptListCopyWithImpl(this._self, this._then);

  final _MemoryPromptList _self;
  final $Res Function(_MemoryPromptList) _then;

/// Create a copy of MemoryPromptList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_MemoryPromptList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MemoryPromptRecord>,
  ));
}


}

// dart format on
