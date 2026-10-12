// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bridge_next_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BridgeNextStep {

@JsonKey(name: 'code') String get code;@JsonKey(name: 'whenLabel') String? get whenLabel;@JsonKey(name: 'at') DateTime? get at;@JsonKey(name: 'childIds') List<String> get childIds;@JsonKey(name: 'reminder') bool get reminder;@JsonKey(name: 'reminderAt') DateTime? get reminderAt;@JsonKey(name: 'agreedUserIds') List<String> get agreedUserIds;
/// Create a copy of BridgeNextStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BridgeNextStepCopyWith<BridgeNextStep> get copyWith => _$BridgeNextStepCopyWithImpl<BridgeNextStep>(this as BridgeNextStep, _$identity);

  /// Serializes this BridgeNextStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BridgeNextStep&&(identical(other.code, code) || other.code == code)&&(identical(other.whenLabel, whenLabel) || other.whenLabel == whenLabel)&&(identical(other.at, at) || other.at == at)&&const DeepCollectionEquality().equals(other.childIds, childIds)&&(identical(other.reminder, reminder) || other.reminder == reminder)&&(identical(other.reminderAt, reminderAt) || other.reminderAt == reminderAt)&&const DeepCollectionEquality().equals(other.agreedUserIds, agreedUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,whenLabel,at,const DeepCollectionEquality().hash(childIds),reminder,reminderAt,const DeepCollectionEquality().hash(agreedUserIds));

@override
String toString() {
  return 'BridgeNextStep(code: $code, whenLabel: $whenLabel, at: $at, childIds: $childIds, reminder: $reminder, reminderAt: $reminderAt, agreedUserIds: $agreedUserIds)';
}


}

/// @nodoc
abstract mixin class $BridgeNextStepCopyWith<$Res>  {
  factory $BridgeNextStepCopyWith(BridgeNextStep value, $Res Function(BridgeNextStep) _then) = _$BridgeNextStepCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'whenLabel') String? whenLabel,@JsonKey(name: 'at') DateTime? at,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'reminder') bool reminder,@JsonKey(name: 'reminderAt') DateTime? reminderAt,@JsonKey(name: 'agreedUserIds') List<String> agreedUserIds
});




}
/// @nodoc
class _$BridgeNextStepCopyWithImpl<$Res>
    implements $BridgeNextStepCopyWith<$Res> {
  _$BridgeNextStepCopyWithImpl(this._self, this._then);

  final BridgeNextStep _self;
  final $Res Function(BridgeNextStep) _then;

/// Create a copy of BridgeNextStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? whenLabel = freezed,Object? at = freezed,Object? childIds = null,Object? reminder = null,Object? reminderAt = freezed,Object? agreedUserIds = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,whenLabel: freezed == whenLabel ? _self.whenLabel : whenLabel // ignore: cast_nullable_to_non_nullable
as String?,at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,reminder: null == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as bool,reminderAt: freezed == reminderAt ? _self.reminderAt : reminderAt // ignore: cast_nullable_to_non_nullable
as DateTime?,agreedUserIds: null == agreedUserIds ? _self.agreedUserIds : agreedUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [BridgeNextStep].
extension BridgeNextStepPatterns on BridgeNextStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BridgeNextStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BridgeNextStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BridgeNextStep value)  $default,){
final _that = this;
switch (_that) {
case _BridgeNextStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BridgeNextStep value)?  $default,){
final _that = this;
switch (_that) {
case _BridgeNextStep() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BridgeNextStep implements BridgeNextStep {
  const _BridgeNextStep({@JsonKey(name: 'code') required this.code, @JsonKey(name: 'whenLabel') this.whenLabel, @JsonKey(name: 'at') this.at, @JsonKey(name: 'childIds') final  List<String> childIds = const [], @JsonKey(name: 'reminder') this.reminder = true, @JsonKey(name: 'reminderAt') this.reminderAt, @JsonKey(name: 'agreedUserIds') final  List<String> agreedUserIds = const []}): _childIds = childIds,_agreedUserIds = agreedUserIds;
  factory _BridgeNextStep.fromJson(Map<String, dynamic> json) => _$BridgeNextStepFromJson(json);

@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'whenLabel') final  String? whenLabel;
@override@JsonKey(name: 'at') final  DateTime? at;
 final  List<String> _childIds;
@override@JsonKey(name: 'childIds') List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}

@override@JsonKey(name: 'reminder') final  bool reminder;
@override@JsonKey(name: 'reminderAt') final  DateTime? reminderAt;
 final  List<String> _agreedUserIds;
@override@JsonKey(name: 'agreedUserIds') List<String> get agreedUserIds {
  if (_agreedUserIds is EqualUnmodifiableListView) return _agreedUserIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_agreedUserIds);
}


/// Create a copy of BridgeNextStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BridgeNextStepCopyWith<_BridgeNextStep> get copyWith => __$BridgeNextStepCopyWithImpl<_BridgeNextStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BridgeNextStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BridgeNextStep&&(identical(other.code, code) || other.code == code)&&(identical(other.whenLabel, whenLabel) || other.whenLabel == whenLabel)&&(identical(other.at, at) || other.at == at)&&const DeepCollectionEquality().equals(other._childIds, _childIds)&&(identical(other.reminder, reminder) || other.reminder == reminder)&&(identical(other.reminderAt, reminderAt) || other.reminderAt == reminderAt)&&const DeepCollectionEquality().equals(other._agreedUserIds, _agreedUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,whenLabel,at,const DeepCollectionEquality().hash(_childIds),reminder,reminderAt,const DeepCollectionEquality().hash(_agreedUserIds));

@override
String toString() {
  return 'BridgeNextStep(code: $code, whenLabel: $whenLabel, at: $at, childIds: $childIds, reminder: $reminder, reminderAt: $reminderAt, agreedUserIds: $agreedUserIds)';
}


}

/// @nodoc
abstract mixin class _$BridgeNextStepCopyWith<$Res> implements $BridgeNextStepCopyWith<$Res> {
  factory _$BridgeNextStepCopyWith(_BridgeNextStep value, $Res Function(_BridgeNextStep) _then) = __$BridgeNextStepCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'whenLabel') String? whenLabel,@JsonKey(name: 'at') DateTime? at,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'reminder') bool reminder,@JsonKey(name: 'reminderAt') DateTime? reminderAt,@JsonKey(name: 'agreedUserIds') List<String> agreedUserIds
});




}
/// @nodoc
class __$BridgeNextStepCopyWithImpl<$Res>
    implements _$BridgeNextStepCopyWith<$Res> {
  __$BridgeNextStepCopyWithImpl(this._self, this._then);

  final _BridgeNextStep _self;
  final $Res Function(_BridgeNextStep) _then;

/// Create a copy of BridgeNextStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? whenLabel = freezed,Object? at = freezed,Object? childIds = null,Object? reminder = null,Object? reminderAt = freezed,Object? agreedUserIds = null,}) {
  return _then(_BridgeNextStep(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,whenLabel: freezed == whenLabel ? _self.whenLabel : whenLabel // ignore: cast_nullable_to_non_nullable
as String?,at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,reminder: null == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as bool,reminderAt: freezed == reminderAt ? _self.reminderAt : reminderAt // ignore: cast_nullable_to_non_nullable
as DateTime?,agreedUserIds: null == agreedUserIds ? _self._agreedUserIds : agreedUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
