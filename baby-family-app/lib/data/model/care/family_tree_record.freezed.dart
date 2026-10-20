// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_tree_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyTreeRecord {

@JsonKey(name: 'level') int get level;@JsonKey(name: 'levelName') String? get levelName;@JsonKey(name: 'progressPercent') int get progressPercent;@JsonKey(name: 'fruits') int get fruits;@JsonKey(name: 'flowers') int get flowers;@JsonKey(name: 'bloomedDaysThisWeek') int get bloomedDaysThisWeek;@JsonKey(name: 'today') FamilyTreeTodayRecord? get today;
/// Create a copy of FamilyTreeRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyTreeRecordCopyWith<FamilyTreeRecord> get copyWith => _$FamilyTreeRecordCopyWithImpl<FamilyTreeRecord>(this as FamilyTreeRecord, _$identity);

  /// Serializes this FamilyTreeRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyTreeRecord&&(identical(other.level, level) || other.level == level)&&(identical(other.levelName, levelName) || other.levelName == levelName)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.fruits, fruits) || other.fruits == fruits)&&(identical(other.flowers, flowers) || other.flowers == flowers)&&(identical(other.bloomedDaysThisWeek, bloomedDaysThisWeek) || other.bloomedDaysThisWeek == bloomedDaysThisWeek)&&(identical(other.today, today) || other.today == today));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,levelName,progressPercent,fruits,flowers,bloomedDaysThisWeek,today);

@override
String toString() {
  return 'FamilyTreeRecord(level: $level, levelName: $levelName, progressPercent: $progressPercent, fruits: $fruits, flowers: $flowers, bloomedDaysThisWeek: $bloomedDaysThisWeek, today: $today)';
}


}

/// @nodoc
abstract mixin class $FamilyTreeRecordCopyWith<$Res>  {
  factory $FamilyTreeRecordCopyWith(FamilyTreeRecord value, $Res Function(FamilyTreeRecord) _then) = _$FamilyTreeRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'level') int level,@JsonKey(name: 'levelName') String? levelName,@JsonKey(name: 'progressPercent') int progressPercent,@JsonKey(name: 'fruits') int fruits,@JsonKey(name: 'flowers') int flowers,@JsonKey(name: 'bloomedDaysThisWeek') int bloomedDaysThisWeek,@JsonKey(name: 'today') FamilyTreeTodayRecord? today
});


$FamilyTreeTodayRecordCopyWith<$Res>? get today;

}
/// @nodoc
class _$FamilyTreeRecordCopyWithImpl<$Res>
    implements $FamilyTreeRecordCopyWith<$Res> {
  _$FamilyTreeRecordCopyWithImpl(this._self, this._then);

  final FamilyTreeRecord _self;
  final $Res Function(FamilyTreeRecord) _then;

/// Create a copy of FamilyTreeRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? levelName = freezed,Object? progressPercent = null,Object? fruits = null,Object? flowers = null,Object? bloomedDaysThisWeek = null,Object? today = freezed,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,levelName: freezed == levelName ? _self.levelName : levelName // ignore: cast_nullable_to_non_nullable
as String?,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,fruits: null == fruits ? _self.fruits : fruits // ignore: cast_nullable_to_non_nullable
as int,flowers: null == flowers ? _self.flowers : flowers // ignore: cast_nullable_to_non_nullable
as int,bloomedDaysThisWeek: null == bloomedDaysThisWeek ? _self.bloomedDaysThisWeek : bloomedDaysThisWeek // ignore: cast_nullable_to_non_nullable
as int,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as FamilyTreeTodayRecord?,
  ));
}
/// Create a copy of FamilyTreeRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FamilyTreeTodayRecordCopyWith<$Res>? get today {
    if (_self.today == null) {
    return null;
  }

  return $FamilyTreeTodayRecordCopyWith<$Res>(_self.today!, (value) {
    return _then(_self.copyWith(today: value));
  });
}
}


