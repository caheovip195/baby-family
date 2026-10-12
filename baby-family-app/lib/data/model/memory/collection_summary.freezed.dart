// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CollectionSummary {

@JsonKey(name: 'code') String get code;@JsonKey(name: 'title') String get title;@JsonKey(name: 'coverAsset') String? get coverAsset;@JsonKey(name: 'count') int get count;
/// Create a copy of CollectionSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionSummaryCopyWith<CollectionSummary> get copyWith => _$CollectionSummaryCopyWithImpl<CollectionSummary>(this as CollectionSummary, _$identity);

  /// Serializes this CollectionSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionSummary&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.coverAsset, coverAsset) || other.coverAsset == coverAsset)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,coverAsset,count);

@override
String toString() {
  return 'CollectionSummary(code: $code, title: $title, coverAsset: $coverAsset, count: $count)';
}


}

/// @nodoc
abstract mixin class $CollectionSummaryCopyWith<$Res>  {
  factory $CollectionSummaryCopyWith(CollectionSummary value, $Res Function(CollectionSummary) _then) = _$CollectionSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'title') String title,@JsonKey(name: 'coverAsset') String? coverAsset,@JsonKey(name: 'count') int count
});




}
/// @nodoc
class _$CollectionSummaryCopyWithImpl<$Res>
    implements $CollectionSummaryCopyWith<$Res> {
  _$CollectionSummaryCopyWithImpl(this._self, this._then);

  final CollectionSummary _self;
  final $Res Function(CollectionSummary) _then;

/// Create a copy of CollectionSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? title = null,Object? coverAsset = freezed,Object? count = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverAsset: freezed == coverAsset ? _self.coverAsset : coverAsset // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectionSummary].
extension CollectionSummaryPatterns on CollectionSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionSummary value)  $default,){
final _that = this;
switch (_that) {
case _CollectionSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CollectionSummary implements CollectionSummary {
  const _CollectionSummary({@JsonKey(name: 'code') required this.code, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'coverAsset') this.coverAsset, @JsonKey(name: 'count') this.count = 0});
  factory _CollectionSummary.fromJson(Map<String, dynamic> json) => _$CollectionSummaryFromJson(json);

@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'coverAsset') final  String? coverAsset;
@override@JsonKey(name: 'count') final  int count;

/// Create a copy of CollectionSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionSummaryCopyWith<_CollectionSummary> get copyWith => __$CollectionSummaryCopyWithImpl<_CollectionSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionSummary&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.coverAsset, coverAsset) || other.coverAsset == coverAsset)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,coverAsset,count);

@override
String toString() {
  return 'CollectionSummary(code: $code, title: $title, coverAsset: $coverAsset, count: $count)';
}


}

/// @nodoc
abstract mixin class _$CollectionSummaryCopyWith<$Res> implements $CollectionSummaryCopyWith<$Res> {
  factory _$CollectionSummaryCopyWith(_CollectionSummary value, $Res Function(_CollectionSummary) _then) = __$CollectionSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'title') String title,@JsonKey(name: 'coverAsset') String? coverAsset,@JsonKey(name: 'count') int count
});




}
/// @nodoc
class __$CollectionSummaryCopyWithImpl<$Res>
    implements _$CollectionSummaryCopyWith<$Res> {
  __$CollectionSummaryCopyWithImpl(this._self, this._then);

  final _CollectionSummary _self;
  final $Res Function(_CollectionSummary) _then;

/// Create a copy of CollectionSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? title = null,Object? coverAsset = freezed,Object? count = null,}) {
  return _then(_CollectionSummary(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverAsset: freezed == coverAsset ? _self.coverAsset : coverAsset // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
