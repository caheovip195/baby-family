// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChildProfile {

@JsonKey(name: 'childId') String get childId;@JsonKey(name: 'fullName') String? get fullName;@JsonKey(name: 'gestationWeeks') int? get gestationWeeks;@JsonKey(name: 'showBirthTimeToRelatives') bool get showBirthTimeToRelatives;@JsonKey(name: 'nameStory') String? get nameStory;@JsonKey(name: 'nameGivenBy') List<String> get nameGivenBy;@JsonKey(name: 'favoriteFood') String? get favoriteFood;@JsonKey(name: 'favoriteToy') String? get favoriteToy;@JsonKey(name: 'favoriteSong') String? get favoriteSong;@JsonKey(name: 'memoryCount') int get memoryCount;@JsonKey(name: 'milestoneCount') int get milestoneCount;@JsonKey(name: 'letterCount') int get letterCount;@JsonKey(name: 'privateMemoryCount') int get privateMemoryCount;@JsonKey(name: 'relativeViewerNames') List<String> get relativeViewerNames;/// CHD-05.
@JsonKey(name: 'addedByUserId') String? get addedByUserId;@JsonKey(name: 'addedAt') DateTime? get addedAt;@JsonKey(name: 'duplicateOfChildId') String? get duplicateOfChildId;@JsonKey(name: 'sharedMemoryCount') int get sharedMemoryCount;@JsonKey(name: 'sharedWithChildIds') List<String> get sharedWithChildIds;
/// Create a copy of ChildProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildProfileCopyWith<ChildProfile> get copyWith => _$ChildProfileCopyWithImpl<ChildProfile>(this as ChildProfile, _$identity);

  /// Serializes this ChildProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChildProfile&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.gestationWeeks, gestationWeeks) || other.gestationWeeks == gestationWeeks)&&(identical(other.showBirthTimeToRelatives, showBirthTimeToRelatives) || other.showBirthTimeToRelatives == showBirthTimeToRelatives)&&(identical(other.nameStory, nameStory) || other.nameStory == nameStory)&&const DeepCollectionEquality().equals(other.nameGivenBy, nameGivenBy)&&(identical(other.favoriteFood, favoriteFood) || other.favoriteFood == favoriteFood)&&(identical(other.favoriteToy, favoriteToy) || other.favoriteToy == favoriteToy)&&(identical(other.favoriteSong, favoriteSong) || other.favoriteSong == favoriteSong)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&(identical(other.milestoneCount, milestoneCount) || other.milestoneCount == milestoneCount)&&(identical(other.letterCount, letterCount) || other.letterCount == letterCount)&&(identical(other.privateMemoryCount, privateMemoryCount) || other.privateMemoryCount == privateMemoryCount)&&const DeepCollectionEquality().equals(other.relativeViewerNames, relativeViewerNames)&&(identical(other.addedByUserId, addedByUserId) || other.addedByUserId == addedByUserId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.duplicateOfChildId, duplicateOfChildId) || other.duplicateOfChildId == duplicateOfChildId)&&(identical(other.sharedMemoryCount, sharedMemoryCount) || other.sharedMemoryCount == sharedMemoryCount)&&const DeepCollectionEquality().equals(other.sharedWithChildIds, sharedWithChildIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,childId,fullName,gestationWeeks,showBirthTimeToRelatives,nameStory,const DeepCollectionEquality().hash(nameGivenBy),favoriteFood,favoriteToy,favoriteSong,memoryCount,milestoneCount,letterCount,privateMemoryCount,const DeepCollectionEquality().hash(relativeViewerNames),addedByUserId,addedAt,duplicateOfChildId,sharedMemoryCount,const DeepCollectionEquality().hash(sharedWithChildIds)]);

@override
String toString() {
  return 'ChildProfile(childId: $childId, fullName: $fullName, gestationWeeks: $gestationWeeks, showBirthTimeToRelatives: $showBirthTimeToRelatives, nameStory: $nameStory, nameGivenBy: $nameGivenBy, favoriteFood: $favoriteFood, favoriteToy: $favoriteToy, favoriteSong: $favoriteSong, memoryCount: $memoryCount, milestoneCount: $milestoneCount, letterCount: $letterCount, privateMemoryCount: $privateMemoryCount, relativeViewerNames: $relativeViewerNames, addedByUserId: $addedByUserId, addedAt: $addedAt, duplicateOfChildId: $duplicateOfChildId, sharedMemoryCount: $sharedMemoryCount, sharedWithChildIds: $sharedWithChildIds)';
}


}

