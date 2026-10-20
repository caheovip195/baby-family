// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_series_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionSeriesList {

@JsonKey(name: 'items') List<MissionSeriesRecord> get items;
/// Create a copy of MissionSeriesList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionSeriesListCopyWith<MissionSeriesList> get copyWith => _$MissionSeriesListCopyWithImpl<MissionSeriesList>(this as MissionSeriesList, _$identity);

  /// Serializes this MissionSeriesList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionSeriesList&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'MissionSeriesList(items: $items)';
}


}

/// @nodoc
abstract mixin class $MissionSeriesListCopyWith<$Res>  {
  factory $MissionSeriesListCopyWith(MissionSeriesList value, $Res Function(MissionSeriesList) _then) = _$MissionSeriesListCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items') List<MissionSeriesRecord> items
});




}
/// @nodoc
class _$MissionSeriesListCopyWithImpl<$Res>
    implements $MissionSeriesListCopyWith<$Res> {
  _$MissionSeriesListCopyWithImpl(this._self, this._then);

  final MissionSeriesList _self;
  final $Res Function(MissionSeriesList) _then;

/// Create a copy of MissionSeriesList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MissionSeriesRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionSeriesList].
extension MissionSeriesListPatterns on MissionSeriesList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionSeriesList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionSeriesList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionSeriesList value)  $default,){
final _that = this;
switch (_that) {
case _MissionSeriesList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionSeriesList value)?  $default,){
final _that = this;
switch (_that) {
case _MissionSeriesList() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MissionSeriesList implements MissionSeriesList {
  const _MissionSeriesList({@JsonKey(name: 'items') final  List<MissionSeriesRecord> items = const <MissionSeriesRecord>[]}): _items = items;
  factory _MissionSeriesList.fromJson(Map<String, dynamic> json) => _$MissionSeriesListFromJson(json);

 final  List<MissionSeriesRecord> _items;
@override@JsonKey(name: 'items') List<MissionSeriesRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of MissionSeriesList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionSeriesListCopyWith<_MissionSeriesList> get copyWith => __$MissionSeriesListCopyWithImpl<_MissionSeriesList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionSeriesListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionSeriesList&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'MissionSeriesList(items: $items)';
}


}

/// @nodoc
abstract mixin class _$MissionSeriesListCopyWith<$Res> implements $MissionSeriesListCopyWith<$Res> {
  factory _$MissionSeriesListCopyWith(_MissionSeriesList value, $Res Function(_MissionSeriesList) _then) = __$MissionSeriesListCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items') List<MissionSeriesRecord> items
});




}
/// @nodoc
class __$MissionSeriesListCopyWithImpl<$Res>
    implements _$MissionSeriesListCopyWith<$Res> {
  __$MissionSeriesListCopyWithImpl(this._self, this._then);

  final _MissionSeriesList _self;
  final $Res Function(_MissionSeriesList) _then;

/// Create a copy of MissionSeriesList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_MissionSeriesList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MissionSeriesRecord>,
  ));
}


}

// dart format on
