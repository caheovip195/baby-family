// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_story_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DayStoryRecord {

@JsonKey(name: 'childId') String? get childId;@JsonKey(name: 'date') String? get date;@JsonKey(name: 'memories', fromJson: _dayMemories) List<DayStoryMemoryRecord> get memories;@JsonKey(name: 'saved') SavedDayStoryRecord? get saved;
/// Create a copy of DayStoryRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayStoryRecordCopyWith<DayStoryRecord> get copyWith => _$DayStoryRecordCopyWithImpl<DayStoryRecord>(this as DayStoryRecord, _$identity);

  /// Serializes this DayStoryRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayStoryRecord&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.memories, memories)&&(identical(other.saved, saved) || other.saved == saved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,date,const DeepCollectionEquality().hash(memories),saved);

@override
String toString() {
  return 'DayStoryRecord(childId: $childId, date: $date, memories: $memories, saved: $saved)';
}


}

/// @nodoc
abstract mixin class $DayStoryRecordCopyWith<$Res>  {
  factory $DayStoryRecordCopyWith(DayStoryRecord value, $Res Function(DayStoryRecord) _then) = _$DayStoryRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'date') String? date,@JsonKey(name: 'memories', fromJson: _dayMemories) List<DayStoryMemoryRecord> memories,@JsonKey(name: 'saved') SavedDayStoryRecord? saved
});


$SavedDayStoryRecordCopyWith<$Res>? get saved;

}
/// @nodoc
class _$DayStoryRecordCopyWithImpl<$Res>
    implements $DayStoryRecordCopyWith<$Res> {
  _$DayStoryRecordCopyWithImpl(this._self, this._then);

  final DayStoryRecord _self;
  final $Res Function(DayStoryRecord) _then;

/// Create a copy of DayStoryRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childId = freezed,Object? date = freezed,Object? memories = null,Object? saved = freezed,}) {
  return _then(_self.copyWith(
childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,memories: null == memories ? _self.memories : memories // ignore: cast_nullable_to_non_nullable
as List<DayStoryMemoryRecord>,saved: freezed == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as SavedDayStoryRecord?,
  ));
}
/// Create a copy of DayStoryRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SavedDayStoryRecordCopyWith<$Res>? get saved {
    if (_self.saved == null) {
    return null;
  }

  return $SavedDayStoryRecordCopyWith<$Res>(_self.saved!, (value) {
    return _then(_self.copyWith(saved: value));
  });
}
}


/// Adds pattern-matching-related methods to [DayStoryRecord].
extension DayStoryRecordPatterns on DayStoryRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayStoryRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayStoryRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayStoryRecord value)  $default,){
final _that = this;
switch (_that) {
case _DayStoryRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayStoryRecord value)?  $default,){
final _that = this;
switch (_that) {
case _DayStoryRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DayStoryRecord implements DayStoryRecord {
  const _DayStoryRecord({@JsonKey(name: 'childId') this.childId, @JsonKey(name: 'date') this.date, @JsonKey(name: 'memories', fromJson: _dayMemories) final  List<DayStoryMemoryRecord> memories = const <DayStoryMemoryRecord>[], @JsonKey(name: 'saved') this.saved}): _memories = memories;
  factory _DayStoryRecord.fromJson(Map<String, dynamic> json) => _$DayStoryRecordFromJson(json);

@override@JsonKey(name: 'childId') final  String? childId;
@override@JsonKey(name: 'date') final  String? date;
 final  List<DayStoryMemoryRecord> _memories;
@override@JsonKey(name: 'memories', fromJson: _dayMemories) List<DayStoryMemoryRecord> get memories {
  if (_memories is EqualUnmodifiableListView) return _memories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memories);
}

@override@JsonKey(name: 'saved') final  SavedDayStoryRecord? saved;

/// Create a copy of DayStoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayStoryRecordCopyWith<_DayStoryRecord> get copyWith => __$DayStoryRecordCopyWithImpl<_DayStoryRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayStoryRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayStoryRecord&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._memories, _memories)&&(identical(other.saved, saved) || other.saved == saved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,date,const DeepCollectionEquality().hash(_memories),saved);

@override
String toString() {
  return 'DayStoryRecord(childId: $childId, date: $date, memories: $memories, saved: $saved)';
}


}

/// @nodoc
abstract mixin class _$DayStoryRecordCopyWith<$Res> implements $DayStoryRecordCopyWith<$Res> {
  factory _$DayStoryRecordCopyWith(_DayStoryRecord value, $Res Function(_DayStoryRecord) _then) = __$DayStoryRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'date') String? date,@JsonKey(name: 'memories', fromJson: _dayMemories) List<DayStoryMemoryRecord> memories,@JsonKey(name: 'saved') SavedDayStoryRecord? saved
});


