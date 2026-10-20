// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'me_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeProfile {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'displayName') String? get displayName;/// AUTH-04: URL ký ngắn hạn của ảnh đại diện (null khi chưa có).
@JsonKey(name: 'avatarUrl') String? get avatarUrl;@JsonKey(name: 'locale') String? get locale;@JsonKey(name: 'timezone') String? get timezone;@JsonKey(name: 'onboardingRole') String? get onboardingRole;@JsonKey(name: 'profileCompleted') bool get profileCompleted;@JsonKey(name: 'families') List<MeFamily> get families;@JsonKey(name: 'awaitingApproval') List<MeAwaitingApproval> get awaitingApproval;
/// Create a copy of MeProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeProfileCopyWith<MeProfile> get copyWith => _$MeProfileCopyWithImpl<MeProfile>(this as MeProfile, _$identity);

  /// Serializes this MeProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.onboardingRole, onboardingRole) || other.onboardingRole == onboardingRole)&&(identical(other.profileCompleted, profileCompleted) || other.profileCompleted == profileCompleted)&&const DeepCollectionEquality().equals(other.families, families)&&const DeepCollectionEquality().equals(other.awaitingApproval, awaitingApproval));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,avatarUrl,locale,timezone,onboardingRole,profileCompleted,const DeepCollectionEquality().hash(families),const DeepCollectionEquality().hash(awaitingApproval));

@override
String toString() {
  return 'MeProfile(id: $id, displayName: $displayName, avatarUrl: $avatarUrl, locale: $locale, timezone: $timezone, onboardingRole: $onboardingRole, profileCompleted: $profileCompleted, families: $families, awaitingApproval: $awaitingApproval)';
}


}

/// @nodoc
abstract mixin class $MeProfileCopyWith<$Res>  {
  factory $MeProfileCopyWith(MeProfile value, $Res Function(MeProfile) _then) = _$MeProfileCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'displayName') String? displayName,@JsonKey(name: 'avatarUrl') String? avatarUrl,@JsonKey(name: 'locale') String? locale,@JsonKey(name: 'timezone') String? timezone,@JsonKey(name: 'onboardingRole') String? onboardingRole,@JsonKey(name: 'profileCompleted') bool profileCompleted,@JsonKey(name: 'families') List<MeFamily> families,@JsonKey(name: 'awaitingApproval') List<MeAwaitingApproval> awaitingApproval
});




}
/// @nodoc
class _$MeProfileCopyWithImpl<$Res>
    implements $MeProfileCopyWith<$Res> {
  _$MeProfileCopyWithImpl(this._self, this._then);

  final MeProfile _self;
  final $Res Function(MeProfile) _then;

/// Create a copy of MeProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,Object? locale = freezed,Object? timezone = freezed,Object? onboardingRole = freezed,Object? profileCompleted = null,Object? families = null,Object? awaitingApproval = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,onboardingRole: freezed == onboardingRole ? _self.onboardingRole : onboardingRole // ignore: cast_nullable_to_non_nullable
as String?,profileCompleted: null == profileCompleted ? _self.profileCompleted : profileCompleted // ignore: cast_nullable_to_non_nullable
as bool,families: null == families ? _self.families : families // ignore: cast_nullable_to_non_nullable
as List<MeFamily>,awaitingApproval: null == awaitingApproval ? _self.awaitingApproval : awaitingApproval // ignore: cast_nullable_to_non_nullable
as List<MeAwaitingApproval>,
  ));
}

}


