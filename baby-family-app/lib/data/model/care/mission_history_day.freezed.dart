// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_history_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionHistoryDay {

@JsonKey(name: 'date') DateTime get date;@JsonKey(name: 'entries') List<MissionHistoryEntry> get entries;
/// Create a copy of MissionHistoryDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionHistoryDayCopyWith<MissionHistoryDay> get copyWith => _$MissionHistoryDayCopyWithImpl<MissionHistoryDay>(this as MissionHistoryDay, _$identity);

  /// Serializes this MissionHistoryDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionHistoryDay&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.entries, entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(entries));

@override
String toString() {
  return 'MissionHistoryDay(date: $date, entries: $entries)';
}


}

/// @nodoc
abstract mixin class $MissionHistoryDayCopyWith<$Res>  {
  factory $MissionHistoryDayCopyWith(MissionHistoryDay value, $Res Function(MissionHistoryDay) _then) = _$MissionHistoryDayCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'date') DateTime date,@JsonKey(name: 'entries') List<MissionHistoryEntry> entries
});




}
/// @nodoc
class _$MissionHistoryDayCopyWithImpl<$Res>
    implements $MissionHistoryDayCopyWith<$Res> {
  _$MissionHistoryDayCopyWithImpl(this._self, this._then);

  final MissionHistoryDay _self;
  final $Res Function(MissionHistoryDay) _then;

/// Create a copy of MissionHistoryDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? entries = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<MissionHistoryEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionHistoryDay].
extension MissionHistoryDayPatterns on MissionHistoryDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionHistoryDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionHistoryDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionHistoryDay value)  $default,){
final _that = this;
switch (_that) {
case _MissionHistoryDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionHistoryDay value)?  $default,){
final _that = this;
switch (_that) {
case _MissionHistoryDay() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MissionHistoryDay implements MissionHistoryDay {
  const _MissionHistoryDay({@JsonKey(name: 'date') required this.date, @JsonKey(name: 'entries') final  List<MissionHistoryEntry> entries = const []}): _entries = entries;
  factory _MissionHistoryDay.fromJson(Map<String, dynamic> json) => _$MissionHistoryDayFromJson(json);

@override@JsonKey(name: 'date') final  DateTime date;
 final  List<MissionHistoryEntry> _entries;
@override@JsonKey(name: 'entries') List<MissionHistoryEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}


/// Create a copy of MissionHistoryDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionHistoryDayCopyWith<_MissionHistoryDay> get copyWith => __$MissionHistoryDayCopyWithImpl<_MissionHistoryDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionHistoryDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionHistoryDay&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._entries, _entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(_entries));

@override
String toString() {
  return 'MissionHistoryDay(date: $date, entries: $entries)';
}


}

/// @nodoc
abstract mixin class _$MissionHistoryDayCopyWith<$Res> implements $MissionHistoryDayCopyWith<$Res> {
  factory _$MissionHistoryDayCopyWith(_MissionHistoryDay value, $Res Function(_MissionHistoryDay) _then) = __$MissionHistoryDayCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'date') DateTime date,@JsonKey(name: 'entries') List<MissionHistoryEntry> entries
});




}
/// @nodoc
class __$MissionHistoryDayCopyWithImpl<$Res>
    implements _$MissionHistoryDayCopyWith<$Res> {
  __$MissionHistoryDayCopyWithImpl(this._self, this._then);

  final _MissionHistoryDay _self;
  final $Res Function(_MissionHistoryDay) _then;

/// Create a copy of MissionHistoryDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? entries = null,}) {
  return _then(_MissionHistoryDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<MissionHistoryEntry>,
  ));
}


}

// dart format on
