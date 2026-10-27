// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Memory {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'familyId') String get familyId;@JsonKey(name: 'kind') MemoryKind get kind;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'body') String? get body;@JsonKey(name: 'quoteContext') String? get quoteContext;@JsonKey(name: 'childIds') List<String> get childIds;@JsonKey(name: 'authorId') String get authorId;@JsonKey(name: 'occurredAt') DateTime get occurredAt;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'mediaAssets') List<String> get mediaAssets;@JsonKey(name: 'visibility') MemoryVisibility get visibility;@JsonKey(name: 'feeling') String? get feeling;@JsonKey(name: 'people') List<String> get people;@JsonKey(name: 'locationLabel') String? get locationLabel;@JsonKey(name: 'milestoneCode') String? get milestoneCode;@JsonKey(name: 'milestoneTitle') String? get milestoneTitle;@JsonKey(name: 'monthIndex') int? get monthIndex;@JsonKey(name: 'pregnancyWeek') int? get pregnancyWeek;@JsonKey(name: 'pregnancyDay') int? get pregnancyDay;@JsonKey(name: 'voiceDurationSec') int? get voiceDurationSec;/// VOICE bản server: URL nghe đã ký (biến thể `a`, hết hạn ~1 giờ).
@JsonKey(name: 'voiceUrl') String? get voiceUrl;@JsonKey(name: 'sealedUntil') DateTime? get sealedUntil;@JsonKey(name: 'missionId') String? get missionId;@JsonKey(name: 'reactions') Map<String, int> get reactions;/// Cảm xúc của người xem (mỗi người 1 cảm xúc/ký ức, đổi được — đặc tả 7.12).
@JsonKey(name: 'myReaction') String? get myReaction;@JsonKey(name: 'reactorNames') List<String> get reactorNames;@JsonKey(name: 'commentCount') int get commentCount;/// Tác giả có thể tắt bình luận cho từng ký ức (MEM-07).
@JsonKey(name: 'commentsEnabled') bool get commentsEnabled;@JsonKey(name: 'perspectiveCount') int get perspectiveCount;@JsonKey(name: 'perspectiveAuthorId') String? get perspectiveAuthorId;@JsonKey(name: 'perspectivePreview') String? get perspectivePreview;@JsonKey(name: 'isFavorite') bool get isFavorite;@JsonKey(name: 'pinned') bool get pinned;/// MEM-17: ngày xoá / người xoá (thùng rác giữ 30 ngày).
@JsonKey(name: 'deletedAt') DateTime? get deletedAt;@JsonKey(name: 'deletedByUserId') String? get deletedByUserId;/// MEM-19: lý do từ chối ảnh người thân đăng.
@JsonKey(name: 'rejectReason') String? get rejectReason;/// MEM-06: ký ức đang tải nền (số ảnh/video đã tải / tổng); null khi
/// không còn tải. [uploadFailed] → “Tải lên chưa xong. Thử lại”.
/// MEM-08: URL phát video theo từng ảnh của [mediaAssets] (null = ảnh).
@JsonKey(name: 'mediaVideos') List<String?> get mediaVideos;@JsonKey(name: 'uploadDone') int? get uploadDone;@JsonKey(name: 'uploadTotal') int? get uploadTotal;@JsonKey(name: 'uploadFailed') bool get uploadFailed;/// Offline-first (BF-20261022-001): đang chờ có mạng, sẽ tự gửi lại.
@JsonKey(name: 'uploadWaiting') bool get uploadWaiting;
/// Create a copy of Memory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryCopyWith<Memory> get copyWith => _$MemoryCopyWithImpl<Memory>(this as Memory, _$identity);

  /// Serializes this Memory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Memory&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.quoteContext, quoteContext) || other.quoteContext == quoteContext)&&const DeepCollectionEquality().equals(other.childIds, childIds)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.mediaAssets, mediaAssets)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.feeling, feeling) || other.feeling == feeling)&&const DeepCollectionEquality().equals(other.people, people)&&(identical(other.locationLabel, locationLabel) || other.locationLabel == locationLabel)&&(identical(other.milestoneCode, milestoneCode) || other.milestoneCode == milestoneCode)&&(identical(other.milestoneTitle, milestoneTitle) || other.milestoneTitle == milestoneTitle)&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.pregnancyWeek, pregnancyWeek) || other.pregnancyWeek == pregnancyWeek)&&(identical(other.pregnancyDay, pregnancyDay) || other.pregnancyDay == pregnancyDay)&&(identical(other.voiceDurationSec, voiceDurationSec) || other.voiceDurationSec == voiceDurationSec)&&(identical(other.voiceUrl, voiceUrl) || other.voiceUrl == voiceUrl)&&(identical(other.sealedUntil, sealedUntil) || other.sealedUntil == sealedUntil)&&(identical(other.missionId, missionId) || other.missionId == missionId)&&const DeepCollectionEquality().equals(other.reactions, reactions)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&const DeepCollectionEquality().equals(other.reactorNames, reactorNames)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.commentsEnabled, commentsEnabled) || other.commentsEnabled == commentsEnabled)&&(identical(other.perspectiveCount, perspectiveCount) || other.perspectiveCount == perspectiveCount)&&(identical(other.perspectiveAuthorId, perspectiveAuthorId) || other.perspectiveAuthorId == perspectiveAuthorId)&&(identical(other.perspectivePreview, perspectivePreview) || other.perspectivePreview == perspectivePreview)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.pinned, pinned) || other.pinned == pinned)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.deletedByUserId, deletedByUserId) || other.deletedByUserId == deletedByUserId)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason)&&const DeepCollectionEquality().equals(other.mediaVideos, mediaVideos)&&(identical(other.uploadDone, uploadDone) || other.uploadDone == uploadDone)&&(identical(other.uploadTotal, uploadTotal) || other.uploadTotal == uploadTotal)&&(identical(other.uploadFailed, uploadFailed) || other.uploadFailed == uploadFailed)&&(identical(other.uploadWaiting, uploadWaiting) || other.uploadWaiting == uploadWaiting));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,familyId,kind,title,body,quoteContext,const DeepCollectionEquality().hash(childIds),authorId,occurredAt,createdAt,const DeepCollectionEquality().hash(mediaAssets),visibility,feeling,const DeepCollectionEquality().hash(people),locationLabel,milestoneCode,milestoneTitle,monthIndex,pregnancyWeek,pregnancyDay,voiceDurationSec,voiceUrl,sealedUntil,missionId,const DeepCollectionEquality().hash(reactions),myReaction,const DeepCollectionEquality().hash(reactorNames),commentCount,commentsEnabled,perspectiveCount,perspectiveAuthorId,perspectivePreview,isFavorite,pinned,deletedAt,deletedByUserId,rejectReason,const DeepCollectionEquality().hash(mediaVideos),uploadDone,uploadTotal,uploadFailed,uploadWaiting]);

