// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Child {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'familyId') String get familyId;@JsonKey(name: 'name') String get name;@JsonKey(name: 'nickname') String? get nickname;@JsonKey(name: 'kind') ChildKind get kind;@JsonKey(name: 'birthDate') DateTime? get birthDate;@JsonKey(name: 'dueDate') DateTime? get dueDate;@JsonKey(name: 'colorIndex') int get colorIndex;@JsonKey(name: 'avatarAsset') String? get avatarAsset;@JsonKey(name: 'coverAsset') String? get coverAsset;@JsonKey(name: 'gender') ChildGender get gender;@JsonKey(name: 'archived') bool get archived;@JsonKey(name: 'carrierUserId') String? get carrierUserId;@JsonKey(name: 'pregnancyOrder') int? get pregnancyOrder;@JsonKey(name: 'babyCount') int get babyCount;@JsonKey(name: 'lunarBirthDay') int? get lunarBirthDay;@JsonKey(name: 'lunarBirthMonth') int? get lunarBirthMonth;@JsonKey(name: 'birthWeightKg') double? get birthWeightKg;@JsonKey(name: 'birthHeightCm') double? get birthHeightCm;@JsonKey(name: 'birthTime') String? get birthTime;/// CHD-03: ngày lưu trữ hồ sơ.
@JsonKey(name: 'archivedAt') DateTime? get archivedAt;
/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildCopyWith<Child> get copyWith => _$ChildCopyWithImpl<Child>(this as Child, _$identity);

  /// Serializes this Child to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Child&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.avatarAsset, avatarAsset) || other.avatarAsset == avatarAsset)&&(identical(other.coverAsset, coverAsset) || other.coverAsset == coverAsset)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.carrierUserId, carrierUserId) || other.carrierUserId == carrierUserId)&&(identical(other.pregnancyOrder, pregnancyOrder) || other.pregnancyOrder == pregnancyOrder)&&(identical(other.babyCount, babyCount) || other.babyCount == babyCount)&&(identical(other.lunarBirthDay, lunarBirthDay) || other.lunarBirthDay == lunarBirthDay)&&(identical(other.lunarBirthMonth, lunarBirthMonth) || other.lunarBirthMonth == lunarBirthMonth)&&(identical(other.birthWeightKg, birthWeightKg) || other.birthWeightKg == birthWeightKg)&&(identical(other.birthHeightCm, birthHeightCm) || other.birthHeightCm == birthHeightCm)&&(identical(other.birthTime, birthTime) || other.birthTime == birthTime)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,familyId,name,nickname,kind,birthDate,dueDate,colorIndex,avatarAsset,coverAsset,gender,archived,carrierUserId,pregnancyOrder,babyCount,lunarBirthDay,lunarBirthMonth,birthWeightKg,birthHeightCm,birthTime,archivedAt]);

