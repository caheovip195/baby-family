// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_prompt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemoryPrompt {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'childId') String? get childId;@JsonKey(name: 'kind') MemoryKind get kind;@JsonKey(name: 'text') String get text;
/// Create a copy of MemoryPrompt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryPromptCopyWith<MemoryPrompt> get copyWith => _$MemoryPromptCopyWithImpl<MemoryPrompt>(this as MemoryPrompt, _$identity);

  /// Serializes this MemoryPrompt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryPrompt&&(identical(other.id, id) || other.id == id)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,childId,kind,text);

@override
String toString() {
  return 'MemoryPrompt(id: $id, childId: $childId, kind: $kind, text: $text)';
}


}

/// @nodoc
abstract mixin class $MemoryPromptCopyWith<$Res>  {
  factory $MemoryPromptCopyWith(MemoryPrompt value, $Res Function(MemoryPrompt) _then) = _$MemoryPromptCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'kind') MemoryKind kind,@JsonKey(name: 'text') String text
});




}
/// @nodoc
class _$MemoryPromptCopyWithImpl<$Res>
    implements $MemoryPromptCopyWith<$Res> {
  _$MemoryPromptCopyWithImpl(this._self, this._then);

  final MemoryPrompt _self;
  final $Res Function(MemoryPrompt) _then;

/// Create a copy of MemoryPrompt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? childId = freezed,Object? kind = null,Object? text = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MemoryKind,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryPrompt].
extension MemoryPromptPatterns on MemoryPrompt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryPrompt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryPrompt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryPrompt value)  $default,){
final _that = this;
switch (_that) {
case _MemoryPrompt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryPrompt value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryPrompt() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MemoryPrompt implements MemoryPrompt {
  const _MemoryPrompt({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'childId') this.childId, @JsonKey(name: 'kind') this.kind = MemoryKind.quote, @JsonKey(name: 'text') required this.text});
  factory _MemoryPrompt.fromJson(Map<String, dynamic> json) => _$MemoryPromptFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'childId') final  String? childId;
@override@JsonKey(name: 'kind') final  MemoryKind kind;
@override@JsonKey(name: 'text') final  String text;

/// Create a copy of MemoryPrompt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryPromptCopyWith<_MemoryPrompt> get copyWith => __$MemoryPromptCopyWithImpl<_MemoryPrompt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryPromptToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryPrompt&&(identical(other.id, id) || other.id == id)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,childId,kind,text);

@override
String toString() {
  return 'MemoryPrompt(id: $id, childId: $childId, kind: $kind, text: $text)';
}


}

/// @nodoc
abstract mixin class _$MemoryPromptCopyWith<$Res> implements $MemoryPromptCopyWith<$Res> {
  factory _$MemoryPromptCopyWith(_MemoryPrompt value, $Res Function(_MemoryPrompt) _then) = __$MemoryPromptCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'kind') MemoryKind kind,@JsonKey(name: 'text') String text
});




}
/// @nodoc
class __$MemoryPromptCopyWithImpl<$Res>
    implements _$MemoryPromptCopyWith<$Res> {
  __$MemoryPromptCopyWithImpl(this._self, this._then);

  final _MemoryPrompt _self;
  final $Res Function(_MemoryPrompt) _then;

/// Create a copy of MemoryPrompt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? childId = freezed,Object? kind = null,Object? text = null,}) {
  return _then(_MemoryPrompt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MemoryKind,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
