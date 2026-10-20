// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'milestone_catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MilestoneCatalog {

@JsonKey(name: 'categories') List<MilestoneCategoryRecord> get categories;
/// Create a copy of MilestoneCatalog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MilestoneCatalogCopyWith<MilestoneCatalog> get copyWith => _$MilestoneCatalogCopyWithImpl<MilestoneCatalog>(this as MilestoneCatalog, _$identity);

  /// Serializes this MilestoneCatalog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MilestoneCatalog&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(categories));

@override
String toString() {
  return 'MilestoneCatalog(categories: $categories)';
}


}

/// @nodoc
abstract mixin class $MilestoneCatalogCopyWith<$Res>  {
  factory $MilestoneCatalogCopyWith(MilestoneCatalog value, $Res Function(MilestoneCatalog) _then) = _$MilestoneCatalogCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'categories') List<MilestoneCategoryRecord> categories
});




}
/// @nodoc
class _$MilestoneCatalogCopyWithImpl<$Res>
    implements $MilestoneCatalogCopyWith<$Res> {
  _$MilestoneCatalogCopyWithImpl(this._self, this._then);

  final MilestoneCatalog _self;
  final $Res Function(MilestoneCatalog) _then;

/// Create a copy of MilestoneCatalog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,}) {
  return _then(_self.copyWith(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<MilestoneCategoryRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [MilestoneCatalog].
extension MilestoneCatalogPatterns on MilestoneCatalog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MilestoneCatalog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MilestoneCatalog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MilestoneCatalog value)  $default,){
final _that = this;
switch (_that) {
case _MilestoneCatalog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MilestoneCatalog value)?  $default,){
final _that = this;
switch (_that) {
case _MilestoneCatalog() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MilestoneCatalog implements MilestoneCatalog {
  const _MilestoneCatalog({@JsonKey(name: 'categories') final  List<MilestoneCategoryRecord> categories = const <MilestoneCategoryRecord>[]}): _categories = categories;
  factory _MilestoneCatalog.fromJson(Map<String, dynamic> json) => _$MilestoneCatalogFromJson(json);

 final  List<MilestoneCategoryRecord> _categories;
@override@JsonKey(name: 'categories') List<MilestoneCategoryRecord> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of MilestoneCatalog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MilestoneCatalogCopyWith<_MilestoneCatalog> get copyWith => __$MilestoneCatalogCopyWithImpl<_MilestoneCatalog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MilestoneCatalogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MilestoneCatalog&&const DeepCollectionEquality().equals(other._categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'MilestoneCatalog(categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$MilestoneCatalogCopyWith<$Res> implements $MilestoneCatalogCopyWith<$Res> {
  factory _$MilestoneCatalogCopyWith(_MilestoneCatalog value, $Res Function(_MilestoneCatalog) _then) = __$MilestoneCatalogCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'categories') List<MilestoneCategoryRecord> categories
});




}
/// @nodoc
class __$MilestoneCatalogCopyWithImpl<$Res>
    implements _$MilestoneCatalogCopyWith<$Res> {
  __$MilestoneCatalogCopyWithImpl(this._self, this._then);

  final _MilestoneCatalog _self;
  final $Res Function(_MilestoneCatalog) _then;

/// Create a copy of MilestoneCatalog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,}) {
  return _then(_MilestoneCatalog(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<MilestoneCategoryRecord>,
  ));
}


}

// dart format on
