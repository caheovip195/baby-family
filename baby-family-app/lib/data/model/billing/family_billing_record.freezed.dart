// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_billing_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyBillingRecord {

@JsonKey(name: 'accessPhase') String? get accessPhase;@JsonKey(name: 'licenseBlocked') bool get licenseBlocked;@JsonKey(name: 'plan') BillingPlanRecord? get plan;@JsonKey(name: 'trialEndsAt') DateTime? get trialEndsAt;@JsonKey(name: 'validUntil') DateTime? get validUntil;@JsonKey(name: 'inGrace') bool get inGrace;@JsonKey(name: 'usage') FamilyBillingUsage? get usage;
/// Create a copy of FamilyBillingRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyBillingRecordCopyWith<FamilyBillingRecord> get copyWith => _$FamilyBillingRecordCopyWithImpl<FamilyBillingRecord>(this as FamilyBillingRecord, _$identity);

  /// Serializes this FamilyBillingRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyBillingRecord&&(identical(other.accessPhase, accessPhase) || other.accessPhase == accessPhase)&&(identical(other.licenseBlocked, licenseBlocked) || other.licenseBlocked == licenseBlocked)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.trialEndsAt, trialEndsAt) || other.trialEndsAt == trialEndsAt)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.inGrace, inGrace) || other.inGrace == inGrace)&&(identical(other.usage, usage) || other.usage == usage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessPhase,licenseBlocked,plan,trialEndsAt,validUntil,inGrace,usage);

@override
String toString() {
  return 'FamilyBillingRecord(accessPhase: $accessPhase, licenseBlocked: $licenseBlocked, plan: $plan, trialEndsAt: $trialEndsAt, validUntil: $validUntil, inGrace: $inGrace, usage: $usage)';
}


}

/// @nodoc
abstract mixin class $FamilyBillingRecordCopyWith<$Res>  {
  factory $FamilyBillingRecordCopyWith(FamilyBillingRecord value, $Res Function(FamilyBillingRecord) _then) = _$FamilyBillingRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'accessPhase') String? accessPhase,@JsonKey(name: 'licenseBlocked') bool licenseBlocked,@JsonKey(name: 'plan') BillingPlanRecord? plan,@JsonKey(name: 'trialEndsAt') DateTime? trialEndsAt,@JsonKey(name: 'validUntil') DateTime? validUntil,@JsonKey(name: 'inGrace') bool inGrace,@JsonKey(name: 'usage') FamilyBillingUsage? usage
});


$BillingPlanRecordCopyWith<$Res>? get plan;$FamilyBillingUsageCopyWith<$Res>? get usage;

}
/// @nodoc
class _$FamilyBillingRecordCopyWithImpl<$Res>
    implements $FamilyBillingRecordCopyWith<$Res> {
  _$FamilyBillingRecordCopyWithImpl(this._self, this._then);

  final FamilyBillingRecord _self;
  final $Res Function(FamilyBillingRecord) _then;

/// Create a copy of FamilyBillingRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessPhase = freezed,Object? licenseBlocked = null,Object? plan = freezed,Object? trialEndsAt = freezed,Object? validUntil = freezed,Object? inGrace = null,Object? usage = freezed,}) {
  return _then(_self.copyWith(
accessPhase: freezed == accessPhase ? _self.accessPhase : accessPhase // ignore: cast_nullable_to_non_nullable
as String?,licenseBlocked: null == licenseBlocked ? _self.licenseBlocked : licenseBlocked // ignore: cast_nullable_to_non_nullable
as bool,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as BillingPlanRecord?,trialEndsAt: freezed == trialEndsAt ? _self.trialEndsAt : trialEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,validUntil: freezed == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,inGrace: null == inGrace ? _self.inGrace : inGrace // ignore: cast_nullable_to_non_nullable
as bool,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as FamilyBillingUsage?,
  ));
}
/// Create a copy of FamilyBillingRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BillingPlanRecordCopyWith<$Res>? get plan {
    if (_self.plan == null) {
    return null;
  }

  return $BillingPlanRecordCopyWith<$Res>(_self.plan!, (value) {
    return _then(_self.copyWith(plan: value));
  });
}/// Create a copy of FamilyBillingRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FamilyBillingUsageCopyWith<$Res>? get usage {
    if (_self.usage == null) {
    return null;
  }

  return $FamilyBillingUsageCopyWith<$Res>(_self.usage!, (value) {
    return _then(_self.copyWith(usage: value));
  });
}
}