@override
String toString() {
  return 'Memory(id: $id, familyId: $familyId, kind: $kind, title: $title, body: $body, quoteContext: $quoteContext, childIds: $childIds, authorId: $authorId, occurredAt: $occurredAt, createdAt: $createdAt, mediaAssets: $mediaAssets, visibility: $visibility, feeling: $feeling, people: $people, locationLabel: $locationLabel, milestoneCode: $milestoneCode, milestoneTitle: $milestoneTitle, monthIndex: $monthIndex, pregnancyWeek: $pregnancyWeek, pregnancyDay: $pregnancyDay, voiceDurationSec: $voiceDurationSec, voiceUrl: $voiceUrl, sealedUntil: $sealedUntil, missionId: $missionId, reactions: $reactions, myReaction: $myReaction, reactorNames: $reactorNames, commentCount: $commentCount, commentsEnabled: $commentsEnabled, perspectiveCount: $perspectiveCount, perspectiveAuthorId: $perspectiveAuthorId, perspectivePreview: $perspectivePreview, isFavorite: $isFavorite, pinned: $pinned, deletedAt: $deletedAt, deletedByUserId: $deletedByUserId, rejectReason: $rejectReason, mediaVideos: $mediaVideos, uploadDone: $uploadDone, uploadTotal: $uploadTotal, uploadFailed: $uploadFailed, uploadWaiting: $uploadWaiting)';
}


}

