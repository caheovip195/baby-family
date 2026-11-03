// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'couple_question_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoupleQuestionRecord {

@JsonKey(name: 'date') String? get date;@JsonKey(name: 'code') String? get code;@JsonKey(name: 'textI18n') Map<String, String> get textI18n;@JsonKey(name: 'myAnswer') String? get myAnswer;@JsonKey(name: 'partnerAnswered') bool get partnerAnswered;@JsonKey(name: 'partnerAnswer') String? get partnerAnswer;
/// Create a copy of CoupleQuestionRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoupleQuestionRecordCopyWith<CoupleQuestionRecord> get copyWith => _$CoupleQuestionRecordCopyWithImpl<CoupleQuestionRecord>(this as CoupleQuestionRecord, _$identity);

  /// Serializes this CoupleQuestionRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoupleQuestionRecord&&(identical(other.date, date) || other.date == date)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.textI18n, textI18n)&&(identical(other.myAnswer, myAnswer) || other.myAnswer == myAnswer)&&(identical(other.partnerAnswered, partnerAnswered) || other.partnerAnswered == partnerAnswered)&&(identical(other.partnerAnswer, partnerAnswer) || other.partnerAnswer == partnerAnswer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,code,const DeepCollectionEquality().hash(textI18n),myAnswer,partnerAnswered,partnerAnswer);

@override
String toString() {
  return 'CoupleQuestionRecord(date: $date, code: $code, textI18n: $textI18n, myAnswer: $myAnswer, partnerAnswered: $partnerAnswered, partnerAnswer: $partnerAnswer)';
}


}

