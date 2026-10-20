// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circle_member_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CircleMemberList {

@JsonKey(name: 'members') List<CircleMemberRecord> get members;
/// Create a copy of CircleMemberList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleMemberListCopyWith<CircleMemberList> get copyWith => _$CircleMemberListCopyWithImpl<CircleMemberList>(this as CircleMemberList, _$identity);

  /// Serializes this CircleMemberList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleMemberList&&const DeepCollectionEquality().equals(other.members, members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(members));

@override
String toString() {
  return 'CircleMemberList(members: $members)';
}


}

/// @nodoc
abstract mixin class $CircleMemberListCopyWith<$Res>  {
  factory $CircleMemberListCopyWith(CircleMemberList value, $Res Function(CircleMemberList) _then) = _$CircleMemberListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'members') List<CircleMemberRecord> members
});




}
/// @nodoc
class _$CircleMemberListCopyWithImpl<$Res>
    implements $CircleMemberListCopyWith<$Res> {
  _$CircleMemberListCopyWithImpl(this._self, this._then);

  final CircleMemberList _self;
  final $Res Function(CircleMemberList) _then;

/// Create a copy of CircleMemberList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? members = null,}) {
  return _then(_self.copyWith(
members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<CircleMemberRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [CircleMemberList].
extension CircleMemberListPatterns on CircleMemberList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircleMemberList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircleMemberList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircleMemberList value)  $default,){
final _that = this;
switch (_that) {
case _CircleMemberList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircleMemberList value)?  $default,){
final _that = this;
switch (_that) {
case _CircleMemberList() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CircleMemberList implements CircleMemberList {
  const _CircleMemberList({@JsonKey(name: 'members') final  List<CircleMemberRecord> members = const <CircleMemberRecord>[]}): _members = members;
  factory _CircleMemberList.fromJson(Map<String, dynamic> json) => _$CircleMemberListFromJson(json);

 final  List<CircleMemberRecord> _members;
@override@JsonKey(name: 'members') List<CircleMemberRecord> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}


/// Create a copy of CircleMemberList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircleMemberListCopyWith<_CircleMemberList> get copyWith => __$CircleMemberListCopyWithImpl<_CircleMemberList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircleMemberListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircleMemberList&&const DeepCollectionEquality().equals(other._members, _members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_members));

@override
String toString() {
  return 'CircleMemberList(members: $members)';
}


}

/// @nodoc
abstract mixin class _$CircleMemberListCopyWith<$Res> implements $CircleMemberListCopyWith<$Res> {
  factory _$CircleMemberListCopyWith(_CircleMemberList value, $Res Function(_CircleMemberList) _then) = __$CircleMemberListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'members') List<CircleMemberRecord> members
});




}
/// @nodoc
class __$CircleMemberListCopyWithImpl<$Res>
    implements _$CircleMemberListCopyWith<$Res> {
  __$CircleMemberListCopyWithImpl(this._self, this._then);

  final _CircleMemberList _self;
  final $Res Function(_CircleMemberList) _then;

/// Create a copy of CircleMemberList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? members = null,}) {
  return _then(_CircleMemberList(
members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<CircleMemberRecord>,
  ));
}


}

// dart format on
