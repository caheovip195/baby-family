// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_download_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExportDownloadRecord {

@JsonKey(name: 'url') String? get url;@JsonKey(name: 'expiresAt') DateTime? get expiresAt;
/// Create a copy of ExportDownloadRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportDownloadRecordCopyWith<ExportDownloadRecord> get copyWith => _$ExportDownloadRecordCopyWithImpl<ExportDownloadRecord>(this as ExportDownloadRecord, _$identity);

  /// Serializes this ExportDownloadRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportDownloadRecord&&(identical(other.url, url) || other.url == url)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,expiresAt);

@override
String toString() {
  return 'ExportDownloadRecord(url: $url, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $ExportDownloadRecordCopyWith<$Res>  {
  factory $ExportDownloadRecordCopyWith(ExportDownloadRecord value, $Res Function(ExportDownloadRecord) _then) = _$ExportDownloadRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'url') String? url,@JsonKey(name: 'expiresAt') DateTime? expiresAt
});




}
/// @nodoc
class _$ExportDownloadRecordCopyWithImpl<$Res>
    implements $ExportDownloadRecordCopyWith<$Res> {
  _$ExportDownloadRecordCopyWithImpl(this._self, this._then);

  final ExportDownloadRecord _self;
  final $Res Function(ExportDownloadRecord) _then;

/// Create a copy of ExportDownloadRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = freezed,Object? expiresAt = freezed,}) {
  return _then(_self.copyWith(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportDownloadRecord].
extension ExportDownloadRecordPatterns on ExportDownloadRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportDownloadRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportDownloadRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportDownloadRecord value)  $default,){
final _that = this;
switch (_that) {
case _ExportDownloadRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportDownloadRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ExportDownloadRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ExportDownloadRecord implements ExportDownloadRecord {
  const _ExportDownloadRecord({@JsonKey(name: 'url') this.url, @JsonKey(name: 'expiresAt') this.expiresAt});
  factory _ExportDownloadRecord.fromJson(Map<String, dynamic> json) => _$ExportDownloadRecordFromJson(json);

@override@JsonKey(name: 'url') final  String? url;
@override@JsonKey(name: 'expiresAt') final  DateTime? expiresAt;

/// Create a copy of ExportDownloadRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportDownloadRecordCopyWith<_ExportDownloadRecord> get copyWith => __$ExportDownloadRecordCopyWithImpl<_ExportDownloadRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExportDownloadRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportDownloadRecord&&(identical(other.url, url) || other.url == url)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,expiresAt);

@override
String toString() {
  return 'ExportDownloadRecord(url: $url, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$ExportDownloadRecordCopyWith<$Res> implements $ExportDownloadRecordCopyWith<$Res> {
  factory _$ExportDownloadRecordCopyWith(_ExportDownloadRecord value, $Res Function(_ExportDownloadRecord) _then) = __$ExportDownloadRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'url') String? url,@JsonKey(name: 'expiresAt') DateTime? expiresAt
});




}
/// @nodoc
class __$ExportDownloadRecordCopyWithImpl<$Res>
    implements _$ExportDownloadRecordCopyWith<$Res> {
  __$ExportDownloadRecordCopyWithImpl(this._self, this._then);

  final _ExportDownloadRecord _self;
  final $Res Function(_ExportDownloadRecord) _then;

/// Create a copy of ExportDownloadRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = freezed,Object? expiresAt = freezed,}) {
  return _then(_ExportDownloadRecord(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
