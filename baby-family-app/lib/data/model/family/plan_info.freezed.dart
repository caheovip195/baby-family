// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlanInfo {

@JsonKey(name: 'state') PlanState get state;@JsonKey(name: 'startedAt') DateTime? get startedAt;@JsonKey(name: 'endsAt') DateTime? get endsAt;@JsonKey(name: 'storageUsedMb') int get storageUsedMb;@JsonKey(name: 'storageQuotaMb') int get storageQuotaMb;@JsonKey(name: 'relativeSlotsUsed') int get relativeSlotsUsed;@JsonKey(name: 'relativeSlotsMax') int get relativeSlotsMax;/// SUB-06: gia hạn chưa thành công (gói vẫn hoạt động).
@JsonKey(name: 'paymentIssue') bool get paymentIssue;
/// Create a copy of PlanInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanInfoCopyWith<PlanInfo> get copyWith => _$PlanInfoCopyWithImpl<PlanInfo>(this as PlanInfo, _$identity);

  /// Serializes this PlanInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanInfo&&(identical(other.state, state) || other.state == state)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.storageUsedMb, storageUsedMb) || other.storageUsedMb == storageUsedMb)&&(identical(other.storageQuotaMb, storageQuotaMb) || other.storageQuotaMb == storageQuotaMb)&&(identical(other.relativeSlotsUsed, relativeSlotsUsed) || other.relativeSlotsUsed == relativeSlotsUsed)&&(identical(other.relativeSlotsMax, relativeSlotsMax) || other.relativeSlotsMax == relativeSlotsMax)&&(identical(other.paymentIssue, paymentIssue) || other.paymentIssue == paymentIssue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,state,startedAt,endsAt,storageUsedMb,storageQuotaMb,relativeSlotsUsed,relativeSlotsMax,paymentIssue);

@override
String toString() {
  return 'PlanInfo(state: $state, startedAt: $startedAt, endsAt: $endsAt, storageUsedMb: $storageUsedMb, storageQuotaMb: $storageQuotaMb, relativeSlotsUsed: $relativeSlotsUsed, relativeSlotsMax: $relativeSlotsMax, paymentIssue: $paymentIssue)';
}


}

