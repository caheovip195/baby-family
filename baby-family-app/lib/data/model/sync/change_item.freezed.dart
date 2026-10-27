// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChangeItem {

@JsonKey(name: 'entity') String get entity;@JsonKey(name: 'id') String get id;@JsonKey(name: 'memoryId') String? get memoryId;@JsonKey(name: 'op') String get op;@JsonKey(name: 'version') int? get version;@JsonKey(name: 'updatedAt') DateTime? get updatedAt;@JsonKey(name: 'data') Map<String, dynamic>? get data;
/// Create a copy of ChangeItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeItemCopyWith<ChangeItem> get copyWith => _$ChangeItemCopyWithImpl<ChangeItem>(this as ChangeItem, _$identity);

  /// Serializes this ChangeItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeItem&&(identical(other.entity, entity) || other.entity == entity)&&(identical(other.id, id) || other.id == id)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.op, op) || other.op == op)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entity,id,memoryId,op,version,updatedAt,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ChangeItem(entity: $entity, id: $id, memoryId: $memoryId, op: $op, version: $version, updatedAt: $updatedAt, data: $data)';
}


}

/// @nodoc
abstract mixin class $ChangeItemCopyWith<$Res>  {
  factory $ChangeItemCopyWith(ChangeItem value, $Res Function(ChangeItem) _then) = _$ChangeItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'entity') String entity,@JsonKey(name: 'id') String id,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'op') String op,@JsonKey(name: 'version') int? version,@JsonKey(name: 'updatedAt') DateTime? updatedAt,@JsonKey(name: 'data') Map<String, dynamic>? data
});




}
/// @nodoc
class _$ChangeItemCopyWithImpl<$Res>
    implements $ChangeItemCopyWith<$Res> {
  _$ChangeItemCopyWithImpl(this._self, this._then);

  final ChangeItem _self;
  final $Res Function(ChangeItem) _then;

/// Create a copy of ChangeItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entity = null,Object? id = null,Object? memoryId = freezed,Object? op = null,Object? version = freezed,Object? updatedAt = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,op: null == op ? _self.op : op // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangeItem].
extension ChangeItemPatterns on ChangeItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangeItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangeItem value)  $default,){
final _that = this;
switch (_that) {
case _ChangeItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangeItem value)?  $default,){
final _that = this;
switch (_that) {
case _ChangeItem() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChangeItem extends ChangeItem {
  const _ChangeItem({@JsonKey(name: 'entity') required this.entity, @JsonKey(name: 'id') required this.id, @JsonKey(name: 'memoryId') this.memoryId, @JsonKey(name: 'op') required this.op, @JsonKey(name: 'version') this.version, @JsonKey(name: 'updatedAt') this.updatedAt, @JsonKey(name: 'data') final  Map<String, dynamic>? data}): _data = data,super._();
  factory _ChangeItem.fromJson(Map<String, dynamic> json) => _$ChangeItemFromJson(json);

@override@JsonKey(name: 'entity') final  String entity;
@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'memoryId') final  String? memoryId;
@override@JsonKey(name: 'op') final  String op;
@override@JsonKey(name: 'version') final  int? version;
@override@JsonKey(name: 'updatedAt') final  DateTime? updatedAt;
 final  Map<String, dynamic>? _data;
@override@JsonKey(name: 'data') Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ChangeItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeItemCopyWith<_ChangeItem> get copyWith => __$ChangeItemCopyWithImpl<_ChangeItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangeItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeItem&&(identical(other.entity, entity) || other.entity == entity)&&(identical(other.id, id) || other.id == id)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.op, op) || other.op == op)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entity,id,memoryId,op,version,updatedAt,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'ChangeItem(entity: $entity, id: $id, memoryId: $memoryId, op: $op, version: $version, updatedAt: $updatedAt, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ChangeItemCopyWith<$Res> implements $ChangeItemCopyWith<$Res> {
  factory _$ChangeItemCopyWith(_ChangeItem value, $Res Function(_ChangeItem) _then) = __$ChangeItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'entity') String entity,@JsonKey(name: 'id') String id,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'op') String op,@JsonKey(name: 'version') int? version,@JsonKey(name: 'updatedAt') DateTime? updatedAt,@JsonKey(name: 'data') Map<String, dynamic>? data
});




}
/// @nodoc
class __$ChangeItemCopyWithImpl<$Res>
    implements _$ChangeItemCopyWith<$Res> {
  __$ChangeItemCopyWithImpl(this._self, this._then);

  final _ChangeItem _self;
  final $Res Function(_ChangeItem) _then;

/// Create a copy of ChangeItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entity = null,Object? id = null,Object? memoryId = freezed,Object? op = null,Object? version = freezed,Object? updatedAt = freezed,Object? data = freezed,}) {
  return _then(_ChangeItem(
entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,op: null == op ? _self.op : op // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$ChangesPage {

@JsonKey(name: 'items', fromJson: _changeItems) List<ChangeItem> get items;@JsonKey(name: 'nextCursor') String? get nextCursor;@JsonKey(name: 'hasMore') bool get hasMore;
/// Create a copy of ChangesPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangesPageCopyWith<ChangesPage> get copyWith => _$ChangesPageCopyWithImpl<ChangesPage>(this as ChangesPage, _$identity);

  /// Serializes this ChangesPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangesPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor,hasMore);

@override
String toString() {
  return 'ChangesPage(items: $items, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $ChangesPageCopyWith<$Res>  {
  factory $ChangesPageCopyWith(ChangesPage value, $Res Function(ChangesPage) _then) = _$ChangesPageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items', fromJson: _changeItems) List<ChangeItem> items,@JsonKey(name: 'nextCursor') String? nextCursor,@JsonKey(name: 'hasMore') bool hasMore
});




}
/// @nodoc
class _$ChangesPageCopyWithImpl<$Res>
    implements $ChangesPageCopyWith<$Res> {
  _$ChangesPageCopyWithImpl(this._self, this._then);

  final ChangesPage _self;
  final $Res Function(ChangesPage) _then;

/// Create a copy of ChangesPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ChangeItem>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangesPage].
extension ChangesPagePatterns on ChangesPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangesPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangesPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangesPage value)  $default,){
final _that = this;
switch (_that) {
case _ChangesPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangesPage value)?  $default,){
final _that = this;
switch (_that) {
case _ChangesPage() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChangesPage implements ChangesPage {
  const _ChangesPage({@JsonKey(name: 'items', fromJson: _changeItems) final  List<ChangeItem> items = const [], @JsonKey(name: 'nextCursor') this.nextCursor, @JsonKey(name: 'hasMore') this.hasMore = false}): _items = items;
  factory _ChangesPage.fromJson(Map<String, dynamic> json) => _$ChangesPageFromJson(json);

 final  List<ChangeItem> _items;
@override@JsonKey(name: 'items', fromJson: _changeItems) List<ChangeItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'nextCursor') final  String? nextCursor;
@override@JsonKey(name: 'hasMore') final  bool hasMore;

/// Create a copy of ChangesPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangesPageCopyWith<_ChangesPage> get copyWith => __$ChangesPageCopyWithImpl<_ChangesPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangesPageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangesPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor,hasMore);

@override
String toString() {
  return 'ChangesPage(items: $items, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$ChangesPageCopyWith<$Res> implements $ChangesPageCopyWith<$Res> {
  factory _$ChangesPageCopyWith(_ChangesPage value, $Res Function(_ChangesPage) _then) = __$ChangesPageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items', fromJson: _changeItems) List<ChangeItem> items,@JsonKey(name: 'nextCursor') String? nextCursor,@JsonKey(name: 'hasMore') bool hasMore
});




}
/// @nodoc
class __$ChangesPageCopyWithImpl<$Res>
    implements _$ChangesPageCopyWith<$Res> {
  __$ChangesPageCopyWithImpl(this._self, this._then);

  final _ChangesPage _self;
  final $Res Function(_ChangesPage) _then;

/// Create a copy of ChangesPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(_ChangesPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ChangeItem>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
