// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'timezone') String? get timezone;@JsonKey(name: 'contentLocale') String? get contentLocale;@JsonKey(name: 'coverUrl') String? get coverUrl;
/// Create a copy of FamilyRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyRecordCopyWith<FamilyRecord> get copyWith => _$FamilyRecordCopyWithImpl<FamilyRecord>(this as FamilyRecord, _$identity);

  /// Serializes this FamilyRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.contentLocale, contentLocale) || other.contentLocale == contentLocale)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,timezone,contentLocale,coverUrl);

@override
String toString() {
  return 'FamilyRecord(id: $id, name: $name, timezone: $timezone, contentLocale: $contentLocale, coverUrl: $coverUrl)';
}


}

/// @nodoc
abstract mixin class $FamilyRecordCopyWith<$Res>  {
  factory $FamilyRecordCopyWith(FamilyRecord value, $Res Function(FamilyRecord) _then) = _$FamilyRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'timezone') String? timezone,@JsonKey(name: 'contentLocale') String? contentLocale,@JsonKey(name: 'coverUrl') String? coverUrl
});




}
/// @nodoc
class _$FamilyRecordCopyWithImpl<$Res>
    implements $FamilyRecordCopyWith<$Res> {
  _$FamilyRecordCopyWithImpl(this._self, this._then);

  final FamilyRecord _self;
  final $Res Function(FamilyRecord) _then;

/// Create a copy of FamilyRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? timezone = freezed,Object? contentLocale = freezed,Object? coverUrl = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,contentLocale: freezed == contentLocale ? _self.contentLocale : contentLocale // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyRecord].
extension FamilyRecordPatterns on FamilyRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyRecord value)  $default,){
final _that = this;
switch (_that) {
case _FamilyRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyRecord value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FamilyRecord implements FamilyRecord {
  const _FamilyRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'name') this.name, @JsonKey(name: 'timezone') this.timezone, @JsonKey(name: 'contentLocale') this.contentLocale, @JsonKey(name: 'coverUrl') this.coverUrl});
  factory _FamilyRecord.fromJson(Map<String, dynamic> json) => _$FamilyRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'timezone') final  String? timezone;
@override@JsonKey(name: 'contentLocale') final  String? contentLocale;
@override@JsonKey(name: 'coverUrl') final  String? coverUrl;

/// Create a copy of FamilyRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyRecordCopyWith<_FamilyRecord> get copyWith => __$FamilyRecordCopyWithImpl<_FamilyRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.contentLocale, contentLocale) || other.contentLocale == contentLocale)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,timezone,contentLocale,coverUrl);

@override
String toString() {
  return 'FamilyRecord(id: $id, name: $name, timezone: $timezone, contentLocale: $contentLocale, coverUrl: $coverUrl)';
}


}

/// @nodoc
abstract mixin class _$FamilyRecordCopyWith<$Res> implements $FamilyRecordCopyWith<$Res> {
  factory _$FamilyRecordCopyWith(_FamilyRecord value, $Res Function(_FamilyRecord) _then) = __$FamilyRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'timezone') String? timezone,@JsonKey(name: 'contentLocale') String? contentLocale,@JsonKey(name: 'coverUrl') String? coverUrl
});




}
/// @nodoc
class __$FamilyRecordCopyWithImpl<$Res>
    implements _$FamilyRecordCopyWith<$Res> {
  __$FamilyRecordCopyWithImpl(this._self, this._then);

  final _FamilyRecord _self;
  final $Res Function(_FamilyRecord) _then;

/// Create a copy of FamilyRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? timezone = freezed,Object? contentLocale = freezed,Object? coverUrl = freezed,}) {
  return _then(_FamilyRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,contentLocale: freezed == contentLocale ? _self.contentLocale : contentLocale // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
