// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'code') String? get code;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'createdAt') DateTime? get createdAt;
/// Create a copy of ReportRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportRecordCopyWith<ReportRecord> get copyWith => _$ReportRecordCopyWithImpl<ReportRecord>(this as ReportRecord, _$identity);

  /// Serializes this ReportRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,status,createdAt);

@override
String toString() {
  return 'ReportRecord(id: $id, code: $code, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ReportRecordCopyWith<$Res>  {
  factory $ReportRecordCopyWith(ReportRecord value, $Res Function(ReportRecord) _then) = _$ReportRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'code') String? code,@JsonKey(name: 'status') String? status,@JsonKey(name: 'createdAt') DateTime? createdAt
});




}
/// @nodoc
class _$ReportRecordCopyWithImpl<$Res>
    implements $ReportRecordCopyWith<$Res> {
  _$ReportRecordCopyWithImpl(this._self, this._then);

  final ReportRecord _self;
  final $Res Function(ReportRecord) _then;

/// Create a copy of ReportRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? code = freezed,Object? status = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportRecord].
extension ReportRecordPatterns on ReportRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportRecord value)  $default,){
final _that = this;
switch (_that) {
case _ReportRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ReportRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ReportRecord implements ReportRecord {
  const _ReportRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'code') this.code, @JsonKey(name: 'status') this.status, @JsonKey(name: 'createdAt') this.createdAt});
  factory _ReportRecord.fromJson(Map<String, dynamic> json) => _$ReportRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'code') final  String? code;
@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;

/// Create a copy of ReportRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportRecordCopyWith<_ReportRecord> get copyWith => __$ReportRecordCopyWithImpl<_ReportRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,status,createdAt);

@override
String toString() {
  return 'ReportRecord(id: $id, code: $code, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReportRecordCopyWith<$Res> implements $ReportRecordCopyWith<$Res> {
  factory _$ReportRecordCopyWith(_ReportRecord value, $Res Function(_ReportRecord) _then) = __$ReportRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'code') String? code,@JsonKey(name: 'status') String? status,@JsonKey(name: 'createdAt') DateTime? createdAt
});




}
/// @nodoc
class __$ReportRecordCopyWithImpl<$Res>
    implements _$ReportRecordCopyWith<$Res> {
  __$ReportRecordCopyWithImpl(this._self, this._then);

  final _ReportRecord _self;
  final $Res Function(_ReportRecord) _then;

/// Create a copy of ReportRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? code = freezed,Object? status = freezed,Object? createdAt = freezed,}) {
  return _then(_ReportRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
