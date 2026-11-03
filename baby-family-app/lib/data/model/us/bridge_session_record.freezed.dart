// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bridge_session_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BridgeSessionRecord {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'initiatorUserId') String? get initiatorUserId;@JsonKey(name: 'startedAt') DateTime? get startedAt;@JsonKey(name: 'retentionDays') int get retentionDays;@JsonKey(name: 'contentPurged') bool get contentPurged;@JsonKey(name: 'shares', fromJson: _bridgeShares) List<BridgeShareRecord> get shares;@JsonKey(name: 'nextStep') BridgeNextStepRecord? get nextStep;@JsonKey(name: 'closeAgreedUserIds') List<String> get closeAgreedUserIds;
/// Create a copy of BridgeSessionRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BridgeSessionRecordCopyWith<BridgeSessionRecord> get copyWith => _$BridgeSessionRecordCopyWithImpl<BridgeSessionRecord>(this as BridgeSessionRecord, _$identity);

  /// Serializes this BridgeSessionRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BridgeSessionRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.initiatorUserId, initiatorUserId) || other.initiatorUserId == initiatorUserId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.retentionDays, retentionDays) || other.retentionDays == retentionDays)&&(identical(other.contentPurged, contentPurged) || other.contentPurged == contentPurged)&&const DeepCollectionEquality().equals(other.shares, shares)&&(identical(other.nextStep, nextStep) || other.nextStep == nextStep)&&const DeepCollectionEquality().equals(other.closeAgreedUserIds, closeAgreedUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,initiatorUserId,startedAt,retentionDays,contentPurged,const DeepCollectionEquality().hash(shares),nextStep,const DeepCollectionEquality().hash(closeAgreedUserIds));

@override
String toString() {
  return 'BridgeSessionRecord(id: $id, status: $status, initiatorUserId: $initiatorUserId, startedAt: $startedAt, retentionDays: $retentionDays, contentPurged: $contentPurged, shares: $shares, nextStep: $nextStep, closeAgreedUserIds: $closeAgreedUserIds)';
}


}

/// @nodoc
abstract mixin class $BridgeSessionRecordCopyWith<$Res>  {
  factory $BridgeSessionRecordCopyWith(BridgeSessionRecord value, $Res Function(BridgeSessionRecord) _then) = _$BridgeSessionRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'status') String? status,@JsonKey(name: 'initiatorUserId') String? initiatorUserId,@JsonKey(name: 'startedAt') DateTime? startedAt,@JsonKey(name: 'retentionDays') int retentionDays,@JsonKey(name: 'contentPurged') bool contentPurged,@JsonKey(name: 'shares', fromJson: _bridgeShares) List<BridgeShareRecord> shares,@JsonKey(name: 'nextStep') BridgeNextStepRecord? nextStep,@JsonKey(name: 'closeAgreedUserIds') List<String> closeAgreedUserIds
});


$BridgeNextStepRecordCopyWith<$Res>? get nextStep;

}
/// @nodoc
class _$BridgeSessionRecordCopyWithImpl<$Res>
    implements $BridgeSessionRecordCopyWith<$Res> {
  _$BridgeSessionRecordCopyWithImpl(this._self, this._then);

  final BridgeSessionRecord _self;
  final $Res Function(BridgeSessionRecord) _then;

/// Create a copy of BridgeSessionRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = freezed,Object? initiatorUserId = freezed,Object? startedAt = freezed,Object? retentionDays = null,Object? contentPurged = null,Object? shares = null,Object? nextStep = freezed,Object? closeAgreedUserIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,initiatorUserId: freezed == initiatorUserId ? _self.initiatorUserId : initiatorUserId // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,retentionDays: null == retentionDays ? _self.retentionDays : retentionDays // ignore: cast_nullable_to_non_nullable
as int,contentPurged: null == contentPurged ? _self.contentPurged : contentPurged // ignore: cast_nullable_to_non_nullable
as bool,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as List<BridgeShareRecord>,nextStep: freezed == nextStep ? _self.nextStep : nextStep // ignore: cast_nullable_to_non_nullable
as BridgeNextStepRecord?,closeAgreedUserIds: null == closeAgreedUserIds ? _self.closeAgreedUserIds : closeAgreedUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of BridgeSessionRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BridgeNextStepRecordCopyWith<$Res>? get nextStep {
    if (_self.nextStep == null) {
    return null;
  }

  return $BridgeNextStepRecordCopyWith<$Res>(_self.nextStep!, (value) {
    return _then(_self.copyWith(nextStep: value));
  });
}
}


