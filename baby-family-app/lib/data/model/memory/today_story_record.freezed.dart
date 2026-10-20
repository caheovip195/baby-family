// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_story_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodayStoryRecord {

@JsonKey(name: 'date') String? get date;@JsonKey(name: 'childId') String? get childId;@JsonKey(name: 'memoryCount') int get memoryCount;@JsonKey(name: 'slides') List<TodayStorySlideRecord> get slides;
/// Create a copy of TodayStoryRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayStoryRecordCopyWith<TodayStoryRecord> get copyWith => _$TodayStoryRecordCopyWithImpl<TodayStoryRecord>(this as TodayStoryRecord, _$identity);

  /// Serializes this TodayStoryRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayStoryRecord&&(identical(other.date, date) || other.date == date)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&const DeepCollectionEquality().equals(other.slides, slides));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,childId,memoryCount,const DeepCollectionEquality().hash(slides));

@override
String toString() {
  return 'TodayStoryRecord(date: $date, childId: $childId, memoryCount: $memoryCount, slides: $slides)';
}


}

/// @nodoc
abstract mixin class $TodayStoryRecordCopyWith<$Res>  {
  factory $TodayStoryRecordCopyWith(TodayStoryRecord value, $Res Function(TodayStoryRecord) _then) = _$TodayStoryRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'date') String? date,@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'memoryCount') int memoryCount,@JsonKey(name: 'slides') List<TodayStorySlideRecord> slides
});




}
/// @nodoc
class _$TodayStoryRecordCopyWithImpl<$Res>
    implements $TodayStoryRecordCopyWith<$Res> {
  _$TodayStoryRecordCopyWithImpl(this._self, this._then);

  final TodayStoryRecord _self;
  final $Res Function(TodayStoryRecord) _then;

/// Create a copy of TodayStoryRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = freezed,Object? childId = freezed,Object? memoryCount = null,Object? slides = null,}) {
  return _then(_self.copyWith(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,slides: null == slides ? _self.slides : slides // ignore: cast_nullable_to_non_nullable
as List<TodayStorySlideRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [TodayStoryRecord].
extension TodayStoryRecordPatterns on TodayStoryRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayStoryRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayStoryRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayStoryRecord value)  $default,){
final _that = this;
switch (_that) {
case _TodayStoryRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayStoryRecord value)?  $default,){
final _that = this;
switch (_that) {
case _TodayStoryRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TodayStoryRecord implements TodayStoryRecord {
  const _TodayStoryRecord({@JsonKey(name: 'date') this.date, @JsonKey(name: 'childId') this.childId, @JsonKey(name: 'memoryCount') this.memoryCount = 0, @JsonKey(name: 'slides') final  List<TodayStorySlideRecord> slides = const <TodayStorySlideRecord>[]}): _slides = slides;
  factory _TodayStoryRecord.fromJson(Map<String, dynamic> json) => _$TodayStoryRecordFromJson(json);

@override@JsonKey(name: 'date') final  String? date;
@override@JsonKey(name: 'childId') final  String? childId;
@override@JsonKey(name: 'memoryCount') final  int memoryCount;
 final  List<TodayStorySlideRecord> _slides;
@override@JsonKey(name: 'slides') List<TodayStorySlideRecord> get slides {
  if (_slides is EqualUnmodifiableListView) return _slides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slides);
}


/// Create a copy of TodayStoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayStoryRecordCopyWith<_TodayStoryRecord> get copyWith => __$TodayStoryRecordCopyWithImpl<_TodayStoryRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodayStoryRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayStoryRecord&&(identical(other.date, date) || other.date == date)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.memoryCount, memoryCount) || other.memoryCount == memoryCount)&&const DeepCollectionEquality().equals(other._slides, _slides));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,childId,memoryCount,const DeepCollectionEquality().hash(_slides));

@override
String toString() {
  return 'TodayStoryRecord(date: $date, childId: $childId, memoryCount: $memoryCount, slides: $slides)';
}


}

/// @nodoc
abstract mixin class _$TodayStoryRecordCopyWith<$Res> implements $TodayStoryRecordCopyWith<$Res> {
  factory _$TodayStoryRecordCopyWith(_TodayStoryRecord value, $Res Function(_TodayStoryRecord) _then) = __$TodayStoryRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'date') String? date,@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'memoryCount') int memoryCount,@JsonKey(name: 'slides') List<TodayStorySlideRecord> slides
});




}
/// @nodoc
class __$TodayStoryRecordCopyWithImpl<$Res>
    implements _$TodayStoryRecordCopyWith<$Res> {
  __$TodayStoryRecordCopyWithImpl(this._self, this._then);

  final _TodayStoryRecord _self;
  final $Res Function(_TodayStoryRecord) _then;

/// Create a copy of TodayStoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = freezed,Object? childId = freezed,Object? memoryCount = null,Object? slides = null,}) {
  return _then(_TodayStoryRecord(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,memoryCount: null == memoryCount ? _self.memoryCount : memoryCount // ignore: cast_nullable_to_non_nullable
as int,slides: null == slides ? _self._slides : slides // ignore: cast_nullable_to_non_nullable
as List<TodayStorySlideRecord>,
  ));
}


}


