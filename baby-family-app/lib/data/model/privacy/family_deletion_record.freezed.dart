// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_deletion_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyDeletionRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'requestedBy') String? get requestedBy;@JsonKey(name: 'scheduledFor') DateTime? get scheduledFor;@JsonKey(name: 'graceDays') int? get graceDays;
/// Create a copy of FamilyDeletionRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyDeletionRecordCopyWith<FamilyDeletionRecord> get copyWith => _$FamilyDeletionRecordCopyWithImpl<FamilyDeletionRecord>(this as FamilyDeletionRecord, _$identity);

  /// Serializes this FamilyDeletionRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyDeletionRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.graceDays, graceDays) || other.graceDays == graceDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,requestedBy,scheduledFor,graceDays);

@override
String toString() {
  return 'FamilyDeletionRecord(id: $id, status: $status, requestedBy: $requestedBy, scheduledFor: $scheduledFor, graceDays: $graceDays)';
}


}

/// @nodoc
abstract mixin class $FamilyDeletionRecordCopyWith<$Res>  {
  factory $FamilyDeletionRecordCopyWith(FamilyDeletionRecord value, $Res Function(FamilyDeletionRecord) _then) = _$FamilyDeletionRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'status') String? status,@JsonKey(name: 'requestedBy') String? requestedBy,@JsonKey(name: 'scheduledFor') DateTime? scheduledFor,@JsonKey(name: 'graceDays') int? graceDays
});




}
/// @nodoc
class _$FamilyDeletionRecordCopyWithImpl<$Res>
    implements $FamilyDeletionRecordCopyWith<$Res> {
  _$FamilyDeletionRecordCopyWithImpl(this._self, this._then);

  final FamilyDeletionRecord _self;
  final $Res Function(FamilyDeletionRecord) _then;

/// Create a copy of FamilyDeletionRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? status = freezed,Object? requestedBy = freezed,Object? scheduledFor = freezed,Object? graceDays = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,requestedBy: freezed == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String?,scheduledFor: freezed == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime?,graceDays: freezed == graceDays ? _self.graceDays : graceDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyDeletionRecord].
extension FamilyDeletionRecordPatterns on FamilyDeletionRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyDeletionRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyDeletionRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyDeletionRecord value)  $default,){
final _that = this;
switch (_that) {
case _FamilyDeletionRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyDeletionRecord value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyDeletionRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FamilyDeletionRecord implements FamilyDeletionRecord {
  const _FamilyDeletionRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'status') this.status, @JsonKey(name: 'requestedBy') this.requestedBy, @JsonKey(name: 'scheduledFor') this.scheduledFor, @JsonKey(name: 'graceDays') this.graceDays});
  factory _FamilyDeletionRecord.fromJson(Map<String, dynamic> json) => _$FamilyDeletionRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'requestedBy') final  String? requestedBy;
@override@JsonKey(name: 'scheduledFor') final  DateTime? scheduledFor;
@override@JsonKey(name: 'graceDays') final  int? graceDays;

/// Create a copy of FamilyDeletionRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyDeletionRecordCopyWith<_FamilyDeletionRecord> get copyWith => __$FamilyDeletionRecordCopyWithImpl<_FamilyDeletionRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyDeletionRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyDeletionRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.graceDays, graceDays) || other.graceDays == graceDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,requestedBy,scheduledFor,graceDays);

@override
String toString() {
  return 'FamilyDeletionRecord(id: $id, status: $status, requestedBy: $requestedBy, scheduledFor: $scheduledFor, graceDays: $graceDays)';
}


}

/// @nodoc
abstract mixin class _$FamilyDeletionRecordCopyWith<$Res> implements $FamilyDeletionRecordCopyWith<$Res> {
  factory _$FamilyDeletionRecordCopyWith(_FamilyDeletionRecord value, $Res Function(_FamilyDeletionRecord) _then) = __$FamilyDeletionRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'status') String? status,@JsonKey(name: 'requestedBy') String? requestedBy,@JsonKey(name: 'scheduledFor') DateTime? scheduledFor,@JsonKey(name: 'graceDays') int? graceDays
});




}
/// @nodoc
class __$FamilyDeletionRecordCopyWithImpl<$Res>
    implements _$FamilyDeletionRecordCopyWith<$Res> {
  __$FamilyDeletionRecordCopyWithImpl(this._self, this._then);

  final _FamilyDeletionRecord _self;
  final $Res Function(_FamilyDeletionRecord) _then;

/// Create a copy of FamilyDeletionRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? status = freezed,Object? requestedBy = freezed,Object? scheduledFor = freezed,Object? graceDays = freezed,}) {
  return _then(_FamilyDeletionRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,requestedBy: freezed == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String?,scheduledFor: freezed == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime?,graceDays: freezed == graceDays ? _self.graceDays : graceDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
