// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appreciation_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppreciationRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'fromUserId') String? get fromUserId;@JsonKey(name: 'toUserId') String? get toUserId;@JsonKey(name: 'body') String? get body;@JsonKey(name: 'sticker') String? get sticker;@JsonKey(name: 'linkedType') String? get linkedType;@JsonKey(name: 'linkedId') String? get linkedId;@JsonKey(name: 'familyShareStatus') String? get familyShareStatus;@JsonKey(name: 'reaction') String? get reaction;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'isMine') bool get isMine;
/// Create a copy of AppreciationRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppreciationRecordCopyWith<AppreciationRecord> get copyWith => _$AppreciationRecordCopyWithImpl<AppreciationRecord>(this as AppreciationRecord, _$identity);

  /// Serializes this AppreciationRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppreciationRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.body, body) || other.body == body)&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.linkedType, linkedType) || other.linkedType == linkedType)&&(identical(other.linkedId, linkedId) || other.linkedId == linkedId)&&(identical(other.familyShareStatus, familyShareStatus) || other.familyShareStatus == familyShareStatus)&&(identical(other.reaction, reaction) || other.reaction == reaction)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isMine, isMine) || other.isMine == isMine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromUserId,toUserId,body,sticker,linkedType,linkedId,familyShareStatus,reaction,createdAt,isMine);

@override
String toString() {
  return 'AppreciationRecord(id: $id, fromUserId: $fromUserId, toUserId: $toUserId, body: $body, sticker: $sticker, linkedType: $linkedType, linkedId: $linkedId, familyShareStatus: $familyShareStatus, reaction: $reaction, createdAt: $createdAt, isMine: $isMine)';
}


}

/// @nodoc
abstract mixin class $AppreciationRecordCopyWith<$Res>  {
  factory $AppreciationRecordCopyWith(AppreciationRecord value, $Res Function(AppreciationRecord) _then) = _$AppreciationRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'fromUserId') String? fromUserId,@JsonKey(name: 'toUserId') String? toUserId,@JsonKey(name: 'body') String? body,@JsonKey(name: 'sticker') String? sticker,@JsonKey(name: 'linkedType') String? linkedType,@JsonKey(name: 'linkedId') String? linkedId,@JsonKey(name: 'familyShareStatus') String? familyShareStatus,@JsonKey(name: 'reaction') String? reaction,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'isMine') bool isMine
});




}
/// @nodoc
class _$AppreciationRecordCopyWithImpl<$Res>
    implements $AppreciationRecordCopyWith<$Res> {
  _$AppreciationRecordCopyWithImpl(this._self, this._then);

  final AppreciationRecord _self;
  final $Res Function(AppreciationRecord) _then;

/// Create a copy of AppreciationRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? fromUserId = freezed,Object? toUserId = freezed,Object? body = freezed,Object? sticker = freezed,Object? linkedType = freezed,Object? linkedId = freezed,Object? familyShareStatus = freezed,Object? reaction = freezed,Object? createdAt = freezed,Object? isMine = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,fromUserId: freezed == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String?,toUserId: freezed == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,sticker: freezed == sticker ? _self.sticker : sticker // ignore: cast_nullable_to_non_nullable
as String?,linkedType: freezed == linkedType ? _self.linkedType : linkedType // ignore: cast_nullable_to_non_nullable
as String?,linkedId: freezed == linkedId ? _self.linkedId : linkedId // ignore: cast_nullable_to_non_nullable
as String?,familyShareStatus: freezed == familyShareStatus ? _self.familyShareStatus : familyShareStatus // ignore: cast_nullable_to_non_nullable
as String?,reaction: freezed == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppreciationRecord].
extension AppreciationRecordPatterns on AppreciationRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppreciationRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppreciationRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppreciationRecord value)  $default,){
final _that = this;
switch (_that) {
case _AppreciationRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppreciationRecord value)?  $default,){
final _that = this;
switch (_that) {
case _AppreciationRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AppreciationRecord implements AppreciationRecord {
  const _AppreciationRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'fromUserId') this.fromUserId, @JsonKey(name: 'toUserId') this.toUserId, @JsonKey(name: 'body') this.body, @JsonKey(name: 'sticker') this.sticker, @JsonKey(name: 'linkedType') this.linkedType, @JsonKey(name: 'linkedId') this.linkedId, @JsonKey(name: 'familyShareStatus') this.familyShareStatus, @JsonKey(name: 'reaction') this.reaction, @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'isMine') this.isMine = false});
  factory _AppreciationRecord.fromJson(Map<String, dynamic> json) => _$AppreciationRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'fromUserId') final  String? fromUserId;
