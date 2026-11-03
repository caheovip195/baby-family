// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiStatusRecord {

@JsonKey(name: 'available') bool get available;@JsonKey(name: 'used') int get used;@JsonKey(name: 'total') int get total;@JsonKey(name: 'consented') List<String> get consented;
/// Create a copy of AiStatusRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiStatusRecordCopyWith<AiStatusRecord> get copyWith => _$AiStatusRecordCopyWithImpl<AiStatusRecord>(this as AiStatusRecord, _$identity);

  /// Serializes this AiStatusRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiStatusRecord&&(identical(other.available, available) || other.available == available)&&(identical(other.used, used) || other.used == used)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.consented, consented));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,available,used,total,const DeepCollectionEquality().hash(consented));

@override
String toString() {
  return 'AiStatusRecord(available: $available, used: $used, total: $total, consented: $consented)';
}


}

/// @nodoc
abstract mixin class $AiStatusRecordCopyWith<$Res>  {
  factory $AiStatusRecordCopyWith(AiStatusRecord value, $Res Function(AiStatusRecord) _then) = _$AiStatusRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'available') bool available,@JsonKey(name: 'used') int used,@JsonKey(name: 'total') int total,@JsonKey(name: 'consented') List<String> consented
});




}
/// @nodoc
class _$AiStatusRecordCopyWithImpl<$Res>
    implements $AiStatusRecordCopyWith<$Res> {
  _$AiStatusRecordCopyWithImpl(this._self, this._then);

  final AiStatusRecord _self;
  final $Res Function(AiStatusRecord) _then;

/// Create a copy of AiStatusRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? available = null,Object? used = null,Object? total = null,Object? consented = null,}) {
  return _then(_self.copyWith(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,consented: null == consented ? _self.consented : consented // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiStatusRecord].
extension AiStatusRecordPatterns on AiStatusRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiStatusRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiStatusRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiStatusRecord value)  $default,){
final _that = this;
switch (_that) {
case _AiStatusRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiStatusRecord value)?  $default,){
final _that = this;
switch (_that) {
case _AiStatusRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AiStatusRecord implements AiStatusRecord {
  const _AiStatusRecord({@JsonKey(name: 'available') this.available = false, @JsonKey(name: 'used') this.used = 0, @JsonKey(name: 'total') this.total = 0, @JsonKey(name: 'consented') final  List<String> consented = const <String>[]}): _consented = consented;
  factory _AiStatusRecord.fromJson(Map<String, dynamic> json) => _$AiStatusRecordFromJson(json);

@override@JsonKey(name: 'available') final  bool available;
@override@JsonKey(name: 'used') final  int used;
@override@JsonKey(name: 'total') final  int total;
 final  List<String> _consented;
@override@JsonKey(name: 'consented') List<String> get consented {
  if (_consented is EqualUnmodifiableListView) return _consented;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_consented);
}


/// Create a copy of AiStatusRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiStatusRecordCopyWith<_AiStatusRecord> get copyWith => __$AiStatusRecordCopyWithImpl<_AiStatusRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiStatusRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiStatusRecord&&(identical(other.available, available) || other.available == available)&&(identical(other.used, used) || other.used == used)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._consented, _consented));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,available,used,total,const DeepCollectionEquality().hash(_consented));

@override
String toString() {
  return 'AiStatusRecord(available: $available, used: $used, total: $total, consented: $consented)';
}


}

/// @nodoc
abstract mixin class _$AiStatusRecordCopyWith<$Res> implements $AiStatusRecordCopyWith<$Res> {
  factory _$AiStatusRecordCopyWith(_AiStatusRecord value, $Res Function(_AiStatusRecord) _then) = __$AiStatusRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'available') bool available,@JsonKey(name: 'used') int used,@JsonKey(name: 'total') int total,@JsonKey(name: 'consented') List<String> consented
});




}
/// @nodoc
class __$AiStatusRecordCopyWithImpl<$Res>
    implements _$AiStatusRecordCopyWith<$Res> {
  __$AiStatusRecordCopyWithImpl(this._self, this._then);

  final _AiStatusRecord _self;
  final $Res Function(_AiStatusRecord) _then;

/// Create a copy of AiStatusRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? available = null,Object? used = null,Object? total = null,Object? consented = null,}) {
  return _then(_AiStatusRecord(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,consented: null == consented ? _self._consented : consented // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$AiDraftRecord {

/// Lượt gọi trên server — dùng khi báo cáo nội dung AI.
@JsonKey(name: 'invocationId') String? get invocationId;@JsonKey(name: 'suggestions') List<String> get suggestions;@JsonKey(name: 'story') String? get story;@JsonKey(name: 'summary') String? get summary;@JsonKey(name: 'safety') bool get safety;@JsonKey(name: 'neutral') String? get neutral;@JsonKey(name: 'warm') String? get warm;@JsonKey(name: 'short') String? get short;@JsonKey(name: 'missions', fromJson: _missionPicks) List<AiMissionPick> get missions;
/// Create a copy of AiDraftRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiDraftRecordCopyWith<AiDraftRecord> get copyWith => _$AiDraftRecordCopyWithImpl<AiDraftRecord>(this as AiDraftRecord, _$identity);

  /// Serializes this AiDraftRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiDraftRecord&&(identical(other.invocationId, invocationId) || other.invocationId == invocationId)&&const DeepCollectionEquality().equals(other.suggestions, suggestions)&&(identical(other.story, story) || other.story == story)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.safety, safety) || other.safety == safety)&&(identical(other.neutral, neutral) || other.neutral == neutral)&&(identical(other.warm, warm) || other.warm == warm)&&(identical(other.short, short) || other.short == short)&&const DeepCollectionEquality().equals(other.missions, missions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,invocationId,const DeepCollectionEquality().hash(suggestions),story,summary,safety,neutral,warm,short,const DeepCollectionEquality().hash(missions));

@override
String toString() {
  return 'AiDraftRecord(invocationId: $invocationId, suggestions: $suggestions, story: $story, summary: $summary, safety: $safety, neutral: $neutral, warm: $warm, short: $short, missions: $missions)';
}


}

/// @nodoc
abstract mixin class $AiDraftRecordCopyWith<$Res>  {
  factory $AiDraftRecordCopyWith(AiDraftRecord value, $Res Function(AiDraftRecord) _then) = _$AiDraftRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'invocationId') String? invocationId,@JsonKey(name: 'suggestions') List<String> suggestions,@JsonKey(name: 'story') String? story,@JsonKey(name: 'summary') String? summary,@JsonKey(name: 'safety') bool safety,@JsonKey(name: 'neutral') String? neutral,@JsonKey(name: 'warm') String? warm,@JsonKey(name: 'short') String? short,@JsonKey(name: 'missions', fromJson: _missionPicks) List<AiMissionPick> missions
});




}
/// @nodoc
class _$AiDraftRecordCopyWithImpl<$Res>
    implements $AiDraftRecordCopyWith<$Res> {
  _$AiDraftRecordCopyWithImpl(this._self, this._then);

  final AiDraftRecord _self;
  final $Res Function(AiDraftRecord) _then;

/// Create a copy of AiDraftRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? invocationId = freezed,Object? suggestions = null,Object? story = freezed,Object? summary = freezed,Object? safety = null,Object? neutral = freezed,Object? warm = freezed,Object? short = freezed,Object? missions = null,}) {
  return _then(_self.copyWith(
invocationId: freezed == invocationId ? _self.invocationId : invocationId // ignore: cast_nullable_to_non_nullable
as String?,suggestions: null == suggestions ? _self.suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<String>,story: freezed == story ? _self.story : story // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,safety: null == safety ? _self.safety : safety // ignore: cast_nullable_to_non_nullable
as bool,neutral: freezed == neutral ? _self.neutral : neutral // ignore: cast_nullable_to_non_nullable
as String?,warm: freezed == warm ? _self.warm : warm // ignore: cast_nullable_to_non_nullable
as String?,short: freezed == short ? _self.short : short // ignore: cast_nullable_to_non_nullable
as String?,missions: null == missions ? _self.missions : missions // ignore: cast_nullable_to_non_nullable
as List<AiMissionPick>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiDraftRecord].
extension AiDraftRecordPatterns on AiDraftRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiDraftRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiDraftRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiDraftRecord value)  $default,){
final _that = this;
switch (_that) {
case _AiDraftRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiDraftRecord value)?  $default,){
final _that = this;
switch (_that) {
case _AiDraftRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AiDraftRecord implements AiDraftRecord {
  const _AiDraftRecord({@JsonKey(name: 'invocationId') this.invocationId, @JsonKey(name: 'suggestions') final  List<String> suggestions = const <String>[], @JsonKey(name: 'story') this.story, @JsonKey(name: 'summary') this.summary, @JsonKey(name: 'safety') this.safety = false, @JsonKey(name: 'neutral') this.neutral, @JsonKey(name: 'warm') this.warm, @JsonKey(name: 'short') this.short, @JsonKey(name: 'missions', fromJson: _missionPicks) final  List<AiMissionPick> missions = const <AiMissionPick>[]}): _suggestions = suggestions,_missions = missions;
  factory _AiDraftRecord.fromJson(Map<String, dynamic> json) => _$AiDraftRecordFromJson(json);

/// Lượt gọi trên server — dùng khi báo cáo nội dung AI.
@override@JsonKey(name: 'invocationId') final  String? invocationId;
 final  List<String> _suggestions;
@override@JsonKey(name: 'suggestions') List<String> get suggestions {
  if (_suggestions is EqualUnmodifiableListView) return _suggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestions);
}

@override@JsonKey(name: 'story') final  String? story;
@override@JsonKey(name: 'summary') final  String? summary;
@override@JsonKey(name: 'safety') final  bool safety;
@override@JsonKey(name: 'neutral') final  String? neutral;
@override@JsonKey(name: 'warm') final  String? warm;
@override@JsonKey(name: 'short') final  String? short;
 final  List<AiMissionPick> _missions;
@override@JsonKey(name: 'missions', fromJson: _missionPicks) List<AiMissionPick> get missions {
  if (_missions is EqualUnmodifiableListView) return _missions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_missions);
}


/// Create a copy of AiDraftRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiDraftRecordCopyWith<_AiDraftRecord> get copyWith => __$AiDraftRecordCopyWithImpl<_AiDraftRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiDraftRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiDraftRecord&&(identical(other.invocationId, invocationId) || other.invocationId == invocationId)&&const DeepCollectionEquality().equals(other._suggestions, _suggestions)&&(identical(other.story, story) || other.story == story)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.safety, safety) || other.safety == safety)&&(identical(other.neutral, neutral) || other.neutral == neutral)&&(identical(other.warm, warm) || other.warm == warm)&&(identical(other.short, short) || other.short == short)&&const DeepCollectionEquality().equals(other._missions, _missions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,invocationId,const DeepCollectionEquality().hash(_suggestions),story,summary,safety,neutral,warm,short,const DeepCollectionEquality().hash(_missions));

@override
String toString() {
  return 'AiDraftRecord(invocationId: $invocationId, suggestions: $suggestions, story: $story, summary: $summary, safety: $safety, neutral: $neutral, warm: $warm, short: $short, missions: $missions)';
}


}

