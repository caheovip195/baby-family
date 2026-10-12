// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Mission {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'title') String get title;@JsonKey(name: 'category') MissionCategory get category;@JsonKey(name: 'hearts') int? get hearts;@JsonKey(name: 'ownerKind') MissionOwnerKind get ownerKind;@JsonKey(name: 'source') MissionSource get source;@JsonKey(name: 'templateId') String? get templateId;@JsonKey(name: 'childIds') List<String> get childIds;@JsonKey(name: 'date') DateTime get date;@JsonKey(name: 'dueTime') String? get dueTime;@JsonKey(name: 'durationMin') int? get durationMin;@JsonKey(name: 'icon') String? get icon;@JsonKey(name: 'status') MissionStatus get status;@JsonKey(name: 'repeat') MissionRepeat get repeat;@JsonKey(name: 'reminder') MissionReminder get reminder;@JsonKey(name: 'late') bool get late;@JsonKey(name: 'completedAt') DateTime? get completedAt;@JsonKey(name: 'thankedByPartner') bool get thankedByPartner;@JsonKey(name: 'note') String? get note;
/// Create a copy of Mission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionCopyWith<Mission> get copyWith => _$MissionCopyWithImpl<Mission>(this as Mission, _$identity);

  /// Serializes this Mission to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Mission&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.ownerKind, ownerKind) || other.ownerKind == ownerKind)&&(identical(other.source, source) || other.source == source)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&const DeepCollectionEquality().equals(other.childIds, childIds)&&(identical(other.date, date) || other.date == date)&&(identical(other.dueTime, dueTime) || other.dueTime == dueTime)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.status, status) || other.status == status)&&(identical(other.repeat, repeat) || other.repeat == repeat)&&(identical(other.reminder, reminder) || other.reminder == reminder)&&(identical(other.late, late) || other.late == late)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.thankedByPartner, thankedByPartner) || other.thankedByPartner == thankedByPartner)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,category,hearts,ownerKind,source,templateId,const DeepCollectionEquality().hash(childIds),date,dueTime,durationMin,icon,status,repeat,reminder,late,completedAt,thankedByPartner,note]);

@override
String toString() {
  return 'Mission(id: $id, title: $title, category: $category, hearts: $hearts, ownerKind: $ownerKind, source: $source, templateId: $templateId, childIds: $childIds, date: $date, dueTime: $dueTime, durationMin: $durationMin, icon: $icon, status: $status, repeat: $repeat, reminder: $reminder, late: $late, completedAt: $completedAt, thankedByPartner: $thankedByPartner, note: $note)';
}


}

/// @nodoc
abstract mixin class $MissionCopyWith<$Res>  {
  factory $MissionCopyWith(Mission value, $Res Function(Mission) _then) = _$MissionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'title') String title,@JsonKey(name: 'category') MissionCategory category,@JsonKey(name: 'hearts') int? hearts,@JsonKey(name: 'ownerKind') MissionOwnerKind ownerKind,@JsonKey(name: 'source') MissionSource source,@JsonKey(name: 'templateId') String? templateId,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'date') DateTime date,@JsonKey(name: 'dueTime') String? dueTime,@JsonKey(name: 'durationMin') int? durationMin,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'status') MissionStatus status,@JsonKey(name: 'repeat') MissionRepeat repeat,@JsonKey(name: 'reminder') MissionReminder reminder,@JsonKey(name: 'late') bool late,@JsonKey(name: 'completedAt') DateTime? completedAt,@JsonKey(name: 'thankedByPartner') bool thankedByPartner,@JsonKey(name: 'note') String? note
});




}
/// @nodoc
class _$MissionCopyWithImpl<$Res>
    implements $MissionCopyWith<$Res> {
  _$MissionCopyWithImpl(this._self, this._then);

  final Mission _self;
  final $Res Function(Mission) _then;

/// Create a copy of Mission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? category = null,Object? hearts = freezed,Object? ownerKind = null,Object? source = null,Object? templateId = freezed,Object? childIds = null,Object? date = null,Object? dueTime = freezed,Object? durationMin = freezed,Object? icon = freezed,Object? status = null,Object? repeat = null,Object? reminder = null,Object? late = null,Object? completedAt = freezed,Object? thankedByPartner = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MissionCategory,hearts: freezed == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int?,ownerKind: null == ownerKind ? _self.ownerKind : ownerKind // ignore: cast_nullable_to_non_nullable
as MissionOwnerKind,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as MissionSource,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,dueTime: freezed == dueTime ? _self.dueTime : dueTime // ignore: cast_nullable_to_non_nullable
as String?,durationMin: freezed == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MissionStatus,repeat: null == repeat ? _self.repeat : repeat // ignore: cast_nullable_to_non_nullable
as MissionRepeat,reminder: null == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as MissionReminder,late: null == late ? _self.late : late // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,thankedByPartner: null == thankedByPartner ? _self.thankedByPartner : thankedByPartner // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Mission].
extension MissionPatterns on Mission {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Mission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Mission() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Mission value)  $default,){
final _that = this;
switch (_that) {
case _Mission():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Mission value)?  $default,){
final _that = this;
switch (_that) {
case _Mission() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Mission extends Mission {
  const _Mission({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'category') this.category = MissionCategory.care, @JsonKey(name: 'hearts') this.hearts, @JsonKey(name: 'ownerKind') this.ownerKind = MissionOwnerKind.me, @JsonKey(name: 'source') this.source = MissionSource.system, @JsonKey(name: 'templateId') this.templateId, @JsonKey(name: 'childIds') final  List<String> childIds = const [], @JsonKey(name: 'date') required this.date, @JsonKey(name: 'dueTime') this.dueTime, @JsonKey(name: 'durationMin') this.durationMin, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'status') this.status = MissionStatus.todo, @JsonKey(name: 'repeat') this.repeat = MissionRepeat.none, @JsonKey(name: 'reminder') this.reminder = MissionReminder.none, @JsonKey(name: 'late') this.late = false, @JsonKey(name: 'completedAt') this.completedAt, @JsonKey(name: 'thankedByPartner') this.thankedByPartner = false, @JsonKey(name: 'note') this.note}): _childIds = childIds,super._();
  factory _Mission.fromJson(Map<String, dynamic> json) => _$MissionFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'category') final  MissionCategory category;
