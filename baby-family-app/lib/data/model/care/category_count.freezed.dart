// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryCount {

@JsonKey(name: 'code') String get code;@JsonKey(name: 'count') int get count;
/// Create a copy of CategoryCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryCountCopyWith<CategoryCount> get copyWith => _$CategoryCountCopyWithImpl<CategoryCount>(this as CategoryCount, _$identity);

  /// Serializes this CategoryCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryCount&&(identical(other.code, code) || other.code == code)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,count);

@override
String toString() {
  return 'CategoryCount(code: $code, count: $count)';
}


}

/// @nodoc
abstract mixin class $CategoryCountCopyWith<$Res>  {
  factory $CategoryCountCopyWith(CategoryCount value, $Res Function(CategoryCount) _then) = _$CategoryCountCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'count') int count
});




}
/// @nodoc
class _$CategoryCountCopyWithImpl<$Res>
    implements $CategoryCountCopyWith<$Res> {
  _$CategoryCountCopyWithImpl(this._self, this._then);

  final CategoryCount _self;
  final $Res Function(CategoryCount) _then;

/// Create a copy of CategoryCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? count = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryCount].
extension CategoryCountPatterns on CategoryCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryCount value)  $default,){
final _that = this;
switch (_that) {
case _CategoryCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryCount value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryCount() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CategoryCount implements CategoryCount {
  const _CategoryCount({@JsonKey(name: 'code') required this.code, @JsonKey(name: 'count') this.count = 0});
  factory _CategoryCount.fromJson(Map<String, dynamic> json) => _$CategoryCountFromJson(json);

@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'count') final  int count;

/// Create a copy of CategoryCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryCountCopyWith<_CategoryCount> get copyWith => __$CategoryCountCopyWithImpl<_CategoryCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryCountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryCount&&(identical(other.code, code) || other.code == code)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,count);

@override
String toString() {
  return 'CategoryCount(code: $code, count: $count)';
}


}

/// @nodoc
abstract mixin class _$CategoryCountCopyWith<$Res> implements $CategoryCountCopyWith<$Res> {
  factory _$CategoryCountCopyWith(_CategoryCount value, $Res Function(_CategoryCount) _then) = __$CategoryCountCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'count') int count
});




}
/// @nodoc
class __$CategoryCountCopyWithImpl<$Res>
    implements _$CategoryCountCopyWith<$Res> {
  __$CategoryCountCopyWithImpl(this._self, this._then);

  final _CategoryCount _self;
  final $Res Function(_CategoryCount) _then;

/// Create a copy of CategoryCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? count = null,}) {
  return _then(_CategoryCount(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