/// @nodoc
abstract mixin class _$AiDraftRecordCopyWith<$Res> implements $AiDraftRecordCopyWith<$Res> {
  factory _$AiDraftRecordCopyWith(_AiDraftRecord value, $Res Function(_AiDraftRecord) _then) = __$AiDraftRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'invocationId') String? invocationId,@JsonKey(name: 'suggestions') List<String> suggestions,@JsonKey(name: 'story') String? story,@JsonKey(name: 'summary') String? summary,@JsonKey(name: 'safety') bool safety,@JsonKey(name: 'neutral') String? neutral,@JsonKey(name: 'warm') String? warm,@JsonKey(name: 'short') String? short,@JsonKey(name: 'missions', fromJson: _missionPicks) List<AiMissionPick> missions
});




}
/// @nodoc
class __$AiDraftRecordCopyWithImpl<$Res>
    implements _$AiDraftRecordCopyWith<$Res> {
  __$AiDraftRecordCopyWithImpl(this._self, this._then);

  final _AiDraftRecord _self;
  final $Res Function(_AiDraftRecord) _then;

/// Create a copy of AiDraftRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? invocationId = freezed,Object? suggestions = null,Object? story = freezed,Object? summary = freezed,Object? safety = null,Object? neutral = freezed,Object? warm = freezed,Object? short = freezed,Object? missions = null,}) {
  return _then(_AiDraftRecord(
invocationId: freezed == invocationId ? _self.invocationId : invocationId // ignore: cast_nullable_to_non_nullable
as String?,suggestions: null == suggestions ? _self._suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<String>,story: freezed == story ? _self.story : story // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,safety: null == safety ? _self.safety : safety // ignore: cast_nullable_to_non_nullable
as bool,neutral: freezed == neutral ? _self.neutral : neutral // ignore: cast_nullable_to_non_nullable
as String?,warm: freezed == warm ? _self.warm : warm // ignore: cast_nullable_to_non_nullable
as String?,short: freezed == short ? _self.short : short // ignore: cast_nullable_to_non_nullable
as String?,missions: null == missions ? _self._missions : missions // ignore: cast_nullable_to_non_nullable
as List<AiMissionPick>,
  ));
}


}


