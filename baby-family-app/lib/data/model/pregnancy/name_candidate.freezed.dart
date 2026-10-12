// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'name_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NameCandidate {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'pregnancyId') String get pregnancyId;@JsonKey(name: 'name') String get name;@JsonKey(name: 'meaning') String? get meaning;@JsonKey(name: 'addedByUserId') String get addedByUserId;@JsonKey(name: 'addedByCallName') String? get addedByCallName;@JsonKey(name: 'likedByMe') bool get likedByMe;@JsonKey(name: 'likedByPartner') bool get likedByPartner;@JsonKey(name: 'chosen') bool get chosen;
/// Create a copy of NameCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NameCandidateCopyWith<NameCandidate> get copyWith => _$NameCandidateCopyWithImpl<NameCandidate>(this as NameCandidate, _$identity);

  /// Serializes this NameCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NameCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.addedByUserId, addedByUserId) || other.addedByUserId == addedByUserId)&&(identical(other.addedByCallName, addedByCallName) || other.addedByCallName == addedByCallName)&&(identical(other.likedByMe, likedByMe) || other.likedByMe == likedByMe)&&(identical(other.likedByPartner, likedByPartner) || other.likedByPartner == likedByPartner)&&(identical(other.chosen, chosen) || other.chosen == chosen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pregnancyId,name,meaning,addedByUserId,addedByCallName,likedByMe,likedByPartner,chosen);

@override
String toString() {
  return 'NameCandidate(id: $id, pregnancyId: $pregnancyId, name: $name, meaning: $meaning, addedByUserId: $addedByUserId, addedByCallName: $addedByCallName, likedByMe: $likedByMe, likedByPartner: $likedByPartner, chosen: $chosen)';
}


}

/// @nodoc
abstract mixin class $NameCandidateCopyWith<$Res>  {
  factory $NameCandidateCopyWith(NameCandidate value, $Res Function(NameCandidate) _then) = _$NameCandidateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'pregnancyId') String pregnancyId,@JsonKey(name: 'name') String name,@JsonKey(name: 'meaning') String? meaning,@JsonKey(name: 'addedByUserId') String addedByUserId,@JsonKey(name: 'addedByCallName') String? addedByCallName,@JsonKey(name: 'likedByMe') bool likedByMe,@JsonKey(name: 'likedByPartner') bool likedByPartner,@JsonKey(name: 'chosen') bool chosen
});




}
/// @nodoc
class _$NameCandidateCopyWithImpl<$Res>
    implements $NameCandidateCopyWith<$Res> {
  _$NameCandidateCopyWithImpl(this._self, this._then);

  final NameCandidate _self;
  final $Res Function(NameCandidate) _then;

/// Create a copy of NameCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pregnancyId = null,Object? name = null,Object? meaning = freezed,Object? addedByUserId = null,Object? addedByCallName = freezed,Object? likedByMe = null,Object? likedByPartner = null,Object? chosen = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pregnancyId: null == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,meaning: freezed == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String?,addedByUserId: null == addedByUserId ? _self.addedByUserId : addedByUserId // ignore: cast_nullable_to_non_nullable
as String,addedByCallName: freezed == addedByCallName ? _self.addedByCallName : addedByCallName // ignore: cast_nullable_to_non_nullable
as String?,likedByMe: null == likedByMe ? _self.likedByMe : likedByMe // ignore: cast_nullable_to_non_nullable
as bool,likedByPartner: null == likedByPartner ? _self.likedByPartner : likedByPartner // ignore: cast_nullable_to_non_nullable
as bool,chosen: null == chosen ? _self.chosen : chosen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NameCandidate].
extension NameCandidatePatterns on NameCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NameCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NameCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NameCandidate value)  $default,){
final _that = this;
switch (_that) {
case _NameCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NameCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _NameCandidate() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _NameCandidate extends NameCandidate {
  const _NameCandidate({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'pregnancyId') required this.pregnancyId, @JsonKey(name: 'name') required this.name, @JsonKey(name: 'meaning') this.meaning, @JsonKey(name: 'addedByUserId') required this.addedByUserId, @JsonKey(name: 'addedByCallName') this.addedByCallName, @JsonKey(name: 'likedByMe') this.likedByMe = false, @JsonKey(name: 'likedByPartner') this.likedByPartner = false, @JsonKey(name: 'chosen') this.chosen = false}): super._();
  factory _NameCandidate.fromJson(Map<String, dynamic> json) => _$NameCandidateFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'pregnancyId') final  String pregnancyId;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'meaning') final  String? meaning;
