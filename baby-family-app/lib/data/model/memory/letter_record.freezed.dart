// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'letter_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LetterRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'sealed') bool get sealed;@JsonKey(name: 'unlockAt') DateTime? get unlockAt;@JsonKey(name: 'authorUserId') String? get authorUserId;
/// Create a copy of LetterRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LetterRecordCopyWith<LetterRecord> get copyWith => _$LetterRecordCopyWithImpl<LetterRecord>(this as LetterRecord, _$identity);

  /// Serializes this LetterRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LetterRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.sealed, sealed) || other.sealed == sealed)&&(identical(other.unlockAt, unlockAt) || other.unlockAt == unlockAt)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sealed,unlockAt,authorUserId);

@override
String toString() {
  return 'LetterRecord(id: $id, sealed: $sealed, unlockAt: $unlockAt, authorUserId: $authorUserId)';
}


}

/// @nodoc
abstract mixin class $LetterRecordCopyWith<$Res>  {
  factory $LetterRecordCopyWith(LetterRecord value, $Res Function(LetterRecord) _then) = _$LetterRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'sealed') bool sealed,@JsonKey(name: 'unlockAt') DateTime? unlockAt,@JsonKey(name: 'authorUserId') String? authorUserId
});




}
/// @nodoc
class _$LetterRecordCopyWithImpl<$Res>
    implements $LetterRecordCopyWith<$Res> {
  _$LetterRecordCopyWithImpl(this._self, this._then);

  final LetterRecord _self;
  final $Res Function(LetterRecord) _then;

/// Create a copy of LetterRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? sealed = null,Object? unlockAt = freezed,Object? authorUserId = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,sealed: null == sealed ? _self.sealed : sealed // ignore: cast_nullable_to_non_nullable
as bool,unlockAt: freezed == unlockAt ? _self.unlockAt : unlockAt // ignore: cast_nullable_to_non_nullable
as DateTime?,authorUserId: freezed == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LetterRecord].
extension LetterRecordPatterns on LetterRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LetterRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LetterRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LetterRecord value)  $default,){
final _that = this;
switch (_that) {
case _LetterRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LetterRecord value)?  $default,){
final _that = this;
switch (_that) {
case _LetterRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _LetterRecord implements LetterRecord {
  const _LetterRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'sealed') this.sealed = false, @JsonKey(name: 'unlockAt') this.unlockAt, @JsonKey(name: 'authorUserId') this.authorUserId});
  factory _LetterRecord.fromJson(Map<String, dynamic> json) => _$LetterRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'sealed') final  bool sealed;
@override@JsonKey(name: 'unlockAt') final  DateTime? unlockAt;
@override@JsonKey(name: 'authorUserId') final  String? authorUserId;

/// Create a copy of LetterRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LetterRecordCopyWith<_LetterRecord> get copyWith => __$LetterRecordCopyWithImpl<_LetterRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LetterRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LetterRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.sealed, sealed) || other.sealed == sealed)&&(identical(other.unlockAt, unlockAt) || other.unlockAt == unlockAt)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sealed,unlockAt,authorUserId);

@override
String toString() {
  return 'LetterRecord(id: $id, sealed: $sealed, unlockAt: $unlockAt, authorUserId: $authorUserId)';
}


}

/// @nodoc
abstract mixin class _$LetterRecordCopyWith<$Res> implements $LetterRecordCopyWith<$Res> {
  factory _$LetterRecordCopyWith(_LetterRecord value, $Res Function(_LetterRecord) _then) = __$LetterRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'sealed') bool sealed,@JsonKey(name: 'unlockAt') DateTime? unlockAt,@JsonKey(name: 'authorUserId') String? authorUserId
});




}
/// @nodoc
class __$LetterRecordCopyWithImpl<$Res>
    implements _$LetterRecordCopyWith<$Res> {
  __$LetterRecordCopyWithImpl(this._self, this._then);

  final _LetterRecord _self;
  final $Res Function(_LetterRecord) _then;

/// Create a copy of LetterRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? sealed = null,Object? unlockAt = freezed,Object? authorUserId = freezed,}) {
  return _then(_LetterRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,sealed: null == sealed ? _self.sealed : sealed // ignore: cast_nullable_to_non_nullable
as bool,unlockAt: freezed == unlockAt ? _self.unlockAt : unlockAt // ignore: cast_nullable_to_non_nullable
as DateTime?,authorUserId: freezed == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
