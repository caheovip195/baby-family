// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyPhoto {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'childId') String get childId;@JsonKey(name: 'monthIndex') int get monthIndex;@JsonKey(name: 'memoryId') String? get memoryId;@JsonKey(name: 'asset') String? get asset;@JsonKey(name: 'takenAt') DateTime? get takenAt;
/// Create a copy of MonthlyPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyPhotoCopyWith<MonthlyPhoto> get copyWith => _$MonthlyPhotoCopyWithImpl<MonthlyPhoto>(this as MonthlyPhoto, _$identity);

  /// Serializes this MonthlyPhoto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.asset, asset) || other.asset == asset)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,childId,monthIndex,memoryId,asset,takenAt);

@override
String toString() {
  return 'MonthlyPhoto(id: $id, childId: $childId, monthIndex: $monthIndex, memoryId: $memoryId, asset: $asset, takenAt: $takenAt)';
}


}

/// @nodoc
abstract mixin class $MonthlyPhotoCopyWith<$Res>  {
  factory $MonthlyPhotoCopyWith(MonthlyPhoto value, $Res Function(MonthlyPhoto) _then) = _$MonthlyPhotoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'childId') String childId,@JsonKey(name: 'monthIndex') int monthIndex,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'asset') String? asset,@JsonKey(name: 'takenAt') DateTime? takenAt
});




}
/// @nodoc
class _$MonthlyPhotoCopyWithImpl<$Res>
    implements $MonthlyPhotoCopyWith<$Res> {
  _$MonthlyPhotoCopyWithImpl(this._self, this._then);

  final MonthlyPhoto _self;
  final $Res Function(MonthlyPhoto) _then;

/// Create a copy of MonthlyPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? childId = null,Object? monthIndex = null,Object? memoryId = freezed,Object? asset = freezed,Object? takenAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,monthIndex: null == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,asset: freezed == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as String?,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyPhoto].
extension MonthlyPhotoPatterns on MonthlyPhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyPhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyPhoto value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyPhoto() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MonthlyPhoto implements MonthlyPhoto {
  const _MonthlyPhoto({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'childId') required this.childId, @JsonKey(name: 'monthIndex') required this.monthIndex, @JsonKey(name: 'memoryId') this.memoryId, @JsonKey(name: 'asset') this.asset, @JsonKey(name: 'takenAt') this.takenAt});
  factory _MonthlyPhoto.fromJson(Map<String, dynamic> json) => _$MonthlyPhotoFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'childId') final  String childId;
@override@JsonKey(name: 'monthIndex') final  int monthIndex;
@override@JsonKey(name: 'memoryId') final  String? memoryId;
@override@JsonKey(name: 'asset') final  String? asset;
@override@JsonKey(name: 'takenAt') final  DateTime? takenAt;

/// Create a copy of MonthlyPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyPhotoCopyWith<_MonthlyPhoto> get copyWith => __$MonthlyPhotoCopyWithImpl<_MonthlyPhoto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyPhotoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.asset, asset) || other.asset == asset)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,childId,monthIndex,memoryId,asset,takenAt);

@override
String toString() {
  return 'MonthlyPhoto(id: $id, childId: $childId, monthIndex: $monthIndex, memoryId: $memoryId, asset: $asset, takenAt: $takenAt)';
}


}

/// @nodoc
abstract mixin class _$MonthlyPhotoCopyWith<$Res> implements $MonthlyPhotoCopyWith<$Res> {
  factory _$MonthlyPhotoCopyWith(_MonthlyPhoto value, $Res Function(_MonthlyPhoto) _then) = __$MonthlyPhotoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'childId') String childId,@JsonKey(name: 'monthIndex') int monthIndex,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'asset') String? asset,@JsonKey(name: 'takenAt') DateTime? takenAt
});




}
/// @nodoc
class __$MonthlyPhotoCopyWithImpl<$Res>
    implements _$MonthlyPhotoCopyWith<$Res> {
  __$MonthlyPhotoCopyWithImpl(this._self, this._then);

  final _MonthlyPhoto _self;
  final $Res Function(_MonthlyPhoto) _then;

/// Create a copy of MonthlyPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? childId = null,Object? monthIndex = null,Object? memoryId = freezed,Object? asset = freezed,Object? takenAt = freezed,}) {
  return _then(_MonthlyPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,monthIndex: null == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,asset: freezed == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as String?,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
