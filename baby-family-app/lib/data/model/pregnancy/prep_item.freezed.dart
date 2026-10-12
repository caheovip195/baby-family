// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prep_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrepItem {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'pregnancyId') String get pregnancyId;@JsonKey(name: 'group') PrepGroup get group;@JsonKey(name: 'title') String get title;@JsonKey(name: 'done') bool get done;@JsonKey(name: 'ownerKind') MissionOwnerKind? get ownerKind;@JsonKey(name: 'requestedFromPartner') bool get requestedFromPartner;@JsonKey(name: 'isCustom') bool get isCustom;
/// Create a copy of PrepItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrepItemCopyWith<PrepItem> get copyWith => _$PrepItemCopyWithImpl<PrepItem>(this as PrepItem, _$identity);

  /// Serializes this PrepItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrepItem&&(identical(other.id, id) || other.id == id)&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.group, group) || other.group == group)&&(identical(other.title, title) || other.title == title)&&(identical(other.done, done) || other.done == done)&&(identical(other.ownerKind, ownerKind) || other.ownerKind == ownerKind)&&(identical(other.requestedFromPartner, requestedFromPartner) || other.requestedFromPartner == requestedFromPartner)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pregnancyId,group,title,done,ownerKind,requestedFromPartner,isCustom);

@override
String toString() {
  return 'PrepItem(id: $id, pregnancyId: $pregnancyId, group: $group, title: $title, done: $done, ownerKind: $ownerKind, requestedFromPartner: $requestedFromPartner, isCustom: $isCustom)';
}


}

/// @nodoc
abstract mixin class $PrepItemCopyWith<$Res>  {
  factory $PrepItemCopyWith(PrepItem value, $Res Function(PrepItem) _then) = _$PrepItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'pregnancyId') String pregnancyId,@JsonKey(name: 'group') PrepGroup group,@JsonKey(name: 'title') String title,@JsonKey(name: 'done') bool done,@JsonKey(name: 'ownerKind') MissionOwnerKind? ownerKind,@JsonKey(name: 'requestedFromPartner') bool requestedFromPartner,@JsonKey(name: 'isCustom') bool isCustom
});




}
/// @nodoc
class _$PrepItemCopyWithImpl<$Res>
    implements $PrepItemCopyWith<$Res> {
  _$PrepItemCopyWithImpl(this._self, this._then);

  final PrepItem _self;
  final $Res Function(PrepItem) _then;

/// Create a copy of PrepItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pregnancyId = null,Object? group = null,Object? title = null,Object? done = null,Object? ownerKind = freezed,Object? requestedFromPartner = null,Object? isCustom = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pregnancyId: null == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as PrepGroup,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,ownerKind: freezed == ownerKind ? _self.ownerKind : ownerKind // ignore: cast_nullable_to_non_nullable
as MissionOwnerKind?,requestedFromPartner: null == requestedFromPartner ? _self.requestedFromPartner : requestedFromPartner // ignore: cast_nullable_to_non_nullable
as bool,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PrepItem].
extension PrepItemPatterns on PrepItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrepItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrepItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrepItem value)  $default,){
final _that = this;
switch (_that) {
case _PrepItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrepItem value)?  $default,){
final _that = this;
switch (_that) {
case _PrepItem() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PrepItem implements PrepItem {
  const _PrepItem({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'pregnancyId') required this.pregnancyId, @JsonKey(name: 'group') this.group = PrepGroup.bag, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'done') this.done = false, @JsonKey(name: 'ownerKind') this.ownerKind, @JsonKey(name: 'requestedFromPartner') this.requestedFromPartner = false, @JsonKey(name: 'isCustom') this.isCustom = false});
  factory _PrepItem.fromJson(Map<String, dynamic> json) => _$PrepItemFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'pregnancyId') final  String pregnancyId;
@override@JsonKey(name: 'group') final  PrepGroup group;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'done') final  bool done;
@override@JsonKey(name: 'ownerKind') final  MissionOwnerKind? ownerKind;
@override@JsonKey(name: 'requestedFromPartner') final  bool requestedFromPartner;
@override@JsonKey(name: 'isCustom') final  bool isCustom;

/// Create a copy of PrepItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrepItemCopyWith<_PrepItem> get copyWith => __$PrepItemCopyWithImpl<_PrepItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrepItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrepItem&&(identical(other.id, id) || other.id == id)&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.group, group) || other.group == group)&&(identical(other.title, title) || other.title == title)&&(identical(other.done, done) || other.done == done)&&(identical(other.ownerKind, ownerKind) || other.ownerKind == ownerKind)&&(identical(other.requestedFromPartner, requestedFromPartner) || other.requestedFromPartner == requestedFromPartner)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pregnancyId,group,title,done,ownerKind,requestedFromPartner,isCustom);

@override
String toString() {
  return 'PrepItem(id: $id, pregnancyId: $pregnancyId, group: $group, title: $title, done: $done, ownerKind: $ownerKind, requestedFromPartner: $requestedFromPartner, isCustom: $isCustom)';
}


}

/// @nodoc
abstract mixin class _$PrepItemCopyWith<$Res> implements $PrepItemCopyWith<$Res> {
  factory _$PrepItemCopyWith(_PrepItem value, $Res Function(_PrepItem) _then) = __$PrepItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'pregnancyId') String pregnancyId,@JsonKey(name: 'group') PrepGroup group,@JsonKey(name: 'title') String title,@JsonKey(name: 'done') bool done,@JsonKey(name: 'ownerKind') MissionOwnerKind? ownerKind,@JsonKey(name: 'requestedFromPartner') bool requestedFromPartner,@JsonKey(name: 'isCustom') bool isCustom
});




}
/// @nodoc
class __$PrepItemCopyWithImpl<$Res>
    implements _$PrepItemCopyWith<$Res> {
  __$PrepItemCopyWithImpl(this._self, this._then);

  final _PrepItem _self;
  final $Res Function(_PrepItem) _then;

/// Create a copy of PrepItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pregnancyId = null,Object? group = null,Object? title = null,Object? done = null,Object? ownerKind = freezed,Object? requestedFromPartner = null,Object? isCustom = null,}) {
  return _then(_PrepItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pregnancyId: null == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as PrepGroup,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,ownerKind: freezed == ownerKind ? _self.ownerKind : ownerKind // ignore: cast_nullable_to_non_nullable
as MissionOwnerKind?,requestedFromPartner: null == requestedFromPartner ? _self.requestedFromPartner : requestedFromPartner // ignore: cast_nullable_to_non_nullable
as bool,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
