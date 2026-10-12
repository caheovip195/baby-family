// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Family {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'name') String get name;@JsonKey(name: 'coverIndex') int get coverIndex;@JsonKey(name: 'coverAsset') String? get coverAsset;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'activatedAt') DateTime? get activatedAt;@JsonKey(name: 'setupCompleted') bool get setupCompleted;@JsonKey(name: 'timezone') String? get timezone;@JsonKey(name: 'plan') PlanInfo get plan;/// PARTNER_LEFT (US-00, FAM-02): bạn đời đã xoá tài khoản — chỉ xem & tải về.
@JsonKey(name: 'partnerLeftAt') DateTime? get partnerLeftAt;
/// Create a copy of Family
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyCopyWith<Family> get copyWith => _$FamilyCopyWithImpl<Family>(this as Family, _$identity);

  /// Serializes this Family to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Family&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.coverIndex, coverIndex) || other.coverIndex == coverIndex)&&(identical(other.coverAsset, coverAsset) || other.coverAsset == coverAsset)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt)&&(identical(other.setupCompleted, setupCompleted) || other.setupCompleted == setupCompleted)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.partnerLeftAt, partnerLeftAt) || other.partnerLeftAt == partnerLeftAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,coverIndex,coverAsset,createdAt,activatedAt,setupCompleted,timezone,plan,partnerLeftAt);

@override
String toString() {
  return 'Family(id: $id, name: $name, coverIndex: $coverIndex, coverAsset: $coverAsset, createdAt: $createdAt, activatedAt: $activatedAt, setupCompleted: $setupCompleted, timezone: $timezone, plan: $plan, partnerLeftAt: $partnerLeftAt)';
}


}

/// @nodoc
abstract mixin class $FamilyCopyWith<$Res>  {
  factory $FamilyCopyWith(Family value, $Res Function(Family) _then) = _$FamilyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'coverIndex') int coverIndex,@JsonKey(name: 'coverAsset') String? coverAsset,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'activatedAt') DateTime? activatedAt,@JsonKey(name: 'setupCompleted') bool setupCompleted,@JsonKey(name: 'timezone') String? timezone,@JsonKey(name: 'plan') PlanInfo plan,@JsonKey(name: 'partnerLeftAt') DateTime? partnerLeftAt
});


