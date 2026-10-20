// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appreciation_wall.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppreciationWall {

@JsonKey(name: 'items') List<AppreciationRecord> get items;@JsonKey(name: 'nextCursor') String? get nextCursor;
/// Create a copy of AppreciationWall
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppreciationWallCopyWith<AppreciationWall> get copyWith => _$AppreciationWallCopyWithImpl<AppreciationWall>(this as AppreciationWall, _$identity);

  /// Serializes this AppreciationWall to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppreciationWall&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'AppreciationWall(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $AppreciationWallCopyWith<$Res>  {
  factory $AppreciationWallCopyWith(AppreciationWall value, $Res Function(AppreciationWall) _then) = _$AppreciationWallCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items') List<AppreciationRecord> items,@JsonKey(name: 'nextCursor') String? nextCursor
});




}
/// @nodoc
class _$AppreciationWallCopyWithImpl<$Res>
    implements $AppreciationWallCopyWith<$Res> {
  _$AppreciationWallCopyWithImpl(this._self, this._then);

  final AppreciationWall _self;
  final $Res Function(AppreciationWall) _then;

/// Create a copy of AppreciationWall
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AppreciationRecord>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppreciationWall].
extension AppreciationWallPatterns on AppreciationWall {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppreciationWall value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppreciationWall() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppreciationWall value)  $default,){
final _that = this;
switch (_that) {
case _AppreciationWall():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppreciationWall value)?  $default,){
final _that = this;
switch (_that) {
case _AppreciationWall() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AppreciationWall implements AppreciationWall {
  const _AppreciationWall({@JsonKey(name: 'items') final  List<AppreciationRecord> items = const <AppreciationRecord>[], @JsonKey(name: 'nextCursor') this.nextCursor}): _items = items;
  factory _AppreciationWall.fromJson(Map<String, dynamic> json) => _$AppreciationWallFromJson(json);

 final  List<AppreciationRecord> _items;
@override@JsonKey(name: 'items') List<AppreciationRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'nextCursor') final  String? nextCursor;

/// Create a copy of AppreciationWall
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppreciationWallCopyWith<_AppreciationWall> get copyWith => __$AppreciationWallCopyWithImpl<_AppreciationWall>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppreciationWallToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppreciationWall&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);

@override
String toString() {
  return 'AppreciationWall(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$AppreciationWallCopyWith<$Res> implements $AppreciationWallCopyWith<$Res> {
  factory _$AppreciationWallCopyWith(_AppreciationWall value, $Res Function(_AppreciationWall) _then) = __$AppreciationWallCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items') List<AppreciationRecord> items,@JsonKey(name: 'nextCursor') String? nextCursor
});




}
/// @nodoc
class __$AppreciationWallCopyWithImpl<$Res>
    implements _$AppreciationWallCopyWith<$Res> {
  __$AppreciationWallCopyWithImpl(this._self, this._then);

  final _AppreciationWall _self;
  final $Res Function(_AppreciationWall) _then;

/// Create a copy of AppreciationWall
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_AppreciationWall(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AppreciationRecord>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
