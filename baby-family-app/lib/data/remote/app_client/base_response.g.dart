// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthCertificateRespond _$AuthCertificateRespondFromJson(
  Map<String, dynamic> json,
) => AuthCertificateRespond(
  auth: json['data'] == null
      ? null
      : AuthCertificate.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$AuthCertificateRespondToJson(
  AuthCertificateRespond instance,
) => <String, dynamic>{'data': instance.auth, 'runtimeType': instance.$type};

UserRespond _$UserRespondFromJson(Map<String, dynamic> json) => UserRespond(
  user: json['data'] == null
      ? null
      : User.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$UserRespondToJson(UserRespond instance) =>
    <String, dynamic>{'data': instance.user, 'runtimeType': instance.$type};

OtpDispatchRespond _$OtpDispatchRespondFromJson(Map<String, dynamic> json) =>
    OtpDispatchRespond(
      dispatch: json['data'] == null
          ? null
          : OtpDispatch.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$OtpDispatchRespondToJson(OtpDispatchRespond instance) =>
    <String, dynamic>{'data': instance.dispatch, 'runtimeType': instance.$type};

MeProfileRespond _$MeProfileRespondFromJson(Map<String, dynamic> json) =>
    MeProfileRespond(
      profile: json['data'] == null
          ? null
          : MeProfile.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MeProfileRespondToJson(MeProfileRespond instance) =>
    <String, dynamic>{'data': instance.profile, 'runtimeType': instance.$type};

FamilyBootstrapRespond _$FamilyBootstrapRespondFromJson(
  Map<String, dynamic> json,
) => FamilyBootstrapRespond(
  bootstrap: json['data'] == null
      ? null
      : FamilyBootstrap.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$FamilyBootstrapRespondToJson(
  FamilyBootstrapRespond instance,
) => <String, dynamic>{
  'data': instance.bootstrap,
  'runtimeType': instance.$type,
};

PartnerInviteIssuedRespond _$PartnerInviteIssuedRespondFromJson(
  Map<String, dynamic> json,
) => PartnerInviteIssuedRespond(
  invite: json['data'] == null
      ? null
      : PartnerInviteIssued.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PartnerInviteIssuedRespondToJson(
  PartnerInviteIssuedRespond instance,
) => <String, dynamic>{'data': instance.invite, 'runtimeType': instance.$type};

PartnerInviteStatusRespond _$PartnerInviteStatusRespondFromJson(
  Map<String, dynamic> json,
) => PartnerInviteStatusRespond(
  invite: json['data'] == null
      ? null
      : PartnerInviteStatus.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PartnerInviteStatusRespondToJson(
  PartnerInviteStatusRespond instance,
) => <String, dynamic>{'data': instance.invite, 'runtimeType': instance.$type};

InviteResolutionRespond _$InviteResolutionRespondFromJson(
  Map<String, dynamic> json,
) => InviteResolutionRespond(
  invite: json['data'] == null
      ? null
      : InviteResolution.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$InviteResolutionRespondToJson(
  InviteResolutionRespond instance,
) => <String, dynamic>{'data': instance.invite, 'runtimeType': instance.$type};

InviteDecisionRespond _$InviteDecisionRespondFromJson(
  Map<String, dynamic> json,
) => InviteDecisionRespond(
  decision: json['data'] == null
      ? null
      : InviteDecision.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$InviteDecisionRespondToJson(
  InviteDecisionRespond instance,
) => <String, dynamic>{
  'data': instance.decision,
  'runtimeType': instance.$type,
};

ChildRecordRespond _$ChildRecordRespondFromJson(Map<String, dynamic> json) =>
    ChildRecordRespond(
      child: json['data'] == null
          ? null
          : ChildRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ChildRecordRespondToJson(ChildRecordRespond instance) =>
    <String, dynamic>{'data': instance.child, 'runtimeType': instance.$type};

PregnancyRecordRespond _$PregnancyRecordRespondFromJson(
  Map<String, dynamic> json,
) => PregnancyRecordRespond(
  pregnancy: json['data'] == null
      ? null
      : PregnancyRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PregnancyRecordRespondToJson(
  PregnancyRecordRespond instance,
) => <String, dynamic>{
  'data': instance.pregnancy,
  'runtimeType': instance.$type,
};

UploadIntentRespond _$UploadIntentRespondFromJson(Map<String, dynamic> json) =>
    UploadIntentRespond(
      intent: json['data'] == null
          ? null
          : UploadIntent.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$UploadIntentRespondToJson(
  UploadIntentRespond instance,
) => <String, dynamic>{'data': instance.intent, 'runtimeType': instance.$type};

UploadStatusRespond _$UploadStatusRespondFromJson(Map<String, dynamic> json) =>
    UploadStatusRespond(
      upload: json['data'] == null
          ? null
          : UploadStatus.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$UploadStatusRespondToJson(
  UploadStatusRespond instance,
) => <String, dynamic>{'data': instance.upload, 'runtimeType': instance.$type};

MemoryRecordRespond _$MemoryRecordRespondFromJson(Map<String, dynamic> json) =>
    MemoryRecordRespond(
      memory: json['data'] == null
          ? null
          : MemoryRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MemoryRecordRespondToJson(
  MemoryRecordRespond instance,
) => <String, dynamic>{'data': instance.memory, 'runtimeType': instance.$type};

TimelineRespond _$TimelineRespondFromJson(Map<String, dynamic> json) =>
    TimelineRespond(
      items:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) => TimelineItemRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <TimelineItemRecord>[],
      nextCursor: json['nextCursor'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$TimelineRespondToJson(TimelineRespond instance) =>
    <String, dynamic>{
      'data': instance.items,
      'nextCursor': instance.nextCursor,
      'runtimeType': instance.$type,
    };

MediaGridRespond _$MediaGridRespondFromJson(Map<String, dynamic> json) =>
    MediaGridRespond(
      items:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) => MediaGridItemRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <MediaGridItemRecord>[],
      nextCursor: json['nextCursor'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MediaGridRespondToJson(MediaGridRespond instance) =>
    <String, dynamic>{
      'data': instance.items,
      'nextCursor': instance.nextCursor,
      'runtimeType': instance.$type,
    };

CommentRecordRespond _$CommentRecordRespondFromJson(
  Map<String, dynamic> json,
) => CommentRecordRespond(
  comment: json['data'] == null
      ? null
      : CommentRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$CommentRecordRespondToJson(
  CommentRecordRespond instance,
) => <String, dynamic>{'data': instance.comment, 'runtimeType': instance.$type};

CommentListRespond _$CommentListRespondFromJson(Map<String, dynamic> json) =>
    CommentListRespond(
      comments:
          (json['data'] as List<dynamic>?)
              ?.map((e) => CommentRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CommentRecord>[],
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$CommentListRespondToJson(CommentListRespond instance) =>
    <String, dynamic>{'data': instance.comments, 'runtimeType': instance.$type};

ReactionStateRespond _$ReactionStateRespondFromJson(
  Map<String, dynamic> json,
) => ReactionStateRespond(
  reaction: json['data'] == null
      ? null
      : ReactionState.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$ReactionStateRespondToJson(
  ReactionStateRespond instance,
) => <String, dynamic>{
  'data': instance.reaction,
  'runtimeType': instance.$type,
};

PregnancyNamesRespond _$PregnancyNamesRespondFromJson(
  Map<String, dynamic> json,
) => PregnancyNamesRespond(
  list: json['data'] == null
      ? null
      : PregnancyNameList.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PregnancyNamesRespondToJson(
  PregnancyNamesRespond instance,
) => <String, dynamic>{'data': instance.list, 'runtimeType': instance.$type};

PregnancyNameRespond _$PregnancyNameRespondFromJson(
  Map<String, dynamic> json,
) => PregnancyNameRespond(
  name: json['data'] == null
      ? null
      : PregnancyNameRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PregnancyNameRespondToJson(
  PregnancyNameRespond instance,
) => <String, dynamic>{'data': instance.name, 'runtimeType': instance.$type};

CareStatsRespond _$CareStatsRespondFromJson(Map<String, dynamic> json) =>
    CareStatsRespond(
      stats: json['data'] == null
          ? null
          : CareStats.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$CareStatsRespondToJson(CareStatsRespond instance) =>
    <String, dynamic>{'data': instance.stats, 'runtimeType': instance.$type};

MemoryFeedRespond _$MemoryFeedRespondFromJson(Map<String, dynamic> json) =>
    MemoryFeedRespond(
      memories: json['data'] == null
          ? const <MemoryRecord>[]
          : _memoryRecords(json['data']),
      nextCursor: json['nextCursor'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MemoryFeedRespondToJson(MemoryFeedRespond instance) =>
    <String, dynamic>{
      'data': instance.memories,
      'nextCursor': instance.nextCursor,
      'runtimeType': instance.$type,
    };

NotificationPageRespond _$NotificationPageRespondFromJson(
  Map<String, dynamic> json,
) => NotificationPageRespond(
  page: json['data'] == null
      ? null
      : NotificationPage.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$NotificationPageRespondToJson(
  NotificationPageRespond instance,
) => <String, dynamic>{'data': instance.page, 'runtimeType': instance.$type};

NotificationCountRespond _$NotificationCountRespondFromJson(
  Map<String, dynamic> json,
) => NotificationCountRespond(
  count: json['data'] == null
      ? null
      : NotificationCount.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$NotificationCountRespondToJson(
  NotificationCountRespond instance,
) => <String, dynamic>{'data': instance.count, 'runtimeType': instance.$type};

HeartsMeRespond _$HeartsMeRespondFromJson(Map<String, dynamic> json) =>
    HeartsMeRespond(
      hearts: json['data'] == null
          ? null
          : HeartsMeRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$HeartsMeRespondToJson(HeartsMeRespond instance) =>
    <String, dynamic>{'data': instance.hearts, 'runtimeType': instance.$type};

FamilyTreeRespond _$FamilyTreeRespondFromJson(Map<String, dynamic> json) =>
    FamilyTreeRespond(
      tree: json['data'] == null
          ? null
          : FamilyTreeRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$FamilyTreeRespondToJson(FamilyTreeRespond instance) =>
    <String, dynamic>{'data': instance.tree, 'runtimeType': instance.$type};

BadgeListRespond _$BadgeListRespondFromJson(Map<String, dynamic> json) =>
    BadgeListRespond(
      list: json['data'] == null
          ? null
          : BadgeList.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$BadgeListRespondToJson(BadgeListRespond instance) =>
    <String, dynamic>{'data': instance.list, 'runtimeType': instance.$type};

MissionHistoryRespond _$MissionHistoryRespondFromJson(
  Map<String, dynamic> json,
) => MissionHistoryRespond(
  page: json['data'] == null
      ? null
      : MissionHistoryPage.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$MissionHistoryRespondToJson(
  MissionHistoryRespond instance,
) => <String, dynamic>{'data': instance.page, 'runtimeType': instance.$type};

MissionBoardRespond _$MissionBoardRespondFromJson(Map<String, dynamic> json) =>
    MissionBoardRespond(
      board: json['data'] == null
          ? null
          : MissionBoardRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MissionBoardRespondToJson(
  MissionBoardRespond instance,
) => <String, dynamic>{'data': instance.board, 'runtimeType': instance.$type};

MissionRecordRespond _$MissionRecordRespondFromJson(
  Map<String, dynamic> json,
) => MissionRecordRespond(
  mission: json['data'] == null
      ? null
      : MissionRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$MissionRecordRespondToJson(
  MissionRecordRespond instance,
) => <String, dynamic>{'data': instance.mission, 'runtimeType': instance.$type};

MissionResultRespond _$MissionResultRespondFromJson(
  Map<String, dynamic> json,
) => MissionResultRespond(
  result: json['data'] == null
      ? null
      : MissionResultRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$MissionResultRespondToJson(
  MissionResultRespond instance,
) => <String, dynamic>{'data': instance.result, 'runtimeType': instance.$type};

MissionTemplateListRespond _$MissionTemplateListRespondFromJson(
  Map<String, dynamic> json,
) => MissionTemplateListRespond(
  list: json['data'] == null
      ? null
      : MissionTemplateList.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$MissionTemplateListRespondToJson(
  MissionTemplateListRespond instance,
) => <String, dynamic>{'data': instance.list, 'runtimeType': instance.$type};

MissionSwapOptionsRespond _$MissionSwapOptionsRespondFromJson(
  Map<String, dynamic> json,
) => MissionSwapOptionsRespond(
  options: json['data'] == null
      ? null
      : MissionSwapOptionsRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$MissionSwapOptionsRespondToJson(
  MissionSwapOptionsRespond instance,
) => <String, dynamic>{'data': instance.options, 'runtimeType': instance.$type};

AppreciationRecordRespond _$AppreciationRecordRespondFromJson(
  Map<String, dynamic> json,
) => AppreciationRecordRespond(
  appreciation: json['data'] == null
      ? null
      : AppreciationRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$AppreciationRecordRespondToJson(
  AppreciationRecordRespond instance,
) => <String, dynamic>{
  'data': instance.appreciation,
  'runtimeType': instance.$type,
};

AppreciationWallRespond _$AppreciationWallRespondFromJson(
  Map<String, dynamic> json,
) => AppreciationWallRespond(
  wall: json['data'] == null
      ? null
      : AppreciationWall.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$AppreciationWallRespondToJson(
  AppreciationWallRespond instance,
) => <String, dynamic>{'data': instance.wall, 'runtimeType': instance.$type};

JournalEntryRespond _$JournalEntryRespondFromJson(Map<String, dynamic> json) =>
    JournalEntryRespond(
      entry: json['data'] == null
          ? null
          : JournalEntryRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$JournalEntryRespondToJson(
  JournalEntryRespond instance,
) => <String, dynamic>{'data': instance.entry, 'runtimeType': instance.$type};

JournalListRespond _$JournalListRespondFromJson(Map<String, dynamic> json) =>
    JournalListRespond(
      page: json['data'] == null
          ? null
          : JournalList.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$JournalListRespondToJson(JournalListRespond instance) =>
    <String, dynamic>{'data': instance.page, 'runtimeType': instance.$type};

CheckinRecordRespond _$CheckinRecordRespondFromJson(
  Map<String, dynamic> json,
) => CheckinRecordRespond(
  checkin: json['data'] == null
      ? null
      : CheckinRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$CheckinRecordRespondToJson(
  CheckinRecordRespond instance,
) => <String, dynamic>{'data': instance.checkin, 'runtimeType': instance.$type};

CheckinTodayRespond _$CheckinTodayRespondFromJson(Map<String, dynamic> json) =>
    CheckinTodayRespond(
      today: json['data'] == null
          ? null
          : CheckinToday.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$CheckinTodayRespondToJson(
  CheckinTodayRespond instance,
) => <String, dynamic>{'data': instance.today, 'runtimeType': instance.$type};

RequestCreatedRespond _$RequestCreatedRespondFromJson(
  Map<String, dynamic> json,
) => RequestCreatedRespond(
  created: json['data'] == null
      ? null
      : RequestCreated.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$RequestCreatedRespondToJson(
  RequestCreatedRespond instance,
) => <String, dynamic>{'data': instance.created, 'runtimeType': instance.$type};

RequestRecordRespond _$RequestRecordRespondFromJson(
  Map<String, dynamic> json,
) => RequestRecordRespond(
  request: json['data'] == null
      ? null
      : RequestRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$RequestRecordRespondToJson(
  RequestRecordRespond instance,
) => <String, dynamic>{'data': instance.request, 'runtimeType': instance.$type};

RequestListRespond _$RequestListRespondFromJson(Map<String, dynamic> json) =>
    RequestListRespond(
      page: json['data'] == null
          ? null
          : RequestList.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$RequestListRespondToJson(RequestListRespond instance) =>
    <String, dynamic>{'data': instance.page, 'runtimeType': instance.$type};

ReauthTokenRespond _$ReauthTokenRespondFromJson(Map<String, dynamic> json) =>
    ReauthTokenRespond(
      token: json['data'] == null
          ? null
          : ReauthTokenRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ReauthTokenRespondToJson(ReauthTokenRespond instance) =>
    <String, dynamic>{'data': instance.token, 'runtimeType': instance.$type};

DeletionPreviewRespond _$DeletionPreviewRespondFromJson(
  Map<String, dynamic> json,
) => DeletionPreviewRespond(
  preview: json['data'] == null
      ? null
      : DeletionPreviewRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$DeletionPreviewRespondToJson(
  DeletionPreviewRespond instance,
) => <String, dynamic>{'data': instance.preview, 'runtimeType': instance.$type};

DataExportRespond _$DataExportRespondFromJson(Map<String, dynamic> json) =>
    DataExportRespond(
      export: json['data'] == null
          ? null
          : DataExportRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$DataExportRespondToJson(DataExportRespond instance) =>
    <String, dynamic>{'data': instance.export, 'runtimeType': instance.$type};

CalendarRespond _$CalendarRespondFromJson(Map<String, dynamic> json) =>
    CalendarRespond(
      calendar: json['data'] == null
          ? null
          : CalendarRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$CalendarRespondToJson(CalendarRespond instance) =>
    <String, dynamic>{'data': instance.calendar, 'runtimeType': instance.$type};

CalendarEventRespond _$CalendarEventRespondFromJson(
  Map<String, dynamic> json,
) => CalendarEventRespond(
  event: json['data'] == null
      ? null
      : CalendarEventRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$CalendarEventRespondToJson(
  CalendarEventRespond instance,
) => <String, dynamic>{'data': instance.event, 'runtimeType': instance.$type};

SessionListRespond _$SessionListRespondFromJson(Map<String, dynamic> json) =>
    SessionListRespond(
      list: json['data'] == null
          ? null
          : SessionList.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$SessionListRespondToJson(SessionListRespond instance) =>
    <String, dynamic>{'data': instance.list, 'runtimeType': instance.$type};

FamilySettingsRespond _$FamilySettingsRespondFromJson(
  Map<String, dynamic> json,
) => FamilySettingsRespond(
  settings: json['data'] == null
      ? null
      : FamilySettingsRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$FamilySettingsRespondToJson(
  FamilySettingsRespond instance,
) => <String, dynamic>{
  'data': instance.settings,
  'runtimeType': instance.$type,
};

JourneyRespond _$JourneyRespondFromJson(Map<String, dynamic> json) =>
    JourneyRespond(
      journey: json['data'] == null
          ? null
          : JourneyRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$JourneyRespondToJson(JourneyRespond instance) =>
    <String, dynamic>{'data': instance.journey, 'runtimeType': instance.$type};

PrepGroupsRespond _$PrepGroupsRespondFromJson(Map<String, dynamic> json) =>
    PrepGroupsRespond(
      groups: (json['data'] as List<dynamic>?)
          ?.map((e) => PrepGroupRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$PrepGroupsRespondToJson(PrepGroupsRespond instance) =>
    <String, dynamic>{'data': instance.groups, 'runtimeType': instance.$type};

PrepItemRespond _$PrepItemRespondFromJson(Map<String, dynamic> json) =>
    PrepItemRespond(
      item: json['data'] == null
          ? null
          : PrepItemRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$PrepItemRespondToJson(PrepItemRespond instance) =>
    <String, dynamic>{'data': instance.item, 'runtimeType': instance.$type};

BirthResultRespond _$BirthResultRespondFromJson(Map<String, dynamic> json) =>
    BirthResultRespond(
      result: json['data'] == null
          ? null
          : BirthResultRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$BirthResultRespondToJson(BirthResultRespond instance) =>
    <String, dynamic>{'data': instance.result, 'runtimeType': instance.$type};

ChildStatsRespond _$ChildStatsRespondFromJson(Map<String, dynamic> json) =>
    ChildStatsRespond(
      stats: json['data'] == null
          ? null
          : ChildStatsRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ChildStatsRespondToJson(ChildStatsRespond instance) =>
    <String, dynamic>{'data': instance.stats, 'runtimeType': instance.$type};

AlbumListRespond _$AlbumListRespondFromJson(Map<String, dynamic> json) =>
    AlbumListRespond(
      list: json['data'] == null
          ? null
          : AlbumList.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$AlbumListRespondToJson(AlbumListRespond instance) =>
    <String, dynamic>{'data': instance.list, 'runtimeType': instance.$type};

AlbumRecordRespond _$AlbumRecordRespondFromJson(Map<String, dynamic> json) =>
    AlbumRecordRespond(
      album: json['data'] == null
          ? null
          : AlbumRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$AlbumRecordRespondToJson(AlbumRecordRespond instance) =>
    <String, dynamic>{'data': instance.album, 'runtimeType': instance.$type};

PerspectiveListRespond _$PerspectiveListRespondFromJson(
  Map<String, dynamic> json,
) => PerspectiveListRespond(
  list: json['data'] == null
      ? null
      : PerspectiveList.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PerspectiveListRespondToJson(
  PerspectiveListRespond instance,
) => <String, dynamic>{'data': instance.list, 'runtimeType': instance.$type};

PerspectiveRecordRespond _$PerspectiveRecordRespondFromJson(
  Map<String, dynamic> json,
) => PerspectiveRecordRespond(
  perspective: json['data'] == null
      ? null
      : PerspectiveRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PerspectiveRecordRespondToJson(
  PerspectiveRecordRespond instance,
) => <String, dynamic>{
  'data': instance.perspective,
  'runtimeType': instance.$type,
};

MemoryPromptListRespond _$MemoryPromptListRespondFromJson(
  Map<String, dynamic> json,
) => MemoryPromptListRespond(
  list: json['data'] == null
      ? null
      : MemoryPromptList.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$MemoryPromptListRespondToJson(
  MemoryPromptListRespond instance,
) => <String, dynamic>{'data': instance.list, 'runtimeType': instance.$type};

DownloadUrlListRespond _$DownloadUrlListRespondFromJson(
  Map<String, dynamic> json,
) => DownloadUrlListRespond(
  list: json['data'] == null
      ? null
      : DownloadUrlList.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$DownloadUrlListRespondToJson(
  DownloadUrlListRespond instance,
) => <String, dynamic>{'data': instance.list, 'runtimeType': instance.$type};

MilestoneCatalogRespond _$MilestoneCatalogRespondFromJson(
  Map<String, dynamic> json,
) => MilestoneCatalogRespond(
  catalog: json['data'] == null
      ? null
      : MilestoneCatalog.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$MilestoneCatalogRespondToJson(
  MilestoneCatalogRespond instance,
) => <String, dynamic>{'data': instance.catalog, 'runtimeType': instance.$type};

LetterListRespond _$LetterListRespondFromJson(Map<String, dynamic> json) =>
    LetterListRespond(
      letters:
          (json['data'] as List<dynamic>?)
              ?.map((e) => LetterRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <LetterRecord>[],
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$LetterListRespondToJson(LetterListRespond instance) =>
    <String, dynamic>{'data': instance.letters, 'runtimeType': instance.$type};

MissionSettingsRespond _$MissionSettingsRespondFromJson(
  Map<String, dynamic> json,
) => MissionSettingsRespond(
  settings: json['data'] == null
      ? null
      : MissionSettingsRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$MissionSettingsRespondToJson(
  MissionSettingsRespond instance,
) => <String, dynamic>{
  'data': instance.settings,
  'runtimeType': instance.$type,
};

MissionSeriesRespond _$MissionSeriesRespondFromJson(
  Map<String, dynamic> json,
) => MissionSeriesRespond(
  series: json['data'] == null
      ? null
      : MissionSeriesRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$MissionSeriesRespondToJson(
  MissionSeriesRespond instance,
) => <String, dynamic>{'data': instance.series, 'runtimeType': instance.$type};

CircleMemberListRespond _$CircleMemberListRespondFromJson(
  Map<String, dynamic> json,
) => CircleMemberListRespond(
  list: json['data'] == null
      ? null
      : CircleMemberList.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$CircleMemberListRespondToJson(
  CircleMemberListRespond instance,
) => <String, dynamic>{'data': instance.list, 'runtimeType': instance.$type};

CircleInviteListRespond _$CircleInviteListRespondFromJson(
  Map<String, dynamic> json,
) => CircleInviteListRespond(
  list: json['data'] == null
      ? null
      : CircleInviteList.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$CircleInviteListRespondToJson(
  CircleInviteListRespond instance,
) => <String, dynamic>{'data': instance.list, 'runtimeType': instance.$type};

CircleInviteIssuedRespond _$CircleInviteIssuedRespondFromJson(
  Map<String, dynamic> json,
) => CircleInviteIssuedRespond(
  invite: json['data'] == null
      ? null
      : CircleInviteIssued.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$CircleInviteIssuedRespondToJson(
  CircleInviteIssuedRespond instance,
) => <String, dynamic>{'data': instance.invite, 'runtimeType': instance.$type};

UsSettingsRespond _$UsSettingsRespondFromJson(Map<String, dynamic> json) =>
    UsSettingsRespond(
      settings: json['data'] == null
          ? null
          : UsSettingsRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$UsSettingsRespondToJson(UsSettingsRespond instance) =>
    <String, dynamic>{'data': instance.settings, 'runtimeType': instance.$type};

MyCircleListRespond _$MyCircleListRespondFromJson(Map<String, dynamic> json) =>
    MyCircleListRespond(
      list: json['data'] == null
          ? null
          : MyCircleList.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MyCircleListRespondToJson(
  MyCircleListRespond instance,
) => <String, dynamic>{'data': instance.list, 'runtimeType': instance.$type};

BillingCatalogRespond _$BillingCatalogRespondFromJson(
  Map<String, dynamic> json,
) => BillingCatalogRespond(
  catalog: json['data'] == null
      ? null
      : BillingCatalog.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$BillingCatalogRespondToJson(
  BillingCatalogRespond instance,
) => <String, dynamic>{'data': instance.catalog, 'runtimeType': instance.$type};

PurchaseIntentRespond _$PurchaseIntentRespondFromJson(
  Map<String, dynamic> json,
) => PurchaseIntentRespond(
  intent: json['data'] == null
      ? null
      : PurchaseIntentRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PurchaseIntentRespondToJson(
  PurchaseIntentRespond instance,
) => <String, dynamic>{'data': instance.intent, 'runtimeType': instance.$type};

FamilyBillingRespond _$FamilyBillingRespondFromJson(
  Map<String, dynamic> json,
) => FamilyBillingRespond(
  billing: json['data'] == null
      ? null
      : FamilyBillingRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$FamilyBillingRespondToJson(
  FamilyBillingRespond instance,
) => <String, dynamic>{'data': instance.billing, 'runtimeType': instance.$type};

NotificationSettingsRespond _$NotificationSettingsRespondFromJson(
  Map<String, dynamic> json,
) => NotificationSettingsRespond(
  settings: json['data'] == null
      ? null
      : NotificationSettingsRecord.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$NotificationSettingsRespondToJson(
  NotificationSettingsRespond instance,
) => <String, dynamic>{
  'data': instance.settings,
  'runtimeType': instance.$type,
};

AiSettingsRespond _$AiSettingsRespondFromJson(Map<String, dynamic> json) =>
    AiSettingsRespond(
      settings: json['data'] == null
          ? null
          : AiSettingsRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$AiSettingsRespondToJson(AiSettingsRespond instance) =>
    <String, dynamic>{'data': instance.settings, 'runtimeType': instance.$type};

OnThisDayRespond _$OnThisDayRespondFromJson(Map<String, dynamic> json) =>
    OnThisDayRespond(
      record: json['data'] == null
          ? null
          : OnThisDayRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$OnThisDayRespondToJson(OnThisDayRespond instance) =>
    <String, dynamic>{'data': instance.record, 'runtimeType': instance.$type};

ReportRespond _$ReportRespondFromJson(Map<String, dynamic> json) =>
    ReportRespond(
      report: json['data'] == null
          ? null
          : ReportRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ReportRespondToJson(ReportRespond instance) =>
    <String, dynamic>{'data': instance.report, 'runtimeType': instance.$type};

BlockedUserListRespond _$BlockedUserListRespondFromJson(
  Map<String, dynamic> json,
) => BlockedUserListRespond(
  list: json['data'] == null
      ? null
      : BlockedUserList.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$BlockedUserListRespondToJson(
  BlockedUserListRespond instance,
) => <String, dynamic>{'data': instance.list, 'runtimeType': instance.$type};

WeekStatsRespond _$WeekStatsRespondFromJson(Map<String, dynamic> json) =>
    WeekStatsRespond(
      stats: json['data'] == null
          ? null
          : WeekStatsRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$WeekStatsRespondToJson(WeekStatsRespond instance) =>
    <String, dynamic>{'data': instance.stats, 'runtimeType': instance.$type};

WeeklyRecapRespond _$WeeklyRecapRespondFromJson(Map<String, dynamic> json) =>
    WeeklyRecapRespond(
      recap: json['data'] == null
          ? null
          : WeeklyRecapRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$WeeklyRecapRespondToJson(WeeklyRecapRespond instance) =>
    <String, dynamic>{'data': instance.recap, 'runtimeType': instance.$type};

DisplaySettingsRespond _$DisplaySettingsRespondFromJson(
  Map<String, dynamic> json,
) => DisplaySettingsRespond(
  settings: json['data'] == null
      ? null
      : DisplaySettingsRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$DisplaySettingsRespondToJson(
  DisplaySettingsRespond instance,
) => <String, dynamic>{
  'data': instance.settings,
  'runtimeType': instance.$type,
};

FamilyDeletionRespond _$FamilyDeletionRespondFromJson(
  Map<String, dynamic> json,
) => FamilyDeletionRespond(
  deletion: json['data'] == null
      ? null
      : FamilyDeletionRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$FamilyDeletionRespondToJson(
  FamilyDeletionRespond instance,
) => <String, dynamic>{
  'data': instance.deletion,
  'runtimeType': instance.$type,
};

PrivacyOverviewRespond _$PrivacyOverviewRespondFromJson(
  Map<String, dynamic> json,
) => PrivacyOverviewRespond(
  overview: json['data'] == null
      ? null
      : PrivacyOverviewRecord.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PrivacyOverviewRespondToJson(
  PrivacyOverviewRespond instance,
) => <String, dynamic>{
  'data': instance.overview,
  'runtimeType': instance.$type,
};

MonthlyPhotoListRespond _$MonthlyPhotoListRespondFromJson(
  Map<String, dynamic> json,
) => MonthlyPhotoListRespond(
  photos:
      (json['data'] as List<dynamic>?)
          ?.map((e) => MonthlyPhotoRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MonthlyPhotoRecord>[],
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$MonthlyPhotoListRespondToJson(
  MonthlyPhotoListRespond instance,
) => <String, dynamic>{'data': instance.photos, 'runtimeType': instance.$type};

MonthlyPhotoRespond _$MonthlyPhotoRespondFromJson(Map<String, dynamic> json) =>
    MonthlyPhotoRespond(
      photo: json['data'] == null
          ? null
          : MonthlyPhotoRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MonthlyPhotoRespondToJson(
  MonthlyPhotoRespond instance,
) => <String, dynamic>{'data': instance.photo, 'runtimeType': instance.$type};

TodayStoryRespond _$TodayStoryRespondFromJson(Map<String, dynamic> json) =>
    TodayStoryRespond(
      story: json['data'] == null
          ? null
          : TodayStoryRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$TodayStoryRespondToJson(TodayStoryRespond instance) =>
    <String, dynamic>{'data': instance.story, 'runtimeType': instance.$type};

FamilyRecordRespond _$FamilyRecordRespondFromJson(Map<String, dynamic> json) =>
    FamilyRecordRespond(
      family: json['data'] == null
          ? null
          : FamilyRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$FamilyRecordRespondToJson(
  FamilyRecordRespond instance,
) => <String, dynamic>{'data': instance.family, 'runtimeType': instance.$type};

MissionSeriesListRespond _$MissionSeriesListRespondFromJson(
  Map<String, dynamic> json,
) => MissionSeriesListRespond(
  list: json['data'] == null
      ? null
      : MissionSeriesList.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$MissionSeriesListRespondToJson(
  MissionSeriesListRespond instance,
) => <String, dynamic>{'data': instance.list, 'runtimeType': instance.$type};

SupportCategoriesRespond _$SupportCategoriesRespondFromJson(
  Map<String, dynamic> json,
) => SupportCategoriesRespond(
  catalog: json['data'] == null
      ? null
      : SupportCategoryCatalog.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$SupportCategoriesRespondToJson(
  SupportCategoriesRespond instance,
) => <String, dynamic>{'data': instance.catalog, 'runtimeType': instance.$type};

SupportTicketRespond _$SupportTicketRespondFromJson(
  Map<String, dynamic> json,
) => SupportTicketRespond(
  ticket: json['data'] == null
      ? null
      : SupportTicket.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$SupportTicketRespondToJson(
  SupportTicketRespond instance,
) => <String, dynamic>{'data': instance.ticket, 'runtimeType': instance.$type};

HelpCenterRespond _$HelpCenterRespondFromJson(Map<String, dynamic> json) =>
    HelpCenterRespond(
      helpCenter: json['data'] == null
          ? null
          : HelpCenterRecord.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$HelpCenterRespondToJson(HelpCenterRespond instance) =>
    <String, dynamic>{
      'data': instance.helpCenter,
      'runtimeType': instance.$type,
    };

SupportTicketDetailRespond _$SupportTicketDetailRespondFromJson(
  Map<String, dynamic> json,
) => SupportTicketDetailRespond(
  ticket: json['data'] == null
      ? null
      : SupportTicketDetail.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$SupportTicketDetailRespondToJson(
  SupportTicketDetailRespond instance,
) => <String, dynamic>{'data': instance.ticket, 'runtimeType': instance.$type};

SupportTicketListRespond _$SupportTicketListRespondFromJson(
  Map<String, dynamic> json,
) => SupportTicketListRespond(
  list: json['data'] == null
      ? null
      : SupportTicketList.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$SupportTicketListRespondToJson(
  SupportTicketListRespond instance,
) => <String, dynamic>{'data': instance.list, 'runtimeType': instance.$type};

SignInMethodListRespond _$SignInMethodListRespondFromJson(
  Map<String, dynamic> json,
) => SignInMethodListRespond(
  methods:
      (json['data'] as List<dynamic>?)
          ?.map((e) => SignInMethodRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SignInMethodRecord>[],
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$SignInMethodListRespondToJson(
  SignInMethodListRespond instance,
) => <String, dynamic>{'data': instance.methods, 'runtimeType': instance.$type};

MyFamilyListRespond _$MyFamilyListRespondFromJson(Map<String, dynamic> json) =>
    MyFamilyListRespond(
      list: json['data'] == null
          ? null
          : MyFamilyList.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MyFamilyListRespondToJson(
  MyFamilyListRespond instance,
) => <String, dynamic>{'data': instance.list, 'runtimeType': instance.$type};

TimezoneCatalogRespond _$TimezoneCatalogRespondFromJson(
  Map<String, dynamic> json,
) => TimezoneCatalogRespond(
  catalog: json['data'] == null
      ? null
      : TimezoneCatalog.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$TimezoneCatalogRespondToJson(
  TimezoneCatalogRespond instance,
) => <String, dynamic>{'data': instance.catalog, 'runtimeType': instance.$type};
