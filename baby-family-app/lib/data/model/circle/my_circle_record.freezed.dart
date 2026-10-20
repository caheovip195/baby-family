// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_circle_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyCircleRecord {

@JsonKey(name: 'familyId') String? get familyId;@JsonKey(name: 'familyName') String? get familyName;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'children') List<CircleSubjectRecord> get children;@JsonKey(name: 'allowDownload') bool get allowDownload;
/// Create a copy of MyCircleRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyCircleRecordCopyWith<MyCircleRecord> get copyWith => _$MyCircleRecordCopyWithImpl<MyCircleRecord>(this as MyCircleRecord, _$identity);

  /// Serializes this MyCircleRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyCircleRecord&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.children, children)&&(identical(other.allowDownload, allowDownload) || other.allowDownload == allowDownload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,familyName,status,const DeepCollectionEquality().hash(children),allowDownload);

@override
String toString() {
  return 'MyCircleRecord(familyId: $familyId, familyName: $familyName, status: $status, children: $children, allowDownload: $allowDownload)';
}


}

/// @nodoc
abstract mixin class $MyCircleRecordCopyWith<$Res>  {
  factory $MyCircleRecordCopyWith(MyCircleRecord value, $Res Function(MyCircleRecord) _then) = _$MyCircleRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'familyName') String? familyName,@JsonKey(name: 'status') String? status,@JsonKey(name: 'children') List<CircleSubjectRecord> children,@JsonKey(name: 'allowDownload') bool allowDownload
});




}
/// @nodoc
class _$MyCircleRecordCopyWithImpl<$Res>
    implements $MyCircleRecordCopyWith<$Res> {
  _$MyCircleRecordCopyWithImpl(this._self, this._then);

  final MyCircleRecord _self;
  final $Res Function(MyCircleRecord) _then;

/// Create a copy of MyCircleRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? familyId = freezed,Object? familyName = freezed,Object? status = freezed,Object? children = null,Object? allowDownload = null,}) {
  return _then(_self.copyWith(
familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,familyName: freezed == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<CircleSubjectRecord>,allowDownload: null == allowDownload ? _self.allowDownload : allowDownload // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MyCircleRecord].
extension MyCircleRecordPatterns on MyCircleRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyCircleRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyCircleRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyCircleRecord value)  $default,){
final _that = this;
switch (_that) {
case _MyCircleRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyCircleRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MyCircleRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MyCircleRecord implements MyCircleRecord {
  const _MyCircleRecord({@JsonKey(name: 'familyId') this.familyId, @JsonKey(name: 'familyName') this.familyName, @JsonKey(name: 'status') this.status, @JsonKey(name: 'children') final  List<CircleSubjectRecord> children = const <CircleSubjectRecord>[], @JsonKey(name: 'allowDownload') this.allowDownload = false}): _children = children;
  factory _MyCircleRecord.fromJson(Map<String, dynamic> json) => _$MyCircleRecordFromJson(json);

@override@JsonKey(name: 'familyId') final  String? familyId;
@override@JsonKey(name: 'familyName') final  String? familyName;
@override@JsonKey(name: 'status') final  String? status;
 final  List<CircleSubjectRecord> _children;
@override@JsonKey(name: 'children') List<CircleSubjectRecord> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

@override@JsonKey(name: 'allowDownload') final  bool allowDownload;

/// Create a copy of MyCircleRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyCircleRecordCopyWith<_MyCircleRecord> get copyWith => __$MyCircleRecordCopyWithImpl<_MyCircleRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyCircleRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyCircleRecord&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._children, _children)&&(identical(other.allowDownload, allowDownload) || other.allowDownload == allowDownload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,familyName,status,const DeepCollectionEquality().hash(_children),allowDownload);

@override
String toString() {
  return 'MyCircleRecord(familyId: $familyId, familyName: $familyName, status: $status, children: $children, allowDownload: $allowDownload)';
}


}

/// @nodoc
abstract mixin class _$MyCircleRecordCopyWith<$Res> implements $MyCircleRecordCopyWith<$Res> {
  factory _$MyCircleRecordCopyWith(_MyCircleRecord value, $Res Function(_MyCircleRecord) _then) = __$MyCircleRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'familyName') String? familyName,@JsonKey(name: 'status') String? status,@JsonKey(name: 'children') List<CircleSubjectRecord> children,@JsonKey(name: 'allowDownload') bool allowDownload
});




}
/// @nodoc
class __$MyCircleRecordCopyWithImpl<$Res>
    implements _$MyCircleRecordCopyWith<$Res> {
  __$MyCircleRecordCopyWithImpl(this._self, this._then);

  final _MyCircleRecord _self;
  final $Res Function(_MyCircleRecord) _then;

/// Create a copy of MyCircleRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? familyId = freezed,Object? familyName = freezed,Object? status = freezed,Object? children = null,Object? allowDownload = null,}) {
  return _then(_MyCircleRecord(
familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,familyName: freezed == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<CircleSubjectRecord>,allowDownload: null == allowDownload ? _self.allowDownload : allowDownload // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
