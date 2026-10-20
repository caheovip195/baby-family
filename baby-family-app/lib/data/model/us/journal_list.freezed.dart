// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JournalList {

@JsonKey(name: 'items') List<JournalEntryRecord> get items;@JsonKey(name: 'nextCursor') String? get nextCursor;
/// Create a copy of JournalList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalListCopyWith<JournalList> get copyWith => _$JournalListCopyWithImpl<JournalList>(this as JournalList, _$identity);

  /// Serializes this JournalList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalList&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'JournalList(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $JournalListCopyWith<$Res>  {
  factory $JournalListCopyWith(JournalList value, $Res Function(JournalList) _then) = _$JournalListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items') List<JournalEntryRecord> items,@JsonKey(name: 'nextCursor') String? nextCursor
});




}
/// @nodoc
class _$JournalListCopyWithImpl<$Res>
    implements $JournalListCopyWith<$Res> {
  _$JournalListCopyWithImpl(this._self, this._then);

  final JournalList _self;
  final $Res Function(JournalList) _then;

/// Create a copy of JournalList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<JournalEntryRecord>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalList].
extension JournalListPatterns on JournalList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalList value)  $default,){
final _that = this;
switch (_that) {
case _JournalList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalList value)?  $default,){
final _that = this;
switch (_that) {
case _JournalList() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _JournalList implements JournalList {
  const _JournalList({@JsonKey(name: 'items') final  List<JournalEntryRecord> items = const <JournalEntryRecord>[], @JsonKey(name: 'nextCursor') this.nextCursor}): _items = items;
  factory _JournalList.fromJson(Map<String, dynamic> json) => _$JournalListFromJson(json);

 final  List<JournalEntryRecord> _items;
@override@JsonKey(name: 'items') List<JournalEntryRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'nextCursor') final  String? nextCursor;

/// Create a copy of JournalList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalListCopyWith<_JournalList> get copyWith => __$JournalListCopyWithImpl<_JournalList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalList&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);

@override
String toString() {
  return 'JournalList(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$JournalListCopyWith<$Res> implements $JournalListCopyWith<$Res> {
  factory _$JournalListCopyWith(_JournalList value, $Res Function(_JournalList) _then) = __$JournalListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items') List<JournalEntryRecord> items,@JsonKey(name: 'nextCursor') String? nextCursor
});




}
/// @nodoc
class __$JournalListCopyWithImpl<$Res>
    implements _$JournalListCopyWith<$Res> {
  __$JournalListCopyWithImpl(this._self, this._then);

  final _JournalList _self;
  final $Res Function(_JournalList) _then;

/// Create a copy of JournalList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_JournalList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<JournalEntryRecord>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