@override@JsonKey(name: 'addedByUserId') final  String addedByUserId;
@override@JsonKey(name: 'addedByCallName') final  String? addedByCallName;
@override@JsonKey(name: 'likedByMe') final  bool likedByMe;
@override@JsonKey(name: 'likedByPartner') final  bool likedByPartner;
@override@JsonKey(name: 'chosen') final  bool chosen;

/// Create a copy of NameCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NameCandidateCopyWith<_NameCandidate> get copyWith => __$NameCandidateCopyWithImpl<_NameCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NameCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NameCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.addedByUserId, addedByUserId) || other.addedByUserId == addedByUserId)&&(identical(other.addedByCallName, addedByCallName) || other.addedByCallName == addedByCallName)&&(identical(other.likedByMe, likedByMe) || other.likedByMe == likedByMe)&&(identical(other.likedByPartner, likedByPartner) || other.likedByPartner == likedByPartner)&&(identical(other.chosen, chosen) || other.chosen == chosen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pregnancyId,name,meaning,addedByUserId,addedByCallName,likedByMe,likedByPartner,chosen);

@override
String toString() {
  return 'NameCandidate(id: $id, pregnancyId: $pregnancyId, name: $name, meaning: $meaning, addedByUserId: $addedByUserId, addedByCallName: $addedByCallName, likedByMe: $likedByMe, likedByPartner: $likedByPartner, chosen: $chosen)';
}


}

/// @nodoc
abstract mixin class _$NameCandidateCopyWith<$Res> implements $NameCandidateCopyWith<$Res> {
  factory _$NameCandidateCopyWith(_NameCandidate value, $Res Function(_NameCandidate) _then) = __$NameCandidateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'pregnancyId') String pregnancyId,@JsonKey(name: 'name') String name,@JsonKey(name: 'meaning') String? meaning,@JsonKey(name: 'addedByUserId') String addedByUserId,@JsonKey(name: 'addedByCallName') String? addedByCallName,@JsonKey(name: 'likedByMe') bool likedByMe,@JsonKey(name: 'likedByPartner') bool likedByPartner,@JsonKey(name: 'chosen') bool chosen
});




}
/// @nodoc
class __$NameCandidateCopyWithImpl<$Res>
    implements _$NameCandidateCopyWith<$Res> {
  __$NameCandidateCopyWithImpl(this._self, this._then);

  final _NameCandidate _self;
  final $Res Function(_NameCandidate) _then;

/// Create a copy of NameCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pregnancyId = null,Object? name = null,Object? meaning = freezed,Object? addedByUserId = null,Object? addedByCallName = freezed,Object? likedByMe = null,Object? likedByPartner = null,Object? chosen = null,}) {
  return _then(_NameCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pregnancyId: null == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,meaning: freezed == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String?,addedByUserId: null == addedByUserId ? _self.addedByUserId : addedByUserId // ignore: cast_nullable_to_non_nullable
as String,addedByCallName: freezed == addedByCallName ? _self.addedByCallName : addedByCallName // ignore: cast_nullable_to_non_nullable
as String?,likedByMe: null == likedByMe ? _self.likedByMe : likedByMe // ignore: cast_nullable_to_non_nullable
as bool,likedByPartner: null == likedByPartner ? _self.likedByPartner : likedByPartner // ignore: cast_nullable_to_non_nullable
as bool,chosen: null == chosen ? _self.chosen : chosen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