/// @nodoc
abstract mixin class $MemoryCopyWith<$Res>  {
  factory $MemoryCopyWith(Memory value, $Res Function(Memory) _then) = _$MemoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'familyId') String familyId,@JsonKey(name: 'kind') MemoryKind kind,@JsonKey(name: 'title') String? title,@JsonKey(name: 'body') String? body,@JsonKey(name: 'quoteContext') String? quoteContext,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'authorId') String authorId,@JsonKey(name: 'occurredAt') DateTime occurredAt,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'mediaAssets') List<String> mediaAssets,@JsonKey(name: 'visibility') MemoryVisibility visibility,@JsonKey(name: 'feeling') String? feeling,@JsonKey(name: 'people') List<String> people,@JsonKey(name: 'locationLabel') String? locationLabel,@JsonKey(name: 'milestoneCode') String? milestoneCode,@JsonKey(name: 'milestoneTitle') String? milestoneTitle,@JsonKey(name: 'monthIndex') int? monthIndex,@JsonKey(name: 'pregnancyWeek') int? pregnancyWeek,@JsonKey(name: 'pregnancyDay') int? pregnancyDay,@JsonKey(name: 'voiceDurationSec') int? voiceDurationSec,@JsonKey(name: 'voiceUrl') String? voiceUrl,@JsonKey(name: 'sealedUntil') DateTime? sealedUntil,@JsonKey(name: 'missionId') String? missionId,@JsonKey(name: 'reactions') Map<String, int> reactions,@JsonKey(name: 'myReaction') String? myReaction,@JsonKey(name: 'reactorNames') List<String> reactorNames,@JsonKey(name: 'commentCount') int commentCount,@JsonKey(name: 'commentsEnabled') bool commentsEnabled,@JsonKey(name: 'perspectiveCount') int perspectiveCount,@JsonKey(name: 'perspectiveAuthorId') String? perspectiveAuthorId,@JsonKey(name: 'perspectivePreview') String? perspectivePreview,@JsonKey(name: 'isFavorite') bool isFavorite,@JsonKey(name: 'pinned') bool pinned,@JsonKey(name: 'deletedAt') DateTime? deletedAt,@JsonKey(name: 'deletedByUserId') String? deletedByUserId,@JsonKey(name: 'rejectReason') String? rejectReason,@JsonKey(name: 'mediaVideos') List<String?> mediaVideos,@JsonKey(name: 'uploadDone') int? uploadDone,@JsonKey(name: 'uploadTotal') int? uploadTotal,@JsonKey(name: 'uploadFailed') bool uploadFailed,@JsonKey(name: 'uploadWaiting') bool uploadWaiting
});




}
/// @nodoc
class _$MemoryCopyWithImpl<$Res>
    implements $MemoryCopyWith<$Res> {
  _$MemoryCopyWithImpl(this._self, this._then);

  final Memory _self;
  final $Res Function(Memory) _then;

/// Create a copy of Memory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? familyId = null,Object? kind = null,Object? title = freezed,Object? body = freezed,Object? quoteContext = freezed,Object? childIds = null,Object? authorId = null,Object? occurredAt = null,Object? createdAt = freezed,Object? mediaAssets = null,Object? visibility = null,Object? feeling = freezed,Object? people = null,Object? locationLabel = freezed,Object? milestoneCode = freezed,Object? milestoneTitle = freezed,Object? monthIndex = freezed,Object? pregnancyWeek = freezed,Object? pregnancyDay = freezed,Object? voiceDurationSec = freezed,Object? voiceUrl = freezed,Object? sealedUntil = freezed,Object? missionId = freezed,Object? reactions = null,Object? myReaction = freezed,Object? reactorNames = null,Object? commentCount = null,Object? commentsEnabled = null,Object? perspectiveCount = null,Object? perspectiveAuthorId = freezed,Object? perspectivePreview = freezed,Object? isFavorite = null,Object? pinned = null,Object? deletedAt = freezed,Object? deletedByUserId = freezed,Object? rejectReason = freezed,Object? mediaVideos = null,Object? uploadDone = freezed,Object? uploadTotal = freezed,Object? uploadFailed = null,Object? uploadWaiting = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MemoryKind,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,quoteContext: freezed == quoteContext ? _self.quoteContext : quoteContext // ignore: cast_nullable_to_non_nullable
as String?,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,mediaAssets: null == mediaAssets ? _self.mediaAssets : mediaAssets // ignore: cast_nullable_to_non_nullable
as List<String>,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as MemoryVisibility,feeling: freezed == feeling ? _self.feeling : feeling // ignore: cast_nullable_to_non_nullable
as String?,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as List<String>,locationLabel: freezed == locationLabel ? _self.locationLabel : locationLabel // ignore: cast_nullable_to_non_nullable
as String?,milestoneCode: freezed == milestoneCode ? _self.milestoneCode : milestoneCode // ignore: cast_nullable_to_non_nullable
as String?,milestoneTitle: freezed == milestoneTitle ? _self.milestoneTitle : milestoneTitle // ignore: cast_nullable_to_non_nullable
as String?,monthIndex: freezed == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int?,pregnancyWeek: freezed == pregnancyWeek ? _self.pregnancyWeek : pregnancyWeek // ignore: cast_nullable_to_non_nullable
as int?,pregnancyDay: freezed == pregnancyDay ? _self.pregnancyDay : pregnancyDay // ignore: cast_nullable_to_non_nullable
as int?,voiceDurationSec: freezed == voiceDurationSec ? _self.voiceDurationSec : voiceDurationSec // ignore: cast_nullable_to_non_nullable
as int?,voiceUrl: freezed == voiceUrl ? _self.voiceUrl : voiceUrl // ignore: cast_nullable_to_non_nullable
as String?,sealedUntil: freezed == sealedUntil ? _self.sealedUntil : sealedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,missionId: freezed == missionId ? _self.missionId : missionId // ignore: cast_nullable_to_non_nullable
as String?,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as Map<String, int>,myReaction: freezed == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as String?,reactorNames: null == reactorNames ? _self.reactorNames : reactorNames // ignore: cast_nullable_to_non_nullable
as List<String>,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,commentsEnabled: null == commentsEnabled ? _self.commentsEnabled : commentsEnabled // ignore: cast_nullable_to_non_nullable
as bool,perspectiveCount: null == perspectiveCount ? _self.perspectiveCount : perspectiveCount // ignore: cast_nullable_to_non_nullable
as int,perspectiveAuthorId: freezed == perspectiveAuthorId ? _self.perspectiveAuthorId : perspectiveAuthorId // ignore: cast_nullable_to_non_nullable
as String?,perspectivePreview: freezed == perspectivePreview ? _self.perspectivePreview : perspectivePreview // ignore: cast_nullable_to_non_nullable
as String?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,pinned: null == pinned ? _self.pinned : pinned // ignore: cast_nullable_to_non_nullable
as bool,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedByUserId: freezed == deletedByUserId ? _self.deletedByUserId : deletedByUserId // ignore: cast_nullable_to_non_nullable
as String?,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,mediaVideos: null == mediaVideos ? _self.mediaVideos : mediaVideos // ignore: cast_nullable_to_non_nullable
as List<String?>,uploadDone: freezed == uploadDone ? _self.uploadDone : uploadDone // ignore: cast_nullable_to_non_nullable
as int?,uploadTotal: freezed == uploadTotal ? _self.uploadTotal : uploadTotal // ignore: cast_nullable_to_non_nullable
as int?,uploadFailed: null == uploadFailed ? _self.uploadFailed : uploadFailed // ignore: cast_nullable_to_non_nullable
as bool,uploadWaiting: null == uploadWaiting ? _self.uploadWaiting : uploadWaiting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Memory].
extension MemoryPatterns on Memory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Memory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Memory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Memory value)  $default,){
final _that = this;
switch (_that) {
case _Memory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Memory value)?  $default,){
final _that = this;
switch (_that) {
case _Memory() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Memory extends Memory {
  const _Memory({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'familyId') required this.familyId, @JsonKey(name: 'kind') required this.kind, @JsonKey(name: 'title') this.title, @JsonKey(name: 'body') this.body, @JsonKey(name: 'quoteContext') this.quoteContext, @JsonKey(name: 'childIds') final  List<String> childIds = const [], @JsonKey(name: 'authorId') required this.authorId, @JsonKey(name: 'occurredAt') required this.occurredAt, @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'mediaAssets') final  List<String> mediaAssets = const [], @JsonKey(name: 'visibility') this.visibility = MemoryVisibility.family, @JsonKey(name: 'feeling') this.feeling, @JsonKey(name: 'people') final  List<String> people = const [], @JsonKey(name: 'locationLabel') this.locationLabel, @JsonKey(name: 'milestoneCode') this.milestoneCode, @JsonKey(name: 'milestoneTitle') this.milestoneTitle, @JsonKey(name: 'monthIndex') this.monthIndex, @JsonKey(name: 'pregnancyWeek') this.pregnancyWeek, @JsonKey(name: 'pregnancyDay') this.pregnancyDay, @JsonKey(name: 'voiceDurationSec') this.voiceDurationSec, @JsonKey(name: 'voiceUrl') this.voiceUrl, @JsonKey(name: 'sealedUntil') this.sealedUntil, @JsonKey(name: 'missionId') this.missionId, @JsonKey(name: 'reactions') final  Map<String, int> reactions = const {}, @JsonKey(name: 'myReaction') this.myReaction, @JsonKey(name: 'reactorNames') final  List<String> reactorNames = const [], @JsonKey(name: 'commentCount') this.commentCount = 0, @JsonKey(name: 'commentsEnabled') this.commentsEnabled = true, @JsonKey(name: 'perspectiveCount') this.perspectiveCount = 0, @JsonKey(name: 'perspectiveAuthorId') this.perspectiveAuthorId, @JsonKey(name: 'perspectivePreview') this.perspectivePreview, @JsonKey(name: 'isFavorite') this.isFavorite = false, @JsonKey(name: 'pinned') this.pinned = false, @JsonKey(name: 'deletedAt') this.deletedAt, @JsonKey(name: 'deletedByUserId') this.deletedByUserId, @JsonKey(name: 'rejectReason') this.rejectReason, @JsonKey(name: 'mediaVideos') final  List<String?> mediaVideos = const [], @JsonKey(name: 'uploadDone') this.uploadDone, @JsonKey(name: 'uploadTotal') this.uploadTotal, @JsonKey(name: 'uploadFailed') this.uploadFailed = false, @JsonKey(name: 'uploadWaiting') this.uploadWaiting = false}): _childIds = childIds,_mediaAssets = mediaAssets,_people = people,_reactions = reactions,_reactorNames = reactorNames,_mediaVideos = mediaVideos,super._();
  factory _Memory.fromJson(Map<String, dynamic> json) => _$MemoryFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'familyId') final  String familyId;
