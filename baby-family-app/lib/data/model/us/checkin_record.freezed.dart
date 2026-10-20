// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkin_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CheckinRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'expiresAt') DateTime? get expiresAt;@JsonKey(name: 'mood') String? get mood;@JsonKey(name: 'energy') int? get energy;@JsonKey(name: 'needs') List<String> get needs;@JsonKey(name: 'note') String? get note;@JsonKey(name: 'shared') bool? get shared;@JsonKey(name: 'sharedFields') List<String> get sharedFields;
/// Create a copy of CheckinRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckinRecordCopyWith<CheckinRecord> get copyWith => _$CheckinRecordCopyWithImpl<CheckinRecord>(this as CheckinRecord, _$identity);

  /// Serializes this CheckinRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckinRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.energy, energy) || other.energy == energy)&&const DeepCollectionEquality().equals(other.needs, needs)&&(identical(other.note, note) || other.note == note)&&(identical(other.shared, shared) || other.shared == shared)&&const DeepCollectionEquality().equals(other.sharedFields, sharedFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,expiresAt,mood,energy,const DeepCollectionEquality().hash(needs),note,shared,const DeepCollectionEquality().hash(sharedFields));

@override
String toString() {
  return 'CheckinRecord(id: $id, createdAt: $createdAt, expiresAt: $expiresAt, mood: $mood, energy: $energy, needs: $needs, note: $note, shared: $shared, sharedFields: $sharedFields)';
}


}

/// @nodoc
abstract mixin class $CheckinRecordCopyWith<$Res>  {
  factory $CheckinRecordCopyWith(CheckinRecord value, $Res Function(CheckinRecord) _then) = _$CheckinRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'expiresAt') DateTime? expiresAt,@JsonKey(name: 'mood') String? mood,@JsonKey(name: 'energy') int? energy,@JsonKey(name: 'needs') List<String> needs,@JsonKey(name: 'note') String? note,@JsonKey(name: 'shared') bool? shared,@JsonKey(name: 'sharedFields') List<String> sharedFields
});




}
/// @nodoc
class _$CheckinRecordCopyWithImpl<$Res>
    implements $CheckinRecordCopyWith<$Res> {
  _$CheckinRecordCopyWithImpl(this._self, this._then);

  final CheckinRecord _self;
  final $Res Function(CheckinRecord) _then;

/// Create a copy of CheckinRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdAt = freezed,Object? expiresAt = freezed,Object? mood = freezed,Object? energy = freezed,Object? needs = null,Object? note = freezed,Object? shared = freezed,Object? sharedFields = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,mood: freezed == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String?,energy: freezed == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as int?,needs: null == needs ? _self.needs : needs // ignore: cast_nullable_to_non_nullable
as List<String>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,shared: freezed == shared ? _self.shared : shared // ignore: cast_nullable_to_non_nullable
as bool?,sharedFields: null == sharedFields ? _self.sharedFields : sharedFields // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckinRecord].
extension CheckinRecordPatterns on CheckinRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckinRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckinRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckinRecord value)  $default,){
final _that = this;
switch (_that) {
case _CheckinRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckinRecord value)?  $default,){
final _that = this;
switch (_that) {
case _CheckinRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CheckinRecord implements CheckinRecord {
  const _CheckinRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'expiresAt') this.expiresAt, @JsonKey(name: 'mood') this.mood, @JsonKey(name: 'energy') this.energy, @JsonKey(name: 'needs') final  List<String> needs = const <String>[], @JsonKey(name: 'note') this.note, @JsonKey(name: 'shared') this.shared, @JsonKey(name: 'sharedFields') final  List<String> sharedFields = const <String>[]}): _needs = needs,_sharedFields = sharedFields;
  factory _CheckinRecord.fromJson(Map<String, dynamic> json) => _$CheckinRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
@override@JsonKey(name: 'expiresAt') final  DateTime? expiresAt;
@override@JsonKey(name: 'mood') final  String? mood;
@override@JsonKey(name: 'energy') final  int? energy;
 final  List<String> _needs;
@override@JsonKey(name: 'needs') List<String> get needs {
  if (_needs is EqualUnmodifiableListView) return _needs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_needs);
}

@override@JsonKey(name: 'note') final  String? note;
@override@JsonKey(name: 'shared') final  bool? shared;
 final  List<String> _sharedFields;
@override@JsonKey(name: 'sharedFields') List<String> get sharedFields {
  if (_sharedFields is EqualUnmodifiableListView) return _sharedFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sharedFields);
}


/// Create a copy of CheckinRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckinRecordCopyWith<_CheckinRecord> get copyWith => __$CheckinRecordCopyWithImpl<_CheckinRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckinRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckinRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.energy, energy) || other.energy == energy)&&const DeepCollectionEquality().equals(other._needs, _needs)&&(identical(other.note, note) || other.note == note)&&(identical(other.shared, shared) || other.shared == shared)&&const DeepCollectionEquality().equals(other._sharedFields, _sharedFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,expiresAt,mood,energy,const DeepCollectionEquality().hash(_needs),note,shared,const DeepCollectionEquality().hash(_sharedFields));

@override
String toString() {
  return 'CheckinRecord(id: $id, createdAt: $createdAt, expiresAt: $expiresAt, mood: $mood, energy: $energy, needs: $needs, note: $note, shared: $shared, sharedFields: $sharedFields)';
}


}

/// @nodoc
abstract mixin class _$CheckinRecordCopyWith<$Res> implements $CheckinRecordCopyWith<$Res> {
  factory _$CheckinRecordCopyWith(_CheckinRecord value, $Res Function(_CheckinRecord) _then) = __$CheckinRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'expiresAt') DateTime? expiresAt,@JsonKey(name: 'mood') String? mood,@JsonKey(name: 'energy') int? energy,@JsonKey(name: 'needs') List<String> needs,@JsonKey(name: 'note') String? note,@JsonKey(name: 'shared') bool? shared,@JsonKey(name: 'sharedFields') List<String> sharedFields
});




}
/// @nodoc
class __$CheckinRecordCopyWithImpl<$Res>
    implements _$CheckinRecordCopyWith<$Res> {
  __$CheckinRecordCopyWithImpl(this._self, this._then);

  final _CheckinRecord _self;
  final $Res Function(_CheckinRecord) _then;

/// Create a copy of CheckinRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdAt = freezed,Object? expiresAt = freezed,Object? mood = freezed,Object? energy = freezed,Object? needs = null,Object? note = freezed,Object? shared = freezed,Object? sharedFields = null,}) {
  return _then(_CheckinRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,mood: freezed == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String?,energy: freezed == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as int?,needs: null == needs ? _self._needs : needs // ignore: cast_nullable_to_non_nullable
as List<String>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,shared: freezed == shared ? _self.shared : shared // ignore: cast_nullable_to_non_nullable
as bool?,sharedFields: null == sharedFields ? _self._sharedFields : sharedFields // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