/// @nodoc
abstract mixin class $ChildProfileCopyWith<$Res>  {
  factory $ChildProfileCopyWith(ChildProfile value, $Res Function(ChildProfile) _then) = _$ChildProfileCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'childId') String childId,@JsonKey(name: 'fullName') String? fullName,@JsonKey(name: 'gestationWeeks') int? gestationWeeks,@JsonKey(name: 'showBirthTimeToRelatives') bool showBirthTimeToRelatives,@JsonKey(name: 'nameStory') String? nameStory,@JsonKey(name: 'nameGivenBy') List<String> nameGivenBy,@JsonKey(name: 'favoriteFood') String? favoriteFood,@JsonKey(name: 'favoriteToy') String? favoriteToy,@JsonKey(name: 'favoriteSong') String? favoriteSong,@JsonKey(name: 'memoryCount') int memoryCount,@JsonKey(name: 'milestoneCount') int milestoneCount,@JsonKey(name: 'letterCount') int letterCount,@JsonKey(name: 'privateMemoryCount') int privateMemoryCount,@JsonKey(name: 'relativeViewerNames') List<String> relativeViewerNames,@JsonKey(name: 'addedByUserId') String? addedByUserId,@JsonKey(name: 'addedAt') DateTime? addedAt,@JsonKey(name: 'duplicateOfChildId') String? duplicateOfChildId,@JsonKey(name: 'sharedMemoryCount') int sharedMemoryCount,@JsonKey(name: 'sharedWithChildIds') List<String> sharedWithChildIds
});




}
/// @nodoc
class _$ChildProfileCopyWithImpl<$Res>
    implements $ChildProfileCopyWith<$Res> {
  _$ChildProfileCopyWithImpl(this._self, this._then);

  final ChildProfile _self;
  final $Res Function(ChildProfile) _then;

/// Create a copy of ChildProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childId = null,Object? fullName = freezed,Object? gestationWeeks = freezed,Object? showBirthTimeToRelatives = null,Object? nameStory = freezed,Object? nameGivenBy = null,Object? favoriteFood = freezed,Object? favoriteToy = freezed,Object? favoriteSong = freezed,Object? memoryCount = null,Object? milestoneCount = null,Object? letterCount = null,Object? privateMemoryCount = null,Object? relativeViewerNames = null,Object? addedByUserId = freezed,Object? addedAt = freezed,Object? duplicateOfChildId = freezed,Object? sharedMemoryCount = null,Object? sharedWithChildIds = null,}) {
  return _then(_self.copyWith(
childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,gestationWeeks: freezed == gestationWeeks ? _self.gestationWeeks : gestationWeeks // ignore: cast_nullable_to_non_nullable
as int?,showBirthTimeToRelatives: null == showBirthTimeToRelatives ? _self.showBirthTimeToRelatives : showBirthTimeToRelatives // ignore: cast_nullable_to_non_nullable
as bool,nameStory: freezed == nameStory ? _self.nameStory : nameStory // ignore: cast_nullable_to_non_nullable
as String?,nameGivenBy: null == nameGivenBy ? _self.nameGivenBy : nameGivenBy // ignore: cast_nullable_to_non_nullable
as List<String>,favoriteFood: freezed == favoriteFood ? _self.favoriteFood : favoriteFood // ignore: cast_nullable_to_non_nullable
as String?,favoriteToy: freezed == favoriteToy ? _self.favoriteToy : favoriteToy // ignore: cast_nullable_to_non_nullable
as String?,favoriteSong: freezed == favoriteSong ? _self.favoriteSong : favoriteSong // ignore: cast_nullable_to_non_nullable
as String?,memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,milestoneCount: null == milestoneCount ? _self.milestoneCount : milestoneCount // ignore: cast_nullable_to_non_nullable
as int,letterCount: null == letterCount ? _self.letterCount : letterCount // ignore: cast_nullable_to_non_nullable
as int,privateMemoryCount: null == privateMemoryCount ? _self.privateMemoryCount : privateMemoryCount // ignore: cast_nullable_to_non_nullable
as int,relativeViewerNames: null == relativeViewerNames ? _self.relativeViewerNames : relativeViewerNames // ignore: cast_nullable_to_non_nullable
as List<String>,addedByUserId: freezed == addedByUserId ? _self.addedByUserId : addedByUserId // ignore: cast_nullable_to_non_nullable
as String?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,duplicateOfChildId: freezed == duplicateOfChildId ? _self.duplicateOfChildId : duplicateOfChildId // ignore: cast_nullable_to_non_nullable
as String?,sharedMemoryCount: null == sharedMemoryCount ? _self.sharedMemoryCount : sharedMemoryCount // ignore: cast_nullable_to_non_nullable
as int,sharedWithChildIds: null == sharedWithChildIds ? _self.sharedWithChildIds : sharedWithChildIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChildProfile].
extension ChildProfilePatterns on ChildProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChildProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChildProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChildProfile value)  $default,){
final _that = this;
switch (_that) {
case _ChildProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChildProfile value)?  $default,){
final _that = this;
switch (_that) {
case _ChildProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChildProfile implements ChildProfile {
  const _ChildProfile({@JsonKey(name: 'childId') required this.childId, @JsonKey(name: 'fullName') this.fullName, @JsonKey(name: 'gestationWeeks') this.gestationWeeks, @JsonKey(name: 'showBirthTimeToRelatives') this.showBirthTimeToRelatives = false, @JsonKey(name: 'nameStory') this.nameStory, @JsonKey(name: 'nameGivenBy') final  List<String> nameGivenBy = const [], @JsonKey(name: 'favoriteFood') this.favoriteFood, @JsonKey(name: 'favoriteToy') this.favoriteToy, @JsonKey(name: 'favoriteSong') this.favoriteSong, @JsonKey(name: 'memoryCount') this.memoryCount = 0, @JsonKey(name: 'milestoneCount') this.milestoneCount = 0, @JsonKey(name: 'letterCount') this.letterCount = 0, @JsonKey(name: 'privateMemoryCount') this.privateMemoryCount = 0, @JsonKey(name: 'relativeViewerNames') final  List<String> relativeViewerNames = const [], @JsonKey(name: 'addedByUserId') this.addedByUserId, @JsonKey(name: 'addedAt') this.addedAt, @JsonKey(name: 'duplicateOfChildId') this.duplicateOfChildId, @JsonKey(name: 'sharedMemoryCount') this.sharedMemoryCount = 0, @JsonKey(name: 'sharedWithChildIds') final  List<String> sharedWithChildIds = const []}): _nameGivenBy = nameGivenBy,_relativeViewerNames = relativeViewerNames,_sharedWithChildIds = sharedWithChildIds;
  factory _ChildProfile.fromJson(Map<String, dynamic> json) => _$ChildProfileFromJson(json);

@override@JsonKey(name: 'childId') final  String childId;
@override@JsonKey(name: 'fullName') final  String? fullName;
@override@JsonKey(name: 'gestationWeeks') final  int? gestationWeeks;
@override@JsonKey(name: 'showBirthTimeToRelatives') final  bool showBirthTimeToRelatives;
@override@JsonKey(name: 'nameStory') final  String? nameStory;
 final  List<String> _nameGivenBy;
@override@JsonKey(name: 'nameGivenBy') List<String> get nameGivenBy {
  if (_nameGivenBy is EqualUnmodifiableListView) return _nameGivenBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nameGivenBy);
}

@override@JsonKey(name: 'favoriteFood') final  String? favoriteFood;
@override@JsonKey(name: 'favoriteToy') final  String? favoriteToy;
@override@JsonKey(name: 'favoriteSong') final  String? favoriteSong;
@override@JsonKey(name: 'memoryCount') final  int memoryCount;
@override@JsonKey(name: 'milestoneCount') final  int milestoneCount;
@override@JsonKey(name: 'letterCount') final  int letterCount;
@override@JsonKey(name: 'privateMemoryCount') final  int privateMemoryCount;
 final  List<String> _relativeViewerNames;
@override@JsonKey(name: 'relativeViewerNames') List<String> get relativeViewerNames {
  if (_relativeViewerNames is EqualUnmodifiableListView) return _relativeViewerNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_relativeViewerNames);
}

/// CHD-05.
@override@JsonKey(name: 'addedByUserId') final  String? addedByUserId;
@override@JsonKey(name: 'addedAt') final  DateTime? addedAt;
@override@JsonKey(name: 'duplicateOfChildId') final  String? duplicateOfChildId;
@override@JsonKey(name: 'sharedMemoryCount') final  int sharedMemoryCount;
 final  List<String> _sharedWithChildIds;
@override@JsonKey(name: 'sharedWithChildIds') List<String> get sharedWithChildIds {
  if (_sharedWithChildIds is EqualUnmodifiableListView) return _sharedWithChildIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sharedWithChildIds);
}


