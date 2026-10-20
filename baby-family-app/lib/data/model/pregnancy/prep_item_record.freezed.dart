// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prep_item_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrepItemRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'pregnancyId') String? get pregnancyId;@JsonKey(name: 'groupCode') String? get groupCode;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'sortOrder') int get sortOrder;@JsonKey(name: 'done') bool get done;
/// Create a copy of PrepItemRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrepItemRecordCopyWith<PrepItemRecord> get copyWith => _$PrepItemRecordCopyWithImpl<PrepItemRecord>(this as PrepItemRecord, _$identity);

  /// Serializes this PrepItemRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrepItemRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.groupCode, groupCode) || other.groupCode == groupCode)&&(identical(other.title, title) || other.title == title)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.done, done) || other.done == done));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pregnancyId,groupCode,title,sortOrder,done);

@override
String toString() {
  return 'PrepItemRecord(id: $id, pregnancyId: $pregnancyId, groupCode: $groupCode, title: $title, sortOrder: $sortOrder, done: $done)';
}


}

/// @nodoc
abstract mixin class $PrepItemRecordCopyWith<$Res>  {
  factory $PrepItemRecordCopyWith(PrepItemRecord value, $Res Function(PrepItemRecord) _then) = _$PrepItemRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'pregnancyId') String? pregnancyId,@JsonKey(name: 'groupCode') String? groupCode,@JsonKey(name: 'title') String? title,@JsonKey(name: 'sortOrder') int sortOrder,@JsonKey(name: 'done') bool done
});




}
/// @nodoc
class _$PrepItemRecordCopyWithImpl<$Res>
    implements $PrepItemRecordCopyWith<$Res> {
  _$PrepItemRecordCopyWithImpl(this._self, this._then);

  final PrepItemRecord _self;
  final $Res Function(PrepItemRecord) _then;

/// Create a copy of PrepItemRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? pregnancyId = freezed,Object? groupCode = freezed,Object? title = freezed,Object? sortOrder = null,Object? done = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,pregnancyId: freezed == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String?,groupCode: freezed == groupCode ? _self.groupCode : groupCode // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PrepItemRecord].
extension PrepItemRecordPatterns on PrepItemRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrepItemRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrepItemRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrepItemRecord value)  $default,){
final _that = this;
switch (_that) {
case _PrepItemRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrepItemRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PrepItemRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PrepItemRecord implements PrepItemRecord {
  const _PrepItemRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'pregnancyId') this.pregnancyId, @JsonKey(name: 'groupCode') this.groupCode, @JsonKey(name: 'title') this.title, @JsonKey(name: 'sortOrder') this.sortOrder = 0, @JsonKey(name: 'done') this.done = false});
  factory _PrepItemRecord.fromJson(Map<String, dynamic> json) => _$PrepItemRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'pregnancyId') final  String? pregnancyId;
@override@JsonKey(name: 'groupCode') final  String? groupCode;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'sortOrder') final  int sortOrder;
@override@JsonKey(name: 'done') final  bool done;

/// Create a copy of PrepItemRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrepItemRecordCopyWith<_PrepItemRecord> get copyWith => __$PrepItemRecordCopyWithImpl<_PrepItemRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrepItemRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrepItemRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.groupCode, groupCode) || other.groupCode == groupCode)&&(identical(other.title, title) || other.title == title)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.done, done) || other.done == done));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pregnancyId,groupCode,title,sortOrder,done);

@override
String toString() {
  return 'PrepItemRecord(id: $id, pregnancyId: $pregnancyId, groupCode: $groupCode, title: $title, sortOrder: $sortOrder, done: $done)';
}


}

/// @nodoc
abstract mixin class _$PrepItemRecordCopyWith<$Res> implements $PrepItemRecordCopyWith<$Res> {
  factory _$PrepItemRecordCopyWith(_PrepItemRecord value, $Res Function(_PrepItemRecord) _then) = __$PrepItemRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'pregnancyId') String? pregnancyId,@JsonKey(name: 'groupCode') String? groupCode,@JsonKey(name: 'title') String? title,@JsonKey(name: 'sortOrder') int sortOrder,@JsonKey(name: 'done') bool done
});




}
/// @nodoc
class __$PrepItemRecordCopyWithImpl<$Res>
    implements _$PrepItemRecordCopyWith<$Res> {
  __$PrepItemRecordCopyWithImpl(this._self, this._then);

  final _PrepItemRecord _self;
  final $Res Function(_PrepItemRecord) _then;

/// Create a copy of PrepItemRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? pregnancyId = freezed,Object? groupCode = freezed,Object? title = freezed,Object? sortOrder = null,Object? done = null,}) {
  return _then(_PrepItemRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,pregnancyId: freezed == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String?,groupCode: freezed == groupCode ? _self.groupCode : groupCode // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
