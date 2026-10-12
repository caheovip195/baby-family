// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemoryComment {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'memoryId') String get memoryId;@JsonKey(name: 'authorId') String? get authorId;@JsonKey(name: 'authorName') String get authorName;@JsonKey(name: 'authorRole') FamilyRole? get authorRole;@JsonKey(name: 'body') String get body;@JsonKey(name: 'createdAt') DateTime get createdAt;@JsonKey(name: 'pendingApproval') bool get pendingApproval;/// Bình luận gốc khi đây là trả lời (MEM-10).
@JsonKey(name: 'parentId') String? get parentId;
/// Create a copy of MemoryComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryCommentCopyWith<MemoryComment> get copyWith => _$MemoryCommentCopyWithImpl<MemoryComment>(this as MemoryComment, _$identity);

  /// Serializes this MemoryComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryComment&&(identical(other.id, id) || other.id == id)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorRole, authorRole) || other.authorRole == authorRole)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.pendingApproval, pendingApproval) || other.pendingApproval == pendingApproval)&&(identical(other.parentId, parentId) || other.parentId == parentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memoryId,authorId,authorName,authorRole,body,createdAt,pendingApproval,parentId);

@override
String toString() {
  return 'MemoryComment(id: $id, memoryId: $memoryId, authorId: $authorId, authorName: $authorName, authorRole: $authorRole, body: $body, createdAt: $createdAt, pendingApproval: $pendingApproval, parentId: $parentId)';
}


}

/// @nodoc
abstract mixin class $MemoryCommentCopyWith<$Res>  {
  factory $MemoryCommentCopyWith(MemoryComment value, $Res Function(MemoryComment) _then) = _$MemoryCommentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'memoryId') String memoryId,@JsonKey(name: 'authorId') String? authorId,@JsonKey(name: 'authorName') String authorName,@JsonKey(name: 'authorRole') FamilyRole? authorRole,@JsonKey(name: 'body') String body,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'pendingApproval') bool pendingApproval,@JsonKey(name: 'parentId') String? parentId
});




}
/// @nodoc
class _$MemoryCommentCopyWithImpl<$Res>
    implements $MemoryCommentCopyWith<$Res> {
  _$MemoryCommentCopyWithImpl(this._self, this._then);

  final MemoryComment _self;
  final $Res Function(MemoryComment) _then;

/// Create a copy of MemoryComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? memoryId = null,Object? authorId = freezed,Object? authorName = null,Object? authorRole = freezed,Object? body = null,Object? createdAt = null,Object? pendingApproval = null,Object? parentId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memoryId: null == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorRole: freezed == authorRole ? _self.authorRole : authorRole // ignore: cast_nullable_to_non_nullable
as FamilyRole?,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,pendingApproval: null == pendingApproval ? _self.pendingApproval : pendingApproval // ignore: cast_nullable_to_non_nullable
as bool,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryComment].
extension MemoryCommentPatterns on MemoryComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryComment value)  $default,){
final _that = this;
switch (_that) {
case _MemoryComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryComment value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryComment() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MemoryComment implements MemoryComment {
  const _MemoryComment({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'memoryId') required this.memoryId, @JsonKey(name: 'authorId') this.authorId, @JsonKey(name: 'authorName') this.authorName = '', @JsonKey(name: 'authorRole') this.authorRole, @JsonKey(name: 'body') required this.body, @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'pendingApproval') this.pendingApproval = false, @JsonKey(name: 'parentId') this.parentId});
  factory _MemoryComment.fromJson(Map<String, dynamic> json) => _$MemoryCommentFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'memoryId') final  String memoryId;
@override@JsonKey(name: 'authorId') final  String? authorId;
@override@JsonKey(name: 'authorName') final  String authorName;
@override@JsonKey(name: 'authorRole') final  FamilyRole? authorRole;
@override@JsonKey(name: 'body') final  String body;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;
@override@JsonKey(name: 'pendingApproval') final  bool pendingApproval;
/// Bình luận gốc khi đây là trả lời (MEM-10).
@override@JsonKey(name: 'parentId') final  String? parentId;

/// Create a copy of MemoryComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryCommentCopyWith<_MemoryComment> get copyWith => __$MemoryCommentCopyWithImpl<_MemoryComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryCommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryComment&&(identical(other.id, id) || other.id == id)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorRole, authorRole) || other.authorRole == authorRole)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.pendingApproval, pendingApproval) || other.pendingApproval == pendingApproval)&&(identical(other.parentId, parentId) || other.parentId == parentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memoryId,authorId,authorName,authorRole,body,createdAt,pendingApproval,parentId);

@override
String toString() {
  return 'MemoryComment(id: $id, memoryId: $memoryId, authorId: $authorId, authorName: $authorName, authorRole: $authorRole, body: $body, createdAt: $createdAt, pendingApproval: $pendingApproval, parentId: $parentId)';
}


}

/// @nodoc
abstract mixin class _$MemoryCommentCopyWith<$Res> implements $MemoryCommentCopyWith<$Res> {
  factory _$MemoryCommentCopyWith(_MemoryComment value, $Res Function(_MemoryComment) _then) = __$MemoryCommentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'memoryId') String memoryId,@JsonKey(name: 'authorId') String? authorId,@JsonKey(name: 'authorName') String authorName,@JsonKey(name: 'authorRole') FamilyRole? authorRole,@JsonKey(name: 'body') String body,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'pendingApproval') bool pendingApproval,@JsonKey(name: 'parentId') String? parentId
});




}
/// @nodoc
class __$MemoryCommentCopyWithImpl<$Res>
    implements _$MemoryCommentCopyWith<$Res> {
  __$MemoryCommentCopyWithImpl(this._self, this._then);

  final _MemoryComment _self;
  final $Res Function(_MemoryComment) _then;

/// Create a copy of MemoryComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? memoryId = null,Object? authorId = freezed,Object? authorName = null,Object? authorRole = freezed,Object? body = null,Object? createdAt = null,Object? pendingApproval = null,Object? parentId = freezed,}) {
  return _then(_MemoryComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memoryId: null == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorRole: freezed == authorRole ? _self.authorRole : authorRole // ignore: cast_nullable_to_non_nullable
as FamilyRole?,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,pendingApproval: null == pendingApproval ? _self.pendingApproval : pendingApproval // ignore: cast_nullable_to_non_nullable
as bool,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
