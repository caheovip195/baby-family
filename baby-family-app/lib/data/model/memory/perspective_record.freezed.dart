// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'perspective_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PerspectiveRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'memoryId') String? get memoryId;@JsonKey(name: 'authorUserId') String? get authorUserId;@JsonKey(name: 'body') String? get body;@JsonKey(name: 'hiddenFromCircle') bool get hiddenFromCircle;@JsonKey(name: 'createdAt') DateTime? get createdAt;
/// Create a copy of PerspectiveRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PerspectiveRecordCopyWith<PerspectiveRecord> get copyWith => _$PerspectiveRecordCopyWithImpl<PerspectiveRecord>(this as PerspectiveRecord, _$identity);

  /// Serializes this PerspectiveRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PerspectiveRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.body, body) || other.body == body)&&(identical(other.hiddenFromCircle, hiddenFromCircle) || other.hiddenFromCircle == hiddenFromCircle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memoryId,authorUserId,body,hiddenFromCircle,createdAt);

@override
String toString() {
  return 'PerspectiveRecord(id: $id, memoryId: $memoryId, authorUserId: $authorUserId, body: $body, hiddenFromCircle: $hiddenFromCircle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PerspectiveRecordCopyWith<$Res>  {
  factory $PerspectiveRecordCopyWith(PerspectiveRecord value, $Res Function(PerspectiveRecord) _then) = _$PerspectiveRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'authorUserId') String? authorUserId,@JsonKey(name: 'body') String? body,@JsonKey(name: 'hiddenFromCircle') bool hiddenFromCircle,@JsonKey(name: 'createdAt') DateTime? createdAt
});




}
/// @nodoc
class _$PerspectiveRecordCopyWithImpl<$Res>
    implements $PerspectiveRecordCopyWith<$Res> {
  _$PerspectiveRecordCopyWithImpl(this._self, this._then);

  final PerspectiveRecord _self;
  final $Res Function(PerspectiveRecord) _then;

/// Create a copy of PerspectiveRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? memoryId = freezed,Object? authorUserId = freezed,Object? body = freezed,Object? hiddenFromCircle = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,authorUserId: freezed == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,hiddenFromCircle: null == hiddenFromCircle ? _self.hiddenFromCircle : hiddenFromCircle // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PerspectiveRecord].
extension PerspectiveRecordPatterns on PerspectiveRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PerspectiveRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PerspectiveRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PerspectiveRecord value)  $default,){
final _that = this;
switch (_that) {
case _PerspectiveRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PerspectiveRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PerspectiveRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PerspectiveRecord implements PerspectiveRecord {
  const _PerspectiveRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'memoryId') this.memoryId, @JsonKey(name: 'authorUserId') this.authorUserId, @JsonKey(name: 'body') this.body, @JsonKey(name: 'hiddenFromCircle') this.hiddenFromCircle = false, @JsonKey(name: 'createdAt') this.createdAt});
  factory _PerspectiveRecord.fromJson(Map<String, dynamic> json) => _$PerspectiveRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'memoryId') final  String? memoryId;
@override@JsonKey(name: 'authorUserId') final  String? authorUserId;
@override@JsonKey(name: 'body') final  String? body;
@override@JsonKey(name: 'hiddenFromCircle') final  bool hiddenFromCircle;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;

/// Create a copy of PerspectiveRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PerspectiveRecordCopyWith<_PerspectiveRecord> get copyWith => __$PerspectiveRecordCopyWithImpl<_PerspectiveRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PerspectiveRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PerspectiveRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.body, body) || other.body == body)&&(identical(other.hiddenFromCircle, hiddenFromCircle) || other.hiddenFromCircle == hiddenFromCircle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memoryId,authorUserId,body,hiddenFromCircle,createdAt);

@override
String toString() {
  return 'PerspectiveRecord(id: $id, memoryId: $memoryId, authorUserId: $authorUserId, body: $body, hiddenFromCircle: $hiddenFromCircle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PerspectiveRecordCopyWith<$Res> implements $PerspectiveRecordCopyWith<$Res> {
  factory _$PerspectiveRecordCopyWith(_PerspectiveRecord value, $Res Function(_PerspectiveRecord) _then) = __$PerspectiveRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'authorUserId') String? authorUserId,@JsonKey(name: 'body') String? body,@JsonKey(name: 'hiddenFromCircle') bool hiddenFromCircle,@JsonKey(name: 'createdAt') DateTime? createdAt
});




}
/// @nodoc
class __$PerspectiveRecordCopyWithImpl<$Res>
    implements _$PerspectiveRecordCopyWith<$Res> {
  __$PerspectiveRecordCopyWithImpl(this._self, this._then);

  final _PerspectiveRecord _self;
  final $Res Function(_PerspectiveRecord) _then;

/// Create a copy of PerspectiveRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? memoryId = freezed,Object? authorUserId = freezed,Object? body = freezed,Object? hiddenFromCircle = null,Object? createdAt = freezed,}) {
  return _then(_PerspectiveRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,authorUserId: freezed == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,hiddenFromCircle: null == hiddenFromCircle ? _self.hiddenFromCircle : hiddenFromCircle // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
