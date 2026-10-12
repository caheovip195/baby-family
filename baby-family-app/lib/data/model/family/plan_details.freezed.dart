// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlanDetails {

@JsonKey(name: 'plan') PlanInfo get plan;@JsonKey(name: 'payerUserId') String? get payerUserId;@JsonKey(name: 'channel') String get channel;@JsonKey(name: 'storage') List<StorageUsage> get storage;@JsonKey(name: 'aiRemaining') int get aiRemaining;@JsonKey(name: 'aiTotal') int get aiTotal;@JsonKey(name: 'aiRenewsAt') DateTime? get aiRenewsAt;@JsonKey(name: 'videoMaxMinutes') int get videoMaxMinutes;@JsonKey(name: 'photosPerMemory') int get photosPerMemory;@JsonKey(name: 'relativeNames') List<String> get relativeNames;
/// Create a copy of PlanDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanDetailsCopyWith<PlanDetails> get copyWith => _$PlanDetailsCopyWithImpl<PlanDetails>(this as PlanDetails, _$identity);

  /// Serializes this PlanDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanDetails&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.payerUserId, payerUserId) || other.payerUserId == payerUserId)&&(identical(other.channel, channel) || other.channel == channel)&&const DeepCollectionEquality().equals(other.storage, storage)&&(identical(other.aiRemaining, aiRemaining) || other.aiRemaining == aiRemaining)&&(identical(other.aiTotal, aiTotal) || other.aiTotal == aiTotal)&&(identical(other.aiRenewsAt, aiRenewsAt) || other.aiRenewsAt == aiRenewsAt)&&(identical(other.videoMaxMinutes, videoMaxMinutes) || other.videoMaxMinutes == videoMaxMinutes)&&(identical(other.photosPerMemory, photosPerMemory) || other.photosPerMemory == photosPerMemory)&&const DeepCollectionEquality().equals(other.relativeNames, relativeNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,plan,payerUserId,channel,const DeepCollectionEquality().hash(storage),aiRemaining,aiTotal,aiRenewsAt,videoMaxMinutes,photosPerMemory,const DeepCollectionEquality().hash(relativeNames));

@override
String toString() {
  return 'PlanDetails(plan: $plan, payerUserId: $payerUserId, channel: $channel, storage: $storage, aiRemaining: $aiRemaining, aiTotal: $aiTotal, aiRenewsAt: $aiRenewsAt, videoMaxMinutes: $videoMaxMinutes, photosPerMemory: $photosPerMemory, relativeNames: $relativeNames)';
}


}

/// @nodoc
abstract mixin class $PlanDetailsCopyWith<$Res>  {
  factory $PlanDetailsCopyWith(PlanDetails value, $Res Function(PlanDetails) _then) = _$PlanDetailsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'plan') PlanInfo plan,@JsonKey(name: 'payerUserId') String? payerUserId,@JsonKey(name: 'channel') String channel,@JsonKey(name: 'storage') List<StorageUsage> storage,@JsonKey(name: 'aiRemaining') int aiRemaining,@JsonKey(name: 'aiTotal') int aiTotal,@JsonKey(name: 'aiRenewsAt') DateTime? aiRenewsAt,@JsonKey(name: 'videoMaxMinutes') int videoMaxMinutes,@JsonKey(name: 'photosPerMemory') int photosPerMemory,@JsonKey(name: 'relativeNames') List<String> relativeNames
});


