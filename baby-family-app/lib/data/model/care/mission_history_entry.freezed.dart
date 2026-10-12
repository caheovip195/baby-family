// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_history_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionHistoryEntry {

@JsonKey(name: 'title') String get title;@JsonKey(name: 'ownerKind') MissionOwnerKind get ownerKind;@JsonKey(name: 'done') bool get done;@JsonKey(name: 'completedTime') String? get completedTime;@JsonKey(name: 'categoryCode') String? get categoryCode;@JsonKey(name: 'hearts') int? get hearts;@JsonKey(name: 'childIds') List<String> get childIds;@JsonKey(name: 'couple') bool get couple;
/// Create a copy of MissionHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionHistoryEntryCopyWith<MissionHistoryEntry> get copyWith => _$MissionHistoryEntryCopyWithImpl<MissionHistoryEntry>(this as MissionHistoryEntry, _$identity);

  /// Serializes this MissionHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionHistoryEntry&&(identical(other.title, title) || other.title == title)&&(identical(other.ownerKind, ownerKind) || other.ownerKind == ownerKind)&&(identical(other.done, done) || other.done == done)&&(identical(other.completedTime, completedTime) || other.completedTime == completedTime)&&(identical(other.categoryCode, categoryCode) || other.categoryCode == categoryCode)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&const DeepCollectionEquality().equals(other.childIds, childIds)&&(identical(other.couple, couple) || other.couple == couple));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,ownerKind,done,completedTime,categoryCode,hearts,const DeepCollectionEquality().hash(childIds),couple);

@override
String toString() {
  return 'MissionHistoryEntry(title: $title, ownerKind: $ownerKind, done: $done, completedTime: $completedTime, categoryCode: $categoryCode, hearts: $hearts, childIds: $childIds, couple: $couple)';
}


}

/// @nodoc
abstract mixin class $MissionHistoryEntryCopyWith<$Res>  {
  factory $MissionHistoryEntryCopyWith(MissionHistoryEntry value, $Res Function(MissionHistoryEntry) _then) = _$MissionHistoryEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'title') String title,@JsonKey(name: 'ownerKind') MissionOwnerKind ownerKind,@JsonKey(name: 'done') bool done,@JsonKey(name: 'completedTime') String? completedTime,@JsonKey(name: 'categoryCode') String? categoryCode,@JsonKey(name: 'hearts') int? hearts,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'couple') bool couple
});




}
/// @nodoc
class _$MissionHistoryEntryCopyWithImpl<$Res>
    implements $MissionHistoryEntryCopyWith<$Res> {
  _$MissionHistoryEntryCopyWithImpl(this._self, this._then);

  final MissionHistoryEntry _self;
  final $Res Function(MissionHistoryEntry) _then;

/// Create a copy of MissionHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? ownerKind = null,Object? done = null,Object? completedTime = freezed,Object? categoryCode = freezed,Object? hearts = freezed,Object? childIds = null,Object? couple = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,ownerKind: null == ownerKind ? _self.ownerKind : ownerKind // ignore: cast_nullable_to_non_nullable
as MissionOwnerKind,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,completedTime: freezed == completedTime ? _self.completedTime : completedTime // ignore: cast_nullable_to_non_nullable
as String?,categoryCode: freezed == categoryCode ? _self.categoryCode : categoryCode // ignore: cast_nullable_to_non_nullable
as String?,hearts: freezed == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int?,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,couple: null == couple ? _self.couple : couple // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionHistoryEntry].
extension MissionHistoryEntryPatterns on MissionHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _MissionHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _MissionHistoryEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MissionHistoryEntry implements MissionHistoryEntry {
  const _MissionHistoryEntry({@JsonKey(name: 'title') required this.title, @JsonKey(name: 'ownerKind') this.ownerKind = MissionOwnerKind.me, @JsonKey(name: 'done') this.done = true, @JsonKey(name: 'completedTime') this.completedTime, @JsonKey(name: 'categoryCode') this.categoryCode, @JsonKey(name: 'hearts') this.hearts, @JsonKey(name: 'childIds') final  List<String> childIds = const [], @JsonKey(name: 'couple') this.couple = false}): _childIds = childIds;
  factory _MissionHistoryEntry.fromJson(Map<String, dynamic> json) => _$MissionHistoryEntryFromJson(json);

@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'ownerKind') final  MissionOwnerKind ownerKind;
@override@JsonKey(name: 'done') final  bool done;
@override@JsonKey(name: 'completedTime') final  String? completedTime;
@override@JsonKey(name: 'categoryCode') final  String? categoryCode;
@override@JsonKey(name: 'hearts') final  int? hearts;
 final  List<String> _childIds;
@override@JsonKey(name: 'childIds') List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}

@override@JsonKey(name: 'couple') final  bool couple;

/// Create a copy of MissionHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionHistoryEntryCopyWith<_MissionHistoryEntry> get copyWith => __$MissionHistoryEntryCopyWithImpl<_MissionHistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionHistoryEntry&&(identical(other.title, title) || other.title == title)&&(identical(other.ownerKind, ownerKind) || other.ownerKind == ownerKind)&&(identical(other.done, done) || other.done == done)&&(identical(other.completedTime, completedTime) || other.completedTime == completedTime)&&(identical(other.categoryCode, categoryCode) || other.categoryCode == categoryCode)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&const DeepCollectionEquality().equals(other._childIds, _childIds)&&(identical(other.couple, couple) || other.couple == couple));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,ownerKind,done,completedTime,categoryCode,hearts,const DeepCollectionEquality().hash(_childIds),couple);

@override
String toString() {
  return 'MissionHistoryEntry(title: $title, ownerKind: $ownerKind, done: $done, completedTime: $completedTime, categoryCode: $categoryCode, hearts: $hearts, childIds: $childIds, couple: $couple)';
}


}

/// @nodoc
abstract mixin class _$MissionHistoryEntryCopyWith<$Res> implements $MissionHistoryEntryCopyWith<$Res> {
  factory _$MissionHistoryEntryCopyWith(_MissionHistoryEntry value, $Res Function(_MissionHistoryEntry) _then) = __$MissionHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'title') String title,@JsonKey(name: 'ownerKind') MissionOwnerKind ownerKind,@JsonKey(name: 'done') bool done,@JsonKey(name: 'completedTime') String? completedTime,@JsonKey(name: 'categoryCode') String? categoryCode,@JsonKey(name: 'hearts') int? hearts,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'couple') bool couple
});




}
/// @nodoc
class __$MissionHistoryEntryCopyWithImpl<$Res>
    implements _$MissionHistoryEntryCopyWith<$Res> {
  __$MissionHistoryEntryCopyWithImpl(this._self, this._then);

  final _MissionHistoryEntry _self;
  final $Res Function(_MissionHistoryEntry) _then;

/// Create a copy of MissionHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? ownerKind = null,Object? done = null,Object? completedTime = freezed,Object? categoryCode = freezed,Object? hearts = freezed,Object? childIds = null,Object? couple = null,}) {
  return _then(_MissionHistoryEntry(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,ownerKind: null == ownerKind ? _self.ownerKind : ownerKind // ignore: cast_nullable_to_non_nullable
as MissionOwnerKind,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,completedTime: freezed == completedTime ? _self.completedTime : completedTime // ignore: cast_nullable_to_non_nullable
as String?,categoryCode: freezed == categoryCode ? _self.categoryCode : categoryCode // ignore: cast_nullable_to_non_nullable
as String?,hearts: freezed == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int?,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,couple: null == couple ? _self.couple : couple // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
