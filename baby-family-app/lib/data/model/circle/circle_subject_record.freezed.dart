// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circle_subject_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CircleSubjectRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'permission') String? get permission;@JsonKey(name: 'allowDownload') bool? get allowDownload;
/// Create a copy of CircleSubjectRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleSubjectRecordCopyWith<CircleSubjectRecord> get copyWith => _$CircleSubjectRecordCopyWithImpl<CircleSubjectRecord>(this as CircleSubjectRecord, _$identity);

  /// Serializes this CircleSubjectRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleSubjectRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.allowDownload, allowDownload) || other.allowDownload == allowDownload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,kind,permission,allowDownload);

@override
String toString() {
  return 'CircleSubjectRecord(id: $id, name: $name, kind: $kind, permission: $permission, allowDownload: $allowDownload)';
}


}

/// @nodoc
abstract mixin class $CircleSubjectRecordCopyWith<$Res>  {
  factory $CircleSubjectRecordCopyWith(CircleSubjectRecord value, $Res Function(CircleSubjectRecord) _then) = _$CircleSubjectRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'permission') String? permission,@JsonKey(name: 'allowDownload') bool? allowDownload
});




}
/// @nodoc
class _$CircleSubjectRecordCopyWithImpl<$Res>
    implements $CircleSubjectRecordCopyWith<$Res> {
  _$CircleSubjectRecordCopyWithImpl(this._self, this._then);

  final CircleSubjectRecord _self;
  final $Res Function(CircleSubjectRecord) _then;

/// Create a copy of CircleSubjectRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? kind = freezed,Object? permission = freezed,Object? allowDownload = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,permission: freezed == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as String?,allowDownload: freezed == allowDownload ? _self.allowDownload : allowDownload // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [CircleSubjectRecord].
extension CircleSubjectRecordPatterns on CircleSubjectRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircleSubjectRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircleSubjectRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircleSubjectRecord value)  $default,){
final _that = this;
switch (_that) {
case _CircleSubjectRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircleSubjectRecord value)?  $default,){
final _that = this;
switch (_that) {
case _CircleSubjectRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CircleSubjectRecord implements CircleSubjectRecord {
  const _CircleSubjectRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'name') this.name, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'permission') this.permission, @JsonKey(name: 'allowDownload') this.allowDownload});
  factory _CircleSubjectRecord.fromJson(Map<String, dynamic> json) => _$CircleSubjectRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'permission') final  String? permission;
@override@JsonKey(name: 'allowDownload') final  bool? allowDownload;

/// Create a copy of CircleSubjectRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircleSubjectRecordCopyWith<_CircleSubjectRecord> get copyWith => __$CircleSubjectRecordCopyWithImpl<_CircleSubjectRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircleSubjectRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircleSubjectRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.allowDownload, allowDownload) || other.allowDownload == allowDownload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,kind,permission,allowDownload);

@override
String toString() {
  return 'CircleSubjectRecord(id: $id, name: $name, kind: $kind, permission: $permission, allowDownload: $allowDownload)';
}


}

/// @nodoc
abstract mixin class _$CircleSubjectRecordCopyWith<$Res> implements $CircleSubjectRecordCopyWith<$Res> {
  factory _$CircleSubjectRecordCopyWith(_CircleSubjectRecord value, $Res Function(_CircleSubjectRecord) _then) = __$CircleSubjectRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'permission') String? permission,@JsonKey(name: 'allowDownload') bool? allowDownload
});




}
/// @nodoc
class __$CircleSubjectRecordCopyWithImpl<$Res>
    implements _$CircleSubjectRecordCopyWith<$Res> {
  __$CircleSubjectRecordCopyWithImpl(this._self, this._then);

  final _CircleSubjectRecord _self;
  final $Res Function(_CircleSubjectRecord) _then;

/// Create a copy of CircleSubjectRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? kind = freezed,Object? permission = freezed,Object? allowDownload = freezed,}) {
  return _then(_CircleSubjectRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,permission: freezed == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as String?,allowDownload: freezed == allowDownload ? _self.allowDownload : allowDownload // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
