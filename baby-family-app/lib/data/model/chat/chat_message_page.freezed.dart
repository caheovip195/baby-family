// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessagePage {

@JsonKey(name: 'items', fromJson: chatMessageList) List<ChatMessage> get items;@JsonKey(name: 'hasMore') bool get hasMore;
/// Create a copy of ChatMessagePage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessagePageCopyWith<ChatMessagePage> get copyWith => _$ChatMessagePageCopyWithImpl<ChatMessagePage>(this as ChatMessagePage, _$identity);

  /// Serializes this ChatMessagePage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessagePage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),hasMore);

@override
String toString() {
  return 'ChatMessagePage(items: $items, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $ChatMessagePageCopyWith<$Res>  {
  factory $ChatMessagePageCopyWith(ChatMessagePage value, $Res Function(ChatMessagePage) _then) = _$ChatMessagePageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'items', fromJson: chatMessageList) List<ChatMessage> items,@JsonKey(name: 'hasMore') bool hasMore
});




}
/// @nodoc
class _$ChatMessagePageCopyWithImpl<$Res>
    implements $ChatMessagePageCopyWith<$Res> {
  _$ChatMessagePageCopyWithImpl(this._self, this._then);

  final ChatMessagePage _self;
  final $Res Function(ChatMessagePage) _then;

/// Create a copy of ChatMessagePage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? hasMore = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessagePage].
extension ChatMessagePagePatterns on ChatMessagePage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessagePage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessagePage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessagePage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessagePage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessagePage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessagePage() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChatMessagePage implements ChatMessagePage {
  const _ChatMessagePage({@JsonKey(name: 'items', fromJson: chatMessageList) final  List<ChatMessage> items = const <ChatMessage>[], @JsonKey(name: 'hasMore') this.hasMore = false}): _items = items;
  factory _ChatMessagePage.fromJson(Map<String, dynamic> json) => _$ChatMessagePageFromJson(json);

 final  List<ChatMessage> _items;
@override@JsonKey(name: 'items', fromJson: chatMessageList) List<ChatMessage> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'hasMore') final  bool hasMore;

/// Create a copy of ChatMessagePage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessagePageCopyWith<_ChatMessagePage> get copyWith => __$ChatMessagePageCopyWithImpl<_ChatMessagePage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessagePageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessagePage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),hasMore);

@override
String toString() {
  return 'ChatMessagePage(items: $items, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$ChatMessagePageCopyWith<$Res> implements $ChatMessagePageCopyWith<$Res> {
  factory _$ChatMessagePageCopyWith(_ChatMessagePage value, $Res Function(_ChatMessagePage) _then) = __$ChatMessagePageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'items', fromJson: chatMessageList) List<ChatMessage> items,@JsonKey(name: 'hasMore') bool hasMore
});




}
/// @nodoc
class __$ChatMessagePageCopyWithImpl<$Res>
    implements _$ChatMessagePageCopyWith<$Res> {
  __$ChatMessagePageCopyWithImpl(this._self, this._then);

  final _ChatMessagePage _self;
  final $Res Function(_ChatMessagePage) _then;

/// Create a copy of ChatMessagePage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? hasMore = null,}) {
  return _then(_ChatMessagePage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
