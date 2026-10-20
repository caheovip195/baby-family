// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hearts_me_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HeartsMeRecord {

@JsonKey(name: 'today') int get today;@JsonKey(name: 'week') int get week;@JsonKey(name: 'total') int get total;@JsonKey(name: 'dailyCap') int? get dailyCap;@JsonKey(name: 'history') List<HeartHistoryRecord> get history;
/// Create a copy of HeartsMeRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeartsMeRecordCopyWith<HeartsMeRecord> get copyWith => _$HeartsMeRecordCopyWithImpl<HeartsMeRecord>(this as HeartsMeRecord, _$identity);

  /// Serializes this HeartsMeRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeartsMeRecord&&(identical(other.today, today) || other.today == today)&&(identical(other.week, week) || other.week == week)&&(identical(other.total, total) || other.total == total)&&(identical(other.dailyCap, dailyCap) || other.dailyCap == dailyCap)&&const DeepCollectionEquality().equals(other.history, history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,today,week,total,dailyCap,const DeepCollectionEquality().hash(history));

@override
String toString() {
  return 'HeartsMeRecord(today: $today, week: $week, total: $total, dailyCap: $dailyCap, history: $history)';
}


}

/// @nodoc
abstract mixin class $HeartsMeRecordCopyWith<$Res>  {
  factory $HeartsMeRecordCopyWith(HeartsMeRecord value, $Res Function(HeartsMeRecord) _then) = _$HeartsMeRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'today') int today,@JsonKey(name: 'week') int week,@JsonKey(name: 'total') int total,@JsonKey(name: 'dailyCap') int? dailyCap,@JsonKey(name: 'history') List<HeartHistoryRecord> history
});




}
/// @nodoc
class _$HeartsMeRecordCopyWithImpl<$Res>
    implements $HeartsMeRecordCopyWith<$Res> {
  _$HeartsMeRecordCopyWithImpl(this._self, this._then);

  final HeartsMeRecord _self;
  final $Res Function(HeartsMeRecord) _then;

/// Create a copy of HeartsMeRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? today = null,Object? week = null,Object? total = null,Object? dailyCap = freezed,Object? history = null,}) {
  return _then(_self.copyWith(
today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as int,week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,dailyCap: freezed == dailyCap ? _self.dailyCap : dailyCap // ignore: cast_nullable_to_non_nullable
as int?,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<HeartHistoryRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [HeartsMeRecord].
extension HeartsMeRecordPatterns on HeartsMeRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeartsMeRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeartsMeRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeartsMeRecord value)  $default,){
final _that = this;
switch (_that) {
case _HeartsMeRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeartsMeRecord value)?  $default,){
final _that = this;
switch (_that) {
case _HeartsMeRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _HeartsMeRecord implements HeartsMeRecord {
  const _HeartsMeRecord({@JsonKey(name: 'today') this.today = 0, @JsonKey(name: 'week') this.week = 0, @JsonKey(name: 'total') this.total = 0, @JsonKey(name: 'dailyCap') this.dailyCap, @JsonKey(name: 'history') final  List<HeartHistoryRecord> history = const <HeartHistoryRecord>[]}): _history = history;
  factory _HeartsMeRecord.fromJson(Map<String, dynamic> json) => _$HeartsMeRecordFromJson(json);

@override@JsonKey(name: 'today') final  int today;
@override@JsonKey(name: 'week') final  int week;
@override@JsonKey(name: 'total') final  int total;
@override@JsonKey(name: 'dailyCap') final  int? dailyCap;
 final  List<HeartHistoryRecord> _history;
@override@JsonKey(name: 'history') List<HeartHistoryRecord> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of HeartsMeRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeartsMeRecordCopyWith<_HeartsMeRecord> get copyWith => __$HeartsMeRecordCopyWithImpl<_HeartsMeRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeartsMeRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeartsMeRecord&&(identical(other.today, today) || other.today == today)&&(identical(other.week, week) || other.week == week)&&(identical(other.total, total) || other.total == total)&&(identical(other.dailyCap, dailyCap) || other.dailyCap == dailyCap)&&const DeepCollectionEquality().equals(other._history, _history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,today,week,total,dailyCap,const DeepCollectionEquality().hash(_history));

@override
String toString() {
  return 'HeartsMeRecord(today: $today, week: $week, total: $total, dailyCap: $dailyCap, history: $history)';
}


}

/// @nodoc
abstract mixin class _$HeartsMeRecordCopyWith<$Res> implements $HeartsMeRecordCopyWith<$Res> {
  factory _$HeartsMeRecordCopyWith(_HeartsMeRecord value, $Res Function(_HeartsMeRecord) _then) = __$HeartsMeRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'today') int today,@JsonKey(name: 'week') int week,@JsonKey(name: 'total') int total,@JsonKey(name: 'dailyCap') int? dailyCap,@JsonKey(name: 'history') List<HeartHistoryRecord> history
});




}
/// @nodoc
class __$HeartsMeRecordCopyWithImpl<$Res>
    implements _$HeartsMeRecordCopyWith<$Res> {
  __$HeartsMeRecordCopyWithImpl(this._self, this._then);

  final _HeartsMeRecord _self;
  final $Res Function(_HeartsMeRecord) _then;

/// Create a copy of HeartsMeRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? today = null,Object? week = null,Object? total = null,Object? dailyCap = freezed,Object? history = null,}) {
  return _then(_HeartsMeRecord(
today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as int,week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,dailyCap: freezed == dailyCap ? _self.dailyCap : dailyCap // ignore: cast_nullable_to_non_nullable
as int?,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<HeartHistoryRecord>,
  ));
}


}

// dart format on