/// Adds pattern-matching-related methods to [MeProfile].
extension MeProfilePatterns on MeProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeProfile value)  $default,){
final _that = this;
switch (_that) {
case _MeProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeProfile value)?  $default,){
final _that = this;
switch (_that) {
case _MeProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MeProfile implements MeProfile {
  const _MeProfile({@JsonKey(name: 'id') this.id, @JsonKey(name: 'displayName') this.displayName, @JsonKey(name: 'avatarUrl') this.avatarUrl, @JsonKey(name: 'locale') this.locale, @JsonKey(name: 'timezone') this.timezone, @JsonKey(name: 'onboardingRole') this.onboardingRole, @JsonKey(name: 'profileCompleted') this.profileCompleted = false, @JsonKey(name: 'families') final  List<MeFamily> families = const <MeFamily>[], @JsonKey(name: 'awaitingApproval') final  List<MeAwaitingApproval> awaitingApproval = const <MeAwaitingApproval>[]}): _families = families,_awaitingApproval = awaitingApproval;
  factory _MeProfile.fromJson(Map<String, dynamic> json) => _$MeProfileFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'displayName') final  String? displayName;
/// AUTH-04: URL ký ngắn hạn của ảnh đại diện (null khi chưa có).
@override@JsonKey(name: 'avatarUrl') final  String? avatarUrl;
@override@JsonKey(name: 'locale') final  String? locale;
@override@JsonKey(name: 'timezone') final  String? timezone;
@override@JsonKey(name: 'onboardingRole') final  String? onboardingRole;
@override@JsonKey(name: 'profileCompleted') final  bool profileCompleted;
 final  List<MeFamily> _families;
@override@JsonKey(name: 'families') List<MeFamily> get families {
  if (_families is EqualUnmodifiableListView) return _families;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_families);
}

 final  List<MeAwaitingApproval> _awaitingApproval;
@override@JsonKey(name: 'awaitingApproval') List<MeAwaitingApproval> get awaitingApproval {
  if (_awaitingApproval is EqualUnmodifiableListView) return _awaitingApproval;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_awaitingApproval);
}


/// Create a copy of MeProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeProfileCopyWith<_MeProfile> get copyWith => __$MeProfileCopyWithImpl<_MeProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.onboardingRole, onboardingRole) || other.onboardingRole == onboardingRole)&&(identical(other.profileCompleted, profileCompleted) || other.profileCompleted == profileCompleted)&&const DeepCollectionEquality().equals(other._families, _families)&&const DeepCollectionEquality().equals(other._awaitingApproval, _awaitingApproval));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,avatarUrl,locale,timezone,onboardingRole,profileCompleted,const DeepCollectionEquality().hash(_families),const DeepCollectionEquality().hash(_awaitingApproval));

@override
String toString() {
  return 'MeProfile(id: $id, displayName: $displayName, avatarUrl: $avatarUrl, locale: $locale, timezone: $timezone, onboardingRole: $onboardingRole, profileCompleted: $profileCompleted, families: $families, awaitingApproval: $awaitingApproval)';
}


}

/// @nodoc
abstract mixin class _$MeProfileCopyWith<$Res> implements $MeProfileCopyWith<$Res> {
  factory _$MeProfileCopyWith(_MeProfile value, $Res Function(_MeProfile) _then) = __$MeProfileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'displayName') String? displayName,@JsonKey(name: 'avatarUrl') String? avatarUrl,@JsonKey(name: 'locale') String? locale,@JsonKey(name: 'timezone') String? timezone,@JsonKey(name: 'onboardingRole') String? onboardingRole,@JsonKey(name: 'profileCompleted') bool profileCompleted,@JsonKey(name: 'families') List<MeFamily> families,@JsonKey(name: 'awaitingApproval') List<MeAwaitingApproval> awaitingApproval
});




}
/// @nodoc
class __$MeProfileCopyWithImpl<$Res>
    implements _$MeProfileCopyWith<$Res> {
  __$MeProfileCopyWithImpl(this._self, this._then);

  final _MeProfile _self;
  final $Res Function(_MeProfile) _then;

/// Create a copy of MeProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,Object? locale = freezed,Object? timezone = freezed,Object? onboardingRole = freezed,Object? profileCompleted = null,Object? families = null,Object? awaitingApproval = null,}) {
  return _then(_MeProfile(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,onboardingRole: freezed == onboardingRole ? _self.onboardingRole : onboardingRole // ignore: cast_nullable_to_non_nullable
as String?,profileCompleted: null == profileCompleted ? _self.profileCompleted : profileCompleted // ignore: cast_nullable_to_non_nullable
as bool,families: null == families ? _self._families : families // ignore: cast_nullable_to_non_nullable
as List<MeFamily>,awaitingApproval: null == awaitingApproval ? _self._awaitingApproval : awaitingApproval // ignore: cast_nullable_to_non_nullable
as List<MeAwaitingApproval>,
  ));
}


}

// dart format on
