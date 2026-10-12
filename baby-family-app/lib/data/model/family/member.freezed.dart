// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Member {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'familyId') String get familyId;@JsonKey(name: 'userId') String? get userId;@JsonKey(name: 'role') FamilyRole get role;@JsonKey(name: 'slot') ParentSlot? get slot;@JsonKey(name: 'status') MemberStatus get status;@JsonKey(name: 'displayName') String get displayName;@JsonKey(name: 'callName') String get callName;@JsonKey(name: 'avatarAsset') String? get avatarAsset;@JsonKey(name: 'relation') RelativeRelation? get relation;@JsonKey(name: 'grantedChildIds') List<String> get grantedChildIds;@JsonKey(name: 'canComment') bool get canComment;@JsonKey(name: 'canPost') bool get canPost;@JsonKey(name: 'isAdmin') bool get isAdmin;@JsonKey(name: 'joinedAt') DateTime? get joinedAt;/// FAM-04: quyền theo từng bé; bé không có trong map = chưa chia sẻ.
@JsonKey(name: 'childPermissions') Map<String, RelativePermission> get childPermissions;@JsonKey(name: 'allowDownload') bool get allowDownload;@JsonKey(name: 'notificationsMuted') bool get notificationsMuted;@JsonKey(name: 'paused') bool get paused;@JsonKey(name: 'lastActiveAt') DateTime? get lastActiveAt;@JsonKey(name: 'phoneMasked') String? get phoneMasked;@JsonKey(name: 'postedCount') int get postedCount;
/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberCopyWith<Member> get copyWith => _$MemberCopyWithImpl<Member>(this as Member, _$identity);

  /// Serializes this Member to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Member&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.status, status) || other.status == status)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.callName, callName) || other.callName == callName)&&(identical(other.avatarAsset, avatarAsset) || other.avatarAsset == avatarAsset)&&(identical(other.relation, relation) || other.relation == relation)&&const DeepCollectionEquality().equals(other.grantedChildIds, grantedChildIds)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canPost, canPost) || other.canPost == canPost)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&const DeepCollectionEquality().equals(other.childPermissions, childPermissions)&&(identical(other.allowDownload, allowDownload) || other.allowDownload == allowDownload)&&(identical(other.notificationsMuted, notificationsMuted) || other.notificationsMuted == notificationsMuted)&&(identical(other.paused, paused) || other.paused == paused)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.phoneMasked, phoneMasked) || other.phoneMasked == phoneMasked)&&(identical(other.postedCount, postedCount) || other.postedCount == postedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,familyId,userId,role,slot,status,displayName,callName,avatarAsset,relation,const DeepCollectionEquality().hash(grantedChildIds),canComment,canPost,isAdmin,joinedAt,const DeepCollectionEquality().hash(childPermissions),allowDownload,notificationsMuted,paused,lastActiveAt,phoneMasked,postedCount]);

@override
String toString() {
  return 'Member(id: $id, familyId: $familyId, userId: $userId, role: $role, slot: $slot, status: $status, displayName: $displayName, callName: $callName, avatarAsset: $avatarAsset, relation: $relation, grantedChildIds: $grantedChildIds, canComment: $canComment, canPost: $canPost, isAdmin: $isAdmin, joinedAt: $joinedAt, childPermissions: $childPermissions, allowDownload: $allowDownload, notificationsMuted: $notificationsMuted, paused: $paused, lastActiveAt: $lastActiveAt, phoneMasked: $phoneMasked, postedCount: $postedCount)';
}


}

