// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'birth_result_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BirthResultRecord {

@JsonKey(name: 'pregnancyId') String? get pregnancyId;@JsonKey(name: 'children') List<ChildRecord> get children;
/// Create a copy of BirthResultRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BirthResultRecordCopyWith<BirthResultRecord> get copyWith => _$BirthResultRecordCopyWithImpl<BirthResultRecord>(this as BirthResultRecord, _$identity);

  /// Serializes this BirthResultRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BirthResultRecord&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pregnancyId,const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'BirthResultRecord(pregnancyId: $pregnancyId, children: $children)';
}


}

/// @nodoc
abstract mixin class $BirthResultRecordCopyWith<$Res>  {
  factory $BirthResultRecordCopyWith(BirthResultRecord value, $Res Function(BirthResultRecord) _then) = _$BirthResultRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'pregnancyId') String? pregnancyId,@JsonKey(name: 'children') List<ChildRecord> children
});




}
/// @nodoc
class _$BirthResultRecordCopyWithImpl<$Res>
    implements $BirthResultRecordCopyWith<$Res> {
  _$BirthResultRecordCopyWithImpl(this._self, this._then);

  final BirthResultRecord _self;
  final $Res Function(BirthResultRecord) _then;

/// Create a copy of BirthResultRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pregnancyId = freezed,Object? children = null,}) {
  return _then(_self.copyWith(
pregnancyId: freezed == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ChildRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [BirthResultRecord].
extension BirthResultRecordPatterns on BirthResultRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BirthResultRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BirthResultRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BirthResultRecord value)  $default,){
final _that = this;
switch (_that) {
case _BirthResultRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BirthResultRecord value)?  $default,){
final _that = this;
switch (_that) {
case _BirthResultRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BirthResultRecord implements BirthResultRecord {
  const _BirthResultRecord({@JsonKey(name: 'pregnancyId') this.pregnancyId, @JsonKey(name: 'children') final  List<ChildRecord> children = const <ChildRecord>[]}): _children = children;
  factory _BirthResultRecord.fromJson(Map<String, dynamic> json) => _$BirthResultRecordFromJson(json);

@override@JsonKey(name: 'pregnancyId') final  String? pregnancyId;
 final  List<ChildRecord> _children;
@override@JsonKey(name: 'children') List<ChildRecord> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of BirthResultRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BirthResultRecordCopyWith<_BirthResultRecord> get copyWith => __$BirthResultRecordCopyWithImpl<_BirthResultRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BirthResultRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BirthResultRecord&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&const DeepCollectionEquality().equals(other._children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pregnancyId,const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'BirthResultRecord(pregnancyId: $pregnancyId, children: $children)';
}


}

/// @nodoc
abstract mixin class _$BirthResultRecordCopyWith<$Res> implements $BirthResultRecordCopyWith<$Res> {
  factory _$BirthResultRecordCopyWith(_BirthResultRecord value, $Res Function(_BirthResultRecord) _then) = __$BirthResultRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'pregnancyId') String? pregnancyId,@JsonKey(name: 'children') List<ChildRecord> children
});




}
/// @nodoc
class __$BirthResultRecordCopyWithImpl<$Res>
    implements _$BirthResultRecordCopyWith<$Res> {
  __$BirthResultRecordCopyWithImpl(this._self, this._then);

  final _BirthResultRecord _self;
  final $Res Function(_BirthResultRecord) _then;

/// Create a copy of BirthResultRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pregnancyId = freezed,Object? children = null,}) {
  return _then(_BirthResultRecord(
pregnancyId: freezed == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ChildRecord>,
  ));
}


}

// dart format on
