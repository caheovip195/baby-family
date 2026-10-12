// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JournalEntry {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'userId') String get userId;@JsonKey(name: 'createdAt') DateTime get createdAt;@JsonKey(name: 'showTime') bool get showTime;@JsonKey(name: 'mood') JournalMood get mood;@JsonKey(name: 'title') String get title;@JsonKey(name: 'body') String get body;@JsonKey(name: 'photoAsset') String? get photoAsset;@JsonKey(name: 'sharedExcerpt') bool get sharedExcerpt;
/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntryCopyWith<JournalEntry> get copyWith => _$JournalEntryCopyWithImpl<JournalEntry>(this as JournalEntry, _$identity);

  /// Serializes this JournalEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.showTime, showTime) || other.showTime == showTime)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.photoAsset, photoAsset) || other.photoAsset == photoAsset)&&(identical(other.sharedExcerpt, sharedExcerpt) || other.sharedExcerpt == sharedExcerpt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,createdAt,showTime,mood,title,body,photoAsset,sharedExcerpt);

@override
String toString() {
  return 'JournalEntry(id: $id, userId: $userId, createdAt: $createdAt, showTime: $showTime, mood: $mood, title: $title, body: $body, photoAsset: $photoAsset, sharedExcerpt: $sharedExcerpt)';
}


}

/// @nodoc
abstract mixin class $JournalEntryCopyWith<$Res>  {
  factory $JournalEntryCopyWith(JournalEntry value, $Res Function(JournalEntry) _then) = _$JournalEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'userId') String userId,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'showTime') bool showTime,@JsonKey(name: 'mood') JournalMood mood,@JsonKey(name: 'title') String title,@JsonKey(name: 'body') String body,@JsonKey(name: 'photoAsset') String? photoAsset,@JsonKey(name: 'sharedExcerpt') bool sharedExcerpt
});




}
/// @nodoc
class _$JournalEntryCopyWithImpl<$Res>
    implements $JournalEntryCopyWith<$Res> {
  _$JournalEntryCopyWithImpl(this._self, this._then);

  final JournalEntry _self;
  final $Res Function(JournalEntry) _then;

/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? createdAt = null,Object? showTime = null,Object? mood = null,Object? title = null,Object? body = null,Object? photoAsset = freezed,Object? sharedExcerpt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,showTime: null == showTime ? _self.showTime : showTime // ignore: cast_nullable_to_non_nullable
as bool,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as JournalMood,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,photoAsset: freezed == photoAsset ? _self.photoAsset : photoAsset // ignore: cast_nullable_to_non_nullable
as String?,sharedExcerpt: null == sharedExcerpt ? _self.sharedExcerpt : sharedExcerpt // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalEntry].
extension JournalEntryPatterns on JournalEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalEntry value)  $default,){
final _that = this;
switch (_that) {
case _JournalEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalEntry value)?  $default,){
final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _JournalEntry implements JournalEntry {
  const _JournalEntry({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'userId') required this.userId, @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'showTime') this.showTime = false, @JsonKey(name: 'mood') this.mood = JournalMood.calm, @JsonKey(name: 'title') this.title = '', @JsonKey(name: 'body') this.body = '', @JsonKey(name: 'photoAsset') this.photoAsset, @JsonKey(name: 'sharedExcerpt') this.sharedExcerpt = false});
  factory _JournalEntry.fromJson(Map<String, dynamic> json) => _$JournalEntryFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'userId') final  String userId;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;
@override@JsonKey(name: 'showTime') final  bool showTime;
@override@JsonKey(name: 'mood') final  JournalMood mood;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'body') final  String body;
@override@JsonKey(name: 'photoAsset') final  String? photoAsset;
@override@JsonKey(name: 'sharedExcerpt') final  bool sharedExcerpt;

/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalEntryCopyWith<_JournalEntry> get copyWith => __$JournalEntryCopyWithImpl<_JournalEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.showTime, showTime) || other.showTime == showTime)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.photoAsset, photoAsset) || other.photoAsset == photoAsset)&&(identical(other.sharedExcerpt, sharedExcerpt) || other.sharedExcerpt == sharedExcerpt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,createdAt,showTime,mood,title,body,photoAsset,sharedExcerpt);

@override
String toString() {
  return 'JournalEntry(id: $id, userId: $userId, createdAt: $createdAt, showTime: $showTime, mood: $mood, title: $title, body: $body, photoAsset: $photoAsset, sharedExcerpt: $sharedExcerpt)';
}


}

/// @nodoc
abstract mixin class _$JournalEntryCopyWith<$Res> implements $JournalEntryCopyWith<$Res> {
  factory _$JournalEntryCopyWith(_JournalEntry value, $Res Function(_JournalEntry) _then) = __$JournalEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'userId') String userId,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'showTime') bool showTime,@JsonKey(name: 'mood') JournalMood mood,@JsonKey(name: 'title') String title,@JsonKey(name: 'body') String body,@JsonKey(name: 'photoAsset') String? photoAsset,@JsonKey(name: 'sharedExcerpt') bool sharedExcerpt
});




}
/// @nodoc
class __$JournalEntryCopyWithImpl<$Res>
    implements _$JournalEntryCopyWith<$Res> {
  __$JournalEntryCopyWithImpl(this._self, this._then);

  final _JournalEntry _self;
  final $Res Function(_JournalEntry) _then;

/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? createdAt = null,Object? showTime = null,Object? mood = null,Object? title = null,Object? body = null,Object? photoAsset = freezed,Object? sharedExcerpt = null,}) {
  return _then(_JournalEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,showTime: null == showTime ? _self.showTime : showTime // ignore: cast_nullable_to_non_nullable
as bool,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as JournalMood,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,photoAsset: freezed == photoAsset ? _self.photoAsset : photoAsset // ignore: cast_nullable_to_non_nullable
as String?,sharedExcerpt: null == sharedExcerpt ? _self.sharedExcerpt : sharedExcerpt // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
