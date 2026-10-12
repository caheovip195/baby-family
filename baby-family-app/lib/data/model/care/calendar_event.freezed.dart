// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarEvent {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'title') String get title;@JsonKey(name: 'kind') CalendarEventKind get kind;@JsonKey(name: 'date') DateTime get date;@JsonKey(name: 'time') String? get time;@JsonKey(name: 'allDay') bool get allDay;@JsonKey(name: 'icon') String? get icon;@JsonKey(name: 'childIds') List<String> get childIds;@JsonKey(name: 'participantUserIds') List<String> get participantUserIds;@JsonKey(name: 'lunar') bool get lunar;@JsonKey(name: 'lunarDay') int? get lunarDay;@JsonKey(name: 'lunarMonth') int? get lunarMonth;@JsonKey(name: 'repeatYearly') bool get repeatYearly;@JsonKey(name: 'inviteFamily') bool get inviteFamily;@JsonKey(name: 'reminders') List<String> get reminders;@JsonKey(name: 'ownerKind') MissionOwnerKind? get ownerKind;@JsonKey(name: 'missionId') String? get missionId;/// Ghi chú tự do của sự kiện (CAL-02 “Ghi chú”).
@JsonKey(name: 'note') String? get note;
/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarEventCopyWith<CalendarEvent> get copyWith => _$CalendarEventCopyWithImpl<CalendarEvent>(this as CalendarEvent, _$identity);

  /// Serializes this CalendarEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.allDay, allDay) || other.allDay == allDay)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other.childIds, childIds)&&const DeepCollectionEquality().equals(other.participantUserIds, participantUserIds)&&(identical(other.lunar, lunar) || other.lunar == lunar)&&(identical(other.lunarDay, lunarDay) || other.lunarDay == lunarDay)&&(identical(other.lunarMonth, lunarMonth) || other.lunarMonth == lunarMonth)&&(identical(other.repeatYearly, repeatYearly) || other.repeatYearly == repeatYearly)&&(identical(other.inviteFamily, inviteFamily) || other.inviteFamily == inviteFamily)&&const DeepCollectionEquality().equals(other.reminders, reminders)&&(identical(other.ownerKind, ownerKind) || other.ownerKind == ownerKind)&&(identical(other.missionId, missionId) || other.missionId == missionId)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,kind,date,time,allDay,icon,const DeepCollectionEquality().hash(childIds),const DeepCollectionEquality().hash(participantUserIds),lunar,lunarDay,lunarMonth,repeatYearly,inviteFamily,const DeepCollectionEquality().hash(reminders),ownerKind,missionId,note);

@override
String toString() {
  return 'CalendarEvent(id: $id, title: $title, kind: $kind, date: $date, time: $time, allDay: $allDay, icon: $icon, childIds: $childIds, participantUserIds: $participantUserIds, lunar: $lunar, lunarDay: $lunarDay, lunarMonth: $lunarMonth, repeatYearly: $repeatYearly, inviteFamily: $inviteFamily, reminders: $reminders, ownerKind: $ownerKind, missionId: $missionId, note: $note)';
}


}

