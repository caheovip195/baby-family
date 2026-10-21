// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_ticket_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupportTicketDetail {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'code') String? get code;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'category') String? get category;@JsonKey(name: 'subject') String get subject;@JsonKey(name: 'body') String get body;@JsonKey(name: 'messages') List<SupportMessage> get messages;
/// Create a copy of SupportTicketDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportTicketDetailCopyWith<SupportTicketDetail> get copyWith => _$SupportTicketDetailCopyWithImpl<SupportTicketDetail>(this as SupportTicketDetail, _$identity);

  /// Serializes this SupportTicketDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportTicketDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.category, category) || other.category == category)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.messages, messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,status,createdAt,category,subject,body,const DeepCollectionEquality().hash(messages));

@override
String toString() {
  return 'SupportTicketDetail(id: $id, code: $code, status: $status, createdAt: $createdAt, category: $category, subject: $subject, body: $body, messages: $messages)';
}


}

/// @nodoc
abstract mixin class $SupportTicketDetailCopyWith<$Res>  {
  factory $SupportTicketDetailCopyWith(SupportTicketDetail value, $Res Function(SupportTicketDetail) _then) = _$SupportTicketDetailCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'code') String? code,@JsonKey(name: 'status') String? status,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'category') String? category,@JsonKey(name: 'subject') String subject,@JsonKey(name: 'body') String body,@JsonKey(name: 'messages') List<SupportMessage> messages
});




}
/// @nodoc
class _$SupportTicketDetailCopyWithImpl<$Res>
    implements $SupportTicketDetailCopyWith<$Res> {
  _$SupportTicketDetailCopyWithImpl(this._self, this._then);

  final SupportTicketDetail _self;
  final $Res Function(SupportTicketDetail) _then;

/// Create a copy of SupportTicketDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? code = freezed,Object? status = freezed,Object? createdAt = freezed,Object? category = freezed,Object? subject = null,Object? body = null,Object? messages = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<SupportMessage>,
  ));
}

}


/// Adds pattern-matching-related methods to [SupportTicketDetail].
extension SupportTicketDetailPatterns on SupportTicketDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportTicketDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportTicketDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportTicketDetail value)  $default,){
final _that = this;
switch (_that) {
case _SupportTicketDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportTicketDetail value)?  $default,){
final _that = this;
switch (_that) {
case _SupportTicketDetail() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SupportTicketDetail implements SupportTicketDetail {
  const _SupportTicketDetail({@JsonKey(name: 'id') this.id, @JsonKey(name: 'code') this.code, @JsonKey(name: 'status') this.status, @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'category') this.category, @JsonKey(name: 'subject') this.subject = '', @JsonKey(name: 'body') this.body = '', @JsonKey(name: 'messages') final  List<SupportMessage> messages = const <SupportMessage>[]}): _messages = messages;
  factory _SupportTicketDetail.fromJson(Map<String, dynamic> json) => _$SupportTicketDetailFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'code') final  String? code;
@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
@override@JsonKey(name: 'category') final  String? category;
@override@JsonKey(name: 'subject') final  String subject;
@override@JsonKey(name: 'body') final  String body;
 final  List<SupportMessage> _messages;
@override@JsonKey(name: 'messages') List<SupportMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of SupportTicketDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportTicketDetailCopyWith<_SupportTicketDetail> get copyWith => __$SupportTicketDetailCopyWithImpl<_SupportTicketDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupportTicketDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportTicketDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.category, category) || other.category == category)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._messages, _messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,status,createdAt,category,subject,body,const DeepCollectionEquality().hash(_messages));

@override
String toString() {
  return 'SupportTicketDetail(id: $id, code: $code, status: $status, createdAt: $createdAt, category: $category, subject: $subject, body: $body, messages: $messages)';
}


}