/// @nodoc
mixin _$AiMissionPick {

@JsonKey(name: 'templateId') String get templateId;@JsonKey(name: 'title') String get title;@JsonKey(name: 'category') String? get category;@JsonKey(name: 'hearts') int get hearts;@JsonKey(name: 'durationMin') int? get durationMin;@JsonKey(name: 'reason') String get reason;
/// Create a copy of AiMissionPick
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiMissionPickCopyWith<AiMissionPick> get copyWith => _$AiMissionPickCopyWithImpl<AiMissionPick>(this as AiMissionPick, _$identity);

  /// Serializes this AiMissionPick to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiMissionPick&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,templateId,title,category,hearts,durationMin,reason);

@override
String toString() {
  return 'AiMissionPick(templateId: $templateId, title: $title, category: $category, hearts: $hearts, durationMin: $durationMin, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $AiMissionPickCopyWith<$Res>  {
  factory $AiMissionPickCopyWith(AiMissionPick value, $Res Function(AiMissionPick) _then) = _$AiMissionPickCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'templateId') String templateId,@JsonKey(name: 'title') String title,@JsonKey(name: 'category') String? category,@JsonKey(name: 'hearts') int hearts,@JsonKey(name: 'durationMin') int? durationMin,@JsonKey(name: 'reason') String reason
});




}
/// @nodoc
class _$AiMissionPickCopyWithImpl<$Res>
    implements $AiMissionPickCopyWith<$Res> {
  _$AiMissionPickCopyWithImpl(this._self, this._then);

  final AiMissionPick _self;
  final $Res Function(AiMissionPick) _then;

/// Create a copy of AiMissionPick
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? templateId = null,Object? title = null,Object? category = freezed,Object? hearts = null,Object? durationMin = freezed,Object? reason = null,}) {
  return _then(_self.copyWith(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,durationMin: freezed == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AiMissionPick].
extension AiMissionPickPatterns on AiMissionPick {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiMissionPick value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiMissionPick() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiMissionPick value)  $default,){
final _that = this;
switch (_that) {
case _AiMissionPick():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiMissionPick value)?  $default,){
final _that = this;
switch (_that) {
case _AiMissionPick() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AiMissionPick implements AiMissionPick {
  const _AiMissionPick({@JsonKey(name: 'templateId') required this.templateId, @JsonKey(name: 'title') this.title = '', @JsonKey(name: 'category') this.category, @JsonKey(name: 'hearts') this.hearts = 0, @JsonKey(name: 'durationMin') this.durationMin, @JsonKey(name: 'reason') this.reason = ''});
  factory _AiMissionPick.fromJson(Map<String, dynamic> json) => _$AiMissionPickFromJson(json);

@override@JsonKey(name: 'templateId') final  String templateId;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'category') final  String? category;
@override@JsonKey(name: 'hearts') final  int hearts;
@override@JsonKey(name: 'durationMin') final  int? durationMin;
@override@JsonKey(name: 'reason') final  String reason;

/// Create a copy of AiMissionPick
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiMissionPickCopyWith<_AiMissionPick> get copyWith => __$AiMissionPickCopyWithImpl<_AiMissionPick>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiMissionPickToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiMissionPick&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,templateId,title,category,hearts,durationMin,reason);

@override
String toString() {
  return 'AiMissionPick(templateId: $templateId, title: $title, category: $category, hearts: $hearts, durationMin: $durationMin, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$AiMissionPickCopyWith<$Res> implements $AiMissionPickCopyWith<$Res> {
  factory _$AiMissionPickCopyWith(_AiMissionPick value, $Res Function(_AiMissionPick) _then) = __$AiMissionPickCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'templateId') String templateId,@JsonKey(name: 'title') String title,@JsonKey(name: 'category') String? category,@JsonKey(name: 'hearts') int hearts,@JsonKey(name: 'durationMin') int? durationMin,@JsonKey(name: 'reason') String reason
});




}
/// @nodoc
class __$AiMissionPickCopyWithImpl<$Res>
    implements _$AiMissionPickCopyWith<$Res> {
  __$AiMissionPickCopyWithImpl(this._self, this._then);

  final _AiMissionPick _self;
  final $Res Function(_AiMissionPick) _then;

/// Create a copy of AiMissionPick
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? templateId = null,Object? title = null,Object? category = freezed,Object? hearts = null,Object? durationMin = freezed,Object? reason = null,}) {
  return _then(_AiMissionPick(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,durationMin: freezed == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
