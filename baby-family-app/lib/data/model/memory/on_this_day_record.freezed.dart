// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'on_this_day_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnThisDayRecord {

@JsonKey(name: 'date') String? get date;@JsonKey(name: 'groups') List<OnThisDayGroupRecord> get groups;
/// Create a copy of OnThisDayRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnThisDayRecordCopyWith<OnThisDayRecord> get copyWith => _$OnThisDayRecordCopyWithImpl<OnThisDayRecord>(this as OnThisDayRecord, _$identity);

  /// Serializes this OnThisDayRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnThisDayRecord&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.groups, groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(groups));

@override
String toString() {
  return 'OnThisDayRecord(date: $date, groups: $groups)';
}


}

/// @nodoc
abstract mixin class $OnThisDayRecordCopyWith<$Res>  {
  factory $OnThisDayRecordCopyWith(OnThisDayRecord value, $Res Function(OnThisDayRecord) _then) = _$OnThisDayRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'date') String? date,@JsonKey(name: 'groups') List<OnThisDayGroupRecord> groups
});




}
/// @nodoc
class _$OnThisDayRecordCopyWithImpl<$Res>
    implements $OnThisDayRecordCopyWith<$Res> {
  _$OnThisDayRecordCopyWithImpl(this._self, this._then);

  final OnThisDayRecord _self;
  final $Res Function(OnThisDayRecord) _then;

/// Create a copy of OnThisDayRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = freezed,Object? groups = null,}) {
  return _then(_self.copyWith(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<OnThisDayGroupRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [OnThisDayRecord].
extension OnThisDayRecordPatterns on OnThisDayRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnThisDayRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnThisDayRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnThisDayRecord value)  $default,){
final _that = this;
switch (_that) {
case _OnThisDayRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnThisDayRecord value)?  $default,){
final _that = this;
switch (_that) {
case _OnThisDayRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OnThisDayRecord implements OnThisDayRecord {
  const _OnThisDayRecord({@JsonKey(name: 'date') this.date, @JsonKey(name: 'groups') final  List<OnThisDayGroupRecord> groups = const <OnThisDayGroupRecord>[]}): _groups = groups;
  factory _OnThisDayRecord.fromJson(Map<String, dynamic> json) => _$OnThisDayRecordFromJson(json);

@override@JsonKey(name: 'date') final  String? date;
 final  List<OnThisDayGroupRecord> _groups;
@override@JsonKey(name: 'groups') List<OnThisDayGroupRecord> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}


/// Create a copy of OnThisDayRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnThisDayRecordCopyWith<_OnThisDayRecord> get copyWith => __$OnThisDayRecordCopyWithImpl<_OnThisDayRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnThisDayRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnThisDayRecord&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._groups, _groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(_groups));

@override
String toString() {
  return 'OnThisDayRecord(date: $date, groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$OnThisDayRecordCopyWith<$Res> implements $OnThisDayRecordCopyWith<$Res> {
  factory _$OnThisDayRecordCopyWith(_OnThisDayRecord value, $Res Function(_OnThisDayRecord) _then) = __$OnThisDayRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'date') String? date,@JsonKey(name: 'groups') List<OnThisDayGroupRecord> groups
});




}
/// @nodoc
class __$OnThisDayRecordCopyWithImpl<$Res>
    implements _$OnThisDayRecordCopyWith<$Res> {
  __$OnThisDayRecordCopyWithImpl(this._self, this._then);

  final _OnThisDayRecord _self;
  final $Res Function(_OnThisDayRecord) _then;

/// Create a copy of OnThisDayRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = freezed,Object? groups = null,}) {
  return _then(_OnThisDayRecord(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<OnThisDayGroupRecord>,
  ));
}


}


/// @nodoc
mixin _$OnThisDayGroupRecord {

@JsonKey(name: 'yearsAgo') int get yearsAgo;@JsonKey(name: 'date') String? get date;@JsonKey(name: 'memories') List<MemoryRecord> get memories;
/// Create a copy of OnThisDayGroupRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnThisDayGroupRecordCopyWith<OnThisDayGroupRecord> get copyWith => _$OnThisDayGroupRecordCopyWithImpl<OnThisDayGroupRecord>(this as OnThisDayGroupRecord, _$identity);

  /// Serializes this OnThisDayGroupRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnThisDayGroupRecord&&(identical(other.yearsAgo, yearsAgo) || other.yearsAgo == yearsAgo)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.memories, memories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,yearsAgo,date,const DeepCollectionEquality().hash(memories));

@override
String toString() {
  return 'OnThisDayGroupRecord(yearsAgo: $yearsAgo, date: $date, memories: $memories)';
}


}

