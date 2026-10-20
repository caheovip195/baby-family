// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_tree_today_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyTreeTodayRecord {

@JsonKey(name: 'leaves') int get leaves;@JsonKey(name: 'total') int get total;@JsonKey(name: 'bloomed') bool get bloomed;
/// Create a copy of FamilyTreeTodayRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyTreeTodayRecordCopyWith<FamilyTreeTodayRecord> get copyWith => _$FamilyTreeTodayRecordCopyWithImpl<FamilyTreeTodayRecord>(this as FamilyTreeTodayRecord, _$identity);

  /// Serializes this FamilyTreeTodayRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyTreeTodayRecord&&(identical(other.leaves, leaves) || other.leaves == leaves)&&(identical(other.total, total) || other.total == total)&&(identical(other.bloomed, bloomed) || other.bloomed == bloomed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,leaves,total,bloomed);

@override
String toString() {
  return 'FamilyTreeTodayRecord(leaves: $leaves, total: $total, bloomed: $bloomed)';
}


}

/// @nodoc
abstract mixin class $FamilyTreeTodayRecordCopyWith<$Res>  {
  factory $FamilyTreeTodayRecordCopyWith(FamilyTreeTodayRecord value, $Res Function(FamilyTreeTodayRecord) _then) = _$FamilyTreeTodayRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'leaves') int leaves,@JsonKey(name: 'total') int total,@JsonKey(name: 'bloomed') bool bloomed
});




}
/// @nodoc
class _$FamilyTreeTodayRecordCopyWithImpl<$Res>
    implements $FamilyTreeTodayRecordCopyWith<$Res> {
  _$FamilyTreeTodayRecordCopyWithImpl(this._self, this._then);

  final FamilyTreeTodayRecord _self;
  final $Res Function(FamilyTreeTodayRecord) _then;

/// Create a copy of FamilyTreeTodayRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leaves = null,Object? total = null,Object? bloomed = null,}) {
  return _then(_self.copyWith(
leaves: null == leaves ? _self.leaves : leaves // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,bloomed: null == bloomed ? _self.bloomed : bloomed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyTreeTodayRecord].
extension FamilyTreeTodayRecordPatterns on FamilyTreeTodayRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyTreeTodayRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyTreeTodayRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyTreeTodayRecord value)  $default,){
final _that = this;
switch (_that) {
case _FamilyTreeTodayRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyTreeTodayRecord value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyTreeTodayRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FamilyTreeTodayRecord implements FamilyTreeTodayRecord {
  const _FamilyTreeTodayRecord({@JsonKey(name: 'leaves') this.leaves = 0, @JsonKey(name: 'total') this.total = 0, @JsonKey(name: 'bloomed') this.bloomed = false});
  factory _FamilyTreeTodayRecord.fromJson(Map<String, dynamic> json) => _$FamilyTreeTodayRecordFromJson(json);

@override@JsonKey(name: 'leaves') final  int leaves;
@override@JsonKey(name: 'total') final  int total;
@override@JsonKey(name: 'bloomed') final  bool bloomed;

/// Create a copy of FamilyTreeTodayRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyTreeTodayRecordCopyWith<_FamilyTreeTodayRecord> get copyWith => __$FamilyTreeTodayRecordCopyWithImpl<_FamilyTreeTodayRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyTreeTodayRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyTreeTodayRecord&&(identical(other.leaves, leaves) || other.leaves == leaves)&&(identical(other.total, total) || other.total == total)&&(identical(other.bloomed, bloomed) || other.bloomed == bloomed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,leaves,total,bloomed);

@override
String toString() {
  return 'FamilyTreeTodayRecord(leaves: $leaves, total: $total, bloomed: $bloomed)';
}


}

/// @nodoc
abstract mixin class _$FamilyTreeTodayRecordCopyWith<$Res> implements $FamilyTreeTodayRecordCopyWith<$Res> {
  factory _$FamilyTreeTodayRecordCopyWith(_FamilyTreeTodayRecord value, $Res Function(_FamilyTreeTodayRecord) _then) = __$FamilyTreeTodayRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'leaves') int leaves,@JsonKey(name: 'total') int total,@JsonKey(name: 'bloomed') bool bloomed
});




}
/// @nodoc
class __$FamilyTreeTodayRecordCopyWithImpl<$Res>
    implements _$FamilyTreeTodayRecordCopyWith<$Res> {
  __$FamilyTreeTodayRecordCopyWithImpl(this._self, this._then);

  final _FamilyTreeTodayRecord _self;
  final $Res Function(_FamilyTreeTodayRecord) _then;

/// Create a copy of FamilyTreeTodayRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leaves = null,Object? total = null,Object? bloomed = null,}) {
  return _then(_FamilyTreeTodayRecord(
leaves: null == leaves ? _self.leaves : leaves // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,bloomed: null == bloomed ? _self.bloomed : bloomed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