@override $SavedDayStoryRecordCopyWith<$Res>? get saved;

}
/// @nodoc
class __$DayStoryRecordCopyWithImpl<$Res>
    implements _$DayStoryRecordCopyWith<$Res> {
  __$DayStoryRecordCopyWithImpl(this._self, this._then);

  final _DayStoryRecord _self;
  final $Res Function(_DayStoryRecord) _then;

/// Create a copy of DayStoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childId = freezed,Object? date = freezed,Object? memories = null,Object? saved = freezed,}) {
  return _then(_DayStoryRecord(
childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,memories: null == memories ? _self._memories : memories // ignore: cast_nullable_to_non_nullable
as List<DayStoryMemoryRecord>,saved: freezed == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as SavedDayStoryRecord?,
  ));
}

/// Create a copy of DayStoryRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SavedDayStoryRecordCopyWith<$Res>? get saved {
    if (_self.saved == null) {
    return null;
  }

  return $SavedDayStoryRecordCopyWith<$Res>(_self.saved!, (value) {
    return _then(_self.copyWith(saved: value));
  });
}
}


/// @nodoc
mixin _$DayStoryMemoryRecord {

@JsonKey(name: 'memoryId') String get memoryId;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'occurredAt') DateTime? get occurredAt;@JsonKey(name: 'assetIds') List<String> get assetIds;
/// Create a copy of DayStoryMemoryRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayStoryMemoryRecordCopyWith<DayStoryMemoryRecord> get copyWith => _$DayStoryMemoryRecordCopyWithImpl<DayStoryMemoryRecord>(this as DayStoryMemoryRecord, _$identity);

  /// Serializes this DayStoryMemoryRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayStoryMemoryRecord&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&const DeepCollectionEquality().equals(other.assetIds, assetIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memoryId,kind,title,occurredAt,const DeepCollectionEquality().hash(assetIds));

@override
String toString() {
  return 'DayStoryMemoryRecord(memoryId: $memoryId, kind: $kind, title: $title, occurredAt: $occurredAt, assetIds: $assetIds)';
}


}

/// @nodoc
abstract mixin class $DayStoryMemoryRecordCopyWith<$Res>  {
  factory $DayStoryMemoryRecordCopyWith(DayStoryMemoryRecord value, $Res Function(DayStoryMemoryRecord) _then) = _$DayStoryMemoryRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'memoryId') String memoryId,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'title') String? title,@JsonKey(name: 'occurredAt') DateTime? occurredAt,@JsonKey(name: 'assetIds') List<String> assetIds
});




}
/// @nodoc
class _$DayStoryMemoryRecordCopyWithImpl<$Res>
    implements $DayStoryMemoryRecordCopyWith<$Res> {
  _$DayStoryMemoryRecordCopyWithImpl(this._self, this._then);

  final DayStoryMemoryRecord _self;
  final $Res Function(DayStoryMemoryRecord) _then;

/// Create a copy of DayStoryMemoryRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memoryId = null,Object? kind = freezed,Object? title = freezed,Object? occurredAt = freezed,Object? assetIds = null,}) {
  return _then(_self.copyWith(
memoryId: null == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: freezed == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,assetIds: null == assetIds ? _self.assetIds : assetIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DayStoryMemoryRecord].
extension DayStoryMemoryRecordPatterns on DayStoryMemoryRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayStoryMemoryRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayStoryMemoryRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayStoryMemoryRecord value)  $default,){
final _that = this;
switch (_that) {
case _DayStoryMemoryRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayStoryMemoryRecord value)?  $default,){
final _that = this;
switch (_that) {
case _DayStoryMemoryRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DayStoryMemoryRecord implements DayStoryMemoryRecord {
  const _DayStoryMemoryRecord({@JsonKey(name: 'memoryId') required this.memoryId, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'title') this.title, @JsonKey(name: 'occurredAt') this.occurredAt, @JsonKey(name: 'assetIds') final  List<String> assetIds = const <String>[]}): _assetIds = assetIds;
  factory _DayStoryMemoryRecord.fromJson(Map<String, dynamic> json) => _$DayStoryMemoryRecordFromJson(json);

@override@JsonKey(name: 'memoryId') final  String memoryId;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'occurredAt') final  DateTime? occurredAt;
 final  List<String> _assetIds;
@override@JsonKey(name: 'assetIds') List<String> get assetIds {
  if (_assetIds is EqualUnmodifiableListView) return _assetIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assetIds);
}