$PlanInfoCopyWith<$Res> get plan;

}
/// @nodoc
class _$PlanDetailsCopyWithImpl<$Res>
    implements $PlanDetailsCopyWith<$Res> {
  _$PlanDetailsCopyWithImpl(this._self, this._then);

  final PlanDetails _self;
  final $Res Function(PlanDetails) _then;

/// Create a copy of PlanDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plan = null,Object? payerUserId = freezed,Object? channel = null,Object? storage = null,Object? aiRemaining = null,Object? aiTotal = null,Object? aiRenewsAt = freezed,Object? videoMaxMinutes = null,Object? photosPerMemory = null,Object? relativeNames = null,}) {
  return _then(_self.copyWith(
plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as PlanInfo,payerUserId: freezed == payerUserId ? _self.payerUserId : payerUserId // ignore: cast_nullable_to_non_nullable
as String?,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as String,storage: null == storage ? _self.storage : storage // ignore: cast_nullable_to_non_nullable
as List<StorageUsage>,aiRemaining: null == aiRemaining ? _self.aiRemaining : aiRemaining // ignore: cast_nullable_to_non_nullable
as int,aiTotal: null == aiTotal ? _self.aiTotal : aiTotal // ignore: cast_nullable_to_non_nullable
as int,aiRenewsAt: freezed == aiRenewsAt ? _self.aiRenewsAt : aiRenewsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,videoMaxMinutes: null == videoMaxMinutes ? _self.videoMaxMinutes : videoMaxMinutes // ignore: cast_nullable_to_non_nullable
as int,photosPerMemory: null == photosPerMemory ? _self.photosPerMemory : photosPerMemory // ignore: cast_nullable_to_non_nullable
as int,relativeNames: null == relativeNames ? _self.relativeNames : relativeNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of PlanDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanInfoCopyWith<$Res> get plan {
  
  return $PlanInfoCopyWith<$Res>(_self.plan, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlanDetails].
extension PlanDetailsPatterns on PlanDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanDetails value)  $default,){
final _that = this;
switch (_that) {
case _PlanDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanDetails value)?  $default,){
final _that = this;
switch (_that) {
case _PlanDetails() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PlanDetails implements PlanDetails {
  const _PlanDetails({@JsonKey(name: 'plan') required this.plan, @JsonKey(name: 'payerUserId') this.payerUserId, @JsonKey(name: 'channel') this.channel = '', @JsonKey(name: 'storage') final  List<StorageUsage> storage = const [], @JsonKey(name: 'aiRemaining') this.aiRemaining = 0, @JsonKey(name: 'aiTotal') this.aiTotal = 0, @JsonKey(name: 'aiRenewsAt') this.aiRenewsAt, @JsonKey(name: 'videoMaxMinutes') this.videoMaxMinutes = 0, @JsonKey(name: 'photosPerMemory') this.photosPerMemory = 0, @JsonKey(name: 'relativeNames') final  List<String> relativeNames = const []}): _storage = storage,_relativeNames = relativeNames;
  factory _PlanDetails.fromJson(Map<String, dynamic> json) => _$PlanDetailsFromJson(json);

@override@JsonKey(name: 'plan') final  PlanInfo plan;
@override@JsonKey(name: 'payerUserId') final  String? payerUserId;
@override@JsonKey(name: 'channel') final  String channel;
 final  List<StorageUsage> _storage;
@override@JsonKey(name: 'storage') List<StorageUsage> get storage {
  if (_storage is EqualUnmodifiableListView) return _storage;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_storage);
}

@override@JsonKey(name: 'aiRemaining') final  int aiRemaining;
@override@JsonKey(name: 'aiTotal') final  int aiTotal;
@override@JsonKey(name: 'aiRenewsAt') final  DateTime? aiRenewsAt;
@override@JsonKey(name: 'videoMaxMinutes') final  int videoMaxMinutes;
@override@JsonKey(name: 'photosPerMemory') final  int photosPerMemory;
 final  List<String> _relativeNames;
@override@JsonKey(name: 'relativeNames') List<String> get relativeNames {
  if (_relativeNames is EqualUnmodifiableListView) return _relativeNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_relativeNames);
}


/// Create a copy of PlanDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanDetailsCopyWith<_PlanDetails> get copyWith => __$PlanDetailsCopyWithImpl<_PlanDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanDetails&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.payerUserId, payerUserId) || other.payerUserId == payerUserId)&&(identical(other.channel, channel) || other.channel == channel)&&const DeepCollectionEquality().equals(other._storage, _storage)&&(identical(other.aiRemaining, aiRemaining) || other.aiRemaining == aiRemaining)&&(identical(other.aiTotal, aiTotal) || other.aiTotal == aiTotal)&&(identical(other.aiRenewsAt, aiRenewsAt) || other.aiRenewsAt == aiRenewsAt)&&(identical(other.videoMaxMinutes, videoMaxMinutes) || other.videoMaxMinutes == videoMaxMinutes)&&(identical(other.photosPerMemory, photosPerMemory) || other.photosPerMemory == photosPerMemory)&&const DeepCollectionEquality().equals(other._relativeNames, _relativeNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,plan,payerUserId,channel,const DeepCollectionEquality().hash(_storage),aiRemaining,aiTotal,aiRenewsAt,videoMaxMinutes,photosPerMemory,const DeepCollectionEquality().hash(_relativeNames));

@override
String toString() {
  return 'PlanDetails(plan: $plan, payerUserId: $payerUserId, channel: $channel, storage: $storage, aiRemaining: $aiRemaining, aiTotal: $aiTotal, aiRenewsAt: $aiRenewsAt, videoMaxMinutes: $videoMaxMinutes, photosPerMemory: $photosPerMemory, relativeNames: $relativeNames)';
}


}

/// @nodoc
abstract mixin class _$PlanDetailsCopyWith<$Res> implements $PlanDetailsCopyWith<$Res> {
  factory _$PlanDetailsCopyWith(_PlanDetails value, $Res Function(_PlanDetails) _then) = __$PlanDetailsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'plan') PlanInfo plan,@JsonKey(name: 'payerUserId') String? payerUserId,@JsonKey(name: 'channel') String channel,@JsonKey(name: 'storage') List<StorageUsage> storage,@JsonKey(name: 'aiRemaining') int aiRemaining,@JsonKey(name: 'aiTotal') int aiTotal,@JsonKey(name: 'aiRenewsAt') DateTime? aiRenewsAt,@JsonKey(name: 'videoMaxMinutes') int videoMaxMinutes,@JsonKey(name: 'photosPerMemory') int photosPerMemory,@JsonKey(name: 'relativeNames') List<String> relativeNames
});


