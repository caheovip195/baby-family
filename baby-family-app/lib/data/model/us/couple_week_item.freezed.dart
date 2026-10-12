// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'couple_week_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoupleWeekItem {

@JsonKey(name: 'title') String get title;@JsonKey(name: 'date') DateTime get date;
/// Create a copy of CoupleWeekItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoupleWeekItemCopyWith<CoupleWeekItem> get copyWith => _$CoupleWeekItemCopyWithImpl<CoupleWeekItem>(this as CoupleWeekItem, _$identity);

  /// Serializes this CoupleWeekItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoupleWeekItem&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,date);

@override
String toString() {
  return 'CoupleWeekItem(title: $title, date: $date)';
}


}

/// @nodoc
abstract mixin class $CoupleWeekItemCopyWith<$Res>  {
  factory $CoupleWeekItemCopyWith(CoupleWeekItem value, $Res Function(CoupleWeekItem) _then) = _$CoupleWeekItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'title') String title,@JsonKey(name: 'date') DateTime date
});




}
/// @nodoc
class _$CoupleWeekItemCopyWithImpl<$Res>
    implements $CoupleWeekItemCopyWith<$Res> {
  _$CoupleWeekItemCopyWithImpl(this._self, this._then);

  final CoupleWeekItem _self;
  final $Res Function(CoupleWeekItem) _then;

/// Create a copy of CoupleWeekItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? date = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CoupleWeekItem].
extension CoupleWeekItemPatterns on CoupleWeekItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoupleWeekItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoupleWeekItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoupleWeekItem value)  $default,){
final _that = this;
switch (_that) {
case _CoupleWeekItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoupleWeekItem value)?  $default,){
final _that = this;
switch (_that) {
case _CoupleWeekItem() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CoupleWeekItem implements CoupleWeekItem {
  const _CoupleWeekItem({@JsonKey(name: 'title') required this.title, @JsonKey(name: 'date') required this.date});
  factory _CoupleWeekItem.fromJson(Map<String, dynamic> json) => _$CoupleWeekItemFromJson(json);

@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'date') final  DateTime date;

/// Create a copy of CoupleWeekItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoupleWeekItemCopyWith<_CoupleWeekItem> get copyWith => __$CoupleWeekItemCopyWithImpl<_CoupleWeekItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoupleWeekItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoupleWeekItem&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,date);

@override
String toString() {
  return 'CoupleWeekItem(title: $title, date: $date)';
}


}

/// @nodoc
abstract mixin class _$CoupleWeekItemCopyWith<$Res> implements $CoupleWeekItemCopyWith<$Res> {
  factory _$CoupleWeekItemCopyWith(_CoupleWeekItem value, $Res Function(_CoupleWeekItem) _then) = __$CoupleWeekItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'title') String title,@JsonKey(name: 'date') DateTime date
});




}
/// @nodoc
class __$CoupleWeekItemCopyWithImpl<$Res>
    implements _$CoupleWeekItemCopyWith<$Res> {
  __$CoupleWeekItemCopyWithImpl(this._self, this._then);

  final _CoupleWeekItem _self;
  final $Res Function(_CoupleWeekItem) _then;

/// Create a copy of CoupleWeekItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? date = null,}) {
  return _then(_CoupleWeekItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