/// Create a copy of DayStoryMemoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayStoryMemoryRecordCopyWith<_DayStoryMemoryRecord> get copyWith => __$DayStoryMemoryRecordCopyWithImpl<_DayStoryMemoryRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayStoryMemoryRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayStoryMemoryRecord&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&const DeepCollectionEquality().equals(other._assetIds, _assetIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memoryId,kind,title,occurredAt,const DeepCollectionEquality().hash(_assetIds));

@override
String toString() {
  return 'DayStoryMemoryRecord(memoryId: $memoryId, kind: $kind, title: $title, occurredAt: $occurredAt, assetIds: $assetIds)';
}


}

/// @nodoc
abstract mixin class _$DayStoryMemoryRecordCopyWith<$Res> implements $DayStoryMemoryRecordCopyWith<$Res> {
  factory _$DayStoryMemoryRecordCopyWith(_DayStoryMemoryRecord value, $Res Function(_DayStoryMemoryRecord) _then) = __$DayStoryMemoryRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'memoryId') String memoryId,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'title') String? title,@JsonKey(name: 'occurredAt') DateTime? occurredAt,@JsonKey(name: 'assetIds') List<String> assetIds
});




}
/// @nodoc
class __$DayStoryMemoryRecordCopyWithImpl<$Res>
    implements _$DayStoryMemoryRecordCopyWith<$Res> {
  __$DayStoryMemoryRecordCopyWithImpl(this._self, this._then);

  final _DayStoryMemoryRecord _self;
  final $Res Function(_DayStoryMemoryRecord) _then;

/// Create a copy of DayStoryMemoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memoryId = null,Object? kind = freezed,Object? title = freezed,Object? occurredAt = freezed,Object? assetIds = null,}) {
  return _then(_DayStoryMemoryRecord(
memoryId: null == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: freezed == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,assetIds: null == assetIds ? _self._assetIds : assetIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$SavedDayStoryRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'title') String get title;@JsonKey(name: 'body') String? get body;@JsonKey(name: 'coverAssetId') String? get coverAssetId;@JsonKey(name: 'memoryIds') List<String> get memoryIds;@JsonKey(name: 'assetIds') List<String> get assetIds;@JsonKey(name: 'visibility') String? get visibility;
/// Create a copy of SavedDayStoryRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedDayStoryRecordCopyWith<SavedDayStoryRecord> get copyWith => _$SavedDayStoryRecordCopyWithImpl<SavedDayStoryRecord>(this as SavedDayStoryRecord, _$identity);

  /// Serializes this SavedDayStoryRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedDayStoryRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.coverAssetId, coverAssetId) || other.coverAssetId == coverAssetId)&&const DeepCollectionEquality().equals(other.memoryIds, memoryIds)&&const DeepCollectionEquality().equals(other.assetIds, assetIds)&&(identical(other.visibility, visibility) || other.visibility == visibility));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,coverAssetId,const DeepCollectionEquality().hash(memoryIds),const DeepCollectionEquality().hash(assetIds),visibility);

@override
String toString() {
  return 'SavedDayStoryRecord(id: $id, title: $title, body: $body, coverAssetId: $coverAssetId, memoryIds: $memoryIds, assetIds: $assetIds, visibility: $visibility)';
}


}

/// @nodoc
abstract mixin class $SavedDayStoryRecordCopyWith<$Res>  {
  factory $SavedDayStoryRecordCopyWith(SavedDayStoryRecord value, $Res Function(SavedDayStoryRecord) _then) = _$SavedDayStoryRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'title') String title,@JsonKey(name: 'body') String? body,@JsonKey(name: 'coverAssetId') String? coverAssetId,@JsonKey(name: 'memoryIds') List<String> memoryIds,@JsonKey(name: 'assetIds') List<String> assetIds,@JsonKey(name: 'visibility') String? visibility
});




}
/// @nodoc
class _$SavedDayStoryRecordCopyWithImpl<$Res>
    implements $SavedDayStoryRecordCopyWith<$Res> {
  _$SavedDayStoryRecordCopyWithImpl(this._self, this._then);

  final SavedDayStoryRecord _self;
  final $Res Function(SavedDayStoryRecord) _then;

/// Create a copy of SavedDayStoryRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = null,Object? body = freezed,Object? coverAssetId = freezed,Object? memoryIds = null,Object? assetIds = null,Object? visibility = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,coverAssetId: freezed == coverAssetId ? _self.coverAssetId : coverAssetId // ignore: cast_nullable_to_non_nullable
as String?,memoryIds: null == memoryIds ? _self.memoryIds : memoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,assetIds: null == assetIds ? _self.assetIds : assetIds // ignore: cast_nullable_to_non_nullable
as List<String>,visibility: freezed == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedDayStoryRecord].
extension SavedDayStoryRecordPatterns on SavedDayStoryRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedDayStoryRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedDayStoryRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedDayStoryRecord value)  $default,){
final _that = this;
switch (_that) {
case _SavedDayStoryRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedDayStoryRecord value)?  $default,){
final _that = this;
switch (_that) {
case _SavedDayStoryRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SavedDayStoryRecord implements SavedDayStoryRecord {
  const _SavedDayStoryRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'title') this.title = '', @JsonKey(name: 'body') this.body, @JsonKey(name: 'coverAssetId') this.coverAssetId, @JsonKey(name: 'memoryIds') final  List<String> memoryIds = const <String>[], @JsonKey(name: 'assetIds') final  List<String> assetIds = const <String>[], @JsonKey(name: 'visibility') this.visibility}): _memoryIds = memoryIds,_assetIds = assetIds;
  factory _SavedDayStoryRecord.fromJson(Map<String, dynamic> json) => _$SavedDayStoryRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'body') final  String? body;