/// @nodoc
abstract mixin class $CoupleQuestionRecordCopyWith<$Res>  {
  factory $CoupleQuestionRecordCopyWith(CoupleQuestionRecord value, $Res Function(CoupleQuestionRecord) _then) = _$CoupleQuestionRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'date') String? date,@JsonKey(name: 'code') String? code,@JsonKey(name: 'textI18n') Map<String, String> textI18n,@JsonKey(name: 'myAnswer') String? myAnswer,@JsonKey(name: 'partnerAnswered') bool partnerAnswered,@JsonKey(name: 'partnerAnswer') String? partnerAnswer
});




}
/// @nodoc
class _$CoupleQuestionRecordCopyWithImpl<$Res>
    implements $CoupleQuestionRecordCopyWith<$Res> {
  _$CoupleQuestionRecordCopyWithImpl(this._self, this._then);

  final CoupleQuestionRecord _self;
  final $Res Function(CoupleQuestionRecord) _then;

/// Create a copy of CoupleQuestionRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = freezed,Object? code = freezed,Object? textI18n = null,Object? myAnswer = freezed,Object? partnerAnswered = null,Object? partnerAnswer = freezed,}) {
  return _then(_self.copyWith(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,textI18n: null == textI18n ? _self.textI18n : textI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,myAnswer: freezed == myAnswer ? _self.myAnswer : myAnswer // ignore: cast_nullable_to_non_nullable
as String?,partnerAnswered: null == partnerAnswered ? _self.partnerAnswered : partnerAnswered // ignore: cast_nullable_to_non_nullable
as bool,partnerAnswer: freezed == partnerAnswer ? _self.partnerAnswer : partnerAnswer // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoupleQuestionRecord].
extension CoupleQuestionRecordPatterns on CoupleQuestionRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoupleQuestionRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoupleQuestionRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoupleQuestionRecord value)  $default,){
final _that = this;
switch (_that) {
case _CoupleQuestionRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoupleQuestionRecord value)?  $default,){
final _that = this;
switch (_that) {
case _CoupleQuestionRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CoupleQuestionRecord implements CoupleQuestionRecord {
  const _CoupleQuestionRecord({@JsonKey(name: 'date') this.date, @JsonKey(name: 'code') this.code, @JsonKey(name: 'textI18n') final  Map<String, String> textI18n = const <String, String>{}, @JsonKey(name: 'myAnswer') this.myAnswer, @JsonKey(name: 'partnerAnswered') this.partnerAnswered = false, @JsonKey(name: 'partnerAnswer') this.partnerAnswer}): _textI18n = textI18n;
  factory _CoupleQuestionRecord.fromJson(Map<String, dynamic> json) => _$CoupleQuestionRecordFromJson(json);

@override@JsonKey(name: 'date') final  String? date;
@override@JsonKey(name: 'code') final  String? code;
 final  Map<String, String> _textI18n;
@override@JsonKey(name: 'textI18n') Map<String, String> get textI18n {
  if (_textI18n is EqualUnmodifiableMapView) return _textI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_textI18n);
}

@override@JsonKey(name: 'myAnswer') final  String? myAnswer;
@override@JsonKey(name: 'partnerAnswered') final  bool partnerAnswered;
@override@JsonKey(name: 'partnerAnswer') final  String? partnerAnswer;

/// Create a copy of CoupleQuestionRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoupleQuestionRecordCopyWith<_CoupleQuestionRecord> get copyWith => __$CoupleQuestionRecordCopyWithImpl<_CoupleQuestionRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoupleQuestionRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoupleQuestionRecord&&(identical(other.date, date) || other.date == date)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._textI18n, _textI18n)&&(identical(other.myAnswer, myAnswer) || other.myAnswer == myAnswer)&&(identical(other.partnerAnswered, partnerAnswered) || other.partnerAnswered == partnerAnswered)&&(identical(other.partnerAnswer, partnerAnswer) || other.partnerAnswer == partnerAnswer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,code,const DeepCollectionEquality().hash(_textI18n),myAnswer,partnerAnswered,partnerAnswer);

@override
String toString() {
  return 'CoupleQuestionRecord(date: $date, code: $code, textI18n: $textI18n, myAnswer: $myAnswer, partnerAnswered: $partnerAnswered, partnerAnswer: $partnerAnswer)';
}


}

/// @nodoc
abstract mixin class _$CoupleQuestionRecordCopyWith<$Res> implements $CoupleQuestionRecordCopyWith<$Res> {
  factory _$CoupleQuestionRecordCopyWith(_CoupleQuestionRecord value, $Res Function(_CoupleQuestionRecord) _then) = __$CoupleQuestionRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'date') String? date,@JsonKey(name: 'code') String? code,@JsonKey(name: 'textI18n') Map<String, String> textI18n,@JsonKey(name: 'myAnswer') String? myAnswer,@JsonKey(name: 'partnerAnswered') bool partnerAnswered,@JsonKey(name: 'partnerAnswer') String? partnerAnswer
});




}
/// @nodoc
class __$CoupleQuestionRecordCopyWithImpl<$Res>
    implements _$CoupleQuestionRecordCopyWith<$Res> {
  __$CoupleQuestionRecordCopyWithImpl(this._self, this._then);

  final _CoupleQuestionRecord _self;
  final $Res Function(_CoupleQuestionRecord) _then;

/// Create a copy of CoupleQuestionRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = freezed,Object? code = freezed,Object? textI18n = null,Object? myAnswer = freezed,Object? partnerAnswered = null,Object? partnerAnswer = freezed,}) {
  return _then(_CoupleQuestionRecord(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,textI18n: null == textI18n ? _self._textI18n : textI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,myAnswer: freezed == myAnswer ? _self.myAnswer : myAnswer // ignore: cast_nullable_to_non_nullable
as String?,partnerAnswered: null == partnerAnswered ? _self.partnerAnswered : partnerAnswered // ignore: cast_nullable_to_non_nullable
as bool,partnerAnswer: freezed == partnerAnswer ? _self.partnerAnswer : partnerAnswer // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CoupleWeekRecord {

@JsonKey(name: 'weekStart') String? get weekStart;@JsonKey(name: 'weekEnd') String? get weekEnd;@JsonKey(name: 'checkins') int get checkins;@JsonKey(name: 'requestsHelped') int get requestsHelped;@JsonKey(name: 'thanks') int get thanks;@JsonKey(name: 'togetherMissions') int get togetherMissions;@JsonKey(name: 'together') List<CoupleWeekTogetherRecord> get together;
/// Create a copy of CoupleWeekRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoupleWeekRecordCopyWith<CoupleWeekRecord> get copyWith => _$CoupleWeekRecordCopyWithImpl<CoupleWeekRecord>(this as CoupleWeekRecord, _$identity);

  /// Serializes this CoupleWeekRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoupleWeekRecord&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd)&&(identical(other.checkins, checkins) || other.checkins == checkins)&&(identical(other.requestsHelped, requestsHelped) || other.requestsHelped == requestsHelped)&&(identical(other.thanks, thanks) || other.thanks == thanks)&&(identical(other.togetherMissions, togetherMissions) || other.togetherMissions == togetherMissions)&&const DeepCollectionEquality().equals(other.together, together));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weekStart,weekEnd,checkins,requestsHelped,thanks,togetherMissions,const DeepCollectionEquality().hash(together));

@override
String toString() {
  return 'CoupleWeekRecord(weekStart: $weekStart, weekEnd: $weekEnd, checkins: $checkins, requestsHelped: $requestsHelped, thanks: $thanks, togetherMissions: $togetherMissions, together: $together)';
}


}

/// @nodoc
abstract mixin class $CoupleWeekRecordCopyWith<$Res>  {
  factory $CoupleWeekRecordCopyWith(CoupleWeekRecord value, $Res Function(CoupleWeekRecord) _then) = _$CoupleWeekRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'weekStart') String? weekStart,@JsonKey(name: 'weekEnd') String? weekEnd,@JsonKey(name: 'checkins') int checkins,@JsonKey(name: 'requestsHelped') int requestsHelped,@JsonKey(name: 'thanks') int thanks,@JsonKey(name: 'togetherMissions') int togetherMissions,@JsonKey(name: 'together') List<CoupleWeekTogetherRecord> together
});




}
/// @nodoc
class _$CoupleWeekRecordCopyWithImpl<$Res>
    implements $CoupleWeekRecordCopyWith<$Res> {
  _$CoupleWeekRecordCopyWithImpl(this._self, this._then);

  final CoupleWeekRecord _self;
  final $Res Function(CoupleWeekRecord) _then;

/// Create a copy of CoupleWeekRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekStart = freezed,Object? weekEnd = freezed,Object? checkins = null,Object? requestsHelped = null,Object? thanks = null,Object? togetherMissions = null,Object? together = null,}) {
  return _then(_self.copyWith(
weekStart: freezed == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as String?,weekEnd: freezed == weekEnd ? _self.weekEnd : weekEnd // ignore: cast_nullable_to_non_nullable
as String?,checkins: null == checkins ? _self.checkins : checkins // ignore: cast_nullable_to_non_nullable
as int,requestsHelped: null == requestsHelped ? _self.requestsHelped : requestsHelped // ignore: cast_nullable_to_non_nullable
as int,thanks: null == thanks ? _self.thanks : thanks // ignore: cast_nullable_to_non_nullable
as int,togetherMissions: null == togetherMissions ? _self.togetherMissions : togetherMissions // ignore: cast_nullable_to_non_nullable
as int,together: null == together ? _self.together : together // ignore: cast_nullable_to_non_nullable
as List<CoupleWeekTogetherRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [CoupleWeekRecord].
extension CoupleWeekRecordPatterns on CoupleWeekRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoupleWeekRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoupleWeekRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoupleWeekRecord value)  $default,){
final _that = this;
switch (_that) {
case _CoupleWeekRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoupleWeekRecord value)?  $default,){
final _that = this;
switch (_that) {
case _CoupleWeekRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CoupleWeekRecord implements CoupleWeekRecord {
  const _CoupleWeekRecord({@JsonKey(name: 'weekStart') this.weekStart, @JsonKey(name: 'weekEnd') this.weekEnd, @JsonKey(name: 'checkins') this.checkins = 0, @JsonKey(name: 'requestsHelped') this.requestsHelped = 0, @JsonKey(name: 'thanks') this.thanks = 0, @JsonKey(name: 'togetherMissions') this.togetherMissions = 0, @JsonKey(name: 'together') final  List<CoupleWeekTogetherRecord> together = const <CoupleWeekTogetherRecord>[]}): _together = together;
  factory _CoupleWeekRecord.fromJson(Map<String, dynamic> json) => _$CoupleWeekRecordFromJson(json);

@override@JsonKey(name: 'weekStart') final  String? weekStart;
@override@JsonKey(name: 'weekEnd') final  String? weekEnd;
@override@JsonKey(name: 'checkins') final  int checkins;
@override@JsonKey(name: 'requestsHelped') final  int requestsHelped;
@override@JsonKey(name: 'thanks') final  int thanks;
@override@JsonKey(name: 'togetherMissions') final  int togetherMissions;
 final  List<CoupleWeekTogetherRecord> _together;
@override@JsonKey(name: 'together') List<CoupleWeekTogetherRecord> get together {
  if (_together is EqualUnmodifiableListView) return _together;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_together);
}


/// Create a copy of CoupleWeekRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoupleWeekRecordCopyWith<_CoupleWeekRecord> get copyWith => __$CoupleWeekRecordCopyWithImpl<_CoupleWeekRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoupleWeekRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoupleWeekRecord&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd)&&(identical(other.checkins, checkins) || other.checkins == checkins)&&(identical(other.requestsHelped, requestsHelped) || other.requestsHelped == requestsHelped)&&(identical(other.thanks, thanks) || other.thanks == thanks)&&(identical(other.togetherMissions, togetherMissions) || other.togetherMissions == togetherMissions)&&const DeepCollectionEquality().equals(other._together, _together));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weekStart,weekEnd,checkins,requestsHelped,thanks,togetherMissions,const DeepCollectionEquality().hash(_together));

@override
String toString() {
  return 'CoupleWeekRecord(weekStart: $weekStart, weekEnd: $weekEnd, checkins: $checkins, requestsHelped: $requestsHelped, thanks: $thanks, togetherMissions: $togetherMissions, together: $together)';
}


}

/// @nodoc
abstract mixin class _$CoupleWeekRecordCopyWith<$Res> implements $CoupleWeekRecordCopyWith<$Res> {
  factory _$CoupleWeekRecordCopyWith(_CoupleWeekRecord value, $Res Function(_CoupleWeekRecord) _then) = __$CoupleWeekRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'weekStart') String? weekStart,@JsonKey(name: 'weekEnd') String? weekEnd,@JsonKey(name: 'checkins') int checkins,@JsonKey(name: 'requestsHelped') int requestsHelped,@JsonKey(name: 'thanks') int thanks,@JsonKey(name: 'togetherMissions') int togetherMissions,@JsonKey(name: 'together') List<CoupleWeekTogetherRecord> together
});




}
/// @nodoc
class __$CoupleWeekRecordCopyWithImpl<$Res>
    implements _$CoupleWeekRecordCopyWith<$Res> {
  __$CoupleWeekRecordCopyWithImpl(this._self, this._then);

  final _CoupleWeekRecord _self;
  final $Res Function(_CoupleWeekRecord) _then;

/// Create a copy of CoupleWeekRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekStart = freezed,Object? weekEnd = freezed,Object? checkins = null,Object? requestsHelped = null,Object? thanks = null,Object? togetherMissions = null,Object? together = null,}) {
  return _then(_CoupleWeekRecord(
weekStart: freezed == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as String?,weekEnd: freezed == weekEnd ? _self.weekEnd : weekEnd // ignore: cast_nullable_to_non_nullable
as String?,checkins: null == checkins ? _self.checkins : checkins // ignore: cast_nullable_to_non_nullable
as int,requestsHelped: null == requestsHelped ? _self.requestsHelped : requestsHelped // ignore: cast_nullable_to_non_nullable
as int,thanks: null == thanks ? _self.thanks : thanks // ignore: cast_nullable_to_non_nullable
as int,togetherMissions: null == togetherMissions ? _self.togetherMissions : togetherMissions // ignore: cast_nullable_to_non_nullable
as int,together: null == together ? _self._together : together // ignore: cast_nullable_to_non_nullable
as List<CoupleWeekTogetherRecord>,
  ));
}


}


