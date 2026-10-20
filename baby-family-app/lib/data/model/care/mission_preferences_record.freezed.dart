// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_preferences_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionPreferencesRecord {

@JsonKey(name: 'disabledCategories') List<String> get disabledCategories;@JsonKey(name: 'boardPushTime') String? get boardPushTime;@JsonKey(name: 'eveningCarryOver') bool get eveningCarryOver;@JsonKey(name: 'defaultReminderMin') int? get defaultReminderMin;
/// Create a copy of MissionPreferencesRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionPreferencesRecordCopyWith<MissionPreferencesRecord> get copyWith => _$MissionPreferencesRecordCopyWithImpl<MissionPreferencesRecord>(this as MissionPreferencesRecord, _$identity);

  /// Serializes this MissionPreferencesRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionPreferencesRecord&&const DeepCollectionEquality().equals(other.disabledCategories, disabledCategories)&&(identical(other.boardPushTime, boardPushTime) || other.boardPushTime == boardPushTime)&&(identical(other.eveningCarryOver, eveningCarryOver) || other.eveningCarryOver == eveningCarryOver)&&(identical(other.defaultReminderMin, defaultReminderMin) || other.defaultReminderMin == defaultReminderMin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(disabledCategories),boardPushTime,eveningCarryOver,defaultReminderMin);

@override
String toString() {
  return 'MissionPreferencesRecord(disabledCategories: $disabledCategories, boardPushTime: $boardPushTime, eveningCarryOver: $eveningCarryOver, defaultReminderMin: $defaultReminderMin)';
}


}

/// @nodoc
abstract mixin class $MissionPreferencesRecordCopyWith<$Res>  {
  factory $MissionPreferencesRecordCopyWith(MissionPreferencesRecord value, $Res Function(MissionPreferencesRecord) _then) = _$MissionPreferencesRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'disabledCategories') List<String> disabledCategories,@JsonKey(name: 'boardPushTime') String? boardPushTime,@JsonKey(name: 'eveningCarryOver') bool eveningCarryOver,@JsonKey(name: 'defaultReminderMin') int? defaultReminderMin
});




}
/// @nodoc
class _$MissionPreferencesRecordCopyWithImpl<$Res>
    implements $MissionPreferencesRecordCopyWith<$Res> {
  _$MissionPreferencesRecordCopyWithImpl(this._self, this._then);

  final MissionPreferencesRecord _self;
  final $Res Function(MissionPreferencesRecord) _then;

/// Create a copy of MissionPreferencesRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? disabledCategories = null,Object? boardPushTime = freezed,Object? eveningCarryOver = null,Object? defaultReminderMin = freezed,}) {
  return _then(_self.copyWith(
disabledCategories: null == disabledCategories ? _self.disabledCategories : disabledCategories // ignore: cast_nullable_to_non_nullable
as List<String>,boardPushTime: freezed == boardPushTime ? _self.boardPushTime : boardPushTime // ignore: cast_nullable_to_non_nullable
as String?,eveningCarryOver: null == eveningCarryOver ? _self.eveningCarryOver : eveningCarryOver // ignore: cast_nullable_to_non_nullable
as bool,defaultReminderMin: freezed == defaultReminderMin ? _self.defaultReminderMin : defaultReminderMin // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionPreferencesRecord].
extension MissionPreferencesRecordPatterns on MissionPreferencesRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionPreferencesRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionPreferencesRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionPreferencesRecord value)  $default,){
final _that = this;
switch (_that) {
case _MissionPreferencesRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionPreferencesRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MissionPreferencesRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MissionPreferencesRecord implements MissionPreferencesRecord {
  const _MissionPreferencesRecord({@JsonKey(name: 'disabledCategories') final  List<String> disabledCategories = const <String>[], @JsonKey(name: 'boardPushTime') this.boardPushTime, @JsonKey(name: 'eveningCarryOver') this.eveningCarryOver = true, @JsonKey(name: 'defaultReminderMin') this.defaultReminderMin}): _disabledCategories = disabledCategories;
  factory _MissionPreferencesRecord.fromJson(Map<String, dynamic> json) => _$MissionPreferencesRecordFromJson(json);

 final  List<String> _disabledCategories;
@override@JsonKey(name: 'disabledCategories') List<String> get disabledCategories {
  if (_disabledCategories is EqualUnmodifiableListView) return _disabledCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_disabledCategories);
}

@override@JsonKey(name: 'boardPushTime') final  String? boardPushTime;
@override@JsonKey(name: 'eveningCarryOver') final  bool eveningCarryOver;
@override@JsonKey(name: 'defaultReminderMin') final  int? defaultReminderMin;

/// Create a copy of MissionPreferencesRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionPreferencesRecordCopyWith<_MissionPreferencesRecord> get copyWith => __$MissionPreferencesRecordCopyWithImpl<_MissionPreferencesRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionPreferencesRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionPreferencesRecord&&const DeepCollectionEquality().equals(other._disabledCategories, _disabledCategories)&&(identical(other.boardPushTime, boardPushTime) || other.boardPushTime == boardPushTime)&&(identical(other.eveningCarryOver, eveningCarryOver) || other.eveningCarryOver == eveningCarryOver)&&(identical(other.defaultReminderMin, defaultReminderMin) || other.defaultReminderMin == defaultReminderMin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_disabledCategories),boardPushTime,eveningCarryOver,defaultReminderMin);

@override
String toString() {
  return 'MissionPreferencesRecord(disabledCategories: $disabledCategories, boardPushTime: $boardPushTime, eveningCarryOver: $eveningCarryOver, defaultReminderMin: $defaultReminderMin)';
}


}

/// @nodoc
abstract mixin class _$MissionPreferencesRecordCopyWith<$Res> implements $MissionPreferencesRecordCopyWith<$Res> {
  factory _$MissionPreferencesRecordCopyWith(_MissionPreferencesRecord value, $Res Function(_MissionPreferencesRecord) _then) = __$MissionPreferencesRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'disabledCategories') List<String> disabledCategories,@JsonKey(name: 'boardPushTime') String? boardPushTime,@JsonKey(name: 'eveningCarryOver') bool eveningCarryOver,@JsonKey(name: 'defaultReminderMin') int? defaultReminderMin
});




}
/// @nodoc
class __$MissionPreferencesRecordCopyWithImpl<$Res>
    implements _$MissionPreferencesRecordCopyWith<$Res> {
  __$MissionPreferencesRecordCopyWithImpl(this._self, this._then);

  final _MissionPreferencesRecord _self;
  final $Res Function(_MissionPreferencesRecord) _then;

/// Create a copy of MissionPreferencesRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? disabledCategories = null,Object? boardPushTime = freezed,Object? eveningCarryOver = null,Object? defaultReminderMin = freezed,}) {
  return _then(_MissionPreferencesRecord(
disabledCategories: null == disabledCategories ? _self._disabledCategories : disabledCategories // ignore: cast_nullable_to_non_nullable
as List<String>,boardPushTime: freezed == boardPushTime ? _self.boardPushTime : boardPushTime // ignore: cast_nullable_to_non_nullable
as String?,eveningCarryOver: null == eveningCarryOver ? _self.eveningCarryOver : eveningCarryOver // ignore: cast_nullable_to_non_nullable
as bool,defaultReminderMin: freezed == defaultReminderMin ? _self.defaultReminderMin : defaultReminderMin // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
