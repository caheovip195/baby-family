// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge_progress_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BadgeProgressRecord {

@JsonKey(name: 'current') int get current;@JsonKey(name: 'target') int get target;@JsonKey(name: 'percent') int get percent;
/// Create a copy of BadgeProgressRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadgeProgressRecordCopyWith<BadgeProgressRecord> get copyWith => _$BadgeProgressRecordCopyWithImpl<BadgeProgressRecord>(this as BadgeProgressRecord, _$identity);

  /// Serializes this BadgeProgressRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadgeProgressRecord&&(identical(other.current, current) || other.current == current)&&(identical(other.target, target) || other.target == target)&&(identical(other.percent, percent) || other.percent == percent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,current,target,percent);

@override
String toString() {
  return 'BadgeProgressRecord(current: $current, target: $target, percent: $percent)';
}


}

/// @nodoc
abstract mixin class $BadgeProgressRecordCopyWith<$Res>  {
  factory $BadgeProgressRecordCopyWith(BadgeProgressRecord value, $Res Function(BadgeProgressRecord) _then) = _$BadgeProgressRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'current') int current,@JsonKey(name: 'target') int target,@JsonKey(name: 'percent') int percent
});




}
/// @nodoc
class _$BadgeProgressRecordCopyWithImpl<$Res>
    implements $BadgeProgressRecordCopyWith<$Res> {
  _$BadgeProgressRecordCopyWithImpl(this._self, this._then);

  final BadgeProgressRecord _self;
  final $Res Function(BadgeProgressRecord) _then;

/// Create a copy of BadgeProgressRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = null,Object? target = null,Object? percent = null,}) {
  return _then(_self.copyWith(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BadgeProgressRecord].
extension BadgeProgressRecordPatterns on BadgeProgressRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BadgeProgressRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BadgeProgressRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BadgeProgressRecord value)  $default,){
final _that = this;
switch (_that) {
case _BadgeProgressRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BadgeProgressRecord value)?  $default,){
final _that = this;
switch (_that) {
case _BadgeProgressRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BadgeProgressRecord implements BadgeProgressRecord {
  const _BadgeProgressRecord({@JsonKey(name: 'current') this.current = 0, @JsonKey(name: 'target') this.target = 0, @JsonKey(name: 'percent') this.percent = 0});
  factory _BadgeProgressRecord.fromJson(Map<String, dynamic> json) => _$BadgeProgressRecordFromJson(json);

@override@JsonKey(name: 'current') final  int current;
@override@JsonKey(name: 'target') final  int target;
@override@JsonKey(name: 'percent') final  int percent;

/// Create a copy of BadgeProgressRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BadgeProgressRecordCopyWith<_BadgeProgressRecord> get copyWith => __$BadgeProgressRecordCopyWithImpl<_BadgeProgressRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BadgeProgressRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BadgeProgressRecord&&(identical(other.current, current) || other.current == current)&&(identical(other.target, target) || other.target == target)&&(identical(other.percent, percent) || other.percent == percent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,current,target,percent);

@override
String toString() {
  return 'BadgeProgressRecord(current: $current, target: $target, percent: $percent)';
}


}

/// @nodoc
abstract mixin class _$BadgeProgressRecordCopyWith<$Res> implements $BadgeProgressRecordCopyWith<$Res> {
  factory _$BadgeProgressRecordCopyWith(_BadgeProgressRecord value, $Res Function(_BadgeProgressRecord) _then) = __$BadgeProgressRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'current') int current,@JsonKey(name: 'target') int target,@JsonKey(name: 'percent') int percent
});




}
/// @nodoc
class __$BadgeProgressRecordCopyWithImpl<$Res>
    implements _$BadgeProgressRecordCopyWith<$Res> {
  __$BadgeProgressRecordCopyWithImpl(this._self, this._then);

  final _BadgeProgressRecord _self;
  final $Res Function(_BadgeProgressRecord) _then;

/// Create a copy of BadgeProgressRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = null,Object? target = null,Object? percent = null,}) {
  return _then(_BadgeProgressRecord(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
