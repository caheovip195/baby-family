// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'boardDate') String? get boardDate;@JsonKey(name: 'ownerKind') String? get ownerKind;@JsonKey(name: 'mine') bool? get mine;@JsonKey(name: 'source') String? get source;@JsonKey(name: 'templateId') String? get templateId;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'note') String? get note;@JsonKey(name: 'category') String? get category;@JsonKey(name: 'childIds') List<String> get childIds;@JsonKey(name: 'hearts') int? get hearts;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'scheduledTime') String? get scheduledTime;@JsonKey(name: 'completedAt') DateTime? get completedAt;@JsonKey(name: 'late') bool get late;@JsonKey(name: 'thanked') bool get thanked;@JsonKey(name: 'canSwap') bool get canSwap;@JsonKey(name: 'version') int? get version;
/// Create a copy of MissionRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionRecordCopyWith<MissionRecord> get copyWith => _$MissionRecordCopyWithImpl<MissionRecord>(this as MissionRecord, _$identity);

  /// Serializes this MissionRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.boardDate, boardDate) || other.boardDate == boardDate)&&(identical(other.ownerKind, ownerKind) || other.ownerKind == ownerKind)&&(identical(other.mine, mine) || other.mine == mine)&&(identical(other.source, source) || other.source == source)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.childIds, childIds)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.late, late) || other.late == late)&&(identical(other.thanked, thanked) || other.thanked == thanked)&&(identical(other.canSwap, canSwap) || other.canSwap == canSwap)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,boardDate,ownerKind,mine,source,templateId,title,note,category,const DeepCollectionEquality().hash(childIds),hearts,status,scheduledTime,completedAt,late,thanked,canSwap,version);

@override
String toString() {
  return 'MissionRecord(id: $id, boardDate: $boardDate, ownerKind: $ownerKind, mine: $mine, source: $source, templateId: $templateId, title: $title, note: $note, category: $category, childIds: $childIds, hearts: $hearts, status: $status, scheduledTime: $scheduledTime, completedAt: $completedAt, late: $late, thanked: $thanked, canSwap: $canSwap, version: $version)';
}


}

/// @nodoc
abstract mixin class $MissionRecordCopyWith<$Res>  {
  factory $MissionRecordCopyWith(MissionRecord value, $Res Function(MissionRecord) _then) = _$MissionRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'boardDate') String? boardDate,@JsonKey(name: 'ownerKind') String? ownerKind,@JsonKey(name: 'mine') bool? mine,@JsonKey(name: 'source') String? source,@JsonKey(name: 'templateId') String? templateId,@JsonKey(name: 'title') String? title,@JsonKey(name: 'note') String? note,@JsonKey(name: 'category') String? category,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'hearts') int? hearts,@JsonKey(name: 'status') String? status,@JsonKey(name: 'scheduledTime') String? scheduledTime,@JsonKey(name: 'completedAt') DateTime? completedAt,@JsonKey(name: 'late') bool late,@JsonKey(name: 'thanked') bool thanked,@JsonKey(name: 'canSwap') bool canSwap,@JsonKey(name: 'version') int? version
});




}
/// @nodoc
class _$MissionRecordCopyWithImpl<$Res>
    implements $MissionRecordCopyWith<$Res> {
  _$MissionRecordCopyWithImpl(this._self, this._then);

  final MissionRecord _self;
  final $Res Function(MissionRecord) _then;

/// Create a copy of MissionRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? boardDate = freezed,Object? ownerKind = freezed,Object? mine = freezed,Object? source = freezed,Object? templateId = freezed,Object? title = freezed,Object? note = freezed,Object? category = freezed,Object? childIds = null,Object? hearts = freezed,Object? status = freezed,Object? scheduledTime = freezed,Object? completedAt = freezed,Object? late = null,Object? thanked = null,Object? canSwap = null,Object? version = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,boardDate: freezed == boardDate ? _self.boardDate : boardDate // ignore: cast_nullable_to_non_nullable
as String?,ownerKind: freezed == ownerKind ? _self.ownerKind : ownerKind // ignore: cast_nullable_to_non_nullable
as String?,mine: freezed == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as bool?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,hearts: freezed == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,late: null == late ? _self.late : late // ignore: cast_nullable_to_non_nullable
as bool,thanked: null == thanked ? _self.thanked : thanked // ignore: cast_nullable_to_non_nullable
as bool,canSwap: null == canSwap ? _self.canSwap : canSwap // ignore: cast_nullable_to_non_nullable
as bool,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionRecord].
extension MissionRecordPatterns on MissionRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionRecord value)  $default,){
final _that = this;
switch (_that) {
case _MissionRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MissionRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MissionRecord implements MissionRecord {
  const _MissionRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'boardDate') this.boardDate, @JsonKey(name: 'ownerKind') this.ownerKind, @JsonKey(name: 'mine') this.mine, @JsonKey(name: 'source') this.source, @JsonKey(name: 'templateId') this.templateId, @JsonKey(name: 'title') this.title, @JsonKey(name: 'note') this.note, @JsonKey(name: 'category') this.category, @JsonKey(name: 'childIds') final  List<String> childIds = const <String>[], @JsonKey(name: 'hearts') this.hearts, @JsonKey(name: 'status') this.status, @JsonKey(name: 'scheduledTime') this.scheduledTime, @JsonKey(name: 'completedAt') this.completedAt, @JsonKey(name: 'late') this.late = false, @JsonKey(name: 'thanked') this.thanked = false, @JsonKey(name: 'canSwap') this.canSwap = false, @JsonKey(name: 'version') this.version}): _childIds = childIds;
  factory _MissionRecord.fromJson(Map<String, dynamic> json) => _$MissionRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'boardDate') final  String? boardDate;