/// @nodoc
abstract mixin class $MemberCopyWith<$Res>  {
  factory $MemberCopyWith(Member value, $Res Function(Member) _then) = _$MemberCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'familyId') String familyId,@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'role') FamilyRole role,@JsonKey(name: 'slot') ParentSlot? slot,@JsonKey(name: 'status') MemberStatus status,@JsonKey(name: 'displayName') String displayName,@JsonKey(name: 'callName') String callName,@JsonKey(name: 'avatarAsset') String? avatarAsset,@JsonKey(name: 'relation') RelativeRelation? relation,@JsonKey(name: 'grantedChildIds') List<String> grantedChildIds,@JsonKey(name: 'canComment') bool canComment,@JsonKey(name: 'canPost') bool canPost,@JsonKey(name: 'isAdmin') bool isAdmin,@JsonKey(name: 'joinedAt') DateTime? joinedAt,@JsonKey(name: 'childPermissions') Map<String, RelativePermission> childPermissions,@JsonKey(name: 'allowDownload') bool allowDownload,@JsonKey(name: 'notificationsMuted') bool notificationsMuted,@JsonKey(name: 'paused') bool paused,@JsonKey(name: 'lastActiveAt') DateTime? lastActiveAt,@JsonKey(name: 'phoneMasked') String? phoneMasked,@JsonKey(name: 'postedCount') int postedCount
});




}
/// @nodoc
class _$MemberCopyWithImpl<$Res>
    implements $MemberCopyWith<$Res> {
  _$MemberCopyWithImpl(this._self, this._then);

  final Member _self;
  final $Res Function(Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? familyId = null,Object? userId = freezed,Object? role = null,Object? slot = freezed,Object? status = null,Object? displayName = null,Object? callName = null,Object? avatarAsset = freezed,Object? relation = freezed,Object? grantedChildIds = null,Object? canComment = null,Object? canPost = null,Object? isAdmin = null,Object? joinedAt = freezed,Object? childPermissions = null,Object? allowDownload = null,Object? notificationsMuted = null,Object? paused = null,Object? lastActiveAt = freezed,Object? phoneMasked = freezed,Object? postedCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FamilyRole,slot: freezed == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as ParentSlot?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,callName: null == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String,avatarAsset: freezed == avatarAsset ? _self.avatarAsset : avatarAsset // ignore: cast_nullable_to_non_nullable
as String?,relation: freezed == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as RelativeRelation?,grantedChildIds: null == grantedChildIds ? _self.grantedChildIds : grantedChildIds // ignore: cast_nullable_to_non_nullable
as List<String>,canComment: null == canComment ? _self.canComment : canComment // ignore: cast_nullable_to_non_nullable
as bool,canPost: null == canPost ? _self.canPost : canPost // ignore: cast_nullable_to_non_nullable
as bool,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,childPermissions: null == childPermissions ? _self.childPermissions : childPermissions // ignore: cast_nullable_to_non_nullable
as Map<String, RelativePermission>,allowDownload: null == allowDownload ? _self.allowDownload : allowDownload // ignore: cast_nullable_to_non_nullable
as bool,notificationsMuted: null == notificationsMuted ? _self.notificationsMuted : notificationsMuted // ignore: cast_nullable_to_non_nullable
as bool,paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as bool,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,phoneMasked: freezed == phoneMasked ? _self.phoneMasked : phoneMasked // ignore: cast_nullable_to_non_nullable
as String?,postedCount: null == postedCount ? _self.postedCount : postedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Member].
extension MemberPatterns on Member {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Member value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Member() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Member value)  $default,){
final _that = this;
switch (_that) {
case _Member():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Member value)?  $default,){
final _that = this;
switch (_that) {
case _Member() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Member implements Member {
  const _Member({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'familyId') required this.familyId, @JsonKey(name: 'userId') this.userId, @JsonKey(name: 'role') required this.role, @JsonKey(name: 'slot') this.slot, @JsonKey(name: 'status') this.status = MemberStatus.active, @JsonKey(name: 'displayName') this.displayName = '', @JsonKey(name: 'callName') this.callName = '', @JsonKey(name: 'avatarAsset') this.avatarAsset, @JsonKey(name: 'relation') this.relation, @JsonKey(name: 'grantedChildIds') final  List<String> grantedChildIds = const [], @JsonKey(name: 'canComment') this.canComment = false, @JsonKey(name: 'canPost') this.canPost = false, @JsonKey(name: 'isAdmin') this.isAdmin = false, @JsonKey(name: 'joinedAt') this.joinedAt, @JsonKey(name: 'childPermissions') final  Map<String, RelativePermission> childPermissions = const {}, @JsonKey(name: 'allowDownload') this.allowDownload = false, @JsonKey(name: 'notificationsMuted') this.notificationsMuted = false, @JsonKey(name: 'paused') this.paused = false, @JsonKey(name: 'lastActiveAt') this.lastActiveAt, @JsonKey(name: 'phoneMasked') this.phoneMasked, @JsonKey(name: 'postedCount') this.postedCount = 0}): _grantedChildIds = grantedChildIds,_childPermissions = childPermissions;
  factory _Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'familyId') final  String familyId;
@override@JsonKey(name: 'userId') final  String? userId;
@override@JsonKey(name: 'role') final  FamilyRole role;
@override@JsonKey(name: 'slot') final  ParentSlot? slot;
@override@JsonKey(name: 'status') final  MemberStatus status;
@override@JsonKey(name: 'displayName') final  String displayName;
@override@JsonKey(name: 'callName') final  String callName;
@override@JsonKey(name: 'avatarAsset') final  String? avatarAsset;
@override@JsonKey(name: 'relation') final  RelativeRelation? relation;
 final  List<String> _grantedChildIds;
@override@JsonKey(name: 'grantedChildIds') List<String> get grantedChildIds {
  if (_grantedChildIds is EqualUnmodifiableListView) return _grantedChildIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grantedChildIds);
}

