// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bridge_share.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BridgeShare {

@JsonKey(name: 'userId') String get userId;@JsonKey(name: 'feelings') List<String> get feelings;@JsonKey(name: 'needs') List<String> get needs;@JsonKey(name: 'topic') String? get topic;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'understood') bool get understood;@JsonKey(name: 'readDone') bool get readDone;
/// Create a copy of BridgeShare
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BridgeShareCopyWith<BridgeShare> get copyWith => _$BridgeShareCopyWithImpl<BridgeShare>(this as BridgeShare, _$identity);

  /// Serializes this BridgeShare to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BridgeShare&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.feelings, feelings)&&const DeepCollectionEquality().equals(other.needs, needs)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.message, message) || other.message == message)&&(identical(other.understood, understood) || other.understood == understood)&&(identical(other.readDone, readDone) || other.readDone == readDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,const DeepCollectionEquality().hash(feelings),const DeepCollectionEquality().hash(needs),topic,message,understood,readDone);

@override
String toString() {
  return 'BridgeShare(userId: $userId, feelings: $feelings, needs: $needs, topic: $topic, message: $message, understood: $understood, readDone: $readDone)';
}


}

/// @nodoc
abstract mixin class $BridgeShareCopyWith<$Res>  {
  factory $BridgeShareCopyWith(BridgeShare value, $Res Function(BridgeShare) _then) = _$BridgeShareCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'userId') String userId,@JsonKey(name: 'feelings') List<String> feelings,@JsonKey(name: 'needs') List<String> needs,@JsonKey(name: 'topic') String? topic,@JsonKey(name: 'message') String? message,@JsonKey(name: 'understood') bool understood,@JsonKey(name: 'readDone') bool readDone
});




}
/// @nodoc
class _$BridgeShareCopyWithImpl<$Res>
    implements $BridgeShareCopyWith<$Res> {
  _$BridgeShareCopyWithImpl(this._self, this._then);

  final BridgeShare _self;
  final $Res Function(BridgeShare) _then;

/// Create a copy of BridgeShare
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? feelings = null,Object? needs = null,Object? topic = freezed,Object? message = freezed,Object? understood = null,Object? readDone = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,feelings: null == feelings ? _self.feelings : feelings // ignore: cast_nullable_to_non_nullable
as List<String>,needs: null == needs ? _self.needs : needs // ignore: cast_nullable_to_non_nullable
as List<String>,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,understood: null == understood ? _self.understood : understood // ignore: cast_nullable_to_non_nullable
as bool,readDone: null == readDone ? _self.readDone : readDone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BridgeShare].
extension BridgeSharePatterns on BridgeShare {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BridgeShare value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BridgeShare() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BridgeShare value)  $default,){
final _that = this;
switch (_that) {
case _BridgeShare():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BridgeShare value)?  $default,){
final _that = this;
switch (_that) {
case _BridgeShare() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BridgeShare implements BridgeShare {
  const _BridgeShare({@JsonKey(name: 'userId') required this.userId, @JsonKey(name: 'feelings') final  List<String> feelings = const [], @JsonKey(name: 'needs') final  List<String> needs = const [], @JsonKey(name: 'topic') this.topic, @JsonKey(name: 'message') this.message, @JsonKey(name: 'understood') this.understood = false, @JsonKey(name: 'readDone') this.readDone = false}): _feelings = feelings,_needs = needs;
  factory _BridgeShare.fromJson(Map<String, dynamic> json) => _$BridgeShareFromJson(json);

@override@JsonKey(name: 'userId') final  String userId;
 final  List<String> _feelings;
@override@JsonKey(name: 'feelings') List<String> get feelings {
  if (_feelings is EqualUnmodifiableListView) return _feelings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feelings);
}

 final  List<String> _needs;
@override@JsonKey(name: 'needs') List<String> get needs {
  if (_needs is EqualUnmodifiableListView) return _needs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_needs);
}

@override@JsonKey(name: 'topic') final  String? topic;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'understood') final  bool understood;
@override@JsonKey(name: 'readDone') final  bool readDone;

/// Create a copy of BridgeShare
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BridgeShareCopyWith<_BridgeShare> get copyWith => __$BridgeShareCopyWithImpl<_BridgeShare>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BridgeShareToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BridgeShare&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._feelings, _feelings)&&const DeepCollectionEquality().equals(other._needs, _needs)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.message, message) || other.message == message)&&(identical(other.understood, understood) || other.understood == understood)&&(identical(other.readDone, readDone) || other.readDone == readDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,const DeepCollectionEquality().hash(_feelings),const DeepCollectionEquality().hash(_needs),topic,message,understood,readDone);

@override
String toString() {
  return 'BridgeShare(userId: $userId, feelings: $feelings, needs: $needs, topic: $topic, message: $message, understood: $understood, readDone: $readDone)';
}


}

/// @nodoc
abstract mixin class _$BridgeShareCopyWith<$Res> implements $BridgeShareCopyWith<$Res> {
  factory _$BridgeShareCopyWith(_BridgeShare value, $Res Function(_BridgeShare) _then) = __$BridgeShareCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'userId') String userId,@JsonKey(name: 'feelings') List<String> feelings,@JsonKey(name: 'needs') List<String> needs,@JsonKey(name: 'topic') String? topic,@JsonKey(name: 'message') String? message,@JsonKey(name: 'understood') bool understood,@JsonKey(name: 'readDone') bool readDone
});




}
/// @nodoc
class __$BridgeShareCopyWithImpl<$Res>
    implements _$BridgeShareCopyWith<$Res> {
  __$BridgeShareCopyWithImpl(this._self, this._then);

  final _BridgeShare _self;
  final $Res Function(_BridgeShare) _then;

/// Create a copy of BridgeShare
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? feelings = null,Object? needs = null,Object? topic = freezed,Object? message = freezed,Object? understood = null,Object? readDone = null,}) {
  return _then(_BridgeShare(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,feelings: null == feelings ? _self._feelings : feelings // ignore: cast_nullable_to_non_nullable
as List<String>,needs: null == needs ? _self._needs : needs // ignore: cast_nullable_to_non_nullable
as List<String>,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,understood: null == understood ? _self.understood : understood // ignore: cast_nullable_to_non_nullable
as bool,readDone: null == readDone ? _self.readDone : readDone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
