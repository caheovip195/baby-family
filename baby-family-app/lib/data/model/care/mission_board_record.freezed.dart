// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_board_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionBoardRecord {

@JsonKey(name: 'date') String? get date;@JsonKey(name: 'items') List<MissionRecord> get items;@JsonKey(name: 'myHeartsToday') int? get myHeartsToday;@JsonKey(name: 'swapsLeft') int? get swapsLeft;@JsonKey(name: 'openRequestCount') int get openRequestCount;
/// Create a copy of MissionBoardRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionBoardRecordCopyWith<MissionBoardRecord> get copyWith => _$MissionBoardRecordCopyWithImpl<MissionBoardRecord>(this as MissionBoardRecord, _$identity);

  /// Serializes this MissionBoardRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionBoardRecord&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.myHeartsToday, myHeartsToday) || other.myHeartsToday == myHeartsToday)&&(identical(other.swapsLeft, swapsLeft) || other.swapsLeft == swapsLeft)&&(identical(other.openRequestCount, openRequestCount) || other.openRequestCount == openRequestCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(items),myHeartsToday,swapsLeft,openRequestCount);

@override
String toString() {
  return 'MissionBoardRecord(date: $date, items: $items, myHeartsToday: $myHeartsToday, swapsLeft: $swapsLeft, openRequestCount: $openRequestCount)';
}


}

/// @nodoc
abstract mixin class $MissionBoardRecordCopyWith<$Res>  {
  factory $MissionBoardRecordCopyWith(MissionBoardRecord value, $Res Function(MissionBoardRecord) _then) = _$MissionBoardRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'date') String? date,@JsonKey(name: 'items') List<MissionRecord> items,@JsonKey(name: 'myHeartsToday') int? myHeartsToday,@JsonKey(name: 'swapsLeft') int? swapsLeft,@JsonKey(name: 'openRequestCount') int openRequestCount
});




}
/// @nodoc
class _$MissionBoardRecordCopyWithImpl<$Res>
    implements $MissionBoardRecordCopyWith<$Res> {
  _$MissionBoardRecordCopyWithImpl(this._self, this._then);

  final MissionBoardRecord _self;
  final $Res Function(MissionBoardRecord) _then;

/// Create a copy of MissionBoardRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = freezed,Object? items = null,Object? myHeartsToday = freezed,Object? swapsLeft = freezed,Object? openRequestCount = null,}) {
  return _then(_self.copyWith(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MissionRecord>,myHeartsToday: freezed == myHeartsToday ? _self.myHeartsToday : myHeartsToday // ignore: cast_nullable_to_non_nullable
as int?,swapsLeft: freezed == swapsLeft ? _self.swapsLeft : swapsLeft // ignore: cast_nullable_to_non_nullable
as int?,openRequestCount: null == openRequestCount ? _self.openRequestCount : openRequestCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionBoardRecord].
extension MissionBoardRecordPatterns on MissionBoardRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionBoardRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionBoardRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionBoardRecord value)  $default,){
final _that = this;
switch (_that) {
case _MissionBoardRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionBoardRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MissionBoardRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MissionBoardRecord implements MissionBoardRecord {
  const _MissionBoardRecord({@JsonKey(name: 'date') this.date, @JsonKey(name: 'items') final  List<MissionRecord> items = const <MissionRecord>[], @JsonKey(name: 'myHeartsToday') this.myHeartsToday, @JsonKey(name: 'swapsLeft') this.swapsLeft, @JsonKey(name: 'openRequestCount') this.openRequestCount = 0}): _items = items;
  factory _MissionBoardRecord.fromJson(Map<String, dynamic> json) => _$MissionBoardRecordFromJson(json);

@override@JsonKey(name: 'date') final  String? date;
 final  List<MissionRecord> _items;
@override@JsonKey(name: 'items') List<MissionRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'myHeartsToday') final  int? myHeartsToday;
@override@JsonKey(name: 'swapsLeft') final  int? swapsLeft;
@override@JsonKey(name: 'openRequestCount') final  int openRequestCount;

/// Create a copy of MissionBoardRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionBoardRecordCopyWith<_MissionBoardRecord> get copyWith => __$MissionBoardRecordCopyWithImpl<_MissionBoardRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionBoardRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionBoardRecord&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.myHeartsToday, myHeartsToday) || other.myHeartsToday == myHeartsToday)&&(identical(other.swapsLeft, swapsLeft) || other.swapsLeft == swapsLeft)&&(identical(other.openRequestCount, openRequestCount) || other.openRequestCount == openRequestCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(_items),myHeartsToday,swapsLeft,openRequestCount);

@override
String toString() {
  return 'MissionBoardRecord(date: $date, items: $items, myHeartsToday: $myHeartsToday, swapsLeft: $swapsLeft, openRequestCount: $openRequestCount)';
}


}

/// @nodoc
abstract mixin class _$MissionBoardRecordCopyWith<$Res> implements $MissionBoardRecordCopyWith<$Res> {
  factory _$MissionBoardRecordCopyWith(_MissionBoardRecord value, $Res Function(_MissionBoardRecord) _then) = __$MissionBoardRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'date') String? date,@JsonKey(name: 'items') List<MissionRecord> items,@JsonKey(name: 'myHeartsToday') int? myHeartsToday,@JsonKey(name: 'swapsLeft') int? swapsLeft,@JsonKey(name: 'openRequestCount') int openRequestCount
});




}
/// @nodoc
class __$MissionBoardRecordCopyWithImpl<$Res>
    implements _$MissionBoardRecordCopyWith<$Res> {
  __$MissionBoardRecordCopyWithImpl(this._self, this._then);

  final _MissionBoardRecord _self;
  final $Res Function(_MissionBoardRecord) _then;

/// Create a copy of MissionBoardRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = freezed,Object? items = null,Object? myHeartsToday = freezed,Object? swapsLeft = freezed,Object? openRequestCount = null,}) {
  return _then(_MissionBoardRecord(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MissionRecord>,myHeartsToday: freezed == myHeartsToday ? _self.myHeartsToday : myHeartsToday // ignore: cast_nullable_to_non_nullable
as int?,swapsLeft: freezed == swapsLeft ? _self.swapsLeft : swapsLeft // ignore: cast_nullable_to_non_nullable
as int?,openRequestCount: null == openRequestCount ? _self.openRequestCount : openRequestCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
