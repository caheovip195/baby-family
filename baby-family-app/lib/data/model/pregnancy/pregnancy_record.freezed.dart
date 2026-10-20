// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pregnancy_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PregnancyRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'familyId') String? get familyId;@JsonKey(name: 'seqNo') int? get seqNo;@JsonKey(name: 'nickname') String? get nickname;@JsonKey(name: 'dueDate') DateTime? get dueDate;@JsonKey(name: 'expectedCount') int? get expectedCount;@JsonKey(name: 'status') String? get status;
/// Create a copy of PregnancyRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PregnancyRecordCopyWith<PregnancyRecord> get copyWith => _$PregnancyRecordCopyWithImpl<PregnancyRecord>(this as PregnancyRecord, _$identity);

  /// Serializes this PregnancyRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PregnancyRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.seqNo, seqNo) || other.seqNo == seqNo)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.expectedCount, expectedCount) || other.expectedCount == expectedCount)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,familyId,seqNo,nickname,dueDate,expectedCount,status);

@override
String toString() {
  return 'PregnancyRecord(id: $id, familyId: $familyId, seqNo: $seqNo, nickname: $nickname, dueDate: $dueDate, expectedCount: $expectedCount, status: $status)';
}


}

/// @nodoc
abstract mixin class $PregnancyRecordCopyWith<$Res>  {
  factory $PregnancyRecordCopyWith(PregnancyRecord value, $Res Function(PregnancyRecord) _then) = _$PregnancyRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'seqNo') int? seqNo,@JsonKey(name: 'nickname') String? nickname,@JsonKey(name: 'dueDate') DateTime? dueDate,@JsonKey(name: 'expectedCount') int? expectedCount,@JsonKey(name: 'status') String? status
});




}
/// @nodoc
class _$PregnancyRecordCopyWithImpl<$Res>
    implements $PregnancyRecordCopyWith<$Res> {
  _$PregnancyRecordCopyWithImpl(this._self, this._then);

  final PregnancyRecord _self;
  final $Res Function(PregnancyRecord) _then;

/// Create a copy of PregnancyRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? familyId = freezed,Object? seqNo = freezed,Object? nickname = freezed,Object? dueDate = freezed,Object? expectedCount = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,seqNo: freezed == seqNo ? _self.seqNo : seqNo // ignore: cast_nullable_to_non_nullable
as int?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expectedCount: freezed == expectedCount ? _self.expectedCount : expectedCount // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PregnancyRecord].
extension PregnancyRecordPatterns on PregnancyRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PregnancyRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PregnancyRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PregnancyRecord value)  $default,){
final _that = this;
switch (_that) {
case _PregnancyRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PregnancyRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PregnancyRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PregnancyRecord implements PregnancyRecord {
  const _PregnancyRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'familyId') this.familyId, @JsonKey(name: 'seqNo') this.seqNo, @JsonKey(name: 'nickname') this.nickname, @JsonKey(name: 'dueDate') this.dueDate, @JsonKey(name: 'expectedCount') this.expectedCount, @JsonKey(name: 'status') this.status});
  factory _PregnancyRecord.fromJson(Map<String, dynamic> json) => _$PregnancyRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'familyId') final  String? familyId;
@override@JsonKey(name: 'seqNo') final  int? seqNo;
@override@JsonKey(name: 'nickname') final  String? nickname;
@override@JsonKey(name: 'dueDate') final  DateTime? dueDate;
@override@JsonKey(name: 'expectedCount') final  int? expectedCount;
@override@JsonKey(name: 'status') final  String? status;

/// Create a copy of PregnancyRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PregnancyRecordCopyWith<_PregnancyRecord> get copyWith => __$PregnancyRecordCopyWithImpl<_PregnancyRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PregnancyRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PregnancyRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.seqNo, seqNo) || other.seqNo == seqNo)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.expectedCount, expectedCount) || other.expectedCount == expectedCount)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,familyId,seqNo,nickname,dueDate,expectedCount,status);

@override
String toString() {
  return 'PregnancyRecord(id: $id, familyId: $familyId, seqNo: $seqNo, nickname: $nickname, dueDate: $dueDate, expectedCount: $expectedCount, status: $status)';
}


}

/// @nodoc
abstract mixin class _$PregnancyRecordCopyWith<$Res> implements $PregnancyRecordCopyWith<$Res> {
  factory _$PregnancyRecordCopyWith(_PregnancyRecord value, $Res Function(_PregnancyRecord) _then) = __$PregnancyRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'seqNo') int? seqNo,@JsonKey(name: 'nickname') String? nickname,@JsonKey(name: 'dueDate') DateTime? dueDate,@JsonKey(name: 'expectedCount') int? expectedCount,@JsonKey(name: 'status') String? status
});




}
/// @nodoc
class __$PregnancyRecordCopyWithImpl<$Res>
    implements _$PregnancyRecordCopyWith<$Res> {
  __$PregnancyRecordCopyWithImpl(this._self, this._then);

  final _PregnancyRecord _self;
  final $Res Function(_PregnancyRecord) _then;

/// Create a copy of PregnancyRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? familyId = freezed,Object? seqNo = freezed,Object? nickname = freezed,Object? dueDate = freezed,Object? expectedCount = freezed,Object? status = freezed,}) {
  return _then(_PregnancyRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,seqNo: freezed == seqNo ? _self.seqNo : seqNo // ignore: cast_nullable_to_non_nullable
as int?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expectedCount: freezed == expectedCount ? _self.expectedCount : expectedCount // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