/// Adds pattern-matching-related methods to [BridgeSessionRecord].
extension BridgeSessionRecordPatterns on BridgeSessionRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BridgeSessionRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BridgeSessionRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BridgeSessionRecord value)  $default,){
final _that = this;
switch (_that) {
case _BridgeSessionRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BridgeSessionRecord value)?  $default,){
final _that = this;
switch (_that) {
case _BridgeSessionRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BridgeSessionRecord implements BridgeSessionRecord {
  const _BridgeSessionRecord({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'status') this.status, @JsonKey(name: 'initiatorUserId') this.initiatorUserId, @JsonKey(name: 'startedAt') this.startedAt, @JsonKey(name: 'retentionDays') this.retentionDays = 30, @JsonKey(name: 'contentPurged') this.contentPurged = false, @JsonKey(name: 'shares', fromJson: _bridgeShares) final  List<BridgeShareRecord> shares = const <BridgeShareRecord>[], @JsonKey(name: 'nextStep') this.nextStep, @JsonKey(name: 'closeAgreedUserIds') final  List<String> closeAgreedUserIds = const <String>[]}): _shares = shares,_closeAgreedUserIds = closeAgreedUserIds;
  factory _BridgeSessionRecord.fromJson(Map<String, dynamic> json) => _$BridgeSessionRecordFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'initiatorUserId') final  String? initiatorUserId;
@override@JsonKey(name: 'startedAt') final  DateTime? startedAt;
@override@JsonKey(name: 'retentionDays') final  int retentionDays;
@override@JsonKey(name: 'contentPurged') final  bool contentPurged;
 final  List<BridgeShareRecord> _shares;
@override@JsonKey(name: 'shares', fromJson: _bridgeShares) List<BridgeShareRecord> get shares {
  if (_shares is EqualUnmodifiableListView) return _shares;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shares);
}

@override@JsonKey(name: 'nextStep') final  BridgeNextStepRecord? nextStep;
 final  List<String> _closeAgreedUserIds;
@override@JsonKey(name: 'closeAgreedUserIds') List<String> get closeAgreedUserIds {
  if (_closeAgreedUserIds is EqualUnmodifiableListView) return _closeAgreedUserIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_closeAgreedUserIds);
}


/// Create a copy of BridgeSessionRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BridgeSessionRecordCopyWith<_BridgeSessionRecord> get copyWith => __$BridgeSessionRecordCopyWithImpl<_BridgeSessionRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BridgeSessionRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BridgeSessionRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.initiatorUserId, initiatorUserId) || other.initiatorUserId == initiatorUserId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.retentionDays, retentionDays) || other.retentionDays == retentionDays)&&(identical(other.contentPurged, contentPurged) || other.contentPurged == contentPurged)&&const DeepCollectionEquality().equals(other._shares, _shares)&&(identical(other.nextStep, nextStep) || other.nextStep == nextStep)&&const DeepCollectionEquality().equals(other._closeAgreedUserIds, _closeAgreedUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,initiatorUserId,startedAt,retentionDays,contentPurged,const DeepCollectionEquality().hash(_shares),nextStep,const DeepCollectionEquality().hash(_closeAgreedUserIds));

@override
String toString() {
  return 'BridgeSessionRecord(id: $id, status: $status, initiatorUserId: $initiatorUserId, startedAt: $startedAt, retentionDays: $retentionDays, contentPurged: $contentPurged, shares: $shares, nextStep: $nextStep, closeAgreedUserIds: $closeAgreedUserIds)';
}


}

/// @nodoc
abstract mixin class _$BridgeSessionRecordCopyWith<$Res> implements $BridgeSessionRecordCopyWith<$Res> {
  factory _$BridgeSessionRecordCopyWith(_BridgeSessionRecord value, $Res Function(_BridgeSessionRecord) _then) = __$BridgeSessionRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'status') String? status,@JsonKey(name: 'initiatorUserId') String? initiatorUserId,@JsonKey(name: 'startedAt') DateTime? startedAt,@JsonKey(name: 'retentionDays') int retentionDays,@JsonKey(name: 'contentPurged') bool contentPurged,@JsonKey(name: 'shares', fromJson: _bridgeShares) List<BridgeShareRecord> shares,@JsonKey(name: 'nextStep') BridgeNextStepRecord? nextStep,@JsonKey(name: 'closeAgreedUserIds') List<String> closeAgreedUserIds
});