@override $PlanInfoCopyWith<$Res> get plan;

}
/// @nodoc
class __$PlanDetailsCopyWithImpl<$Res>
    implements _$PlanDetailsCopyWith<$Res> {
  __$PlanDetailsCopyWithImpl(this._self, this._then);

  final _PlanDetails _self;
  final $Res Function(_PlanDetails) _then;

/// Create a copy of PlanDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plan = null,Object? payerUserId = freezed,Object? channel = null,Object? storage = null,Object? aiRemaining = null,Object? aiTotal = null,Object? aiRenewsAt = freezed,Object? videoMaxMinutes = null,Object? photosPerMemory = null,Object? relativeNames = null,}) {
  return _then(_PlanDetails(
plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as PlanInfo,payerUserId: freezed == payerUserId ? _self.payerUserId : payerUserId // ignore: cast_nullable_to_non_nullable
as String?,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as String,storage: null == storage ? _self._storage : storage // ignore: cast_nullable_to_non_nullable
as List<StorageUsage>,aiRemaining: null == aiRemaining ? _self.aiRemaining : aiRemaining // ignore: cast_nullable_to_non_nullable
as int,aiTotal: null == aiTotal ? _self.aiTotal : aiTotal // ignore: cast_nullable_to_non_nullable
as int,aiRenewsAt: freezed == aiRenewsAt ? _self.aiRenewsAt : aiRenewsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,videoMaxMinutes: null == videoMaxMinutes ? _self.videoMaxMinutes : videoMaxMinutes // ignore: cast_nullable_to_non_nullable
as int,photosPerMemory: null == photosPerMemory ? _self.photosPerMemory : photosPerMemory // ignore: cast_nullable_to_non_nullable
as int,relativeNames: null == relativeNames ? _self._relativeNames : relativeNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of PlanDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanInfoCopyWith<$Res> get plan {
  
  return $PlanInfoCopyWith<$Res>(_self.plan, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}

// dart format on