@override@JsonKey(name: 'kind') final  MemoryKind kind;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'body') final  String? body;
@override@JsonKey(name: 'quoteContext') final  String? quoteContext;
 final  List<String> _childIds;
@override@JsonKey(name: 'childIds') List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}

@override@JsonKey(name: 'authorId') final  String authorId;
@override@JsonKey(name: 'occurredAt') final  DateTime occurredAt;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
 final  List<String> _mediaAssets;
@override@JsonKey(name: 'mediaAssets') List<String> get mediaAssets {
  if (_mediaAssets is EqualUnmodifiableListView) return _mediaAssets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaAssets);
}

@override@JsonKey(name: 'visibility') final  MemoryVisibility visibility;
@override@JsonKey(name: 'feeling') final  String? feeling;
 final  List<String> _people;
@override@JsonKey(name: 'people') List<String> get people {
  if (_people is EqualUnmodifiableListView) return _people;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_people);
}

@override@JsonKey(name: 'locationLabel') final  String? locationLabel;
@override@JsonKey(name: 'milestoneCode') final  String? milestoneCode;
@override@JsonKey(name: 'milestoneTitle') final  String? milestoneTitle;
@override@JsonKey(name: 'monthIndex') final  int? monthIndex;
@override@JsonKey(name: 'pregnancyWeek') final  int? pregnancyWeek;
@override@JsonKey(name: 'pregnancyDay') final  int? pregnancyDay;
@override@JsonKey(name: 'voiceDurationSec') final  int? voiceDurationSec;
/// VOICE bản server: URL nghe đã ký (biến thể `a`, hết hạn ~1 giờ).
@override@JsonKey(name: 'voiceUrl') final  String? voiceUrl;
@override@JsonKey(name: 'sealedUntil') final  DateTime? sealedUntil;
@override@JsonKey(name: 'missionId') final  String? missionId;
 final  Map<String, int> _reactions;
