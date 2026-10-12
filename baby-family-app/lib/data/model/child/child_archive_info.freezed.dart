// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_archive_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChildArchiveInfo {

@JsonKey(name: 'childId') String get childId;@JsonKey(name: 'addedByUserId') String? get addedByUserId;@JsonKey(name: 'addedAt') DateTime? get addedAt;@JsonKey(name: 'duplicateOfChildId') String? get duplicateOfChildId;@JsonKey(name: 'privateMemoryCount') int get privateMemoryCount;@JsonKey(name: 'sharedMemoryCount') int get sharedMemoryCount;@JsonKey(name: 'sharedWithChildIds') List<String> get sharedWithChildIds;@JsonKey(name: 'archivedAt') DateTime? get archivedAt;@JsonKey(name: 'deletableFrom') DateTime? get deletableFrom;
/// Create a copy of ChildArchiveInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildArchiveInfoCopyWith<ChildArchiveInfo> get copyWith => _$ChildArchiveInfoCopyWithImpl<ChildArchiveInfo>(this as ChildArchiveInfo, _$identity);

  /// Serializes this ChildArchiveInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChildArchiveInfo&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.addedByUserId, addedByUserId) || other.addedByUserId == addedByUserId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.duplicateOfChildId, duplicateOfChildId) || other.duplicateOfChildId == duplicateOfChildId)&&(identical(other.privateMemoryCount, privateMemoryCount) || other.privateMemoryCount == privateMemoryCount)&&(identical(other.sharedMemoryCount, sharedMemoryCount) || other.sharedMemoryCount == sharedMemoryCount)&&const DeepCollectionEquality().equals(other.sharedWithChildIds, sharedWithChildIds)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.deletableFrom, deletableFrom) || other.deletableFrom == deletableFrom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,addedByUserId,addedAt,duplicateOfChildId,privateMemoryCount,sharedMemoryCount,const DeepCollectionEquality().hash(sharedWithChildIds),archivedAt,deletableFrom);

@override
String toString() {
  return 'ChildArchiveInfo(childId: $childId, addedByUserId: $addedByUserId, addedAt: $addedAt, duplicateOfChildId: $duplicateOfChildId, privateMemoryCount: $privateMemoryCount, sharedMemoryCount: $sharedMemoryCount, sharedWithChildIds: $sharedWithChildIds, archivedAt: $archivedAt, deletableFrom: $deletableFrom)';
}


}

