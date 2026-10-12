// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyMembership {

@JsonKey(name: 'familyId') String get familyId;@JsonKey(name: 'familyName') String get familyName;@JsonKey(name: 'role') FamilyRole get role;@JsonKey(name: 'callName') String get callName;@JsonKey(name: 'childNames') List<String> get childNames;@JsonKey(name: 'partnerName') String? get partnerName;@JsonKey(name: 'permissionSummary') String? get permissionSummary;@JsonKey(name: 'current') bool get current;
/// Create a copy of FamilyMembership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyMembershipCopyWith<FamilyMembership> get copyWith => _$FamilyMembershipCopyWithImpl<FamilyMembership>(this as FamilyMembership, _$identity);

  /// Serializes this FamilyMembership to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyMembership&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.role, role) || other.role == role)&&(identical(other.callName, callName) || other.callName == callName)&&const DeepCollectionEquality().equals(other.childNames, childNames)&&(identical(other.partnerName, partnerName) || other.partnerName == partnerName)&&(identical(other.permissionSummary, permissionSummary) || other.permissionSummary == permissionSummary)&&(identical(other.current, current) || other.current == current));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,familyName,role,callName,const DeepCollectionEquality().hash(childNames),partnerName,permissionSummary,current);

@override
String toString() {
  return 'FamilyMembership(familyId: $familyId, familyName: $familyName, role: $role, callName: $callName, childNames: $childNames, partnerName: $partnerName, permissionSummary: $permissionSummary, current: $current)';
}


}

/// @nodoc
abstract mixin class $FamilyMembershipCopyWith<$Res>  {
  factory $FamilyMembershipCopyWith(FamilyMembership value, $Res Function(FamilyMembership) _then) = _$FamilyMembershipCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'familyId') String familyId,@JsonKey(name: 'familyName') String familyName,@JsonKey(name: 'role') FamilyRole role,@JsonKey(name: 'callName') String callName,@JsonKey(name: 'childNames') List<String> childNames,@JsonKey(name: 'partnerName') String? partnerName,@JsonKey(name: 'permissionSummary') String? permissionSummary,@JsonKey(name: 'current') bool current
});




}
/// @nodoc
class _$FamilyMembershipCopyWithImpl<$Res>
    implements $FamilyMembershipCopyWith<$Res> {
  _$FamilyMembershipCopyWithImpl(this._self, this._then);

  final FamilyMembership _self;
  final $Res Function(FamilyMembership) _then;

/// Create a copy of FamilyMembership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? familyId = null,Object? familyName = null,Object? role = null,Object? callName = null,Object? childNames = null,Object? partnerName = freezed,Object? permissionSummary = freezed,Object? current = null,}) {
  return _then(_self.copyWith(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,familyName: null == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FamilyRole,callName: null == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String,childNames: null == childNames ? _self.childNames : childNames // ignore: cast_nullable_to_non_nullable
as List<String>,partnerName: freezed == partnerName ? _self.partnerName : partnerName // ignore: cast_nullable_to_non_nullable
as String?,permissionSummary: freezed == permissionSummary ? _self.permissionSummary : permissionSummary // ignore: cast_nullable_to_non_nullable
as String?,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyMembership].
extension FamilyMembershipPatterns on FamilyMembership {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyMembership value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyMembership() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyMembership value)  $default,){
final _that = this;
switch (_that) {
case _FamilyMembership():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyMembership value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyMembership() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FamilyMembership implements FamilyMembership {
  const _FamilyMembership({@JsonKey(name: 'familyId') required this.familyId, @JsonKey(name: 'familyName') required this.familyName, @JsonKey(name: 'role') required this.role, @JsonKey(name: 'callName') this.callName = '', @JsonKey(name: 'childNames') final  List<String> childNames = const [], @JsonKey(name: 'partnerName') this.partnerName, @JsonKey(name: 'permissionSummary') this.permissionSummary, @JsonKey(name: 'current') this.current = false}): _childNames = childNames;
  factory _FamilyMembership.fromJson(Map<String, dynamic> json) => _$FamilyMembershipFromJson(json);

@override@JsonKey(name: 'familyId') final  String familyId;
@override@JsonKey(name: 'familyName') final  String familyName;
@override@JsonKey(name: 'role') final  FamilyRole role;
@override@JsonKey(name: 'callName') final  String callName;
 final  List<String> _childNames;
@override@JsonKey(name: 'childNames') List<String> get childNames {
  if (_childNames is EqualUnmodifiableListView) return _childNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childNames);
}

@override@JsonKey(name: 'partnerName') final  String? partnerName;
@override@JsonKey(name: 'permissionSummary') final  String? permissionSummary;
@override@JsonKey(name: 'current') final  bool current;

/// Create a copy of FamilyMembership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyMembershipCopyWith<_FamilyMembership> get copyWith => __$FamilyMembershipCopyWithImpl<_FamilyMembership>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyMembershipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyMembership&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.role, role) || other.role == role)&&(identical(other.callName, callName) || other.callName == callName)&&const DeepCollectionEquality().equals(other._childNames, _childNames)&&(identical(other.partnerName, partnerName) || other.partnerName == partnerName)&&(identical(other.permissionSummary, permissionSummary) || other.permissionSummary == permissionSummary)&&(identical(other.current, current) || other.current == current));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,familyName,role,callName,const DeepCollectionEquality().hash(_childNames),partnerName,permissionSummary,current);

@override
String toString() {
  return 'FamilyMembership(familyId: $familyId, familyName: $familyName, role: $role, callName: $callName, childNames: $childNames, partnerName: $partnerName, permissionSummary: $permissionSummary, current: $current)';
}


}

/// @nodoc
abstract mixin class _$FamilyMembershipCopyWith<$Res> implements $FamilyMembershipCopyWith<$Res> {
  factory _$FamilyMembershipCopyWith(_FamilyMembership value, $Res Function(_FamilyMembership) _then) = __$FamilyMembershipCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'familyId') String familyId,@JsonKey(name: 'familyName') String familyName,@JsonKey(name: 'role') FamilyRole role,@JsonKey(name: 'callName') String callName,@JsonKey(name: 'childNames') List<String> childNames,@JsonKey(name: 'partnerName') String? partnerName,@JsonKey(name: 'permissionSummary') String? permissionSummary,@JsonKey(name: 'current') bool current
});




}
/// @nodoc
class __$FamilyMembershipCopyWithImpl<$Res>
    implements _$FamilyMembershipCopyWith<$Res> {
  __$FamilyMembershipCopyWithImpl(this._self, this._then);

  final _FamilyMembership _self;
  final $Res Function(_FamilyMembership) _then;

/// Create a copy of FamilyMembership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? familyId = null,Object? familyName = null,Object? role = null,Object? callName = null,Object? childNames = null,Object? partnerName = freezed,Object? permissionSummary = freezed,Object? current = null,}) {
  return _then(_FamilyMembership(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,familyName: null == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FamilyRole,callName: null == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String,childNames: null == childNames ? _self._childNames : childNames // ignore: cast_nullable_to_non_nullable
as List<String>,partnerName: freezed == partnerName ? _self.partnerName : partnerName // ignore: cast_nullable_to_non_nullable
as String?,permissionSummary: freezed == permissionSummary ? _self.permissionSummary : permissionSummary // ignore: cast_nullable_to_non_nullable
as String?,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