/// @nodoc
abstract mixin class $OnThisDayGroupRecordCopyWith<$Res>  {
  factory $OnThisDayGroupRecordCopyWith(OnThisDayGroupRecord value, $Res Function(OnThisDayGroupRecord) _then) = _$OnThisDayGroupRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'yearsAgo') int yearsAgo,@JsonKey(name: 'date') String? date,@JsonKey(name: 'memories') List<MemoryRecord> memories
});




}
/// @nodoc
class _$OnThisDayGroupRecordCopyWithImpl<$Res>
    implements $OnThisDayGroupRecordCopyWith<$Res> {
  _$OnThisDayGroupRecordCopyWithImpl(this._self, this._then);

  final OnThisDayGroupRecord _self;
  final $Res Function(OnThisDayGroupRecord) _then;

/// Create a copy of OnThisDayGroupRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? yearsAgo = null,Object? date = freezed,Object? memories = null,}) {
  return _then(_self.copyWith(
yearsAgo: null == yearsAgo ? _self.yearsAgo : yearsAgo // ignore: cast_nullable_to_non_nullable
as int,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,memories: null == memories ? _self.memories : memories // ignore: cast_nullable_to_non_nullable
as List<MemoryRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [OnThisDayGroupRecord].
extension OnThisDayGroupRecordPatterns on OnThisDayGroupRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnThisDayGroupRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnThisDayGroupRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnThisDayGroupRecord value)  $default,){
final _that = this;
switch (_that) {
case _OnThisDayGroupRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnThisDayGroupRecord value)?  $default,){
final _that = this;
switch (_that) {
case _OnThisDayGroupRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OnThisDayGroupRecord implements OnThisDayGroupRecord {
  const _OnThisDayGroupRecord({@JsonKey(name: 'yearsAgo') this.yearsAgo = 0, @JsonKey(name: 'date') this.date, @JsonKey(name: 'memories') final  List<MemoryRecord> memories = const <MemoryRecord>[]}): _memories = memories;
  factory _OnThisDayGroupRecord.fromJson(Map<String, dynamic> json) => _$OnThisDayGroupRecordFromJson(json);

@override@JsonKey(name: 'yearsAgo') final  int yearsAgo;
@override@JsonKey(name: 'date') final  String? date;
 final  List<MemoryRecord> _memories;
@override@JsonKey(name: 'memories') List<MemoryRecord> get memories {
  if (_memories is EqualUnmodifiableListView) return _memories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memories);
}


/// Create a copy of OnThisDayGroupRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnThisDayGroupRecordCopyWith<_OnThisDayGroupRecord> get copyWith => __$OnThisDayGroupRecordCopyWithImpl<_OnThisDayGroupRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnThisDayGroupRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnThisDayGroupRecord&&(identical(other.yearsAgo, yearsAgo) || other.yearsAgo == yearsAgo)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._memories, _memories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,yearsAgo,date,const DeepCollectionEquality().hash(_memories));

@override
String toString() {
  return 'OnThisDayGroupRecord(yearsAgo: $yearsAgo, date: $date, memories: $memories)';
}


}

/// @nodoc
abstract mixin class _$OnThisDayGroupRecordCopyWith<$Res> implements $OnThisDayGroupRecordCopyWith<$Res> {
  factory _$OnThisDayGroupRecordCopyWith(_OnThisDayGroupRecord value, $Res Function(_OnThisDayGroupRecord) _then) = __$OnThisDayGroupRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'yearsAgo') int yearsAgo,@JsonKey(name: 'date') String? date,@JsonKey(name: 'memories') List<MemoryRecord> memories
});




}
/// @nodoc
class __$OnThisDayGroupRecordCopyWithImpl<$Res>
    implements _$OnThisDayGroupRecordCopyWith<$Res> {
  __$OnThisDayGroupRecordCopyWithImpl(this._self, this._then);

  final _OnThisDayGroupRecord _self;
  final $Res Function(_OnThisDayGroupRecord) _then;

/// Create a copy of OnThisDayGroupRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? yearsAgo = null,Object? date = freezed,Object? memories = null,}) {
  return _then(_OnThisDayGroupRecord(
yearsAgo: null == yearsAgo ? _self.yearsAgo : yearsAgo // ignore: cast_nullable_to_non_nullable
as int,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,memories: null == memories ? _self._memories : memories // ignore: cast_nullable_to_non_nullable
as List<MemoryRecord>,
  ));
}


}

// dart format on
