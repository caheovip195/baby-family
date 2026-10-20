// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_overview_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrivacyOverviewRecord {

@JsonKey(name: 'defaults') PrivacyDefaultsRecord? get defaults;@JsonKey(name: 'pendingInvites') int get pendingInvites;@JsonKey(name: 'blockedCount') int get blockedCount;@JsonKey(name: 'deletion') FamilyDeletionRecord? get deletion;
/// Create a copy of PrivacyOverviewRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivacyOverviewRecordCopyWith<PrivacyOverviewRecord> get copyWith => _$PrivacyOverviewRecordCopyWithImpl<PrivacyOverviewRecord>(this as PrivacyOverviewRecord, _$identity);

  /// Serializes this PrivacyOverviewRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivacyOverviewRecord&&(identical(other.defaults, defaults) || other.defaults == defaults)&&(identical(other.pendingInvites, pendingInvites) || other.pendingInvites == pendingInvites)&&(identical(other.blockedCount, blockedCount) || other.blockedCount == blockedCount)&&(identical(other.deletion, deletion) || other.deletion == deletion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaults,pendingInvites,blockedCount,deletion);

@override
String toString() {
  return 'PrivacyOverviewRecord(defaults: $defaults, pendingInvites: $pendingInvites, blockedCount: $blockedCount, deletion: $deletion)';
}


}

/// @nodoc
abstract mixin class $PrivacyOverviewRecordCopyWith<$Res>  {
  factory $PrivacyOverviewRecordCopyWith(PrivacyOverviewRecord value, $Res Function(PrivacyOverviewRecord) _then) = _$PrivacyOverviewRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'defaults') PrivacyDefaultsRecord? defaults,@JsonKey(name: 'pendingInvites') int pendingInvites,@JsonKey(name: 'blockedCount') int blockedCount,@JsonKey(name: 'deletion') FamilyDeletionRecord? deletion
});


$PrivacyDefaultsRecordCopyWith<$Res>? get defaults;$FamilyDeletionRecordCopyWith<$Res>? get deletion;

}
/// @nodoc
class _$PrivacyOverviewRecordCopyWithImpl<$Res>
    implements $PrivacyOverviewRecordCopyWith<$Res> {
  _$PrivacyOverviewRecordCopyWithImpl(this._self, this._then);

  final PrivacyOverviewRecord _self;
  final $Res Function(PrivacyOverviewRecord) _then;

/// Create a copy of PrivacyOverviewRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? defaults = freezed,Object? pendingInvites = null,Object? blockedCount = null,Object? deletion = freezed,}) {
  return _then(_self.copyWith(
defaults: freezed == defaults ? _self.defaults : defaults // ignore: cast_nullable_to_non_nullable
as PrivacyDefaultsRecord?,pendingInvites: null == pendingInvites ? _self.pendingInvites : pendingInvites // ignore: cast_nullable_to_non_nullable
as int,blockedCount: null == blockedCount ? _self.blockedCount : blockedCount // ignore: cast_nullable_to_non_nullable
as int,deletion: freezed == deletion ? _self.deletion : deletion // ignore: cast_nullable_to_non_nullable
as FamilyDeletionRecord?,
  ));
}
/// Create a copy of PrivacyOverviewRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrivacyDefaultsRecordCopyWith<$Res>? get defaults {
    if (_self.defaults == null) {
    return null;
  }

  return $PrivacyDefaultsRecordCopyWith<$Res>(_self.defaults!, (value) {
    return _then(_self.copyWith(defaults: value));
  });
}/// Create a copy of PrivacyOverviewRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FamilyDeletionRecordCopyWith<$Res>? get deletion {
    if (_self.deletion == null) {
    return null;
  }

  return $FamilyDeletionRecordCopyWith<$Res>(_self.deletion!, (value) {
    return _then(_self.copyWith(deletion: value));
  });
}
}


