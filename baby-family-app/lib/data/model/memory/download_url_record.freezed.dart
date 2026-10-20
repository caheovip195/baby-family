// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_url_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DownloadUrlRecord {

@JsonKey(name: 'assetId') String? get assetId;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'url') String? get url;@JsonKey(name: 'fileName') String? get fileName;
/// Create a copy of DownloadUrlRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadUrlRecordCopyWith<DownloadUrlRecord> get copyWith => _$DownloadUrlRecordCopyWithImpl<DownloadUrlRecord>(this as DownloadUrlRecord, _$identity);

  /// Serializes this DownloadUrlRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadUrlRecord&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.url, url) || other.url == url)&&(identical(other.fileName, fileName) || other.fileName == fileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,kind,url,fileName);

@override
String toString() {
  return 'DownloadUrlRecord(assetId: $assetId, kind: $kind, url: $url, fileName: $fileName)';
}


}

/// @nodoc
abstract mixin class $DownloadUrlRecordCopyWith<$Res>  {
  factory $DownloadUrlRecordCopyWith(DownloadUrlRecord value, $Res Function(DownloadUrlRecord) _then) = _$DownloadUrlRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'assetId') String? assetId,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'url') String? url,@JsonKey(name: 'fileName') String? fileName
});




}
/// @nodoc
class _$DownloadUrlRecordCopyWithImpl<$Res>
    implements $DownloadUrlRecordCopyWith<$Res> {
  _$DownloadUrlRecordCopyWithImpl(this._self, this._then);

  final DownloadUrlRecord _self;
  final $Res Function(DownloadUrlRecord) _then;

/// Create a copy of DownloadUrlRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetId = freezed,Object? kind = freezed,Object? url = freezed,Object? fileName = freezed,}) {
  return _then(_self.copyWith(
assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadUrlRecord].
extension DownloadUrlRecordPatterns on DownloadUrlRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadUrlRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadUrlRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadUrlRecord value)  $default,){
final _that = this;
switch (_that) {
case _DownloadUrlRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadUrlRecord value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadUrlRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DownloadUrlRecord implements DownloadUrlRecord {
  const _DownloadUrlRecord({@JsonKey(name: 'assetId') this.assetId, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'url') this.url, @JsonKey(name: 'fileName') this.fileName});
  factory _DownloadUrlRecord.fromJson(Map<String, dynamic> json) => _$DownloadUrlRecordFromJson(json);

@override@JsonKey(name: 'assetId') final  String? assetId;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'url') final  String? url;
@override@JsonKey(name: 'fileName') final  String? fileName;

/// Create a copy of DownloadUrlRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadUrlRecordCopyWith<_DownloadUrlRecord> get copyWith => __$DownloadUrlRecordCopyWithImpl<_DownloadUrlRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DownloadUrlRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadUrlRecord&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.url, url) || other.url == url)&&(identical(other.fileName, fileName) || other.fileName == fileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,kind,url,fileName);

@override
String toString() {
  return 'DownloadUrlRecord(assetId: $assetId, kind: $kind, url: $url, fileName: $fileName)';
}


}

/// @nodoc
abstract mixin class _$DownloadUrlRecordCopyWith<$Res> implements $DownloadUrlRecordCopyWith<$Res> {
  factory _$DownloadUrlRecordCopyWith(_DownloadUrlRecord value, $Res Function(_DownloadUrlRecord) _then) = __$DownloadUrlRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'assetId') String? assetId,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'url') String? url,@JsonKey(name: 'fileName') String? fileName
});




}
/// @nodoc
class __$DownloadUrlRecordCopyWithImpl<$Res>
    implements _$DownloadUrlRecordCopyWith<$Res> {
  __$DownloadUrlRecordCopyWithImpl(this._self, this._then);

  final _DownloadUrlRecord _self;
  final $Res Function(_DownloadUrlRecord) _then;

/// Create a copy of DownloadUrlRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = freezed,Object? kind = freezed,Object? url = freezed,Object? fileName = freezed,}) {
  return _then(_DownloadUrlRecord(
assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
