// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_series_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionSeriesRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'ownerKind') String? get ownerKind;@JsonKey(name: 'mine') bool get mine;@JsonKey(name: 'scheduledTime') String? get scheduledTime;@JsonKey(name: 'startDate') String? get startDate;@JsonKey(name: 'endDate') String? get endDate;@JsonKey(name: 'days') List<String> get days;@JsonKey(name: 'pausedRanges') List<Map<String, dynamic>> get pausedRanges;@JsonKey(name: 'status') String? get status;
/// Create a copy of MissionSeriesRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionSeriesRecordCopyWith<MissionSeriesRecord> get copyWith => _$MissionSeriesRecordCopyWithImpl<MissionSeriesRecord>(this as MissionSeriesRecord, _$identity);

  /// Serializes this MissionSeriesRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionSeriesRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.ownerKind, ownerKind) || other.ownerKind == ownerKind)&&(identical(other.mine, mine) || other.mine == mine)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other.days, days)&&const DeepCollectionEquality().equals(other.pausedRanges, pausedRanges)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,ownerKind,mine,scheduledTime,startDate,endDate,const DeepCollectionEquality().hash(days),const DeepCollectionEquality().hash(pausedRanges),status);

@override
String toString() {
  return 'MissionSeriesRecord(id: $id, title: $title, ownerKind: $ownerKind, mine: $mine, scheduledTime: $scheduledTime, startDate: $startDate, endDate: $endDate, days: $days, pausedRanges: $pausedRanges, status: $status)';
}


}

/// @nodoc
abstract mixin class $MissionSeriesRecordCopyWith<$Res>  {
  factory $MissionSeriesRecordCopyWith(MissionSeriesRecord value, $Res Function(MissionSeriesRecord) _then) = _$MissionSeriesRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'title') String? title,@JsonKey(name: 'ownerKind') String? ownerKind,@JsonKey(name: 'mine') bool mine,@JsonKey(name: 'scheduledTime') String? scheduledTime,@JsonKey(name: 'startDate') String? startDate,@JsonKey(name: 'endDate') String? endDate,@JsonKey(name: 'days') List<String> days,@JsonKey(name: 'pausedRanges') List<Map<String, dynamic>> pausedRanges,@JsonKey(name: 'status') String? status
});




}
/// @nodoc
class _$MissionSeriesRecordCopyWithImpl<$Res>
    implements $MissionSeriesRecordCopyWith<$Res> {
  _$MissionSeriesRecordCopyWithImpl(this._self, this._then);

  final MissionSeriesRecord _self;
  final $Res Function(MissionSeriesRecord) _then;

/// Create a copy of MissionSeriesRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = freezed,Object? ownerKind = freezed,Object? mine = null,Object? scheduledTime = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? days = null,Object? pausedRanges = null,Object? status = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,ownerKind: freezed == ownerKind ? _self.ownerKind : ownerKind // ignore: cast_nullable_to_non_nullable
as String?,mine: null == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as bool,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<String>,pausedRanges: null == pausedRanges ? _self.pausedRanges : pausedRanges // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionSeriesRecord].
extension MissionSeriesRecordPatterns on MissionSeriesRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionSeriesRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionSeriesRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionSeriesRecord value)  $default,){
final _that = this;
switch (_that) {
case _MissionSeriesRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionSeriesRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MissionSeriesRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MissionSeriesRecord implements MissionSeriesRecord {
  const _MissionSeriesRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'title') this.title, @JsonKey(name: 'ownerKind') this.ownerKind, @JsonKey(name: 'mine') this.mine = false, @JsonKey(name: 'scheduledTime') this.scheduledTime, @JsonKey(name: 'startDate') this.startDate, @JsonKey(name: 'endDate') this.endDate, @JsonKey(name: 'days') final  List<String> days = const <String>[], @JsonKey(name: 'pausedRanges') final  List<Map<String, dynamic>> pausedRanges = const <Map<String, dynamic>>[], @JsonKey(name: 'status') this.status}): _days = days,_pausedRanges = pausedRanges;
  factory _MissionSeriesRecord.fromJson(Map<String, dynamic> json) => _$MissionSeriesRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'ownerKind') final  String? ownerKind;
@override@JsonKey(name: 'mine') final  bool mine;
@override@JsonKey(name: 'scheduledTime') final  String? scheduledTime;
@override@JsonKey(name: 'startDate') final  String? startDate;
@override@JsonKey(name: 'endDate') final  String? endDate;
 final  List<String> _days;
@override@JsonKey(name: 'days') List<String> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

 final  List<Map<String, dynamic>> _pausedRanges;
@override@JsonKey(name: 'pausedRanges') List<Map<String, dynamic>> get pausedRanges {
  if (_pausedRanges is EqualUnmodifiableListView) return _pausedRanges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pausedRanges);
}

@override@JsonKey(name: 'status') final  String? status;

/// Create a copy of MissionSeriesRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionSeriesRecordCopyWith<_MissionSeriesRecord> get copyWith => __$MissionSeriesRecordCopyWithImpl<_MissionSeriesRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionSeriesRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionSeriesRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.ownerKind, ownerKind) || other.ownerKind == ownerKind)&&(identical(other.mine, mine) || other.mine == mine)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other._days, _days)&&const DeepCollectionEquality().equals(other._pausedRanges, _pausedRanges)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,ownerKind,mine,scheduledTime,startDate,endDate,const DeepCollectionEquality().hash(_days),const DeepCollectionEquality().hash(_pausedRanges),status);

@override
String toString() {
  return 'MissionSeriesRecord(id: $id, title: $title, ownerKind: $ownerKind, mine: $mine, scheduledTime: $scheduledTime, startDate: $startDate, endDate: $endDate, days: $days, pausedRanges: $pausedRanges, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MissionSeriesRecordCopyWith<$Res> implements $MissionSeriesRecordCopyWith<$Res> {
  factory _$MissionSeriesRecordCopyWith(_MissionSeriesRecord value, $Res Function(_MissionSeriesRecord) _then) = __$MissionSeriesRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'title') String? title,@JsonKey(name: 'ownerKind') String? ownerKind,@JsonKey(name: 'mine') bool mine,@JsonKey(name: 'scheduledTime') String? scheduledTime,@JsonKey(name: 'startDate') String? startDate,@JsonKey(name: 'endDate') String? endDate,@JsonKey(name: 'days') List<String> days,@JsonKey(name: 'pausedRanges') List<Map<String, dynamic>> pausedRanges,@JsonKey(name: 'status') String? status
});




}
/// @nodoc
class __$MissionSeriesRecordCopyWithImpl<$Res>
    implements _$MissionSeriesRecordCopyWith<$Res> {
  __$MissionSeriesRecordCopyWithImpl(this._self, this._then);

  final _MissionSeriesRecord _self;
  final $Res Function(_MissionSeriesRecord) _then;

/// Create a copy of MissionSeriesRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = freezed,Object? ownerKind = freezed,Object? mine = null,Object? scheduledTime = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? days = null,Object? pausedRanges = null,Object? status = freezed,}) {
  return _then(_MissionSeriesRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,ownerKind: freezed == ownerKind ? _self.ownerKind : ownerKind // ignore: cast_nullable_to_non_nullable
as String?,mine: null == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as bool,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<String>,pausedRanges: null == pausedRanges ? _self._pausedRanges : pausedRanges // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
