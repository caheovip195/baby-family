// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlbumRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'ownerUserId') String? get ownerUserId;@JsonKey(name: 'isSensitive') bool get isSensitive;@JsonKey(name: 'coverMemoryId') String? get coverMemoryId;@JsonKey(name: 'cover') MemoryRecord? get cover;@JsonKey(name: 'memoryCount') int get memoryCount;@JsonKey(name: 'createdAt') DateTime? get createdAt;
/// Create a copy of AlbumRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumRecordCopyWith<AlbumRecord> get copyWith => _$AlbumRecordCopyWithImpl<AlbumRecord>(this as AlbumRecord, _$identity);

  /// Serializes this AlbumRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlbumRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.isSensitive, isSensitive) || other.isSensitive == isSensitive)&&(identical(other.coverMemoryId, coverMemoryId) || other.coverMemoryId == coverMemoryId)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,ownerUserId,isSensitive,coverMemoryId,cover,memoryCount,createdAt);

@override
String toString() {
  return 'AlbumRecord(id: $id, name: $name, ownerUserId: $ownerUserId, isSensitive: $isSensitive, coverMemoryId: $coverMemoryId, cover: $cover, memoryCount: $memoryCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AlbumRecordCopyWith<$Res>  {
  factory $AlbumRecordCopyWith(AlbumRecord value, $Res Function(AlbumRecord) _then) = _$AlbumRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'ownerUserId') String? ownerUserId,@JsonKey(name: 'isSensitive') bool isSensitive,@JsonKey(name: 'coverMemoryId') String? coverMemoryId,@JsonKey(name: 'cover') MemoryRecord? cover,@JsonKey(name: 'memoryCount') int memoryCount,@JsonKey(name: 'createdAt') DateTime? createdAt
});


$MemoryRecordCopyWith<$Res>? get cover;

}
/// @nodoc
class _$AlbumRecordCopyWithImpl<$Res>
    implements $AlbumRecordCopyWith<$Res> {
  _$AlbumRecordCopyWithImpl(this._self, this._then);

  final AlbumRecord _self;
  final $Res Function(AlbumRecord) _then;

/// Create a copy of AlbumRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? ownerUserId = freezed,Object? isSensitive = null,Object? coverMemoryId = freezed,Object? cover = freezed,Object? memoryCount = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,ownerUserId: freezed == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String?,isSensitive: null == isSensitive ? _self.isSensitive : isSensitive // ignore: cast_nullable_to_non_nullable
as bool,coverMemoryId: freezed == coverMemoryId ? _self.coverMemoryId : coverMemoryId // ignore: cast_nullable_to_non_nullable
as String?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as MemoryRecord?,memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of AlbumRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemoryRecordCopyWith<$Res>? get cover {
    if (_self.cover == null) {
    return null;
  }

  return $MemoryRecordCopyWith<$Res>(_self.cover!, (value) {
    return _then(_self.copyWith(cover: value));
  });
}
}


/// Adds pattern-matching-related methods to [AlbumRecord].
extension AlbumRecordPatterns on AlbumRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlbumRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlbumRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlbumRecord value)  $default,){
final _that = this;
switch (_that) {
case _AlbumRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlbumRecord value)?  $default,){
final _that = this;
switch (_that) {
case _AlbumRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AlbumRecord implements AlbumRecord {
  const _AlbumRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'name') this.name, @JsonKey(name: 'ownerUserId') this.ownerUserId, @JsonKey(name: 'isSensitive') this.isSensitive = false, @JsonKey(name: 'coverMemoryId') this.coverMemoryId, @JsonKey(name: 'cover') this.cover, @JsonKey(name: 'memoryCount') this.memoryCount = 0, @JsonKey(name: 'createdAt') this.createdAt});
  factory _AlbumRecord.fromJson(Map<String, dynamic> json) => _$AlbumRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'ownerUserId') final  String? ownerUserId;
@override@JsonKey(name: 'isSensitive') final  bool isSensitive;
@override@JsonKey(name: 'coverMemoryId') final  String? coverMemoryId;
@override@JsonKey(name: 'cover') final  MemoryRecord? cover;
@override@JsonKey(name: 'memoryCount') final  int memoryCount;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;

/// Create a copy of AlbumRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumRecordCopyWith<_AlbumRecord> get copyWith => __$AlbumRecordCopyWithImpl<_AlbumRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlbumRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlbumRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.isSensitive, isSensitive) || other.isSensitive == isSensitive)&&(identical(other.coverMemoryId, coverMemoryId) || other.coverMemoryId == coverMemoryId)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,ownerUserId,isSensitive,coverMemoryId,cover,memoryCount,createdAt);

@override
String toString() {
  return 'AlbumRecord(id: $id, name: $name, ownerUserId: $ownerUserId, isSensitive: $isSensitive, coverMemoryId: $coverMemoryId, cover: $cover, memoryCount: $memoryCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AlbumRecordCopyWith<$Res> implements $AlbumRecordCopyWith<$Res> {
  factory _$AlbumRecordCopyWith(_AlbumRecord value, $Res Function(_AlbumRecord) _then) = __$AlbumRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'ownerUserId') String? ownerUserId,@JsonKey(name: 'isSensitive') bool isSensitive,@JsonKey(name: 'coverMemoryId') String? coverMemoryId,@JsonKey(name: 'cover') MemoryRecord? cover,@JsonKey(name: 'memoryCount') int memoryCount,@JsonKey(name: 'createdAt') DateTime? createdAt
});


@override $MemoryRecordCopyWith<$Res>? get cover;

}
/// @nodoc
class __$AlbumRecordCopyWithImpl<$Res>
    implements _$AlbumRecordCopyWith<$Res> {
  __$AlbumRecordCopyWithImpl(this._self, this._then);

  final _AlbumRecord _self;
  final $Res Function(_AlbumRecord) _then;

/// Create a copy of AlbumRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? ownerUserId = freezed,Object? isSensitive = null,Object? coverMemoryId = freezed,Object? cover = freezed,Object? memoryCount = null,Object? createdAt = freezed,}) {
  return _then(_AlbumRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,ownerUserId: freezed == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String?,isSensitive: null == isSensitive ? _self.isSensitive : isSensitive // ignore: cast_nullable_to_non_nullable
as bool,coverMemoryId: freezed == coverMemoryId ? _self.coverMemoryId : coverMemoryId // ignore: cast_nullable_to_non_nullable
as String?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as MemoryRecord?,memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of AlbumRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemoryRecordCopyWith<$Res>? get cover {
    if (_self.cover == null) {
    return null;
  }

  return $MemoryRecordCopyWith<$Res>(_self.cover!, (value) {
    return _then(_self.copyWith(cover: value));
  });
}
}

// dart format on
