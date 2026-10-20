// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'heart_history_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HeartHistoryRecord {

@JsonKey(name: 'at') DateTime? get at;@JsonKey(name: 'amount') int get amount;@JsonKey(name: 'reason') String? get reason;@JsonKey(name: 'title') String? get title;
/// Create a copy of HeartHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeartHistoryRecordCopyWith<HeartHistoryRecord> get copyWith => _$HeartHistoryRecordCopyWithImpl<HeartHistoryRecord>(this as HeartHistoryRecord, _$identity);

  /// Serializes this HeartHistoryRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeartHistoryRecord&&(identical(other.at, at) || other.at == at)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,at,amount,reason,title);

@override
String toString() {
  return 'HeartHistoryRecord(at: $at, amount: $amount, reason: $reason, title: $title)';
}


}

/// @nodoc
abstract mixin class $HeartHistoryRecordCopyWith<$Res>  {
  factory $HeartHistoryRecordCopyWith(HeartHistoryRecord value, $Res Function(HeartHistoryRecord) _then) = _$HeartHistoryRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'at') DateTime? at,@JsonKey(name: 'amount') int amount,@JsonKey(name: 'reason') String? reason,@JsonKey(name: 'title') String? title
});




}
/// @nodoc
class _$HeartHistoryRecordCopyWithImpl<$Res>
    implements $HeartHistoryRecordCopyWith<$Res> {
  _$HeartHistoryRecordCopyWithImpl(this._self, this._then);

  final HeartHistoryRecord _self;
  final $Res Function(HeartHistoryRecord) _then;

/// Create a copy of HeartHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? at = freezed,Object? amount = null,Object? reason = freezed,Object? title = freezed,}) {
  return _then(_self.copyWith(
at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HeartHistoryRecord].
extension HeartHistoryRecordPatterns on HeartHistoryRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeartHistoryRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeartHistoryRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeartHistoryRecord value)  $default,){
final _that = this;
switch (_that) {
case _HeartHistoryRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeartHistoryRecord value)?  $default,){
final _that = this;
switch (_that) {
case _HeartHistoryRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _HeartHistoryRecord implements HeartHistoryRecord {
  const _HeartHistoryRecord({@JsonKey(name: 'at') this.at, @JsonKey(name: 'amount') this.amount = 0, @JsonKey(name: 'reason') this.reason, @JsonKey(name: 'title') this.title});
  factory _HeartHistoryRecord.fromJson(Map<String, dynamic> json) => _$HeartHistoryRecordFromJson(json);

@override@JsonKey(name: 'at') final  DateTime? at;
@override@JsonKey(name: 'amount') final  int amount;
@override@JsonKey(name: 'reason') final  String? reason;
@override@JsonKey(name: 'title') final  String? title;

/// Create a copy of HeartHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeartHistoryRecordCopyWith<_HeartHistoryRecord> get copyWith => __$HeartHistoryRecordCopyWithImpl<_HeartHistoryRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeartHistoryRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeartHistoryRecord&&(identical(other.at, at) || other.at == at)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,at,amount,reason,title);

@override
String toString() {
  return 'HeartHistoryRecord(at: $at, amount: $amount, reason: $reason, title: $title)';
}


}

/// @nodoc
abstract mixin class _$HeartHistoryRecordCopyWith<$Res> implements $HeartHistoryRecordCopyWith<$Res> {
  factory _$HeartHistoryRecordCopyWith(_HeartHistoryRecord value, $Res Function(_HeartHistoryRecord) _then) = __$HeartHistoryRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'at') DateTime? at,@JsonKey(name: 'amount') int amount,@JsonKey(name: 'reason') String? reason,@JsonKey(name: 'title') String? title
});




}
/// @nodoc
class __$HeartHistoryRecordCopyWithImpl<$Res>
    implements _$HeartHistoryRecordCopyWith<$Res> {
  __$HeartHistoryRecordCopyWithImpl(this._self, this._then);

  final _HeartHistoryRecord _self;
  final $Res Function(_HeartHistoryRecord) _then;

/// Create a copy of HeartHistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = freezed,Object? amount = null,Object? reason = freezed,Object? title = freezed,}) {
  return _then(_HeartHistoryRecord(
at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
