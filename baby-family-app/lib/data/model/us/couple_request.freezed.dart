// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'couple_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoupleRequest {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'kind') RequestKind get kind;@JsonKey(name: 'templateCode') String? get templateCode;@JsonKey(name: 'needCode') CoupleNeed? get needCode;@JsonKey(name: 'title') String get title;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'childIds') List<String> get childIds;@JsonKey(name: 'dueLabel') String? get dueLabel;@JsonKey(name: 'dueAt') DateTime? get dueAt;@JsonKey(name: 'durationMin') int? get durationMin;@JsonKey(name: 'urgency') RequestUrgency get urgency;@JsonKey(name: 'status') RequestStatus get status;@JsonKey(name: 'senderId') String get senderId;@JsonKey(name: 'receiverId') String get receiverId;@JsonKey(name: 'volunteered') bool get volunteered;@JsonKey(name: 'declineReason') String? get declineReason;@JsonKey(name: 'sentAt') DateTime get sentAt;@JsonKey(name: 'seenAt') DateTime? get seenAt;@JsonKey(name: 'acceptedAt') DateTime? get acceptedAt;@JsonKey(name: 'doneAt') DateTime? get doneAt;@JsonKey(name: 'declinedAt') DateTime? get declinedAt;@JsonKey(name: 'remindAt') DateTime? get remindAt;
/// Create a copy of CoupleRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoupleRequestCopyWith<CoupleRequest> get copyWith => _$CoupleRequestCopyWithImpl<CoupleRequest>(this as CoupleRequest, _$identity);

  /// Serializes this CoupleRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoupleRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.templateCode, templateCode) || other.templateCode == templateCode)&&(identical(other.needCode, needCode) || other.needCode == needCode)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.childIds, childIds)&&(identical(other.dueLabel, dueLabel) || other.dueLabel == dueLabel)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.status, status) || other.status == status)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.receiverId, receiverId) || other.receiverId == receiverId)&&(identical(other.volunteered, volunteered) || other.volunteered == volunteered)&&(identical(other.declineReason, declineReason) || other.declineReason == declineReason)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.seenAt, seenAt) || other.seenAt == seenAt)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.doneAt, doneAt) || other.doneAt == doneAt)&&(identical(other.declinedAt, declinedAt) || other.declinedAt == declinedAt)&&(identical(other.remindAt, remindAt) || other.remindAt == remindAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,kind,templateCode,needCode,title,message,const DeepCollectionEquality().hash(childIds),dueLabel,dueAt,durationMin,urgency,status,senderId,receiverId,volunteered,declineReason,sentAt,seenAt,acceptedAt,doneAt,declinedAt,remindAt]);

@override
String toString() {
  return 'CoupleRequest(id: $id, kind: $kind, templateCode: $templateCode, needCode: $needCode, title: $title, message: $message, childIds: $childIds, dueLabel: $dueLabel, dueAt: $dueAt, durationMin: $durationMin, urgency: $urgency, status: $status, senderId: $senderId, receiverId: $receiverId, volunteered: $volunteered, declineReason: $declineReason, sentAt: $sentAt, seenAt: $seenAt, acceptedAt: $acceptedAt, doneAt: $doneAt, declinedAt: $declinedAt, remindAt: $remindAt)';
}


}

