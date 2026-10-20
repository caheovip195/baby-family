// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'senderUserId') String? get senderUserId;@JsonKey(name: 'receiverUserId') String? get receiverUserId;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'needCode') String? get needCode;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'durationMin') int? get durationMin;@JsonKey(name: 'childIds') List<String> get childIds;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'dueKind') String? get dueKind;@JsonKey(name: 'dueAt') DateTime? get dueAt;@JsonKey(name: 'urgency') String? get urgency;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'volunteered') bool get volunteered;@JsonKey(name: 'declineReason') String? get declineReason;@JsonKey(name: 'reminderAt') DateTime? get reminderAt;@JsonKey(name: 'seenAt') DateTime? get seenAt;@JsonKey(name: 'respondedAt') DateTime? get respondedAt;@JsonKey(name: 'doneAt') DateTime? get doneAt;@JsonKey(name: 'createdAt') DateTime? get createdAt;
/// Create a copy of RequestRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestRecordCopyWith<RequestRecord> get copyWith => _$RequestRecordCopyWithImpl<RequestRecord>(this as RequestRecord, _$identity);

  /// Serializes this RequestRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.senderUserId, senderUserId) || other.senderUserId == senderUserId)&&(identical(other.receiverUserId, receiverUserId) || other.receiverUserId == receiverUserId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.needCode, needCode) || other.needCode == needCode)&&(identical(other.title, title) || other.title == title)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&const DeepCollectionEquality().equals(other.childIds, childIds)&&(identical(other.message, message) || other.message == message)&&(identical(other.dueKind, dueKind) || other.dueKind == dueKind)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.status, status) || other.status == status)&&(identical(other.volunteered, volunteered) || other.volunteered == volunteered)&&(identical(other.declineReason, declineReason) || other.declineReason == declineReason)&&(identical(other.reminderAt, reminderAt) || other.reminderAt == reminderAt)&&(identical(other.seenAt, seenAt) || other.seenAt == seenAt)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.doneAt, doneAt) || other.doneAt == doneAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,senderUserId,receiverUserId,kind,needCode,title,durationMin,const DeepCollectionEquality().hash(childIds),message,dueKind,dueAt,urgency,status,volunteered,declineReason,reminderAt,seenAt,respondedAt,doneAt,createdAt]);

