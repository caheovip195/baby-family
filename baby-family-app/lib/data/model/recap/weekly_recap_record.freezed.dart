// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_recap_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeeklyRecapRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'periodStart') String? get periodStart;@JsonKey(name: 'periodEnd') String? get periodEnd;@JsonKey(name: 'visibility') String? get visibility;@JsonKey(name: 'content') WeeklyRecapContent? get content;
/// Create a copy of WeeklyRecapRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyRecapRecordCopyWith<WeeklyRecapRecord> get copyWith => _$WeeklyRecapRecordCopyWithImpl<WeeklyRecapRecord>(this as WeeklyRecapRecord, _$identity);

  /// Serializes this WeeklyRecapRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyRecapRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,periodStart,periodEnd,visibility,content);

@override
String toString() {
  return 'WeeklyRecapRecord(id: $id, periodStart: $periodStart, periodEnd: $periodEnd, visibility: $visibility, content: $content)';
}


}

/// @nodoc
abstract mixin class $WeeklyRecapRecordCopyWith<$Res>  {
  factory $WeeklyRecapRecordCopyWith(WeeklyRecapRecord value, $Res Function(WeeklyRecapRecord) _then) = _$WeeklyRecapRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'periodStart') String? periodStart,@JsonKey(name: 'periodEnd') String? periodEnd,@JsonKey(name: 'visibility') String? visibility,@JsonKey(name: 'content') WeeklyRecapContent? content
});


$WeeklyRecapContentCopyWith<$Res>? get content;

}
/// @nodoc
class _$WeeklyRecapRecordCopyWithImpl<$Res>
    implements $WeeklyRecapRecordCopyWith<$Res> {
  _$WeeklyRecapRecordCopyWithImpl(this._self, this._then);

  final WeeklyRecapRecord _self;
  final $Res Function(WeeklyRecapRecord) _then;

/// Create a copy of WeeklyRecapRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? periodStart = freezed,Object? periodEnd = freezed,Object? visibility = freezed,Object? content = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,periodStart: freezed == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as String?,periodEnd: freezed == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as String?,visibility: freezed == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as WeeklyRecapContent?,
  ));
}
/// Create a copy of WeeklyRecapRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklyRecapContentCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $WeeklyRecapContentCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeeklyRecapRecord].
extension WeeklyRecapRecordPatterns on WeeklyRecapRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyRecapRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyRecapRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyRecapRecord value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyRecapRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyRecapRecord value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyRecapRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _WeeklyRecapRecord implements WeeklyRecapRecord {
  const _WeeklyRecapRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'periodStart') this.periodStart, @JsonKey(name: 'periodEnd') this.periodEnd, @JsonKey(name: 'visibility') this.visibility, @JsonKey(name: 'content') this.content});
  factory _WeeklyRecapRecord.fromJson(Map<String, dynamic> json) => _$WeeklyRecapRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'periodStart') final  String? periodStart;
@override@JsonKey(name: 'periodEnd') final  String? periodEnd;
@override@JsonKey(name: 'visibility') final  String? visibility;
@override@JsonKey(name: 'content') final  WeeklyRecapContent? content;

/// Create a copy of WeeklyRecapRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyRecapRecordCopyWith<_WeeklyRecapRecord> get copyWith => __$WeeklyRecapRecordCopyWithImpl<_WeeklyRecapRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyRecapRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyRecapRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,periodStart,periodEnd,visibility,content);

@override
String toString() {
  return 'WeeklyRecapRecord(id: $id, periodStart: $periodStart, periodEnd: $periodEnd, visibility: $visibility, content: $content)';
}


}

/// @nodoc
abstract mixin class _$WeeklyRecapRecordCopyWith<$Res> implements $WeeklyRecapRecordCopyWith<$Res> {
  factory _$WeeklyRecapRecordCopyWith(_WeeklyRecapRecord value, $Res Function(_WeeklyRecapRecord) _then) = __$WeeklyRecapRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'periodStart') String? periodStart,@JsonKey(name: 'periodEnd') String? periodEnd,@JsonKey(name: 'visibility') String? visibility,@JsonKey(name: 'content') WeeklyRecapContent? content
});