/// @nodoc
abstract mixin class $CoupleRequestCopyWith<$Res>  {
  factory $CoupleRequestCopyWith(CoupleRequest value, $Res Function(CoupleRequest) _then) = _$CoupleRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'kind') RequestKind kind,@JsonKey(name: 'templateCode') String? templateCode,@JsonKey(name: 'needCode') CoupleNeed? needCode,@JsonKey(name: 'title') String title,@JsonKey(name: 'message') String? message,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'dueLabel') String? dueLabel,@JsonKey(name: 'dueAt') DateTime? dueAt,@JsonKey(name: 'durationMin') int? durationMin,@JsonKey(name: 'urgency') RequestUrgency urgency,@JsonKey(name: 'status') RequestStatus status,@JsonKey(name: 'senderId') String senderId,@JsonKey(name: 'receiverId') String receiverId,@JsonKey(name: 'volunteered') bool volunteered,@JsonKey(name: 'declineReason') String? declineReason,@JsonKey(name: 'sentAt') DateTime sentAt,@JsonKey(name: 'seenAt') DateTime? seenAt,@JsonKey(name: 'acceptedAt') DateTime? acceptedAt,@JsonKey(name: 'doneAt') DateTime? doneAt,@JsonKey(name: 'declinedAt') DateTime? declinedAt,@JsonKey(name: 'remindAt') DateTime? remindAt
});




}
/// @nodoc
class _$CoupleRequestCopyWithImpl<$Res>
    implements $CoupleRequestCopyWith<$Res> {
  _$CoupleRequestCopyWithImpl(this._self, this._then);

  final CoupleRequest _self;
  final $Res Function(CoupleRequest) _then;

/// Create a copy of CoupleRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? templateCode = freezed,Object? needCode = freezed,Object? title = null,Object? message = freezed,Object? childIds = null,Object? dueLabel = freezed,Object? dueAt = freezed,Object? durationMin = freezed,Object? urgency = null,Object? status = null,Object? senderId = null,Object? receiverId = null,Object? volunteered = null,Object? declineReason = freezed,Object? sentAt = null,Object? seenAt = freezed,Object? acceptedAt = freezed,Object? doneAt = freezed,Object? declinedAt = freezed,Object? remindAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RequestKind,templateCode: freezed == templateCode ? _self.templateCode : templateCode // ignore: cast_nullable_to_non_nullable
as String?,needCode: freezed == needCode ? _self.needCode : needCode // ignore: cast_nullable_to_non_nullable
as CoupleNeed?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,dueLabel: freezed == dueLabel ? _self.dueLabel : dueLabel // ignore: cast_nullable_to_non_nullable
as String?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMin: freezed == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int?,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as RequestUrgency,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,receiverId: null == receiverId ? _self.receiverId : receiverId // ignore: cast_nullable_to_non_nullable
as String,volunteered: null == volunteered ? _self.volunteered : volunteered // ignore: cast_nullable_to_non_nullable
as bool,declineReason: freezed == declineReason ? _self.declineReason : declineReason // ignore: cast_nullable_to_non_nullable
as String?,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,seenAt: freezed == seenAt ? _self.seenAt : seenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,doneAt: freezed == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,declinedAt: freezed == declinedAt ? _self.declinedAt : declinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,remindAt: freezed == remindAt ? _self.remindAt : remindAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoupleRequest].
extension CoupleRequestPatterns on CoupleRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoupleRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoupleRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoupleRequest value)  $default,){
final _that = this;
switch (_that) {
case _CoupleRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoupleRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CoupleRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CoupleRequest implements CoupleRequest {
  const _CoupleRequest({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'kind') this.kind = RequestKind.task, @JsonKey(name: 'templateCode') this.templateCode, @JsonKey(name: 'needCode') this.needCode, @JsonKey(name: 'title') this.title = '', @JsonKey(name: 'message') this.message, @JsonKey(name: 'childIds') final  List<String> childIds = const [], @JsonKey(name: 'dueLabel') this.dueLabel, @JsonKey(name: 'dueAt') this.dueAt, @JsonKey(name: 'durationMin') this.durationMin, @JsonKey(name: 'urgency') this.urgency = RequestUrgency.normal, @JsonKey(name: 'status') this.status = RequestStatus.sent, @JsonKey(name: 'senderId') required this.senderId, @JsonKey(name: 'receiverId') required this.receiverId, @JsonKey(name: 'volunteered') this.volunteered = false, @JsonKey(name: 'declineReason') this.declineReason, @JsonKey(name: 'sentAt') required this.sentAt, @JsonKey(name: 'seenAt') this.seenAt, @JsonKey(name: 'acceptedAt') this.acceptedAt, @JsonKey(name: 'doneAt') this.doneAt, @JsonKey(name: 'declinedAt') this.declinedAt, @JsonKey(name: 'remindAt') this.remindAt}): _childIds = childIds;
  factory _CoupleRequest.fromJson(Map<String, dynamic> json) => _$CoupleRequestFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'kind') final  RequestKind kind;
@override@JsonKey(name: 'templateCode') final  String? templateCode;
@override@JsonKey(name: 'needCode') final  CoupleNeed? needCode;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'message') final  String? message;
 final  List<String> _childIds;
@override@JsonKey(name: 'childIds') List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}

@override@JsonKey(name: 'dueLabel') final  String? dueLabel;
@override@JsonKey(name: 'dueAt') final  DateTime? dueAt;
@override@JsonKey(name: 'durationMin') final  int? durationMin;
@override@JsonKey(name: 'urgency') final  RequestUrgency urgency;
@override@JsonKey(name: 'status') final  RequestStatus status;
@override@JsonKey(name: 'senderId') final  String senderId;
@override@JsonKey(name: 'receiverId') final  String receiverId;
@override@JsonKey(name: 'volunteered') final  bool volunteered;
@override@JsonKey(name: 'declineReason') final  String? declineReason;
@override@JsonKey(name: 'sentAt') final  DateTime sentAt;
@override@JsonKey(name: 'seenAt') final  DateTime? seenAt;
@override@JsonKey(name: 'acceptedAt') final  DateTime? acceptedAt;
@override@JsonKey(name: 'doneAt') final  DateTime? doneAt;
@override@JsonKey(name: 'declinedAt') final  DateTime? declinedAt;
@override@JsonKey(name: 'remindAt') final  DateTime? remindAt;

