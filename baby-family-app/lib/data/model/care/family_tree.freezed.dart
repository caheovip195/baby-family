// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_tree.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyTree {

@JsonKey(name: 'level') int get level;@JsonKey(name: 'name') String get name;@JsonKey(name: 'nextName') String? get nextName;@JsonKey(name: 'nextReward') String? get nextReward;@JsonKey(name: 'progressPercent') int get progressPercent;@JsonKey(name: 'todayLeaves') int get todayLeaves;@JsonKey(name: 'todayTotal') int get todayTotal;@JsonKey(name: 'bloomed') bool get bloomed;@JsonKey(name: 'weekCareMoments') int get weekCareMoments;@JsonKey(name: 'weekTogether') int get weekTogether;@JsonKey(name: 'weekBloomDays') int get weekBloomDays;
/// Create a copy of FamilyTree
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyTreeCopyWith<FamilyTree> get copyWith => _$FamilyTreeCopyWithImpl<FamilyTree>(this as FamilyTree, _$identity);

  /// Serializes this FamilyTree to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyTree&&(identical(other.level, level) || other.level == level)&&(identical(other.name, name) || other.name == name)&&(identical(other.nextName, nextName) || other.nextName == nextName)&&(identical(other.nextReward, nextReward) || other.nextReward == nextReward)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.todayLeaves, todayLeaves) || other.todayLeaves == todayLeaves)&&(identical(other.todayTotal, todayTotal) || other.todayTotal == todayTotal)&&(identical(other.bloomed, bloomed) || other.bloomed == bloomed)&&(identical(other.weekCareMoments, weekCareMoments) || other.weekCareMoments == weekCareMoments)&&(identical(other.weekTogether, weekTogether) || other.weekTogether == weekTogether)&&(identical(other.weekBloomDays, weekBloomDays) || other.weekBloomDays == weekBloomDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,name,nextName,nextReward,progressPercent,todayLeaves,todayTotal,bloomed,weekCareMoments,weekTogether,weekBloomDays);

@override
String toString() {
  return 'FamilyTree(level: $level, name: $name, nextName: $nextName, nextReward: $nextReward, progressPercent: $progressPercent, todayLeaves: $todayLeaves, todayTotal: $todayTotal, bloomed: $bloomed, weekCareMoments: $weekCareMoments, weekTogether: $weekTogether, weekBloomDays: $weekBloomDays)';
}


}

/// @nodoc
abstract mixin class $FamilyTreeCopyWith<$Res>  {
  factory $FamilyTreeCopyWith(FamilyTree value, $Res Function(FamilyTree) _then) = _$FamilyTreeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'level') int level,@JsonKey(name: 'name') String name,@JsonKey(name: 'nextName') String? nextName,@JsonKey(name: 'nextReward') String? nextReward,@JsonKey(name: 'progressPercent') int progressPercent,@JsonKey(name: 'todayLeaves') int todayLeaves,@JsonKey(name: 'todayTotal') int todayTotal,@JsonKey(name: 'bloomed') bool bloomed,@JsonKey(name: 'weekCareMoments') int weekCareMoments,@JsonKey(name: 'weekTogether') int weekTogether,@JsonKey(name: 'weekBloomDays') int weekBloomDays
});




}
/// @nodoc
class _$FamilyTreeCopyWithImpl<$Res>
    implements $FamilyTreeCopyWith<$Res> {
  _$FamilyTreeCopyWithImpl(this._self, this._then);

  final FamilyTree _self;
  final $Res Function(FamilyTree) _then;

/// Create a copy of FamilyTree
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? name = null,Object? nextName = freezed,Object? nextReward = freezed,Object? progressPercent = null,Object? todayLeaves = null,Object? todayTotal = null,Object? bloomed = null,Object? weekCareMoments = null,Object? weekTogether = null,Object? weekBloomDays = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nextName: freezed == nextName ? _self.nextName : nextName // ignore: cast_nullable_to_non_nullable
as String?,nextReward: freezed == nextReward ? _self.nextReward : nextReward // ignore: cast_nullable_to_non_nullable
as String?,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,todayLeaves: null == todayLeaves ? _self.todayLeaves : todayLeaves // ignore: cast_nullable_to_non_nullable
as int,todayTotal: null == todayTotal ? _self.todayTotal : todayTotal // ignore: cast_nullable_to_non_nullable
as int,bloomed: null == bloomed ? _self.bloomed : bloomed // ignore: cast_nullable_to_non_nullable
as bool,weekCareMoments: null == weekCareMoments ? _self.weekCareMoments : weekCareMoments // ignore: cast_nullable_to_non_nullable
as int,weekTogether: null == weekTogether ? _self.weekTogether : weekTogether // ignore: cast_nullable_to_non_nullable
as int,weekBloomDays: null == weekBloomDays ? _self.weekBloomDays : weekBloomDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyTree].
extension FamilyTreePatterns on FamilyTree {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyTree value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyTree() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyTree value)  $default,){
final _that = this;
switch (_that) {
case _FamilyTree():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyTree value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyTree() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FamilyTree implements FamilyTree {
  const _FamilyTree({@JsonKey(name: 'level') this.level = 1, @JsonKey(name: 'name') this.name = '', @JsonKey(name: 'nextName') this.nextName, @JsonKey(name: 'nextReward') this.nextReward, @JsonKey(name: 'progressPercent') this.progressPercent = 0, @JsonKey(name: 'todayLeaves') this.todayLeaves = 0, @JsonKey(name: 'todayTotal') this.todayTotal = 0, @JsonKey(name: 'bloomed') this.bloomed = false, @JsonKey(name: 'weekCareMoments') this.weekCareMoments = 0, @JsonKey(name: 'weekTogether') this.weekTogether = 0, @JsonKey(name: 'weekBloomDays') this.weekBloomDays = 0});
  factory _FamilyTree.fromJson(Map<String, dynamic> json) => _$FamilyTreeFromJson(json);

@override@JsonKey(name: 'level') final  int level;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'nextName') final  String? nextName;
@override@JsonKey(name: 'nextReward') final  String? nextReward;
@override@JsonKey(name: 'progressPercent') final  int progressPercent;
@override@JsonKey(name: 'todayLeaves') final  int todayLeaves;
@override@JsonKey(name: 'todayTotal') final  int todayTotal;
@override@JsonKey(name: 'bloomed') final  bool bloomed;
@override@JsonKey(name: 'weekCareMoments') final  int weekCareMoments;
@override@JsonKey(name: 'weekTogether') final  int weekTogether;
@override@JsonKey(name: 'weekBloomDays') final  int weekBloomDays;

/// Create a copy of FamilyTree
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyTreeCopyWith<_FamilyTree> get copyWith => __$FamilyTreeCopyWithImpl<_FamilyTree>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyTreeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyTree&&(identical(other.level, level) || other.level == level)&&(identical(other.name, name) || other.name == name)&&(identical(other.nextName, nextName) || other.nextName == nextName)&&(identical(other.nextReward, nextReward) || other.nextReward == nextReward)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.todayLeaves, todayLeaves) || other.todayLeaves == todayLeaves)&&(identical(other.todayTotal, todayTotal) || other.todayTotal == todayTotal)&&(identical(other.bloomed, bloomed) || other.bloomed == bloomed)&&(identical(other.weekCareMoments, weekCareMoments) || other.weekCareMoments == weekCareMoments)&&(identical(other.weekTogether, weekTogether) || other.weekTogether == weekTogether)&&(identical(other.weekBloomDays, weekBloomDays) || other.weekBloomDays == weekBloomDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,name,nextName,nextReward,progressPercent,todayLeaves,todayTotal,bloomed,weekCareMoments,weekTogether,weekBloomDays);

