// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_ticket_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupportTicketList {

@JsonKey(name: 'items') List<SupportTicket> get items;@JsonKey(name: 'nextOffset') int? get nextOffset;
/// Create a copy of SupportTicketList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportTicketListCopyWith<SupportTicketList> get copyWith => _$SupportTicketListCopyWithImpl<SupportTicketList>(this as SupportTicketList, _$identity);

  /// Serializes this SupportTicketList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportTicketList&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextOffset, nextOffset) || other.nextOffset == nextOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextOffset);

@override
String toString() {
  return 'SupportTicketList(items: $items, nextOffset: $nextOffset)';
}


}

/// @nodoc
abstract mixin class $SupportTicketListCopyWith<$Res>  {
  factory $SupportTicketListCopyWith(SupportTicketList value, $Res Function(SupportTicketList) _then) = _$SupportTicketListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items') List<SupportTicket> items,@JsonKey(name: 'nextOffset') int? nextOffset
});




}
/// @nodoc
class _$SupportTicketListCopyWithImpl<$Res>
    implements $SupportTicketListCopyWith<$Res> {
  _$SupportTicketListCopyWithImpl(this._self, this._then);

  final SupportTicketList _self;
  final $Res Function(SupportTicketList) _then;

/// Create a copy of SupportTicketList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextOffset = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SupportTicket>,nextOffset: freezed == nextOffset ? _self.nextOffset : nextOffset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SupportTicketList].
extension SupportTicketListPatterns on SupportTicketList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportTicketList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportTicketList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportTicketList value)  $default,){
final _that = this;
switch (_that) {
case _SupportTicketList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportTicketList value)?  $default,){
final _that = this;
switch (_that) {
case _SupportTicketList() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SupportTicketList implements SupportTicketList {
  const _SupportTicketList({@JsonKey(name: 'items') final  List<SupportTicket> items = const <SupportTicket>[], @JsonKey(name: 'nextOffset') this.nextOffset}): _items = items;
  factory _SupportTicketList.fromJson(Map<String, dynamic> json) => _$SupportTicketListFromJson(json);

 final  List<SupportTicket> _items;
@override@JsonKey(name: 'items') List<SupportTicket> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'nextOffset') final  int? nextOffset;

/// Create a copy of SupportTicketList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportTicketListCopyWith<_SupportTicketList> get copyWith => __$SupportTicketListCopyWithImpl<_SupportTicketList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupportTicketListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportTicketList&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextOffset, nextOffset) || other.nextOffset == nextOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextOffset);

@override
String toString() {
  return 'SupportTicketList(items: $items, nextOffset: $nextOffset)';
}


}

/// @nodoc
abstract mixin class _$SupportTicketListCopyWith<$Res> implements $SupportTicketListCopyWith<$Res> {
  factory _$SupportTicketListCopyWith(_SupportTicketList value, $Res Function(_SupportTicketList) _then) = __$SupportTicketListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items') List<SupportTicket> items,@JsonKey(name: 'nextOffset') int? nextOffset
});




}
/// @nodoc
class __$SupportTicketListCopyWithImpl<$Res>
    implements _$SupportTicketListCopyWith<$Res> {
  __$SupportTicketListCopyWithImpl(this._self, this._then);

  final _SupportTicketList _self;
  final $Res Function(_SupportTicketList) _then;

/// Create a copy of SupportTicketList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextOffset = freezed,}) {
  return _then(_SupportTicketList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SupportTicket>,nextOffset: freezed == nextOffset ? _self.nextOffset : nextOffset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
