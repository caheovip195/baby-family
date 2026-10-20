// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_export_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DataExportJob {

@JsonKey(name: 'kind') DataExportKind get kind;@JsonKey(name: 'status') DataExportStatus get status;@JsonKey(name: 'progress') int get progress;@JsonKey(name: 'startedAt') DateTime? get startedAt;@JsonKey(name: 'sizeMb') int? get sizeMb;@JsonKey(name: 'expiresAt') DateTime? get expiresAt;/// Id job xuất trên server (bản thật) — để hỏi lại trạng thái/link tải.
@JsonKey(name: 'exportId') String? get exportId;
/// Create a copy of DataExportJob
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataExportJobCopyWith<DataExportJob> get copyWith => _$DataExportJobCopyWithImpl<DataExportJob>(this as DataExportJob, _$identity);

  /// Serializes this DataExportJob to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataExportJob&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.sizeMb, sizeMb) || other.sizeMb == sizeMb)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.exportId, exportId) || other.exportId == exportId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,status,progress,startedAt,sizeMb,expiresAt,exportId);

@override
String toString() {
  return 'DataExportJob(kind: $kind, status: $status, progress: $progress, startedAt: $startedAt, sizeMb: $sizeMb, expiresAt: $expiresAt, exportId: $exportId)';
}


}

/// @nodoc
abstract mixin class $DataExportJobCopyWith<$Res>  {
  factory $DataExportJobCopyWith(DataExportJob value, $Res Function(DataExportJob) _then) = _$DataExportJobCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'kind') DataExportKind kind,@JsonKey(name: 'status') DataExportStatus status,@JsonKey(name: 'progress') int progress,@JsonKey(name: 'startedAt') DateTime? startedAt,@JsonKey(name: 'sizeMb') int? sizeMb,@JsonKey(name: 'expiresAt') DateTime? expiresAt,@JsonKey(name: 'exportId') String? exportId
});




}
/// @nodoc
class _$DataExportJobCopyWithImpl<$Res>
    implements $DataExportJobCopyWith<$Res> {
  _$DataExportJobCopyWithImpl(this._self, this._then);

  final DataExportJob _self;
  final $Res Function(DataExportJob) _then;

/// Create a copy of DataExportJob
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? status = null,Object? progress = null,Object? startedAt = freezed,Object? sizeMb = freezed,Object? expiresAt = freezed,Object? exportId = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DataExportKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DataExportStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sizeMb: freezed == sizeMb ? _self.sizeMb : sizeMb // ignore: cast_nullable_to_non_nullable
as int?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,exportId: freezed == exportId ? _self.exportId : exportId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DataExportJob].
extension DataExportJobPatterns on DataExportJob {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DataExportJob value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DataExportJob() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DataExportJob value)  $default,){
final _that = this;
switch (_that) {
case _DataExportJob():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DataExportJob value)?  $default,){
final _that = this;
switch (_that) {
case _DataExportJob() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DataExportJob implements DataExportJob {
  const _DataExportJob({@JsonKey(name: 'kind') required this.kind, @JsonKey(name: 'status') this.status = DataExportStatus.idle, @JsonKey(name: 'progress') this.progress = 0, @JsonKey(name: 'startedAt') this.startedAt, @JsonKey(name: 'sizeMb') this.sizeMb, @JsonKey(name: 'expiresAt') this.expiresAt, @JsonKey(name: 'exportId') this.exportId});
  factory _DataExportJob.fromJson(Map<String, dynamic> json) => _$DataExportJobFromJson(json);

@override@JsonKey(name: 'kind') final  DataExportKind kind;
@override@JsonKey(name: 'status') final  DataExportStatus status;
@override@JsonKey(name: 'progress') final  int progress;
@override@JsonKey(name: 'startedAt') final  DateTime? startedAt;
@override@JsonKey(name: 'sizeMb') final  int? sizeMb;
@override@JsonKey(name: 'expiresAt') final  DateTime? expiresAt;
/// Id job xuất trên server (bản thật) — để hỏi lại trạng thái/link tải.
@override@JsonKey(name: 'exportId') final  String? exportId;

/// Create a copy of DataExportJob
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataExportJobCopyWith<_DataExportJob> get copyWith => __$DataExportJobCopyWithImpl<_DataExportJob>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DataExportJobToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataExportJob&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.sizeMb, sizeMb) || other.sizeMb == sizeMb)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.exportId, exportId) || other.exportId == exportId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,status,progress,startedAt,sizeMb,expiresAt,exportId);

@override
String toString() {
  return 'DataExportJob(kind: $kind, status: $status, progress: $progress, startedAt: $startedAt, sizeMb: $sizeMb, expiresAt: $expiresAt, exportId: $exportId)';
}


}

/// @nodoc
abstract mixin class _$DataExportJobCopyWith<$Res> implements $DataExportJobCopyWith<$Res> {
  factory _$DataExportJobCopyWith(_DataExportJob value, $Res Function(_DataExportJob) _then) = __$DataExportJobCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'kind') DataExportKind kind,@JsonKey(name: 'status') DataExportStatus status,@JsonKey(name: 'progress') int progress,@JsonKey(name: 'startedAt') DateTime? startedAt,@JsonKey(name: 'sizeMb') int? sizeMb,@JsonKey(name: 'expiresAt') DateTime? expiresAt,@JsonKey(name: 'exportId') String? exportId
});




}
/// @nodoc
class __$DataExportJobCopyWithImpl<$Res>
    implements _$DataExportJobCopyWith<$Res> {
  __$DataExportJobCopyWithImpl(this._self, this._then);

  final _DataExportJob _self;
  final $Res Function(_DataExportJob) _then;

/// Create a copy of DataExportJob
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? status = null,Object? progress = null,Object? startedAt = freezed,Object? sizeMb = freezed,Object? expiresAt = freezed,Object? exportId = freezed,}) {
  return _then(_DataExportJob(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DataExportKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DataExportStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sizeMb: freezed == sizeMb ? _self.sizeMb : sizeMb // ignore: cast_nullable_to_non_nullable
as int?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,exportId: freezed == exportId ? _self.exportId : exportId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
