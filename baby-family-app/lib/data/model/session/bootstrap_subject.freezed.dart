// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bootstrap_subject.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BootstrapSubject {

@JsonKey(name: 'type') String? get type;@JsonKey(name: 'id') String? get id;@JsonKey(name: 'displayName') String? get displayName;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'nickname') String? get nickname;@JsonKey(name: 'birthDate') DateTime? get birthDate;@JsonKey(name: 'dueDate') DateTime? get dueDate;@JsonKey(name: 'colorIndex') int? get colorIndex;@JsonKey(name: 'gender') String? get gender;@JsonKey(name: 'expectedCount') int? get expectedCount;@JsonKey(name: 'seqNo') int? get seqNo;@JsonKey(name: 'status') String? get status;/// URL ký ngắn hạn của ảnh đại diện / ảnh bìa bé (null khi chưa có).
@JsonKey(name: 'avatarUrl') String? get avatarUrl;@JsonKey(name: 'coverUrl') String? get coverUrl;
/// Create a copy of BootstrapSubject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BootstrapSubjectCopyWith<BootstrapSubject> get copyWith => _$BootstrapSubjectCopyWithImpl<BootstrapSubject>(this as BootstrapSubject, _$identity);

  /// Serializes this BootstrapSubject to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BootstrapSubject&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.name, name) || other.name == name)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.expectedCount, expectedCount) || other.expectedCount == expectedCount)&&(identical(other.seqNo, seqNo) || other.seqNo == seqNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,id,displayName,name,nickname,birthDate,dueDate,colorIndex,gender,expectedCount,seqNo,status,avatarUrl,coverUrl);

@override
String toString() {
  return 'BootstrapSubject(type: $type, id: $id, displayName: $displayName, name: $name, nickname: $nickname, birthDate: $birthDate, dueDate: $dueDate, colorIndex: $colorIndex, gender: $gender, expectedCount: $expectedCount, seqNo: $seqNo, status: $status, avatarUrl: $avatarUrl, coverUrl: $coverUrl)';
}


}

/// @nodoc
abstract mixin class $BootstrapSubjectCopyWith<$Res>  {
  factory $BootstrapSubjectCopyWith(BootstrapSubject value, $Res Function(BootstrapSubject) _then) = _$BootstrapSubjectCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'id') String? id,@JsonKey(name: 'displayName') String? displayName,@JsonKey(name: 'name') String? name,@JsonKey(name: 'nickname') String? nickname,@JsonKey(name: 'birthDate') DateTime? birthDate,@JsonKey(name: 'dueDate') DateTime? dueDate,@JsonKey(name: 'colorIndex') int? colorIndex,@JsonKey(name: 'gender') String? gender,@JsonKey(name: 'expectedCount') int? expectedCount,@JsonKey(name: 'seqNo') int? seqNo,@JsonKey(name: 'status') String? status,@JsonKey(name: 'avatarUrl') String? avatarUrl,@JsonKey(name: 'coverUrl') String? coverUrl
});




}
/// @nodoc
class _$BootstrapSubjectCopyWithImpl<$Res>
    implements $BootstrapSubjectCopyWith<$Res> {
  _$BootstrapSubjectCopyWithImpl(this._self, this._then);

  final BootstrapSubject _self;
  final $Res Function(BootstrapSubject) _then;

/// Create a copy of BootstrapSubject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? id = freezed,Object? displayName = freezed,Object? name = freezed,Object? nickname = freezed,Object? birthDate = freezed,Object? dueDate = freezed,Object? colorIndex = freezed,Object? gender = freezed,Object? expectedCount = freezed,Object? seqNo = freezed,Object? status = freezed,Object? avatarUrl = freezed,Object? coverUrl = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,colorIndex: freezed == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,expectedCount: freezed == expectedCount ? _self.expectedCount : expectedCount // ignore: cast_nullable_to_non_nullable
as int?,seqNo: freezed == seqNo ? _self.seqNo : seqNo // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BootstrapSubject].
extension BootstrapSubjectPatterns on BootstrapSubject {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BootstrapSubject value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BootstrapSubject() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BootstrapSubject value)  $default,){
final _that = this;
switch (_that) {
case _BootstrapSubject():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BootstrapSubject value)?  $default,){
final _that = this;
switch (_that) {
case _BootstrapSubject() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BootstrapSubject implements BootstrapSubject {
  const _BootstrapSubject({@JsonKey(name: 'type') this.type, @JsonKey(name: 'id') this.id, @JsonKey(name: 'displayName') this.displayName, @JsonKey(name: 'name') this.name, @JsonKey(name: 'nickname') this.nickname, @JsonKey(name: 'birthDate') this.birthDate, @JsonKey(name: 'dueDate') this.dueDate, @JsonKey(name: 'colorIndex') this.colorIndex, @JsonKey(name: 'gender') this.gender, @JsonKey(name: 'expectedCount') this.expectedCount, @JsonKey(name: 'seqNo') this.seqNo, @JsonKey(name: 'status') this.status, @JsonKey(name: 'avatarUrl') this.avatarUrl, @JsonKey(name: 'coverUrl') this.coverUrl});
  factory _BootstrapSubject.fromJson(Map<String, dynamic> json) => _$BootstrapSubjectFromJson(json);

@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'displayName') final  String? displayName;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'nickname') final  String? nickname;
@override@JsonKey(name: 'birthDate') final  DateTime? birthDate;
@override@JsonKey(name: 'dueDate') final  DateTime? dueDate;
@override@JsonKey(name: 'colorIndex') final  int? colorIndex;
@override@JsonKey(name: 'gender') final  String? gender;
@override@JsonKey(name: 'expectedCount') final  int? expectedCount;
@override@JsonKey(name: 'seqNo') final  int? seqNo;
@override@JsonKey(name: 'status') final  String? status;
/// URL ký ngắn hạn của ảnh đại diện / ảnh bìa bé (null khi chưa có).
@override@JsonKey(name: 'avatarUrl') final  String? avatarUrl;
@override@JsonKey(name: 'coverUrl') final  String? coverUrl;

/// Create a copy of BootstrapSubject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BootstrapSubjectCopyWith<_BootstrapSubject> get copyWith => __$BootstrapSubjectCopyWithImpl<_BootstrapSubject>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BootstrapSubjectToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BootstrapSubject&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.name, name) || other.name == name)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.expectedCount, expectedCount) || other.expectedCount == expectedCount)&&(identical(other.seqNo, seqNo) || other.seqNo == seqNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,id,displayName,name,nickname,birthDate,dueDate,colorIndex,gender,expectedCount,seqNo,status,avatarUrl,coverUrl);

@override
String toString() {
  return 'BootstrapSubject(type: $type, id: $id, displayName: $displayName, name: $name, nickname: $nickname, birthDate: $birthDate, dueDate: $dueDate, colorIndex: $colorIndex, gender: $gender, expectedCount: $expectedCount, seqNo: $seqNo, status: $status, avatarUrl: $avatarUrl, coverUrl: $coverUrl)';
}


}