/// Adds pattern-matching-related methods to [FamilyTreeRecord].
extension FamilyTreeRecordPatterns on FamilyTreeRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyTreeRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyTreeRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyTreeRecord value)  $default,){
final _that = this;
switch (_that) {
case _FamilyTreeRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyTreeRecord value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyTreeRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FamilyTreeRecord implements FamilyTreeRecord {
  const _FamilyTreeRecord({@JsonKey(name: 'level') this.level = 1, @JsonKey(name: 'levelName') this.levelName, @JsonKey(name: 'progressPercent') this.progressPercent = 0, @JsonKey(name: 'fruits') this.fruits = 0, @JsonKey(name: 'flowers') this.flowers = 0, @JsonKey(name: 'bloomedDaysThisWeek') this.bloomedDaysThisWeek = 0, @JsonKey(name: 'today') this.today});
  factory _FamilyTreeRecord.fromJson(Map<String, dynamic> json) => _$FamilyTreeRecordFromJson(json);

@override@JsonKey(name: 'level') final  int level;
@override@JsonKey(name: 'levelName') final  String? levelName;
@override@JsonKey(name: 'progressPercent') final  int progressPercent;
@override@JsonKey(name: 'fruits') final  int fruits;
@override@JsonKey(name: 'flowers') final  int flowers;
@override@JsonKey(name: 'bloomedDaysThisWeek') final  int bloomedDaysThisWeek;
@override@JsonKey(name: 'today') final  FamilyTreeTodayRecord? today;

/// Create a copy of FamilyTreeRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyTreeRecordCopyWith<_FamilyTreeRecord> get copyWith => __$FamilyTreeRecordCopyWithImpl<_FamilyTreeRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyTreeRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyTreeRecord&&(identical(other.level, level) || other.level == level)&&(identical(other.levelName, levelName) || other.levelName == levelName)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.fruits, fruits) || other.fruits == fruits)&&(identical(other.flowers, flowers) || other.flowers == flowers)&&(identical(other.bloomedDaysThisWeek, bloomedDaysThisWeek) || other.bloomedDaysThisWeek == bloomedDaysThisWeek)&&(identical(other.today, today) || other.today == today));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,levelName,progressPercent,fruits,flowers,bloomedDaysThisWeek,today);

@override
String toString() {
  return 'FamilyTreeRecord(level: $level, levelName: $levelName, progressPercent: $progressPercent, fruits: $fruits, flowers: $flowers, bloomedDaysThisWeek: $bloomedDaysThisWeek, today: $today)';
}


}

/// @nodoc
abstract mixin class _$FamilyTreeRecordCopyWith<$Res> implements $FamilyTreeRecordCopyWith<$Res> {
  factory _$FamilyTreeRecordCopyWith(_FamilyTreeRecord value, $Res Function(_FamilyTreeRecord) _then) = __$FamilyTreeRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'level') int level,@JsonKey(name: 'levelName') String? levelName,@JsonKey(name: 'progressPercent') int progressPercent,@JsonKey(name: 'fruits') int fruits,@JsonKey(name: 'flowers') int flowers,@JsonKey(name: 'bloomedDaysThisWeek') int bloomedDaysThisWeek,@JsonKey(name: 'today') FamilyTreeTodayRecord? today
});


@override $FamilyTreeTodayRecordCopyWith<$Res>? get today;

}
/// @nodoc
class __$FamilyTreeRecordCopyWithImpl<$Res>
    implements _$FamilyTreeRecordCopyWith<$Res> {
  __$FamilyTreeRecordCopyWithImpl(this._self, this._then);

  final _FamilyTreeRecord _self;
  final $Res Function(_FamilyTreeRecord) _then;

/// Create a copy of FamilyTreeRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? levelName = freezed,Object? progressPercent = null,Object? fruits = null,Object? flowers = null,Object? bloomedDaysThisWeek = null,Object? today = freezed,}) {
  return _then(_FamilyTreeRecord(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,levelName: freezed == levelName ? _self.levelName : levelName // ignore: cast_nullable_to_non_nullable
as String?,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,fruits: null == fruits ? _self.fruits : fruits // ignore: cast_nullable_to_non_nullable
as int,flowers: null == flowers ? _self.flowers : flowers // ignore: cast_nullable_to_non_nullable
as int,bloomedDaysThisWeek: null == bloomedDaysThisWeek ? _self.bloomedDaysThisWeek : bloomedDaysThisWeek // ignore: cast_nullable_to_non_nullable
as int,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as FamilyTreeTodayRecord?,
  ));
}

/// Create a copy of FamilyTreeRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FamilyTreeTodayRecordCopyWith<$Res>? get today {
    if (_self.today == null) {
    return null;
  }

  return $FamilyTreeTodayRecordCopyWith<$Res>(_self.today!, (value) {
    return _then(_self.copyWith(today: value));
  });
}
}

// dart format on