@override@JsonKey(name: 'toUserId') final  String? toUserId;
@override@JsonKey(name: 'body') final  String? body;
@override@JsonKey(name: 'sticker') final  String? sticker;
@override@JsonKey(name: 'linkedType') final  String? linkedType;
@override@JsonKey(name: 'linkedId') final  String? linkedId;
@override@JsonKey(name: 'familyShareStatus') final  String? familyShareStatus;
@override@JsonKey(name: 'reaction') final  String? reaction;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
@override@JsonKey(name: 'isMine') final  bool isMine;

/// Create a copy of AppreciationRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppreciationRecordCopyWith<_AppreciationRecord> get copyWith => __$AppreciationRecordCopyWithImpl<_AppreciationRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppreciationRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppreciationRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.body, body) || other.body == body)&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.linkedType, linkedType) || other.linkedType == linkedType)&&(identical(other.linkedId, linkedId) || other.linkedId == linkedId)&&(identical(other.familyShareStatus, familyShareStatus) || other.familyShareStatus == familyShareStatus)&&(identical(other.reaction, reaction) || other.reaction == reaction)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isMine, isMine) || other.isMine == isMine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromUserId,toUserId,body,sticker,linkedType,linkedId,familyShareStatus,reaction,createdAt,isMine);

@override
String toString() {
  return 'AppreciationRecord(id: $id, fromUserId: $fromUserId, toUserId: $toUserId, body: $body, sticker: $sticker, linkedType: $linkedType, linkedId: $linkedId, familyShareStatus: $familyShareStatus, reaction: $reaction, createdAt: $createdAt, isMine: $isMine)';
}


}

/// @nodoc
abstract mixin class _$AppreciationRecordCopyWith<$Res> implements $AppreciationRecordCopyWith<$Res> {
  factory _$AppreciationRecordCopyWith(_AppreciationRecord value, $Res Function(_AppreciationRecord) _then) = __$AppreciationRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'fromUserId') String? fromUserId,@JsonKey(name: 'toUserId') String? toUserId,@JsonKey(name: 'body') String? body,@JsonKey(name: 'sticker') String? sticker,@JsonKey(name: 'linkedType') String? linkedType,@JsonKey(name: 'linkedId') String? linkedId,@JsonKey(name: 'familyShareStatus') String? familyShareStatus,@JsonKey(name: 'reaction') String? reaction,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'isMine') bool isMine
});




}
/// @nodoc
class __$AppreciationRecordCopyWithImpl<$Res>
    implements _$AppreciationRecordCopyWith<$Res> {
  __$AppreciationRecordCopyWithImpl(this._self, this._then);

  final _AppreciationRecord _self;
  final $Res Function(_AppreciationRecord) _then;

/// Create a copy of AppreciationRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? fromUserId = freezed,Object? toUserId = freezed,Object? body = freezed,Object? sticker = freezed,Object? linkedType = freezed,Object? linkedId = freezed,Object? familyShareStatus = freezed,Object? reaction = freezed,Object? createdAt = freezed,Object? isMine = null,}) {
  return _then(_AppreciationRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,fromUserId: freezed == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String?,toUserId: freezed == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,sticker: freezed == sticker ? _self.sticker : sticker // ignore: cast_nullable_to_non_nullable
as String?,linkedType: freezed == linkedType ? _self.linkedType : linkedType // ignore: cast_nullable_to_non_nullable
as String?,linkedId: freezed == linkedId ? _self.linkedId : linkedId // ignore: cast_nullable_to_non_nullable
as String?,familyShareStatus: freezed == familyShareStatus ? _self.familyShareStatus : familyShareStatus // ignore: cast_nullable_to_non_nullable
as String?,reaction: freezed == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