/// @nodoc
abstract mixin class $CalendarEventCopyWith<$Res>  {
  factory $CalendarEventCopyWith(CalendarEvent value, $Res Function(CalendarEvent) _then) = _$CalendarEventCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'title') String title,@JsonKey(name: 'kind') CalendarEventKind kind,@JsonKey(name: 'date') DateTime date,@JsonKey(name: 'time') String? time,@JsonKey(name: 'allDay') bool allDay,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'participantUserIds') List<String> participantUserIds,@JsonKey(name: 'lunar') bool lunar,@JsonKey(name: 'lunarDay') int? lunarDay,@JsonKey(name: 'lunarMonth') int? lunarMonth,@JsonKey(name: 'repeatYearly') bool repeatYearly,@JsonKey(name: 'inviteFamily') bool inviteFamily,@JsonKey(name: 'reminders') List<String> reminders,@JsonKey(name: 'ownerKind') MissionOwnerKind? ownerKind,@JsonKey(name: 'missionId') String? missionId,@JsonKey(name: 'note') String? note
});




}
/// @nodoc
class _$CalendarEventCopyWithImpl<$Res>
    implements $CalendarEventCopyWith<$Res> {
  _$CalendarEventCopyWithImpl(this._self, this._then);

  final CalendarEvent _self;
  final $Res Function(CalendarEvent) _then;

/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? kind = null,Object? date = null,Object? time = freezed,Object? allDay = null,Object? icon = freezed,Object? childIds = null,Object? participantUserIds = null,Object? lunar = null,Object? lunarDay = freezed,Object? lunarMonth = freezed,Object? repeatYearly = null,Object? inviteFamily = null,Object? reminders = null,Object? ownerKind = freezed,Object? missionId = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CalendarEventKind,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,allDay: null == allDay ? _self.allDay : allDay // ignore: cast_nullable_to_non_nullable
as bool,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,participantUserIds: null == participantUserIds ? _self.participantUserIds : participantUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,lunar: null == lunar ? _self.lunar : lunar // ignore: cast_nullable_to_non_nullable
as bool,lunarDay: freezed == lunarDay ? _self.lunarDay : lunarDay // ignore: cast_nullable_to_non_nullable
as int?,lunarMonth: freezed == lunarMonth ? _self.lunarMonth : lunarMonth // ignore: cast_nullable_to_non_nullable
as int?,repeatYearly: null == repeatYearly ? _self.repeatYearly : repeatYearly // ignore: cast_nullable_to_non_nullable
as bool,inviteFamily: null == inviteFamily ? _self.inviteFamily : inviteFamily // ignore: cast_nullable_to_non_nullable
as bool,reminders: null == reminders ? _self.reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<String>,ownerKind: freezed == ownerKind ? _self.ownerKind : ownerKind // ignore: cast_nullable_to_non_nullable
as MissionOwnerKind?,missionId: freezed == missionId ? _self.missionId : missionId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarEvent].
extension CalendarEventPatterns on CalendarEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarEvent value)  $default,){
final _that = this;
switch (_that) {
case _CalendarEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarEvent value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CalendarEvent implements CalendarEvent {
  const _CalendarEvent({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'kind') this.kind = CalendarEventKind.family, @JsonKey(name: 'date') required this.date, @JsonKey(name: 'time') this.time, @JsonKey(name: 'allDay') this.allDay = false, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'childIds') final  List<String> childIds = const [], @JsonKey(name: 'participantUserIds') final  List<String> participantUserIds = const [], @JsonKey(name: 'lunar') this.lunar = false, @JsonKey(name: 'lunarDay') this.lunarDay, @JsonKey(name: 'lunarMonth') this.lunarMonth, @JsonKey(name: 'repeatYearly') this.repeatYearly = false, @JsonKey(name: 'inviteFamily') this.inviteFamily = false, @JsonKey(name: 'reminders') final  List<String> reminders = const [], @JsonKey(name: 'ownerKind') this.ownerKind, @JsonKey(name: 'missionId') this.missionId, @JsonKey(name: 'note') this.note}): _childIds = childIds,_participantUserIds = participantUserIds,_reminders = reminders;
  factory _CalendarEvent.fromJson(Map<String, dynamic> json) => _$CalendarEventFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'kind') final  CalendarEventKind kind;
@override@JsonKey(name: 'date') final  DateTime date;
@override@JsonKey(name: 'time') final  String? time;
@override@JsonKey(name: 'allDay') final  bool allDay;
@override@JsonKey(name: 'icon') final  String? icon;
 final  List<String> _childIds;
@override@JsonKey(name: 'childIds') List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}

 final  List<String> _participantUserIds;
@override@JsonKey(name: 'participantUserIds') List<String> get participantUserIds {
  if (_participantUserIds is EqualUnmodifiableListView) return _participantUserIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participantUserIds);
}

@override@JsonKey(name: 'lunar') final  bool lunar;
@override@JsonKey(name: 'lunarDay') final  int? lunarDay;
@override@JsonKey(name: 'lunarMonth') final  int? lunarMonth;
@override@JsonKey(name: 'repeatYearly') final  bool repeatYearly;
@override@JsonKey(name: 'inviteFamily') final  bool inviteFamily;
 final  List<String> _reminders;
@override@JsonKey(name: 'reminders') List<String> get reminders {
  if (_reminders is EqualUnmodifiableListView) return _reminders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminders);
}

@override@JsonKey(name: 'ownerKind') final  MissionOwnerKind? ownerKind;
@override@JsonKey(name: 'missionId') final  String? missionId;
/// Ghi chú tự do của sự kiện (CAL-02 “Ghi chú”).
@override@JsonKey(name: 'note') final  String? note;