@override $BridgeNextStepRecordCopyWith<$Res>? get nextStep;

}
/// @nodoc
class __$BridgeSessionRecordCopyWithImpl<$Res>
    implements _$BridgeSessionRecordCopyWith<$Res> {
  __$BridgeSessionRecordCopyWithImpl(this._self, this._then);

  final _BridgeSessionRecord _self;
  final $Res Function(_BridgeSessionRecord) _then;

/// Create a copy of BridgeSessionRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = freezed,Object? initiatorUserId = freezed,Object? startedAt = freezed,Object? retentionDays = null,Object? contentPurged = null,Object? shares = null,Object? nextStep = freezed,Object? closeAgreedUserIds = null,}) {
  return _then(_BridgeSessionRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,initiatorUserId: freezed == initiatorUserId ? _self.initiatorUserId : initiatorUserId // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,retentionDays: null == retentionDays ? _self.retentionDays : retentionDays // ignore: cast_nullable_to_non_nullable
as int,contentPurged: null == contentPurged ? _self.contentPurged : contentPurged // ignore: cast_nullable_to_non_nullable
as bool,shares: null == shares ? _self._shares : shares // ignore: cast_nullable_to_non_nullable
as List<BridgeShareRecord>,nextStep: freezed == nextStep ? _self.nextStep : nextStep // ignore: cast_nullable_to_non_nullable
as BridgeNextStepRecord?,closeAgreedUserIds: null == closeAgreedUserIds ? _self._closeAgreedUserIds : closeAgreedUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of BridgeSessionRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BridgeNextStepRecordCopyWith<$Res>? get nextStep {
    if (_self.nextStep == null) {
    return null;
  }

  return $BridgeNextStepRecordCopyWith<$Res>(_self.nextStep!, (value) {
    return _then(_self.copyWith(nextStep: value));
  });
}
}


/// @nodoc
mixin _$BridgeShareRecord {

@JsonKey(name: 'userId') String get userId;@JsonKey(name: 'feelings') List<String> get feelings;@JsonKey(name: 'needs') List<String> get needs;@JsonKey(name: 'topic') String? get topic;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'understood') bool get understood;
/// Create a copy of BridgeShareRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BridgeShareRecordCopyWith<BridgeShareRecord> get copyWith => _$BridgeShareRecordCopyWithImpl<BridgeShareRecord>(this as BridgeShareRecord, _$identity);

  /// Serializes this BridgeShareRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BridgeShareRecord&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.feelings, feelings)&&const DeepCollectionEquality().equals(other.needs, needs)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.message, message) || other.message == message)&&(identical(other.understood, understood) || other.understood == understood));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,const DeepCollectionEquality().hash(feelings),const DeepCollectionEquality().hash(needs),topic,message,understood);

@override
String toString() {
  return 'BridgeShareRecord(userId: $userId, feelings: $feelings, needs: $needs, topic: $topic, message: $message, understood: $understood)';
}


}

