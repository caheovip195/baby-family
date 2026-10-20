// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeline_item_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimelineItemRecord {

@JsonKey(name: 'type') String? get type;@JsonKey(name: 'memory') MemoryRecord? get memory;@JsonKey(name: 'id') String? get id;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'childId') String? get childId;@JsonKey(name: 'monthIndex') int? get monthIndex;@JsonKey(name: 'date') String? get date;/// Thẻ `CHAPTER` (BF-20261019-008): ảnh tháng làm bìa + số liệu tháng.
@JsonKey(name: 'coverUrl') String? get coverUrl;@JsonKey(name: 'memoryCount') int? get memoryCount;@JsonKey(name: 'firstsCount') int? get firstsCount;
/// Create a copy of TimelineItemRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineItemRecordCopyWith<TimelineItemRecord> get copyWith => _$TimelineItemRecordCopyWithImpl<TimelineItemRecord>(this as TimelineItemRecord, _$identity);

  /// Serializes this TimelineItemRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineItemRecord&&(identical(other.type, type) || other.type == type)&&(identical(other.memory, memory) || other.memory == memory)&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.date, date) || other.date == date)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&(identical(other.firstsCount, firstsCount) || other.firstsCount == firstsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,memory,id,kind,childId,monthIndex,date,coverUrl,memoryCount,firstsCount);

@override
String toString() {
  return 'TimelineItemRecord(type: $type, memory: $memory, id: $id, kind: $kind, childId: $childId, monthIndex: $monthIndex, date: $date, coverUrl: $coverUrl, memoryCount: $memoryCount, firstsCount: $firstsCount)';
}


}

/// @nodoc
abstract mixin class $TimelineItemRecordCopyWith<$Res>  {
  factory $TimelineItemRecordCopyWith(TimelineItemRecord value, $Res Function(TimelineItemRecord) _then) = _$TimelineItemRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'memory') MemoryRecord? memory,@JsonKey(name: 'id') String? id,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'monthIndex') int? monthIndex,@JsonKey(name: 'date') String? date,@JsonKey(name: 'coverUrl') String? coverUrl,@JsonKey(name: 'memoryCount') int? memoryCount,@JsonKey(name: 'firstsCount') int? firstsCount
});


$MemoryRecordCopyWith<$Res>? get memory;

}
/// @nodoc
class _$TimelineItemRecordCopyWithImpl<$Res>
    implements $TimelineItemRecordCopyWith<$Res> {
  _$TimelineItemRecordCopyWithImpl(this._self, this._then);

  final TimelineItemRecord _self;
  final $Res Function(TimelineItemRecord) _then;

/// Create a copy of TimelineItemRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? memory = freezed,Object? id = freezed,Object? kind = freezed,Object? childId = freezed,Object? monthIndex = freezed,Object? date = freezed,Object? coverUrl = freezed,Object? memoryCount = freezed,Object? firstsCount = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,memory: freezed == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as MemoryRecord?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,monthIndex: freezed == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,memoryCount: freezed == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int?,firstsCount: freezed == firstsCount ? _self.firstsCount : firstsCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of TimelineItemRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemoryRecordCopyWith<$Res>? get memory {
    if (_self.memory == null) {
    return null;
  }

  return $MemoryRecordCopyWith<$Res>(_self.memory!, (value) {
    return _then(_self.copyWith(memory: value));
  });
}
}


/// Adds pattern-matching-related methods to [TimelineItemRecord].
extension TimelineItemRecordPatterns on TimelineItemRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimelineItemRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimelineItemRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimelineItemRecord value)  $default,){
final _that = this;
switch (_that) {
case _TimelineItemRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimelineItemRecord value)?  $default,){
final _that = this;
switch (_that) {
case _TimelineItemRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TimelineItemRecord implements TimelineItemRecord {
  const _TimelineItemRecord({@JsonKey(name: 'type') this.type, @JsonKey(name: 'memory') this.memory, @JsonKey(name: 'id') this.id, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'childId') this.childId, @JsonKey(name: 'monthIndex') this.monthIndex, @JsonKey(name: 'date') this.date, @JsonKey(name: 'coverUrl') this.coverUrl, @JsonKey(name: 'memoryCount') this.memoryCount, @JsonKey(name: 'firstsCount') this.firstsCount});
  factory _TimelineItemRecord.fromJson(Map<String, dynamic> json) => _$TimelineItemRecordFromJson(json);

@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'memory') final  MemoryRecord? memory;
@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'childId') final  String? childId;
@override@JsonKey(name: 'monthIndex') final  int? monthIndex;
@override@JsonKey(name: 'date') final  String? date;
/// Thẻ `CHAPTER` (BF-20261019-008): ảnh tháng làm bìa + số liệu tháng.
@override@JsonKey(name: 'coverUrl') final  String? coverUrl;
@override@JsonKey(name: 'memoryCount') final  int? memoryCount;
@override@JsonKey(name: 'firstsCount') final  int? firstsCount;

/// Create a copy of TimelineItemRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimelineItemRecordCopyWith<_TimelineItemRecord> get copyWith => __$TimelineItemRecordCopyWithImpl<_TimelineItemRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimelineItemRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimelineItemRecord&&(identical(other.type, type) || other.type == type)&&(identical(other.memory, memory) || other.memory == memory)&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.date, date) || other.date == date)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&(identical(other.firstsCount, firstsCount) || other.firstsCount == firstsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,memory,id,kind,childId,monthIndex,date,coverUrl,memoryCount,firstsCount);

@override
String toString() {
  return 'TimelineItemRecord(type: $type, memory: $memory, id: $id, kind: $kind, childId: $childId, monthIndex: $monthIndex, date: $date, coverUrl: $coverUrl, memoryCount: $memoryCount, firstsCount: $firstsCount)';
}


}

/// @nodoc
abstract mixin class _$TimelineItemRecordCopyWith<$Res> implements $TimelineItemRecordCopyWith<$Res> {
  factory _$TimelineItemRecordCopyWith(_TimelineItemRecord value, $Res Function(_TimelineItemRecord) _then) = __$TimelineItemRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'memory') MemoryRecord? memory,@JsonKey(name: 'id') String? id,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'monthIndex') int? monthIndex,@JsonKey(name: 'date') String? date,@JsonKey(name: 'coverUrl') String? coverUrl,@JsonKey(name: 'memoryCount') int? memoryCount,@JsonKey(name: 'firstsCount') int? firstsCount
});


@override $MemoryRecordCopyWith<$Res>? get memory;

}
/// @nodoc
class __$TimelineItemRecordCopyWithImpl<$Res>
    implements _$TimelineItemRecordCopyWith<$Res> {
  __$TimelineItemRecordCopyWithImpl(this._self, this._then);

  final _TimelineItemRecord _self;
  final $Res Function(_TimelineItemRecord) _then;

/// Create a copy of TimelineItemRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? memory = freezed,Object? id = freezed,Object? kind = freezed,Object? childId = freezed,Object? monthIndex = freezed,Object? date = freezed,Object? coverUrl = freezed,Object? memoryCount = freezed,Object? firstsCount = freezed,}) {
  return _then(_TimelineItemRecord(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,memory: freezed == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as MemoryRecord?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,monthIndex: freezed == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,memoryCount: freezed == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int?,firstsCount: freezed == firstsCount ? _self.firstsCount : firstsCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of TimelineItemRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemoryRecordCopyWith<$Res>? get memory {
    if (_self.memory == null) {
    return null;
  }

  return $MemoryRecordCopyWith<$Res>(_self.memory!, (value) {
    return _then(_self.copyWith(memory: value));
  });
}
}

// dart format on
