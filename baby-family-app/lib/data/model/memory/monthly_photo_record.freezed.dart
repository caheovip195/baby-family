// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_photo_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyPhotoRecord {

@JsonKey(name: 'monthIndex') int? get monthIndex;@JsonKey(name: 'memoryId') String? get memoryId;@JsonKey(name: 'url') String? get url;@JsonKey(name: 'occurredAt') DateTime? get occurredAt;
/// Create a copy of MonthlyPhotoRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyPhotoRecordCopyWith<MonthlyPhotoRecord> get copyWith => _$MonthlyPhotoRecordCopyWithImpl<MonthlyPhotoRecord>(this as MonthlyPhotoRecord, _$identity);

  /// Serializes this MonthlyPhotoRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyPhotoRecord&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.url, url) || other.url == url)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monthIndex,memoryId,url,occurredAt);

@override
String toString() {
  return 'MonthlyPhotoRecord(monthIndex: $monthIndex, memoryId: $memoryId, url: $url, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class $MonthlyPhotoRecordCopyWith<$Res>  {
  factory $MonthlyPhotoRecordCopyWith(MonthlyPhotoRecord value, $Res Function(MonthlyPhotoRecord) _then) = _$MonthlyPhotoRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'monthIndex') int? monthIndex,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'url') String? url,@JsonKey(name: 'occurredAt') DateTime? occurredAt
});




}
/// @nodoc
class _$MonthlyPhotoRecordCopyWithImpl<$Res>
    implements $MonthlyPhotoRecordCopyWith<$Res> {
  _$MonthlyPhotoRecordCopyWithImpl(this._self, this._then);

  final MonthlyPhotoRecord _self;
  final $Res Function(MonthlyPhotoRecord) _then;

/// Create a copy of MonthlyPhotoRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monthIndex = freezed,Object? memoryId = freezed,Object? url = freezed,Object? occurredAt = freezed,}) {
  return _then(_self.copyWith(
monthIndex: freezed == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: freezed == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyPhotoRecord].
extension MonthlyPhotoRecordPatterns on MonthlyPhotoRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyPhotoRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyPhotoRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyPhotoRecord value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyPhotoRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyPhotoRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyPhotoRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MonthlyPhotoRecord implements MonthlyPhotoRecord {
  const _MonthlyPhotoRecord({@JsonKey(name: 'monthIndex') this.monthIndex, @JsonKey(name: 'memoryId') this.memoryId, @JsonKey(name: 'url') this.url, @JsonKey(name: 'occurredAt') this.occurredAt});
  factory _MonthlyPhotoRecord.fromJson(Map<String, dynamic> json) => _$MonthlyPhotoRecordFromJson(json);

@override@JsonKey(name: 'monthIndex') final  int? monthIndex;
@override@JsonKey(name: 'memoryId') final  String? memoryId;
@override@JsonKey(name: 'url') final  String? url;
@override@JsonKey(name: 'occurredAt') final  DateTime? occurredAt;

/// Create a copy of MonthlyPhotoRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyPhotoRecordCopyWith<_MonthlyPhotoRecord> get copyWith => __$MonthlyPhotoRecordCopyWithImpl<_MonthlyPhotoRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyPhotoRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyPhotoRecord&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.url, url) || other.url == url)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monthIndex,memoryId,url,occurredAt);

@override
String toString() {
  return 'MonthlyPhotoRecord(monthIndex: $monthIndex, memoryId: $memoryId, url: $url, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class _$MonthlyPhotoRecordCopyWith<$Res> implements $MonthlyPhotoRecordCopyWith<$Res> {
  factory _$MonthlyPhotoRecordCopyWith(_MonthlyPhotoRecord value, $Res Function(_MonthlyPhotoRecord) _then) = __$MonthlyPhotoRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'monthIndex') int? monthIndex,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'url') String? url,@JsonKey(name: 'occurredAt') DateTime? occurredAt
});




}
/// @nodoc
class __$MonthlyPhotoRecordCopyWithImpl<$Res>
    implements _$MonthlyPhotoRecordCopyWith<$Res> {
  __$MonthlyPhotoRecordCopyWithImpl(this._self, this._then);

  final _MonthlyPhotoRecord _self;
  final $Res Function(_MonthlyPhotoRecord) _then;

/// Create a copy of MonthlyPhotoRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monthIndex = freezed,Object? memoryId = freezed,Object? url = freezed,Object? occurredAt = freezed,}) {
  return _then(_MonthlyPhotoRecord(
monthIndex: freezed == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: freezed == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
