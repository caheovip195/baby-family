// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_event_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarEventRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'type') String? get type;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'notes') String? get notes;@JsonKey(name: 'allDay') bool get allDay;@JsonKey(name: 'startAt') DateTime? get startAt;@JsonKey(name: 'localStartDate') String? get localStartDate;@JsonKey(name: 'occurrenceDate') String? get occurrenceDate;@JsonKey(name: 'isLunar') bool get isLunar;@JsonKey(name: 'lunarMonth') int? get lunarMonth;@JsonKey(name: 'lunarDay') int? get lunarDay;@JsonKey(name: 'repeatYearly') bool get repeatYearly;@JsonKey(name: 'inviteCircle') bool get inviteCircle;@JsonKey(name: 'childIds') List<String> get childIds;@JsonKey(name: 'participants') List<EventParticipantRecord> get participants;@JsonKey(name: 'reminderRules') List<EventReminderRuleRecord> get reminderRules;
/// Create a copy of CalendarEventRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarEventRecordCopyWith<CalendarEventRecord> get copyWith => _$CalendarEventRecordCopyWithImpl<CalendarEventRecord>(this as CalendarEventRecord, _$identity);

  /// Serializes this CalendarEventRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarEventRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.allDay, allDay) || other.allDay == allDay)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.localStartDate, localStartDate) || other.localStartDate == localStartDate)&&(identical(other.occurrenceDate, occurrenceDate) || other.occurrenceDate == occurrenceDate)&&(identical(other.isLunar, isLunar) || other.isLunar == isLunar)&&(identical(other.lunarMonth, lunarMonth) || other.lunarMonth == lunarMonth)&&(identical(other.lunarDay, lunarDay) || other.lunarDay == lunarDay)&&(identical(other.repeatYearly, repeatYearly) || other.repeatYearly == repeatYearly)&&(identical(other.inviteCircle, inviteCircle) || other.inviteCircle == inviteCircle)&&const DeepCollectionEquality().equals(other.childIds, childIds)&&const DeepCollectionEquality().equals(other.participants, participants)&&const DeepCollectionEquality().equals(other.reminderRules, reminderRules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,notes,allDay,startAt,localStartDate,occurrenceDate,isLunar,lunarMonth,lunarDay,repeatYearly,inviteCircle,const DeepCollectionEquality().hash(childIds),const DeepCollectionEquality().hash(participants),const DeepCollectionEquality().hash(reminderRules));

@override
String toString() {
  return 'CalendarEventRecord(id: $id, type: $type, title: $title, notes: $notes, allDay: $allDay, startAt: $startAt, localStartDate: $localStartDate, occurrenceDate: $occurrenceDate, isLunar: $isLunar, lunarMonth: $lunarMonth, lunarDay: $lunarDay, repeatYearly: $repeatYearly, inviteCircle: $inviteCircle, childIds: $childIds, participants: $participants, reminderRules: $reminderRules)';
}


}

