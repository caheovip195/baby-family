// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemoryRecord {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'familyId') String? get familyId;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'version') int? get version;@JsonKey(name: 'authorUserId') String? get authorUserId;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'body') String? get body;@JsonKey(name: 'occurredAt') DateTime? get occurredAt;@JsonKey(name: 'visibility') String? get visibility;@JsonKey(name: 'familyMoment') bool get familyMoment;@JsonKey(name: 'childIds') List<String> get childIds;@JsonKey(name: 'pregnancyId') String? get pregnancyId;@JsonKey(name: 'pregnancyWeek') int? get pregnancyWeek;@JsonKey(name: 'feeling') String? get feeling;/// “Ai ở đó” (BF-20261021-002) và địa điểm gõ chữ.
@JsonKey(name: 'people') List<MemoryPersonRecord> get people;@JsonKey(name: 'locationLabel') String? get locationLabel;@JsonKey(name: 'quoteContext') String? get quoteContext;@JsonKey(name: 'commentCount') int get commentCount;@JsonKey(name: 'commentsEnabled') bool get commentsEnabled;@JsonKey(name: 'reactions') Map<String, int> get reactions;@JsonKey(name: 'myReaction') String? get myReaction;@JsonKey(name: 'perspectiveCount') int get perspectiveCount;@JsonKey(name: 'coverAssetId') String? get coverAssetId;/// VOICE (BF-20261021-001): thời lượng do server đo từ asset audio.
@JsonKey(name: 'durationSec') double? get durationSec;@JsonKey(name: 'assets') List<MediaAssetRecord> get assets;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'publishedAt') DateTime? get publishedAt;@JsonKey(name: 'trashedAt') DateTime? get trashedAt;@JsonKey(name: 'trashedBy') String? get trashedBy;@JsonKey(name: 'purgeAfter') DateTime? get purgeAfter;
/// Create a copy of MemoryRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryRecordCopyWith<MemoryRecord> get copyWith => _$MemoryRecordCopyWithImpl<MemoryRecord>(this as MemoryRecord, _$identity);

  /// Serializes this MemoryRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.version, version) || other.version == version)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.familyMoment, familyMoment) || other.familyMoment == familyMoment)&&const DeepCollectionEquality().equals(other.childIds, childIds)&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.pregnancyWeek, pregnancyWeek) || other.pregnancyWeek == pregnancyWeek)&&(identical(other.feeling, feeling) || other.feeling == feeling)&&const DeepCollectionEquality().equals(other.people, people)&&(identical(other.locationLabel, locationLabel) || other.locationLabel == locationLabel)&&(identical(other.quoteContext, quoteContext) || other.quoteContext == quoteContext)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.commentsEnabled, commentsEnabled) || other.commentsEnabled == commentsEnabled)&&const DeepCollectionEquality().equals(other.reactions, reactions)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.perspectiveCount, perspectiveCount) || other.perspectiveCount == perspectiveCount)&&(identical(other.coverAssetId, coverAssetId) || other.coverAssetId == coverAssetId)&&(identical(other.durationSec, durationSec) || other.durationSec == durationSec)&&const DeepCollectionEquality().equals(other.assets, assets)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.trashedAt, trashedAt) || other.trashedAt == trashedAt)&&(identical(other.trashedBy, trashedBy) || other.trashedBy == trashedBy)&&(identical(other.purgeAfter, purgeAfter) || other.purgeAfter == purgeAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,familyId,kind,status,version,authorUserId,title,body,occurredAt,visibility,familyMoment,const DeepCollectionEquality().hash(childIds),pregnancyId,pregnancyWeek,feeling,const DeepCollectionEquality().hash(people),locationLabel,quoteContext,commentCount,commentsEnabled,const DeepCollectionEquality().hash(reactions),myReaction,perspectiveCount,coverAssetId,durationSec,const DeepCollectionEquality().hash(assets),createdAt,publishedAt,trashedAt,trashedBy,purgeAfter]);

