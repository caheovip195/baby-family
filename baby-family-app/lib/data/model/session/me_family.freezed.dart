// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'me_family.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeFamily {

@JsonKey(name: 'familyId') String? get familyId;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'slot') String? get slot;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'callName') String? get callName;
/// Create a copy of MeFamily
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeFamilyCopyWith<MeFamily> get copyWith => _$MeFamilyCopyWithImpl<MeFamily>(this as MeFamily, _$identity);

  /// Serializes this MeFamily to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeFamily&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.callName, callName) || other.callName == callName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,name,status,slot,kind,callName);

@override
String toString() {
  return 'MeFamily(familyId: $familyId, name: $name, status: $status, slot: $slot, kind: $kind, callName: $callName)';
}


}

/// @nodoc
abstract mixin class $MeFamilyCopyWith<$Res>  {
  factory $MeFamilyCopyWith(MeFamily value, $Res Function(MeFamily) _then) = _$MeFamilyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'name') String? name,@JsonKey(name: 'status') String? status,@JsonKey(name: 'slot') String? slot,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'callName') String? callName
});




}
/// @nodoc
class _$MeFamilyCopyWithImpl<$Res>
    implements $MeFamilyCopyWith<$Res> {
  _$MeFamilyCopyWithImpl(this._self, this._then);

  final MeFamily _self;
  final $Res Function(MeFamily) _then;

/// Create a copy of MeFamily
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? familyId = freezed,Object? name = freezed,Object? status = freezed,Object? slot = freezed,Object? kind = freezed,Object? callName = freezed,}) {
  return _then(_self.copyWith(
familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,slot: freezed == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,callName: freezed == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeFamily].
extension MeFamilyPatterns on MeFamily {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeFamily value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeFamily() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeFamily value)  $default,){
final _that = this;
switch (_that) {
case _MeFamily():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeFamily value)?  $default,){
final _that = this;
switch (_that) {
case _MeFamily() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MeFamily implements MeFamily {
  const _MeFamily({@JsonKey(name: 'familyId') this.familyId, @JsonKey(name: 'name') this.name, @JsonKey(name: 'status') this.status, @JsonKey(name: 'slot') this.slot, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'callName') this.callName});
  factory _MeFamily.fromJson(Map<String, dynamic> json) => _$MeFamilyFromJson(json);

@override@JsonKey(name: 'familyId') final  String? familyId;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'slot') final  String? slot;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'callName') final  String? callName;

/// Create a copy of MeFamily
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeFamilyCopyWith<_MeFamily> get copyWith => __$MeFamilyCopyWithImpl<_MeFamily>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeFamilyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeFamily&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.callName, callName) || other.callName == callName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,name,status,slot,kind,callName);

@override
String toString() {
  return 'MeFamily(familyId: $familyId, name: $name, status: $status, slot: $slot, kind: $kind, callName: $callName)';
}


}

/// @nodoc
abstract mixin class _$MeFamilyCopyWith<$Res> implements $MeFamilyCopyWith<$Res> {
  factory _$MeFamilyCopyWith(_MeFamily value, $Res Function(_MeFamily) _then) = __$MeFamilyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'name') String? name,@JsonKey(name: 'status') String? status,@JsonKey(name: 'slot') String? slot,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'callName') String? callName
});




}
/// @nodoc
class __$MeFamilyCopyWithImpl<$Res>
    implements _$MeFamilyCopyWith<$Res> {
  __$MeFamilyCopyWithImpl(this._self, this._then);

  final _MeFamily _self;
  final $Res Function(_MeFamily) _then;

/// Create a copy of MeFamily
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? familyId = freezed,Object? name = freezed,Object? status = freezed,Object? slot = freezed,Object? kind = freezed,Object? callName = freezed,}) {
  return _then(_MeFamily(
familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,slot: freezed == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,callName: freezed == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
