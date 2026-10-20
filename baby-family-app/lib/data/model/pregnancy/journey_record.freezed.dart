// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JourneyRecord {

@JsonKey(name: 'pregnancyId') String? get pregnancyId;@JsonKey(name: 'currentWeek') int? get currentWeek;@JsonKey(name: 'currentDay') int? get currentDay;@JsonKey(name: 'daysLeft') int? get daysLeft;@JsonKey(name: 'week') JourneyWeekRecord? get week;
/// Create a copy of JourneyRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneyRecordCopyWith<JourneyRecord> get copyWith => _$JourneyRecordCopyWithImpl<JourneyRecord>(this as JourneyRecord, _$identity);

  /// Serializes this JourneyRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JourneyRecord&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.currentWeek, currentWeek) || other.currentWeek == currentWeek)&&(identical(other.currentDay, currentDay) || other.currentDay == currentDay)&&(identical(other.daysLeft, daysLeft) || other.daysLeft == daysLeft)&&(identical(other.week, week) || other.week == week));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pregnancyId,currentWeek,currentDay,daysLeft,week);

@override
String toString() {
  return 'JourneyRecord(pregnancyId: $pregnancyId, currentWeek: $currentWeek, currentDay: $currentDay, daysLeft: $daysLeft, week: $week)';
}


}

/// @nodoc
abstract mixin class $JourneyRecordCopyWith<$Res>  {
  factory $JourneyRecordCopyWith(JourneyRecord value, $Res Function(JourneyRecord) _then) = _$JourneyRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'pregnancyId') String? pregnancyId,@JsonKey(name: 'currentWeek') int? currentWeek,@JsonKey(name: 'currentDay') int? currentDay,@JsonKey(name: 'daysLeft') int? daysLeft,@JsonKey(name: 'week') JourneyWeekRecord? week
});


$JourneyWeekRecordCopyWith<$Res>? get week;

}
/// @nodoc
class _$JourneyRecordCopyWithImpl<$Res>
    implements $JourneyRecordCopyWith<$Res> {
  _$JourneyRecordCopyWithImpl(this._self, this._then);

  final JourneyRecord _self;
  final $Res Function(JourneyRecord) _then;

/// Create a copy of JourneyRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pregnancyId = freezed,Object? currentWeek = freezed,Object? currentDay = freezed,Object? daysLeft = freezed,Object? week = freezed,}) {
  return _then(_self.copyWith(
pregnancyId: freezed == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String?,currentWeek: freezed == currentWeek ? _self.currentWeek : currentWeek // ignore: cast_nullable_to_non_nullable
as int?,currentDay: freezed == currentDay ? _self.currentDay : currentDay // ignore: cast_nullable_to_non_nullable
as int?,daysLeft: freezed == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int?,week: freezed == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as JourneyWeekRecord?,
  ));
}
/// Create a copy of JourneyRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JourneyWeekRecordCopyWith<$Res>? get week {
    if (_self.week == null) {
    return null;
  }

  return $JourneyWeekRecordCopyWith<$Res>(_self.week!, (value) {
    return _then(_self.copyWith(week: value));
  });
}
}


/// Adds pattern-matching-related methods to [JourneyRecord].
extension JourneyRecordPatterns on JourneyRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JourneyRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JourneyRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JourneyRecord value)  $default,){
final _that = this;
switch (_that) {
case _JourneyRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JourneyRecord value)?  $default,){
final _that = this;
switch (_that) {
case _JourneyRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _JourneyRecord implements JourneyRecord {
  const _JourneyRecord({@JsonKey(name: 'pregnancyId') this.pregnancyId, @JsonKey(name: 'currentWeek') this.currentWeek, @JsonKey(name: 'currentDay') this.currentDay, @JsonKey(name: 'daysLeft') this.daysLeft, @JsonKey(name: 'week') this.week});
  factory _JourneyRecord.fromJson(Map<String, dynamic> json) => _$JourneyRecordFromJson(json);

@override@JsonKey(name: 'pregnancyId') final  String? pregnancyId;
@override@JsonKey(name: 'currentWeek') final  int? currentWeek;
@override@JsonKey(name: 'currentDay') final  int? currentDay;
@override@JsonKey(name: 'daysLeft') final  int? daysLeft;
@override@JsonKey(name: 'week') final  JourneyWeekRecord? week;

/// Create a copy of JourneyRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneyRecordCopyWith<_JourneyRecord> get copyWith => __$JourneyRecordCopyWithImpl<_JourneyRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JourneyRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JourneyRecord&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.currentWeek, currentWeek) || other.currentWeek == currentWeek)&&(identical(other.currentDay, currentDay) || other.currentDay == currentDay)&&(identical(other.daysLeft, daysLeft) || other.daysLeft == daysLeft)&&(identical(other.week, week) || other.week == week));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pregnancyId,currentWeek,currentDay,daysLeft,week);

@override
String toString() {
  return 'JourneyRecord(pregnancyId: $pregnancyId, currentWeek: $currentWeek, currentDay: $currentDay, daysLeft: $daysLeft, week: $week)';
}


}

/// @nodoc
abstract mixin class _$JourneyRecordCopyWith<$Res> implements $JourneyRecordCopyWith<$Res> {
  factory _$JourneyRecordCopyWith(_JourneyRecord value, $Res Function(_JourneyRecord) _then) = __$JourneyRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'pregnancyId') String? pregnancyId,@JsonKey(name: 'currentWeek') int? currentWeek,@JsonKey(name: 'currentDay') int? currentDay,@JsonKey(name: 'daysLeft') int? daysLeft,@JsonKey(name: 'week') JourneyWeekRecord? week
});


@override $JourneyWeekRecordCopyWith<$Res>? get week;

}
/// @nodoc
class __$JourneyRecordCopyWithImpl<$Res>
    implements _$JourneyRecordCopyWith<$Res> {
  __$JourneyRecordCopyWithImpl(this._self, this._then);

  final _JourneyRecord _self;
  final $Res Function(_JourneyRecord) _then;

/// Create a copy of JourneyRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pregnancyId = freezed,Object? currentWeek = freezed,Object? currentDay = freezed,Object? daysLeft = freezed,Object? week = freezed,}) {
  return _then(_JourneyRecord(
pregnancyId: freezed == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String?,currentWeek: freezed == currentWeek ? _self.currentWeek : currentWeek // ignore: cast_nullable_to_non_nullable
as int?,currentDay: freezed == currentDay ? _self.currentDay : currentDay // ignore: cast_nullable_to_non_nullable
as int?,daysLeft: freezed == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int?,week: freezed == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as JourneyWeekRecord?,
  ));
}

/// Create a copy of JourneyRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JourneyWeekRecordCopyWith<$Res>? get week {
    if (_self.week == null) {
    return null;
  }

  return $JourneyWeekRecordCopyWith<$Res>(_self.week!, (value) {
    return _then(_self.copyWith(week: value));
  });
}
}

// dart format on