/// @nodoc
abstract mixin class $PlanInfoCopyWith<$Res>  {
  factory $PlanInfoCopyWith(PlanInfo value, $Res Function(PlanInfo) _then) = _$PlanInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'state') PlanState state,@JsonKey(name: 'startedAt') DateTime? startedAt,@JsonKey(name: 'endsAt') DateTime? endsAt,@JsonKey(name: 'storageUsedMb') int storageUsedMb,@JsonKey(name: 'storageQuotaMb') int storageQuotaMb,@JsonKey(name: 'relativeSlotsUsed') int relativeSlotsUsed,@JsonKey(name: 'relativeSlotsMax') int relativeSlotsMax,@JsonKey(name: 'paymentIssue') bool paymentIssue
});




}
/// @nodoc
class _$PlanInfoCopyWithImpl<$Res>
    implements $PlanInfoCopyWith<$Res> {
  _$PlanInfoCopyWithImpl(this._self, this._then);

  final PlanInfo _self;
  final $Res Function(PlanInfo) _then;

/// Create a copy of PlanInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? state = null,Object? startedAt = freezed,Object? endsAt = freezed,Object? storageUsedMb = null,Object? storageQuotaMb = null,Object? relativeSlotsUsed = null,Object? relativeSlotsMax = null,Object? paymentIssue = null,}) {
  return _then(_self.copyWith(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PlanState,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,storageUsedMb: null == storageUsedMb ? _self.storageUsedMb : storageUsedMb // ignore: cast_nullable_to_non_nullable
as int,storageQuotaMb: null == storageQuotaMb ? _self.storageQuotaMb : storageQuotaMb // ignore: cast_nullable_to_non_nullable
as int,relativeSlotsUsed: null == relativeSlotsUsed ? _self.relativeSlotsUsed : relativeSlotsUsed // ignore: cast_nullable_to_non_nullable
as int,relativeSlotsMax: null == relativeSlotsMax ? _self.relativeSlotsMax : relativeSlotsMax // ignore: cast_nullable_to_non_nullable
as int,paymentIssue: null == paymentIssue ? _self.paymentIssue : paymentIssue // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanInfo].
extension PlanInfoPatterns on PlanInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanInfo value)  $default,){
final _that = this;
switch (_that) {
case _PlanInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanInfo value)?  $default,){
final _that = this;
switch (_that) {
case _PlanInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PlanInfo implements PlanInfo {
  const _PlanInfo({@JsonKey(name: 'state') this.state = PlanState.trial, @JsonKey(name: 'startedAt') this.startedAt, @JsonKey(name: 'endsAt') this.endsAt, @JsonKey(name: 'storageUsedMb') this.storageUsedMb = 0, @JsonKey(name: 'storageQuotaMb') this.storageQuotaMb = 0, @JsonKey(name: 'relativeSlotsUsed') this.relativeSlotsUsed = 0, @JsonKey(name: 'relativeSlotsMax') this.relativeSlotsMax = 0, @JsonKey(name: 'paymentIssue') this.paymentIssue = false});
  factory _PlanInfo.fromJson(Map<String, dynamic> json) => _$PlanInfoFromJson(json);

@override@JsonKey(name: 'state') final  PlanState state;
@override@JsonKey(name: 'startedAt') final  DateTime? startedAt;
@override@JsonKey(name: 'endsAt') final  DateTime? endsAt;
@override@JsonKey(name: 'storageUsedMb') final  int storageUsedMb;
@override@JsonKey(name: 'storageQuotaMb') final  int storageQuotaMb;
@override@JsonKey(name: 'relativeSlotsUsed') final  int relativeSlotsUsed;
@override@JsonKey(name: 'relativeSlotsMax') final  int relativeSlotsMax;
/// SUB-06: gia hạn chưa thành công (gói vẫn hoạt động).
@override@JsonKey(name: 'paymentIssue') final  bool paymentIssue;

/// Create a copy of PlanInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanInfoCopyWith<_PlanInfo> get copyWith => __$PlanInfoCopyWithImpl<_PlanInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanInfo&&(identical(other.state, state) || other.state == state)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.storageUsedMb, storageUsedMb) || other.storageUsedMb == storageUsedMb)&&(identical(other.storageQuotaMb, storageQuotaMb) || other.storageQuotaMb == storageQuotaMb)&&(identical(other.relativeSlotsUsed, relativeSlotsUsed) || other.relativeSlotsUsed == relativeSlotsUsed)&&(identical(other.relativeSlotsMax, relativeSlotsMax) || other.relativeSlotsMax == relativeSlotsMax)&&(identical(other.paymentIssue, paymentIssue) || other.paymentIssue == paymentIssue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,state,startedAt,endsAt,storageUsedMb,storageQuotaMb,relativeSlotsUsed,relativeSlotsMax,paymentIssue);

@override
String toString() {
  return 'PlanInfo(state: $state, startedAt: $startedAt, endsAt: $endsAt, storageUsedMb: $storageUsedMb, storageQuotaMb: $storageQuotaMb, relativeSlotsUsed: $relativeSlotsUsed, relativeSlotsMax: $relativeSlotsMax, paymentIssue: $paymentIssue)';
}


}

/// @nodoc
abstract mixin class _$PlanInfoCopyWith<$Res> implements $PlanInfoCopyWith<$Res> {
  factory _$PlanInfoCopyWith(_PlanInfo value, $Res Function(_PlanInfo) _then) = __$PlanInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'state') PlanState state,@JsonKey(name: 'startedAt') DateTime? startedAt,@JsonKey(name: 'endsAt') DateTime? endsAt,@JsonKey(name: 'storageUsedMb') int storageUsedMb,@JsonKey(name: 'storageQuotaMb') int storageQuotaMb,@JsonKey(name: 'relativeSlotsUsed') int relativeSlotsUsed,@JsonKey(name: 'relativeSlotsMax') int relativeSlotsMax,@JsonKey(name: 'paymentIssue') bool paymentIssue
});




}
/// @nodoc
class __$PlanInfoCopyWithImpl<$Res>
    implements _$PlanInfoCopyWith<$Res> {
  __$PlanInfoCopyWithImpl(this._self, this._then);

  final _PlanInfo _self;
  final $Res Function(_PlanInfo) _then;

/// Create a copy of PlanInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? state = null,Object? startedAt = freezed,Object? endsAt = freezed,Object? storageUsedMb = null,Object? storageQuotaMb = null,Object? relativeSlotsUsed = null,Object? relativeSlotsMax = null,Object? paymentIssue = null,}) {
  return _then(_PlanInfo(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PlanState,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,storageUsedMb: null == storageUsedMb ? _self.storageUsedMb : storageUsedMb // ignore: cast_nullable_to_non_nullable
as int,storageQuotaMb: null == storageQuotaMb ? _self.storageQuotaMb : storageQuotaMb // ignore: cast_nullable_to_non_nullable
as int,relativeSlotsUsed: null == relativeSlotsUsed ? _self.relativeSlotsUsed : relativeSlotsUsed // ignore: cast_nullable_to_non_nullable
as int,relativeSlotsMax: null == relativeSlotsMax ? _self.relativeSlotsMax : relativeSlotsMax // ignore: cast_nullable_to_non_nullable
as int,paymentIssue: null == paymentIssue ? _self.paymentIssue : paymentIssue // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