/// Create a copy of CoupleRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoupleRequestCopyWith<_CoupleRequest> get copyWith => __$CoupleRequestCopyWithImpl<_CoupleRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoupleRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoupleRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.templateCode, templateCode) || other.templateCode == templateCode)&&(identical(other.needCode, needCode) || other.needCode == needCode)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._childIds, _childIds)&&(identical(other.dueLabel, dueLabel) || other.dueLabel == dueLabel)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.status, status) || other.status == status)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.receiverId, receiverId) || other.receiverId == receiverId)&&(identical(other.volunteered, volunteered) || other.volunteered == volunteered)&&(identical(other.declineReason, declineReason) || other.declineReason == declineReason)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.seenAt, seenAt) || other.seenAt == seenAt)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.doneAt, doneAt) || other.doneAt == doneAt)&&(identical(other.declinedAt, declinedAt) || other.declinedAt == declinedAt)&&(identical(other.remindAt, remindAt) || other.remindAt == remindAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,kind,templateCode,needCode,title,message,const DeepCollectionEquality().hash(_childIds),dueLabel,dueAt,durationMin,urgency,status,senderId,receiverId,volunteered,declineReason,sentAt,seenAt,acceptedAt,doneAt,declinedAt,remindAt]);

@override
String toString() {
  return 'CoupleRequest(id: $id, kind: $kind, templateCode: $templateCode, needCode: $needCode, title: $title, message: $message, childIds: $childIds, dueLabel: $dueLabel, dueAt: $dueAt, durationMin: $durationMin, urgency: $urgency, status: $status, senderId: $senderId, receiverId: $receiverId, volunteered: $volunteered, declineReason: $declineReason, sentAt: $sentAt, seenAt: $seenAt, acceptedAt: $acceptedAt, doneAt: $doneAt, declinedAt: $declinedAt, remindAt: $remindAt)';
}


}

/// @nodoc
abstract mixin class _$CoupleRequestCopyWith<$Res> implements $CoupleRequestCopyWith<$Res> {
  factory _$CoupleRequestCopyWith(_CoupleRequest value, $Res Function(_CoupleRequest) _then) = __$CoupleRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'kind') RequestKind kind,@JsonKey(name: 'templateCode') String? templateCode,@JsonKey(name: 'needCode') CoupleNeed? needCode,@JsonKey(name: 'title') String title,@JsonKey(name: 'message') String? message,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'dueLabel') String? dueLabel,@JsonKey(name: 'dueAt') DateTime? dueAt,@JsonKey(name: 'durationMin') int? durationMin,@JsonKey(name: 'urgency') RequestUrgency urgency,@JsonKey(name: 'status') RequestStatus status,@JsonKey(name: 'senderId') String senderId,@JsonKey(name: 'receiverId') String receiverId,@JsonKey(name: 'volunteered') bool volunteered,@JsonKey(name: 'declineReason') String? declineReason,@JsonKey(name: 'sentAt') DateTime sentAt,@JsonKey(name: 'seenAt') DateTime? seenAt,@JsonKey(name: 'acceptedAt') DateTime? acceptedAt,@JsonKey(name: 'doneAt') DateTime? doneAt,@JsonKey(name: 'declinedAt') DateTime? declinedAt,@JsonKey(name: 'remindAt') DateTime? remindAt
});




}
/// @nodoc
class __$CoupleRequestCopyWithImpl<$Res>
    implements _$CoupleRequestCopyWith<$Res> {
  __$CoupleRequestCopyWithImpl(this._self, this._then);

  final _CoupleRequest _self;
  final $Res Function(_CoupleRequest) _then;

/// Create a copy of CoupleRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? templateCode = freezed,Object? needCode = freezed,Object? title = null,Object? message = freezed,Object? childIds = null,Object? dueLabel = freezed,Object? dueAt = freezed,Object? durationMin = freezed,Object? urgency = null,Object? status = null,Object? senderId = null,Object? receiverId = null,Object? volunteered = null,Object? declineReason = freezed,Object? sentAt = null,Object? seenAt = freezed,Object? acceptedAt = freezed,Object? doneAt = freezed,Object? declinedAt = freezed,Object? remindAt = freezed,}) {
  return _then(_CoupleRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RequestKind,templateCode: freezed == templateCode ? _self.templateCode : templateCode // ignore: cast_nullable_to_non_nullable
as String?,needCode: freezed == needCode ? _self.needCode : needCode // ignore: cast_nullable_to_non_nullable
as CoupleNeed?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,dueLabel: freezed == dueLabel ? _self.dueLabel : dueLabel // ignore: cast_nullable_to_non_nullable
as String?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMin: freezed == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int?,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as RequestUrgency,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,receiverId: null == receiverId ? _self.receiverId : receiverId // ignore: cast_nullable_to_non_nullable
as String,volunteered: null == volunteered ? _self.volunteered : volunteered // ignore: cast_nullable_to_non_nullable
as bool,declineReason: freezed == declineReason ? _self.declineReason : declineReason // ignore: cast_nullable_to_non_nullable
as String?,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,seenAt: freezed == seenAt ? _self.seenAt : seenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,doneAt: freezed == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,declinedAt: freezed == declinedAt ? _self.declinedAt : declinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,remindAt: freezed == remindAt ? _self.remindAt : remindAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
