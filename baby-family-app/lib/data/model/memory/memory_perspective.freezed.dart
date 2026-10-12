// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_perspective.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemoryPerspective {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'memoryId') String get memoryId;@JsonKey(name: 'authorId') String get authorId;@JsonKey(name: 'body') String get body;@JsonKey(name: 'mediaAssets') List<String> get mediaAssets;@JsonKey(name: 'createdAt') DateTime get createdAt;@JsonKey(name: 'hiddenFromRelatives') bool get hiddenFromRelatives;
/// Create a copy of MemoryPerspective
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryPerspectiveCopyWith<MemoryPerspective> get copyWith => _$MemoryPerspectiveCopyWithImpl<MemoryPerspective>(this as MemoryPerspective, _$identity);

  /// Serializes this MemoryPerspective to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryPerspective&&(identical(other.id, id) || other.id == id)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.mediaAssets, mediaAssets)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.hiddenFromRelatives, hiddenFromRelatives) || other.hiddenFromRelatives == hiddenFromRelatives));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memoryId,authorId,body,const DeepCollectionEquality().hash(mediaAssets),createdAt,hiddenFromRelatives);

@override
String toString() {
  return 'MemoryPerspective(id: $id, memoryId: $memoryId, authorId: $authorId, body: $body, mediaAssets: $mediaAssets, createdAt: $createdAt, hiddenFromRelatives: $hiddenFromRelatives)';
}


}

/// @nodoc
abstract mixin class $MemoryPerspectiveCopyWith<$Res>  {
  factory $MemoryPerspectiveCopyWith(MemoryPerspective value, $Res Function(MemoryPerspective) _then) = _$MemoryPerspectiveCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'memoryId') String memoryId,@JsonKey(name: 'authorId') String authorId,@JsonKey(name: 'body') String body,@JsonKey(name: 'mediaAssets') List<String> mediaAssets,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'hiddenFromRelatives') bool hiddenFromRelatives
});




}
/// @nodoc
class _$MemoryPerspectiveCopyWithImpl<$Res>
    implements $MemoryPerspectiveCopyWith<$Res> {
  _$MemoryPerspectiveCopyWithImpl(this._self, this._then);

  final MemoryPerspective _self;
  final $Res Function(MemoryPerspective) _then;

/// Create a copy of MemoryPerspective
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? memoryId = null,Object? authorId = null,Object? body = null,Object? mediaAssets = null,Object? createdAt = null,Object? hiddenFromRelatives = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memoryId: null == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,mediaAssets: null == mediaAssets ? _self.mediaAssets : mediaAssets // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,hiddenFromRelatives: null == hiddenFromRelatives ? _self.hiddenFromRelatives : hiddenFromRelatives // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryPerspective].
extension MemoryPerspectivePatterns on MemoryPerspective {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryPerspective value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryPerspective() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryPerspective value)  $default,){
final _that = this;
switch (_that) {
case _MemoryPerspective():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryPerspective value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryPerspective() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MemoryPerspective implements MemoryPerspective {
  const _MemoryPerspective({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'memoryId') required this.memoryId, @JsonKey(name: 'authorId') required this.authorId, @JsonKey(name: 'body') this.body = '', @JsonKey(name: 'mediaAssets') final  List<String> mediaAssets = const [], @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'hiddenFromRelatives') this.hiddenFromRelatives = false}): _mediaAssets = mediaAssets;
  factory _MemoryPerspective.fromJson(Map<String, dynamic> json) => _$MemoryPerspectiveFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'memoryId') final  String memoryId;
@override@JsonKey(name: 'authorId') final  String authorId;
@override@JsonKey(name: 'body') final  String body;
 final  List<String> _mediaAssets;
@override@JsonKey(name: 'mediaAssets') List<String> get mediaAssets {
  if (_mediaAssets is EqualUnmodifiableListView) return _mediaAssets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaAssets);
}

@override@JsonKey(name: 'createdAt') final  DateTime createdAt;
@override@JsonKey(name: 'hiddenFromRelatives') final  bool hiddenFromRelatives;

/// Create a copy of MemoryPerspective
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryPerspectiveCopyWith<_MemoryPerspective> get copyWith => __$MemoryPerspectiveCopyWithImpl<_MemoryPerspective>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryPerspectiveToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryPerspective&&(identical(other.id, id) || other.id == id)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._mediaAssets, _mediaAssets)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.hiddenFromRelatives, hiddenFromRelatives) || other.hiddenFromRelatives == hiddenFromRelatives));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memoryId,authorId,body,const DeepCollectionEquality().hash(_mediaAssets),createdAt,hiddenFromRelatives);

@override
String toString() {
  return 'MemoryPerspective(id: $id, memoryId: $memoryId, authorId: $authorId, body: $body, mediaAssets: $mediaAssets, createdAt: $createdAt, hiddenFromRelatives: $hiddenFromRelatives)';
}


}

/// @nodoc
abstract mixin class _$MemoryPerspectiveCopyWith<$Res> implements $MemoryPerspectiveCopyWith<$Res> {
  factory _$MemoryPerspectiveCopyWith(_MemoryPerspective value, $Res Function(_MemoryPerspective) _then) = __$MemoryPerspectiveCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'memoryId') String memoryId,@JsonKey(name: 'authorId') String authorId,@JsonKey(name: 'body') String body,@JsonKey(name: 'mediaAssets') List<String> mediaAssets,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'hiddenFromRelatives') bool hiddenFromRelatives
});




}
/// @nodoc
class __$MemoryPerspectiveCopyWithImpl<$Res>
    implements _$MemoryPerspectiveCopyWith<$Res> {
  __$MemoryPerspectiveCopyWithImpl(this._self, this._then);

  final _MemoryPerspective _self;
  final $Res Function(_MemoryPerspective) _then;

/// Create a copy of MemoryPerspective
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? memoryId = null,Object? authorId = null,Object? body = null,Object? mediaAssets = null,Object? createdAt = null,Object? hiddenFromRelatives = null,}) {
  return _then(_MemoryPerspective(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memoryId: null == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,mediaAssets: null == mediaAssets ? _self._mediaAssets : mediaAssets // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,hiddenFromRelatives: null == hiddenFromRelatives ? _self.hiddenFromRelatives : hiddenFromRelatives // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