/// @nodoc
abstract mixin class $CalendarEventRecordCopyWith<$Res>  {
  factory $CalendarEventRecordCopyWith(CalendarEventRecord value, $Res Function(CalendarEventRecord) _then) = _$CalendarEventRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'type') String? type,@JsonKey(name: 'title') String? title,@JsonKey(name: 'notes') String? notes,@JsonKey(name: 'allDay') bool allDay,@JsonKey(name: 'startAt') DateTime? startAt,@JsonKey(name: 'localStartDate') String? localStartDate,@JsonKey(name: 'occurrenceDate') String? occurrenceDate,@JsonKey(name: 'isLunar') bool isLunar,@JsonKey(name: 'lunarMonth') int? lunarMonth,@JsonKey(name: 'lunarDay') int? lunarDay,@JsonKey(name: 'repeatYearly') bool repeatYearly,@JsonKey(name: 'inviteCircle') bool inviteCircle,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'participants') List<EventParticipantRecord> participants,@JsonKey(name: 'reminderRules') List<EventReminderRuleRecord> reminderRules
});




}
/// @nodoc
class _$CalendarEventRecordCopyWithImpl<$Res>
    implements $CalendarEventRecordCopyWith<$Res> {
  _$CalendarEventRecordCopyWithImpl(this._self, this._then);

  final CalendarEventRecord _self;
  final $Res Function(CalendarEventRecord) _then;

/// Create a copy of CalendarEventRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? type = freezed,Object? title = freezed,Object? notes = freezed,Object? allDay = null,Object? startAt = freezed,Object? localStartDate = freezed,Object? occurrenceDate = freezed,Object? isLunar = null,Object? lunarMonth = freezed,Object? lunarDay = freezed,Object? repeatYearly = null,Object? inviteCircle = null,Object? childIds = null,Object? participants = null,Object? reminderRules = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,allDay: null == allDay ? _self.allDay : allDay // ignore: cast_nullable_to_non_nullable
as bool,startAt: freezed == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime?,localStartDate: freezed == localStartDate ? _self.localStartDate : localStartDate // ignore: cast_nullable_to_non_nullable
as String?,occurrenceDate: freezed == occurrenceDate ? _self.occurrenceDate : occurrenceDate // ignore: cast_nullable_to_non_nullable
as String?,isLunar: null == isLunar ? _self.isLunar : isLunar // ignore: cast_nullable_to_non_nullable
as bool,lunarMonth: freezed == lunarMonth ? _self.lunarMonth : lunarMonth // ignore: cast_nullable_to_non_nullable
as int?,lunarDay: freezed == lunarDay ? _self.lunarDay : lunarDay // ignore: cast_nullable_to_non_nullable
as int?,repeatYearly: null == repeatYearly ? _self.repeatYearly : repeatYearly // ignore: cast_nullable_to_non_nullable
as bool,inviteCircle: null == inviteCircle ? _self.inviteCircle : inviteCircle // ignore: cast_nullable_to_non_nullable
as bool,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<EventParticipantRecord>,reminderRules: null == reminderRules ? _self.reminderRules : reminderRules // ignore: cast_nullable_to_non_nullable
as List<EventReminderRuleRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarEventRecord].
extension CalendarEventRecordPatterns on CalendarEventRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarEventRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarEventRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarEventRecord value)  $default,){
final _that = this;
switch (_that) {
case _CalendarEventRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarEventRecord value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarEventRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CalendarEventRecord implements CalendarEventRecord {
  const _CalendarEventRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'type') this.type, @JsonKey(name: 'title') this.title, @JsonKey(name: 'notes') this.notes, @JsonKey(name: 'allDay') this.allDay = false, @JsonKey(name: 'startAt') this.startAt, @JsonKey(name: 'localStartDate') this.localStartDate, @JsonKey(name: 'occurrenceDate') this.occurrenceDate, @JsonKey(name: 'isLunar') this.isLunar = false, @JsonKey(name: 'lunarMonth') this.lunarMonth, @JsonKey(name: 'lunarDay') this.lunarDay, @JsonKey(name: 'repeatYearly') this.repeatYearly = false, @JsonKey(name: 'inviteCircle') this.inviteCircle = false, @JsonKey(name: 'childIds') final  List<String> childIds = const <String>[], @JsonKey(name: 'participants') final  List<EventParticipantRecord> participants = const <EventParticipantRecord>[], @JsonKey(name: 'reminderRules') final  List<EventReminderRuleRecord> reminderRules = const <EventReminderRuleRecord>[]}): _childIds = childIds,_participants = participants,_reminderRules = reminderRules;
  factory _CalendarEventRecord.fromJson(Map<String, dynamic> json) => _$CalendarEventRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'notes') final  String? notes;
@override@JsonKey(name: 'allDay') final  bool allDay;
@override@JsonKey(name: 'startAt') final  DateTime? startAt;
@override@JsonKey(name: 'localStartDate') final  String? localStartDate;
@override@JsonKey(name: 'occurrenceDate') final  String? occurrenceDate;
@override@JsonKey(name: 'isLunar') final  bool isLunar;
@override@JsonKey(name: 'lunarMonth') final  int? lunarMonth;
@override@JsonKey(name: 'lunarDay') final  int? lunarDay;
@override@JsonKey(name: 'repeatYearly') final  bool repeatYearly;
@override@JsonKey(name: 'inviteCircle') final  bool inviteCircle;
 final  List<String> _childIds;
@override@JsonKey(name: 'childIds') List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}

 final  List<EventParticipantRecord> _participants;
@override@JsonKey(name: 'participants') List<EventParticipantRecord> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

 final  List<EventReminderRuleRecord> _reminderRules;
@override@JsonKey(name: 'reminderRules') List<EventReminderRuleRecord> get reminderRules {
  if (_reminderRules is EqualUnmodifiableListView) return _reminderRules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminderRules);
}