/// Adds pattern-matching-related methods to [PrivacyOverviewRecord].
extension PrivacyOverviewRecordPatterns on PrivacyOverviewRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivacyOverviewRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivacyOverviewRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivacyOverviewRecord value)  $default,){
final _that = this;
switch (_that) {
case _PrivacyOverviewRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivacyOverviewRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PrivacyOverviewRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PrivacyOverviewRecord implements PrivacyOverviewRecord {
  const _PrivacyOverviewRecord({@JsonKey(name: 'defaults') this.defaults, @JsonKey(name: 'pendingInvites') this.pendingInvites = 0, @JsonKey(name: 'blockedCount') this.blockedCount = 0, @JsonKey(name: 'deletion') this.deletion});
  factory _PrivacyOverviewRecord.fromJson(Map<String, dynamic> json) => _$PrivacyOverviewRecordFromJson(json);

@override@JsonKey(name: 'defaults') final  PrivacyDefaultsRecord? defaults;
@override@JsonKey(name: 'pendingInvites') final  int pendingInvites;
@override@JsonKey(name: 'blockedCount') final  int blockedCount;
@override@JsonKey(name: 'deletion') final  FamilyDeletionRecord? deletion;

/// Create a copy of PrivacyOverviewRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivacyOverviewRecordCopyWith<_PrivacyOverviewRecord> get copyWith => __$PrivacyOverviewRecordCopyWithImpl<_PrivacyOverviewRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrivacyOverviewRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivacyOverviewRecord&&(identical(other.defaults, defaults) || other.defaults == defaults)&&(identical(other.pendingInvites, pendingInvites) || other.pendingInvites == pendingInvites)&&(identical(other.blockedCount, blockedCount) || other.blockedCount == blockedCount)&&(identical(other.deletion, deletion) || other.deletion == deletion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaults,pendingInvites,blockedCount,deletion);

@override
String toString() {
  return 'PrivacyOverviewRecord(defaults: $defaults, pendingInvites: $pendingInvites, blockedCount: $blockedCount, deletion: $deletion)';
}


}

/// @nodoc
abstract mixin class _$PrivacyOverviewRecordCopyWith<$Res> implements $PrivacyOverviewRecordCopyWith<$Res> {
  factory _$PrivacyOverviewRecordCopyWith(_PrivacyOverviewRecord value, $Res Function(_PrivacyOverviewRecord) _then) = __$PrivacyOverviewRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'defaults') PrivacyDefaultsRecord? defaults,@JsonKey(name: 'pendingInvites') int pendingInvites,@JsonKey(name: 'blockedCount') int blockedCount,@JsonKey(name: 'deletion') FamilyDeletionRecord? deletion
});


@override $PrivacyDefaultsRecordCopyWith<$Res>? get defaults;@override $FamilyDeletionRecordCopyWith<$Res>? get deletion;

}
/// @nodoc
class __$PrivacyOverviewRecordCopyWithImpl<$Res>
    implements _$PrivacyOverviewRecordCopyWith<$Res> {
  __$PrivacyOverviewRecordCopyWithImpl(this._self, this._then);

  final _PrivacyOverviewRecord _self;
  final $Res Function(_PrivacyOverviewRecord) _then;

/// Create a copy of PrivacyOverviewRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? defaults = freezed,Object? pendingInvites = null,Object? blockedCount = null,Object? deletion = freezed,}) {
  return _then(_PrivacyOverviewRecord(
defaults: freezed == defaults ? _self.defaults : defaults // ignore: cast_nullable_to_non_nullable
as PrivacyDefaultsRecord?,pendingInvites: null == pendingInvites ? _self.pendingInvites : pendingInvites // ignore: cast_nullable_to_non_nullable
as int,blockedCount: null == blockedCount ? _self.blockedCount : blockedCount // ignore: cast_nullable_to_non_nullable
as int,deletion: freezed == deletion ? _self.deletion : deletion // ignore: cast_nullable_to_non_nullable
as FamilyDeletionRecord?,
  ));
}

/// Create a copy of PrivacyOverviewRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrivacyDefaultsRecordCopyWith<$Res>? get defaults {
    if (_self.defaults == null) {
    return null;
  }

  return $PrivacyDefaultsRecordCopyWith<$Res>(_self.defaults!, (value) {
    return _then(_self.copyWith(defaults: value));
  });
}/// Create a copy of PrivacyOverviewRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FamilyDeletionRecordCopyWith<$Res>? get deletion {
    if (_self.deletion == null) {
    return null;
  }

  return $FamilyDeletionRecordCopyWith<$Res>(_self.deletion!, (value) {
    return _then(_self.copyWith(deletion: value));
  });
}
}


/// @nodoc
mixin _$PrivacyDefaultsRecord {

@JsonKey(name: 'defaultVisibility') String? get defaultVisibility;@JsonKey(name: 'requireCircleReview') bool? get requireCircleReview;
/// Create a copy of PrivacyDefaultsRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivacyDefaultsRecordCopyWith<PrivacyDefaultsRecord> get copyWith => _$PrivacyDefaultsRecordCopyWithImpl<PrivacyDefaultsRecord>(this as PrivacyDefaultsRecord, _$identity);

  /// Serializes this PrivacyDefaultsRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivacyDefaultsRecord&&(identical(other.defaultVisibility, defaultVisibility) || other.defaultVisibility == defaultVisibility)&&(identical(other.requireCircleReview, requireCircleReview) || other.requireCircleReview == requireCircleReview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultVisibility,requireCircleReview);

@override
String toString() {
  return 'PrivacyDefaultsRecord(defaultVisibility: $defaultVisibility, requireCircleReview: $requireCircleReview)';
}


}