@override@JsonKey(name: 'reactions') Map<String, int> get reactions {
  if (_reactions is EqualUnmodifiableMapView) return _reactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_reactions);
}

/// Cảm xúc của người xem (mỗi người 1 cảm xúc/ký ức, đổi được — đặc tả 7.12).
@override@JsonKey(name: 'myReaction') final  String? myReaction;
 final  List<String> _reactorNames;
@override@JsonKey(name: 'reactorNames') List<String> get reactorNames {
  if (_reactorNames is EqualUnmodifiableListView) return _reactorNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reactorNames);
}

@override@JsonKey(name: 'commentCount') final  int commentCount;
/// Tác giả có thể tắt bình luận cho từng ký ức (MEM-07).
@override@JsonKey(name: 'commentsEnabled') final  bool commentsEnabled;
@override@JsonKey(name: 'perspectiveCount') final  int perspectiveCount;
@override@JsonKey(name: 'perspectiveAuthorId') final  String? perspectiveAuthorId;
@override@JsonKey(name: 'perspectivePreview') final  String? perspectivePreview;
@override@JsonKey(name: 'isFavorite') final  bool isFavorite;
@override@JsonKey(name: 'pinned') final  bool pinned;
/// MEM-17: ngày xoá / người xoá (thùng rác giữ 30 ngày).
@override@JsonKey(name: 'deletedAt') final  DateTime? deletedAt;
@override@JsonKey(name: 'deletedByUserId') final  String? deletedByUserId;
/// MEM-19: lý do từ chối ảnh người thân đăng.
@override@JsonKey(name: 'rejectReason') final  String? rejectReason;
/// MEM-06: ký ức đang tải nền (số ảnh/video đã tải / tổng); null khi
/// không còn tải. [uploadFailed] → “Tải lên chưa xong. Thử lại”.
/// MEM-08: URL phát video theo từng ảnh của [mediaAssets] (null = ảnh).
 final  List<String?> _mediaVideos;
