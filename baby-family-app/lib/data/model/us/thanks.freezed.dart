// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thanks.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Thanks {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'fromUserId') String get fromUserId;@JsonKey(name: 'toUserId') String get toUserId;@JsonKey(name: 'body') String get body;@JsonKey(name: 'sticker') String? get sticker;@JsonKey(name: 'missionId') String? get missionId;@JsonKey(name: 'memoryId') String? get memoryId;@JsonKey(name: 'createdAt') DateTime get createdAt;@JsonKey(name: 'postedToFamily') bool get postedToFamily;/// Người gửi đề nghị đăng thành khoảnh khắc gia đình, chờ bạn đời duyệt.
@JsonKey(name: 'shareRequested') bool get shareRequested;/// Icon Lucide của thẻ trên bức tường cảm ơn (US-06).
@JsonKey(name: 'icon') String? get icon;/// Tên việc/ký ức được gắn (“Thư gửi Hana”).
@JsonKey(name: 'linkedTitle') String? get linkedTitle;/// Ai đã thả tim lời cảm ơn này.
@JsonKey(name: 'reactedByUserIds') List<String> get reactedByUserIds;
/// Create a copy of Thanks
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThanksCopyWith<Thanks> get copyWith => _$ThanksCopyWithImpl<Thanks>(this as Thanks, _$identity);

  /// Serializes this Thanks to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Thanks&&(identical(other.id, id) || other.id == id)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.body, body) || other.body == body)&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.missionId, missionId) || other.missionId == missionId)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.postedToFamily, postedToFamily) || other.postedToFamily == postedToFamily)&&(identical(other.shareRequested, shareRequested) || other.shareRequested == shareRequested)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.linkedTitle, linkedTitle) || other.linkedTitle == linkedTitle)&&const DeepCollectionEquality().equals(other.reactedByUserIds, reactedByUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromUserId,toUserId,body,sticker,missionId,memoryId,createdAt,postedToFamily,shareRequested,icon,linkedTitle,const DeepCollectionEquality().hash(reactedByUserIds));

@override
String toString() {
  return 'Thanks(id: $id, fromUserId: $fromUserId, toUserId: $toUserId, body: $body, sticker: $sticker, missionId: $missionId, memoryId: $memoryId, createdAt: $createdAt, postedToFamily: $postedToFamily, shareRequested: $shareRequested, icon: $icon, linkedTitle: $linkedTitle, reactedByUserIds: $reactedByUserIds)';
}


}

/// @nodoc
abstract mixin class $ThanksCopyWith<$Res>  {
  factory $ThanksCopyWith(Thanks value, $Res Function(Thanks) _then) = _$ThanksCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'fromUserId') String fromUserId,@JsonKey(name: 'toUserId') String toUserId,@JsonKey(name: 'body') String body,@JsonKey(name: 'sticker') String? sticker,@JsonKey(name: 'missionId') String? missionId,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'postedToFamily') bool postedToFamily,@JsonKey(name: 'shareRequested') bool shareRequested,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'linkedTitle') String? linkedTitle,@JsonKey(name: 'reactedByUserIds') List<String> reactedByUserIds
});




}
/// @nodoc
class _$ThanksCopyWithImpl<$Res>
    implements $ThanksCopyWith<$Res> {
  _$ThanksCopyWithImpl(this._self, this._then);

  final Thanks _self;
  final $Res Function(Thanks) _then;

/// Create a copy of Thanks
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromUserId = null,Object? toUserId = null,Object? body = null,Object? sticker = freezed,Object? missionId = freezed,Object? memoryId = freezed,Object? createdAt = null,Object? postedToFamily = null,Object? shareRequested = null,Object? icon = freezed,Object? linkedTitle = freezed,Object? reactedByUserIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sticker: freezed == sticker ? _self.sticker : sticker // ignore: cast_nullable_to_non_nullable
as String?,missionId: freezed == missionId ? _self.missionId : missionId // ignore: cast_nullable_to_non_nullable
as String?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,postedToFamily: null == postedToFamily ? _self.postedToFamily : postedToFamily // ignore: cast_nullable_to_non_nullable
as bool,shareRequested: null == shareRequested ? _self.shareRequested : shareRequested // ignore: cast_nullable_to_non_nullable
as bool,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,linkedTitle: freezed == linkedTitle ? _self.linkedTitle : linkedTitle // ignore: cast_nullable_to_non_nullable
as String?,reactedByUserIds: null == reactedByUserIds ? _self.reactedByUserIds : reactedByUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Thanks].
extension ThanksPatterns on Thanks {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Thanks value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Thanks() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Thanks value)  $default,){
final _that = this;
switch (_that) {
case _Thanks():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Thanks value)?  $default,){
final _that = this;
switch (_that) {
case _Thanks() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Thanks implements Thanks {
  const _Thanks({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'fromUserId') required this.fromUserId, @JsonKey(name: 'toUserId') required this.toUserId, @JsonKey(name: 'body') this.body = '', @JsonKey(name: 'sticker') this.sticker, @JsonKey(name: 'missionId') this.missionId, @JsonKey(name: 'memoryId') this.memoryId, @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'postedToFamily') this.postedToFamily = false, @JsonKey(name: 'shareRequested') this.shareRequested = false, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'linkedTitle') this.linkedTitle, @JsonKey(name: 'reactedByUserIds') final  List<String> reactedByUserIds = const []}): _reactedByUserIds = reactedByUserIds;
  factory _Thanks.fromJson(Map<String, dynamic> json) => _$ThanksFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'fromUserId') final  String fromUserId;
