// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JournalEntryRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'body') String? get body;@JsonKey(name: 'mood') String? get mood;@JsonKey(name: 'assetIds') List<String> get assetIds;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'updatedAt') DateTime? get updatedAt;
/// Create a copy of JournalEntryRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntryRecordCopyWith<JournalEntryRecord> get copyWith => _$JournalEntryRecordCopyWithImpl<JournalEntryRecord>(this as JournalEntryRecord, _$identity);

  /// Serializes this JournalEntryRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntryRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.mood, mood) || other.mood == mood)&&const DeepCollectionEquality().equals(other.assetIds, assetIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,mood,const DeepCollectionEquality().hash(assetIds),createdAt,updatedAt);

@override
String toString() {
  return 'JournalEntryRecord(id: $id, title: $title, body: $body, mood: $mood, assetIds: $assetIds, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $JournalEntryRecordCopyWith<$Res>  {
  factory $JournalEntryRecordCopyWith(JournalEntryRecord value, $Res Function(JournalEntryRecord) _then) = _$JournalEntryRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'title') String? title,@JsonKey(name: 'body') String? body,@JsonKey(name: 'mood') String? mood,@JsonKey(name: 'assetIds') List<String> assetIds,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'updatedAt') DateTime? updatedAt
});




}
/// @nodoc
class _$JournalEntryRecordCopyWithImpl<$Res>
    implements $JournalEntryRecordCopyWith<$Res> {
  _$JournalEntryRecordCopyWithImpl(this._self, this._then);

  final JournalEntryRecord _self;
  final $Res Function(JournalEntryRecord) _then;

/// Create a copy of JournalEntryRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = freezed,Object? body = freezed,Object? mood = freezed,Object? assetIds = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,mood: freezed == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String?,assetIds: null == assetIds ? _self.assetIds : assetIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalEntryRecord].
extension JournalEntryRecordPatterns on JournalEntryRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalEntryRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalEntryRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalEntryRecord value)  $default,){
final _that = this;
switch (_that) {
case _JournalEntryRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalEntryRecord value)?  $default,){
final _that = this;
switch (_that) {
case _JournalEntryRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _JournalEntryRecord implements JournalEntryRecord {
  const _JournalEntryRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'title') this.title, @JsonKey(name: 'body') this.body, @JsonKey(name: 'mood') this.mood, @JsonKey(name: 'assetIds') final  List<String> assetIds = const <String>[], @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'updatedAt') this.updatedAt}): _assetIds = assetIds;
  factory _JournalEntryRecord.fromJson(Map<String, dynamic> json) => _$JournalEntryRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'body') final  String? body;
@override@JsonKey(name: 'mood') final  String? mood;
 final  List<String> _assetIds;
@override@JsonKey(name: 'assetIds') List<String> get assetIds {
  if (_assetIds is EqualUnmodifiableListView) return _assetIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assetIds);
}

@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
@override@JsonKey(name: 'updatedAt') final  DateTime? updatedAt;

/// Create a copy of JournalEntryRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalEntryRecordCopyWith<_JournalEntryRecord> get copyWith => __$JournalEntryRecordCopyWithImpl<_JournalEntryRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalEntryRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalEntryRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.mood, mood) || other.mood == mood)&&const DeepCollectionEquality().equals(other._assetIds, _assetIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,mood,const DeepCollectionEquality().hash(_assetIds),createdAt,updatedAt);

@override
String toString() {
  return 'JournalEntryRecord(id: $id, title: $title, body: $body, mood: $mood, assetIds: $assetIds, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$JournalEntryRecordCopyWith<$Res> implements $JournalEntryRecordCopyWith<$Res> {
  factory _$JournalEntryRecordCopyWith(_JournalEntryRecord value, $Res Function(_JournalEntryRecord) _then) = __$JournalEntryRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'title') String? title,@JsonKey(name: 'body') String? body,@JsonKey(name: 'mood') String? mood,@JsonKey(name: 'assetIds') List<String> assetIds,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'updatedAt') DateTime? updatedAt
});




}
/// @nodoc
class __$JournalEntryRecordCopyWithImpl<$Res>
    implements _$JournalEntryRecordCopyWith<$Res> {
  __$JournalEntryRecordCopyWithImpl(this._self, this._then);

  final _JournalEntryRecord _self;
  final $Res Function(_JournalEntryRecord) _then;

/// Create a copy of JournalEntryRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = freezed,Object? body = freezed,Object? mood = freezed,Object? assetIds = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_JournalEntryRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,mood: freezed == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String?,assetIds: null == assetIds ? _self._assetIds : assetIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