@override@JsonKey(name: 'hearts') final  int? hearts;
@override@JsonKey(name: 'ownerKind') final  MissionOwnerKind ownerKind;
@override@JsonKey(name: 'source') final  MissionSource source;
@override@JsonKey(name: 'templateId') final  String? templateId;
 final  List<String> _childIds;
@override@JsonKey(name: 'childIds') List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}

@override@JsonKey(name: 'date') final  DateTime date;
@override@JsonKey(name: 'dueTime') final  String? dueTime;
@override@JsonKey(name: 'durationMin') final  int? durationMin;
@override@JsonKey(name: 'icon') final  String? icon;
@override@JsonKey(name: 'status') final  MissionStatus status;
@override@JsonKey(name: 'repeat') final  MissionRepeat repeat;
@override@JsonKey(name: 'reminder') final  MissionReminder reminder;
@override@JsonKey(name: 'late') final  bool late;
@override@JsonKey(name: 'completedAt') final  DateTime? completedAt;
@override@JsonKey(name: 'thankedByPartner') final  bool thankedByPartner;
@override@JsonKey(name: 'note') final  String? note;

/// Create a copy of Mission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionCopyWith<_Mission> get copyWith => __$MissionCopyWithImpl<_Mission>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Mission&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.ownerKind, ownerKind) || other.ownerKind == ownerKind)&&(identical(other.source, source) || other.source == source)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&const DeepCollectionEquality().equals(other._childIds, _childIds)&&(identical(other.date, date) || other.date == date)&&(identical(other.dueTime, dueTime) || other.dueTime == dueTime)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.status, status) || other.status == status)&&(identical(other.repeat, repeat) || other.repeat == repeat)&&(identical(other.reminder, reminder) || other.reminder == reminder)&&(identical(other.late, late) || other.late == late)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.thankedByPartner, thankedByPartner) || other.thankedByPartner == thankedByPartner)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,category,hearts,ownerKind,source,templateId,const DeepCollectionEquality().hash(_childIds),date,dueTime,durationMin,icon,status,repeat,reminder,late,completedAt,thankedByPartner,note]);

@override
String toString() {
  return 'Mission(id: $id, title: $title, category: $category, hearts: $hearts, ownerKind: $ownerKind, source: $source, templateId: $templateId, childIds: $childIds, date: $date, dueTime: $dueTime, durationMin: $durationMin, icon: $icon, status: $status, repeat: $repeat, reminder: $reminder, late: $late, completedAt: $completedAt, thankedByPartner: $thankedByPartner, note: $note)';
}


}

/// @nodoc
abstract mixin class _$MissionCopyWith<$Res> implements $MissionCopyWith<$Res> {
  factory _$MissionCopyWith(_Mission value, $Res Function(_Mission) _then) = __$MissionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'title') String title,@JsonKey(name: 'category') MissionCategory category,@JsonKey(name: 'hearts') int? hearts,@JsonKey(name: 'ownerKind') MissionOwnerKind ownerKind,@JsonKey(name: 'source') MissionSource source,@JsonKey(name: 'templateId') String? templateId,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'date') DateTime date,@JsonKey(name: 'dueTime') String? dueTime,@JsonKey(name: 'durationMin') int? durationMin,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'status') MissionStatus status,@JsonKey(name: 'repeat') MissionRepeat repeat,@JsonKey(name: 'reminder') MissionReminder reminder,@JsonKey(name: 'late') bool late,@JsonKey(name: 'completedAt') DateTime? completedAt,@JsonKey(name: 'thankedByPartner') bool thankedByPartner,@JsonKey(name: 'note') String? note
});




}
/// @nodoc
class __$MissionCopyWithImpl<$Res>
    implements _$MissionCopyWith<$Res> {
  __$MissionCopyWithImpl(this._self, this._then);

  final _Mission _self;
  final $Res Function(_Mission) _then;

/// Create a copy of Mission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = null,Object? hearts = freezed,Object? ownerKind = null,Object? source = null,Object? templateId = freezed,Object? childIds = null,Object? date = null,Object? dueTime = freezed,Object? durationMin = freezed,Object? icon = freezed,Object? status = null,Object? repeat = null,Object? reminder = null,Object? late = null,Object? completedAt = freezed,Object? thankedByPartner = null,Object? note = freezed,}) {
  return _then(_Mission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MissionCategory,hearts: freezed == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int?,ownerKind: null == ownerKind ? _self.ownerKind : ownerKind // ignore: cast_nullable_to_non_nullable
as MissionOwnerKind,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as MissionSource,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,dueTime: freezed == dueTime ? _self.dueTime : dueTime // ignore: cast_nullable_to_non_nullable
as String?,durationMin: freezed == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MissionStatus,repeat: null == repeat ? _self.repeat : repeat // ignore: cast_nullable_to_non_nullable
as MissionRepeat,reminder: null == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as MissionReminder,late: null == late ? _self.late : late // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,thankedByPartner: null == thankedByPartner ? _self.thankedByPartner : thankedByPartner // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