@override@JsonKey(name: 'toUserId') final  String toUserId;
@override@JsonKey(name: 'body') final  String body;
@override@JsonKey(name: 'sticker') final  String? sticker;
@override@JsonKey(name: 'missionId') final  String? missionId;
@override@JsonKey(name: 'memoryId') final  String? memoryId;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;
@override@JsonKey(name: 'postedToFamily') final  bool postedToFamily;
/// Người gửi đề nghị đăng thành khoảnh khắc gia đình, chờ bạn đời duyệt.
@override@JsonKey(name: 'shareRequested') final  bool shareRequested;
/// Icon Lucide của thẻ trên bức tường cảm ơn (US-06).
@override@JsonKey(name: 'icon') final  String? icon;
/// Tên việc/ký ức được gắn (“Thư gửi Hana”).
@override@JsonKey(name: 'linkedTitle') final  String? linkedTitle;
/// Ai đã thả tim lời cảm ơn này.
 final  List<String> _reactedByUserIds;
/// Ai đã thả tim lời cảm ơn này.
@override@JsonKey(name: 'reactedByUserIds') List<String> get reactedByUserIds {
  if (_reactedByUserIds is EqualUnmodifiableListView) return _reactedByUserIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reactedByUserIds);
}


/// Create a copy of Thanks
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThanksCopyWith<_Thanks> get copyWith => __$ThanksCopyWithImpl<_Thanks>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ThanksToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Thanks&&(identical(other.id, id) || other.id == id)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.body, body) || other.body == body)&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.missionId, missionId) || other.missionId == missionId)&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.postedToFamily, postedToFamily) || other.postedToFamily == postedToFamily)&&(identical(other.shareRequested, shareRequested) || other.shareRequested == shareRequested)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.linkedTitle, linkedTitle) || other.linkedTitle == linkedTitle)&&const DeepCollectionEquality().equals(other._reactedByUserIds, _reactedByUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromUserId,toUserId,body,sticker,missionId,memoryId,createdAt,postedToFamily,shareRequested,icon,linkedTitle,const DeepCollectionEquality().hash(_reactedByUserIds));

@override
String toString() {
  return 'Thanks(id: $id, fromUserId: $fromUserId, toUserId: $toUserId, body: $body, sticker: $sticker, missionId: $missionId, memoryId: $memoryId, createdAt: $createdAt, postedToFamily: $postedToFamily, shareRequested: $shareRequested, icon: $icon, linkedTitle: $linkedTitle, reactedByUserIds: $reactedByUserIds)';
}


}

/// @nodoc
abstract mixin class _$ThanksCopyWith<$Res> implements $ThanksCopyWith<$Res> {
  factory _$ThanksCopyWith(_Thanks value, $Res Function(_Thanks) _then) = __$ThanksCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'fromUserId') String fromUserId,@JsonKey(name: 'toUserId') String toUserId,@JsonKey(name: 'body') String body,@JsonKey(name: 'sticker') String? sticker,@JsonKey(name: 'missionId') String? missionId,@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'postedToFamily') bool postedToFamily,@JsonKey(name: 'shareRequested') bool shareRequested,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'linkedTitle') String? linkedTitle,@JsonKey(name: 'reactedByUserIds') List<String> reactedByUserIds
});




}
/// @nodoc
class __$ThanksCopyWithImpl<$Res>
    implements _$ThanksCopyWith<$Res> {
  __$ThanksCopyWithImpl(this._self, this._then);

  final _Thanks _self;
  final $Res Function(_Thanks) _then;

/// Create a copy of Thanks
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromUserId = null,Object? toUserId = null,Object? body = null,Object? sticker = freezed,Object? missionId = freezed,Object? memoryId = freezed,Object? createdAt = null,Object? postedToFamily = null,Object? shareRequested = null,Object? icon = freezed,Object? linkedTitle = freezed,Object? reactedByUserIds = null,}) {
  return _then(_Thanks(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sticker: freezed == sticker ? _self.sticker : sticker // ignore: cast_nullable_to_non_nullable
as String?,missionId: freezed == missionId ? _self.missionId : missionId // ignore: cast_nullable_to_non_nullable
as String?,memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,postedToFamily: null == postedToFamily ? _self.postedToFamily : postedToFamily // ignore: cast_nullable_to_non_nullable
as bool,shareRequested: null == shareRequested ? _self.shareRequested : shareRequested // ignore: cast_nullable_to_non_nullable
as bool,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,linkedTitle: freezed == linkedTitle ? _self.linkedTitle : linkedTitle // ignore: cast_nullable_to_non_nullable
as String?,reactedByUserIds: null == reactedByUserIds ? _self._reactedByUserIds : reactedByUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
