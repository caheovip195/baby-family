// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarRecord {

@JsonKey(name: 'events') List<CalendarEventRecord> get events;@JsonKey(name: 'missions') List<MissionRecord> get missions;@JsonKey(name: 'specialDays') List<CalendarSpecialDayRecord> get specialDays;
/// Create a copy of CalendarRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarRecordCopyWith<CalendarRecord> get copyWith => _$CalendarRecordCopyWithImpl<CalendarRecord>(this as CalendarRecord, _$identity);

  /// Serializes this CalendarRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarRecord&&const DeepCollectionEquality().equals(other.events, events)&&const DeepCollectionEquality().equals(other.missions, missions)&&const DeepCollectionEquality().equals(other.specialDays, specialDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(events),const DeepCollectionEquality().hash(missions),const DeepCollectionEquality().hash(specialDays));

@override
String toString() {
  return 'CalendarRecord(events: $events, missions: $missions, specialDays: $specialDays)';
}


}

/// @nodoc
abstract mixin class $CalendarRecordCopyWith<$Res>  {
  factory $CalendarRecordCopyWith(CalendarRecord value, $Res Function(CalendarRecord) _then) = _$CalendarRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'events') List<CalendarEventRecord> events,@JsonKey(name: 'missions') List<MissionRecord> missions,@JsonKey(name: 'specialDays') List<CalendarSpecialDayRecord> specialDays
});




}
/// @nodoc
class _$CalendarRecordCopyWithImpl<$Res>
    implements $CalendarRecordCopyWith<$Res> {
  _$CalendarRecordCopyWithImpl(this._self, this._then);

  final CalendarRecord _self;
  final $Res Function(CalendarRecord) _then;

/// Create a copy of CalendarRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? events = null,Object? missions = null,Object? specialDays = null,}) {
  return _then(_self.copyWith(
events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<CalendarEventRecord>,missions: null == missions ? _self.missions : missions // ignore: cast_nullable_to_non_nullable
as List<MissionRecord>,specialDays: null == specialDays ? _self.specialDays : specialDays // ignore: cast_nullable_to_non_nullable
as List<CalendarSpecialDayRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarRecord].
extension CalendarRecordPatterns on CalendarRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarRecord value)  $default,){
final _that = this;
switch (_that) {
case _CalendarRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarRecord value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CalendarRecord implements CalendarRecord {
  const _CalendarRecord({@JsonKey(name: 'events') final  List<CalendarEventRecord> events = const <CalendarEventRecord>[], @JsonKey(name: 'missions') final  List<MissionRecord> missions = const <MissionRecord>[], @JsonKey(name: 'specialDays') final  List<CalendarSpecialDayRecord> specialDays = const <CalendarSpecialDayRecord>[]}): _events = events,_missions = missions,_specialDays = specialDays;
  factory _CalendarRecord.fromJson(Map<String, dynamic> json) => _$CalendarRecordFromJson(json);

 final  List<CalendarEventRecord> _events;
@override@JsonKey(name: 'events') List<CalendarEventRecord> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

 final  List<MissionRecord> _missions;
@override@JsonKey(name: 'missions') List<MissionRecord> get missions {
  if (_missions is EqualUnmodifiableListView) return _missions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_missions);
}

 final  List<CalendarSpecialDayRecord> _specialDays;
@override@JsonKey(name: 'specialDays') List<CalendarSpecialDayRecord> get specialDays {
  if (_specialDays is EqualUnmodifiableListView) return _specialDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specialDays);
}


/// Create a copy of CalendarRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarRecordCopyWith<_CalendarRecord> get copyWith => __$CalendarRecordCopyWithImpl<_CalendarRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarRecord&&const DeepCollectionEquality().equals(other._events, _events)&&const DeepCollectionEquality().equals(other._missions, _missions)&&const DeepCollectionEquality().equals(other._specialDays, _specialDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_events),const DeepCollectionEquality().hash(_missions),const DeepCollectionEquality().hash(_specialDays));

@override
String toString() {
  return 'CalendarRecord(events: $events, missions: $missions, specialDays: $specialDays)';
}


}

/// @nodoc
abstract mixin class _$CalendarRecordCopyWith<$Res> implements $CalendarRecordCopyWith<$Res> {
  factory _$CalendarRecordCopyWith(_CalendarRecord value, $Res Function(_CalendarRecord) _then) = __$CalendarRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'events') List<CalendarEventRecord> events,@JsonKey(name: 'missions') List<MissionRecord> missions,@JsonKey(name: 'specialDays') List<CalendarSpecialDayRecord> specialDays
});




}
/// @nodoc
class __$CalendarRecordCopyWithImpl<$Res>
    implements _$CalendarRecordCopyWith<$Res> {
  __$CalendarRecordCopyWithImpl(this._self, this._then);

  final _CalendarRecord _self;
  final $Res Function(_CalendarRecord) _then;

/// Create a copy of CalendarRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? events = null,Object? missions = null,Object? specialDays = null,}) {
  return _then(_CalendarRecord(
events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<CalendarEventRecord>,missions: null == missions ? _self._missions : missions // ignore: cast_nullable_to_non_nullable
as List<MissionRecord>,specialDays: null == specialDays ? _self._specialDays : specialDays // ignore: cast_nullable_to_non_nullable
as List<CalendarSpecialDayRecord>,
  ));
}


}

// dart format on