@override
String toString() {
  return 'MemoryRecord(id: $id, familyId: $familyId, kind: $kind, status: $status, version: $version, authorUserId: $authorUserId, title: $title, body: $body, occurredAt: $occurredAt, visibility: $visibility, familyMoment: $familyMoment, childIds: $childIds, pregnancyId: $pregnancyId, pregnancyWeek: $pregnancyWeek, feeling: $feeling, people: $people, locationLabel: $locationLabel, quoteContext: $quoteContext, commentCount: $commentCount, commentsEnabled: $commentsEnabled, reactions: $reactions, myReaction: $myReaction, perspectiveCount: $perspectiveCount, coverAssetId: $coverAssetId, durationSec: $durationSec, assets: $assets, createdAt: $createdAt, publishedAt: $publishedAt, trashedAt: $trashedAt, trashedBy: $trashedBy, purgeAfter: $purgeAfter)';
}


}

/// @nodoc
abstract mixin class $MemoryRecordCopyWith<$Res>  {
  factory $MemoryRecordCopyWith(MemoryRecord value, $Res Function(MemoryRecord) _then) = _$MemoryRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'status') String? status,@JsonKey(name: 'version') int? version,@JsonKey(name: 'authorUserId') String? authorUserId,@JsonKey(name: 'title') String? title,@JsonKey(name: 'body') String? body,@JsonKey(name: 'occurredAt') DateTime? occurredAt,@JsonKey(name: 'visibility') String? visibility,@JsonKey(name: 'familyMoment') bool familyMoment,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'pregnancyId') String? pregnancyId,@JsonKey(name: 'pregnancyWeek') int? pregnancyWeek,@JsonKey(name: 'feeling') String? feeling,@JsonKey(name: 'people') List<MemoryPersonRecord> people,@JsonKey(name: 'locationLabel') String? locationLabel,@JsonKey(name: 'quoteContext') String? quoteContext,@JsonKey(name: 'commentCount') int commentCount,@JsonKey(name: 'commentsEnabled') bool commentsEnabled,@JsonKey(name: 'reactions') Map<String, int> reactions,@JsonKey(name: 'myReaction') String? myReaction,@JsonKey(name: 'perspectiveCount') int perspectiveCount,@JsonKey(name: 'coverAssetId') String? coverAssetId,@JsonKey(name: 'durationSec') double? durationSec,@JsonKey(name: 'assets') List<MediaAssetRecord> assets,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'publishedAt') DateTime? publishedAt,@JsonKey(name: 'trashedAt') DateTime? trashedAt,@JsonKey(name: 'trashedBy') String? trashedBy,@JsonKey(name: 'purgeAfter') DateTime? purgeAfter
});




}
/// @nodoc
class _$MemoryRecordCopyWithImpl<$Res>
    implements $MemoryRecordCopyWith<$Res> {
  _$MemoryRecordCopyWithImpl(this._self, this._then);

  final MemoryRecord _self;
  final $Res Function(MemoryRecord) _then;

/// Create a copy of MemoryRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? familyId = freezed,Object? kind = freezed,Object? status = freezed,Object? version = freezed,Object? authorUserId = freezed,Object? title = freezed,Object? body = freezed,Object? occurredAt = freezed,Object? visibility = freezed,Object? familyMoment = null,Object? childIds = null,Object? pregnancyId = freezed,Object? pregnancyWeek = freezed,Object? feeling = freezed,Object? people = null,Object? locationLabel = freezed,Object? quoteContext = freezed,Object? commentCount = null,Object? commentsEnabled = null,Object? reactions = null,Object? myReaction = freezed,Object? perspectiveCount = null,Object? coverAssetId = freezed,Object? durationSec = freezed,Object? assets = null,Object? createdAt = freezed,Object? publishedAt = freezed,Object? trashedAt = freezed,Object? trashedBy = freezed,Object? purgeAfter = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,authorUserId: freezed == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: freezed == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,visibility: freezed == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String?,familyMoment: null == familyMoment ? _self.familyMoment : familyMoment // ignore: cast_nullable_to_non_nullable
as bool,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,pregnancyId: freezed == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String?,pregnancyWeek: freezed == pregnancyWeek ? _self.pregnancyWeek : pregnancyWeek // ignore: cast_nullable_to_non_nullable
as int?,feeling: freezed == feeling ? _self.feeling : feeling // ignore: cast_nullable_to_non_nullable
as String?,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as List<MemoryPersonRecord>,locationLabel: freezed == locationLabel ? _self.locationLabel : locationLabel // ignore: cast_nullable_to_non_nullable
as String?,quoteContext: freezed == quoteContext ? _self.quoteContext : quoteContext // ignore: cast_nullable_to_non_nullable
as String?,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,commentsEnabled: null == commentsEnabled ? _self.commentsEnabled : commentsEnabled // ignore: cast_nullable_to_non_nullable
as bool,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as Map<String, int>,myReaction: freezed == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as String?,perspectiveCount: null == perspectiveCount ? _self.perspectiveCount : perspectiveCount // ignore: cast_nullable_to_non_nullable
as int,coverAssetId: freezed == coverAssetId ? _self.coverAssetId : coverAssetId // ignore: cast_nullable_to_non_nullable
as String?,durationSec: freezed == durationSec ? _self.durationSec : durationSec // ignore: cast_nullable_to_non_nullable
as double?,assets: null == assets ? _self.assets : assets // ignore: cast_nullable_to_non_nullable
as List<MediaAssetRecord>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,trashedAt: freezed == trashedAt ? _self.trashedAt : trashedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,trashedBy: freezed == trashedBy ? _self.trashedBy : trashedBy // ignore: cast_nullable_to_non_nullable
as String?,purgeAfter: freezed == purgeAfter ? _self.purgeAfter : purgeAfter // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryRecord].
extension MemoryRecordPatterns on MemoryRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryRecord value)  $default,){
final _that = this;
switch (_that) {
case _MemoryRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MemoryRecord implements MemoryRecord {
  const _MemoryRecord({@JsonKey(name: 'id') this.id, @JsonKey(name: 'familyId') this.familyId, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'status') this.status, @JsonKey(name: 'version') this.version, @JsonKey(name: 'authorUserId') this.authorUserId, @JsonKey(name: 'title') this.title, @JsonKey(name: 'body') this.body, @JsonKey(name: 'occurredAt') this.occurredAt, @JsonKey(name: 'visibility') this.visibility, @JsonKey(name: 'familyMoment') this.familyMoment = false, @JsonKey(name: 'childIds') final  List<String> childIds = const <String>[], @JsonKey(name: 'pregnancyId') this.pregnancyId, @JsonKey(name: 'pregnancyWeek') this.pregnancyWeek, @JsonKey(name: 'feeling') this.feeling, @JsonKey(name: 'people') final  List<MemoryPersonRecord> people = const <MemoryPersonRecord>[], @JsonKey(name: 'locationLabel') this.locationLabel, @JsonKey(name: 'quoteContext') this.quoteContext, @JsonKey(name: 'commentCount') this.commentCount = 0, @JsonKey(name: 'commentsEnabled') this.commentsEnabled = true, @JsonKey(name: 'reactions') final  Map<String, int> reactions = const <String, int>{}, @JsonKey(name: 'myReaction') this.myReaction, @JsonKey(name: 'perspectiveCount') this.perspectiveCount = 0, @JsonKey(name: 'coverAssetId') this.coverAssetId, @JsonKey(name: 'durationSec') this.durationSec, @JsonKey(name: 'assets') final  List<MediaAssetRecord> assets = const <MediaAssetRecord>[], @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'publishedAt') this.publishedAt, @JsonKey(name: 'trashedAt') this.trashedAt, @JsonKey(name: 'trashedBy') this.trashedBy, @JsonKey(name: 'purgeAfter') this.purgeAfter}): _childIds = childIds,_people = people,_reactions = reactions,_assets = assets;
  factory _MemoryRecord.fromJson(Map<String, dynamic> json) => _$MemoryRecordFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'familyId') final  String? familyId;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'version') final  int? version;