@override
String toString() {
  return 'Child(id: $id, familyId: $familyId, name: $name, nickname: $nickname, kind: $kind, birthDate: $birthDate, dueDate: $dueDate, colorIndex: $colorIndex, avatarAsset: $avatarAsset, coverAsset: $coverAsset, gender: $gender, archived: $archived, carrierUserId: $carrierUserId, pregnancyOrder: $pregnancyOrder, babyCount: $babyCount, lunarBirthDay: $lunarBirthDay, lunarBirthMonth: $lunarBirthMonth, birthWeightKg: $birthWeightKg, birthHeightCm: $birthHeightCm, birthTime: $birthTime, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class $ChildCopyWith<$Res>  {
  factory $ChildCopyWith(Child value, $Res Function(Child) _then) = _$ChildCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'familyId') String familyId,@JsonKey(name: 'name') String name,@JsonKey(name: 'nickname') String? nickname,@JsonKey(name: 'kind') ChildKind kind,@JsonKey(name: 'birthDate') DateTime? birthDate,@JsonKey(name: 'dueDate') DateTime? dueDate,@JsonKey(name: 'colorIndex') int colorIndex,@JsonKey(name: 'avatarAsset') String? avatarAsset,@JsonKey(name: 'coverAsset') String? coverAsset,@JsonKey(name: 'gender') ChildGender gender,@JsonKey(name: 'archived') bool archived,@JsonKey(name: 'carrierUserId') String? carrierUserId,@JsonKey(name: 'pregnancyOrder') int? pregnancyOrder,@JsonKey(name: 'babyCount') int babyCount,@JsonKey(name: 'lunarBirthDay') int? lunarBirthDay,@JsonKey(name: 'lunarBirthMonth') int? lunarBirthMonth,@JsonKey(name: 'birthWeightKg') double? birthWeightKg,@JsonKey(name: 'birthHeightCm') double? birthHeightCm,@JsonKey(name: 'birthTime') String? birthTime,@JsonKey(name: 'archivedAt') DateTime? archivedAt
});




}
/// @nodoc
class _$ChildCopyWithImpl<$Res>
    implements $ChildCopyWith<$Res> {
  _$ChildCopyWithImpl(this._self, this._then);

  final Child _self;
  final $Res Function(Child) _then;

/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? familyId = null,Object? name = null,Object? nickname = freezed,Object? kind = null,Object? birthDate = freezed,Object? dueDate = freezed,Object? colorIndex = null,Object? avatarAsset = freezed,Object? coverAsset = freezed,Object? gender = null,Object? archived = null,Object? carrierUserId = freezed,Object? pregnancyOrder = freezed,Object? babyCount = null,Object? lunarBirthDay = freezed,Object? lunarBirthMonth = freezed,Object? birthWeightKg = freezed,Object? birthHeightCm = freezed,Object? birthTime = freezed,Object? archivedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChildKind,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,avatarAsset: freezed == avatarAsset ? _self.avatarAsset : avatarAsset // ignore: cast_nullable_to_non_nullable
as String?,coverAsset: freezed == coverAsset ? _self.coverAsset : coverAsset // ignore: cast_nullable_to_non_nullable
as String?,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as ChildGender,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,carrierUserId: freezed == carrierUserId ? _self.carrierUserId : carrierUserId // ignore: cast_nullable_to_non_nullable
as String?,pregnancyOrder: freezed == pregnancyOrder ? _self.pregnancyOrder : pregnancyOrder // ignore: cast_nullable_to_non_nullable
as int?,babyCount: null == babyCount ? _self.babyCount : babyCount // ignore: cast_nullable_to_non_nullable
as int,lunarBirthDay: freezed == lunarBirthDay ? _self.lunarBirthDay : lunarBirthDay // ignore: cast_nullable_to_non_nullable
as int?,lunarBirthMonth: freezed == lunarBirthMonth ? _self.lunarBirthMonth : lunarBirthMonth // ignore: cast_nullable_to_non_nullable
as int?,birthWeightKg: freezed == birthWeightKg ? _self.birthWeightKg : birthWeightKg // ignore: cast_nullable_to_non_nullable
as double?,birthHeightCm: freezed == birthHeightCm ? _self.birthHeightCm : birthHeightCm // ignore: cast_nullable_to_non_nullable
as double?,birthTime: freezed == birthTime ? _self.birthTime : birthTime // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Child].
extension ChildPatterns on Child {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Child value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Child() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Child value)  $default,){
final _that = this;
switch (_that) {
case _Child():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Child value)?  $default,){
final _that = this;
switch (_that) {
case _Child() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Child extends Child {
  const _Child({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'familyId') required this.familyId, @JsonKey(name: 'name') required this.name, @JsonKey(name: 'nickname') this.nickname, @JsonKey(name: 'kind') this.kind = ChildKind.baby, @JsonKey(name: 'birthDate') this.birthDate, @JsonKey(name: 'dueDate') this.dueDate, @JsonKey(name: 'colorIndex') this.colorIndex = 0, @JsonKey(name: 'avatarAsset') this.avatarAsset, @JsonKey(name: 'coverAsset') this.coverAsset, @JsonKey(name: 'gender') this.gender = ChildGender.unknown, @JsonKey(name: 'archived') this.archived = false, @JsonKey(name: 'carrierUserId') this.carrierUserId, @JsonKey(name: 'pregnancyOrder') this.pregnancyOrder, @JsonKey(name: 'babyCount') this.babyCount = 1, @JsonKey(name: 'lunarBirthDay') this.lunarBirthDay, @JsonKey(name: 'lunarBirthMonth') this.lunarBirthMonth, @JsonKey(name: 'birthWeightKg') this.birthWeightKg, @JsonKey(name: 'birthHeightCm') this.birthHeightCm, @JsonKey(name: 'birthTime') this.birthTime, @JsonKey(name: 'archivedAt') this.archivedAt}): super._();
  factory _Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'familyId') final  String familyId;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'nickname') final  String? nickname;