@override@JsonKey(name: 'canComment') final  bool canComment;
@override@JsonKey(name: 'canPost') final  bool canPost;
@override@JsonKey(name: 'isAdmin') final  bool isAdmin;
@override@JsonKey(name: 'joinedAt') final  DateTime? joinedAt;
/// FAM-04: quyền theo từng bé; bé không có trong map = chưa chia sẻ.
 final  Map<String, RelativePermission> _childPermissions;
/// FAM-04: quyền theo từng bé; bé không có trong map = chưa chia sẻ.
@override@JsonKey(name: 'childPermissions') Map<String, RelativePermission> get childPermissions {
  if (_childPermissions is EqualUnmodifiableMapView) return _childPermissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_childPermissions);
}

@override@JsonKey(name: 'allowDownload') final  bool allowDownload;
@override@JsonKey(name: 'notificationsMuted') final  bool notificationsMuted;
@override@JsonKey(name: 'paused') final  bool paused;
@override@JsonKey(name: 'lastActiveAt') final  DateTime? lastActiveAt;
@override@JsonKey(name: 'phoneMasked') final  String? phoneMasked;
@override@JsonKey(name: 'postedCount') final  int postedCount;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberCopyWith<_Member> get copyWith => __$MemberCopyWithImpl<_Member>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Member&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.status, status) || other.status == status)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.callName, callName) || other.callName == callName)&&(identical(other.avatarAsset, avatarAsset) || other.avatarAsset == avatarAsset)&&(identical(other.relation, relation) || other.relation == relation)&&const DeepCollectionEquality().equals(other._grantedChildIds, _grantedChildIds)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canPost, canPost) || other.canPost == canPost)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&const DeepCollectionEquality().equals(other._childPermissions, _childPermissions)&&(identical(other.allowDownload, allowDownload) || other.allowDownload == allowDownload)&&(identical(other.notificationsMuted, notificationsMuted) || other.notificationsMuted == notificationsMuted)&&(identical(other.paused, paused) || other.paused == paused)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.phoneMasked, phoneMasked) || other.phoneMasked == phoneMasked)&&(identical(other.postedCount, postedCount) || other.postedCount == postedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,familyId,userId,role,slot,status,displayName,callName,avatarAsset,relation,const DeepCollectionEquality().hash(_grantedChildIds),canComment,canPost,isAdmin,joinedAt,const DeepCollectionEquality().hash(_childPermissions),allowDownload,notificationsMuted,paused,lastActiveAt,phoneMasked,postedCount]);