$PlanInfoCopyWith<$Res> get plan;

}
/// @nodoc
class _$FamilyCopyWithImpl<$Res>
    implements $FamilyCopyWith<$Res> {
  _$FamilyCopyWithImpl(this._self, this._then);

  final Family _self;
  final $Res Function(Family) _then;

/// Create a copy of Family
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? coverIndex = null,Object? coverAsset = freezed,Object? createdAt = freezed,Object? activatedAt = freezed,Object? setupCompleted = null,Object? timezone = freezed,Object? plan = null,Object? partnerLeftAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coverIndex: null == coverIndex ? _self.coverIndex : coverIndex // ignore: cast_nullable_to_non_nullable
as int,coverAsset: freezed == coverAsset ? _self.coverAsset : coverAsset // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,activatedAt: freezed == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,setupCompleted: null == setupCompleted ? _self.setupCompleted : setupCompleted // ignore: cast_nullable_to_non_nullable
as bool,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as PlanInfo,partnerLeftAt: freezed == partnerLeftAt ? _self.partnerLeftAt : partnerLeftAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Family
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanInfoCopyWith<$Res> get plan {
  
  return $PlanInfoCopyWith<$Res>(_self.plan, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}


/// Adds pattern-matching-related methods to [Family].
extension FamilyPatterns on Family {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Family value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Family() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Family value)  $default,){
final _that = this;
switch (_that) {
case _Family():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Family value)?  $default,){
final _that = this;
switch (_that) {
case _Family() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Family implements Family {
  const _Family({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'name') required this.name, @JsonKey(name: 'coverIndex') this.coverIndex = 0, @JsonKey(name: 'coverAsset') this.coverAsset, @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'activatedAt') this.activatedAt, @JsonKey(name: 'setupCompleted') this.setupCompleted = false, @JsonKey(name: 'timezone') this.timezone, @JsonKey(name: 'plan') this.plan = const PlanInfo(), @JsonKey(name: 'partnerLeftAt') this.partnerLeftAt});
  factory _Family.fromJson(Map<String, dynamic> json) => _$FamilyFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'coverIndex') final  int coverIndex;
@override@JsonKey(name: 'coverAsset') final  String? coverAsset;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
@override@JsonKey(name: 'activatedAt') final  DateTime? activatedAt;
@override@JsonKey(name: 'setupCompleted') final  bool setupCompleted;
@override@JsonKey(name: 'timezone') final  String? timezone;
@override@JsonKey(name: 'plan') final  PlanInfo plan;
/// PARTNER_LEFT (US-00, FAM-02): bạn đời đã xoá tài khoản — chỉ xem & tải về.
@override@JsonKey(name: 'partnerLeftAt') final  DateTime? partnerLeftAt;

/// Create a copy of Family
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyCopyWith<_Family> get copyWith => __$FamilyCopyWithImpl<_Family>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Family&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.coverIndex, coverIndex) || other.coverIndex == coverIndex)&&(identical(other.coverAsset, coverAsset) || other.coverAsset == coverAsset)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt)&&(identical(other.setupCompleted, setupCompleted) || other.setupCompleted == setupCompleted)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.partnerLeftAt, partnerLeftAt) || other.partnerLeftAt == partnerLeftAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,coverIndex,coverAsset,createdAt,activatedAt,setupCompleted,timezone,plan,partnerLeftAt);

@override
String toString() {
  return 'Family(id: $id, name: $name, coverIndex: $coverIndex, coverAsset: $coverAsset, createdAt: $createdAt, activatedAt: $activatedAt, setupCompleted: $setupCompleted, timezone: $timezone, plan: $plan, partnerLeftAt: $partnerLeftAt)';
}


}

/// @nodoc
abstract mixin class _$FamilyCopyWith<$Res> implements $FamilyCopyWith<$Res> {
  factory _$FamilyCopyWith(_Family value, $Res Function(_Family) _then) = __$FamilyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'coverIndex') int coverIndex,@JsonKey(name: 'coverAsset') String? coverAsset,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'activatedAt') DateTime? activatedAt,@JsonKey(name: 'setupCompleted') bool setupCompleted,@JsonKey(name: 'timezone') String? timezone,@JsonKey(name: 'plan') PlanInfo plan,@JsonKey(name: 'partnerLeftAt') DateTime? partnerLeftAt
});


@override $PlanInfoCopyWith<$Res> get plan;

}
/// @nodoc
class __$FamilyCopyWithImpl<$Res>
    implements _$FamilyCopyWith<$Res> {
  __$FamilyCopyWithImpl(this._self, this._then);

  final _Family _self;
  final $Res Function(_Family) _then;

/// Create a copy of Family
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? coverIndex = null,Object? coverAsset = freezed,Object? createdAt = freezed,Object? activatedAt = freezed,Object? setupCompleted = null,Object? timezone = freezed,Object? plan = null,Object? partnerLeftAt = freezed,}) {
  return _then(_Family(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coverIndex: null == coverIndex ? _self.coverIndex : coverIndex // ignore: cast_nullable_to_non_nullable
as int,coverAsset: freezed == coverAsset ? _self.coverAsset : coverAsset // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,activatedAt: freezed == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,setupCompleted: null == setupCompleted ? _self.setupCompleted : setupCompleted // ignore: cast_nullable_to_non_nullable
as bool,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as PlanInfo,partnerLeftAt: freezed == partnerLeftAt ? _self.partnerLeftAt : partnerLeftAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Family
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