/// @nodoc
abstract mixin class _$BootstrapSubjectCopyWith<$Res> implements $BootstrapSubjectCopyWith<$Res> {
  factory _$BootstrapSubjectCopyWith(_BootstrapSubject value, $Res Function(_BootstrapSubject) _then) = __$BootstrapSubjectCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'id') String? id,@JsonKey(name: 'displayName') String? displayName,@JsonKey(name: 'name') String? name,@JsonKey(name: 'nickname') String? nickname,@JsonKey(name: 'birthDate') DateTime? birthDate,@JsonKey(name: 'dueDate') DateTime? dueDate,@JsonKey(name: 'colorIndex') int? colorIndex,@JsonKey(name: 'gender') String? gender,@JsonKey(name: 'expectedCount') int? expectedCount,@JsonKey(name: 'seqNo') int? seqNo,@JsonKey(name: 'status') String? status,@JsonKey(name: 'avatarUrl') String? avatarUrl,@JsonKey(name: 'coverUrl') String? coverUrl
});




}
/// @nodoc
class __$BootstrapSubjectCopyWithImpl<$Res>
    implements _$BootstrapSubjectCopyWith<$Res> {
  __$BootstrapSubjectCopyWithImpl(this._self, this._then);

  final _BootstrapSubject _self;
  final $Res Function(_BootstrapSubject) _then;

/// Create a copy of BootstrapSubject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? id = freezed,Object? displayName = freezed,Object? name = freezed,Object? nickname = freezed,Object? birthDate = freezed,Object? dueDate = freezed,Object? colorIndex = freezed,Object? gender = freezed,Object? expectedCount = freezed,Object? seqNo = freezed,Object? status = freezed,Object? avatarUrl = freezed,Object? coverUrl = freezed,}) {
  return _then(_BootstrapSubject(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,colorIndex: freezed == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,expectedCount: freezed == expectedCount ? _self.expectedCount : expectedCount // ignore: cast_nullable_to_non_nullable
as int?,seqNo: freezed == seqNo ? _self.seqNo : seqNo // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