/// MEM-06: ký ức đang tải nền (số ảnh/video đã tải / tổng); null khi
/// không còn tải. [uploadFailed] → “Tải lên chưa xong. Thử lại”.
/// MEM-08: URL phát video theo từng ảnh của [mediaAssets] (null = ảnh).
@override@JsonKey(name: 'mediaVideos') List<String?> get mediaVideos {
  if (_mediaVideos is EqualUnmodifiableListView) return _mediaVideos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaVideos);
}

@override@JsonKey(name: 'uploadDone') final  int? uploadDone;
@override@JsonKey(name: 'uploadTotal') final  int? uploadTotal;
@override@JsonKey(name: 'uploadFailed') final  bool uploadFailed;
/// Offline-first (BF-20261022-001): đang chờ có mạng, sẽ tự gửi lại.
@override@JsonKey(name: 'uploadWaiting') final  bool uploadWaiting;

/// Create a copy of Memory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryCopyWith<_Memory> get copyWith => __$MemoryCopyWithImpl<_Memory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Memory&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.quoteContext, quoteContext) || other.quoteContext == quoteContext)&&const DeepCollectionEquality().equals(other._childIds, _childIds)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._mediaAssets, _mediaAssets)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.feeling, feeling) || other.feeling == feeling)&&const DeepCollectionEquality().equals(other._people, _people)&&(identical(other.locationLabel, locationLabel) || other.locationLabel == locationLabel)&&(identical(other.milestoneCode, milestoneCode) || other.milestoneCode == milestoneCode)&&(identical(other.milestoneTitle, milestoneTitle) || other.milestoneTitle == milestoneTitle)&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.pregnancyWeek, pregnancyWeek) || other.pregnancyWeek == pregnancyWeek)&&(identical(other.pregnancyDay, pregnancyDay) || other.pregnancyDay == pregnancyDay)&&(identical(other.voiceDurationSec, voiceDurationSec) || other.voiceDurationSec == voiceDurationSec)&&(identical(other.voiceUrl, voiceUrl) || other.voiceUrl == voiceUrl)&&(identical(other.sealedUntil, sealedUntil) || other.sealedUntil == sealedUntil)&&(identical(other.missionId, missionId) || other.missionId == missionId)&&const DeepCollectionEquality().equals(other._reactions, _reactions)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&const DeepCollectionEquality().equals(other._reactorNames, _reactorNames)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.commentsEnabled, commentsEnabled) || other.commentsEnabled == commentsEnabled)&&(identical(other.perspectiveCount, perspectiveCount) || other.perspectiveCount == perspectiveCount)&&(identical(other.perspectiveAuthorId, perspectiveAuthorId) || other.perspectiveAuthorId == perspectiveAuthorId)&&(identical(other.perspectivePreview, perspectivePreview) || other.perspectivePreview == perspectivePreview)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.pinned, pinned) || other.pinned == pinned)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.deletedByUserId, deletedByUserId) || other.deletedByUserId == deletedByUserId)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason)&&const DeepCollectionEquality().equals(other._mediaVideos, _mediaVideos)&&(identical(other.uploadDone, uploadDone) || other.uploadDone == uploadDone)&&(identical(other.uploadTotal, uploadTotal) || other.uploadTotal == uploadTotal)&&(identical(other.uploadFailed, uploadFailed) || other.uploadFailed == uploadFailed)&&(identical(other.uploadWaiting, uploadWaiting) || other.uploadWaiting == uploadWaiting));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,familyId,kind,title,body,quoteContext,const DeepCollectionEquality().hash(_childIds),authorId,occurredAt,createdAt,const DeepCollectionEquality().hash(_mediaAssets),visibility,feeling,const DeepCollectionEquality().hash(_people),locationLabel,milestoneCode,milestoneTitle,monthIndex,pregnancyWeek,pregnancyDay,voiceDurationSec,voiceUrl,sealedUntil,missionId,const DeepCollectionEquality().hash(_reactions),myReaction,const DeepCollectionEquality().hash(_reactorNames),commentCount,commentsEnabled,perspectiveCount,perspectiveAuthorId,perspectivePreview,isFavorite,pinned,deletedAt,deletedByUserId,rejectReason,const DeepCollectionEquality().hash(_mediaVideos),uploadDone,uploadTotal,uploadFailed,uploadWaiting]);