/// @nodoc
abstract mixin class $BridgeShareRecordCopyWith<$Res>  {
  factory $BridgeShareRecordCopyWith(BridgeShareRecord value, $Res Function(BridgeShareRecord) _then) = _$BridgeShareRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'userId') String userId,@JsonKey(name: 'feelings') List<String> feelings,@JsonKey(name: 'needs') List<String> needs,@JsonKey(name: 'topic') String? topic,@JsonKey(name: 'message') String? message,@JsonKey(name: 'understood') bool understood
});




}
/// @nodoc
class _$BridgeShareRecordCopyWithImpl<$Res>
    implements $BridgeShareRecordCopyWith<$Res> {
  _$BridgeShareRecordCopyWithImpl(this._self, this._then);

  final BridgeShareRecord _self;
  final $Res Function(BridgeShareRecord) _then;

/// Create a copy of BridgeShareRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? feelings = null,Object? needs = null,Object? topic = freezed,Object? message = freezed,Object? understood = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,feelings: null == feelings ? _self.feelings : feelings // ignore: cast_nullable_to_non_nullable
as List<String>,needs: null == needs ? _self.needs : needs // ignore: cast_nullable_to_non_nullable
as List<String>,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,understood: null == understood ? _self.understood : understood // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BridgeShareRecord].
extension BridgeShareRecordPatterns on BridgeShareRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BridgeShareRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BridgeShareRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BridgeShareRecord value)  $default,){
final _that = this;
switch (_that) {
case _BridgeShareRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BridgeShareRecord value)?  $default,){
final _that = this;
switch (_that) {
case _BridgeShareRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BridgeShareRecord implements BridgeShareRecord {
  const _BridgeShareRecord({@JsonKey(name: 'userId') required this.userId, @JsonKey(name: 'feelings') final  List<String> feelings = const <String>[], @JsonKey(name: 'needs') final  List<String> needs = const <String>[], @JsonKey(name: 'topic') this.topic, @JsonKey(name: 'message') this.message, @JsonKey(name: 'understood') this.understood = false}): _feelings = feelings,_needs = needs;
  factory _BridgeShareRecord.fromJson(Map<String, dynamic> json) => _$BridgeShareRecordFromJson(json);

@override@JsonKey(name: 'userId') final  String userId;
 final  List<String> _feelings;
@override@JsonKey(name: 'feelings') List<String> get feelings {
  if (_feelings is EqualUnmodifiableListView) return _feelings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feelings);
}

 final  List<String> _needs;
@override@JsonKey(name: 'needs') List<String> get needs {
  if (_needs is EqualUnmodifiableListView) return _needs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_needs);
}

@override@JsonKey(name: 'topic') final  String? topic;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'understood') final  bool understood;

/// Create a copy of BridgeShareRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BridgeShareRecordCopyWith<_BridgeShareRecord> get copyWith => __$BridgeShareRecordCopyWithImpl<_BridgeShareRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BridgeShareRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BridgeShareRecord&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._feelings, _feelings)&&const DeepCollectionEquality().equals(other._needs, _needs)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.message, message) || other.message == message)&&(identical(other.understood, understood) || other.understood == understood));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,const DeepCollectionEquality().hash(_feelings),const DeepCollectionEquality().hash(_needs),topic,message,understood);

@override
String toString() {
  return 'BridgeShareRecord(userId: $userId, feelings: $feelings, needs: $needs, topic: $topic, message: $message, understood: $understood)';
}


}