@override@JsonKey(name: 'authorUserId') final  String? authorUserId;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'body') final  String? body;
@override@JsonKey(name: 'occurredAt') final  DateTime? occurredAt;
@override@JsonKey(name: 'visibility') final  String? visibility;
@override@JsonKey(name: 'familyMoment') final  bool familyMoment;
 final  List<String> _childIds;
@override@JsonKey(name: 'childIds') List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}

@override@JsonKey(name: 'pregnancyId') final  String? pregnancyId;
@override@JsonKey(name: 'pregnancyWeek') final  int? pregnancyWeek;
@override@JsonKey(name: 'feeling') final  String? feeling;
/// “Ai ở đó” (BF-20261021-002) và địa điểm gõ chữ.
 final  List<MemoryPersonRecord> _people;
/// “Ai ở đó” (BF-20261021-002) và địa điểm gõ chữ.
@override@JsonKey(name: 'people') List<MemoryPersonRecord> get people {
  if (_people is EqualUnmodifiableListView) return _people;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_people);
}

@override@JsonKey(name: 'locationLabel') final  String? locationLabel;
@override@JsonKey(name: 'quoteContext') final  String? quoteContext;
@override@JsonKey(name: 'commentCount') final  int commentCount;
@override@JsonKey(name: 'commentsEnabled') final  bool commentsEnabled;
 final  Map<String, int> _reactions;
