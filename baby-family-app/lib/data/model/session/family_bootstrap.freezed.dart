// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_bootstrap.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyBootstrap {

@JsonKey(name: 'family') BootstrapFamily? get family;@JsonKey(name: 'me') BootstrapParent? get me;@JsonKey(name: 'parents') List<BootstrapParent> get parents;@JsonKey(name: 'coupleLinked') bool get coupleLinked;@JsonKey(name: 'subjects') List<BootstrapSubject> get subjects;@JsonKey(name: 'entitlement') BootstrapEntitlement? get entitlement;@JsonKey(name: 'accessVersion') int? get accessVersion;
/// Create a copy of FamilyBootstrap
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyBootstrapCopyWith<FamilyBootstrap> get copyWith => _$FamilyBootstrapCopyWithImpl<FamilyBootstrap>(this as FamilyBootstrap, _$identity);

  /// Serializes this FamilyBootstrap to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyBootstrap&&(identical(other.family, family) || other.family == family)&&(identical(other.me, me) || other.me == me)&&const DeepCollectionEquality().equals(other.parents, parents)&&(identical(other.coupleLinked, coupleLinked) || other.coupleLinked == coupleLinked)&&const DeepCollectionEquality().equals(other.subjects, subjects)&&(identical(other.entitlement, entitlement) || other.entitlement == entitlement)&&(identical(other.accessVersion, accessVersion) || other.accessVersion == accessVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,family,me,const DeepCollectionEquality().hash(parents),coupleLinked,const DeepCollectionEquality().hash(subjects),entitlement,accessVersion);

@override
String toString() {
  return 'FamilyBootstrap(family: $family, me: $me, parents: $parents, coupleLinked: $coupleLinked, subjects: $subjects, entitlement: $entitlement, accessVersion: $accessVersion)';
}


}

/// @nodoc
abstract mixin class $FamilyBootstrapCopyWith<$Res>  {
  factory $FamilyBootstrapCopyWith(FamilyBootstrap value, $Res Function(FamilyBootstrap) _then) = _$FamilyBootstrapCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'family') BootstrapFamily? family,@JsonKey(name: 'me') BootstrapParent? me,@JsonKey(name: 'parents') List<BootstrapParent> parents,@JsonKey(name: 'coupleLinked') bool coupleLinked,@JsonKey(name: 'subjects') List<BootstrapSubject> subjects,@JsonKey(name: 'entitlement') BootstrapEntitlement? entitlement,@JsonKey(name: 'accessVersion') int? accessVersion
});


