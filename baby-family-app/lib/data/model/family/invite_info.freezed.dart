// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InviteInfo {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'code') String get code;@JsonKey(name: 'kind') InviteKind get kind;@JsonKey(name: 'familyId') String get familyId;@JsonKey(name: 'familyName') String? get familyName;@JsonKey(name: 'inviterName') String? get inviterName;@JsonKey(name: 'inviterCallName') String? get inviterCallName;@JsonKey(name: 'inviterAvatarAsset') String? get inviterAvatarAsset;@JsonKey(name: 'memberId') String? get memberId;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'role') FamilyRole get role;@JsonKey(name: 'relation') RelativeRelation? get relation;@JsonKey(name: 'callName') String? get callName;@JsonKey(name: 'grantedChildIds') List<String> get grantedChildIds;@JsonKey(name: 'canComment') bool get canComment;@JsonKey(name: 'canPost') bool get canPost;@JsonKey(name: 'link') String? get link;@JsonKey(name: 'sentAt') DateTime? get sentAt;@JsonKey(name: 'openedAt') DateTime? get openedAt;@JsonKey(name: 'expiresAt') DateTime? get expiresAt;@JsonKey(name: 'status') String get status;
/// Create a copy of InviteInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InviteInfoCopyWith<InviteInfo> get copyWith => _$InviteInfoCopyWithImpl<InviteInfo>(this as InviteInfo, _$identity);

  /// Serializes this InviteInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InviteInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.inviterName, inviterName) || other.inviterName == inviterName)&&(identical(other.inviterCallName, inviterCallName) || other.inviterCallName == inviterCallName)&&(identical(other.inviterAvatarAsset, inviterAvatarAsset) || other.inviterAvatarAsset == inviterAvatarAsset)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.message, message) || other.message == message)&&(identical(other.role, role) || other.role == role)&&(identical(other.relation, relation) || other.relation == relation)&&(identical(other.callName, callName) || other.callName == callName)&&const DeepCollectionEquality().equals(other.grantedChildIds, grantedChildIds)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canPost, canPost) || other.canPost == canPost)&&(identical(other.link, link) || other.link == link)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,code,kind,familyId,familyName,inviterName,inviterCallName,inviterAvatarAsset,memberId,message,role,relation,callName,const DeepCollectionEquality().hash(grantedChildIds),canComment,canPost,link,sentAt,openedAt,expiresAt,status]);

@override
String toString() {
  return 'InviteInfo(id: $id, code: $code, kind: $kind, familyId: $familyId, familyName: $familyName, inviterName: $inviterName, inviterCallName: $inviterCallName, inviterAvatarAsset: $inviterAvatarAsset, memberId: $memberId, message: $message, role: $role, relation: $relation, callName: $callName, grantedChildIds: $grantedChildIds, canComment: $canComment, canPost: $canPost, link: $link, sentAt: $sentAt, openedAt: $openedAt, expiresAt: $expiresAt, status: $status)';
}


}

