// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outbox_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OutboxEntry {

@JsonKey(name: 'id') String get id;/// Loại thao tác, vd `memory.create`.
@JsonKey(name: 'kind') String get kind;/// Tham số của thao tác (đường dẫn media là bản sao trong thư mục app).
@JsonKey(name: 'args') Map<String, dynamic> get args;/// Bản ghi tạm hiện trên giao diện tới khi server nhận.
@JsonKey(name: 'placeholder') Map<String, dynamic> get placeholder;@JsonKey(name: 'createdAt') DateTime get createdAt;@JsonKey(name: 'attempts') int get attempts;/// Server từ chối (4xx nghiệp vụ): chờ người dùng thử lại hoặc huỷ.
@JsonKey(name: 'failed') bool get failed;
/// Create a copy of OutboxEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutboxEntryCopyWith<OutboxEntry> get copyWith => _$OutboxEntryCopyWithImpl<OutboxEntry>(this as OutboxEntry, _$identity);

  /// Serializes this OutboxEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutboxEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other.args, args)&&const DeepCollectionEquality().equals(other.placeholder, placeholder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.failed, failed) || other.failed == failed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,const DeepCollectionEquality().hash(args),const DeepCollectionEquality().hash(placeholder),createdAt,attempts,failed);

@override
String toString() {
  return 'OutboxEntry(id: $id, kind: $kind, args: $args, placeholder: $placeholder, createdAt: $createdAt, attempts: $attempts, failed: $failed)';
}


}

/// @nodoc
abstract mixin class $OutboxEntryCopyWith<$Res>  {
  factory $OutboxEntryCopyWith(OutboxEntry value, $Res Function(OutboxEntry) _then) = _$OutboxEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'kind') String kind,@JsonKey(name: 'args') Map<String, dynamic> args,@JsonKey(name: 'placeholder') Map<String, dynamic> placeholder,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'attempts') int attempts,@JsonKey(name: 'failed') bool failed
});




}
/// @nodoc
class _$OutboxEntryCopyWithImpl<$Res>
    implements $OutboxEntryCopyWith<$Res> {
  _$OutboxEntryCopyWithImpl(this._self, this._then);

  final OutboxEntry _self;
  final $Res Function(OutboxEntry) _then;

/// Create a copy of OutboxEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? args = null,Object? placeholder = null,Object? createdAt = null,Object? attempts = null,Object? failed = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,args: null == args ? _self.args : args // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,placeholder: null == placeholder ? _self.placeholder : placeholder // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OutboxEntry].
extension OutboxEntryPatterns on OutboxEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutboxEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutboxEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutboxEntry value)  $default,){
final _that = this;
switch (_that) {
case _OutboxEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutboxEntry value)?  $default,){
final _that = this;
switch (_that) {
case _OutboxEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OutboxEntry implements OutboxEntry {
  const _OutboxEntry({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'kind') required this.kind, @JsonKey(name: 'args') final  Map<String, dynamic> args = const <String, dynamic>{}, @JsonKey(name: 'placeholder') final  Map<String, dynamic> placeholder = const <String, dynamic>{}, @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'attempts') this.attempts = 0, @JsonKey(name: 'failed') this.failed = false}): _args = args,_placeholder = placeholder;
  factory _OutboxEntry.fromJson(Map<String, dynamic> json) => _$OutboxEntryFromJson(json);

@override@JsonKey(name: 'id') final  String id;
/// Loại thao tác, vd `memory.create`.
@override@JsonKey(name: 'kind') final  String kind;
/// Tham số của thao tác (đường dẫn media là bản sao trong thư mục app).
 final  Map<String, dynamic> _args;
/// Tham số của thao tác (đường dẫn media là bản sao trong thư mục app).
@override@JsonKey(name: 'args') Map<String, dynamic> get args {
  if (_args is EqualUnmodifiableMapView) return _args;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_args);
}

/// Bản ghi tạm hiện trên giao diện tới khi server nhận.
 final  Map<String, dynamic> _placeholder;
/// Bản ghi tạm hiện trên giao diện tới khi server nhận.
@override@JsonKey(name: 'placeholder') Map<String, dynamic> get placeholder {
  if (_placeholder is EqualUnmodifiableMapView) return _placeholder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_placeholder);
}

@override@JsonKey(name: 'createdAt') final  DateTime createdAt;
@override@JsonKey(name: 'attempts') final  int attempts;
/// Server từ chối (4xx nghiệp vụ): chờ người dùng thử lại hoặc huỷ.
@override@JsonKey(name: 'failed') final  bool failed;

/// Create a copy of OutboxEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutboxEntryCopyWith<_OutboxEntry> get copyWith => __$OutboxEntryCopyWithImpl<_OutboxEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OutboxEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutboxEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other._args, _args)&&const DeepCollectionEquality().equals(other._placeholder, _placeholder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.failed, failed) || other.failed == failed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,const DeepCollectionEquality().hash(_args),const DeepCollectionEquality().hash(_placeholder),createdAt,attempts,failed);

@override
String toString() {
  return 'OutboxEntry(id: $id, kind: $kind, args: $args, placeholder: $placeholder, createdAt: $createdAt, attempts: $attempts, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$OutboxEntryCopyWith<$Res> implements $OutboxEntryCopyWith<$Res> {
  factory _$OutboxEntryCopyWith(_OutboxEntry value, $Res Function(_OutboxEntry) _then) = __$OutboxEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'kind') String kind,@JsonKey(name: 'args') Map<String, dynamic> args,@JsonKey(name: 'placeholder') Map<String, dynamic> placeholder,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'attempts') int attempts,@JsonKey(name: 'failed') bool failed
});




}
/// @nodoc
class __$OutboxEntryCopyWithImpl<$Res>
    implements _$OutboxEntryCopyWith<$Res> {
  __$OutboxEntryCopyWithImpl(this._self, this._then);

  final _OutboxEntry _self;
  final $Res Function(_OutboxEntry) _then;

/// Create a copy of OutboxEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? args = null,Object? placeholder = null,Object? createdAt = null,Object? attempts = null,Object? failed = null,}) {
  return _then(_OutboxEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,args: null == args ? _self._args : args // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,placeholder: null == placeholder ? _self._placeholder : placeholder // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