/// @nodoc
abstract mixin class _$BridgeShareRecordCopyWith<$Res> implements $BridgeShareRecordCopyWith<$Res> {
  factory _$BridgeShareRecordCopyWith(_BridgeShareRecord value, $Res Function(_BridgeShareRecord) _then) = __$BridgeShareRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'userId') String userId,@JsonKey(name: 'feelings') List<String> feelings,@JsonKey(name: 'needs') List<String> needs,@JsonKey(name: 'topic') String? topic,@JsonKey(name: 'message') String? message,@JsonKey(name: 'understood') bool understood
});




}
/// @nodoc
class __$BridgeShareRecordCopyWithImpl<$Res>
    implements _$BridgeShareRecordCopyWith<$Res> {
  __$BridgeShareRecordCopyWithImpl(this._self, this._then);

  final _BridgeShareRecord _self;
  final $Res Function(_BridgeShareRecord) _then;

/// Create a copy of BridgeShareRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? feelings = null,Object? needs = null,Object? topic = freezed,Object? message = freezed,Object? understood = null,}) {
  return _then(_BridgeShareRecord(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,feelings: null == feelings ? _self._feelings : feelings // ignore: cast_nullable_to_non_nullable
as List<String>,needs: null == needs ? _self._needs : needs // ignore: cast_nullable_to_non_nullable
as List<String>,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,understood: null == understood ? _self.understood : understood // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$BridgeNextStepRecord {

@JsonKey(name: 'code') String get code;@JsonKey(name: 'text') String? get text;@JsonKey(name: 'at') DateTime? get at;@JsonKey(name: 'agreedUserIds') List<String> get agreedUserIds;
/// Create a copy of BridgeNextStepRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BridgeNextStepRecordCopyWith<BridgeNextStepRecord> get copyWith => _$BridgeNextStepRecordCopyWithImpl<BridgeNextStepRecord>(this as BridgeNextStepRecord, _$identity);

  /// Serializes this BridgeNextStepRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BridgeNextStepRecord&&(identical(other.code, code) || other.code == code)&&(identical(other.text, text) || other.text == text)&&(identical(other.at, at) || other.at == at)&&const DeepCollectionEquality().equals(other.agreedUserIds, agreedUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,text,at,const DeepCollectionEquality().hash(agreedUserIds));

@override
String toString() {
  return 'BridgeNextStepRecord(code: $code, text: $text, at: $at, agreedUserIds: $agreedUserIds)';
}


}

/// @nodoc
abstract mixin class $BridgeNextStepRecordCopyWith<$Res>  {
  factory $BridgeNextStepRecordCopyWith(BridgeNextStepRecord value, $Res Function(BridgeNextStepRecord) _then) = _$BridgeNextStepRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'text') String? text,@JsonKey(name: 'at') DateTime? at,@JsonKey(name: 'agreedUserIds') List<String> agreedUserIds
});




}
/// @nodoc
class _$BridgeNextStepRecordCopyWithImpl<$Res>
    implements $BridgeNextStepRecordCopyWith<$Res> {
  _$BridgeNextStepRecordCopyWithImpl(this._self, this._then);

  final BridgeNextStepRecord _self;
  final $Res Function(BridgeNextStepRecord) _then;

/// Create a copy of BridgeNextStepRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? text = freezed,Object? at = freezed,Object? agreedUserIds = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,agreedUserIds: null == agreedUserIds ? _self.agreedUserIds : agreedUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [BridgeNextStepRecord].
extension BridgeNextStepRecordPatterns on BridgeNextStepRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BridgeNextStepRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BridgeNextStepRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BridgeNextStepRecord value)  $default,){
final _that = this;
switch (_that) {
case _BridgeNextStepRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BridgeNextStepRecord value)?  $default,){
final _that = this;
switch (_that) {
case _BridgeNextStepRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BridgeNextStepRecord implements BridgeNextStepRecord {
  const _BridgeNextStepRecord({@JsonKey(name: 'code') required this.code, @JsonKey(name: 'text') this.text, @JsonKey(name: 'at') this.at, @JsonKey(name: 'agreedUserIds') final  List<String> agreedUserIds = const <String>[]}): _agreedUserIds = agreedUserIds;
  factory _BridgeNextStepRecord.fromJson(Map<String, dynamic> json) => _$BridgeNextStepRecordFromJson(json);

@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'text') final  String? text;
@override@JsonKey(name: 'at') final  DateTime? at;
 final  List<String> _agreedUserIds;
@override@JsonKey(name: 'agreedUserIds') List<String> get agreedUserIds {
  if (_agreedUserIds is EqualUnmodifiableListView) return _agreedUserIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_agreedUserIds);
}


/// Create a copy of BridgeNextStepRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BridgeNextStepRecordCopyWith<_BridgeNextStepRecord> get copyWith => __$BridgeNextStepRecordCopyWithImpl<_BridgeNextStepRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BridgeNextStepRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BridgeNextStepRecord&&(identical(other.code, code) || other.code == code)&&(identical(other.text, text) || other.text == text)&&(identical(other.at, at) || other.at == at)&&const DeepCollectionEquality().equals(other._agreedUserIds, _agreedUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,text,at,const DeepCollectionEquality().hash(_agreedUserIds));

@override
String toString() {
  return 'BridgeNextStepRecord(code: $code, text: $text, at: $at, agreedUserIds: $agreedUserIds)';
}


}

/// @nodoc
abstract mixin class _$BridgeNextStepRecordCopyWith<$Res> implements $BridgeNextStepRecordCopyWith<$Res> {
  factory _$BridgeNextStepRecordCopyWith(_BridgeNextStepRecord value, $Res Function(_BridgeNextStepRecord) _then) = __$BridgeNextStepRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'text') String? text,@JsonKey(name: 'at') DateTime? at,@JsonKey(name: 'agreedUserIds') List<String> agreedUserIds
});




}
/// @nodoc
class __$BridgeNextStepRecordCopyWithImpl<$Res>
    implements _$BridgeNextStepRecordCopyWith<$Res> {
  __$BridgeNextStepRecordCopyWithImpl(this._self, this._then);

  final _BridgeNextStepRecord _self;
  final $Res Function(_BridgeNextStepRecord) _then;

/// Create a copy of BridgeNextStepRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? text = freezed,Object? at = freezed,Object? agreedUserIds = null,}) {
  return _then(_BridgeNextStepRecord(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,agreedUserIds: null == agreedUserIds ? _self._agreedUserIds : agreedUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
