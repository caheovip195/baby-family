// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocked_person.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockedPerson {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'name') String get name;@JsonKey(name: 'context') String? get context;@JsonKey(name: 'blockedAt') DateTime? get blockedAt;
/// Create a copy of BlockedPerson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockedPersonCopyWith<BlockedPerson> get copyWith => _$BlockedPersonCopyWithImpl<BlockedPerson>(this as BlockedPerson, _$identity);

  /// Serializes this BlockedPerson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockedPerson&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.context, context) || other.context == context)&&(identical(other.blockedAt, blockedAt) || other.blockedAt == blockedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,context,blockedAt);

@override
String toString() {
  return 'BlockedPerson(id: $id, name: $name, context: $context, blockedAt: $blockedAt)';
}


}

/// @nodoc
abstract mixin class $BlockedPersonCopyWith<$Res>  {
  factory $BlockedPersonCopyWith(BlockedPerson value, $Res Function(BlockedPerson) _then) = _$BlockedPersonCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'context') String? context,@JsonKey(name: 'blockedAt') DateTime? blockedAt
});




}
/// @nodoc
class _$BlockedPersonCopyWithImpl<$Res>
    implements $BlockedPersonCopyWith<$Res> {
  _$BlockedPersonCopyWithImpl(this._self, this._then);

  final BlockedPerson _self;
  final $Res Function(BlockedPerson) _then;

/// Create a copy of BlockedPerson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? context = freezed,Object? blockedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String?,blockedAt: freezed == blockedAt ? _self.blockedAt : blockedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BlockedPerson].
extension BlockedPersonPatterns on BlockedPerson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlockedPerson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlockedPerson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlockedPerson value)  $default,){
final _that = this;
switch (_that) {
case _BlockedPerson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlockedPerson value)?  $default,){
final _that = this;
switch (_that) {
case _BlockedPerson() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BlockedPerson implements BlockedPerson {
  const _BlockedPerson({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'name') required this.name, @JsonKey(name: 'context') this.context, @JsonKey(name: 'blockedAt') this.blockedAt});
  factory _BlockedPerson.fromJson(Map<String, dynamic> json) => _$BlockedPersonFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'context') final  String? context;
@override@JsonKey(name: 'blockedAt') final  DateTime? blockedAt;

/// Create a copy of BlockedPerson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockedPersonCopyWith<_BlockedPerson> get copyWith => __$BlockedPersonCopyWithImpl<_BlockedPerson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockedPersonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockedPerson&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.context, context) || other.context == context)&&(identical(other.blockedAt, blockedAt) || other.blockedAt == blockedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,context,blockedAt);

@override
String toString() {
  return 'BlockedPerson(id: $id, name: $name, context: $context, blockedAt: $blockedAt)';
}


}

/// @nodoc
abstract mixin class _$BlockedPersonCopyWith<$Res> implements $BlockedPersonCopyWith<$Res> {
  factory _$BlockedPersonCopyWith(_BlockedPerson value, $Res Function(_BlockedPerson) _then) = __$BlockedPersonCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'context') String? context,@JsonKey(name: 'blockedAt') DateTime? blockedAt
});




}
/// @nodoc
class __$BlockedPersonCopyWithImpl<$Res>
    implements _$BlockedPersonCopyWith<$Res> {
  __$BlockedPersonCopyWithImpl(this._self, this._then);

  final _BlockedPerson _self;
  final $Res Function(_BlockedPerson) _then;

/// Create a copy of BlockedPerson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? context = freezed,Object? blockedAt = freezed,}) {
  return _then(_BlockedPerson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String?,blockedAt: freezed == blockedAt ? _self.blockedAt : blockedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
