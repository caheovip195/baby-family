// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_export_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DataExportRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'scope') String? get scope;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'completedAt') DateTime? get completedAt;@JsonKey(name: 'expiresAt') DateTime? get expiresAt;@JsonKey(name: 'errorCode') String? get errorCode;@JsonKey(name: 'download') ExportDownloadRecord? get download;
/// Create a copy of DataExportRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataExportRecordCopyWith<DataExportRecord> get copyWith => _$DataExportRecordCopyWithImpl<DataExportRecord>(this as DataExportRecord, _$identity);

  /// Serializes this DataExportRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataExportRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.download, download) || other.download == download));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scope,status,createdAt,completedAt,expiresAt,errorCode,download);

@override
String toString() {
  return 'DataExportRecord(id: $id, scope: $scope, status: $status, createdAt: $createdAt, completedAt: $completedAt, expiresAt: $expiresAt, errorCode: $errorCode, download: $download)';
}


}

/// @nodoc
abstract mixin class $DataExportRecordCopyWith<$Res>  {
  factory $DataExportRecordCopyWith(DataExportRecord value, $Res Function(DataExportRecord) _then) = _$DataExportRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'scope') String? scope,@JsonKey(name: 'status') String? status,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'completedAt') DateTime? completedAt,@JsonKey(name: 'expiresAt') DateTime? expiresAt,@JsonKey(name: 'errorCode') String? errorCode,@JsonKey(name: 'download') ExportDownloadRecord? download
});


$ExportDownloadRecordCopyWith<$Res>? get download;

}
/// @nodoc
class _$DataExportRecordCopyWithImpl<$Res>
    implements $DataExportRecordCopyWith<$Res> {
  _$DataExportRecordCopyWithImpl(this._self, this._then);

  final DataExportRecord _self;
  final $Res Function(DataExportRecord) _then;

/// Create a copy of DataExportRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? scope = freezed,Object? status = freezed,Object? createdAt = freezed,Object? completedAt = freezed,Object? expiresAt = freezed,Object? errorCode = freezed,Object? download = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,download: freezed == download ? _self.download : download // ignore: cast_nullable_to_non_nullable
as ExportDownloadRecord?,
  ));
}
/// Create a copy of DataExportRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExportDownloadRecordCopyWith<$Res>? get download {
    if (_self.download == null) {
    return null;
  }

  return $ExportDownloadRecordCopyWith<$Res>(_self.download!, (value) {
    return _then(_self.copyWith(download: value));
  });
}
}


/// Adds pattern-matching-related methods to [DataExportRecord].
extension DataExportRecordPatterns on DataExportRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DataExportRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DataExportRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DataExportRecord value)  $default,){
final _that = this;
switch (_that) {
case _DataExportRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DataExportRecord value)?  $default,){
final _that = this;
switch (_that) {
case _DataExportRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DataExportRecord implements DataExportRecord {
  const _DataExportRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'scope') this.scope, @JsonKey(name: 'status') this.status, @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'completedAt') this.completedAt, @JsonKey(name: 'expiresAt') this.expiresAt, @JsonKey(name: 'errorCode') this.errorCode, @JsonKey(name: 'download') this.download});
  factory _DataExportRecord.fromJson(Map<String, dynamic> json) => _$DataExportRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'scope') final  String? scope;
@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
@override@JsonKey(name: 'completedAt') final  DateTime? completedAt;
@override@JsonKey(name: 'expiresAt') final  DateTime? expiresAt;
@override@JsonKey(name: 'errorCode') final  String? errorCode;
@override@JsonKey(name: 'download') final  ExportDownloadRecord? download;

/// Create a copy of DataExportRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataExportRecordCopyWith<_DataExportRecord> get copyWith => __$DataExportRecordCopyWithImpl<_DataExportRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DataExportRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataExportRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.download, download) || other.download == download));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scope,status,createdAt,completedAt,expiresAt,errorCode,download);

@override
String toString() {
  return 'DataExportRecord(id: $id, scope: $scope, status: $status, createdAt: $createdAt, completedAt: $completedAt, expiresAt: $expiresAt, errorCode: $errorCode, download: $download)';
}


}

/// @nodoc
abstract mixin class _$DataExportRecordCopyWith<$Res> implements $DataExportRecordCopyWith<$Res> {
  factory _$DataExportRecordCopyWith(_DataExportRecord value, $Res Function(_DataExportRecord) _then) = __$DataExportRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'scope') String? scope,@JsonKey(name: 'status') String? status,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'completedAt') DateTime? completedAt,@JsonKey(name: 'expiresAt') DateTime? expiresAt,@JsonKey(name: 'errorCode') String? errorCode,@JsonKey(name: 'download') ExportDownloadRecord? download
});


@override $ExportDownloadRecordCopyWith<$Res>? get download;

}
/// @nodoc
class __$DataExportRecordCopyWithImpl<$Res>
    implements _$DataExportRecordCopyWith<$Res> {
  __$DataExportRecordCopyWithImpl(this._self, this._then);

  final _DataExportRecord _self;
  final $Res Function(_DataExportRecord) _then;

/// Create a copy of DataExportRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? scope = freezed,Object? status = freezed,Object? createdAt = freezed,Object? completedAt = freezed,Object? expiresAt = freezed,Object? errorCode = freezed,Object? download = freezed,}) {
  return _then(_DataExportRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,download: freezed == download ? _self.download : download // ignore: cast_nullable_to_non_nullable
as ExportDownloadRecord?,
  ));
}

/// Create a copy of DataExportRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExportDownloadRecordCopyWith<$Res>? get download {
    if (_self.download == null) {
    return null;
  }

  return $ExportDownloadRecordCopyWith<$Res>(_self.download!, (value) {
    return _then(_self.copyWith(download: value));
  });
}
}

// dart format on
