// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_settings_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilySettingsRecord {

@JsonKey(name: 'showLunar') bool? get showLunar;@JsonKey(name: 'circleCanSeeTree') bool? get circleCanSeeTree;@JsonKey(name: 'defaultVisibility') String? get defaultVisibility;@JsonKey(name: 'requireCircleReview') bool? get requireCircleReview;@JsonKey(name: 'traditionalUseLunar') bool? get traditionalUseLunar;@JsonKey(name: 'milestoneSuggestions') bool? get milestoneSuggestions;
/// Create a copy of FamilySettingsRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilySettingsRecordCopyWith<FamilySettingsRecord> get copyWith => _$FamilySettingsRecordCopyWithImpl<FamilySettingsRecord>(this as FamilySettingsRecord, _$identity);

  /// Serializes this FamilySettingsRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilySettingsRecord&&(identical(other.showLunar, showLunar) || other.showLunar == showLunar)&&(identical(other.circleCanSeeTree, circleCanSeeTree) || other.circleCanSeeTree == circleCanSeeTree)&&(identical(other.defaultVisibility, defaultVisibility) || other.defaultVisibility == defaultVisibility)&&(identical(other.requireCircleReview, requireCircleReview) || other.requireCircleReview == requireCircleReview)&&(identical(other.traditionalUseLunar, traditionalUseLunar) || other.traditionalUseLunar == traditionalUseLunar)&&(identical(other.milestoneSuggestions, milestoneSuggestions) || other.milestoneSuggestions == milestoneSuggestions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,showLunar,circleCanSeeTree,defaultVisibility,requireCircleReview,traditionalUseLunar,milestoneSuggestions);

@override
String toString() {
  return 'FamilySettingsRecord(showLunar: $showLunar, circleCanSeeTree: $circleCanSeeTree, defaultVisibility: $defaultVisibility, requireCircleReview: $requireCircleReview, traditionalUseLunar: $traditionalUseLunar, milestoneSuggestions: $milestoneSuggestions)';
}


}