@override $WeeklyRecapContentCopyWith<$Res>? get content;

}
/// @nodoc
class __$WeeklyRecapRecordCopyWithImpl<$Res>
    implements _$WeeklyRecapRecordCopyWith<$Res> {
  __$WeeklyRecapRecordCopyWithImpl(this._self, this._then);

  final _WeeklyRecapRecord _self;
  final $Res Function(_WeeklyRecapRecord) _then;

/// Create a copy of WeeklyRecapRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? periodStart = freezed,Object? periodEnd = freezed,Object? visibility = freezed,Object? content = freezed,}) {
  return _then(_WeeklyRecapRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,periodStart: freezed == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as String?,periodEnd: freezed == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as String?,visibility: freezed == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as WeeklyRecapContent?,
  ));
}

/// Create a copy of WeeklyRecapRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklyRecapContentCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $WeeklyRecapContentCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// @nodoc
mixin _$WeeklyRecapContent {

@JsonKey(name: 'version') int? get version;@JsonKey(name: 'stats') WeekStatsRecord? get stats;@JsonKey(name: 'topMemories') List<RecapMemoryRef> get topMemories;
/// Create a copy of WeeklyRecapContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyRecapContentCopyWith<WeeklyRecapContent> get copyWith => _$WeeklyRecapContentCopyWithImpl<WeeklyRecapContent>(this as WeeklyRecapContent, _$identity);

  /// Serializes this WeeklyRecapContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyRecapContent&&(identical(other.version, version) || other.version == version)&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other.topMemories, topMemories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,stats,const DeepCollectionEquality().hash(topMemories));

@override
String toString() {
  return 'WeeklyRecapContent(version: $version, stats: $stats, topMemories: $topMemories)';
}


}

/// @nodoc
abstract mixin class $WeeklyRecapContentCopyWith<$Res>  {
  factory $WeeklyRecapContentCopyWith(WeeklyRecapContent value, $Res Function(WeeklyRecapContent) _then) = _$WeeklyRecapContentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'version') int? version,@JsonKey(name: 'stats') WeekStatsRecord? stats,@JsonKey(name: 'topMemories') List<RecapMemoryRef> topMemories
});


$WeekStatsRecordCopyWith<$Res>? get stats;

}
/// @nodoc
class _$WeeklyRecapContentCopyWithImpl<$Res>
    implements $WeeklyRecapContentCopyWith<$Res> {
  _$WeeklyRecapContentCopyWithImpl(this._self, this._then);

  final WeeklyRecapContent _self;
  final $Res Function(WeeklyRecapContent) _then;

/// Create a copy of WeeklyRecapContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = freezed,Object? stats = freezed,Object? topMemories = null,}) {
  return _then(_self.copyWith(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,stats: freezed == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as WeekStatsRecord?,topMemories: null == topMemories ? _self.topMemories : topMemories // ignore: cast_nullable_to_non_nullable
as List<RecapMemoryRef>,
  ));
}
/// Create a copy of WeeklyRecapContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeekStatsRecordCopyWith<$Res>? get stats {
    if (_self.stats == null) {
    return null;
  }

  return $WeekStatsRecordCopyWith<$Res>(_self.stats!, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeeklyRecapContent].
extension WeeklyRecapContentPatterns on WeeklyRecapContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyRecapContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyRecapContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyRecapContent value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyRecapContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyRecapContent value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyRecapContent() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _WeeklyRecapContent implements WeeklyRecapContent {
  const _WeeklyRecapContent({@JsonKey(name: 'version') this.version, @JsonKey(name: 'stats') this.stats, @JsonKey(name: 'topMemories') final  List<RecapMemoryRef> topMemories = const <RecapMemoryRef>[]}): _topMemories = topMemories;
  factory _WeeklyRecapContent.fromJson(Map<String, dynamic> json) => _$WeeklyRecapContentFromJson(json);

@override@JsonKey(name: 'version') final  int? version;
@override@JsonKey(name: 'stats') final  WeekStatsRecord? stats;
 final  List<RecapMemoryRef> _topMemories;
@override@JsonKey(name: 'topMemories') List<RecapMemoryRef> get topMemories {
  if (_topMemories is EqualUnmodifiableListView) return _topMemories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topMemories);
}


/// Create a copy of WeeklyRecapContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyRecapContentCopyWith<_WeeklyRecapContent> get copyWith => __$WeeklyRecapContentCopyWithImpl<_WeeklyRecapContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyRecapContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyRecapContent&&(identical(other.version, version) || other.version == version)&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other._topMemories, _topMemories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,stats,const DeepCollectionEquality().hash(_topMemories));

@override
String toString() {
  return 'WeeklyRecapContent(version: $version, stats: $stats, topMemories: $topMemories)';
}


}