/// @nodoc
mixin _$TodayStorySlideRecord {

@JsonKey(name: 'memoryId') String? get memoryId;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'imageUrl') String? get imageUrl;@JsonKey(name: 'videoUrl') String? get videoUrl;@JsonKey(name: 'caption') String? get caption;@JsonKey(name: 'occurredAt') DateTime? get occurredAt;
/// Create a copy of TodayStorySlideRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayStorySlideRecordCopyWith<TodayStorySlideRecord> get copyWith => _$TodayStorySlideRecordCopyWithImpl<TodayStorySlideRecord>(this as TodayStorySlideRecord, _$identity);

  /// Serializes this TodayStorySlideRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayStorySlideRecord&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memoryId,kind,imageUrl,videoUrl,caption,occurredAt);

@override
String toString() {
  return 'TodayStorySlideRecord(memoryId: $memoryId, kind: $kind, imageUrl: $imageUrl, videoUrl: $videoUrl, caption: $caption, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class $TodayStorySlideRecordCopyWith<$Res>  {
  factory $TodayStorySlideRecordCopyWith(TodayStorySlideRecord value, $Res Function(TodayStorySlideRecord) _then) = _$TodayStorySlideRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'imageUrl') String? imageUrl,@JsonKey(name: 'videoUrl') String? videoUrl,@JsonKey(name: 'caption') String? caption,@JsonKey(name: 'occurredAt') DateTime? occurredAt
});




}
/// @nodoc
class _$TodayStorySlideRecordCopyWithImpl<$Res>
    implements $TodayStorySlideRecordCopyWith<$Res> {
  _$TodayStorySlideRecordCopyWithImpl(this._self, this._then);

  final TodayStorySlideRecord _self;
  final $Res Function(TodayStorySlideRecord) _then;

/// Create a copy of TodayStorySlideRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memoryId = freezed,Object? kind = freezed,Object? imageUrl = freezed,Object? videoUrl = freezed,Object? caption = freezed,Object? occurredAt = freezed,}) {
  return _then(_self.copyWith(
memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: freezed == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TodayStorySlideRecord].
extension TodayStorySlideRecordPatterns on TodayStorySlideRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayStorySlideRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayStorySlideRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayStorySlideRecord value)  $default,){
final _that = this;
switch (_that) {
case _TodayStorySlideRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayStorySlideRecord value)?  $default,){
final _that = this;
switch (_that) {
case _TodayStorySlideRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TodayStorySlideRecord implements TodayStorySlideRecord {
  const _TodayStorySlideRecord({@JsonKey(name: 'memoryId') this.memoryId, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'imageUrl') this.imageUrl, @JsonKey(name: 'videoUrl') this.videoUrl, @JsonKey(name: 'caption') this.caption, @JsonKey(name: 'occurredAt') this.occurredAt});
  factory _TodayStorySlideRecord.fromJson(Map<String, dynamic> json) => _$TodayStorySlideRecordFromJson(json);

@override@JsonKey(name: 'memoryId') final  String? memoryId;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'imageUrl') final  String? imageUrl;
@override@JsonKey(name: 'videoUrl') final  String? videoUrl;
@override@JsonKey(name: 'caption') final  String? caption;
@override@JsonKey(name: 'occurredAt') final  DateTime? occurredAt;

/// Create a copy of TodayStorySlideRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayStorySlideRecordCopyWith<_TodayStorySlideRecord> get copyWith => __$TodayStorySlideRecordCopyWithImpl<_TodayStorySlideRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodayStorySlideRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayStorySlideRecord&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memoryId,kind,imageUrl,videoUrl,caption,occurredAt);

@override
String toString() {
  return 'TodayStorySlideRecord(memoryId: $memoryId, kind: $kind, imageUrl: $imageUrl, videoUrl: $videoUrl, caption: $caption, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class _$TodayStorySlideRecordCopyWith<$Res> implements $TodayStorySlideRecordCopyWith<$Res> {
  factory _$TodayStorySlideRecordCopyWith(_TodayStorySlideRecord value, $Res Function(_TodayStorySlideRecord) _then) = __$TodayStorySlideRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'imageUrl') String? imageUrl,@JsonKey(name: 'videoUrl') String? videoUrl,@JsonKey(name: 'caption') String? caption,@JsonKey(name: 'occurredAt') DateTime? occurredAt
});




}
/// @nodoc
class __$TodayStorySlideRecordCopyWithImpl<$Res>
    implements _$TodayStorySlideRecordCopyWith<$Res> {
  __$TodayStorySlideRecordCopyWithImpl(this._self, this._then);

  final _TodayStorySlideRecord _self;
  final $Res Function(_TodayStorySlideRecord) _then;

/// Create a copy of TodayStorySlideRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memoryId = freezed,Object? kind = freezed,Object? imageUrl = freezed,Object? videoUrl = freezed,Object? caption = freezed,Object? occurredAt = freezed,}) {
  return _then(_TodayStorySlideRecord(
memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: freezed == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