$BootstrapFamilyCopyWith<$Res>? get family;$BootstrapParentCopyWith<$Res>? get me;$BootstrapEntitlementCopyWith<$Res>? get entitlement;

}
/// @nodoc
class _$FamilyBootstrapCopyWithImpl<$Res>
    implements $FamilyBootstrapCopyWith<$Res> {
  _$FamilyBootstrapCopyWithImpl(this._self, this._then);

  final FamilyBootstrap _self;
  final $Res Function(FamilyBootstrap) _then;

/// Create a copy of FamilyBootstrap
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? family = freezed,Object? me = freezed,Object? parents = null,Object? coupleLinked = null,Object? subjects = null,Object? entitlement = freezed,Object? accessVersion = freezed,}) {
  return _then(_self.copyWith(
family: freezed == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as BootstrapFamily?,me: freezed == me ? _self.me : me // ignore: cast_nullable_to_non_nullable
as BootstrapParent?,parents: null == parents ? _self.parents : parents // ignore: cast_nullable_to_non_nullable
as List<BootstrapParent>,coupleLinked: null == coupleLinked ? _self.coupleLinked : coupleLinked // ignore: cast_nullable_to_non_nullable
as bool,subjects: null == subjects ? _self.subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<BootstrapSubject>,entitlement: freezed == entitlement ? _self.entitlement : entitlement // ignore: cast_nullable_to_non_nullable
as BootstrapEntitlement?,accessVersion: freezed == accessVersion ? _self.accessVersion : accessVersion // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of FamilyBootstrap
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BootstrapFamilyCopyWith<$Res>? get family {
    if (_self.family == null) {
    return null;
  }

  return $BootstrapFamilyCopyWith<$Res>(_self.family!, (value) {
    return _then(_self.copyWith(family: value));
  });
}/// Create a copy of FamilyBootstrap
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BootstrapParentCopyWith<$Res>? get me {
    if (_self.me == null) {
    return null;
  }

  return $BootstrapParentCopyWith<$Res>(_self.me!, (value) {
    return _then(_self.copyWith(me: value));
  });
}/// Create a copy of FamilyBootstrap
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BootstrapEntitlementCopyWith<$Res>? get entitlement {
    if (_self.entitlement == null) {
    return null;
  }

  return $BootstrapEntitlementCopyWith<$Res>(_self.entitlement!, (value) {
    return _then(_self.copyWith(entitlement: value));
  });
}
}


/// Adds pattern-matching-related methods to [FamilyBootstrap].
extension FamilyBootstrapPatterns on FamilyBootstrap {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyBootstrap value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyBootstrap() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyBootstrap value)  $default,){
final _that = this;
switch (_that) {
case _FamilyBootstrap():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyBootstrap value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyBootstrap() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FamilyBootstrap implements FamilyBootstrap {
  const _FamilyBootstrap({@JsonKey(name: 'family') this.family, @JsonKey(name: 'me') this.me, @JsonKey(name: 'parents') final  List<BootstrapParent> parents = const <BootstrapParent>[], @JsonKey(name: 'coupleLinked') this.coupleLinked = false, @JsonKey(name: 'subjects') final  List<BootstrapSubject> subjects = const <BootstrapSubject>[], @JsonKey(name: 'entitlement') this.entitlement, @JsonKey(name: 'accessVersion') this.accessVersion}): _parents = parents,_subjects = subjects;
  factory _FamilyBootstrap.fromJson(Map<String, dynamic> json) => _$FamilyBootstrapFromJson(json);

@override@JsonKey(name: 'family') final  BootstrapFamily? family;
@override@JsonKey(name: 'me') final  BootstrapParent? me;
 final  List<BootstrapParent> _parents;
@override@JsonKey(name: 'parents') List<BootstrapParent> get parents {
  if (_parents is EqualUnmodifiableListView) return _parents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parents);
}

@override@JsonKey(name: 'coupleLinked') final  bool coupleLinked;
 final  List<BootstrapSubject> _subjects;
@override@JsonKey(name: 'subjects') List<BootstrapSubject> get subjects {
  if (_subjects is EqualUnmodifiableListView) return _subjects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subjects);
}

@override@JsonKey(name: 'entitlement') final  BootstrapEntitlement? entitlement;
@override@JsonKey(name: 'accessVersion') final  int? accessVersion;

/// Create a copy of FamilyBootstrap
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyBootstrapCopyWith<_FamilyBootstrap> get copyWith => __$FamilyBootstrapCopyWithImpl<_FamilyBootstrap>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyBootstrapToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyBootstrap&&(identical(other.family, family) || other.family == family)&&(identical(other.me, me) || other.me == me)&&const DeepCollectionEquality().equals(other._parents, _parents)&&(identical(other.coupleLinked, coupleLinked) || other.coupleLinked == coupleLinked)&&const DeepCollectionEquality().equals(other._subjects, _subjects)&&(identical(other.entitlement, entitlement) || other.entitlement == entitlement)&&(identical(other.accessVersion, accessVersion) || other.accessVersion == accessVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,family,me,const DeepCollectionEquality().hash(_parents),coupleLinked,const DeepCollectionEquality().hash(_subjects),entitlement,accessVersion);

@override
String toString() {
  return 'FamilyBootstrap(family: $family, me: $me, parents: $parents, coupleLinked: $coupleLinked, subjects: $subjects, entitlement: $entitlement, accessVersion: $accessVersion)';
}


}

/// @nodoc
abstract mixin class _$FamilyBootstrapCopyWith<$Res> implements $FamilyBootstrapCopyWith<$Res> {
  factory _$FamilyBootstrapCopyWith(_FamilyBootstrap value, $Res Function(_FamilyBootstrap) _then) = __$FamilyBootstrapCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'family') BootstrapFamily? family,@JsonKey(name: 'me') BootstrapParent? me,@JsonKey(name: 'parents') List<BootstrapParent> parents,@JsonKey(name: 'coupleLinked') bool coupleLinked,@JsonKey(name: 'subjects') List<BootstrapSubject> subjects,@JsonKey(name: 'entitlement') BootstrapEntitlement? entitlement,@JsonKey(name: 'accessVersion') int? accessVersion
});


@override $BootstrapFamilyCopyWith<$Res>? get family;@override $BootstrapParentCopyWith<$Res>? get me;@override $BootstrapEntitlementCopyWith<$Res>? get entitlement;

}
/// @nodoc
class __$FamilyBootstrapCopyWithImpl<$Res>
    implements _$FamilyBootstrapCopyWith<$Res> {
  __$FamilyBootstrapCopyWithImpl(this._self, this._then);

  final _FamilyBootstrap _self;
  final $Res Function(_FamilyBootstrap) _then;

/// Create a copy of FamilyBootstrap
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? family = freezed,Object? me = freezed,Object? parents = null,Object? coupleLinked = null,Object? subjects = null,Object? entitlement = freezed,Object? accessVersion = freezed,}) {
  return _then(_FamilyBootstrap(
family: freezed == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as BootstrapFamily?,me: freezed == me ? _self.me : me // ignore: cast_nullable_to_non_nullable
as BootstrapParent?,parents: null == parents ? _self._parents : parents // ignore: cast_nullable_to_non_nullable
as List<BootstrapParent>,coupleLinked: null == coupleLinked ? _self.coupleLinked : coupleLinked // ignore: cast_nullable_to_non_nullable
as bool,subjects: null == subjects ? _self._subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<BootstrapSubject>,entitlement: freezed == entitlement ? _self.entitlement : entitlement // ignore: cast_nullable_to_non_nullable
as BootstrapEntitlement?,accessVersion: freezed == accessVersion ? _self.accessVersion : accessVersion // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of FamilyBootstrap
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BootstrapFamilyCopyWith<$Res>? get family {
    if (_self.family == null) {
    return null;
  }

  return $BootstrapFamilyCopyWith<$Res>(_self.family!, (value) {
    return _then(_self.copyWith(family: value));
  });
}/// Create a copy of FamilyBootstrap
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BootstrapParentCopyWith<$Res>? get me {
    if (_self.me == null) {
    return null;
  }

  return $BootstrapParentCopyWith<$Res>(_self.me!, (value) {
    return _then(_self.copyWith(me: value));
  });
}/// Create a copy of FamilyBootstrap
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BootstrapEntitlementCopyWith<$Res>? get entitlement {
    if (_self.entitlement == null) {
    return null;
  }

  return $BootstrapEntitlementCopyWith<$Res>(_self.entitlement!, (value) {
    return _then(_self.copyWith(entitlement: value));
  });
}
}

// dart format on