/// Create a copy of ChildProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildProfileCopyWith<_ChildProfile> get copyWith => __$ChildProfileCopyWithImpl<_ChildProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChildProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChildProfile&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.gestationWeeks, gestationWeeks) || other.gestationWeeks == gestationWeeks)&&(identical(other.showBirthTimeToRelatives, showBirthTimeToRelatives) || other.showBirthTimeToRelatives == showBirthTimeToRelatives)&&(identical(other.nameStory, nameStory) || other.nameStory == nameStory)&&const DeepCollectionEquality().equals(other._nameGivenBy, _nameGivenBy)&&(identical(other.favoriteFood, favoriteFood) || other.favoriteFood == favoriteFood)&&(identical(other.favoriteToy, favoriteToy) || other.favoriteToy == favoriteToy)&&(identical(other.favoriteSong, favoriteSong) || other.favoriteSong == favoriteSong)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&(identical(other.milestoneCount, milestoneCount) || other.milestoneCount == milestoneCount)&&(identical(other.letterCount, letterCount) || other.letterCount == letterCount)&&(identical(other.privateMemoryCount, privateMemoryCount) || other.privateMemoryCount == privateMemoryCount)&&const DeepCollectionEquality().equals(other._relativeViewerNames, _relativeViewerNames)&&(identical(other.addedByUserId, addedByUserId) || other.addedByUserId == addedByUserId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.duplicateOfChildId, duplicateOfChildId) || other.duplicateOfChildId == duplicateOfChildId)&&(identical(other.sharedMemoryCount, sharedMemoryCount) || other.sharedMemoryCount == sharedMemoryCount)&&const DeepCollectionEquality().equals(other._sharedWithChildIds, _sharedWithChildIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,childId,fullName,gestationWeeks,showBirthTimeToRelatives,nameStory,const DeepCollectionEquality().hash(_nameGivenBy),favoriteFood,favoriteToy,favoriteSong,memoryCount,milestoneCount,letterCount,privateMemoryCount,const DeepCollectionEquality().hash(_relativeViewerNames),addedByUserId,addedAt,duplicateOfChildId,sharedMemoryCount,const DeepCollectionEquality().hash(_sharedWithChildIds)]);

