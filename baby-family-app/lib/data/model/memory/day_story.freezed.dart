// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_story.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DayStory {

@JsonKey(name: 'date') DateTime get date;@JsonKey(name: 'childId') String get childId;@JsonKey(name: 'title') String get title;@JsonKey(name: 'body') String get body;@JsonKey(name: 'aiGenerated') bool get aiGenerated;@JsonKey(name: 'items') List<DayStoryItem> get items;@JsonKey(name: 'photoAssets') List<String> get photoAssets;@JsonKey(name: 'coverAsset') String? get coverAsset;@JsonKey(name: 'visibility') MemoryVisibility get visibility;
/// Create a copy of DayStory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayStoryCopyWith<DayStory> get copyWith => _$DayStoryCopyWithImpl<DayStory>(this as DayStory, _$identity);

  /// Serializes this DayStory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayStory&&(identical(other.date, date) || other.date == date)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.aiGenerated, aiGenerated) || other.aiGenerated == aiGenerated)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.photoAssets, photoAssets)&&(identical(other.coverAsset, coverAsset) || other.coverAsset == coverAsset)&&(identical(other.visibility, visibility) || other.visibility == visibility));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,childId,title,body,aiGenerated,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(photoAssets),coverAsset,visibility);

@override
String toString() {
  return 'DayStory(date: $date, childId: $childId, title: $title, body: $body, aiGenerated: $aiGenerated, items: $items, photoAssets: $photoAssets, coverAsset: $coverAsset, visibility: $visibility)';
}


}

/// @nodoc
abstract mixin class $DayStoryCopyWith<$Res>  {
  factory $DayStoryCopyWith(DayStory value, $Res Function(DayStory) _then) = _$DayStoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'date') DateTime date,@JsonKey(name: 'childId') String childId,@JsonKey(name: 'title') String title,@JsonKey(name: 'body') String body,@JsonKey(name: 'aiGenerated') bool aiGenerated,@JsonKey(name: 'items') List<DayStoryItem> items,@JsonKey(name: 'photoAssets') List<String> photoAssets,@JsonKey(name: 'coverAsset') String? coverAsset,@JsonKey(name: 'visibility') MemoryVisibility visibility
});




}
/// @nodoc
class _$DayStoryCopyWithImpl<$Res>
    implements $DayStoryCopyWith<$Res> {
  _$DayStoryCopyWithImpl(this._self, this._then);

  final DayStory _self;
  final $Res Function(DayStory) _then;

/// Create a copy of DayStory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? childId = null,Object? title = null,Object? body = null,Object? aiGenerated = null,Object? items = null,Object? photoAssets = null,Object? coverAsset = freezed,Object? visibility = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,aiGenerated: null == aiGenerated ? _self.aiGenerated : aiGenerated // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DayStoryItem>,photoAssets: null == photoAssets ? _self.photoAssets : photoAssets // ignore: cast_nullable_to_non_nullable
as List<String>,coverAsset: freezed == coverAsset ? _self.coverAsset : coverAsset // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as MemoryVisibility,
  ));
}

}


/// Adds pattern-matching-related methods to [DayStory].
extension DayStoryPatterns on DayStory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayStory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayStory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayStory value)  $default,){
final _that = this;
switch (_that) {
case _DayStory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayStory value)?  $default,){
final _that = this;
switch (_that) {
case _DayStory() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DayStory implements DayStory {
  const _DayStory({@JsonKey(name: 'date') required this.date, @JsonKey(name: 'childId') required this.childId, @JsonKey(name: 'title') this.title = '', @JsonKey(name: 'body') this.body = '', @JsonKey(name: 'aiGenerated') this.aiGenerated = true, @JsonKey(name: 'items') final  List<DayStoryItem> items = const [], @JsonKey(name: 'photoAssets') final  List<String> photoAssets = const [], @JsonKey(name: 'coverAsset') this.coverAsset, @JsonKey(name: 'visibility') this.visibility = MemoryVisibility.parents}): _items = items,_photoAssets = photoAssets;
  factory _DayStory.fromJson(Map<String, dynamic> json) => _$DayStoryFromJson(json);

@override@JsonKey(name: 'date') final  DateTime date;
@override@JsonKey(name: 'childId') final  String childId;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'body') final  String body;
@override@JsonKey(name: 'aiGenerated') final  bool aiGenerated;
 final  List<DayStoryItem> _items;
@override@JsonKey(name: 'items') List<DayStoryItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<String> _photoAssets;
@override@JsonKey(name: 'photoAssets') List<String> get photoAssets {
  if (_photoAssets is EqualUnmodifiableListView) return _photoAssets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoAssets);
}

@override@JsonKey(name: 'coverAsset') final  String? coverAsset;
@override@JsonKey(name: 'visibility') final  MemoryVisibility visibility;

/// Create a copy of DayStory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayStoryCopyWith<_DayStory> get copyWith => __$DayStoryCopyWithImpl<_DayStory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayStoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayStory&&(identical(other.date, date) || other.date == date)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.aiGenerated, aiGenerated) || other.aiGenerated == aiGenerated)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._photoAssets, _photoAssets)&&(identical(other.coverAsset, coverAsset) || other.coverAsset == coverAsset)&&(identical(other.visibility, visibility) || other.visibility == visibility));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,childId,title,body,aiGenerated,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_photoAssets),coverAsset,visibility);

@override
String toString() {
  return 'DayStory(date: $date, childId: $childId, title: $title, body: $body, aiGenerated: $aiGenerated, items: $items, photoAssets: $photoAssets, coverAsset: $coverAsset, visibility: $visibility)';
}


}

/// @nodoc
abstract mixin class _$DayStoryCopyWith<$Res> implements $DayStoryCopyWith<$Res> {
  factory _$DayStoryCopyWith(_DayStory value, $Res Function(_DayStory) _then) = __$DayStoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'date') DateTime date,@JsonKey(name: 'childId') String childId,@JsonKey(name: 'title') String title,@JsonKey(name: 'body') String body,@JsonKey(name: 'aiGenerated') bool aiGenerated,@JsonKey(name: 'items') List<DayStoryItem> items,@JsonKey(name: 'photoAssets') List<String> photoAssets,@JsonKey(name: 'coverAsset') String? coverAsset,@JsonKey(name: 'visibility') MemoryVisibility visibility
});




}
/// @nodoc
class __$DayStoryCopyWithImpl<$Res>
    implements _$DayStoryCopyWith<$Res> {
  __$DayStoryCopyWithImpl(this._self, this._then);

  final _DayStory _self;
  final $Res Function(_DayStory) _then;

/// Create a copy of DayStory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? childId = null,Object? title = null,Object? body = null,Object? aiGenerated = null,Object? items = null,Object? photoAssets = null,Object? coverAsset = freezed,Object? visibility = null,}) {
  return _then(_DayStory(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,aiGenerated: null == aiGenerated ? _self.aiGenerated : aiGenerated // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DayStoryItem>,photoAssets: null == photoAssets ? _self._photoAssets : photoAssets // ignore: cast_nullable_to_non_nullable
as List<String>,coverAsset: freezed == coverAsset ? _self.coverAsset : coverAsset // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as MemoryVisibility,
  ));
}


}

// dart format on