/// @nodoc
abstract mixin class $InviteInfoCopyWith<$Res>  {
  factory $InviteInfoCopyWith(InviteInfo value, $Res Function(InviteInfo) _then) = _$InviteInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'code') String code,@JsonKey(name: 'kind') InviteKind kind,@JsonKey(name: 'familyId') String familyId,@JsonKey(name: 'familyName') String? familyName,@JsonKey(name: 'inviterName') String? inviterName,@JsonKey(name: 'inviterCallName') String? inviterCallName,@JsonKey(name: 'inviterAvatarAsset') String? inviterAvatarAsset,@JsonKey(name: 'memberId') String? memberId,@JsonKey(name: 'message') String? message,@JsonKey(name: 'role') FamilyRole role,@JsonKey(name: 'relation') RelativeRelation? relation,@JsonKey(name: 'callName') String? callName,@JsonKey(name: 'grantedChildIds') List<String> grantedChildIds,@JsonKey(name: 'canComment') bool canComment,@JsonKey(name: 'canPost') bool canPost,@JsonKey(name: 'link') String? link,@JsonKey(name: 'sentAt') DateTime? sentAt,@JsonKey(name: 'openedAt') DateTime? openedAt,@JsonKey(name: 'expiresAt') DateTime? expiresAt,@JsonKey(name: 'status') String status
});




}
/// @nodoc
class _$InviteInfoCopyWithImpl<$Res>
    implements $InviteInfoCopyWith<$Res> {
  _$InviteInfoCopyWithImpl(this._self, this._then);

  final InviteInfo _self;
  final $Res Function(InviteInfo) _then;

/// Create a copy of InviteInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? kind = null,Object? familyId = null,Object? familyName = freezed,Object? inviterName = freezed,Object? inviterCallName = freezed,Object? inviterAvatarAsset = freezed,Object? memberId = freezed,Object? message = freezed,Object? role = null,Object? relation = freezed,Object? callName = freezed,Object? grantedChildIds = null,Object? canComment = null,Object? canPost = null,Object? link = freezed,Object? sentAt = freezed,Object? openedAt = freezed,Object? expiresAt = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as InviteKind,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,familyName: freezed == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String?,inviterName: freezed == inviterName ? _self.inviterName : inviterName // ignore: cast_nullable_to_non_nullable
as String?,inviterCallName: freezed == inviterCallName ? _self.inviterCallName : inviterCallName // ignore: cast_nullable_to_non_nullable
as String?,inviterAvatarAsset: freezed == inviterAvatarAsset ? _self.inviterAvatarAsset : inviterAvatarAsset // ignore: cast_nullable_to_non_nullable
as String?,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FamilyRole,relation: freezed == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as RelativeRelation?,callName: freezed == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String?,grantedChildIds: null == grantedChildIds ? _self.grantedChildIds : grantedChildIds // ignore: cast_nullable_to_non_nullable
as List<String>,canComment: null == canComment ? _self.canComment : canComment // ignore: cast_nullable_to_non_nullable
as bool,canPost: null == canPost ? _self.canPost : canPost // ignore: cast_nullable_to_non_nullable
as bool,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,openedAt: freezed == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InviteInfo].
extension InviteInfoPatterns on InviteInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InviteInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InviteInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InviteInfo value)  $default,){
final _that = this;
switch (_that) {
case _InviteInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InviteInfo value)?  $default,){
final _that = this;
switch (_that) {
case _InviteInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _InviteInfo implements InviteInfo {
  const _InviteInfo({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'code') required this.code, @JsonKey(name: 'kind') required this.kind, @JsonKey(name: 'familyId') required this.familyId, @JsonKey(name: 'familyName') this.familyName, @JsonKey(name: 'inviterName') this.inviterName, @JsonKey(name: 'inviterCallName') this.inviterCallName, @JsonKey(name: 'inviterAvatarAsset') this.inviterAvatarAsset, @JsonKey(name: 'memberId') this.memberId, @JsonKey(name: 'message') this.message, @JsonKey(name: 'role') this.role = FamilyRole.relative, @JsonKey(name: 'relation') this.relation, @JsonKey(name: 'callName') this.callName, @JsonKey(name: 'grantedChildIds') final  List<String> grantedChildIds = const [], @JsonKey(name: 'canComment') this.canComment = false, @JsonKey(name: 'canPost') this.canPost = false, @JsonKey(name: 'link') this.link, @JsonKey(name: 'sentAt') this.sentAt, @JsonKey(name: 'openedAt') this.openedAt, @JsonKey(name: 'expiresAt') this.expiresAt, @JsonKey(name: 'status') this.status = 'open'}): _grantedChildIds = grantedChildIds;
  factory _InviteInfo.fromJson(Map<String, dynamic> json) => _$InviteInfoFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'kind') final  InviteKind kind;
@override@JsonKey(name: 'familyId') final  String familyId;
@override@JsonKey(name: 'familyName') final  String? familyName;
@override@JsonKey(name: 'inviterName') final  String? inviterName;
@override@JsonKey(name: 'inviterCallName') final  String? inviterCallName;
@override@JsonKey(name: 'inviterAvatarAsset') final  String? inviterAvatarAsset;
@override@JsonKey(name: 'memberId') final  String? memberId;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'role') final  FamilyRole role;
@override@JsonKey(name: 'relation') final  RelativeRelation? relation;
@override@JsonKey(name: 'callName') final  String? callName;
 final  List<String> _grantedChildIds;
@override@JsonKey(name: 'grantedChildIds') List<String> get grantedChildIds {
  if (_grantedChildIds is EqualUnmodifiableListView) return _grantedChildIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grantedChildIds);
}

@override@JsonKey(name: 'canComment') final  bool canComment;
@override@JsonKey(name: 'canPost') final  bool canPost;
@override@JsonKey(name: 'link') final  String? link;
@override@JsonKey(name: 'sentAt') final  DateTime? sentAt;
@override@JsonKey(name: 'openedAt') final  DateTime? openedAt;
@override@JsonKey(name: 'expiresAt') final  DateTime? expiresAt;
@override@JsonKey(name: 'status') final  String status;