@override@JsonKey(name: 'kind') final  ChildKind kind;
@override@JsonKey(name: 'birthDate') final  DateTime? birthDate;
@override@JsonKey(name: 'dueDate') final  DateTime? dueDate;
@override@JsonKey(name: 'colorIndex') final  int colorIndex;
@override@JsonKey(name: 'avatarAsset') final  String? avatarAsset;
@override@JsonKey(name: 'coverAsset') final  String? coverAsset;
@override@JsonKey(name: 'gender') final  ChildGender gender;
@override@JsonKey(name: 'archived') final  bool archived;
@override@JsonKey(name: 'carrierUserId') final  String? carrierUserId;
@override@JsonKey(name: 'pregnancyOrder') final  int? pregnancyOrder;
@override@JsonKey(name: 'babyCount') final  int babyCount;
@override@JsonKey(name: 'lunarBirthDay') final  int? lunarBirthDay;
@override@JsonKey(name: 'lunarBirthMonth') final  int? lunarBirthMonth;
@override@JsonKey(name: 'birthWeightKg') final  double? birthWeightKg;
@override@JsonKey(name: 'birthHeightCm') final  double? birthHeightCm;
@override@JsonKey(name: 'birthTime') final  String? birthTime;
/// CHD-03: ngày lưu trữ hồ sơ.
@override@JsonKey(name: 'archivedAt') final  DateTime? archivedAt;

/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildCopyWith<_Child> get copyWith => __$ChildCopyWithImpl<_Child>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChildToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Child&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.avatarAsset, avatarAsset) || other.avatarAsset == avatarAsset)&&(identical(other.coverAsset, coverAsset) || other.coverAsset == coverAsset)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.carrierUserId, carrierUserId) || other.carrierUserId == carrierUserId)&&(identical(other.pregnancyOrder, pregnancyOrder) || other.pregnancyOrder == pregnancyOrder)&&(identical(other.babyCount, babyCount) || other.babyCount == babyCount)&&(identical(other.lunarBirthDay, lunarBirthDay) || other.lunarBirthDay == lunarBirthDay)&&(identical(other.lunarBirthMonth, lunarBirthMonth) || other.lunarBirthMonth == lunarBirthMonth)&&(identical(other.birthWeightKg, birthWeightKg) || other.birthWeightKg == birthWeightKg)&&(identical(other.birthHeightCm, birthHeightCm) || other.birthHeightCm == birthHeightCm)&&(identical(other.birthTime, birthTime) || other.birthTime == birthTime)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,familyId,name,nickname,kind,birthDate,dueDate,colorIndex,avatarAsset,coverAsset,gender,archived,carrierUserId,pregnancyOrder,babyCount,lunarBirthDay,lunarBirthMonth,birthWeightKg,birthHeightCm,birthTime,archivedAt]);

