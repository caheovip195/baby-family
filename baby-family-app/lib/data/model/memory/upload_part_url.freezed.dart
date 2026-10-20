// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_part_url.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UploadPartUrl {

@JsonKey(name: 'n') int get n;@JsonKey(name: 'url') String get url;
/// Create a copy of UploadPartUrl
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadPartUrlCopyWith<UploadPartUrl> get copyWith => _$UploadPartUrlCopyWithImpl<UploadPartUrl>(this as UploadPartUrl, _$identity);

  /// Serializes this UploadPartUrl to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadPartUrl&&(identical(other.n, n) || other.n == n)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,n,url);

@override
String toString() {
  return 'UploadPartUrl(n: $n, url: $url)';
}


}

/// @nodoc
abstract mixin class $UploadPartUrlCopyWith<$Res>  {
  factory $UploadPartUrlCopyWith(UploadPartUrl value, $Res Function(UploadPartUrl) _then) = _$UploadPartUrlCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'n') int n,@JsonKey(name: 'url') String url
});




}
/// @nodoc
class _$UploadPartUrlCopyWithImpl<$Res>
    implements $UploadPartUrlCopyWith<$Res> {
  _$UploadPartUrlCopyWithImpl(this._self, this._then);

  final UploadPartUrl _self;
  final $Res Function(UploadPartUrl) _then;

/// Create a copy of UploadPartUrl
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? n = null,Object? url = null,}) {
  return _then(_self.copyWith(
n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadPartUrl].
extension UploadPartUrlPatterns on UploadPartUrl {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadPartUrl value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadPartUrl() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadPartUrl value)  $default,){
final _that = this;
switch (_that) {
case _UploadPartUrl():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadPartUrl value)?  $default,){
final _that = this;
switch (_that) {
case _UploadPartUrl() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _UploadPartUrl implements UploadPartUrl {
  const _UploadPartUrl({@JsonKey(name: 'n') required this.n, @JsonKey(name: 'url') required this.url});
  factory _UploadPartUrl.fromJson(Map<String, dynamic> json) => _$UploadPartUrlFromJson(json);

@override@JsonKey(name: 'n') final  int n;
@override@JsonKey(name: 'url') final  String url;

/// Create a copy of UploadPartUrl
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadPartUrlCopyWith<_UploadPartUrl> get copyWith => __$UploadPartUrlCopyWithImpl<_UploadPartUrl>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadPartUrlToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadPartUrl&&(identical(other.n, n) || other.n == n)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,n,url);

@override
String toString() {
  return 'UploadPartUrl(n: $n, url: $url)';
}


}

/// @nodoc
abstract mixin class _$UploadPartUrlCopyWith<$Res> implements $UploadPartUrlCopyWith<$Res> {
  factory _$UploadPartUrlCopyWith(_UploadPartUrl value, $Res Function(_UploadPartUrl) _then) = __$UploadPartUrlCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'n') int n,@JsonKey(name: 'url') String url
});




}
/// @nodoc
class __$UploadPartUrlCopyWithImpl<$Res>
    implements _$UploadPartUrlCopyWith<$Res> {
  __$UploadPartUrlCopyWithImpl(this._self, this._then);

  final _UploadPartUrl _self;
  final $Res Function(_UploadPartUrl) _then;

/// Create a copy of UploadPartUrl
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? n = null,Object? url = null,}) {
  return _then(_UploadPartUrl(
n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
