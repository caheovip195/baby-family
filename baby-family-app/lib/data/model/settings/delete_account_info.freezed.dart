// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_account_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteAccountInfo {

@JsonKey(name: 'userName') String get userName;@JsonKey(name: 'partnerName') String? get partnerName;@JsonKey(name: 'partnerCallName') String? get partnerCallName;@JsonKey(name: 'familyName') String get familyName;@JsonKey(name: 'childNames') List<String> get childNames;@JsonKey(name: 'postedMemories') int get postedMemories;@JsonKey(name: 'onlyParent') bool get onlyParent;@JsonKey(name: 'maskedAppleAccount') String? get maskedAppleAccount;@JsonKey(name: 'maskedPhone') String? get maskedPhone;@JsonKey(name: 'purgeDate') DateTime get purgeDate;
/// Create a copy of DeleteAccountInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteAccountInfoCopyWith<DeleteAccountInfo> get copyWith => _$DeleteAccountInfoCopyWithImpl<DeleteAccountInfo>(this as DeleteAccountInfo, _$identity);

  /// Serializes this DeleteAccountInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAccountInfo&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.partnerName, partnerName) || other.partnerName == partnerName)&&(identical(other.partnerCallName, partnerCallName) || other.partnerCallName == partnerCallName)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&const DeepCollectionEquality().equals(other.childNames, childNames)&&(identical(other.postedMemories, postedMemories) || other.postedMemories == postedMemories)&&(identical(other.onlyParent, onlyParent) || other.onlyParent == onlyParent)&&(identical(other.maskedAppleAccount, maskedAppleAccount) || other.maskedAppleAccount == maskedAppleAccount)&&(identical(other.maskedPhone, maskedPhone) || other.maskedPhone == maskedPhone)&&(identical(other.purgeDate, purgeDate) || other.purgeDate == purgeDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userName,partnerName,partnerCallName,familyName,const DeepCollectionEquality().hash(childNames),postedMemories,onlyParent,maskedAppleAccount,maskedPhone,purgeDate);

@override
String toString() {
  return 'DeleteAccountInfo(userName: $userName, partnerName: $partnerName, partnerCallName: $partnerCallName, familyName: $familyName, childNames: $childNames, postedMemories: $postedMemories, onlyParent: $onlyParent, maskedAppleAccount: $maskedAppleAccount, maskedPhone: $maskedPhone, purgeDate: $purgeDate)';
}


}