/// @nodoc
abstract mixin class $FamilySettingsRecordCopyWith<$Res>  {
  factory $FamilySettingsRecordCopyWith(FamilySettingsRecord value, $Res Function(FamilySettingsRecord) _then) = _$FamilySettingsRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'showLunar') bool? showLunar,@JsonKey(name: 'circleCanSeeTree') bool? circleCanSeeTree,@JsonKey(name: 'defaultVisibility') String? defaultVisibility,@JsonKey(name: 'requireCircleReview') bool? requireCircleReview,@JsonKey(name: 'traditionalUseLunar') bool? traditionalUseLunar,@JsonKey(name: 'milestoneSuggestions') bool? milestoneSuggestions
});




}
/// @nodoc
class _$FamilySettingsRecordCopyWithImpl<$Res>
    implements $FamilySettingsRecordCopyWith<$Res> {
  _$FamilySettingsRecordCopyWithImpl(this._self, this._then);

  final FamilySettingsRecord _self;
  final $Res Function(FamilySettingsRecord) _then;

/// Create a copy of FamilySettingsRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showLunar = freezed,Object? circleCanSeeTree = freezed,Object? defaultVisibility = freezed,Object? requireCircleReview = freezed,Object? traditionalUseLunar = freezed,Object? milestoneSuggestions = freezed,}) {
  return _then(_self.copyWith(
showLunar: freezed == showLunar ? _self.showLunar : showLunar // ignore: cast_nullable_to_non_nullable
as bool?,circleCanSeeTree: freezed == circleCanSeeTree ? _self.circleCanSeeTree : circleCanSeeTree // ignore: cast_nullable_to_non_nullable
as bool?,defaultVisibility: freezed == defaultVisibility ? _self.defaultVisibility : defaultVisibility // ignore: cast_nullable_to_non_nullable
as String?,requireCircleReview: freezed == requireCircleReview ? _self.requireCircleReview : requireCircleReview // ignore: cast_nullable_to_non_nullable
as bool?,traditionalUseLunar: freezed == traditionalUseLunar ? _self.traditionalUseLunar : traditionalUseLunar // ignore: cast_nullable_to_non_nullable
as bool?,milestoneSuggestions: freezed == milestoneSuggestions ? _self.milestoneSuggestions : milestoneSuggestions // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilySettingsRecord].
extension FamilySettingsRecordPatterns on FamilySettingsRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilySettingsRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilySettingsRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilySettingsRecord value)  $default,){
final _that = this;
switch (_that) {
case _FamilySettingsRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilySettingsRecord value)?  $default,){
final _that = this;
switch (_that) {
case _FamilySettingsRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FamilySettingsRecord implements FamilySettingsRecord {
  const _FamilySettingsRecord({@JsonKey(name: 'showLunar') this.showLunar, @JsonKey(name: 'circleCanSeeTree') this.circleCanSeeTree, @JsonKey(name: 'defaultVisibility') this.defaultVisibility, @JsonKey(name: 'requireCircleReview') this.requireCircleReview, @JsonKey(name: 'traditionalUseLunar') this.traditionalUseLunar, @JsonKey(name: 'milestoneSuggestions') this.milestoneSuggestions});
  factory _FamilySettingsRecord.fromJson(Map<String, dynamic> json) => _$FamilySettingsRecordFromJson(json);

@override@JsonKey(name: 'showLunar') final  bool? showLunar;
@override@JsonKey(name: 'circleCanSeeTree') final  bool? circleCanSeeTree;
@override@JsonKey(name: 'defaultVisibility') final  String? defaultVisibility;
@override@JsonKey(name: 'requireCircleReview') final  bool? requireCircleReview;
@override@JsonKey(name: 'traditionalUseLunar') final  bool? traditionalUseLunar;
@override@JsonKey(name: 'milestoneSuggestions') final  bool? milestoneSuggestions;

/// Create a copy of FamilySettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilySettingsRecordCopyWith<_FamilySettingsRecord> get copyWith => __$FamilySettingsRecordCopyWithImpl<_FamilySettingsRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilySettingsRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilySettingsRecord&&(identical(other.showLunar, showLunar) || other.showLunar == showLunar)&&(identical(other.circleCanSeeTree, circleCanSeeTree) || other.circleCanSeeTree == circleCanSeeTree)&&(identical(other.defaultVisibility, defaultVisibility) || other.defaultVisibility == defaultVisibility)&&(identical(other.requireCircleReview, requireCircleReview) || other.requireCircleReview == requireCircleReview)&&(identical(other.traditionalUseLunar, traditionalUseLunar) || other.traditionalUseLunar == traditionalUseLunar)&&(identical(other.milestoneSuggestions, milestoneSuggestions) || other.milestoneSuggestions == milestoneSuggestions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,showLunar,circleCanSeeTree,defaultVisibility,requireCircleReview,traditionalUseLunar,milestoneSuggestions);

@override
String toString() {
  return 'FamilySettingsRecord(showLunar: $showLunar, circleCanSeeTree: $circleCanSeeTree, defaultVisibility: $defaultVisibility, requireCircleReview: $requireCircleReview, traditionalUseLunar: $traditionalUseLunar, milestoneSuggestions: $milestoneSuggestions)';
}


}

/// @nodoc
abstract mixin class _$FamilySettingsRecordCopyWith<$Res> implements $FamilySettingsRecordCopyWith<$Res> {
  factory _$FamilySettingsRecordCopyWith(_FamilySettingsRecord value, $Res Function(_FamilySettingsRecord) _then) = __$FamilySettingsRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'showLunar') bool? showLunar,@JsonKey(name: 'circleCanSeeTree') bool? circleCanSeeTree,@JsonKey(name: 'defaultVisibility') String? defaultVisibility,@JsonKey(name: 'requireCircleReview') bool? requireCircleReview,@JsonKey(name: 'traditionalUseLunar') bool? traditionalUseLunar,@JsonKey(name: 'milestoneSuggestions') bool? milestoneSuggestions
});




}
/// @nodoc
class __$FamilySettingsRecordCopyWithImpl<$Res>
    implements _$FamilySettingsRecordCopyWith<$Res> {
  __$FamilySettingsRecordCopyWithImpl(this._self, this._then);

  final _FamilySettingsRecord _self;
  final $Res Function(_FamilySettingsRecord) _then;

/// Create a copy of FamilySettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showLunar = freezed,Object? circleCanSeeTree = freezed,Object? defaultVisibility = freezed,Object? requireCircleReview = freezed,Object? traditionalUseLunar = freezed,Object? milestoneSuggestions = freezed,}) {
  return _then(_FamilySettingsRecord(
showLunar: freezed == showLunar ? _self.showLunar : showLunar // ignore: cast_nullable_to_non_nullable
as bool?,circleCanSeeTree: freezed == circleCanSeeTree ? _self.circleCanSeeTree : circleCanSeeTree // ignore: cast_nullable_to_non_nullable
as bool?,defaultVisibility: freezed == defaultVisibility ? _self.defaultVisibility : defaultVisibility // ignore: cast_nullable_to_non_nullable
as String?,requireCircleReview: freezed == requireCircleReview ? _self.requireCircleReview : requireCircleReview // ignore: cast_nullable_to_non_nullable
as bool?,traditionalUseLunar: freezed == traditionalUseLunar ? _self.traditionalUseLunar : traditionalUseLunar // ignore: cast_nullable_to_non_nullable
as bool?,milestoneSuggestions: freezed == milestoneSuggestions ? _self.milestoneSuggestions : milestoneSuggestions // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