@override@JsonKey(name: 'reactions') Map<String, int> get reactions {
  if (_reactions is EqualUnmodifiableMapView) return _reactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_reactions);
}

@override@JsonKey(name: 'myReaction') final  String? myReaction;
@override@JsonKey(name: 'perspectiveCount') final  int perspectiveCount;
@override@JsonKey(name: 'coverAssetId') final  String? coverAssetId;
/// VOICE (BF-20261021-001): thời lượng do server đo từ asset audio.
@override@JsonKey(name: 'durationSec') final  double? durationSec;
 final  List<MediaAssetRecord> _assets;
@override@JsonKey(name: 'assets') List<MediaAssetRecord> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}

@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
@override@JsonKey(name: 'publishedAt') final  DateTime? publishedAt;
@override@JsonKey(name: 'trashedAt') final  DateTime? trashedAt;
@override@JsonKey(name: 'trashedBy') final  String? trashedBy;
@override@JsonKey(name: 'purgeAfter') final  DateTime? purgeAfter;

/// Create a copy of MemoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryRecordCopyWith<_MemoryRecord> get copyWith => __$MemoryRecordCopyWithImpl<_MemoryRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.version, version) || other.version == version)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.familyMoment, familyMoment) || other.familyMoment == familyMoment)&&const DeepCollectionEquality().equals(other._childIds, _childIds)&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.pregnancyWeek, pregnancyWeek) || other.pregnancyWeek == pregnancyWeek)&&(identical(other.feeling, feeling) || other.feeling == feeling)&&const DeepCollectionEquality().equals(other._people, _people)&&(identical(other.locationLabel, locationLabel) || other.locationLabel == locationLabel)&&(identical(other.quoteContext, quoteContext) || other.quoteContext == quoteContext)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.commentsEnabled, commentsEnabled) || other.commentsEnabled == commentsEnabled)&&const DeepCollectionEquality().equals(other._reactions, _reactions)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.perspectiveCount, perspectiveCount) || other.perspectiveCount == perspectiveCount)&&(identical(other.coverAssetId, coverAssetId) || other.coverAssetId == coverAssetId)&&(identical(other.durationSec, durationSec) || other.durationSec == durationSec)&&const DeepCollectionEquality().equals(other._assets, _assets)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.trashedAt, trashedAt) || other.trashedAt == trashedAt)&&(identical(other.trashedBy, trashedBy) || other.trashedBy == trashedBy)&&(identical(other.purgeAfter, purgeAfter) || other.purgeAfter == purgeAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,familyId,kind,status,version,authorUserId,title,body,occurredAt,visibility,familyMoment,const DeepCollectionEquality().hash(_childIds),pregnancyId,pregnancyWeek,feeling,const DeepCollectionEquality().hash(_people),locationLabel,quoteContext,commentCount,commentsEnabled,const DeepCollectionEquality().hash(_reactions),myReaction,perspectiveCount,coverAssetId,durationSec,const DeepCollectionEquality().hash(_assets),createdAt,publishedAt,trashedAt,trashedBy,purgeAfter]);

@override
String toString() {
  return 'MemoryRecord(id: $id, familyId: $familyId, kind: $kind, status: $status, version: $version, authorUserId: $authorUserId, title: $title, body: $body, occurredAt: $occurredAt, visibility: $visibility, familyMoment: $familyMoment, childIds: $childIds, pregnancyId: $pregnancyId, pregnancyWeek: $pregnancyWeek, feeling: $feeling, people: $people, locationLabel: $locationLabel, quoteContext: $quoteContext, commentCount: $commentCount, commentsEnabled: $commentsEnabled, reactions: $reactions, myReaction: $myReaction, perspectiveCount: $perspectiveCount, coverAssetId: $coverAssetId, durationSec: $durationSec, assets: $assets, createdAt: $createdAt, publishedAt: $publishedAt, trashedAt: $trashedAt, trashedBy: $trashedBy, purgeAfter: $purgeAfter)';
}


}

