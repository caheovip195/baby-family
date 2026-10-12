// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_story_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DayStoryItem {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'title') String get title;@JsonKey(name: 'kindCode') String get kindCode;@JsonKey(name: 'time') String? get time;@JsonKey(name: 'icon') String? get icon;@JsonKey(name: 'selected') bool get selected;
/// Create a copy of DayStoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayStoryItemCopyWith<DayStoryItem> get copyWith => _$DayStoryItemCopyWithImpl<DayStoryItem>(this as DayStoryItem, _$identity);

  /// Serializes this DayStoryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayStoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.kindCode, kindCode) || other.kindCode == kindCode)&&(identical(other.time, time) || other.time == time)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.selected, selected) || other.selected == selected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,kindCode,time,icon,selected);

@override
String toString() {
  return 'DayStoryItem(id: $id, title: $title, kindCode: $kindCode, time: $time, icon: $icon, selected: $selected)';
}


}

/// @nodoc
abstract mixin class $DayStoryItemCopyWith<$Res>  {
  factory $DayStoryItemCopyWith(DayStoryItem value, $Res Function(DayStoryItem) _then) = _$DayStoryItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'title') String title,@JsonKey(name: 'kindCode') String kindCode,@JsonKey(name: 'time') String? time,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'selected') bool selected
});




}
/// @nodoc
class _$DayStoryItemCopyWithImpl<$Res>
    implements $DayStoryItemCopyWith<$Res> {
  _$DayStoryItemCopyWithImpl(this._self, this._then);

  final DayStoryItem _self;
  final $Res Function(DayStoryItem) _then;

/// Create a copy of DayStoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? kindCode = null,Object? time = freezed,Object? icon = freezed,Object? selected = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kindCode: null == kindCode ? _self.kindCode : kindCode // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DayStoryItem].
extension DayStoryItemPatterns on DayStoryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayStoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayStoryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayStoryItem value)  $default,){
final _that = this;
switch (_that) {
case _DayStoryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayStoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _DayStoryItem() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DayStoryItem implements DayStoryItem {
  const _DayStoryItem({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'kindCode') this.kindCode = 'photo', @JsonKey(name: 'time') this.time, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'selected') this.selected = true});
  factory _DayStoryItem.fromJson(Map<String, dynamic> json) => _$DayStoryItemFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'kindCode') final  String kindCode;
@override@JsonKey(name: 'time') final  String? time;
@override@JsonKey(name: 'icon') final  String? icon;
@override@JsonKey(name: 'selected') final  bool selected;

/// Create a copy of DayStoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayStoryItemCopyWith<_DayStoryItem> get copyWith => __$DayStoryItemCopyWithImpl<_DayStoryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayStoryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayStoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.kindCode, kindCode) || other.kindCode == kindCode)&&(identical(other.time, time) || other.time == time)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.selected, selected) || other.selected == selected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,kindCode,time,icon,selected);

@override
String toString() {
  return 'DayStoryItem(id: $id, title: $title, kindCode: $kindCode, time: $time, icon: $icon, selected: $selected)';
}


}

/// @nodoc
abstract mixin class _$DayStoryItemCopyWith<$Res> implements $DayStoryItemCopyWith<$Res> {
  factory _$DayStoryItemCopyWith(_DayStoryItem value, $Res Function(_DayStoryItem) _then) = __$DayStoryItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'title') String title,@JsonKey(name: 'kindCode') String kindCode,@JsonKey(name: 'time') String? time,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'selected') bool selected
});




}
/// @nodoc
class __$DayStoryItemCopyWithImpl<$Res>
    implements _$DayStoryItemCopyWith<$Res> {
  __$DayStoryItemCopyWithImpl(this._self, this._then);

  final _DayStoryItem _self;
  final $Res Function(_DayStoryItem) _then;

/// Create a copy of DayStoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? kindCode = null,Object? time = freezed,Object? icon = freezed,Object? selected = null,}) {
  return _then(_DayStoryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kindCode: null == kindCode ? _self.kindCode : kindCode // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
