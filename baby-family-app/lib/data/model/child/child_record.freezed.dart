// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChildRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'familyId') String? get familyId;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'nickname') String? get nickname;@JsonKey(name: 'birthDate') DateTime? get birthDate;@JsonKey(name: 'birthTime') String? get birthTime;@JsonKey(name: 'gender') String? get gender;@JsonKey(name: 'colorIndex') int? get colorIndex;@JsonKey(name: 'status') String? get status;
/// Create a copy of ChildRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildRecordCopyWith<ChildRecord> get copyWith => _$ChildRecordCopyWithImpl<ChildRecord>(this as ChildRecord, _$identity);

  /// Serializes this ChildRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChildRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.birthTime, birthTime) || other.birthTime == birthTime)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,familyId,name,nickname,birthDate,birthTime,gender,colorIndex,status);

@override
String toString() {
  return 'ChildRecord(id: $id, familyId: $familyId, name: $name, nickname: $nickname, birthDate: $birthDate, birthTime: $birthTime, gender: $gender, colorIndex: $colorIndex, status: $status)';
}


}

/// @nodoc
abstract mixin class $ChildRecordCopyWith<$Res>  {
  factory $ChildRecordCopyWith(ChildRecord value, $Res Function(ChildRecord) _then) = _$ChildRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'name') String? name,@JsonKey(name: 'nickname') String? nickname,@JsonKey(name: 'birthDate') DateTime? birthDate,@JsonKey(name: 'birthTime') String? birthTime,@JsonKey(name: 'gender') String? gender,@JsonKey(name: 'colorIndex') int? colorIndex,@JsonKey(name: 'status') String? status
});




}
/// @nodoc
class _$ChildRecordCopyWithImpl<$Res>
    implements $ChildRecordCopyWith<$Res> {
  _$ChildRecordCopyWithImpl(this._self, this._then);

  final ChildRecord _self;
  final $Res Function(ChildRecord) _then;

/// Create a copy of ChildRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? familyId = freezed,Object? name = freezed,Object? nickname = freezed,Object? birthDate = freezed,Object? birthTime = freezed,Object? gender = freezed,Object? colorIndex = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,birthTime: freezed == birthTime ? _self.birthTime : birthTime // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,colorIndex: freezed == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChildRecord].
extension ChildRecordPatterns on ChildRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChildRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChildRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChildRecord value)  $default,){
final _that = this;
switch (_that) {
case _ChildRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChildRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ChildRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChildRecord implements ChildRecord {
  const _ChildRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'familyId') this.familyId, @JsonKey(name: 'name') this.name, @JsonKey(name: 'nickname') this.nickname, @JsonKey(name: 'birthDate') this.birthDate, @JsonKey(name: 'birthTime') this.birthTime, @JsonKey(name: 'gender') this.gender, @JsonKey(name: 'colorIndex') this.colorIndex, @JsonKey(name: 'status') this.status});
  factory _ChildRecord.fromJson(Map<String, dynamic> json) => _$ChildRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'familyId') final  String? familyId;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'nickname') final  String? nickname;
@override@JsonKey(name: 'birthDate') final  DateTime? birthDate;
@override@JsonKey(name: 'birthTime') final  String? birthTime;
@override@JsonKey(name: 'gender') final  String? gender;
@override@JsonKey(name: 'colorIndex') final  int? colorIndex;
@override@JsonKey(name: 'status') final  String? status;

/// Create a copy of ChildRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildRecordCopyWith<_ChildRecord> get copyWith => __$ChildRecordCopyWithImpl<_ChildRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChildRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChildRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.birthTime, birthTime) || other.birthTime == birthTime)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,familyId,name,nickname,birthDate,birthTime,gender,colorIndex,status);

@override
String toString() {
  return 'ChildRecord(id: $id, familyId: $familyId, name: $name, nickname: $nickname, birthDate: $birthDate, birthTime: $birthTime, gender: $gender, colorIndex: $colorIndex, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ChildRecordCopyWith<$Res> implements $ChildRecordCopyWith<$Res> {
  factory _$ChildRecordCopyWith(_ChildRecord value, $Res Function(_ChildRecord) _then) = __$ChildRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'name') String? name,@JsonKey(name: 'nickname') String? nickname,@JsonKey(name: 'birthDate') DateTime? birthDate,@JsonKey(name: 'birthTime') String? birthTime,@JsonKey(name: 'gender') String? gender,@JsonKey(name: 'colorIndex') int? colorIndex,@JsonKey(name: 'status') String? status
});




}
/// @nodoc
class __$ChildRecordCopyWithImpl<$Res>
    implements _$ChildRecordCopyWith<$Res> {
  __$ChildRecordCopyWithImpl(this._self, this._then);

  final _ChildRecord _self;
  final $Res Function(_ChildRecord) _then;

/// Create a copy of ChildRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? familyId = freezed,Object? name = freezed,Object? nickname = freezed,Object? birthDate = freezed,Object? birthTime = freezed,Object? gender = freezed,Object? colorIndex = freezed,Object? status = freezed,}) {
  return _then(_ChildRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,birthTime: freezed == birthTime ? _self.birthTime : birthTime // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,colorIndex: freezed == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