@override@JsonKey(name: 'coverAssetId') final  String? coverAssetId;
 final  List<String> _memoryIds;
@override@JsonKey(name: 'memoryIds') List<String> get memoryIds {
  if (_memoryIds is EqualUnmodifiableListView) return _memoryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memoryIds);
}

 final  List<String> _assetIds;
@override@JsonKey(name: 'assetIds') List<String> get assetIds {
  if (_assetIds is EqualUnmodifiableListView) return _assetIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assetIds);
}

@override@JsonKey(name: 'visibility') final  String? visibility;

/// Create a copy of SavedDayStoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedDayStoryRecordCopyWith<_SavedDayStoryRecord> get copyWith => __$SavedDayStoryRecordCopyWithImpl<_SavedDayStoryRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavedDayStoryRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedDayStoryRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.coverAssetId, coverAssetId) || other.coverAssetId == coverAssetId)&&const DeepCollectionEquality().equals(other._memoryIds, _memoryIds)&&const DeepCollectionEquality().equals(other._assetIds, _assetIds)&&(identical(other.visibility, visibility) || other.visibility == visibility));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,coverAssetId,const DeepCollectionEquality().hash(_memoryIds),const DeepCollectionEquality().hash(_assetIds),visibility);

@override
String toString() {
  return 'SavedDayStoryRecord(id: $id, title: $title, body: $body, coverAssetId: $coverAssetId, memoryIds: $memoryIds, assetIds: $assetIds, visibility: $visibility)';
}


}

/// @nodoc
abstract mixin class _$SavedDayStoryRecordCopyWith<$Res> implements $SavedDayStoryRecordCopyWith<$Res> {
  factory _$SavedDayStoryRecordCopyWith(_SavedDayStoryRecord value, $Res Function(_SavedDayStoryRecord) _then) = __$SavedDayStoryRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'title') String title,@JsonKey(name: 'body') String? body,@JsonKey(name: 'coverAssetId') String? coverAssetId,@JsonKey(name: 'memoryIds') List<String> memoryIds,@JsonKey(name: 'assetIds') List<String> assetIds,@JsonKey(name: 'visibility') String? visibility
});




}
/// @nodoc
class __$SavedDayStoryRecordCopyWithImpl<$Res>
    implements _$SavedDayStoryRecordCopyWith<$Res> {
  __$SavedDayStoryRecordCopyWithImpl(this._self, this._then);

  final _SavedDayStoryRecord _self;
  final $Res Function(_SavedDayStoryRecord) _then;

/// Create a copy of SavedDayStoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = null,Object? body = freezed,Object? coverAssetId = freezed,Object? memoryIds = null,Object? assetIds = null,Object? visibility = freezed,}) {
  return _then(_SavedDayStoryRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,coverAssetId: freezed == coverAssetId ? _self.coverAssetId : coverAssetId // ignore: cast_nullable_to_non_nullable
as String?,memoryIds: null == memoryIds ? _self._memoryIds : memoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,assetIds: null == assetIds ? _self._assetIds : assetIds // ignore: cast_nullable_to_non_nullable
as List<String>,visibility: freezed == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
