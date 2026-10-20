// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_prompt_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemoryPromptRecord {

@JsonKey(name: 'code') String? get code;@JsonKey(name: 'targetKind') String? get targetKind;@JsonKey(name: 'textI18n') Map<String, dynamic> get textI18n;@JsonKey(name: 'childId') String? get childId;
/// Create a copy of MemoryPromptRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryPromptRecordCopyWith<MemoryPromptRecord> get copyWith => _$MemoryPromptRecordCopyWithImpl<MemoryPromptRecord>(this as MemoryPromptRecord, _$identity);

  /// Serializes this MemoryPromptRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryPromptRecord&&(identical(other.code, code) || other.code == code)&&(identical(other.targetKind, targetKind) || other.targetKind == targetKind)&&const DeepCollectionEquality().equals(other.textI18n, textI18n)&&(identical(other.childId, childId) || other.childId == childId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,targetKind,const DeepCollectionEquality().hash(textI18n),childId);

@override
String toString() {
  return 'MemoryPromptRecord(code: $code, targetKind: $targetKind, textI18n: $textI18n, childId: $childId)';
}


}

/// @nodoc
abstract mixin class $MemoryPromptRecordCopyWith<$Res>  {
  factory $MemoryPromptRecordCopyWith(MemoryPromptRecord value, $Res Function(MemoryPromptRecord) _then) = _$MemoryPromptRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String? code,@JsonKey(name: 'targetKind') String? targetKind,@JsonKey(name: 'textI18n') Map<String, dynamic> textI18n,@JsonKey(name: 'childId') String? childId
});




}
/// @nodoc
class _$MemoryPromptRecordCopyWithImpl<$Res>
    implements $MemoryPromptRecordCopyWith<$Res> {
  _$MemoryPromptRecordCopyWithImpl(this._self, this._then);

  final MemoryPromptRecord _self;
  final $Res Function(MemoryPromptRecord) _then;

/// Create a copy of MemoryPromptRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = freezed,Object? targetKind = freezed,Object? textI18n = null,Object? childId = freezed,}) {
  return _then(_self.copyWith(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,targetKind: freezed == targetKind ? _self.targetKind : targetKind // ignore: cast_nullable_to_non_nullable
as String?,textI18n: null == textI18n ? _self.textI18n : textI18n // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryPromptRecord].
extension MemoryPromptRecordPatterns on MemoryPromptRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryPromptRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryPromptRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryPromptRecord value)  $default,){
final _that = this;
switch (_that) {
case _MemoryPromptRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryPromptRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryPromptRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MemoryPromptRecord implements MemoryPromptRecord {
  const _MemoryPromptRecord({@JsonKey(name: 'code') this.code, @JsonKey(name: 'targetKind') this.targetKind, @JsonKey(name: 'textI18n') final  Map<String, dynamic> textI18n = const <String, dynamic>{}, @JsonKey(name: 'childId') this.childId}): _textI18n = textI18n;
  factory _MemoryPromptRecord.fromJson(Map<String, dynamic> json) => _$MemoryPromptRecordFromJson(json);

@override@JsonKey(name: 'code') final  String? code;
@override@JsonKey(name: 'targetKind') final  String? targetKind;
 final  Map<String, dynamic> _textI18n;
@override@JsonKey(name: 'textI18n') Map<String, dynamic> get textI18n {
  if (_textI18n is EqualUnmodifiableMapView) return _textI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_textI18n);
}

@override@JsonKey(name: 'childId') final  String? childId;

/// Create a copy of MemoryPromptRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryPromptRecordCopyWith<_MemoryPromptRecord> get copyWith => __$MemoryPromptRecordCopyWithImpl<_MemoryPromptRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryPromptRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryPromptRecord&&(identical(other.code, code) || other.code == code)&&(identical(other.targetKind, targetKind) || other.targetKind == targetKind)&&const DeepCollectionEquality().equals(other._textI18n, _textI18n)&&(identical(other.childId, childId) || other.childId == childId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,targetKind,const DeepCollectionEquality().hash(_textI18n),childId);

@override
String toString() {
  return 'MemoryPromptRecord(code: $code, targetKind: $targetKind, textI18n: $textI18n, childId: $childId)';
}


}

/// @nodoc
abstract mixin class _$MemoryPromptRecordCopyWith<$Res> implements $MemoryPromptRecordCopyWith<$Res> {
  factory _$MemoryPromptRecordCopyWith(_MemoryPromptRecord value, $Res Function(_MemoryPromptRecord) _then) = __$MemoryPromptRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String? code,@JsonKey(name: 'targetKind') String? targetKind,@JsonKey(name: 'textI18n') Map<String, dynamic> textI18n,@JsonKey(name: 'childId') String? childId
});




}
/// @nodoc
class __$MemoryPromptRecordCopyWithImpl<$Res>
    implements _$MemoryPromptRecordCopyWith<$Res> {
  __$MemoryPromptRecordCopyWithImpl(this._self, this._then);

  final _MemoryPromptRecord _self;
  final $Res Function(_MemoryPromptRecord) _then;

/// Create a copy of MemoryPromptRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? targetKind = freezed,Object? textI18n = null,Object? childId = freezed,}) {
  return _then(_MemoryPromptRecord(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,targetKind: freezed == targetKind ? _self.targetKind : targetKind // ignore: cast_nullable_to_non_nullable
as String?,textI18n: null == textI18n ? _self._textI18n : textI18n // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
