// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_handoff.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CareHandoff {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'direction') String get direction;@JsonKey(name: 'childIds') List<String> get childIds;@JsonKey(name: 'fedAt') DateTime? get fedAt;@JsonKey(name: 'sleptAt') DateTime? get sleptAt;@JsonKey(name: 'wokeAt') DateTime? get wokeAt;@JsonKey(name: 'note') String? get note;@JsonKey(name: 'acknowledgedAt') DateTime? get acknowledgedAt;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'pending') bool get pending;
/// Create a copy of CareHandoff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareHandoffCopyWith<CareHandoff> get copyWith => _$CareHandoffCopyWithImpl<CareHandoff>(this as CareHandoff, _$identity);

  /// Serializes this CareHandoff to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareHandoff&&(identical(other.id, id) || other.id == id)&&(identical(other.direction, direction) || other.direction == direction)&&const DeepCollectionEquality().equals(other.childIds, childIds)&&(identical(other.fedAt, fedAt) || other.fedAt == fedAt)&&(identical(other.sleptAt, sleptAt) || other.sleptAt == sleptAt)&&(identical(other.wokeAt, wokeAt) || other.wokeAt == wokeAt)&&(identical(other.note, note) || other.note == note)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.pending, pending) || other.pending == pending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,direction,const DeepCollectionEquality().hash(childIds),fedAt,sleptAt,wokeAt,note,acknowledgedAt,createdAt,pending);

@override
String toString() {
  return 'CareHandoff(id: $id, direction: $direction, childIds: $childIds, fedAt: $fedAt, sleptAt: $sleptAt, wokeAt: $wokeAt, note: $note, acknowledgedAt: $acknowledgedAt, createdAt: $createdAt, pending: $pending)';
}


}

/// @nodoc
abstract mixin class $CareHandoffCopyWith<$Res>  {
  factory $CareHandoffCopyWith(CareHandoff value, $Res Function(CareHandoff) _then) = _$CareHandoffCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'direction') String direction,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'fedAt') DateTime? fedAt,@JsonKey(name: 'sleptAt') DateTime? sleptAt,@JsonKey(name: 'wokeAt') DateTime? wokeAt,@JsonKey(name: 'note') String? note,@JsonKey(name: 'acknowledgedAt') DateTime? acknowledgedAt,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'pending') bool pending
});




}
/// @nodoc
class _$CareHandoffCopyWithImpl<$Res>
    implements $CareHandoffCopyWith<$Res> {
  _$CareHandoffCopyWithImpl(this._self, this._then);

  final CareHandoff _self;
  final $Res Function(CareHandoff) _then;

/// Create a copy of CareHandoff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? direction = null,Object? childIds = null,Object? fedAt = freezed,Object? sleptAt = freezed,Object? wokeAt = freezed,Object? note = freezed,Object? acknowledgedAt = freezed,Object? createdAt = freezed,Object? pending = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as String,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,fedAt: freezed == fedAt ? _self.fedAt : fedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sleptAt: freezed == sleptAt ? _self.sleptAt : sleptAt // ignore: cast_nullable_to_non_nullable
as DateTime?,wokeAt: freezed == wokeAt ? _self.wokeAt : wokeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,acknowledgedAt: freezed == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CareHandoff].
extension CareHandoffPatterns on CareHandoff {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareHandoff value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareHandoff() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareHandoff value)  $default,){
final _that = this;
switch (_that) {
case _CareHandoff():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareHandoff value)?  $default,){
final _that = this;
switch (_that) {
case _CareHandoff() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CareHandoff extends CareHandoff {
  const _CareHandoff({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'direction') this.direction = 'SENT', @JsonKey(name: 'childIds') final  List<String> childIds = const <String>[], @JsonKey(name: 'fedAt') this.fedAt, @JsonKey(name: 'sleptAt') this.sleptAt, @JsonKey(name: 'wokeAt') this.wokeAt, @JsonKey(name: 'note') this.note, @JsonKey(name: 'acknowledgedAt') this.acknowledgedAt, @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'pending') this.pending = false}): _childIds = childIds,super._();
  factory _CareHandoff.fromJson(Map<String, dynamic> json) => _$CareHandoffFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'direction') final  String direction;
 final  List<String> _childIds;
@override@JsonKey(name: 'childIds') List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}

@override@JsonKey(name: 'fedAt') final  DateTime? fedAt;
@override@JsonKey(name: 'sleptAt') final  DateTime? sleptAt;
@override@JsonKey(name: 'wokeAt') final  DateTime? wokeAt;
@override@JsonKey(name: 'note') final  String? note;
@override@JsonKey(name: 'acknowledgedAt') final  DateTime? acknowledgedAt;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
@override@JsonKey(name: 'pending') final  bool pending;

/// Create a copy of CareHandoff
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareHandoffCopyWith<_CareHandoff> get copyWith => __$CareHandoffCopyWithImpl<_CareHandoff>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CareHandoffToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareHandoff&&(identical(other.id, id) || other.id == id)&&(identical(other.direction, direction) || other.direction == direction)&&const DeepCollectionEquality().equals(other._childIds, _childIds)&&(identical(other.fedAt, fedAt) || other.fedAt == fedAt)&&(identical(other.sleptAt, sleptAt) || other.sleptAt == sleptAt)&&(identical(other.wokeAt, wokeAt) || other.wokeAt == wokeAt)&&(identical(other.note, note) || other.note == note)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.pending, pending) || other.pending == pending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,direction,const DeepCollectionEquality().hash(_childIds),fedAt,sleptAt,wokeAt,note,acknowledgedAt,createdAt,pending);

@override
String toString() {
  return 'CareHandoff(id: $id, direction: $direction, childIds: $childIds, fedAt: $fedAt, sleptAt: $sleptAt, wokeAt: $wokeAt, note: $note, acknowledgedAt: $acknowledgedAt, createdAt: $createdAt, pending: $pending)';
}


}

/// @nodoc
abstract mixin class _$CareHandoffCopyWith<$Res> implements $CareHandoffCopyWith<$Res> {
  factory _$CareHandoffCopyWith(_CareHandoff value, $Res Function(_CareHandoff) _then) = __$CareHandoffCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'direction') String direction,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'fedAt') DateTime? fedAt,@JsonKey(name: 'sleptAt') DateTime? sleptAt,@JsonKey(name: 'wokeAt') DateTime? wokeAt,@JsonKey(name: 'note') String? note,@JsonKey(name: 'acknowledgedAt') DateTime? acknowledgedAt,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'pending') bool pending
});




}
/// @nodoc
class __$CareHandoffCopyWithImpl<$Res>
    implements _$CareHandoffCopyWith<$Res> {
  __$CareHandoffCopyWithImpl(this._self, this._then);

  final _CareHandoff _self;
  final $Res Function(_CareHandoff) _then;

/// Create a copy of CareHandoff
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? direction = null,Object? childIds = null,Object? fedAt = freezed,Object? sleptAt = freezed,Object? wokeAt = freezed,Object? note = freezed,Object? acknowledgedAt = freezed,Object? createdAt = freezed,Object? pending = null,}) {
  return _then(_CareHandoff(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as String,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,fedAt: freezed == fedAt ? _self.fedAt : fedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sleptAt: freezed == sleptAt ? _self.sleptAt : sleptAt // ignore: cast_nullable_to_non_nullable
as DateTime?,wokeAt: freezed == wokeAt ? _self.wokeAt : wokeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,acknowledgedAt: freezed == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