@override
String toString() {
  return 'Memory(id: $id, familyId: $familyId, kind: $kind, title: $title, body: $body, quoteContext: $quoteContext, childIds: $childIds, authorId: $authorId, occurredAt: $occurredAt, createdAt: $createdAt, mediaAssets: $mediaAssets, visibility: $visibility, feeling: $feeling, people: $people, locationLabel: $locationLabel, milestoneCode: $milestoneCode, milestoneTitle: $milestoneTitle, monthIndex: $monthIndex, pregnancyWeek: $pregnancyWeek, pregnancyDay: $pregnancyDay, voiceDurationSec: $voiceDurationSec, voiceUrl: $voiceUrl, sealedUntil: $sealedUntil, missionId: $missionId, reactions: $reactions, myReaction: $myReaction, reactorNames: $reactorNames, commentCount: $commentCount, commentsEnabled: $commentsEnabled, perspectiveCount: $perspectiveCount, perspectiveAuthorId: $perspectiveAuthorId, perspectivePreview: $perspectivePreview, isFavorite: $isFavorite, pinned: $pinned, deletedAt: $deletedAt, deletedByUserId: $deletedByUserId, rejectReason: $rejectReason, mediaVideos: $mediaVideos, uploadDone: $uploadDone, uploadTotal: $uploadTotal, uploadFailed: $uploadFailed, uploadWaiting: $uploadWaiting)';
}


}