@override
String toString() {
  return 'Member(id: $id, familyId: $familyId, userId: $userId, role: $role, slot: $slot, status: $status, displayName: $displayName, callName: $callName, avatarAsset: $avatarAsset, relation: $relation, grantedChildIds: $grantedChildIds, canComment: $canComment, canPost: $canPost, isAdmin: $isAdmin, joinedAt: $joinedAt, childPermissions: $childPermissions, allowDownload: $allowDownload, notificationsMuted: $notificationsMuted, paused: $paused, lastActiveAt: $lastActiveAt, phoneMasked: $phoneMasked, postedCount: $postedCount)';
}


}

/// @nodoc
abstract mixin class _$MemberCopyWith<$Res> implements $MemberCopyWith<$Res> {
  factory _$MemberCopyWith(_Member value, $Res Function(_Member) _then) = __$MemberCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'familyId') String familyId,@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'role') FamilyRole role,@JsonKey(name: 'slot') ParentSlot? slot,@JsonKey(name: 'status') MemberStatus status,@JsonKey(name: 'displayName') String displayName,@JsonKey(name: 'callName') String callName,@JsonKey(name: 'avatarAsset') String? avatarAsset,@JsonKey(name: 'relation') RelativeRelation? relation,@JsonKey(name: 'grantedChildIds') List<String> grantedChildIds,@JsonKey(name: 'canComment') bool canComment,@JsonKey(name: 'canPost') bool canPost,@JsonKey(name: 'isAdmin') bool isAdmin,@JsonKey(name: 'joinedAt') DateTime? joinedAt,@JsonKey(name: 'childPermissions') Map<String, RelativePermission> childPermissions,@JsonKey(name: 'allowDownload') bool allowDownload,@JsonKey(name: 'notificationsMuted') bool notificationsMuted,@JsonKey(name: 'paused') bool paused,@JsonKey(name: 'lastActiveAt') DateTime? lastActiveAt,@JsonKey(name: 'phoneMasked') String? phoneMasked,@JsonKey(name: 'postedCount') int postedCount
});




}
/// @nodoc
class __$MemberCopyWithImpl<$Res>
    implements _$MemberCopyWith<$Res> {
  __$MemberCopyWithImpl(this._self, this._then);

  final _Member _self;
  final $Res Function(_Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? familyId = null,Object? userId = freezed,Object? role = null,Object? slot = freezed,Object? status = null,Object? displayName = null,Object? callName = null,Object? avatarAsset = freezed,Object? relation = freezed,Object? grantedChildIds = null,Object? canComment = null,Object? canPost = null,Object? isAdmin = null,Object? joinedAt = freezed,Object? childPermissions = null,Object? allowDownload = null,Object? notificationsMuted = null,Object? paused = null,Object? lastActiveAt = freezed,Object? phoneMasked = freezed,Object? postedCount = null,}) {
  return _then(_Member(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FamilyRole,slot: freezed == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as ParentSlot?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,callName: null == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String,avatarAsset: freezed == avatarAsset ? _self.avatarAsset : avatarAsset // ignore: cast_nullable_to_non_nullable
as String?,relation: freezed == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as RelativeRelation?,grantedChildIds: null == grantedChildIds ? _self._grantedChildIds : grantedChildIds // ignore: cast_nullable_to_non_nullable
as List<String>,canComment: null == canComment ? _self.canComment : canComment // ignore: cast_nullable_to_non_nullable
as bool,canPost: null == canPost ? _self.canPost : canPost // ignore: cast_nullable_to_non_nullable
as bool,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,childPermissions: null == childPermissions ? _self._childPermissions : childPermissions // ignore: cast_nullable_to_non_nullable
as Map<String, RelativePermission>,allowDownload: null == allowDownload ? _self.allowDownload : allowDownload // ignore: cast_nullable_to_non_nullable
as bool,notificationsMuted: null == notificationsMuted ? _self.notificationsMuted : notificationsMuted // ignore: cast_nullable_to_non_nullable
as bool,paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as bool,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,phoneMasked: freezed == phoneMasked ? _self.phoneMasked : phoneMasked // ignore: cast_nullable_to_non_nullable
as String?,postedCount: null == postedCount ? _self.postedCount : postedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
