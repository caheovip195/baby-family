// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey_week_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JourneyWeekRecord {

@JsonKey(name: 'number') int? get number;@JsonKey(name: 'size') JourneySizeRecord? get size;@JsonKey(name: 'tip') String? get tip;
/// Create a copy of JourneyWeekRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneyWeekRecordCopyWith<JourneyWeekRecord> get copyWith => _$JourneyWeekRecordCopyWithImpl<JourneyWeekRecord>(this as JourneyWeekRecord, _$identity);

  /// Serializes this JourneyWeekRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JourneyWeekRecord&&(identical(other.number, number) || other.number == number)&&(identical(other.size, size) || other.size == size)&&(identical(other.tip, tip) || other.tip == tip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,size,tip);

@override
String toString() {
  return 'JourneyWeekRecord(number: $number, size: $size, tip: $tip)';
}


}

/// @nodoc
abstract mixin class $JourneyWeekRecordCopyWith<$Res>  {
  factory $JourneyWeekRecordCopyWith(JourneyWeekRecord value, $Res Function(JourneyWeekRecord) _then) = _$JourneyWeekRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'number') int? number,@JsonKey(name: 'size') JourneySizeRecord? size,@JsonKey(name: 'tip') String? tip
});


$JourneySizeRecordCopyWith<$Res>? get size;

}
/// @nodoc
class _$JourneyWeekRecordCopyWithImpl<$Res>
    implements $JourneyWeekRecordCopyWith<$Res> {
  _$JourneyWeekRecordCopyWithImpl(this._self, this._then);

  final JourneyWeekRecord _self;
  final $Res Function(JourneyWeekRecord) _then;

/// Create a copy of JourneyWeekRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = freezed,Object? size = freezed,Object? tip = freezed,}) {
  return _then(_self.copyWith(
number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as JourneySizeRecord?,tip: freezed == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of JourneyWeekRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JourneySizeRecordCopyWith<$Res>? get size {
    if (_self.size == null) {
    return null;
  }

  return $JourneySizeRecordCopyWith<$Res>(_self.size!, (value) {
    return _then(_self.copyWith(size: value));
  });
}
}


/// Adds pattern-matching-related methods to [JourneyWeekRecord].
extension JourneyWeekRecordPatterns on JourneyWeekRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JourneyWeekRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JourneyWeekRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JourneyWeekRecord value)  $default,){
final _that = this;
switch (_that) {
case _JourneyWeekRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JourneyWeekRecord value)?  $default,){
final _that = this;
switch (_that) {
case _JourneyWeekRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _JourneyWeekRecord implements JourneyWeekRecord {
  const _JourneyWeekRecord({@JsonKey(name: 'number') this.number, @JsonKey(name: 'size') this.size, @JsonKey(name: 'tip') this.tip});
  factory _JourneyWeekRecord.fromJson(Map<String, dynamic> json) => _$JourneyWeekRecordFromJson(json);

@override@JsonKey(name: 'number') final  int? number;
@override@JsonKey(name: 'size') final  JourneySizeRecord? size;
@override@JsonKey(name: 'tip') final  String? tip;

/// Create a copy of JourneyWeekRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneyWeekRecordCopyWith<_JourneyWeekRecord> get copyWith => __$JourneyWeekRecordCopyWithImpl<_JourneyWeekRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JourneyWeekRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JourneyWeekRecord&&(identical(other.number, number) || other.number == number)&&(identical(other.size, size) || other.size == size)&&(identical(other.tip, tip) || other.tip == tip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,size,tip);

@override
String toString() {
  return 'JourneyWeekRecord(number: $number, size: $size, tip: $tip)';
}


}

/// @nodoc
abstract mixin class _$JourneyWeekRecordCopyWith<$Res> implements $JourneyWeekRecordCopyWith<$Res> {
  factory _$JourneyWeekRecordCopyWith(_JourneyWeekRecord value, $Res Function(_JourneyWeekRecord) _then) = __$JourneyWeekRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'number') int? number,@JsonKey(name: 'size') JourneySizeRecord? size,@JsonKey(name: 'tip') String? tip
});


@override $JourneySizeRecordCopyWith<$Res>? get size;

}
/// @nodoc
class __$JourneyWeekRecordCopyWithImpl<$Res>
    implements _$JourneyWeekRecordCopyWith<$Res> {
  __$JourneyWeekRecordCopyWithImpl(this._self, this._then);

  final _JourneyWeekRecord _self;
  final $Res Function(_JourneyWeekRecord) _then;

/// Create a copy of JourneyWeekRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = freezed,Object? size = freezed,Object? tip = freezed,}) {
  return _then(_JourneyWeekRecord(
number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as JourneySizeRecord?,tip: freezed == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of JourneyWeekRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JourneySizeRecordCopyWith<$Res>? get size {
    if (_self.size == null) {
    return null;
  }

  return $JourneySizeRecordCopyWith<$Res>(_self.size!, (value) {
    return _then(_self.copyWith(size: value));
  });
}
}

// dart format on