@override
String toString() {
  return 'Child(id: $id, familyId: $familyId, name: $name, nickname: $nickname, kind: $kind, birthDate: $birthDate, dueDate: $dueDate, colorIndex: $colorIndex, avatarAsset: $avatarAsset, coverAsset: $coverAsset, gender: $gender, archived: $archived, carrierUserId: $carrierUserId, pregnancyOrder: $pregnancyOrder, babyCount: $babyCount, lunarBirthDay: $lunarBirthDay, lunarBirthMonth: $lunarBirthMonth, birthWeightKg: $birthWeightKg, birthHeightCm: $birthHeightCm, birthTime: $birthTime, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$ChildCopyWith<$Res> implements $ChildCopyWith<$Res> {
  factory _$ChildCopyWith(_Child value, $Res Function(_Child) _then) = __$ChildCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'familyId') String familyId,@JsonKey(name: 'name') String name,@JsonKey(name: 'nickname') String? nickname,@JsonKey(name: 'kind') ChildKind kind,@JsonKey(name: 'birthDate') DateTime? birthDate,@JsonKey(name: 'dueDate') DateTime? dueDate,@JsonKey(name: 'colorIndex') int colorIndex,@JsonKey(name: 'avatarAsset') String? avatarAsset,@JsonKey(name: 'coverAsset') String? coverAsset,@JsonKey(name: 'gender') ChildGender gender,@JsonKey(name: 'archived') bool archived,@JsonKey(name: 'carrierUserId') String? carrierUserId,@JsonKey(name: 'pregnancyOrder') int? pregnancyOrder,@JsonKey(name: 'babyCount') int babyCount,@JsonKey(name: 'lunarBirthDay') int? lunarBirthDay,@JsonKey(name: 'lunarBirthMonth') int? lunarBirthMonth,@JsonKey(name: 'birthWeightKg') double? birthWeightKg,@JsonKey(name: 'birthHeightCm') double? birthHeightCm,@JsonKey(name: 'birthTime') String? birthTime,@JsonKey(name: 'archivedAt') DateTime? archivedAt
});




}
/// @nodoc
class __$ChildCopyWithImpl<$Res>
    implements _$ChildCopyWith<$Res> {
  __$ChildCopyWithImpl(this._self, this._then);

  final _Child _self;
  final $Res Function(_Child) _then;

/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? familyId = null,Object? name = null,Object? nickname = freezed,Object? kind = null,Object? birthDate = freezed,Object? dueDate = freezed,Object? colorIndex = null,Object? avatarAsset = freezed,Object? coverAsset = freezed,Object? gender = null,Object? archived = null,Object? carrierUserId = freezed,Object? pregnancyOrder = freezed,Object? babyCount = null,Object? lunarBirthDay = freezed,Object? lunarBirthMonth = freezed,Object? birthWeightKg = freezed,Object? birthHeightCm = freezed,Object? birthTime = freezed,Object? archivedAt = freezed,}) {
  return _then(_Child(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChildKind,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,avatarAsset: freezed == avatarAsset ? _self.avatarAsset : avatarAsset // ignore: cast_nullable_to_non_nullable
as String?,coverAsset: freezed == coverAsset ? _self.coverAsset : coverAsset // ignore: cast_nullable_to_non_nullable
as String?,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as ChildGender,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,carrierUserId: freezed == carrierUserId ? _self.carrierUserId : carrierUserId // ignore: cast_nullable_to_non_nullable
as String?,pregnancyOrder: freezed == pregnancyOrder ? _self.pregnancyOrder : pregnancyOrder // ignore: cast_nullable_to_non_nullable
as int?,babyCount: null == babyCount ? _self.babyCount : babyCount // ignore: cast_nullable_to_non_nullable
as int,lunarBirthDay: freezed == lunarBirthDay ? _self.lunarBirthDay : lunarBirthDay // ignore: cast_nullable_to_non_nullable
as int?,lunarBirthMonth: freezed == lunarBirthMonth ? _self.lunarBirthMonth : lunarBirthMonth // ignore: cast_nullable_to_non_nullable
as int?,birthWeightKg: freezed == birthWeightKg ? _self.birthWeightKg : birthWeightKg // ignore: cast_nullable_to_non_nullable
as double?,birthHeightCm: freezed == birthHeightCm ? _self.birthHeightCm : birthHeightCm // ignore: cast_nullable_to_non_nullable
as double?,birthTime: freezed == birthTime ? _self.birthTime : birthTime // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