/// @nodoc
mixin _$CoupleWeekTogetherRecord {

@JsonKey(name: 'title') String? get title;@JsonKey(name: 'date') DateTime? get date;
/// Create a copy of CoupleWeekTogetherRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoupleWeekTogetherRecordCopyWith<CoupleWeekTogetherRecord> get copyWith => _$CoupleWeekTogetherRecordCopyWithImpl<CoupleWeekTogetherRecord>(this as CoupleWeekTogetherRecord, _$identity);

  /// Serializes this CoupleWeekTogetherRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoupleWeekTogetherRecord&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,date);

@override
String toString() {
  return 'CoupleWeekTogetherRecord(title: $title, date: $date)';
}


}

/// @nodoc
abstract mixin class $CoupleWeekTogetherRecordCopyWith<$Res>  {
  factory $CoupleWeekTogetherRecordCopyWith(CoupleWeekTogetherRecord value, $Res Function(CoupleWeekTogetherRecord) _then) = _$CoupleWeekTogetherRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'title') String? title,@JsonKey(name: 'date') DateTime? date
});




}
/// @nodoc
class _$CoupleWeekTogetherRecordCopyWithImpl<$Res>
    implements $CoupleWeekTogetherRecordCopyWith<$Res> {
  _$CoupleWeekTogetherRecordCopyWithImpl(this._self, this._then);

  final CoupleWeekTogetherRecord _self;
  final $Res Function(CoupleWeekTogetherRecord) _then;

/// Create a copy of CoupleWeekTogetherRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? date = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoupleWeekTogetherRecord].
extension CoupleWeekTogetherRecordPatterns on CoupleWeekTogetherRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoupleWeekTogetherRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoupleWeekTogetherRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoupleWeekTogetherRecord value)  $default,){
final _that = this;
switch (_that) {
case _CoupleWeekTogetherRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoupleWeekTogetherRecord value)?  $default,){
final _that = this;
switch (_that) {
case _CoupleWeekTogetherRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CoupleWeekTogetherRecord implements CoupleWeekTogetherRecord {
  const _CoupleWeekTogetherRecord({@JsonKey(name: 'title') this.title, @JsonKey(name: 'date') this.date});
  factory _CoupleWeekTogetherRecord.fromJson(Map<String, dynamic> json) => _$CoupleWeekTogetherRecordFromJson(json);

@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'date') final  DateTime? date;

/// Create a copy of CoupleWeekTogetherRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoupleWeekTogetherRecordCopyWith<_CoupleWeekTogetherRecord> get copyWith => __$CoupleWeekTogetherRecordCopyWithImpl<_CoupleWeekTogetherRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoupleWeekTogetherRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoupleWeekTogetherRecord&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,date);

@override
String toString() {
  return 'CoupleWeekTogetherRecord(title: $title, date: $date)';
}


}

/// @nodoc
abstract mixin class _$CoupleWeekTogetherRecordCopyWith<$Res> implements $CoupleWeekTogetherRecordCopyWith<$Res> {
  factory _$CoupleWeekTogetherRecordCopyWith(_CoupleWeekTogetherRecord value, $Res Function(_CoupleWeekTogetherRecord) _then) = __$CoupleWeekTogetherRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'title') String? title,@JsonKey(name: 'date') DateTime? date
});




}
/// @nodoc
class __$CoupleWeekTogetherRecordCopyWithImpl<$Res>
    implements _$CoupleWeekTogetherRecordCopyWith<$Res> {
  __$CoupleWeekTogetherRecordCopyWithImpl(this._self, this._then);

  final _CoupleWeekTogetherRecord _self;
  final $Res Function(_CoupleWeekTogetherRecord) _then;

/// Create a copy of CoupleWeekTogetherRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? date = freezed,}) {
  return _then(_CoupleWeekTogetherRecord(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