/// Create a copy of InviteInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteInfoCopyWith<_InviteInfo> get copyWith => __$InviteInfoCopyWithImpl<_InviteInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InviteInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.inviterName, inviterName) || other.inviterName == inviterName)&&(identical(other.inviterCallName, inviterCallName) || other.inviterCallName == inviterCallName)&&(identical(other.inviterAvatarAsset, inviterAvatarAsset) || other.inviterAvatarAsset == inviterAvatarAsset)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.message, message) || other.message == message)&&(identical(other.role, role) || other.role == role)&&(identical(other.relation, relation) || other.relation == relation)&&(identical(other.callName, callName) || other.callName == callName)&&const DeepCollectionEquality().equals(other._grantedChildIds, _grantedChildIds)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canPost, canPost) || other.canPost == canPost)&&(identical(other.link, link) || other.link == link)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,code,kind,familyId,familyName,inviterName,inviterCallName,inviterAvatarAsset,memberId,message,role,relation,callName,const DeepCollectionEquality().hash(_grantedChildIds),canComment,canPost,link,sentAt,openedAt,expiresAt,status]);

@override
String toString() {
  return 'InviteInfo(id: $id, code: $code, kind: $kind, familyId: $familyId, familyName: $familyName, inviterName: $inviterName, inviterCallName: $inviterCallName, inviterAvatarAsset: $inviterAvatarAsset, memberId: $memberId, message: $message, role: $role, relation: $relation, callName: $callName, grantedChildIds: $grantedChildIds, canComment: $canComment, canPost: $canPost, link: $link, sentAt: $sentAt, openedAt: $openedAt, expiresAt: $expiresAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$InviteInfoCopyWith<$Res> implements $InviteInfoCopyWith<$Res> {
  factory _$InviteInfoCopyWith(_InviteInfo value, $Res Function(_InviteInfo) _then) = __$InviteInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'code') String code,@JsonKey(name: 'kind') InviteKind kind,@JsonKey(name: 'familyId') String familyId,@JsonKey(name: 'familyName') String? familyName,@JsonKey(name: 'inviterName') String? inviterName,@JsonKey(name: 'inviterCallName') String? inviterCallName,@JsonKey(name: 'inviterAvatarAsset') String? inviterAvatarAsset,@JsonKey(name: 'memberId') String? memberId,@JsonKey(name: 'message') String? message,@JsonKey(name: 'role') FamilyRole role,@JsonKey(name: 'relation') RelativeRelation? relation,@JsonKey(name: 'callName') String? callName,@JsonKey(name: 'grantedChildIds') List<String> grantedChildIds,@JsonKey(name: 'canComment') bool canComment,@JsonKey(name: 'canPost') bool canPost,@JsonKey(name: 'link') String? link,@JsonKey(name: 'sentAt') DateTime? sentAt,@JsonKey(name: 'openedAt') DateTime? openedAt,@JsonKey(name: 'expiresAt') DateTime? expiresAt,@JsonKey(name: 'status') String status
});




}
/// @nodoc
class __$InviteInfoCopyWithImpl<$Res>
    implements _$InviteInfoCopyWith<$Res> {
  __$InviteInfoCopyWithImpl(this._self, this._then);

  final _InviteInfo _self;
  final $Res Function(_InviteInfo) _then;

/// Create a copy of InviteInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? kind = null,Object? familyId = null,Object? familyName = freezed,Object? inviterName = freezed,Object? inviterCallName = freezed,Object? inviterAvatarAsset = freezed,Object? memberId = freezed,Object? message = freezed,Object? role = null,Object? relation = freezed,Object? callName = freezed,Object? grantedChildIds = null,Object? canComment = null,Object? canPost = null,Object? link = freezed,Object? sentAt = freezed,Object? openedAt = freezed,Object? expiresAt = freezed,Object? status = null,}) {
  return _then(_InviteInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as InviteKind,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,familyName: freezed == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String?,inviterName: freezed == inviterName ? _self.inviterName : inviterName // ignore: cast_nullable_to_non_nullable
as String?,inviterCallName: freezed == inviterCallName ? _self.inviterCallName : inviterCallName // ignore: cast_nullable_to_non_nullable
as String?,inviterAvatarAsset: freezed == inviterAvatarAsset ? _self.inviterAvatarAsset : inviterAvatarAsset // ignore: cast_nullable_to_non_nullable
as String?,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FamilyRole,relation: freezed == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as RelativeRelation?,callName: freezed == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String?,grantedChildIds: null == grantedChildIds ? _self._grantedChildIds : grantedChildIds // ignore: cast_nullable_to_non_nullable
as List<String>,canComment: null == canComment ? _self.canComment : canComment // ignore: cast_nullable_to_non_nullable
as bool,canPost: null == canPost ? _self.canPost : canPost // ignore: cast_nullable_to_non_nullable
as bool,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,openedAt: freezed == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
