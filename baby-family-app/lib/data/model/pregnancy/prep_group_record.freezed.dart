// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prep_group_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrepGroupRecord {

@JsonKey(name: 'groupCode') String? get groupCode;@JsonKey(name: 'items') List<PrepItemRecord> get items;
/// Create a copy of PrepGroupRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrepGroupRecordCopyWith<PrepGroupRecord> get copyWith => _$PrepGroupRecordCopyWithImpl<PrepGroupRecord>(this as PrepGroupRecord, _$identity);

  /// Serializes this PrepGroupRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrepGroupRecord&&(identical(other.groupCode, groupCode) || other.groupCode == groupCode)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupCode,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'PrepGroupRecord(groupCode: $groupCode, items: $items)';
}


}

/// @nodoc
abstract mixin class $PrepGroupRecordCopyWith<$Res>  {
  factory $PrepGroupRecordCopyWith(PrepGroupRecord value, $Res Function(PrepGroupRecord) _then) = _$PrepGroupRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'groupCode') String? groupCode,@JsonKey(name: 'items') List<PrepItemRecord> items
});




}
/// @nodoc
class _$PrepGroupRecordCopyWithImpl<$Res>
    implements $PrepGroupRecordCopyWith<$Res> {
  _$PrepGroupRecordCopyWithImpl(this._self, this._then);

  final PrepGroupRecord _self;
  final $Res Function(PrepGroupRecord) _then;

/// Create a copy of PrepGroupRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupCode = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
groupCode: freezed == groupCode ? _self.groupCode : groupCode // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PrepItemRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [PrepGroupRecord].
extension PrepGroupRecordPatterns on PrepGroupRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrepGroupRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrepGroupRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrepGroupRecord value)  $default,){
final _that = this;
switch (_that) {
case _PrepGroupRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrepGroupRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PrepGroupRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PrepGroupRecord implements PrepGroupRecord {
  const _PrepGroupRecord({@JsonKey(name: 'groupCode') this.groupCode, @JsonKey(name: 'items') final  List<PrepItemRecord> items = const <PrepItemRecord>[]}): _items = items;
  factory _PrepGroupRecord.fromJson(Map<String, dynamic> json) => _$PrepGroupRecordFromJson(json);

@override@JsonKey(name: 'groupCode') final  String? groupCode;
 final  List<PrepItemRecord> _items;
@override@JsonKey(name: 'items') List<PrepItemRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PrepGroupRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrepGroupRecordCopyWith<_PrepGroupRecord> get copyWith => __$PrepGroupRecordCopyWithImpl<_PrepGroupRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrepGroupRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrepGroupRecord&&(identical(other.groupCode, groupCode) || other.groupCode == groupCode)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupCode,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PrepGroupRecord(groupCode: $groupCode, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PrepGroupRecordCopyWith<$Res> implements $PrepGroupRecordCopyWith<$Res> {
  factory _$PrepGroupRecordCopyWith(_PrepGroupRecord value, $Res Function(_PrepGroupRecord) _then) = __$PrepGroupRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'groupCode') String? groupCode,@JsonKey(name: 'items') List<PrepItemRecord> items
});




}
/// @nodoc
class __$PrepGroupRecordCopyWithImpl<$Res>
    implements _$PrepGroupRecordCopyWith<$Res> {
  __$PrepGroupRecordCopyWithImpl(this._self, this._then);

  final _PrepGroupRecord _self;
  final $Res Function(_PrepGroupRecord) _then;

/// Create a copy of PrepGroupRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupCode = freezed,Object? items = null,}) {
  return _then(_PrepGroupRecord(
groupCode: freezed == groupCode ? _self.groupCode : groupCode // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PrepItemRecord>,
  ));
}


}

// dart format on