/// @nodoc
abstract mixin class $DeleteAccountInfoCopyWith<$Res>  {
  factory $DeleteAccountInfoCopyWith(DeleteAccountInfo value, $Res Function(DeleteAccountInfo) _then) = _$DeleteAccountInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'userName') String userName,@JsonKey(name: 'partnerName') String? partnerName,@JsonKey(name: 'partnerCallName') String? partnerCallName,@JsonKey(name: 'familyName') String familyName,@JsonKey(name: 'childNames') List<String> childNames,@JsonKey(name: 'postedMemories') int postedMemories,@JsonKey(name: 'onlyParent') bool onlyParent,@JsonKey(name: 'maskedAppleAccount') String? maskedAppleAccount,@JsonKey(name: 'maskedPhone') String? maskedPhone,@JsonKey(name: 'purgeDate') DateTime purgeDate
});




}
/// @nodoc
class _$DeleteAccountInfoCopyWithImpl<$Res>
    implements $DeleteAccountInfoCopyWith<$Res> {
  _$DeleteAccountInfoCopyWithImpl(this._self, this._then);

  final DeleteAccountInfo _self;
  final $Res Function(DeleteAccountInfo) _then;

/// Create a copy of DeleteAccountInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userName = null,Object? partnerName = freezed,Object? partnerCallName = freezed,Object? familyName = null,Object? childNames = null,Object? postedMemories = null,Object? onlyParent = null,Object? maskedAppleAccount = freezed,Object? maskedPhone = freezed,Object? purgeDate = null,}) {
  return _then(_self.copyWith(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,partnerName: freezed == partnerName ? _self.partnerName : partnerName // ignore: cast_nullable_to_non_nullable
as String?,partnerCallName: freezed == partnerCallName ? _self.partnerCallName : partnerCallName // ignore: cast_nullable_to_non_nullable
as String?,familyName: null == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String,childNames: null == childNames ? _self.childNames : childNames // ignore: cast_nullable_to_non_nullable
as List<String>,postedMemories: null == postedMemories ? _self.postedMemories : postedMemories // ignore: cast_nullable_to_non_nullable
as int,onlyParent: null == onlyParent ? _self.onlyParent : onlyParent // ignore: cast_nullable_to_non_nullable
as bool,maskedAppleAccount: freezed == maskedAppleAccount ? _self.maskedAppleAccount : maskedAppleAccount // ignore: cast_nullable_to_non_nullable
as String?,maskedPhone: freezed == maskedPhone ? _self.maskedPhone : maskedPhone // ignore: cast_nullable_to_non_nullable
as String?,purgeDate: null == purgeDate ? _self.purgeDate : purgeDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DeleteAccountInfo].
extension DeleteAccountInfoPatterns on DeleteAccountInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeleteAccountInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeleteAccountInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeleteAccountInfo value)  $default,){
final _that = this;
switch (_that) {
case _DeleteAccountInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeleteAccountInfo value)?  $default,){
final _that = this;
switch (_that) {
case _DeleteAccountInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DeleteAccountInfo implements DeleteAccountInfo {
  const _DeleteAccountInfo({@JsonKey(name: 'userName') this.userName = '', @JsonKey(name: 'partnerName') this.partnerName, @JsonKey(name: 'partnerCallName') this.partnerCallName, @JsonKey(name: 'familyName') this.familyName = '', @JsonKey(name: 'childNames') final  List<String> childNames = const [], @JsonKey(name: 'postedMemories') this.postedMemories = 0, @JsonKey(name: 'onlyParent') this.onlyParent = false, @JsonKey(name: 'maskedAppleAccount') this.maskedAppleAccount, @JsonKey(name: 'maskedPhone') this.maskedPhone, @JsonKey(name: 'purgeDate') required this.purgeDate}): _childNames = childNames;
  factory _DeleteAccountInfo.fromJson(Map<String, dynamic> json) => _$DeleteAccountInfoFromJson(json);

@override@JsonKey(name: 'userName') final  String userName;
@override@JsonKey(name: 'partnerName') final  String? partnerName;
@override@JsonKey(name: 'partnerCallName') final  String? partnerCallName;
@override@JsonKey(name: 'familyName') final  String familyName;
 final  List<String> _childNames;
@override@JsonKey(name: 'childNames') List<String> get childNames {
  if (_childNames is EqualUnmodifiableListView) return _childNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childNames);
}

@override@JsonKey(name: 'postedMemories') final  int postedMemories;
@override@JsonKey(name: 'onlyParent') final  bool onlyParent;
@override@JsonKey(name: 'maskedAppleAccount') final  String? maskedAppleAccount;
@override@JsonKey(name: 'maskedPhone') final  String? maskedPhone;
@override@JsonKey(name: 'purgeDate') final  DateTime purgeDate;

/// Create a copy of DeleteAccountInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteAccountInfoCopyWith<_DeleteAccountInfo> get copyWith => __$DeleteAccountInfoCopyWithImpl<_DeleteAccountInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeleteAccountInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteAccountInfo&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.partnerName, partnerName) || other.partnerName == partnerName)&&(identical(other.partnerCallName, partnerCallName) || other.partnerCallName == partnerCallName)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&const DeepCollectionEquality().equals(other._childNames, _childNames)&&(identical(other.postedMemories, postedMemories) || other.postedMemories == postedMemories)&&(identical(other.onlyParent, onlyParent) || other.onlyParent == onlyParent)&&(identical(other.maskedAppleAccount, maskedAppleAccount) || other.maskedAppleAccount == maskedAppleAccount)&&(identical(other.maskedPhone, maskedPhone) || other.maskedPhone == maskedPhone)&&(identical(other.purgeDate, purgeDate) || other.purgeDate == purgeDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userName,partnerName,partnerCallName,familyName,const DeepCollectionEquality().hash(_childNames),postedMemories,onlyParent,maskedAppleAccount,maskedPhone,purgeDate);

@override
String toString() {
  return 'DeleteAccountInfo(userName: $userName, partnerName: $partnerName, partnerCallName: $partnerCallName, familyName: $familyName, childNames: $childNames, postedMemories: $postedMemories, onlyParent: $onlyParent, maskedAppleAccount: $maskedAppleAccount, maskedPhone: $maskedPhone, purgeDate: $purgeDate)';
}


}

/// @nodoc
abstract mixin class _$DeleteAccountInfoCopyWith<$Res> implements $DeleteAccountInfoCopyWith<$Res> {
  factory _$DeleteAccountInfoCopyWith(_DeleteAccountInfo value, $Res Function(_DeleteAccountInfo) _then) = __$DeleteAccountInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'userName') String userName,@JsonKey(name: 'partnerName') String? partnerName,@JsonKey(name: 'partnerCallName') String? partnerCallName,@JsonKey(name: 'familyName') String familyName,@JsonKey(name: 'childNames') List<String> childNames,@JsonKey(name: 'postedMemories') int postedMemories,@JsonKey(name: 'onlyParent') bool onlyParent,@JsonKey(name: 'maskedAppleAccount') String? maskedAppleAccount,@JsonKey(name: 'maskedPhone') String? maskedPhone,@JsonKey(name: 'purgeDate') DateTime purgeDate
});




}
/// @nodoc
class __$DeleteAccountInfoCopyWithImpl<$Res>
    implements _$DeleteAccountInfoCopyWith<$Res> {
  __$DeleteAccountInfoCopyWithImpl(this._self, this._then);

  final _DeleteAccountInfo _self;
  final $Res Function(_DeleteAccountInfo) _then;

/// Create a copy of DeleteAccountInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userName = null,Object? partnerName = freezed,Object? partnerCallName = freezed,Object? familyName = null,Object? childNames = null,Object? postedMemories = null,Object? onlyParent = null,Object? maskedAppleAccount = freezed,Object? maskedPhone = freezed,Object? purgeDate = null,}) {
  return _then(_DeleteAccountInfo(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,partnerName: freezed == partnerName ? _self.partnerName : partnerName // ignore: cast_nullable_to_non_nullable
as String?,partnerCallName: freezed == partnerCallName ? _self.partnerCallName : partnerCallName // ignore: cast_nullable_to_non_nullable
as String?,familyName: null == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String,childNames: null == childNames ? _self._childNames : childNames // ignore: cast_nullable_to_non_nullable
as List<String>,postedMemories: null == postedMemories ? _self.postedMemories : postedMemories // ignore: cast_nullable_to_non_nullable
as int,onlyParent: null == onlyParent ? _self.onlyParent : onlyParent // ignore: cast_nullable_to_non_nullable
as bool,maskedAppleAccount: freezed == maskedAppleAccount ? _self.maskedAppleAccount : maskedAppleAccount // ignore: cast_nullable_to_non_nullable
as String?,maskedPhone: freezed == maskedPhone ? _self.maskedPhone : maskedPhone // ignore: cast_nullable_to_non_nullable
as String?,purgeDate: null == purgeDate ? _self.purgeDate : purgeDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