/// @nodoc
abstract mixin class $ChildArchiveInfoCopyWith<$Res>  {
  factory $ChildArchiveInfoCopyWith(ChildArchiveInfo value, $Res Function(ChildArchiveInfo) _then) = _$ChildArchiveInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'childId') String childId,@JsonKey(name: 'addedByUserId') String? addedByUserId,@JsonKey(name: 'addedAt') DateTime? addedAt,@JsonKey(name: 'duplicateOfChildId') String? duplicateOfChildId,@JsonKey(name: 'privateMemoryCount') int privateMemoryCount,@JsonKey(name: 'sharedMemoryCount') int sharedMemoryCount,@JsonKey(name: 'sharedWithChildIds') List<String> sharedWithChildIds,@JsonKey(name: 'archivedAt') DateTime? archivedAt,@JsonKey(name: 'deletableFrom') DateTime? deletableFrom
});




}
/// @nodoc
class _$ChildArchiveInfoCopyWithImpl<$Res>
    implements $ChildArchiveInfoCopyWith<$Res> {
  _$ChildArchiveInfoCopyWithImpl(this._self, this._then);

  final ChildArchiveInfo _self;
  final $Res Function(ChildArchiveInfo) _then;

/// Create a copy of ChildArchiveInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childId = null,Object? addedByUserId = freezed,Object? addedAt = freezed,Object? duplicateOfChildId = freezed,Object? privateMemoryCount = null,Object? sharedMemoryCount = null,Object? sharedWithChildIds = null,Object? archivedAt = freezed,Object? deletableFrom = freezed,}) {
  return _then(_self.copyWith(
childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,addedByUserId: freezed == addedByUserId ? _self.addedByUserId : addedByUserId // ignore: cast_nullable_to_non_nullable
as String?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,duplicateOfChildId: freezed == duplicateOfChildId ? _self.duplicateOfChildId : duplicateOfChildId // ignore: cast_nullable_to_non_nullable
as String?,privateMemoryCount: null == privateMemoryCount ? _self.privateMemoryCount : privateMemoryCount // ignore: cast_nullable_to_non_nullable
as int,sharedMemoryCount: null == sharedMemoryCount ? _self.sharedMemoryCount : sharedMemoryCount // ignore: cast_nullable_to_non_nullable
as int,sharedWithChildIds: null == sharedWithChildIds ? _self.sharedWithChildIds : sharedWithChildIds // ignore: cast_nullable_to_non_nullable
as List<String>,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletableFrom: freezed == deletableFrom ? _self.deletableFrom : deletableFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChildArchiveInfo].
extension ChildArchiveInfoPatterns on ChildArchiveInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChildArchiveInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChildArchiveInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChildArchiveInfo value)  $default,){
final _that = this;
switch (_that) {
case _ChildArchiveInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChildArchiveInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ChildArchiveInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChildArchiveInfo extends ChildArchiveInfo {
  const _ChildArchiveInfo({@JsonKey(name: 'childId') required this.childId, @JsonKey(name: 'addedByUserId') this.addedByUserId, @JsonKey(name: 'addedAt') this.addedAt, @JsonKey(name: 'duplicateOfChildId') this.duplicateOfChildId, @JsonKey(name: 'privateMemoryCount') this.privateMemoryCount = 0, @JsonKey(name: 'sharedMemoryCount') this.sharedMemoryCount = 0, @JsonKey(name: 'sharedWithChildIds') final  List<String> sharedWithChildIds = const [], @JsonKey(name: 'archivedAt') this.archivedAt, @JsonKey(name: 'deletableFrom') this.deletableFrom}): _sharedWithChildIds = sharedWithChildIds,super._();
  factory _ChildArchiveInfo.fromJson(Map<String, dynamic> json) => _$ChildArchiveInfoFromJson(json);

@override@JsonKey(name: 'childId') final  String childId;
@override@JsonKey(name: 'addedByUserId') final  String? addedByUserId;
@override@JsonKey(name: 'addedAt') final  DateTime? addedAt;
@override@JsonKey(name: 'duplicateOfChildId') final  String? duplicateOfChildId;
@override@JsonKey(name: 'privateMemoryCount') final  int privateMemoryCount;
@override@JsonKey(name: 'sharedMemoryCount') final  int sharedMemoryCount;
 final  List<String> _sharedWithChildIds;
@override@JsonKey(name: 'sharedWithChildIds') List<String> get sharedWithChildIds {
  if (_sharedWithChildIds is EqualUnmodifiableListView) return _sharedWithChildIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sharedWithChildIds);
}

@override@JsonKey(name: 'archivedAt') final  DateTime? archivedAt;
@override@JsonKey(name: 'deletableFrom') final  DateTime? deletableFrom;

/// Create a copy of ChildArchiveInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildArchiveInfoCopyWith<_ChildArchiveInfo> get copyWith => __$ChildArchiveInfoCopyWithImpl<_ChildArchiveInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChildArchiveInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChildArchiveInfo&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.addedByUserId, addedByUserId) || other.addedByUserId == addedByUserId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.duplicateOfChildId, duplicateOfChildId) || other.duplicateOfChildId == duplicateOfChildId)&&(identical(other.privateMemoryCount, privateMemoryCount) || other.privateMemoryCount == privateMemoryCount)&&(identical(other.sharedMemoryCount, sharedMemoryCount) || other.sharedMemoryCount == sharedMemoryCount)&&const DeepCollectionEquality().equals(other._sharedWithChildIds, _sharedWithChildIds)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.deletableFrom, deletableFrom) || other.deletableFrom == deletableFrom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,addedByUserId,addedAt,duplicateOfChildId,privateMemoryCount,sharedMemoryCount,const DeepCollectionEquality().hash(_sharedWithChildIds),archivedAt,deletableFrom);

@override
String toString() {
  return 'ChildArchiveInfo(childId: $childId, addedByUserId: $addedByUserId, addedAt: $addedAt, duplicateOfChildId: $duplicateOfChildId, privateMemoryCount: $privateMemoryCount, sharedMemoryCount: $sharedMemoryCount, sharedWithChildIds: $sharedWithChildIds, archivedAt: $archivedAt, deletableFrom: $deletableFrom)';
}


}

/// @nodoc
abstract mixin class _$ChildArchiveInfoCopyWith<$Res> implements $ChildArchiveInfoCopyWith<$Res> {
  factory _$ChildArchiveInfoCopyWith(_ChildArchiveInfo value, $Res Function(_ChildArchiveInfo) _then) = __$ChildArchiveInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'childId') String childId,@JsonKey(name: 'addedByUserId') String? addedByUserId,@JsonKey(name: 'addedAt') DateTime? addedAt,@JsonKey(name: 'duplicateOfChildId') String? duplicateOfChildId,@JsonKey(name: 'privateMemoryCount') int privateMemoryCount,@JsonKey(name: 'sharedMemoryCount') int sharedMemoryCount,@JsonKey(name: 'sharedWithChildIds') List<String> sharedWithChildIds,@JsonKey(name: 'archivedAt') DateTime? archivedAt,@JsonKey(name: 'deletableFrom') DateTime? deletableFrom
});




}
/// @nodoc
class __$ChildArchiveInfoCopyWithImpl<$Res>
    implements _$ChildArchiveInfoCopyWith<$Res> {
  __$ChildArchiveInfoCopyWithImpl(this._self, this._then);

  final _ChildArchiveInfo _self;
  final $Res Function(_ChildArchiveInfo) _then;

/// Create a copy of ChildArchiveInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childId = null,Object? addedByUserId = freezed,Object? addedAt = freezed,Object? duplicateOfChildId = freezed,Object? privateMemoryCount = null,Object? sharedMemoryCount = null,Object? sharedWithChildIds = null,Object? archivedAt = freezed,Object? deletableFrom = freezed,}) {
  return _then(_ChildArchiveInfo(
childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,addedByUserId: freezed == addedByUserId ? _self.addedByUserId : addedByUserId // ignore: cast_nullable_to_non_nullable
as String?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,duplicateOfChildId: freezed == duplicateOfChildId ? _self.duplicateOfChildId : duplicateOfChildId // ignore: cast_nullable_to_non_nullable
as String?,privateMemoryCount: null == privateMemoryCount ? _self.privateMemoryCount : privateMemoryCount // ignore: cast_nullable_to_non_nullable
as int,sharedMemoryCount: null == sharedMemoryCount ? _self.sharedMemoryCount : sharedMemoryCount // ignore: cast_nullable_to_non_nullable
as int,sharedWithChildIds: null == sharedWithChildIds ? _self._sharedWithChildIds : sharedWithChildIds // ignore: cast_nullable_to_non_nullable
as List<String>,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletableFrom: freezed == deletableFrom ? _self.deletableFrom : deletableFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
