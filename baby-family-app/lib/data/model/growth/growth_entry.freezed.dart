// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'growth_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GrowthEntry {

@JsonKey(name: 'measuredOn') String get measuredOn;@JsonKey(name: 'weightGrams') int? get weightGrams;@JsonKey(name: 'heightMm') int? get heightMm;@JsonKey(name: 'note') String? get note;@JsonKey(name: 'pending') bool get pending;
/// Create a copy of GrowthEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrowthEntryCopyWith<GrowthEntry> get copyWith => _$GrowthEntryCopyWithImpl<GrowthEntry>(this as GrowthEntry, _$identity);

  /// Serializes this GrowthEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrowthEntry&&(identical(other.measuredOn, measuredOn) || other.measuredOn == measuredOn)&&(identical(other.weightGrams, weightGrams) || other.weightGrams == weightGrams)&&(identical(other.heightMm, heightMm) || other.heightMm == heightMm)&&(identical(other.note, note) || other.note == note)&&(identical(other.pending, pending) || other.pending == pending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,measuredOn,weightGrams,heightMm,note,pending);

@override
String toString() {
  return 'GrowthEntry(measuredOn: $measuredOn, weightGrams: $weightGrams, heightMm: $heightMm, note: $note, pending: $pending)';
}


}

/// @nodoc
abstract mixin class $GrowthEntryCopyWith<$Res>  {
  factory $GrowthEntryCopyWith(GrowthEntry value, $Res Function(GrowthEntry) _then) = _$GrowthEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'measuredOn') String measuredOn,@JsonKey(name: 'weightGrams') int? weightGrams,@JsonKey(name: 'heightMm') int? heightMm,@JsonKey(name: 'note') String? note,@JsonKey(name: 'pending') bool pending
});




}
/// @nodoc
class _$GrowthEntryCopyWithImpl<$Res>
    implements $GrowthEntryCopyWith<$Res> {
  _$GrowthEntryCopyWithImpl(this._self, this._then);

  final GrowthEntry _self;
  final $Res Function(GrowthEntry) _then;

/// Create a copy of GrowthEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? measuredOn = null,Object? weightGrams = freezed,Object? heightMm = freezed,Object? note = freezed,Object? pending = null,}) {
  return _then(_self.copyWith(
measuredOn: null == measuredOn ? _self.measuredOn : measuredOn // ignore: cast_nullable_to_non_nullable
as String,weightGrams: freezed == weightGrams ? _self.weightGrams : weightGrams // ignore: cast_nullable_to_non_nullable
as int?,heightMm: freezed == heightMm ? _self.heightMm : heightMm // ignore: cast_nullable_to_non_nullable
as int?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GrowthEntry].
extension GrowthEntryPatterns on GrowthEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrowthEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrowthEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrowthEntry value)  $default,){
final _that = this;
switch (_that) {
case _GrowthEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrowthEntry value)?  $default,){
final _that = this;
switch (_that) {
case _GrowthEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _GrowthEntry extends GrowthEntry {
  const _GrowthEntry({@JsonKey(name: 'measuredOn') required this.measuredOn, @JsonKey(name: 'weightGrams') this.weightGrams, @JsonKey(name: 'heightMm') this.heightMm, @JsonKey(name: 'note') this.note, @JsonKey(name: 'pending') this.pending = false}): super._();
  factory _GrowthEntry.fromJson(Map<String, dynamic> json) => _$GrowthEntryFromJson(json);

@override@JsonKey(name: 'measuredOn') final  String measuredOn;
@override@JsonKey(name: 'weightGrams') final  int? weightGrams;
@override@JsonKey(name: 'heightMm') final  int? heightMm;
@override@JsonKey(name: 'note') final  String? note;
@override@JsonKey(name: 'pending') final  bool pending;

/// Create a copy of GrowthEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrowthEntryCopyWith<_GrowthEntry> get copyWith => __$GrowthEntryCopyWithImpl<_GrowthEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrowthEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrowthEntry&&(identical(other.measuredOn, measuredOn) || other.measuredOn == measuredOn)&&(identical(other.weightGrams, weightGrams) || other.weightGrams == weightGrams)&&(identical(other.heightMm, heightMm) || other.heightMm == heightMm)&&(identical(other.note, note) || other.note == note)&&(identical(other.pending, pending) || other.pending == pending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,measuredOn,weightGrams,heightMm,note,pending);

@override
String toString() {
  return 'GrowthEntry(measuredOn: $measuredOn, weightGrams: $weightGrams, heightMm: $heightMm, note: $note, pending: $pending)';
}


}

/// @nodoc
abstract mixin class _$GrowthEntryCopyWith<$Res> implements $GrowthEntryCopyWith<$Res> {
  factory _$GrowthEntryCopyWith(_GrowthEntry value, $Res Function(_GrowthEntry) _then) = __$GrowthEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'measuredOn') String measuredOn,@JsonKey(name: 'weightGrams') int? weightGrams,@JsonKey(name: 'heightMm') int? heightMm,@JsonKey(name: 'note') String? note,@JsonKey(name: 'pending') bool pending
});




}
/// @nodoc
class __$GrowthEntryCopyWithImpl<$Res>
    implements _$GrowthEntryCopyWith<$Res> {
  __$GrowthEntryCopyWithImpl(this._self, this._then);

  final _GrowthEntry _self;
  final $Res Function(_GrowthEntry) _then;

/// Create a copy of GrowthEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? measuredOn = null,Object? weightGrams = freezed,Object? heightMm = freezed,Object? note = freezed,Object? pending = null,}) {
  return _then(_GrowthEntry(
measuredOn: null == measuredOn ? _self.measuredOn : measuredOn // ignore: cast_nullable_to_non_nullable
as String,weightGrams: freezed == weightGrams ? _self.weightGrams : weightGrams // ignore: cast_nullable_to_non_nullable
as int?,heightMm: freezed == heightMm ? _self.heightMm : heightMm // ignore: cast_nullable_to_non_nullable
as int?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$GrowthListRecord {

@JsonKey(name: 'childId') String? get childId;@JsonKey(name: 'birthDate') String? get birthDate;@JsonKey(name: 'items', fromJson: _growthItems) List<GrowthEntry> get items;
/// Create a copy of GrowthListRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrowthListRecordCopyWith<GrowthListRecord> get copyWith => _$GrowthListRecordCopyWithImpl<GrowthListRecord>(this as GrowthListRecord, _$identity);

  /// Serializes this GrowthListRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrowthListRecord&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,birthDate,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'GrowthListRecord(childId: $childId, birthDate: $birthDate, items: $items)';
}


}

/// @nodoc
abstract mixin class $GrowthListRecordCopyWith<$Res>  {
  factory $GrowthListRecordCopyWith(GrowthListRecord value, $Res Function(GrowthListRecord) _then) = _$GrowthListRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'birthDate') String? birthDate,@JsonKey(name: 'items', fromJson: _growthItems) List<GrowthEntry> items
});




}
/// @nodoc
class _$GrowthListRecordCopyWithImpl<$Res>
    implements $GrowthListRecordCopyWith<$Res> {
  _$GrowthListRecordCopyWithImpl(this._self, this._then);

  final GrowthListRecord _self;
  final $Res Function(GrowthListRecord) _then;

/// Create a copy of GrowthListRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childId = freezed,Object? birthDate = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<GrowthEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [GrowthListRecord].
extension GrowthListRecordPatterns on GrowthListRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrowthListRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrowthListRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrowthListRecord value)  $default,){
final _that = this;
switch (_that) {
case _GrowthListRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrowthListRecord value)?  $default,){
final _that = this;
switch (_that) {
case _GrowthListRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _GrowthListRecord implements GrowthListRecord {
  const _GrowthListRecord({@JsonKey(name: 'childId') this.childId, @JsonKey(name: 'birthDate') this.birthDate, @JsonKey(name: 'items', fromJson: _growthItems) final  List<GrowthEntry> items = const <GrowthEntry>[]}): _items = items;
  factory _GrowthListRecord.fromJson(Map<String, dynamic> json) => _$GrowthListRecordFromJson(json);

@override@JsonKey(name: 'childId') final  String? childId;
@override@JsonKey(name: 'birthDate') final  String? birthDate;
 final  List<GrowthEntry> _items;
@override@JsonKey(name: 'items', fromJson: _growthItems) List<GrowthEntry> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of GrowthListRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrowthListRecordCopyWith<_GrowthListRecord> get copyWith => __$GrowthListRecordCopyWithImpl<_GrowthListRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrowthListRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrowthListRecord&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,birthDate,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'GrowthListRecord(childId: $childId, birthDate: $birthDate, items: $items)';
}


}

/// @nodoc
abstract mixin class _$GrowthListRecordCopyWith<$Res> implements $GrowthListRecordCopyWith<$Res> {
  factory _$GrowthListRecordCopyWith(_GrowthListRecord value, $Res Function(_GrowthListRecord) _then) = __$GrowthListRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'birthDate') String? birthDate,@JsonKey(name: 'items', fromJson: _growthItems) List<GrowthEntry> items
});




}
/// @nodoc
class __$GrowthListRecordCopyWithImpl<$Res>
    implements _$GrowthListRecordCopyWith<$Res> {
  __$GrowthListRecordCopyWithImpl(this._self, this._then);

  final _GrowthListRecord _self;
  final $Res Function(_GrowthListRecord) _then;

/// Create a copy of GrowthListRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childId = freezed,Object? birthDate = freezed,Object? items = null,}) {
  return _then(_GrowthListRecord(
childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<GrowthEntry>,
  ));
}


}

// dart format on
