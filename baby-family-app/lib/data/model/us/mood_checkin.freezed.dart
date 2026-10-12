// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mood_checkin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MoodCheckin {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'userId') String get userId;@JsonKey(name: 'mood') MoodCode get mood;@JsonKey(name: 'energy') int get energy;@JsonKey(name: 'needs') List<CoupleNeed> get needs;@JsonKey(name: 'needMinutes') int? get needMinutes;@JsonKey(name: 'note') String? get note;@JsonKey(name: 'shared') bool get shared;@JsonKey(name: 'createdAt') DateTime get createdAt;@JsonKey(name: 'expiresAt') DateTime? get expiresAt;
/// Create a copy of MoodCheckin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoodCheckinCopyWith<MoodCheckin> get copyWith => _$MoodCheckinCopyWithImpl<MoodCheckin>(this as MoodCheckin, _$identity);

  /// Serializes this MoodCheckin to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoodCheckin&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.energy, energy) || other.energy == energy)&&const DeepCollectionEquality().equals(other.needs, needs)&&(identical(other.needMinutes, needMinutes) || other.needMinutes == needMinutes)&&(identical(other.note, note) || other.note == note)&&(identical(other.shared, shared) || other.shared == shared)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mood,energy,const DeepCollectionEquality().hash(needs),needMinutes,note,shared,createdAt,expiresAt);

@override
String toString() {
  return 'MoodCheckin(id: $id, userId: $userId, mood: $mood, energy: $energy, needs: $needs, needMinutes: $needMinutes, note: $note, shared: $shared, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $MoodCheckinCopyWith<$Res>  {
  factory $MoodCheckinCopyWith(MoodCheckin value, $Res Function(MoodCheckin) _then) = _$MoodCheckinCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'userId') String userId,@JsonKey(name: 'mood') MoodCode mood,@JsonKey(name: 'energy') int energy,@JsonKey(name: 'needs') List<CoupleNeed> needs,@JsonKey(name: 'needMinutes') int? needMinutes,@JsonKey(name: 'note') String? note,@JsonKey(name: 'shared') bool shared,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'expiresAt') DateTime? expiresAt
});




}
/// @nodoc
class _$MoodCheckinCopyWithImpl<$Res>
    implements $MoodCheckinCopyWith<$Res> {
  _$MoodCheckinCopyWithImpl(this._self, this._then);

  final MoodCheckin _self;
  final $Res Function(MoodCheckin) _then;

/// Create a copy of MoodCheckin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? mood = null,Object? energy = null,Object? needs = null,Object? needMinutes = freezed,Object? note = freezed,Object? shared = null,Object? createdAt = null,Object? expiresAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as MoodCode,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as int,needs: null == needs ? _self.needs : needs // ignore: cast_nullable_to_non_nullable
as List<CoupleNeed>,needMinutes: freezed == needMinutes ? _self.needMinutes : needMinutes // ignore: cast_nullable_to_non_nullable
as int?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,shared: null == shared ? _self.shared : shared // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MoodCheckin].
extension MoodCheckinPatterns on MoodCheckin {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoodCheckin value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoodCheckin() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoodCheckin value)  $default,){
final _that = this;
switch (_that) {
case _MoodCheckin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoodCheckin value)?  $default,){
final _that = this;
switch (_that) {
case _MoodCheckin() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MoodCheckin implements MoodCheckin {
  const _MoodCheckin({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'userId') required this.userId, @JsonKey(name: 'mood') required this.mood, @JsonKey(name: 'energy') this.energy = 3, @JsonKey(name: 'needs') final  List<CoupleNeed> needs = const [], @JsonKey(name: 'needMinutes') this.needMinutes, @JsonKey(name: 'note') this.note, @JsonKey(name: 'shared') this.shared = true, @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'expiresAt') this.expiresAt}): _needs = needs;
  factory _MoodCheckin.fromJson(Map<String, dynamic> json) => _$MoodCheckinFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'userId') final  String userId;
@override@JsonKey(name: 'mood') final  MoodCode mood;
@override@JsonKey(name: 'energy') final  int energy;
 final  List<CoupleNeed> _needs;
@override@JsonKey(name: 'needs') List<CoupleNeed> get needs {
  if (_needs is EqualUnmodifiableListView) return _needs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_needs);
}

@override@JsonKey(name: 'needMinutes') final  int? needMinutes;
@override@JsonKey(name: 'note') final  String? note;
@override@JsonKey(name: 'shared') final  bool shared;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;
@override@JsonKey(name: 'expiresAt') final  DateTime? expiresAt;

/// Create a copy of MoodCheckin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoodCheckinCopyWith<_MoodCheckin> get copyWith => __$MoodCheckinCopyWithImpl<_MoodCheckin>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoodCheckinToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoodCheckin&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.energy, energy) || other.energy == energy)&&const DeepCollectionEquality().equals(other._needs, _needs)&&(identical(other.needMinutes, needMinutes) || other.needMinutes == needMinutes)&&(identical(other.note, note) || other.note == note)&&(identical(other.shared, shared) || other.shared == shared)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mood,energy,const DeepCollectionEquality().hash(_needs),needMinutes,note,shared,createdAt,expiresAt);

@override
String toString() {
  return 'MoodCheckin(id: $id, userId: $userId, mood: $mood, energy: $energy, needs: $needs, needMinutes: $needMinutes, note: $note, shared: $shared, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$MoodCheckinCopyWith<$Res> implements $MoodCheckinCopyWith<$Res> {
  factory _$MoodCheckinCopyWith(_MoodCheckin value, $Res Function(_MoodCheckin) _then) = __$MoodCheckinCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'userId') String userId,@JsonKey(name: 'mood') MoodCode mood,@JsonKey(name: 'energy') int energy,@JsonKey(name: 'needs') List<CoupleNeed> needs,@JsonKey(name: 'needMinutes') int? needMinutes,@JsonKey(name: 'note') String? note,@JsonKey(name: 'shared') bool shared,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'expiresAt') DateTime? expiresAt
});




}
/// @nodoc
class __$MoodCheckinCopyWithImpl<$Res>
    implements _$MoodCheckinCopyWith<$Res> {
  __$MoodCheckinCopyWithImpl(this._self, this._then);

  final _MoodCheckin _self;
  final $Res Function(_MoodCheckin) _then;

/// Create a copy of MoodCheckin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? mood = null,Object? energy = null,Object? needs = null,Object? needMinutes = freezed,Object? note = freezed,Object? shared = null,Object? createdAt = null,Object? expiresAt = freezed,}) {
  return _then(_MoodCheckin(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as MoodCode,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as int,needs: null == needs ? _self._needs : needs // ignore: cast_nullable_to_non_nullable
as List<CoupleNeed>,needMinutes: freezed == needMinutes ? _self.needMinutes : needMinutes // ignore: cast_nullable_to_non_nullable
as int?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,shared: null == shared ? _self.shared : shared // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
