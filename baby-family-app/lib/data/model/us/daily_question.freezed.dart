// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyQuestion {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'date') DateTime get date;@JsonKey(name: 'text') String get text;@JsonKey(name: 'myAnswer') String? get myAnswer;@JsonKey(name: 'partnerAnswer') String? get partnerAnswer;@JsonKey(name: 'partnerAnswered') bool get partnerAnswered;
/// Create a copy of DailyQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyQuestionCopyWith<DailyQuestion> get copyWith => _$DailyQuestionCopyWithImpl<DailyQuestion>(this as DailyQuestion, _$identity);

  /// Serializes this DailyQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.text, text) || other.text == text)&&(identical(other.myAnswer, myAnswer) || other.myAnswer == myAnswer)&&(identical(other.partnerAnswer, partnerAnswer) || other.partnerAnswer == partnerAnswer)&&(identical(other.partnerAnswered, partnerAnswered) || other.partnerAnswered == partnerAnswered));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,text,myAnswer,partnerAnswer,partnerAnswered);

@override
String toString() {
  return 'DailyQuestion(id: $id, date: $date, text: $text, myAnswer: $myAnswer, partnerAnswer: $partnerAnswer, partnerAnswered: $partnerAnswered)';
}


}

/// @nodoc
abstract mixin class $DailyQuestionCopyWith<$Res>  {
  factory $DailyQuestionCopyWith(DailyQuestion value, $Res Function(DailyQuestion) _then) = _$DailyQuestionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'date') DateTime date,@JsonKey(name: 'text') String text,@JsonKey(name: 'myAnswer') String? myAnswer,@JsonKey(name: 'partnerAnswer') String? partnerAnswer,@JsonKey(name: 'partnerAnswered') bool partnerAnswered
});




}
/// @nodoc
class _$DailyQuestionCopyWithImpl<$Res>
    implements $DailyQuestionCopyWith<$Res> {
  _$DailyQuestionCopyWithImpl(this._self, this._then);

  final DailyQuestion _self;
  final $Res Function(DailyQuestion) _then;

/// Create a copy of DailyQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? text = null,Object? myAnswer = freezed,Object? partnerAnswer = freezed,Object? partnerAnswered = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,myAnswer: freezed == myAnswer ? _self.myAnswer : myAnswer // ignore: cast_nullable_to_non_nullable
as String?,partnerAnswer: freezed == partnerAnswer ? _self.partnerAnswer : partnerAnswer // ignore: cast_nullable_to_non_nullable
as String?,partnerAnswered: null == partnerAnswered ? _self.partnerAnswered : partnerAnswered // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyQuestion].
extension DailyQuestionPatterns on DailyQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyQuestion value)  $default,){
final _that = this;
switch (_that) {
case _DailyQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _DailyQuestion() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DailyQuestion implements DailyQuestion {
  const _DailyQuestion({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'date') required this.date, @JsonKey(name: 'text') required this.text, @JsonKey(name: 'myAnswer') this.myAnswer, @JsonKey(name: 'partnerAnswer') this.partnerAnswer, @JsonKey(name: 'partnerAnswered') this.partnerAnswered = false});
  factory _DailyQuestion.fromJson(Map<String, dynamic> json) => _$DailyQuestionFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'date') final  DateTime date;
@override@JsonKey(name: 'text') final  String text;
@override@JsonKey(name: 'myAnswer') final  String? myAnswer;
@override@JsonKey(name: 'partnerAnswer') final  String? partnerAnswer;
@override@JsonKey(name: 'partnerAnswered') final  bool partnerAnswered;

/// Create a copy of DailyQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyQuestionCopyWith<_DailyQuestion> get copyWith => __$DailyQuestionCopyWithImpl<_DailyQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.text, text) || other.text == text)&&(identical(other.myAnswer, myAnswer) || other.myAnswer == myAnswer)&&(identical(other.partnerAnswer, partnerAnswer) || other.partnerAnswer == partnerAnswer)&&(identical(other.partnerAnswered, partnerAnswered) || other.partnerAnswered == partnerAnswered));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,text,myAnswer,partnerAnswer,partnerAnswered);

@override
String toString() {
  return 'DailyQuestion(id: $id, date: $date, text: $text, myAnswer: $myAnswer, partnerAnswer: $partnerAnswer, partnerAnswered: $partnerAnswered)';
}


}

/// @nodoc
abstract mixin class _$DailyQuestionCopyWith<$Res> implements $DailyQuestionCopyWith<$Res> {
  factory _$DailyQuestionCopyWith(_DailyQuestion value, $Res Function(_DailyQuestion) _then) = __$DailyQuestionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'date') DateTime date,@JsonKey(name: 'text') String text,@JsonKey(name: 'myAnswer') String? myAnswer,@JsonKey(name: 'partnerAnswer') String? partnerAnswer,@JsonKey(name: 'partnerAnswered') bool partnerAnswered
});




}
/// @nodoc
class __$DailyQuestionCopyWithImpl<$Res>
    implements _$DailyQuestionCopyWith<$Res> {
  __$DailyQuestionCopyWithImpl(this._self, this._then);

  final _DailyQuestion _self;
  final $Res Function(_DailyQuestion) _then;

/// Create a copy of DailyQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? text = null,Object? myAnswer = freezed,Object? partnerAnswer = freezed,Object? partnerAnswered = null,}) {
  return _then(_DailyQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,myAnswer: freezed == myAnswer ? _self.myAnswer : myAnswer // ignore: cast_nullable_to_non_nullable
as String?,partnerAnswer: freezed == partnerAnswer ? _self.partnerAnswer : partnerAnswer // ignore: cast_nullable_to_non_nullable
as String?,partnerAnswered: null == partnerAnswered ? _self.partnerAnswered : partnerAnswered // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
