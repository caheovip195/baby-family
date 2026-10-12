// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'milestone_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MilestoneItem {

@JsonKey(name: 'code') String get code;@JsonKey(name: 'title') String get title;@JsonKey(name: 'forPregnancy') bool get forPregnancy;@JsonKey(name: 'typicalAgeDays') int? get typicalAgeDays;@JsonKey(name: 'memoryId') String? get memoryId;@JsonKey(name: 'achievedAt') DateTime? get achievedAt;@JsonKey(name: 'asset') String? get asset;
/// Create a copy of MilestoneItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MilestoneItemCopyWith<MilestoneItem> get copyWith => _$MilestoneItemCopyWithImpl<MilestoneItem>(this as MilestoneItem, _$identity);

  /// Serializes this MilestoneItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MilestoneItem&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.forPregnancy, forPregnancy) || other.forPregnancy == forPregnancy)&&(identical(other.typicalAgeDays, typicalAgeDays) || other.typicalAgeDays == typicalAgeDays)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.achievedAt, achievedAt) || other.achievedAt == achievedAt)&&(identical(other.asset, asset) || other.asset == asset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,forPregnancy,typicalAgeDays,memoryId,achievedAt,asset);

@override
String toString() {
  return 'MilestoneItem(code: $code, title: $title, forPregnancy: $forPregnancy, typicalAgeDays: $typicalAgeDays, memoryId: $memoryId, achievedAt: $achievedAt, asset: $asset)';
}


}

/// @nodoc
abstract mixin class $MilestoneItemCopyWith<$Res>  {
  factory $MilestoneItemCopyWith(MilestoneItem value, $Res Function(MilestoneItem) _then) = _$MilestoneItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'title') String title,@JsonKey(name: 'forPregnancy') bool forPregnancy,@JsonKey(name: 'typicalAgeDays') int? typicalAgeDays,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'achievedAt') DateTime? achievedAt,@JsonKey(name: 'asset') String? asset
});




}
/// @nodoc
class _$MilestoneItemCopyWithImpl<$Res>
    implements $MilestoneItemCopyWith<$Res> {
  _$MilestoneItemCopyWithImpl(this._self, this._then);

  final MilestoneItem _self;
  final $Res Function(MilestoneItem) _then;

/// Create a copy of MilestoneItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? title = null,Object? forPregnancy = null,Object? typicalAgeDays = freezed,Object? memoryId = freezed,Object? achievedAt = freezed,Object? asset = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,forPregnancy: null == forPregnancy ? _self.forPregnancy : forPregnancy // ignore: cast_nullable_to_non_nullable
as bool,typicalAgeDays: freezed == typicalAgeDays ? _self.typicalAgeDays : typicalAgeDays // ignore: cast_nullable_to_non_nullable
as int?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,achievedAt: freezed == achievedAt ? _self.achievedAt : achievedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,asset: freezed == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MilestoneItem].
extension MilestoneItemPatterns on MilestoneItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MilestoneItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MilestoneItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MilestoneItem value)  $default,){
final _that = this;
switch (_that) {
case _MilestoneItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MilestoneItem value)?  $default,){
final _that = this;
switch (_that) {
case _MilestoneItem() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MilestoneItem extends MilestoneItem {
  const _MilestoneItem({@JsonKey(name: 'code') required this.code, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'forPregnancy') this.forPregnancy = false, @JsonKey(name: 'typicalAgeDays') this.typicalAgeDays, @JsonKey(name: 'memoryId') this.memoryId, @JsonKey(name: 'achievedAt') this.achievedAt, @JsonKey(name: 'asset') this.asset}): super._();
  factory _MilestoneItem.fromJson(Map<String, dynamic> json) => _$MilestoneItemFromJson(json);

@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'forPregnancy') final  bool forPregnancy;
@override@JsonKey(name: 'typicalAgeDays') final  int? typicalAgeDays;
@override@JsonKey(name: 'memoryId') final  String? memoryId;
@override@JsonKey(name: 'achievedAt') final  DateTime? achievedAt;
@override@JsonKey(name: 'asset') final  String? asset;

/// Create a copy of MilestoneItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MilestoneItemCopyWith<_MilestoneItem> get copyWith => __$MilestoneItemCopyWithImpl<_MilestoneItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MilestoneItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MilestoneItem&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.forPregnancy, forPregnancy) || other.forPregnancy == forPregnancy)&&(identical(other.typicalAgeDays, typicalAgeDays) || other.typicalAgeDays == typicalAgeDays)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.achievedAt, achievedAt) || other.achievedAt == achievedAt)&&(identical(other.asset, asset) || other.asset == asset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,forPregnancy,typicalAgeDays,memoryId,achievedAt,asset);

@override
String toString() {
  return 'MilestoneItem(code: $code, title: $title, forPregnancy: $forPregnancy, typicalAgeDays: $typicalAgeDays, memoryId: $memoryId, achievedAt: $achievedAt, asset: $asset)';
}


}

/// @nodoc
abstract mixin class _$MilestoneItemCopyWith<$Res> implements $MilestoneItemCopyWith<$Res> {
  factory _$MilestoneItemCopyWith(_MilestoneItem value, $Res Function(_MilestoneItem) _then) = __$MilestoneItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'title') String title,@JsonKey(name: 'forPregnancy') bool forPregnancy,@JsonKey(name: 'typicalAgeDays') int? typicalAgeDays,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'achievedAt') DateTime? achievedAt,@JsonKey(name: 'asset') String? asset
});




}
/// @nodoc
class __$MilestoneItemCopyWithImpl<$Res>
    implements _$MilestoneItemCopyWith<$Res> {
  __$MilestoneItemCopyWithImpl(this._self, this._then);

  final _MilestoneItem _self;
  final $Res Function(_MilestoneItem) _then;

/// Create a copy of MilestoneItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? title = null,Object? forPregnancy = null,Object? typicalAgeDays = freezed,Object? memoryId = freezed,Object? achievedAt = freezed,Object? asset = freezed,}) {
  return _then(_MilestoneItem(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,forPregnancy: null == forPregnancy ? _self.forPregnancy : forPregnancy // ignore: cast_nullable_to_non_nullable
as bool,typicalAgeDays: freezed == typicalAgeDays ? _self.typicalAgeDays : typicalAgeDays // ignore: cast_nullable_to_non_nullable
as int?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,achievedAt: freezed == achievedAt ? _self.achievedAt : achievedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,asset: freezed == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
