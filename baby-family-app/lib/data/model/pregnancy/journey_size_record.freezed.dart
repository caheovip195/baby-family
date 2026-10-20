// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey_size_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JourneySizeRecord {

@JsonKey(name: 'emoji') String? get emoji;@JsonKey(name: 'lengthCm') num? get lengthCm;@JsonKey(name: 'weightG') num? get weightG;@JsonKey(name: 'label') String? get label;
/// Create a copy of JourneySizeRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneySizeRecordCopyWith<JourneySizeRecord> get copyWith => _$JourneySizeRecordCopyWithImpl<JourneySizeRecord>(this as JourneySizeRecord, _$identity);

  /// Serializes this JourneySizeRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JourneySizeRecord&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.lengthCm, lengthCm) || other.lengthCm == lengthCm)&&(identical(other.weightG, weightG) || other.weightG == weightG)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,lengthCm,weightG,label);

@override
String toString() {
  return 'JourneySizeRecord(emoji: $emoji, lengthCm: $lengthCm, weightG: $weightG, label: $label)';
}


}

/// @nodoc
abstract mixin class $JourneySizeRecordCopyWith<$Res>  {
  factory $JourneySizeRecordCopyWith(JourneySizeRecord value, $Res Function(JourneySizeRecord) _then) = _$JourneySizeRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'emoji') String? emoji,@JsonKey(name: 'lengthCm') num? lengthCm,@JsonKey(name: 'weightG') num? weightG,@JsonKey(name: 'label') String? label
});




}
/// @nodoc
class _$JourneySizeRecordCopyWithImpl<$Res>
    implements $JourneySizeRecordCopyWith<$Res> {
  _$JourneySizeRecordCopyWithImpl(this._self, this._then);

  final JourneySizeRecord _self;
  final $Res Function(JourneySizeRecord) _then;

/// Create a copy of JourneySizeRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emoji = freezed,Object? lengthCm = freezed,Object? weightG = freezed,Object? label = freezed,}) {
  return _then(_self.copyWith(
emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,lengthCm: freezed == lengthCm ? _self.lengthCm : lengthCm // ignore: cast_nullable_to_non_nullable
as num?,weightG: freezed == weightG ? _self.weightG : weightG // ignore: cast_nullable_to_non_nullable
as num?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JourneySizeRecord].
extension JourneySizeRecordPatterns on JourneySizeRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JourneySizeRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JourneySizeRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JourneySizeRecord value)  $default,){
final _that = this;
switch (_that) {
case _JourneySizeRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JourneySizeRecord value)?  $default,){
final _that = this;
switch (_that) {
case _JourneySizeRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _JourneySizeRecord implements JourneySizeRecord {
  const _JourneySizeRecord({@JsonKey(name: 'emoji') this.emoji, @JsonKey(name: 'lengthCm') this.lengthCm, @JsonKey(name: 'weightG') this.weightG, @JsonKey(name: 'label') this.label});
  factory _JourneySizeRecord.fromJson(Map<String, dynamic> json) => _$JourneySizeRecordFromJson(json);

@override@JsonKey(name: 'emoji') final  String? emoji;
@override@JsonKey(name: 'lengthCm') final  num? lengthCm;
@override@JsonKey(name: 'weightG') final  num? weightG;
@override@JsonKey(name: 'label') final  String? label;

/// Create a copy of JourneySizeRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneySizeRecordCopyWith<_JourneySizeRecord> get copyWith => __$JourneySizeRecordCopyWithImpl<_JourneySizeRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JourneySizeRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JourneySizeRecord&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.lengthCm, lengthCm) || other.lengthCm == lengthCm)&&(identical(other.weightG, weightG) || other.weightG == weightG)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,lengthCm,weightG,label);

@override
String toString() {
  return 'JourneySizeRecord(emoji: $emoji, lengthCm: $lengthCm, weightG: $weightG, label: $label)';
}


}

/// @nodoc
abstract mixin class _$JourneySizeRecordCopyWith<$Res> implements $JourneySizeRecordCopyWith<$Res> {
  factory _$JourneySizeRecordCopyWith(_JourneySizeRecord value, $Res Function(_JourneySizeRecord) _then) = __$JourneySizeRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'emoji') String? emoji,@JsonKey(name: 'lengthCm') num? lengthCm,@JsonKey(name: 'weightG') num? weightG,@JsonKey(name: 'label') String? label
});




}
/// @nodoc
class __$JourneySizeRecordCopyWithImpl<$Res>
    implements _$JourneySizeRecordCopyWith<$Res> {
  __$JourneySizeRecordCopyWithImpl(this._self, this._then);

  final _JourneySizeRecord _self;
  final $Res Function(_JourneySizeRecord) _then;

/// Create a copy of JourneySizeRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emoji = freezed,Object? lengthCm = freezed,Object? weightG = freezed,Object? label = freezed,}) {
  return _then(_JourneySizeRecord(
emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,lengthCm: freezed == lengthCm ? _self.lengthCm : lengthCm // ignore: cast_nullable_to_non_nullable
as num?,weightG: freezed == weightG ? _self.weightG : weightG // ignore: cast_nullable_to_non_nullable
as num?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