@override@JsonKey(name: 'ownerKind') final  String? ownerKind;
@override@JsonKey(name: 'mine') final  bool? mine;
@override@JsonKey(name: 'source') final  String? source;
@override@JsonKey(name: 'templateId') final  String? templateId;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'note') final  String? note;
@override@JsonKey(name: 'category') final  String? category;
 final  List<String> _childIds;
@override@JsonKey(name: 'childIds') List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}

@override@JsonKey(name: 'hearts') final  int? hearts;
@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'scheduledTime') final  String? scheduledTime;
@override@JsonKey(name: 'completedAt') final  DateTime? completedAt;
@override@JsonKey(name: 'late') final  bool late;
@override@JsonKey(name: 'thanked') final  bool thanked;
@override@JsonKey(name: 'canSwap') final  bool canSwap;
@override@JsonKey(name: 'version') final  int? version;

/// Create a copy of MissionRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionRecordCopyWith<_MissionRecord> get copyWith => __$MissionRecordCopyWithImpl<_MissionRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.boardDate, boardDate) || other.boardDate == boardDate)&&(identical(other.ownerKind, ownerKind) || other.ownerKind == ownerKind)&&(identical(other.mine, mine) || other.mine == mine)&&(identical(other.source, source) || other.source == source)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._childIds, _childIds)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.late, late) || other.late == late)&&(identical(other.thanked, thanked) || other.thanked == thanked)&&(identical(other.canSwap, canSwap) || other.canSwap == canSwap)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,boardDate,ownerKind,mine,source,templateId,title,note,category,const DeepCollectionEquality().hash(_childIds),hearts,status,scheduledTime,completedAt,late,thanked,canSwap,version);

@override
String toString() {
  return 'MissionRecord(id: $id, boardDate: $boardDate, ownerKind: $ownerKind, mine: $mine, source: $source, templateId: $templateId, title: $title, note: $note, category: $category, childIds: $childIds, hearts: $hearts, status: $status, scheduledTime: $scheduledTime, completedAt: $completedAt, late: $late, thanked: $thanked, canSwap: $canSwap, version: $version)';
}


}

/// @nodoc
abstract mixin class _$MissionRecordCopyWith<$Res> implements $MissionRecordCopyWith<$Res> {
  factory _$MissionRecordCopyWith(_MissionRecord value, $Res Function(_MissionRecord) _then) = __$MissionRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'boardDate') String? boardDate,@JsonKey(name: 'ownerKind') String? ownerKind,@JsonKey(name: 'mine') bool? mine,@JsonKey(name: 'source') String? source,@JsonKey(name: 'templateId') String? templateId,@JsonKey(name: 'title') String? title,@JsonKey(name: 'note') String? note,@JsonKey(name: 'category') String? category,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'hearts') int? hearts,@JsonKey(name: 'status') String? status,@JsonKey(name: 'scheduledTime') String? scheduledTime,@JsonKey(name: 'completedAt') DateTime? completedAt,@JsonKey(name: 'late') bool late,@JsonKey(name: 'thanked') bool thanked,@JsonKey(name: 'canSwap') bool canSwap,@JsonKey(name: 'version') int? version
});




}
/// @nodoc
class __$MissionRecordCopyWithImpl<$Res>
    implements _$MissionRecordCopyWith<$Res> {
  __$MissionRecordCopyWithImpl(this._self, this._then);

  final _MissionRecord _self;
  final $Res Function(_MissionRecord) _then;

/// Create a copy of MissionRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? boardDate = freezed,Object? ownerKind = freezed,Object? mine = freezed,Object? source = freezed,Object? templateId = freezed,Object? title = freezed,Object? note = freezed,Object? category = freezed,Object? childIds = null,Object? hearts = freezed,Object? status = freezed,Object? scheduledTime = freezed,Object? completedAt = freezed,Object? late = null,Object? thanked = null,Object? canSwap = null,Object? version = freezed,}) {
  return _then(_MissionRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,boardDate: freezed == boardDate ? _self.boardDate : boardDate // ignore: cast_nullable_to_non_nullable
as String?,ownerKind: freezed == ownerKind ? _self.ownerKind : ownerKind // ignore: cast_nullable_to_non_nullable
as String?,mine: freezed == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as bool?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,hearts: freezed == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,late: null == late ? _self.late : late // ignore: cast_nullable_to_non_nullable
as bool,thanked: null == thanked ? _self.thanked : thanked // ignore: cast_nullable_to_non_nullable
as bool,canSwap: null == canSwap ? _self.canSwap : canSwap // ignore: cast_nullable_to_non_nullable
as bool,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