@override
String toString() {
  return 'RequestRecord(id: $id, senderUserId: $senderUserId, receiverUserId: $receiverUserId, kind: $kind, needCode: $needCode, title: $title, durationMin: $durationMin, childIds: $childIds, message: $message, dueKind: $dueKind, dueAt: $dueAt, urgency: $urgency, status: $status, volunteered: $volunteered, declineReason: $declineReason, reminderAt: $reminderAt, seenAt: $seenAt, respondedAt: $respondedAt, doneAt: $doneAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RequestRecordCopyWith<$Res>  {
  factory $RequestRecordCopyWith(RequestRecord value, $Res Function(RequestRecord) _then) = _$RequestRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'senderUserId') String? senderUserId,@JsonKey(name: 'receiverUserId') String? receiverUserId,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'needCode') String? needCode,@JsonKey(name: 'title') String? title,@JsonKey(name: 'durationMin') int? durationMin,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'message') String? message,@JsonKey(name: 'dueKind') String? dueKind,@JsonKey(name: 'dueAt') DateTime? dueAt,@JsonKey(name: 'urgency') String? urgency,@JsonKey(name: 'status') String? status,@JsonKey(name: 'volunteered') bool volunteered,@JsonKey(name: 'declineReason') String? declineReason,@JsonKey(name: 'reminderAt') DateTime? reminderAt,@JsonKey(name: 'seenAt') DateTime? seenAt,@JsonKey(name: 'respondedAt') DateTime? respondedAt,@JsonKey(name: 'doneAt') DateTime? doneAt,@JsonKey(name: 'createdAt') DateTime? createdAt
});




}
/// @nodoc
class _$RequestRecordCopyWithImpl<$Res>
    implements $RequestRecordCopyWith<$Res> {
  _$RequestRecordCopyWithImpl(this._self, this._then);

  final RequestRecord _self;
  final $Res Function(RequestRecord) _then;

/// Create a copy of RequestRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? senderUserId = freezed,Object? receiverUserId = freezed,Object? kind = freezed,Object? needCode = freezed,Object? title = freezed,Object? durationMin = freezed,Object? childIds = null,Object? message = freezed,Object? dueKind = freezed,Object? dueAt = freezed,Object? urgency = freezed,Object? status = freezed,Object? volunteered = null,Object? declineReason = freezed,Object? reminderAt = freezed,Object? seenAt = freezed,Object? respondedAt = freezed,Object? doneAt = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,senderUserId: freezed == senderUserId ? _self.senderUserId : senderUserId // ignore: cast_nullable_to_non_nullable
as String?,receiverUserId: freezed == receiverUserId ? _self.receiverUserId : receiverUserId // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,needCode: freezed == needCode ? _self.needCode : needCode // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,durationMin: freezed == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int?,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,dueKind: freezed == dueKind ? _self.dueKind : dueKind // ignore: cast_nullable_to_non_nullable
as String?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,urgency: freezed == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,volunteered: null == volunteered ? _self.volunteered : volunteered // ignore: cast_nullable_to_non_nullable
as bool,declineReason: freezed == declineReason ? _self.declineReason : declineReason // ignore: cast_nullable_to_non_nullable
as String?,reminderAt: freezed == reminderAt ? _self.reminderAt : reminderAt // ignore: cast_nullable_to_non_nullable
as DateTime?,seenAt: freezed == seenAt ? _self.seenAt : seenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,doneAt: freezed == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestRecord].
extension RequestRecordPatterns on RequestRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestRecord value)  $default,){
final _that = this;
switch (_that) {
case _RequestRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestRecord value)?  $default,){
final _that = this;
switch (_that) {
case _RequestRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _RequestRecord implements RequestRecord {
  const _RequestRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'senderUserId') this.senderUserId, @JsonKey(name: 'receiverUserId') this.receiverUserId, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'needCode') this.needCode, @JsonKey(name: 'title') this.title, @JsonKey(name: 'durationMin') this.durationMin, @JsonKey(name: 'childIds') final  List<String> childIds = const <String>[], @JsonKey(name: 'message') this.message, @JsonKey(name: 'dueKind') this.dueKind, @JsonKey(name: 'dueAt') this.dueAt, @JsonKey(name: 'urgency') this.urgency, @JsonKey(name: 'status') this.status, @JsonKey(name: 'volunteered') this.volunteered = false, @JsonKey(name: 'declineReason') this.declineReason, @JsonKey(name: 'reminderAt') this.reminderAt, @JsonKey(name: 'seenAt') this.seenAt, @JsonKey(name: 'respondedAt') this.respondedAt, @JsonKey(name: 'doneAt') this.doneAt, @JsonKey(name: 'createdAt') this.createdAt}): _childIds = childIds;
  factory _RequestRecord.fromJson(Map<String, dynamic> json) => _$RequestRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'senderUserId') final  String? senderUserId;
@override@JsonKey(name: 'receiverUserId') final  String? receiverUserId;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'needCode') final  String? needCode;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'durationMin') final  int? durationMin;
 final  List<String> _childIds;
@override@JsonKey(name: 'childIds') List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}

@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'dueKind') final  String? dueKind;
@override@JsonKey(name: 'dueAt') final  DateTime? dueAt;
@override@JsonKey(name: 'urgency') final  String? urgency;
@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'volunteered') final  bool volunteered;
@override@JsonKey(name: 'declineReason') final  String? declineReason;
@override@JsonKey(name: 'reminderAt') final  DateTime? reminderAt;
@override@JsonKey(name: 'seenAt') final  DateTime? seenAt;
@override@JsonKey(name: 'respondedAt') final  DateTime? respondedAt;
@override@JsonKey(name: 'doneAt') final  DateTime? doneAt;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;

