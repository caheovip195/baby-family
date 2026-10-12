// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_export_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DataExportInfo {

@JsonKey(name: 'jobs') List<DataExportJob> get jobs;@JsonKey(name: 'cacheMb') int get cacheMb;
/// Create a copy of DataExportInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataExportInfoCopyWith<DataExportInfo> get copyWith => _$DataExportInfoCopyWithImpl<DataExportInfo>(this as DataExportInfo, _$identity);

  /// Serializes this DataExportInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataExportInfo&&const DeepCollectionEquality().equals(other.jobs, jobs)&&(identical(other.cacheMb, cacheMb) || other.cacheMb == cacheMb));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(jobs),cacheMb);

@override
String toString() {
  return 'DataExportInfo(jobs: $jobs, cacheMb: $cacheMb)';
}


}

/// @nodoc
abstract mixin class $DataExportInfoCopyWith<$Res>  {
  factory $DataExportInfoCopyWith(DataExportInfo value, $Res Function(DataExportInfo) _then) = _$DataExportInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'jobs') List<DataExportJob> jobs,@JsonKey(name: 'cacheMb') int cacheMb
});




}
/// @nodoc
class _$DataExportInfoCopyWithImpl<$Res>
    implements $DataExportInfoCopyWith<$Res> {
  _$DataExportInfoCopyWithImpl(this._self, this._then);

  final DataExportInfo _self;
  final $Res Function(DataExportInfo) _then;

/// Create a copy of DataExportInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobs = null,Object? cacheMb = null,}) {
  return _then(_self.copyWith(
jobs: null == jobs ? _self.jobs : jobs // ignore: cast_nullable_to_non_nullable
as List<DataExportJob>,cacheMb: null == cacheMb ? _self.cacheMb : cacheMb // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DataExportInfo].
extension DataExportInfoPatterns on DataExportInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DataExportInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DataExportInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DataExportInfo value)  $default,){
final _that = this;
switch (_that) {
case _DataExportInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DataExportInfo value)?  $default,){
final _that = this;
switch (_that) {
case _DataExportInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DataExportInfo implements DataExportInfo {
  const _DataExportInfo({@JsonKey(name: 'jobs') final  List<DataExportJob> jobs = const [], @JsonKey(name: 'cacheMb') this.cacheMb = 0}): _jobs = jobs;
  factory _DataExportInfo.fromJson(Map<String, dynamic> json) => _$DataExportInfoFromJson(json);

 final  List<DataExportJob> _jobs;
@override@JsonKey(name: 'jobs') List<DataExportJob> get jobs {
  if (_jobs is EqualUnmodifiableListView) return _jobs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_jobs);
}

@override@JsonKey(name: 'cacheMb') final  int cacheMb;

/// Create a copy of DataExportInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataExportInfoCopyWith<_DataExportInfo> get copyWith => __$DataExportInfoCopyWithImpl<_DataExportInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DataExportInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataExportInfo&&const DeepCollectionEquality().equals(other._jobs, _jobs)&&(identical(other.cacheMb, cacheMb) || other.cacheMb == cacheMb));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_jobs),cacheMb);

@override
String toString() {
  return 'DataExportInfo(jobs: $jobs, cacheMb: $cacheMb)';
}


}

/// @nodoc
abstract mixin class _$DataExportInfoCopyWith<$Res> implements $DataExportInfoCopyWith<$Res> {
  factory _$DataExportInfoCopyWith(_DataExportInfo value, $Res Function(_DataExportInfo) _then) = __$DataExportInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'jobs') List<DataExportJob> jobs,@JsonKey(name: 'cacheMb') int cacheMb
});




}
/// @nodoc
class __$DataExportInfoCopyWithImpl<$Res>
    implements _$DataExportInfoCopyWith<$Res> {
  __$DataExportInfoCopyWithImpl(this._self, this._then);

  final _DataExportInfo _self;
  final $Res Function(_DataExportInfo) _then;

/// Create a copy of DataExportInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobs = null,Object? cacheMb = null,}) {
  return _then(_DataExportInfo(
jobs: null == jobs ? _self._jobs : jobs // ignore: cast_nullable_to_non_nullable
as List<DataExportJob>,cacheMb: null == cacheMb ? _self.cacheMb : cacheMb // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
