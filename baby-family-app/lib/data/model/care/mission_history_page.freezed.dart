// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_history_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionHistoryPage {

@JsonKey(name: 'items') List<MissionRecord> get items;@JsonKey(name: 'nextCursor') String? get nextCursor;
/// Create a copy of MissionHistoryPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionHistoryPageCopyWith<MissionHistoryPage> get copyWith => _$MissionHistoryPageCopyWithImpl<MissionHistoryPage>(this as MissionHistoryPage, _$identity);

  /// Serializes this MissionHistoryPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionHistoryPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'MissionHistoryPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $MissionHistoryPageCopyWith<$Res>  {
  factory $MissionHistoryPageCopyWith(MissionHistoryPage value, $Res Function(MissionHistoryPage) _then) = _$MissionHistoryPageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items') List<MissionRecord> items,@JsonKey(name: 'nextCursor') String? nextCursor
});




}
/// @nodoc
class _$MissionHistoryPageCopyWithImpl<$Res>
    implements $MissionHistoryPageCopyWith<$Res> {
  _$MissionHistoryPageCopyWithImpl(this._self, this._then);

  final MissionHistoryPage _self;
  final $Res Function(MissionHistoryPage) _then;

/// Create a copy of MissionHistoryPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MissionRecord>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionHistoryPage].
extension MissionHistoryPagePatterns on MissionHistoryPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionHistoryPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionHistoryPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionHistoryPage value)  $default,){
final _that = this;
switch (_that) {
case _MissionHistoryPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionHistoryPage value)?  $default,){
final _that = this;
switch (_that) {
case _MissionHistoryPage() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MissionHistoryPage implements MissionHistoryPage {
  const _MissionHistoryPage({@JsonKey(name: 'items') final  List<MissionRecord> items = const <MissionRecord>[], @JsonKey(name: 'nextCursor') this.nextCursor}): _items = items;
  factory _MissionHistoryPage.fromJson(Map<String, dynamic> json) => _$MissionHistoryPageFromJson(json);

 final  List<MissionRecord> _items;
@override@JsonKey(name: 'items') List<MissionRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'nextCursor') final  String? nextCursor;

/// Create a copy of MissionHistoryPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionHistoryPageCopyWith<_MissionHistoryPage> get copyWith => __$MissionHistoryPageCopyWithImpl<_MissionHistoryPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionHistoryPageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionHistoryPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);

@override
String toString() {
  return 'MissionHistoryPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$MissionHistoryPageCopyWith<$Res> implements $MissionHistoryPageCopyWith<$Res> {
  factory _$MissionHistoryPageCopyWith(_MissionHistoryPage value, $Res Function(_MissionHistoryPage) _then) = __$MissionHistoryPageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items') List<MissionRecord> items,@JsonKey(name: 'nextCursor') String? nextCursor
});




}
/// @nodoc
class __$MissionHistoryPageCopyWithImpl<$Res>
    implements _$MissionHistoryPageCopyWith<$Res> {
  __$MissionHistoryPageCopyWithImpl(this._self, this._then);

  final _MissionHistoryPage _self;
  final $Res Function(_MissionHistoryPage) _then;

/// Create a copy of MissionHistoryPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_MissionHistoryPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MissionRecord>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
