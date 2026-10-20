// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommentRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'memoryId') String? get memoryId;@JsonKey(name: 'authorUserId') String? get authorUserId;@JsonKey(name: 'parentCommentId') String? get parentCommentId;@JsonKey(name: 'body') String? get body;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'editedAt') DateTime? get editedAt;
/// Create a copy of CommentRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentRecordCopyWith<CommentRecord> get copyWith => _$CommentRecordCopyWithImpl<CommentRecord>(this as CommentRecord, _$identity);

  /// Serializes this CommentRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.parentCommentId, parentCommentId) || other.parentCommentId == parentCommentId)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memoryId,authorUserId,parentCommentId,body,createdAt,editedAt);

@override
String toString() {
  return 'CommentRecord(id: $id, memoryId: $memoryId, authorUserId: $authorUserId, parentCommentId: $parentCommentId, body: $body, createdAt: $createdAt, editedAt: $editedAt)';
}


}

/// @nodoc
abstract mixin class $CommentRecordCopyWith<$Res>  {
  factory $CommentRecordCopyWith(CommentRecord value, $Res Function(CommentRecord) _then) = _$CommentRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'authorUserId') String? authorUserId,@JsonKey(name: 'parentCommentId') String? parentCommentId,@JsonKey(name: 'body') String? body,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'editedAt') DateTime? editedAt
});




}
/// @nodoc
class _$CommentRecordCopyWithImpl<$Res>
    implements $CommentRecordCopyWith<$Res> {
  _$CommentRecordCopyWithImpl(this._self, this._then);

  final CommentRecord _self;
  final $Res Function(CommentRecord) _then;

/// Create a copy of CommentRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? memoryId = freezed,Object? authorUserId = freezed,Object? parentCommentId = freezed,Object? body = freezed,Object? createdAt = freezed,Object? editedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,authorUserId: freezed == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String?,parentCommentId: freezed == parentCommentId ? _self.parentCommentId : parentCommentId // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentRecord].
extension CommentRecordPatterns on CommentRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentRecord value)  $default,){
final _that = this;
switch (_that) {
case _CommentRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentRecord value)?  $default,){
final _that = this;
switch (_that) {
case _CommentRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CommentRecord implements CommentRecord {
  const _CommentRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'memoryId') this.memoryId, @JsonKey(name: 'authorUserId') this.authorUserId, @JsonKey(name: 'parentCommentId') this.parentCommentId, @JsonKey(name: 'body') this.body, @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'editedAt') this.editedAt});
  factory _CommentRecord.fromJson(Map<String, dynamic> json) => _$CommentRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'memoryId') final  String? memoryId;
@override@JsonKey(name: 'authorUserId') final  String? authorUserId;
@override@JsonKey(name: 'parentCommentId') final  String? parentCommentId;
@override@JsonKey(name: 'body') final  String? body;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
@override@JsonKey(name: 'editedAt') final  DateTime? editedAt;

/// Create a copy of CommentRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentRecordCopyWith<_CommentRecord> get copyWith => __$CommentRecordCopyWithImpl<_CommentRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.parentCommentId, parentCommentId) || other.parentCommentId == parentCommentId)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memoryId,authorUserId,parentCommentId,body,createdAt,editedAt);

@override
String toString() {
  return 'CommentRecord(id: $id, memoryId: $memoryId, authorUserId: $authorUserId, parentCommentId: $parentCommentId, body: $body, createdAt: $createdAt, editedAt: $editedAt)';
}


}

/// @nodoc
abstract mixin class _$CommentRecordCopyWith<$Res> implements $CommentRecordCopyWith<$Res> {
  factory _$CommentRecordCopyWith(_CommentRecord value, $Res Function(_CommentRecord) _then) = __$CommentRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'authorUserId') String? authorUserId,@JsonKey(name: 'parentCommentId') String? parentCommentId,@JsonKey(name: 'body') String? body,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'editedAt') DateTime? editedAt
});




}
/// @nodoc
class __$CommentRecordCopyWithImpl<$Res>
    implements _$CommentRecordCopyWith<$Res> {
  __$CommentRecordCopyWithImpl(this._self, this._then);

  final _CommentRecord _self;
  final $Res Function(_CommentRecord) _then;

/// Create a copy of CommentRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? memoryId = freezed,Object? authorUserId = freezed,Object? parentCommentId = freezed,Object? body = freezed,Object? createdAt = freezed,Object? editedAt = freezed,}) {
  return _then(_CommentRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,authorUserId: freezed == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String?,parentCommentId: freezed == parentCommentId ? _self.parentCommentId : parentCommentId // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