@override
String toString() {
  return 'ChildProfile(childId: $childId, fullName: $fullName, gestationWeeks: $gestationWeeks, showBirthTimeToRelatives: $showBirthTimeToRelatives, nameStory: $nameStory, nameGivenBy: $nameGivenBy, favoriteFood: $favoriteFood, favoriteToy: $favoriteToy, favoriteSong: $favoriteSong, memoryCount: $memoryCount, milestoneCount: $milestoneCount, letterCount: $letterCount, privateMemoryCount: $privateMemoryCount, relativeViewerNames: $relativeViewerNames, addedByUserId: $addedByUserId, addedAt: $addedAt, duplicateOfChildId: $duplicateOfChildId, sharedMemoryCount: $sharedMemoryCount, sharedWithChildIds: $sharedWithChildIds)';
}


}

/// @nodoc
abstract mixin class _$ChildProfileCopyWith<$Res> implements $ChildProfileCopyWith<$Res> {
  factory _$ChildProfileCopyWith(_ChildProfile value, $Res Function(_ChildProfile) _then) = __$ChildProfileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'childId') String childId,@JsonKey(name: 'fullName') String? fullName,@JsonKey(name: 'gestationWeeks') int? gestationWeeks,@JsonKey(name: 'showBirthTimeToRelatives') bool showBirthTimeToRelatives,@JsonKey(name: 'nameStory') String? nameStory,@JsonKey(name: 'nameGivenBy') List<String> nameGivenBy,@JsonKey(name: 'favoriteFood') String? favoriteFood,@JsonKey(name: 'favoriteToy') String? favoriteToy,@JsonKey(name: 'favoriteSong') String? favoriteSong,@JsonKey(name: 'memoryCount') int memoryCount,@JsonKey(name: 'milestoneCount') int milestoneCount,@JsonKey(name: 'letterCount') int letterCount,@JsonKey(name: 'privateMemoryCount') int privateMemoryCount,@JsonKey(name: 'relativeViewerNames') List<String> relativeViewerNames,@JsonKey(name: 'addedByUserId') String? addedByUserId,@JsonKey(name: 'addedAt') DateTime? addedAt,@JsonKey(name: 'duplicateOfChildId') String? duplicateOfChildId,@JsonKey(name: 'sharedMemoryCount') int sharedMemoryCount,@JsonKey(name: 'sharedWithChildIds') List<String> sharedWithChildIds
});




}
/// @nodoc
class __$ChildProfileCopyWithImpl<$Res>
    implements _$ChildProfileCopyWith<$Res> {
  __$ChildProfileCopyWithImpl(this._self, this._then);

  final _ChildProfile _self;
  final $Res Function(_ChildProfile) _then;

/// Create a copy of ChildProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childId = null,Object? fullName = freezed,Object? gestationWeeks = freezed,Object? showBirthTimeToRelatives = null,Object? nameStory = freezed,Object? nameGivenBy = null,Object? favoriteFood = freezed,Object? favoriteToy = freezed,Object? favoriteSong = freezed,Object? memoryCount = null,Object? milestoneCount = null,Object? letterCount = null,Object? privateMemoryCount = null,Object? relativeViewerNames = null,Object? addedByUserId = freezed,Object? addedAt = freezed,Object? duplicateOfChildId = freezed,Object? sharedMemoryCount = null,Object? sharedWithChildIds = null,}) {
  return _then(_ChildProfile(
childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,gestationWeeks: freezed == gestationWeeks ? _self.gestationWeeks : gestationWeeks // ignore: cast_nullable_to_non_nullable
as int?,showBirthTimeToRelatives: null == showBirthTimeToRelatives ? _self.showBirthTimeToRelatives : showBirthTimeToRelatives // ignore: cast_nullable_to_non_nullable
as bool,nameStory: freezed == nameStory ? _self.nameStory : nameStory // ignore: cast_nullable_to_non_nullable
as String?,nameGivenBy: null == nameGivenBy ? _self._nameGivenBy : nameGivenBy // ignore: cast_nullable_to_non_nullable
as List<String>,favoriteFood: freezed == favoriteFood ? _self.favoriteFood : favoriteFood // ignore: cast_nullable_to_non_nullable
as String?,favoriteToy: freezed == favoriteToy ? _self.favoriteToy : favoriteToy // ignore: cast_nullable_to_non_nullable
as String?,favoriteSong: freezed == favoriteSong ? _self.favoriteSong : favoriteSong // ignore: cast_nullable_to_non_nullable
as String?,memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,milestoneCount: null == milestoneCount ? _self.milestoneCount : milestoneCount // ignore: cast_nullable_to_non_nullable
as int,letterCount: null == letterCount ? _self.letterCount : letterCount // ignore: cast_nullable_to_non_nullable
as int,privateMemoryCount: null == privateMemoryCount ? _self.privateMemoryCount : privateMemoryCount // ignore: cast_nullable_to_non_nullable
as int,relativeViewerNames: null == relativeViewerNames ? _self._relativeViewerNames : relativeViewerNames // ignore: cast_nullable_to_non_nullable
as List<String>,addedByUserId: freezed == addedByUserId ? _self.addedByUserId : addedByUserId // ignore: cast_nullable_to_non_nullable
as String?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,duplicateOfChildId: freezed == duplicateOfChildId ? _self.duplicateOfChildId : duplicateOfChildId // ignore: cast_nullable_to_non_nullable
as String?,sharedMemoryCount: null == sharedMemoryCount ? _self.sharedMemoryCount : sharedMemoryCount // ignore: cast_nullable_to_non_nullable
as int,sharedWithChildIds: null == sharedWithChildIds ? _self._sharedWithChildIds : sharedWithChildIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
