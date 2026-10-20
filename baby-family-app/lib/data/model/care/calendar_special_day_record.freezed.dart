// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_special_day_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarSpecialDayRecord {

@JsonKey(name: 'date') String? get date;@JsonKey(name: 'type') String? get type;@JsonKey(name: 'childId') String? get childId;@JsonKey(name: 'childName') String? get childName;@JsonKey(name: 'ageYears') int? get ageYears;@JsonKey(name: 'ageMonths') int? get ageMonths;
/// Create a copy of CalendarSpecialDayRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarSpecialDayRecordCopyWith<CalendarSpecialDayRecord> get copyWith => _$CalendarSpecialDayRecordCopyWithImpl<CalendarSpecialDayRecord>(this as CalendarSpecialDayRecord, _$identity);

  /// Serializes this CalendarSpecialDayRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarSpecialDayRecord&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.ageYears, ageYears) || other.ageYears == ageYears)&&(identical(other.ageMonths, ageMonths) || other.ageMonths == ageMonths));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,type,childId,childName,ageYears,ageMonths);

@override
String toString() {
  return 'CalendarSpecialDayRecord(date: $date, type: $type, childId: $childId, childName: $childName, ageYears: $ageYears, ageMonths: $ageMonths)';
}


}

/// @nodoc
abstract mixin class $CalendarSpecialDayRecordCopyWith<$Res>  {
  factory $CalendarSpecialDayRecordCopyWith(CalendarSpecialDayRecord value, $Res Function(CalendarSpecialDayRecord) _then) = _$CalendarSpecialDayRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'date') String? date,@JsonKey(name: 'type') String? type,@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'childName') String? childName,@JsonKey(name: 'ageYears') int? ageYears,@JsonKey(name: 'ageMonths') int? ageMonths
});




}
/// @nodoc
class _$CalendarSpecialDayRecordCopyWithImpl<$Res>
    implements $CalendarSpecialDayRecordCopyWith<$Res> {
  _$CalendarSpecialDayRecordCopyWithImpl(this._self, this._then);

  final CalendarSpecialDayRecord _self;
  final $Res Function(CalendarSpecialDayRecord) _then;

/// Create a copy of CalendarSpecialDayRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = freezed,Object? type = freezed,Object? childId = freezed,Object? childName = freezed,Object? ageYears = freezed,Object? ageMonths = freezed,}) {
  return _then(_self.copyWith(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,childName: freezed == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String?,ageYears: freezed == ageYears ? _self.ageYears : ageYears // ignore: cast_nullable_to_non_nullable
as int?,ageMonths: freezed == ageMonths ? _self.ageMonths : ageMonths // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarSpecialDayRecord].
extension CalendarSpecialDayRecordPatterns on CalendarSpecialDayRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarSpecialDayRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarSpecialDayRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarSpecialDayRecord value)  $default,){
final _that = this;
switch (_that) {
case _CalendarSpecialDayRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarSpecialDayRecord value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarSpecialDayRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CalendarSpecialDayRecord implements CalendarSpecialDayRecord {
  const _CalendarSpecialDayRecord({@JsonKey(name: 'date') this.date, @JsonKey(name: 'type') this.type, @JsonKey(name: 'childId') this.childId, @JsonKey(name: 'childName') this.childName, @JsonKey(name: 'ageYears') this.ageYears, @JsonKey(name: 'ageMonths') this.ageMonths});
  factory _CalendarSpecialDayRecord.fromJson(Map<String, dynamic> json) => _$CalendarSpecialDayRecordFromJson(json);

@override@JsonKey(name: 'date') final  String? date;
@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'childId') final  String? childId;
@override@JsonKey(name: 'childName') final  String? childName;
@override@JsonKey(name: 'ageYears') final  int? ageYears;
@override@JsonKey(name: 'ageMonths') final  int? ageMonths;

/// Create a copy of CalendarSpecialDayRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarSpecialDayRecordCopyWith<_CalendarSpecialDayRecord> get copyWith => __$CalendarSpecialDayRecordCopyWithImpl<_CalendarSpecialDayRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarSpecialDayRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarSpecialDayRecord&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.ageYears, ageYears) || other.ageYears == ageYears)&&(identical(other.ageMonths, ageMonths) || other.ageMonths == ageMonths));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,type,childId,childName,ageYears,ageMonths);

@override
String toString() {
  return 'CalendarSpecialDayRecord(date: $date, type: $type, childId: $childId, childName: $childName, ageYears: $ageYears, ageMonths: $ageMonths)';
}


}

/// @nodoc
abstract mixin class _$CalendarSpecialDayRecordCopyWith<$Res> implements $CalendarSpecialDayRecordCopyWith<$Res> {
  factory _$CalendarSpecialDayRecordCopyWith(_CalendarSpecialDayRecord value, $Res Function(_CalendarSpecialDayRecord) _then) = __$CalendarSpecialDayRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'date') String? date,@JsonKey(name: 'type') String? type,@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'childName') String? childName,@JsonKey(name: 'ageYears') int? ageYears,@JsonKey(name: 'ageMonths') int? ageMonths
});




}
/// @nodoc
class __$CalendarSpecialDayRecordCopyWithImpl<$Res>
    implements _$CalendarSpecialDayRecordCopyWith<$Res> {
  __$CalendarSpecialDayRecordCopyWithImpl(this._self, this._then);

  final _CalendarSpecialDayRecord _self;
  final $Res Function(_CalendarSpecialDayRecord) _then;

/// Create a copy of CalendarSpecialDayRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = freezed,Object? type = freezed,Object? childId = freezed,Object? childName = freezed,Object? ageYears = freezed,Object? ageMonths = freezed,}) {
  return _then(_CalendarSpecialDayRecord(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,childName: freezed == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String?,ageYears: freezed == ageYears ? _self.ageYears : ageYears // ignore: cast_nullable_to_non_nullable
as int?,ageMonths: freezed == ageMonths ? _self.ageMonths : ageMonths // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