/// Adds pattern-matching-related methods to [FamilyBillingRecord].
extension FamilyBillingRecordPatterns on FamilyBillingRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyBillingRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyBillingRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyBillingRecord value)  $default,){
final _that = this;
switch (_that) {
case _FamilyBillingRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyBillingRecord value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyBillingRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FamilyBillingRecord implements FamilyBillingRecord {
  const _FamilyBillingRecord({@JsonKey(name: 'accessPhase') this.accessPhase, @JsonKey(name: 'licenseBlocked') this.licenseBlocked = false, @JsonKey(name: 'plan') this.plan, @JsonKey(name: 'trialEndsAt') this.trialEndsAt, @JsonKey(name: 'validUntil') this.validUntil, @JsonKey(name: 'inGrace') this.inGrace = false, @JsonKey(name: 'usage') this.usage});
  factory _FamilyBillingRecord.fromJson(Map<String, dynamic> json) => _$FamilyBillingRecordFromJson(json);

@override@JsonKey(name: 'accessPhase') final  String? accessPhase;
@override@JsonKey(name: 'licenseBlocked') final  bool licenseBlocked;
@override@JsonKey(name: 'plan') final  BillingPlanRecord? plan;
@override@JsonKey(name: 'trialEndsAt') final  DateTime? trialEndsAt;
@override@JsonKey(name: 'validUntil') final  DateTime? validUntil;
@override@JsonKey(name: 'inGrace') final  bool inGrace;
@override@JsonKey(name: 'usage') final  FamilyBillingUsage? usage;

/// Create a copy of FamilyBillingRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyBillingRecordCopyWith<_FamilyBillingRecord> get copyWith => __$FamilyBillingRecordCopyWithImpl<_FamilyBillingRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyBillingRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyBillingRecord&&(identical(other.accessPhase, accessPhase) || other.accessPhase == accessPhase)&&(identical(other.licenseBlocked, licenseBlocked) || other.licenseBlocked == licenseBlocked)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.trialEndsAt, trialEndsAt) || other.trialEndsAt == trialEndsAt)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.inGrace, inGrace) || other.inGrace == inGrace)&&(identical(other.usage, usage) || other.usage == usage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessPhase,licenseBlocked,plan,trialEndsAt,validUntil,inGrace,usage);

@override
String toString() {
  return 'FamilyBillingRecord(accessPhase: $accessPhase, licenseBlocked: $licenseBlocked, plan: $plan, trialEndsAt: $trialEndsAt, validUntil: $validUntil, inGrace: $inGrace, usage: $usage)';
}


}

/// @nodoc
abstract mixin class _$FamilyBillingRecordCopyWith<$Res> implements $FamilyBillingRecordCopyWith<$Res> {
  factory _$FamilyBillingRecordCopyWith(_FamilyBillingRecord value, $Res Function(_FamilyBillingRecord) _then) = __$FamilyBillingRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'accessPhase') String? accessPhase,@JsonKey(name: 'licenseBlocked') bool licenseBlocked,@JsonKey(name: 'plan') BillingPlanRecord? plan,@JsonKey(name: 'trialEndsAt') DateTime? trialEndsAt,@JsonKey(name: 'validUntil') DateTime? validUntil,@JsonKey(name: 'inGrace') bool inGrace,@JsonKey(name: 'usage') FamilyBillingUsage? usage
});


@override $BillingPlanRecordCopyWith<$Res>? get plan;@override $FamilyBillingUsageCopyWith<$Res>? get usage;

}
/// @nodoc
class __$FamilyBillingRecordCopyWithImpl<$Res>
    implements _$FamilyBillingRecordCopyWith<$Res> {
  __$FamilyBillingRecordCopyWithImpl(this._self, this._then);

  final _FamilyBillingRecord _self;
  final $Res Function(_FamilyBillingRecord) _then;

/// Create a copy of FamilyBillingRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessPhase = freezed,Object? licenseBlocked = null,Object? plan = freezed,Object? trialEndsAt = freezed,Object? validUntil = freezed,Object? inGrace = null,Object? usage = freezed,}) {
  return _then(_FamilyBillingRecord(
accessPhase: freezed == accessPhase ? _self.accessPhase : accessPhase // ignore: cast_nullable_to_non_nullable
as String?,licenseBlocked: null == licenseBlocked ? _self.licenseBlocked : licenseBlocked // ignore: cast_nullable_to_non_nullable
as bool,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as BillingPlanRecord?,trialEndsAt: freezed == trialEndsAt ? _self.trialEndsAt : trialEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,validUntil: freezed == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,inGrace: null == inGrace ? _self.inGrace : inGrace // ignore: cast_nullable_to_non_nullable
as bool,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as FamilyBillingUsage?,
  ));
}

/// Create a copy of FamilyBillingRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BillingPlanRecordCopyWith<$Res>? get plan {
    if (_self.plan == null) {
    return null;
  }

  return $BillingPlanRecordCopyWith<$Res>(_self.plan!, (value) {
    return _then(_self.copyWith(plan: value));
  });
}/// Create a copy of FamilyBillingRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FamilyBillingUsageCopyWith<$Res>? get usage {
    if (_self.usage == null) {
    return null;
  }

  return $FamilyBillingUsageCopyWith<$Res>(_self.usage!, (value) {
    return _then(_self.copyWith(usage: value));
  });
}
}

// dart format on