/// Create a copy of RequestRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestRecordCopyWith<_RequestRecord> get copyWith => __$RequestRecordCopyWithImpl<_RequestRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.senderUserId, senderUserId) || other.senderUserId == senderUserId)&&(identical(other.receiverUserId, receiverUserId) || other.receiverUserId == receiverUserId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.needCode, needCode) || other.needCode == needCode)&&(identical(other.title, title) || other.title == title)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&const DeepCollectionEquality().equals(other._childIds, _childIds)&&(identical(other.message, message) || other.message == message)&&(identical(other.dueKind, dueKind) || other.dueKind == dueKind)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.status, status) || other.status == status)&&(identical(other.volunteered, volunteered) || other.volunteered == volunteered)&&(identical(other.declineReason, declineReason) || other.declineReason == declineReason)&&(identical(other.reminderAt, reminderAt) || other.reminderAt == reminderAt)&&(identical(other.seenAt, seenAt) || other.seenAt == seenAt)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.doneAt, doneAt) || other.doneAt == doneAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,senderUserId,receiverUserId,kind,needCode,title,durationMin,const DeepCollectionEquality().hash(_childIds),message,dueKind,dueAt,urgency,status,volunteered,declineReason,reminderAt,seenAt,respondedAt,doneAt,createdAt]);

@override
String toString() {
  return 'RequestRecord(id: $id, senderUserId: $senderUserId, receiverUserId: $receiverUserId, kind: $kind, needCode: $needCode, title: $title, durationMin: $durationMin, childIds: $childIds, message: $message, dueKind: $dueKind, dueAt: $dueAt, urgency: $urgency, status: $status, volunteered: $volunteered, declineReason: $declineReason, reminderAt: $reminderAt, seenAt: $seenAt, respondedAt: $respondedAt, doneAt: $doneAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RequestRecordCopyWith<$Res> implements $RequestRecordCopyWith<$Res> {
  factory _$RequestRecordCopyWith(_RequestRecord value, $Res Function(_RequestRecord) _then) = __$RequestRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'senderUserId') String? senderUserId,@JsonKey(name: 'receiverUserId') String? receiverUserId,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'needCode') String? needCode,@JsonKey(name: 'title') String? title,@JsonKey(name: 'durationMin') int? durationMin,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'message') String? message,@JsonKey(name: 'dueKind') String? dueKind,@JsonKey(name: 'dueAt') DateTime? dueAt,@JsonKey(name: 'urgency') String? urgency,@JsonKey(name: 'status') String? status,@JsonKey(name: 'volunteered') bool volunteered,@JsonKey(name: 'declineReason') String? declineReason,@JsonKey(name: 'reminderAt') DateTime? reminderAt,@JsonKey(name: 'seenAt') DateTime? seenAt,@JsonKey(name: 'respondedAt') DateTime? respondedAt,@JsonKey(name: 'doneAt') DateTime? doneAt,@JsonKey(name: 'createdAt') DateTime? createdAt
});




}
/// @nodoc
class __$RequestRecordCopyWithImpl<$Res>
    implements _$RequestRecordCopyWith<$Res> {
  __$RequestRecordCopyWithImpl(this._self, this._then);

  final _RequestRecord _self;
  final $Res Function(_RequestRecord) _then;

/// Create a copy of RequestRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? senderUserId = freezed,Object? receiverUserId = freezed,Object? kind = freezed,Object? needCode = freezed,Object? title = freezed,Object? durationMin = freezed,Object? childIds = null,Object? message = freezed,Object? dueKind = freezed,Object? dueAt = freezed,Object? urgency = freezed,Object? status = freezed,Object? volunteered = null,Object? declineReason = freezed,Object? reminderAt = freezed,Object? seenAt = freezed,Object? respondedAt = freezed,Object? doneAt = freezed,Object? createdAt = freezed,}) {
  return _then(_RequestRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,senderUserId: freezed == senderUserId ? _self.senderUserId : senderUserId // ignore: cast_nullable_to_non_nullable
as String?,receiverUserId: freezed == receiverUserId ? _self.receiverUserId : receiverUserId // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,needCode: freezed == needCode ? _self.needCode : needCode // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,durationMin: freezed == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int?,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,dueKind: freezed == dueKind ? _self.dueKind : dueKind // ignore: cast_nullable_to_non_nullable
as String?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,urgency: freezed == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,volunteered: null == volunteered ? _self.volunteered : volunteered // ignore: cast_nullable_to_non_nullable
as bool,declineReason: freezed == declineReason ? _self.declineReason : declineReason // ignore: cast_nullable_to_non_nullable
as String?,reminderAt: freezed == reminderAt ? _self.reminderAt : reminderAt // ignore: cast_nullable_to_non_nullable
as DateTime?,seenAt: freezed == seenAt ? _self.seenAt : seenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,doneAt: freezed == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
