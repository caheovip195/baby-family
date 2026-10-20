// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_result_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionResultRecord {

@JsonKey(name: 'mission') MissionRecord? get mission;@JsonKey(name: 'myHeartsAwarded') int? get myHeartsAwarded;@JsonKey(name: 'removedId') String? get removedId;
/// Create a copy of MissionResultRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionResultRecordCopyWith<MissionResultRecord> get copyWith => _$MissionResultRecordCopyWithImpl<MissionResultRecord>(this as MissionResultRecord, _$identity);

  /// Serializes this MissionResultRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionResultRecord&&(identical(other.mission, mission) || other.mission == mission)&&(identical(other.myHeartsAwarded, myHeartsAwarded) || other.myHeartsAwarded == myHeartsAwarded)&&(identical(other.removedId, removedId) || other.removedId == removedId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mission,myHeartsAwarded,removedId);

@override
String toString() {
  return 'MissionResultRecord(mission: $mission, myHeartsAwarded: $myHeartsAwarded, removedId: $removedId)';
}


}

/// @nodoc
abstract mixin class $MissionResultRecordCopyWith<$Res>  {
  factory $MissionResultRecordCopyWith(MissionResultRecord value, $Res Function(MissionResultRecord) _then) = _$MissionResultRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'mission') MissionRecord? mission,@JsonKey(name: 'myHeartsAwarded') int? myHeartsAwarded,@JsonKey(name: 'removedId') String? removedId
});


$MissionRecordCopyWith<$Res>? get mission;

}
/// @nodoc
class _$MissionResultRecordCopyWithImpl<$Res>
    implements $MissionResultRecordCopyWith<$Res> {
  _$MissionResultRecordCopyWithImpl(this._self, this._then);

  final MissionResultRecord _self;
  final $Res Function(MissionResultRecord) _then;

/// Create a copy of MissionResultRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mission = freezed,Object? myHeartsAwarded = freezed,Object? removedId = freezed,}) {
  return _then(_self.copyWith(
mission: freezed == mission ? _self.mission : mission // ignore: cast_nullable_to_non_nullable
as MissionRecord?,myHeartsAwarded: freezed == myHeartsAwarded ? _self.myHeartsAwarded : myHeartsAwarded // ignore: cast_nullable_to_non_nullable
as int?,removedId: freezed == removedId ? _self.removedId : removedId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MissionResultRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MissionRecordCopyWith<$Res>? get mission {
    if (_self.mission == null) {
    return null;
  }

  return $MissionRecordCopyWith<$Res>(_self.mission!, (value) {
    return _then(_self.copyWith(mission: value));
  });
}
}


/// Adds pattern-matching-related methods to [MissionResultRecord].
extension MissionResultRecordPatterns on MissionResultRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionResultRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionResultRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionResultRecord value)  $default,){
final _that = this;
switch (_that) {
case _MissionResultRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionResultRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MissionResultRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MissionResultRecord implements MissionResultRecord {
  const _MissionResultRecord({@JsonKey(name: 'mission') this.mission, @JsonKey(name: 'myHeartsAwarded') this.myHeartsAwarded, @JsonKey(name: 'removedId') this.removedId});
  factory _MissionResultRecord.fromJson(Map<String, dynamic> json) => _$MissionResultRecordFromJson(json);

@override@JsonKey(name: 'mission') final  MissionRecord? mission;
@override@JsonKey(name: 'myHeartsAwarded') final  int? myHeartsAwarded;
@override@JsonKey(name: 'removedId') final  String? removedId;

/// Create a copy of MissionResultRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionResultRecordCopyWith<_MissionResultRecord> get copyWith => __$MissionResultRecordCopyWithImpl<_MissionResultRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionResultRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionResultRecord&&(identical(other.mission, mission) || other.mission == mission)&&(identical(other.myHeartsAwarded, myHeartsAwarded) || other.myHeartsAwarded == myHeartsAwarded)&&(identical(other.removedId, removedId) || other.removedId == removedId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mission,myHeartsAwarded,removedId);

@override
String toString() {
  return 'MissionResultRecord(mission: $mission, myHeartsAwarded: $myHeartsAwarded, removedId: $removedId)';
}


}

/// @nodoc
abstract mixin class _$MissionResultRecordCopyWith<$Res> implements $MissionResultRecordCopyWith<$Res> {
  factory _$MissionResultRecordCopyWith(_MissionResultRecord value, $Res Function(_MissionResultRecord) _then) = __$MissionResultRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'mission') MissionRecord? mission,@JsonKey(name: 'myHeartsAwarded') int? myHeartsAwarded,@JsonKey(name: 'removedId') String? removedId
});


@override $MissionRecordCopyWith<$Res>? get mission;

}
/// @nodoc
class __$MissionResultRecordCopyWithImpl<$Res>
    implements _$MissionResultRecordCopyWith<$Res> {
  __$MissionResultRecordCopyWithImpl(this._self, this._then);

  final _MissionResultRecord _self;
  final $Res Function(_MissionResultRecord) _then;

/// Create a copy of MissionResultRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mission = freezed,Object? myHeartsAwarded = freezed,Object? removedId = freezed,}) {
  return _then(_MissionResultRecord(
mission: freezed == mission ? _self.mission : mission // ignore: cast_nullable_to_non_nullable
as MissionRecord?,myHeartsAwarded: freezed == myHeartsAwarded ? _self.myHeartsAwarded : myHeartsAwarded // ignore: cast_nullable_to_non_nullable
as int?,removedId: freezed == removedId ? _self.removedId : removedId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MissionResultRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MissionRecordCopyWith<$Res>? get mission {
    if (_self.mission == null) {
    return null;
  }

  return $MissionRecordCopyWith<$Res>(_self.mission!, (value) {
    return _then(_self.copyWith(mission: value));
  });
}
}

// dart format on