/// @nodoc
abstract mixin class _$MemoryCopyWith<$Res> implements $MemoryCopyWith<$Res> {
  factory _$MemoryCopyWith(_Memory value, $Res Function(_Memory) _then) = __$MemoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'familyId') String familyId,@JsonKey(name: 'kind') MemoryKind kind,@JsonKey(name: 'title') String? title,@JsonKey(name: 'body') String? body,@JsonKey(name: 'quoteContext') String? quoteContext,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'authorId') String authorId,@JsonKey(name: 'occurredAt') DateTime occurredAt,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'mediaAssets') List<String> mediaAssets,@JsonKey(name: 'visibility') MemoryVisibility visibility,@JsonKey(name: 'feeling') String? feeling,@JsonKey(name: 'people') List<String> people,@JsonKey(name: 'locationLabel') String? locationLabel,@JsonKey(name: 'milestoneCode') String? milestoneCode,@JsonKey(name: 'milestoneTitle') String? milestoneTitle,@JsonKey(name: 'monthIndex') int? monthIndex,@JsonKey(name: 'pregnancyWeek') int? pregnancyWeek,@JsonKey(name: 'pregnancyDay') int? pregnancyDay,@JsonKey(name: 'voiceDurationSec') int? voiceDurationSec,@JsonKey(name: 'voiceUrl') String? voiceUrl,@JsonKey(name: 'sealedUntil') DateTime? sealedUntil,@JsonKey(name: 'missionId') String? missionId,@JsonKey(name: 'reactions') Map<String, int> reactions,@JsonKey(name: 'myReaction') String? myReaction,@JsonKey(name: 'reactorNames') List<String> reactorNames,@JsonKey(name: 'commentCount') int commentCount,@JsonKey(name: 'commentsEnabled') bool commentsEnabled,@JsonKey(name: 'perspectiveCount') int perspectiveCount,@JsonKey(name: 'perspectiveAuthorId') String? perspectiveAuthorId,@JsonKey(name: 'perspectivePreview') String? perspectivePreview,@JsonKey(name: 'isFavorite') bool isFavorite,@JsonKey(name: 'pinned') bool pinned,@JsonKey(name: 'deletedAt') DateTime? deletedAt,@JsonKey(name: 'deletedByUserId') String? deletedByUserId,@JsonKey(name: 'rejectReason') String? rejectReason,@JsonKey(name: 'mediaVideos') List<String?> mediaVideos,@JsonKey(name: 'uploadDone') int? uploadDone,@JsonKey(name: 'uploadTotal') int? uploadTotal,@JsonKey(name: 'uploadFailed') bool uploadFailed,@JsonKey(name: 'uploadWaiting') bool uploadWaiting
});




}
/// @nodoc
class __$MemoryCopyWithImpl<$Res>
    implements _$MemoryCopyWith<$Res> {
  __$MemoryCopyWithImpl(this._self, this._then);

  final _Memory _self;
  final $Res Function(_Memory) _then;

/// Create a copy of Memory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? familyId = null,Object? kind = null,Object? title = freezed,Object? body = freezed,Object? quoteContext = freezed,Object? childIds = null,Object? authorId = null,Object? occurredAt = null,Object? createdAt = freezed,Object? mediaAssets = null,Object? visibility = null,Object? feeling = freezed,Object? people = null,Object? locationLabel = freezed,Object? milestoneCode = freezed,Object? milestoneTitle = freezed,Object? monthIndex = freezed,Object? pregnancyWeek = freezed,Object? pregnancyDay = freezed,Object? voiceDurationSec = freezed,Object? voiceUrl = freezed,Object? sealedUntil = freezed,Object? missionId = freezed,Object? reactions = null,Object? myReaction = freezed,Object? reactorNames = null,Object? commentCount = null,Object? commentsEnabled = null,Object? perspectiveCount = null,Object? perspectiveAuthorId = freezed,Object? perspectivePreview = freezed,Object? isFavorite = null,Object? pinned = null,Object? deletedAt = freezed,Object? deletedByUserId = freezed,Object? rejectReason = freezed,Object? mediaVideos = null,Object? uploadDone = freezed,Object? uploadTotal = freezed,Object? uploadFailed = null,Object? uploadWaiting = null,}) {
  return _then(_Memory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MemoryKind,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,quoteContext: freezed == quoteContext ? _self.quoteContext : quoteContext // ignore: cast_nullable_to_non_nullable
as String?,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,mediaAssets: null == mediaAssets ? _self._mediaAssets : mediaAssets // ignore: cast_nullable_to_non_nullable
as List<String>,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as MemoryVisibility,feeling: freezed == feeling ? _self.feeling : feeling // ignore: cast_nullable_to_non_nullable
as String?,people: null == people ? _self._people : people // ignore: cast_nullable_to_non_nullable
as List<String>,locationLabel: freezed == locationLabel ? _self.locationLabel : locationLabel // ignore: cast_nullable_to_non_nullable
as String?,milestoneCode: freezed == milestoneCode ? _self.milestoneCode : milestoneCode // ignore: cast_nullable_to_non_nullable
as String?,milestoneTitle: freezed == milestoneTitle ? _self.milestoneTitle : milestoneTitle // ignore: cast_nullable_to_non_nullable
as String?,monthIndex: freezed == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int?,pregnancyWeek: freezed == pregnancyWeek ? _self.pregnancyWeek : pregnancyWeek // ignore: cast_nullable_to_non_nullable
as int?,pregnancyDay: freezed == pregnancyDay ? _self.pregnancyDay : pregnancyDay // ignore: cast_nullable_to_non_nullable
as int?,voiceDurationSec: freezed == voiceDurationSec ? _self.voiceDurationSec : voiceDurationSec // ignore: cast_nullable_to_non_nullable
as int?,voiceUrl: freezed == voiceUrl ? _self.voiceUrl : voiceUrl // ignore: cast_nullable_to_non_nullable
as String?,sealedUntil: freezed == sealedUntil ? _self.sealedUntil : sealedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,missionId: freezed == missionId ? _self.missionId : missionId // ignore: cast_nullable_to_non_nullable
as String?,reactions: null == reactions ? _self._reactions : reactions // ignore: cast_nullable_to_non_nullable
as Map<String, int>,myReaction: freezed == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as String?,reactorNames: null == reactorNames ? _self._reactorNames : reactorNames // ignore: cast_nullable_to_non_nullable
as List<String>,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,commentsEnabled: null == commentsEnabled ? _self.commentsEnabled : commentsEnabled // ignore: cast_nullable_to_non_nullable
as bool,perspectiveCount: null == perspectiveCount ? _self.perspectiveCount : perspectiveCount // ignore: cast_nullable_to_non_nullable
as int,perspectiveAuthorId: freezed == perspectiveAuthorId ? _self.perspectiveAuthorId : perspectiveAuthorId // ignore: cast_nullable_to_non_nullable
as String?,perspectivePreview: freezed == perspectivePreview ? _self.perspectivePreview : perspectivePreview // ignore: cast_nullable_to_non_nullable
as String?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,pinned: null == pinned ? _self.pinned : pinned // ignore: cast_nullable_to_non_nullable
as bool,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedByUserId: freezed == deletedByUserId ? _self.deletedByUserId : deletedByUserId // ignore: cast_nullable_to_non_nullable
as String?,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,mediaVideos: null == mediaVideos ? _self._mediaVideos : mediaVideos // ignore: cast_nullable_to_non_nullable
as List<String?>,uploadDone: freezed == uploadDone ? _self.uploadDone : uploadDone // ignore: cast_nullable_to_non_nullable
as int?,uploadTotal: freezed == uploadTotal ? _self.uploadTotal : uploadTotal // ignore: cast_nullable_to_non_nullable
as int?,uploadFailed: null == uploadFailed ? _self.uploadFailed : uploadFailed // ignore: cast_nullable_to_non_nullable
as bool,uploadWaiting: null == uploadWaiting ? _self.uploadWaiting : uploadWaiting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