/// Create a copy of CalendarEventRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarEventRecordCopyWith<_CalendarEventRecord> get copyWith => __$CalendarEventRecordCopyWithImpl<_CalendarEventRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarEventRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarEventRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.allDay, allDay) || other.allDay == allDay)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.localStartDate, localStartDate) || other.localStartDate == localStartDate)&&(identical(other.occurrenceDate, occurrenceDate) || other.occurrenceDate == occurrenceDate)&&(identical(other.isLunar, isLunar) || other.isLunar == isLunar)&&(identical(other.lunarMonth, lunarMonth) || other.lunarMonth == lunarMonth)&&(identical(other.lunarDay, lunarDay) || other.lunarDay == lunarDay)&&(identical(other.repeatYearly, repeatYearly) || other.repeatYearly == repeatYearly)&&(identical(other.inviteCircle, inviteCircle) || other.inviteCircle == inviteCircle)&&const DeepCollectionEquality().equals(other._childIds, _childIds)&&const DeepCollectionEquality().equals(other._participants, _participants)&&const DeepCollectionEquality().equals(other._reminderRules, _reminderRules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,notes,allDay,startAt,localStartDate,occurrenceDate,isLunar,lunarMonth,lunarDay,repeatYearly,inviteCircle,const DeepCollectionEquality().hash(_childIds),const DeepCollectionEquality().hash(_participants),const DeepCollectionEquality().hash(_reminderRules));

@override
String toString() {
  return 'CalendarEventRecord(id: $id, type: $type, title: $title, notes: $notes, allDay: $allDay, startAt: $startAt, localStartDate: $localStartDate, occurrenceDate: $occurrenceDate, isLunar: $isLunar, lunarMonth: $lunarMonth, lunarDay: $lunarDay, repeatYearly: $repeatYearly, inviteCircle: $inviteCircle, childIds: $childIds, participants: $participants, reminderRules: $reminderRules)';
}


}

/// @nodoc
abstract mixin class _$CalendarEventRecordCopyWith<$Res> implements $CalendarEventRecordCopyWith<$Res> {
  factory _$CalendarEventRecordCopyWith(_CalendarEventRecord value, $Res Function(_CalendarEventRecord) _then) = __$CalendarEventRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'type') String? type,@JsonKey(name: 'title') String? title,@JsonKey(name: 'notes') String? notes,@JsonKey(name: 'allDay') bool allDay,@JsonKey(name: 'startAt') DateTime? startAt,@JsonKey(name: 'localStartDate') String? localStartDate,@JsonKey(name: 'occurrenceDate') String? occurrenceDate,@JsonKey(name: 'isLunar') bool isLunar,@JsonKey(name: 'lunarMonth') int? lunarMonth,@JsonKey(name: 'lunarDay') int? lunarDay,@JsonKey(name: 'repeatYearly') bool repeatYearly,@JsonKey(name: 'inviteCircle') bool inviteCircle,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'participants') List<EventParticipantRecord> participants,@JsonKey(name: 'reminderRules') List<EventReminderRuleRecord> reminderRules
});




}
/// @nodoc
class __$CalendarEventRecordCopyWithImpl<$Res>
    implements _$CalendarEventRecordCopyWith<$Res> {
  __$CalendarEventRecordCopyWithImpl(this._self, this._then);

  final _CalendarEventRecord _self;
  final $Res Function(_CalendarEventRecord) _then;

/// Create a copy of CalendarEventRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? type = freezed,Object? title = freezed,Object? notes = freezed,Object? allDay = null,Object? startAt = freezed,Object? localStartDate = freezed,Object? occurrenceDate = freezed,Object? isLunar = null,Object? lunarMonth = freezed,Object? lunarDay = freezed,Object? repeatYearly = null,Object? inviteCircle = null,Object? childIds = null,Object? participants = null,Object? reminderRules = null,}) {
  return _then(_CalendarEventRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,allDay: null == allDay ? _self.allDay : allDay // ignore: cast_nullable_to_non_nullable
as bool,startAt: freezed == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime?,localStartDate: freezed == localStartDate ? _self.localStartDate : localStartDate // ignore: cast_nullable_to_non_nullable
as String?,occurrenceDate: freezed == occurrenceDate ? _self.occurrenceDate : occurrenceDate // ignore: cast_nullable_to_non_nullable
as String?,isLunar: null == isLunar ? _self.isLunar : isLunar // ignore: cast_nullable_to_non_nullable
as bool,lunarMonth: freezed == lunarMonth ? _self.lunarMonth : lunarMonth // ignore: cast_nullable_to_non_nullable
as int?,lunarDay: freezed == lunarDay ? _self.lunarDay : lunarDay // ignore: cast_nullable_to_non_nullable
as int?,repeatYearly: null == repeatYearly ? _self.repeatYearly : repeatYearly // ignore: cast_nullable_to_non_nullable
as bool,inviteCircle: null == inviteCircle ? _self.inviteCircle : inviteCircle // ignore: cast_nullable_to_non_nullable
as bool,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<EventParticipantRecord>,reminderRules: null == reminderRules ? _self._reminderRules : reminderRules // ignore: cast_nullable_to_non_nullable
as List<EventReminderRuleRecord>,
  ));
}


}

// dart format on
