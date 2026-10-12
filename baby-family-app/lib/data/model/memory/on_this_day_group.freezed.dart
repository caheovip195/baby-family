// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'on_this_day_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnThisDayGroup {

@JsonKey(name: 'yearsAgo') int get yearsAgo;@JsonKey(name: 'date') DateTime get date;@JsonKey(name: 'childId') String? get childId;@JsonKey(name: 'memories') List<Memory> get memories;
/// Create a copy of OnThisDayGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnThisDayGroupCopyWith<OnThisDayGroup> get copyWith => _$OnThisDayGroupCopyWithImpl<OnThisDayGroup>(this as OnThisDayGroup, _$identity);

  /// Serializes this OnThisDayGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnThisDayGroup&&(identical(other.yearsAgo, yearsAgo) || other.yearsAgo == yearsAgo)&&(identical(other.date, date) || other.date == date)&&(identical(other.childId, childId) || other.childId == childId)&&const DeepCollectionEquality().equals(other.memories, memories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,yearsAgo,date,childId,const DeepCollectionEquality().hash(memories));

@override
String toString() {
  return 'OnThisDayGroup(yearsAgo: $yearsAgo, date: $date, childId: $childId, memories: $memories)';
}


}

/// @nodoc
abstract mixin class $OnThisDayGroupCopyWith<$Res>  {
  factory $OnThisDayGroupCopyWith(OnThisDayGroup value, $Res Function(OnThisDayGroup) _then) = _$OnThisDayGroupCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'yearsAgo') int yearsAgo,@JsonKey(name: 'date') DateTime date,@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'memories') List<Memory> memories
});




}
/// @nodoc
class _$OnThisDayGroupCopyWithImpl<$Res>
    implements $OnThisDayGroupCopyWith<$Res> {
  _$OnThisDayGroupCopyWithImpl(this._self, this._then);

  final OnThisDayGroup _self;
  final $Res Function(OnThisDayGroup) _then;

/// Create a copy of OnThisDayGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? yearsAgo = null,Object? date = null,Object? childId = freezed,Object? memories = null,}) {
  return _then(_self.copyWith(
yearsAgo: null == yearsAgo ? _self.yearsAgo : yearsAgo // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,memories: null == memories ? _self.memories : memories // ignore: cast_nullable_to_non_nullable
as List<Memory>,
  ));
}

}


/// Adds pattern-matching-related methods to [OnThisDayGroup].
extension OnThisDayGroupPatterns on OnThisDayGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnThisDayGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnThisDayGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnThisDayGroup value)  $default,){
final _that = this;
switch (_that) {
case _OnThisDayGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnThisDayGroup value)?  $default,){
final _that = this;
switch (_that) {
case _OnThisDayGroup() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OnThisDayGroup implements OnThisDayGroup {
  const _OnThisDayGroup({@JsonKey(name: 'yearsAgo') required this.yearsAgo, @JsonKey(name: 'date') required this.date, @JsonKey(name: 'childId') this.childId, @JsonKey(name: 'memories') final  List<Memory> memories = const []}): _memories = memories;
  factory _OnThisDayGroup.fromJson(Map<String, dynamic> json) => _$OnThisDayGroupFromJson(json);

@override@JsonKey(name: 'yearsAgo') final  int yearsAgo;
@override@JsonKey(name: 'date') final  DateTime date;
@override@JsonKey(name: 'childId') final  String? childId;
 final  List<Memory> _memories;
@override@JsonKey(name: 'memories') List<Memory> get memories {
  if (_memories is EqualUnmodifiableListView) return _memories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memories);
}


/// Create a copy of OnThisDayGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnThisDayGroupCopyWith<_OnThisDayGroup> get copyWith => __$OnThisDayGroupCopyWithImpl<_OnThisDayGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnThisDayGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnThisDayGroup&&(identical(other.yearsAgo, yearsAgo) || other.yearsAgo == yearsAgo)&&(identical(other.date, date) || other.date == date)&&(identical(other.childId, childId) || other.childId == childId)&&const DeepCollectionEquality().equals(other._memories, _memories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,yearsAgo,date,childId,const DeepCollectionEquality().hash(_memories));

@override
String toString() {
  return 'OnThisDayGroup(yearsAgo: $yearsAgo, date: $date, childId: $childId, memories: $memories)';
}


}

/// @nodoc
abstract mixin class _$OnThisDayGroupCopyWith<$Res> implements $OnThisDayGroupCopyWith<$Res> {
  factory _$OnThisDayGroupCopyWith(_OnThisDayGroup value, $Res Function(_OnThisDayGroup) _then) = __$OnThisDayGroupCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'yearsAgo') int yearsAgo,@JsonKey(name: 'date') DateTime date,@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'memories') List<Memory> memories
});




}
/// @nodoc
class __$OnThisDayGroupCopyWithImpl<$Res>
    implements _$OnThisDayGroupCopyWith<$Res> {
  __$OnThisDayGroupCopyWithImpl(this._self, this._then);

  final _OnThisDayGroup _self;
  final $Res Function(_OnThisDayGroup) _then;

/// Create a copy of OnThisDayGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? yearsAgo = null,Object? date = null,Object? childId = freezed,Object? memories = null,}) {
  return _then(_OnThisDayGroup(
yearsAgo: null == yearsAgo ? _self.yearsAgo : yearsAgo // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,memories: null == memories ? _self._memories : memories // ignore: cast_nullable_to_non_nullable
as List<Memory>,
  ));
}


}

// dart format on
