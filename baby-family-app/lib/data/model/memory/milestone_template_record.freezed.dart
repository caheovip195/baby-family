// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'milestone_template_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MilestoneTemplateRecord {

@JsonKey(name: 'code') String? get code;@JsonKey(name: 'suggestedDate') DateTime? get suggestedDate;@JsonKey(name: 'achieved') MilestoneAchievedRecord? get achieved;
/// Create a copy of MilestoneTemplateRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MilestoneTemplateRecordCopyWith<MilestoneTemplateRecord> get copyWith => _$MilestoneTemplateRecordCopyWithImpl<MilestoneTemplateRecord>(this as MilestoneTemplateRecord, _$identity);

  /// Serializes this MilestoneTemplateRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MilestoneTemplateRecord&&(identical(other.code, code) || other.code == code)&&(identical(other.suggestedDate, suggestedDate) || other.suggestedDate == suggestedDate)&&(identical(other.achieved, achieved) || other.achieved == achieved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,suggestedDate,achieved);

@override
String toString() {
  return 'MilestoneTemplateRecord(code: $code, suggestedDate: $suggestedDate, achieved: $achieved)';
}


}

/// @nodoc
abstract mixin class $MilestoneTemplateRecordCopyWith<$Res>  {
  factory $MilestoneTemplateRecordCopyWith(MilestoneTemplateRecord value, $Res Function(MilestoneTemplateRecord) _then) = _$MilestoneTemplateRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String? code,@JsonKey(name: 'suggestedDate') DateTime? suggestedDate,@JsonKey(name: 'achieved') MilestoneAchievedRecord? achieved
});


$MilestoneAchievedRecordCopyWith<$Res>? get achieved;

}
/// @nodoc
class _$MilestoneTemplateRecordCopyWithImpl<$Res>
    implements $MilestoneTemplateRecordCopyWith<$Res> {
  _$MilestoneTemplateRecordCopyWithImpl(this._self, this._then);

  final MilestoneTemplateRecord _self;
  final $Res Function(MilestoneTemplateRecord) _then;

/// Create a copy of MilestoneTemplateRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = freezed,Object? suggestedDate = freezed,Object? achieved = freezed,}) {
  return _then(_self.copyWith(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,suggestedDate: freezed == suggestedDate ? _self.suggestedDate : suggestedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,achieved: freezed == achieved ? _self.achieved : achieved // ignore: cast_nullable_to_non_nullable
as MilestoneAchievedRecord?,
  ));
}
/// Create a copy of MilestoneTemplateRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MilestoneAchievedRecordCopyWith<$Res>? get achieved {
    if (_self.achieved == null) {
    return null;
  }

  return $MilestoneAchievedRecordCopyWith<$Res>(_self.achieved!, (value) {
    return _then(_self.copyWith(achieved: value));
  });
}
}


/// Adds pattern-matching-related methods to [MilestoneTemplateRecord].
extension MilestoneTemplateRecordPatterns on MilestoneTemplateRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MilestoneTemplateRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MilestoneTemplateRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MilestoneTemplateRecord value)  $default,){
final _that = this;
switch (_that) {
case _MilestoneTemplateRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MilestoneTemplateRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MilestoneTemplateRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MilestoneTemplateRecord implements MilestoneTemplateRecord {
  const _MilestoneTemplateRecord({@JsonKey(name: 'code') this.code, @JsonKey(name: 'suggestedDate') this.suggestedDate, @JsonKey(name: 'achieved') this.achieved});
  factory _MilestoneTemplateRecord.fromJson(Map<String, dynamic> json) => _$MilestoneTemplateRecordFromJson(json);

@override@JsonKey(name: 'code') final  String? code;
@override@JsonKey(name: 'suggestedDate') final  DateTime? suggestedDate;
@override@JsonKey(name: 'achieved') final  MilestoneAchievedRecord? achieved;

/// Create a copy of MilestoneTemplateRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MilestoneTemplateRecordCopyWith<_MilestoneTemplateRecord> get copyWith => __$MilestoneTemplateRecordCopyWithImpl<_MilestoneTemplateRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MilestoneTemplateRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MilestoneTemplateRecord&&(identical(other.code, code) || other.code == code)&&(identical(other.suggestedDate, suggestedDate) || other.suggestedDate == suggestedDate)&&(identical(other.achieved, achieved) || other.achieved == achieved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,suggestedDate,achieved);

@override
String toString() {
  return 'MilestoneTemplateRecord(code: $code, suggestedDate: $suggestedDate, achieved: $achieved)';
}


}

/// @nodoc
abstract mixin class _$MilestoneTemplateRecordCopyWith<$Res> implements $MilestoneTemplateRecordCopyWith<$Res> {
  factory _$MilestoneTemplateRecordCopyWith(_MilestoneTemplateRecord value, $Res Function(_MilestoneTemplateRecord) _then) = __$MilestoneTemplateRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String? code,@JsonKey(name: 'suggestedDate') DateTime? suggestedDate,@JsonKey(name: 'achieved') MilestoneAchievedRecord? achieved
});


@override $MilestoneAchievedRecordCopyWith<$Res>? get achieved;

}
/// @nodoc
class __$MilestoneTemplateRecordCopyWithImpl<$Res>
    implements _$MilestoneTemplateRecordCopyWith<$Res> {
  __$MilestoneTemplateRecordCopyWithImpl(this._self, this._then);

  final _MilestoneTemplateRecord _self;
  final $Res Function(_MilestoneTemplateRecord) _then;

/// Create a copy of MilestoneTemplateRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? suggestedDate = freezed,Object? achieved = freezed,}) {
  return _then(_MilestoneTemplateRecord(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,suggestedDate: freezed == suggestedDate ? _self.suggestedDate : suggestedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,achieved: freezed == achieved ? _self.achieved : achieved // ignore: cast_nullable_to_non_nullable
as MilestoneAchievedRecord?,
  ));
}

/// Create a copy of MilestoneTemplateRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MilestoneAchievedRecordCopyWith<$Res>? get achieved {
    if (_self.achieved == null) {
    return null;
  }

  return $MilestoneAchievedRecordCopyWith<$Res>(_self.achieved!, (value) {
    return _then(_self.copyWith(achieved: value));
  });
}
}

// dart format on