/// @nodoc
abstract mixin class $PrivacyDefaultsRecordCopyWith<$Res>  {
  factory $PrivacyDefaultsRecordCopyWith(PrivacyDefaultsRecord value, $Res Function(PrivacyDefaultsRecord) _then) = _$PrivacyDefaultsRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'defaultVisibility') String? defaultVisibility,@JsonKey(name: 'requireCircleReview') bool? requireCircleReview
});




}
/// @nodoc
class _$PrivacyDefaultsRecordCopyWithImpl<$Res>
    implements $PrivacyDefaultsRecordCopyWith<$Res> {
  _$PrivacyDefaultsRecordCopyWithImpl(this._self, this._then);

  final PrivacyDefaultsRecord _self;
  final $Res Function(PrivacyDefaultsRecord) _then;

/// Create a copy of PrivacyDefaultsRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? defaultVisibility = freezed,Object? requireCircleReview = freezed,}) {
  return _then(_self.copyWith(
defaultVisibility: freezed == defaultVisibility ? _self.defaultVisibility : defaultVisibility // ignore: cast_nullable_to_non_nullable
as String?,requireCircleReview: freezed == requireCircleReview ? _self.requireCircleReview : requireCircleReview // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivacyDefaultsRecord].
extension PrivacyDefaultsRecordPatterns on PrivacyDefaultsRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivacyDefaultsRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivacyDefaultsRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivacyDefaultsRecord value)  $default,){
final _that = this;
switch (_that) {
case _PrivacyDefaultsRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivacyDefaultsRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PrivacyDefaultsRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PrivacyDefaultsRecord implements PrivacyDefaultsRecord {
  const _PrivacyDefaultsRecord({@JsonKey(name: 'defaultVisibility') this.defaultVisibility, @JsonKey(name: 'requireCircleReview') this.requireCircleReview});
  factory _PrivacyDefaultsRecord.fromJson(Map<String, dynamic> json) => _$PrivacyDefaultsRecordFromJson(json);

@override@JsonKey(name: 'defaultVisibility') final  String? defaultVisibility;
@override@JsonKey(name: 'requireCircleReview') final  bool? requireCircleReview;

/// Create a copy of PrivacyDefaultsRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivacyDefaultsRecordCopyWith<_PrivacyDefaultsRecord> get copyWith => __$PrivacyDefaultsRecordCopyWithImpl<_PrivacyDefaultsRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrivacyDefaultsRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivacyDefaultsRecord&&(identical(other.defaultVisibility, defaultVisibility) || other.defaultVisibility == defaultVisibility)&&(identical(other.requireCircleReview, requireCircleReview) || other.requireCircleReview == requireCircleReview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultVisibility,requireCircleReview);

@override
String toString() {
  return 'PrivacyDefaultsRecord(defaultVisibility: $defaultVisibility, requireCircleReview: $requireCircleReview)';
}


}

/// @nodoc
abstract mixin class _$PrivacyDefaultsRecordCopyWith<$Res> implements $PrivacyDefaultsRecordCopyWith<$Res> {
  factory _$PrivacyDefaultsRecordCopyWith(_PrivacyDefaultsRecord value, $Res Function(_PrivacyDefaultsRecord) _then) = __$PrivacyDefaultsRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'defaultVisibility') String? defaultVisibility,@JsonKey(name: 'requireCircleReview') bool? requireCircleReview
});




}
/// @nodoc
class __$PrivacyDefaultsRecordCopyWithImpl<$Res>
    implements _$PrivacyDefaultsRecordCopyWith<$Res> {
  __$PrivacyDefaultsRecordCopyWithImpl(this._self, this._then);

  final _PrivacyDefaultsRecord _self;
  final $Res Function(_PrivacyDefaultsRecord) _then;

/// Create a copy of PrivacyDefaultsRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? defaultVisibility = freezed,Object? requireCircleReview = freezed,}) {
  return _then(_PrivacyDefaultsRecord(
defaultVisibility: freezed == defaultVisibility ? _self.defaultVisibility : defaultVisibility // ignore: cast_nullable_to_non_nullable
as String?,requireCircleReview: freezed == requireCircleReview ? _self.requireCircleReview : requireCircleReview // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