/// @nodoc
abstract mixin class _$WeeklyRecapContentCopyWith<$Res> implements $WeeklyRecapContentCopyWith<$Res> {
  factory _$WeeklyRecapContentCopyWith(_WeeklyRecapContent value, $Res Function(_WeeklyRecapContent) _then) = __$WeeklyRecapContentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'version') int? version,@JsonKey(name: 'stats') WeekStatsRecord? stats,@JsonKey(name: 'topMemories') List<RecapMemoryRef> topMemories
});


@override $WeekStatsRecordCopyWith<$Res>? get stats;

}
/// @nodoc
class __$WeeklyRecapContentCopyWithImpl<$Res>
    implements _$WeeklyRecapContentCopyWith<$Res> {
  __$WeeklyRecapContentCopyWithImpl(this._self, this._then);

  final _WeeklyRecapContent _self;
  final $Res Function(_WeeklyRecapContent) _then;

/// Create a copy of WeeklyRecapContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = freezed,Object? stats = freezed,Object? topMemories = null,}) {
  return _then(_WeeklyRecapContent(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,stats: freezed == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as WeekStatsRecord?,topMemories: null == topMemories ? _self._topMemories : topMemories // ignore: cast_nullable_to_non_nullable
as List<RecapMemoryRef>,
  ));
}

/// Create a copy of WeeklyRecapContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeekStatsRecordCopyWith<$Res>? get stats {
    if (_self.stats == null) {
    return null;
  }

  return $WeekStatsRecordCopyWith<$Res>(_self.stats!, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// @nodoc
mixin _$RecapMemoryRef {

@JsonKey(name: 'id') String? get id;
/// Create a copy of RecapMemoryRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecapMemoryRefCopyWith<RecapMemoryRef> get copyWith => _$RecapMemoryRefCopyWithImpl<RecapMemoryRef>(this as RecapMemoryRef, _$identity);

  /// Serializes this RecapMemoryRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecapMemoryRef&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'RecapMemoryRef(id: $id)';
}


}

/// @nodoc
abstract mixin class $RecapMemoryRefCopyWith<$Res>  {
  factory $RecapMemoryRefCopyWith(RecapMemoryRef value, $Res Function(RecapMemoryRef) _then) = _$RecapMemoryRefCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id
});




}
/// @nodoc
class _$RecapMemoryRefCopyWithImpl<$Res>
    implements $RecapMemoryRefCopyWith<$Res> {
  _$RecapMemoryRefCopyWithImpl(this._self, this._then);

  final RecapMemoryRef _self;
  final $Res Function(RecapMemoryRef) _then;

/// Create a copy of RecapMemoryRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecapMemoryRef].
extension RecapMemoryRefPatterns on RecapMemoryRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecapMemoryRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecapMemoryRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecapMemoryRef value)  $default,){
final _that = this;
switch (_that) {
case _RecapMemoryRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecapMemoryRef value)?  $default,){
final _that = this;
switch (_that) {
case _RecapMemoryRef() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _RecapMemoryRef implements RecapMemoryRef {
  const _RecapMemoryRef({@JsonKey(name: 'id') this.id});
  factory _RecapMemoryRef.fromJson(Map<String, dynamic> json) => _$RecapMemoryRefFromJson(json);

@override@JsonKey(name: 'id') final  String? id;

/// Create a copy of RecapMemoryRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecapMemoryRefCopyWith<_RecapMemoryRef> get copyWith => __$RecapMemoryRefCopyWithImpl<_RecapMemoryRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecapMemoryRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecapMemoryRef&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'RecapMemoryRef(id: $id)';
}


}

/// @nodoc
abstract mixin class _$RecapMemoryRefCopyWith<$Res> implements $RecapMemoryRefCopyWith<$Res> {
  factory _$RecapMemoryRefCopyWith(_RecapMemoryRef value, $Res Function(_RecapMemoryRef) _then) = __$RecapMemoryRefCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id
});




}
/// @nodoc
class __$RecapMemoryRefCopyWithImpl<$Res>
    implements _$RecapMemoryRefCopyWith<$Res> {
  __$RecapMemoryRefCopyWithImpl(this._self, this._then);

  final _RecapMemoryRef _self;
  final $Res Function(_RecapMemoryRef) _then;

/// Create a copy of RecapMemoryRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,}) {
  return _then(_RecapMemoryRef(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
