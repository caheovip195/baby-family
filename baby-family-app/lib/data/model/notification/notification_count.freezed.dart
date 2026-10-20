// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationCount {

@JsonKey(name: 'count') int get count;
/// Create a copy of NotificationCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationCountCopyWith<NotificationCount> get copyWith => _$NotificationCountCopyWithImpl<NotificationCount>(this as NotificationCount, _$identity);

  /// Serializes this NotificationCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationCount&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'NotificationCount(count: $count)';
}


}

/// @nodoc
abstract mixin class $NotificationCountCopyWith<$Res>  {
  factory $NotificationCountCopyWith(NotificationCount value, $Res Function(NotificationCount) _then) = _$NotificationCountCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'count') int count
});




}
/// @nodoc
class _$NotificationCountCopyWithImpl<$Res>
    implements $NotificationCountCopyWith<$Res> {
  _$NotificationCountCopyWithImpl(this._self, this._then);

  final NotificationCount _self;
  final $Res Function(NotificationCount) _then;

/// Create a copy of NotificationCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationCount].
extension NotificationCountPatterns on NotificationCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationCount value)  $default,){
final _that = this;
switch (_that) {
case _NotificationCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationCount value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationCount() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _NotificationCount implements NotificationCount {
  const _NotificationCount({@JsonKey(name: 'count') this.count = 0});
  factory _NotificationCount.fromJson(Map<String, dynamic> json) => _$NotificationCountFromJson(json);

@override@JsonKey(name: 'count') final  int count;

/// Create a copy of NotificationCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationCountCopyWith<_NotificationCount> get copyWith => __$NotificationCountCopyWithImpl<_NotificationCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationCountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationCount&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'NotificationCount(count: $count)';
}


}

/// @nodoc
abstract mixin class _$NotificationCountCopyWith<$Res> implements $NotificationCountCopyWith<$Res> {
  factory _$NotificationCountCopyWith(_NotificationCount value, $Res Function(_NotificationCount) _then) = __$NotificationCountCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'count') int count
});




}
/// @nodoc
class __$NotificationCountCopyWithImpl<$Res>
    implements _$NotificationCountCopyWith<$Res> {
  __$NotificationCountCopyWithImpl(this._self, this._then);

  final _NotificationCount _self;
  final $Res Function(_NotificationCount) _then;

/// Create a copy of NotificationCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(_NotificationCount(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