/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarEventCopyWith<_CalendarEvent> get copyWith => __$CalendarEventCopyWithImpl<_CalendarEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.allDay, allDay) || other.allDay == allDay)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other._childIds, _childIds)&&const DeepCollectionEquality().equals(other._participantUserIds, _participantUserIds)&&(identical(other.lunar, lunar) || other.lunar == lunar)&&(identical(other.lunarDay, lunarDay) || other.lunarDay == lunarDay)&&(identical(other.lunarMonth, lunarMonth) || other.lunarMonth == lunarMonth)&&(identical(other.repeatYearly, repeatYearly) || other.repeatYearly == repeatYearly)&&(identical(other.inviteFamily, inviteFamily) || other.inviteFamily == inviteFamily)&&const DeepCollectionEquality().equals(other._reminders, _reminders)&&(identical(other.ownerKind, ownerKind) || other.ownerKind == ownerKind)&&(identical(other.missionId, missionId) || other.missionId == missionId)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,kind,date,time,allDay,icon,const DeepCollectionEquality().hash(_childIds),const DeepCollectionEquality().hash(_participantUserIds),lunar,lunarDay,lunarMonth,repeatYearly,inviteFamily,const DeepCollectionEquality().hash(_reminders),ownerKind,missionId,note);

@override
String toString() {
  return 'CalendarEvent(id: $id, title: $title, kind: $kind, date: $date, time: $time, allDay: $allDay, icon: $icon, childIds: $childIds, participantUserIds: $participantUserIds, lunar: $lunar, lunarDay: $lunarDay, lunarMonth: $lunarMonth, repeatYearly: $repeatYearly, inviteFamily: $inviteFamily, reminders: $reminders, ownerKind: $ownerKind, missionId: $missionId, note: $note)';
}


}

/// @nodoc
abstract mixin class _$CalendarEventCopyWith<$Res> implements $CalendarEventCopyWith<$Res> {
  factory _$CalendarEventCopyWith(_CalendarEvent value, $Res Function(_CalendarEvent) _then) = __$CalendarEventCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'title') String title,@JsonKey(name: 'kind') CalendarEventKind kind,@JsonKey(name: 'date') DateTime date,@JsonKey(name: 'time') String? time,@JsonKey(name: 'allDay') bool allDay,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'participantUserIds') List<String> participantUserIds,@JsonKey(name: 'lunar') bool lunar,@JsonKey(name: 'lunarDay') int? lunarDay,@JsonKey(name: 'lunarMonth') int? lunarMonth,@JsonKey(name: 'repeatYearly') bool repeatYearly,@JsonKey(name: 'inviteFamily') bool inviteFamily,@JsonKey(name: 'reminders') List<String> reminders,@JsonKey(name: 'ownerKind') MissionOwnerKind? ownerKind,@JsonKey(name: 'missionId') String? missionId,@JsonKey(name: 'note') String? note
});




}
/// @nodoc
class __$CalendarEventCopyWithImpl<$Res>
    implements _$CalendarEventCopyWith<$Res> {
  __$CalendarEventCopyWithImpl(this._self, this._then);

  final _CalendarEvent _self;
  final $Res Function(_CalendarEvent) _then;

/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? kind = null,Object? date = null,Object? time = freezed,Object? allDay = null,Object? icon = freezed,Object? childIds = null,Object? participantUserIds = null,Object? lunar = null,Object? lunarDay = freezed,Object? lunarMonth = freezed,Object? repeatYearly = null,Object? inviteFamily = null,Object? reminders = null,Object? ownerKind = freezed,Object? missionId = freezed,Object? note = freezed,}) {
  return _then(_CalendarEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CalendarEventKind,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,allDay: null == allDay ? _self.allDay : allDay // ignore: cast_nullable_to_non_nullable
as bool,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,participantUserIds: null == participantUserIds ? _self._participantUserIds : participantUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,lunar: null == lunar ? _self.lunar : lunar // ignore: cast_nullable_to_non_nullable
as bool,lunarDay: freezed == lunarDay ? _self.lunarDay : lunarDay // ignore: cast_nullable_to_non_nullable
as int?,lunarMonth: freezed == lunarMonth ? _self.lunarMonth : lunarMonth // ignore: cast_nullable_to_non_nullable
as int?,repeatYearly: null == repeatYearly ? _self.repeatYearly : repeatYearly // ignore: cast_nullable_to_non_nullable
as bool,inviteFamily: null == inviteFamily ? _self.inviteFamily : inviteFamily // ignore: cast_nullable_to_non_nullable
as bool,reminders: null == reminders ? _self._reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<String>,ownerKind: freezed == ownerKind ? _self.ownerKind : ownerKind // ignore: cast_nullable_to_non_nullable
as MissionOwnerKind?,missionId: freezed == missionId ? _self.missionId : missionId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