/// @nodoc
abstract mixin class _$SupportTicketDetailCopyWith<$Res> implements $SupportTicketDetailCopyWith<$Res> {
  factory _$SupportTicketDetailCopyWith(_SupportTicketDetail value, $Res Function(_SupportTicketDetail) _then) = __$SupportTicketDetailCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'code') String? code,@JsonKey(name: 'status') String? status,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'category') String? category,@JsonKey(name: 'subject') String subject,@JsonKey(name: 'body') String body,@JsonKey(name: 'messages') List<SupportMessage> messages
});




}
/// @nodoc
class __$SupportTicketDetailCopyWithImpl<$Res>
    implements _$SupportTicketDetailCopyWith<$Res> {
  __$SupportTicketDetailCopyWithImpl(this._self, this._then);

  final _SupportTicketDetail _self;
  final $Res Function(_SupportTicketDetail) _then;

/// Create a copy of SupportTicketDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? code = freezed,Object? status = freezed,Object? createdAt = freezed,Object? category = freezed,Object? subject = null,Object? body = null,Object? messages = null,}) {
  return _then(_SupportTicketDetail(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<SupportMessage>,
  ));
}


}


/// @nodoc
mixin _$SupportMessage {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'sender') String? get sender;@JsonKey(name: 'body') String get body;@JsonKey(name: 'createdAt') DateTime? get createdAt;
/// Create a copy of SupportMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportMessageCopyWith<SupportMessage> get copyWith => _$SupportMessageCopyWithImpl<SupportMessage>(this as SupportMessage, _$identity);

  /// Serializes this SupportMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sender,body,createdAt);

@override
String toString() {
  return 'SupportMessage(id: $id, sender: $sender, body: $body, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SupportMessageCopyWith<$Res>  {
  factory $SupportMessageCopyWith(SupportMessage value, $Res Function(SupportMessage) _then) = _$SupportMessageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'sender') String? sender,@JsonKey(name: 'body') String body,@JsonKey(name: 'createdAt') DateTime? createdAt
});




}
/// @nodoc
class _$SupportMessageCopyWithImpl<$Res>
    implements $SupportMessageCopyWith<$Res> {
  _$SupportMessageCopyWithImpl(this._self, this._then);

  final SupportMessage _self;
  final $Res Function(SupportMessage) _then;

/// Create a copy of SupportMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? sender = freezed,Object? body = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,sender: freezed == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String?,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SupportMessage].
extension SupportMessagePatterns on SupportMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportMessage value)  $default,){
final _that = this;
switch (_that) {
case _SupportMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportMessage value)?  $default,){
final _that = this;
switch (_that) {
case _SupportMessage() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SupportMessage implements SupportMessage {
  const _SupportMessage({@JsonKey(name: 'id') this.id, @JsonKey(name: 'sender') this.sender, @JsonKey(name: 'body') this.body = '', @JsonKey(name: 'createdAt') this.createdAt});
  factory _SupportMessage.fromJson(Map<String, dynamic> json) => _$SupportMessageFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'sender') final  String? sender;
@override@JsonKey(name: 'body') final  String body;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;

/// Create a copy of SupportMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportMessageCopyWith<_SupportMessage> get copyWith => __$SupportMessageCopyWithImpl<_SupportMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupportMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sender,body,createdAt);

@override
String toString() {
  return 'SupportMessage(id: $id, sender: $sender, body: $body, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SupportMessageCopyWith<$Res> implements $SupportMessageCopyWith<$Res> {
  factory _$SupportMessageCopyWith(_SupportMessage value, $Res Function(_SupportMessage) _then) = __$SupportMessageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'sender') String? sender,@JsonKey(name: 'body') String body,@JsonKey(name: 'createdAt') DateTime? createdAt
});




}
/// @nodoc
class __$SupportMessageCopyWithImpl<$Res>
    implements _$SupportMessageCopyWith<$Res> {
  __$SupportMessageCopyWithImpl(this._self, this._then);

  final _SupportMessage _self;
  final $Res Function(_SupportMessage) _then;

/// Create a copy of SupportMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? sender = freezed,Object? body = null,Object? createdAt = freezed,}) {
  return _then(_SupportMessage(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,sender: freezed == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String?,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
