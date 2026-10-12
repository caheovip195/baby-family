// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bump_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BumpPhoto {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'pregnancyId') String get pregnancyId;@JsonKey(name: 'week') int get week;@JsonKey(name: 'asset') String? get asset;@JsonKey(name: 'memoryId') String? get memoryId;@JsonKey(name: 'takenAt') DateTime? get takenAt;
/// Create a copy of BumpPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BumpPhotoCopyWith<BumpPhoto> get copyWith => _$BumpPhotoCopyWithImpl<BumpPhoto>(this as BumpPhoto, _$identity);

  /// Serializes this BumpPhoto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BumpPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.week, week) || other.week == week)&&(identical(other.asset, asset) || other.asset == asset)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pregnancyId,week,asset,memoryId,takenAt);

@override
String toString() {
  return 'BumpPhoto(id: $id, pregnancyId: $pregnancyId, week: $week, asset: $asset, memoryId: $memoryId, takenAt: $takenAt)';
}


}

/// @nodoc
abstract mixin class $BumpPhotoCopyWith<$Res>  {
  factory $BumpPhotoCopyWith(BumpPhoto value, $Res Function(BumpPhoto) _then) = _$BumpPhotoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'pregnancyId') String pregnancyId,@JsonKey(name: 'week') int week,@JsonKey(name: 'asset') String? asset,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'takenAt') DateTime? takenAt
});




}
/// @nodoc
class _$BumpPhotoCopyWithImpl<$Res>
    implements $BumpPhotoCopyWith<$Res> {
  _$BumpPhotoCopyWithImpl(this._self, this._then);

  final BumpPhoto _self;
  final $Res Function(BumpPhoto) _then;

/// Create a copy of BumpPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pregnancyId = null,Object? week = null,Object? asset = freezed,Object? memoryId = freezed,Object? takenAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pregnancyId: null == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String,week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as int,asset: freezed == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as String?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BumpPhoto].
extension BumpPhotoPatterns on BumpPhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BumpPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BumpPhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BumpPhoto value)  $default,){
final _that = this;
switch (_that) {
case _BumpPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BumpPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _BumpPhoto() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BumpPhoto implements BumpPhoto {
  const _BumpPhoto({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'pregnancyId') required this.pregnancyId, @JsonKey(name: 'week') required this.week, @JsonKey(name: 'asset') this.asset, @JsonKey(name: 'memoryId') this.memoryId, @JsonKey(name: 'takenAt') this.takenAt});
  factory _BumpPhoto.fromJson(Map<String, dynamic> json) => _$BumpPhotoFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'pregnancyId') final  String pregnancyId;
@override@JsonKey(name: 'week') final  int week;
@override@JsonKey(name: 'asset') final  String? asset;
@override@JsonKey(name: 'memoryId') final  String? memoryId;
@override@JsonKey(name: 'takenAt') final  DateTime? takenAt;

/// Create a copy of BumpPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BumpPhotoCopyWith<_BumpPhoto> get copyWith => __$BumpPhotoCopyWithImpl<_BumpPhoto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BumpPhotoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BumpPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.week, week) || other.week == week)&&(identical(other.asset, asset) || other.asset == asset)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pregnancyId,week,asset,memoryId,takenAt);

@override
String toString() {
  return 'BumpPhoto(id: $id, pregnancyId: $pregnancyId, week: $week, asset: $asset, memoryId: $memoryId, takenAt: $takenAt)';
}


}

/// @nodoc
abstract mixin class _$BumpPhotoCopyWith<$Res> implements $BumpPhotoCopyWith<$Res> {
  factory _$BumpPhotoCopyWith(_BumpPhoto value, $Res Function(_BumpPhoto) _then) = __$BumpPhotoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'pregnancyId') String pregnancyId,@JsonKey(name: 'week') int week,@JsonKey(name: 'asset') String? asset,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'takenAt') DateTime? takenAt
});




}
/// @nodoc
class __$BumpPhotoCopyWithImpl<$Res>
    implements _$BumpPhotoCopyWith<$Res> {
  __$BumpPhotoCopyWithImpl(this._self, this._then);

  final _BumpPhoto _self;
  final $Res Function(_BumpPhoto) _then;

/// Create a copy of BumpPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pregnancyId = null,Object? week = null,Object? asset = freezed,Object? memoryId = freezed,Object? takenAt = freezed,}) {
  return _then(_BumpPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pregnancyId: null == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String,week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as int,asset: freezed == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as String?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
