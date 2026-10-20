// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_category_catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupportCategoryCatalog {

@JsonKey(name: 'version') int? get version;@JsonKey(name: 'categories') List<String> get categories;
/// Create a copy of SupportCategoryCatalog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportCategoryCatalogCopyWith<SupportCategoryCatalog> get copyWith => _$SupportCategoryCatalogCopyWithImpl<SupportCategoryCatalog>(this as SupportCategoryCatalog, _$identity);

  /// Serializes this SupportCategoryCatalog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportCategoryCatalog&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(categories));

@override
String toString() {
  return 'SupportCategoryCatalog(version: $version, categories: $categories)';
}


}

/// @nodoc
abstract mixin class $SupportCategoryCatalogCopyWith<$Res>  {
  factory $SupportCategoryCatalogCopyWith(SupportCategoryCatalog value, $Res Function(SupportCategoryCatalog) _then) = _$SupportCategoryCatalogCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'version') int? version,@JsonKey(name: 'categories') List<String> categories
});




}
/// @nodoc
class _$SupportCategoryCatalogCopyWithImpl<$Res>
    implements $SupportCategoryCatalogCopyWith<$Res> {
  _$SupportCategoryCatalogCopyWithImpl(this._self, this._then);

  final SupportCategoryCatalog _self;
  final $Res Function(SupportCategoryCatalog) _then;

/// Create a copy of SupportCategoryCatalog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = freezed,Object? categories = null,}) {
  return _then(_self.copyWith(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SupportCategoryCatalog].
extension SupportCategoryCatalogPatterns on SupportCategoryCatalog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportCategoryCatalog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportCategoryCatalog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportCategoryCatalog value)  $default,){
final _that = this;
switch (_that) {
case _SupportCategoryCatalog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportCategoryCatalog value)?  $default,){
final _that = this;
switch (_that) {
case _SupportCategoryCatalog() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SupportCategoryCatalog implements SupportCategoryCatalog {
  const _SupportCategoryCatalog({@JsonKey(name: 'version') this.version, @JsonKey(name: 'categories') final  List<String> categories = const <String>[]}): _categories = categories;
  factory _SupportCategoryCatalog.fromJson(Map<String, dynamic> json) => _$SupportCategoryCatalogFromJson(json);

@override@JsonKey(name: 'version') final  int? version;
 final  List<String> _categories;
@override@JsonKey(name: 'categories') List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of SupportCategoryCatalog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportCategoryCatalogCopyWith<_SupportCategoryCatalog> get copyWith => __$SupportCategoryCatalogCopyWithImpl<_SupportCategoryCatalog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupportCategoryCatalogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportCategoryCatalog&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'SupportCategoryCatalog(version: $version, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$SupportCategoryCatalogCopyWith<$Res> implements $SupportCategoryCatalogCopyWith<$Res> {
  factory _$SupportCategoryCatalogCopyWith(_SupportCategoryCatalog value, $Res Function(_SupportCategoryCatalog) _then) = __$SupportCategoryCatalogCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'version') int? version,@JsonKey(name: 'categories') List<String> categories
});




}
/// @nodoc
class __$SupportCategoryCatalogCopyWithImpl<$Res>
    implements _$SupportCategoryCatalogCopyWith<$Res> {
  __$SupportCategoryCatalogCopyWithImpl(this._self, this._then);

  final _SupportCategoryCatalog _self;
  final $Res Function(_SupportCategoryCatalog) _then;

/// Create a copy of SupportCategoryCatalog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = freezed,Object? categories = null,}) {
  return _then(_SupportCategoryCatalog(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