/// @nodoc
abstract mixin class _$MemoryRecordCopyWith<$Res> implements $MemoryRecordCopyWith<$Res> {
  factory _$MemoryRecordCopyWith(_MemoryRecord value, $Res Function(_MemoryRecord) _then) = __$MemoryRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'status') String? status,@JsonKey(name: 'version') int? version,@JsonKey(name: 'authorUserId') String? authorUserId,@JsonKey(name: 'title') String? title,@JsonKey(name: 'body') String? body,@JsonKey(name: 'occurredAt') DateTime? occurredAt,@JsonKey(name: 'visibility') String? visibility,@JsonKey(name: 'familyMoment') bool familyMoment,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'pregnancyId') String? pregnancyId,@JsonKey(name: 'pregnancyWeek') int? pregnancyWeek,@JsonKey(name: 'feeling') String? feeling,@JsonKey(name: 'people') List<MemoryPersonRecord> people,@JsonKey(name: 'locationLabel') String? locationLabel,@JsonKey(name: 'quoteContext') String? quoteContext,@JsonKey(name: 'commentCount') int commentCount,@JsonKey(name: 'commentsEnabled') bool commentsEnabled,@JsonKey(name: 'reactions') Map<String, int> reactions,@JsonKey(name: 'myReaction') String? myReaction,@JsonKey(name: 'perspectiveCount') int perspectiveCount,@JsonKey(name: 'coverAssetId') String? coverAssetId,@JsonKey(name: 'durationSec') double? durationSec,@JsonKey(name: 'assets') List<MediaAssetRecord> assets,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'publishedAt') DateTime? publishedAt,@JsonKey(name: 'trashedAt') DateTime? trashedAt,@JsonKey(name: 'trashedBy') String? trashedBy,@JsonKey(name: 'purgeAfter') DateTime? purgeAfter
});




}
/// @nodoc
class __$MemoryRecordCopyWithImpl<$Res>
    implements _$MemoryRecordCopyWith<$Res> {
  __$MemoryRecordCopyWithImpl(this._self, this._then);

  final _MemoryRecord _self;
  final $Res Function(_MemoryRecord) _then;

/// Create a copy of MemoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? familyId = freezed,Object? kind = freezed,Object? status = freezed,Object? version = freezed,Object? authorUserId = freezed,Object? title = freezed,Object? body = freezed,Object? occurredAt = freezed,Object? visibility = freezed,Object? familyMoment = null,Object? childIds = null,Object? pregnancyId = freezed,Object? pregnancyWeek = freezed,Object? feeling = freezed,Object? people = null,Object? locationLabel = freezed,Object? quoteContext = freezed,Object? commentCount = null,Object? commentsEnabled = null,Object? reactions = null,Object? myReaction = freezed,Object? perspectiveCount = null,Object? coverAssetId = freezed,Object? durationSec = freezed,Object? assets = null,Object? createdAt = freezed,Object? publishedAt = freezed,Object? trashedAt = freezed,Object? trashedBy = freezed,Object? purgeAfter = freezed,}) {
  return _then(_MemoryRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,authorUserId: freezed == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: freezed == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,visibility: freezed == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String?,familyMoment: null == familyMoment ? _self.familyMoment : familyMoment // ignore: cast_nullable_to_non_nullable
as bool,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,pregnancyId: freezed == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as String?,pregnancyWeek: freezed == pregnancyWeek ? _self.pregnancyWeek : pregnancyWeek // ignore: cast_nullable_to_non_nullable
as int?,feeling: freezed == feeling ? _self.feeling : feeling // ignore: cast_nullable_to_non_nullable
as String?,people: null == people ? _self._people : people // ignore: cast_nullable_to_non_nullable
as List<MemoryPersonRecord>,locationLabel: freezed == locationLabel ? _self.locationLabel : locationLabel // ignore: cast_nullable_to_non_nullable
as String?,quoteContext: freezed == quoteContext ? _self.quoteContext : quoteContext // ignore: cast_nullable_to_non_nullable
as String?,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,commentsEnabled: null == commentsEnabled ? _self.commentsEnabled : commentsEnabled // ignore: cast_nullable_to_non_nullable
as bool,reactions: null == reactions ? _self._reactions : reactions // ignore: cast_nullable_to_non_nullable
as Map<String, int>,myReaction: freezed == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as String?,perspectiveCount: null == perspectiveCount ? _self.perspectiveCount : perspectiveCount // ignore: cast_nullable_to_non_nullable
as int,coverAssetId: freezed == coverAssetId ? _self.coverAssetId : coverAssetId // ignore: cast_nullable_to_non_nullable
as String?,durationSec: freezed == durationSec ? _self.durationSec : durationSec // ignore: cast_nullable_to_non_nullable
as double?,assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<MediaAssetRecord>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,trashedAt: freezed == trashedAt ? _self.trashedAt : trashedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,trashedBy: freezed == trashedBy ? _self.trashedBy : trashedBy // ignore: cast_nullable_to_non_nullable
as String?,purgeAfter: freezed == purgeAfter ? _self.purgeAfter : purgeAfter // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$MemoryPersonRecord {

@JsonKey(name: 'memberId') String? get memberId;@JsonKey(name: 'userId') String? get userId;@JsonKey(name: 'displayName') String get displayName;
/// Create a copy of MemoryPersonRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryPersonRecordCopyWith<MemoryPersonRecord> get copyWith => _$MemoryPersonRecordCopyWithImpl<MemoryPersonRecord>(this as MemoryPersonRecord, _$identity);

  /// Serializes this MemoryPersonRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryPersonRecord&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberId,userId,displayName);

@override
String toString() {
  return 'MemoryPersonRecord(memberId: $memberId, userId: $userId, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class $MemoryPersonRecordCopyWith<$Res>  {
  factory $MemoryPersonRecordCopyWith(MemoryPersonRecord value, $Res Function(MemoryPersonRecord) _then) = _$MemoryPersonRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'memberId') String? memberId,@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'displayName') String displayName
});




}
/// @nodoc
class _$MemoryPersonRecordCopyWithImpl<$Res>
    implements $MemoryPersonRecordCopyWith<$Res> {
  _$MemoryPersonRecordCopyWithImpl(this._self, this._then);

  final MemoryPersonRecord _self;
  final $Res Function(MemoryPersonRecord) _then;

/// Create a copy of MemoryPersonRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberId = freezed,Object? userId = freezed,Object? displayName = null,}) {
  return _then(_self.copyWith(
memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryPersonRecord].
extension MemoryPersonRecordPatterns on MemoryPersonRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryPersonRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryPersonRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryPersonRecord value)  $default,){
final _that = this;
switch (_that) {
case _MemoryPersonRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryPersonRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryPersonRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MemoryPersonRecord implements MemoryPersonRecord {
  const _MemoryPersonRecord({@JsonKey(name: 'memberId') this.memberId, @JsonKey(name: 'userId') this.userId, @JsonKey(name: 'displayName') this.displayName = ''});
  factory _MemoryPersonRecord.fromJson(Map<String, dynamic> json) => _$MemoryPersonRecordFromJson(json);

@override@JsonKey(name: 'memberId') final  String? memberId;
@override@JsonKey(name: 'userId') final  String? userId;
@override@JsonKey(name: 'displayName') final  String displayName;

/// Create a copy of MemoryPersonRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryPersonRecordCopyWith<_MemoryPersonRecord> get copyWith => __$MemoryPersonRecordCopyWithImpl<_MemoryPersonRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryPersonRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryPersonRecord&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberId,userId,displayName);

@override
String toString() {
  return 'MemoryPersonRecord(memberId: $memberId, userId: $userId, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$MemoryPersonRecordCopyWith<$Res> implements $MemoryPersonRecordCopyWith<$Res> {
  factory _$MemoryPersonRecordCopyWith(_MemoryPersonRecord value, $Res Function(_MemoryPersonRecord) _then) = __$MemoryPersonRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'memberId') String? memberId,@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'displayName') String displayName
});




}
/// @nodoc
class __$MemoryPersonRecordCopyWithImpl<$Res>
    implements _$MemoryPersonRecordCopyWith<$Res> {
  __$MemoryPersonRecordCopyWithImpl(this._self, this._then);

  final _MemoryPersonRecord _self;
  final $Res Function(_MemoryPersonRecord) _then;

/// Create a copy of MemoryPersonRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberId = freezed,Object? userId = freezed,Object? displayName = null,}) {
  return _then(_MemoryPersonRecord(
memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