@override
String toString() {
  return 'FamilyTree(level: $level, name: $name, nextName: $nextName, nextReward: $nextReward, progressPercent: $progressPercent, todayLeaves: $todayLeaves, todayTotal: $todayTotal, bloomed: $bloomed, weekCareMoments: $weekCareMoments, weekTogether: $weekTogether, weekBloomDays: $weekBloomDays)';
}


}

/// @nodoc
abstract mixin class _$FamilyTreeCopyWith<$Res> implements $FamilyTreeCopyWith<$Res> {
  factory _$FamilyTreeCopyWith(_FamilyTree value, $Res Function(_FamilyTree) _then) = __$FamilyTreeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'level') int level,@JsonKey(name: 'name') String name,@JsonKey(name: 'nextName') String? nextName,@JsonKey(name: 'nextReward') String? nextReward,@JsonKey(name: 'progressPercent') int progressPercent,@JsonKey(name: 'todayLeaves') int todayLeaves,@JsonKey(name: 'todayTotal') int todayTotal,@JsonKey(name: 'bloomed') bool bloomed,@JsonKey(name: 'weekCareMoments') int weekCareMoments,@JsonKey(name: 'weekTogether') int weekTogether,@JsonKey(name: 'weekBloomDays') int weekBloomDays
});




}
/// @nodoc
class __$FamilyTreeCopyWithImpl<$Res>
    implements _$FamilyTreeCopyWith<$Res> {
  __$FamilyTreeCopyWithImpl(this._self, this._then);

  final _FamilyTree _self;
  final $Res Function(_FamilyTree) _then;

/// Create a copy of FamilyTree
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? name = null,Object? nextName = freezed,Object? nextReward = freezed,Object? progressPercent = null,Object? todayLeaves = null,Object? todayTotal = null,Object? bloomed = null,Object? weekCareMoments = null,Object? weekTogether = null,Object? weekBloomDays = null,}) {
  return _then(_FamilyTree(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nextName: freezed == nextName ? _self.nextName : nextName // ignore: cast_nullable_to_non_nullable
as String?,nextReward: freezed == nextReward ? _self.nextReward : nextReward // ignore: cast_nullable_to_non_nullable
as String?,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,todayLeaves: null == todayLeaves ? _self.todayLeaves : todayLeaves // ignore: cast_nullable_to_non_nullable
as int,todayTotal: null == todayTotal ? _self.todayTotal : todayTotal // ignore: cast_nullable_to_non_nullable
as int,bloomed: null == bloomed ? _self.bloomed : bloomed // ignore: cast_nullable_to_non_nullable
as bool,weekCareMoments: null == weekCareMoments ? _self.weekCareMoments : weekCareMoments // ignore: cast_nullable_to_non_nullable
as int,weekTogether: null == weekTogether ? _self.weekTogether : weekTogether // ignore: cast_nullable_to_non_nullable
as int,weekBloomDays: null == weekBloomDays ? _self.weekBloomDays : weekBloomDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
