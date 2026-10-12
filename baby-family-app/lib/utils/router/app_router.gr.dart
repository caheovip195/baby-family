// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AboutPage]
class AboutRoute extends PageRouteInfo<void> {
  const AboutRoute({List<PageRouteInfo>? children})
    : super(AboutRoute.name, initialChildren: children);

  static const String name = 'AboutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AboutPage();
    },
  );
}

/// generated route for
/// [AiSettingsPage]
class AiSettingsRoute extends PageRouteInfo<void> {
  const AiSettingsRoute({List<PageRouteInfo>? children})
    : super(AiSettingsRoute.name, initialChildren: children);

  static const String name = 'AiSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AiSettingsPage();
    },
  );
}

/// generated route for
/// [AlbumDetailPage]
class AlbumDetailRoute extends PageRouteInfo<AlbumDetailRouteArgs> {
  AlbumDetailRoute({
    required String albumId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         AlbumDetailRoute.name,
         args: AlbumDetailRouteArgs(albumId: albumId, key: key),
         rawPathParams: {'albumId': albumId},
         initialChildren: children,
       );

  static const String name = 'AlbumDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<AlbumDetailRouteArgs>(
        orElse: () =>
            AlbumDetailRouteArgs(albumId: pathParams.getString('albumId')),
      );
      return AlbumDetailPage(albumId: args.albumId, key: args.key);
    },
  );
}

class AlbumDetailRouteArgs {
  const AlbumDetailRouteArgs({required this.albumId, this.key});

  final String albumId;

  final Key? key;

  @override
  String toString() {
    return 'AlbumDetailRouteArgs{albumId: $albumId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AlbumDetailRouteArgs) return false;
    return albumId == other.albumId && key == other.key;
  }

  @override
  int get hashCode => albumId.hashCode ^ key.hashCode;
}

/// generated route for
/// [AlbumsPage]
class AlbumsRoute extends PageRouteInfo<void> {
  const AlbumsRoute({List<PageRouteInfo>? children})
    : super(AlbumsRoute.name, initialChildren: children);

  static const String name = 'AlbumsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AlbumsPage();
    },
  );
}

/// generated route for
/// [AuthOtpPage]
class AuthOtpRoute extends PageRouteInfo<void> {
  const AuthOtpRoute({List<PageRouteInfo>? children})
    : super(AuthOtpRoute.name, initialChildren: children);

  static const String name = 'AuthOtpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthOtpPage();
    },
  );
}

/// generated route for
/// [AuthPage]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthPage();
    },
  );
}

/// generated route for
/// [AuthPhonePage]
class AuthPhoneRoute extends PageRouteInfo<void> {
  const AuthPhoneRoute({List<PageRouteInfo>? children})
    : super(AuthPhoneRoute.name, initialChildren: children);

  static const String name = 'AuthPhoneRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthPhonePage();
    },
  );
}

/// generated route for
/// [AuthProfilePage]
class AuthProfileRoute extends PageRouteInfo<void> {
  const AuthProfileRoute({List<PageRouteInfo>? children})
    : super(AuthProfileRoute.name, initialChildren: children);

  static const String name = 'AuthProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthProfilePage();
    },
  );
}

/// generated route for
/// [BabyNamesPage]
class BabyNamesRoute extends PageRouteInfo<BabyNamesRouteArgs> {
  BabyNamesRoute({
    required String pregnancyId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         BabyNamesRoute.name,
         args: BabyNamesRouteArgs(pregnancyId: pregnancyId, key: key),
         rawPathParams: {'pregnancyId': pregnancyId},
         initialChildren: children,
       );

  static const String name = 'BabyNamesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<BabyNamesRouteArgs>(
        orElse: () => BabyNamesRouteArgs(
          pregnancyId: pathParams.getString('pregnancyId'),
        ),
      );
      return BabyNamesPage(pregnancyId: args.pregnancyId, key: args.key);
    },
  );
}

class BabyNamesRouteArgs {
  const BabyNamesRouteArgs({required this.pregnancyId, this.key});

  final String pregnancyId;

  final Key? key;

  @override
  String toString() {
    return 'BabyNamesRouteArgs{pregnancyId: $pregnancyId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BabyNamesRouteArgs) return false;
    return pregnancyId == other.pregnancyId && key == other.key;
  }

  @override
  int get hashCode => pregnancyId.hashCode ^ key.hashCode;
}

/// generated route for
/// [BadgesPage]
class BadgesRoute extends PageRouteInfo<void> {
  const BadgesRoute({List<PageRouteInfo>? children})
    : super(BadgesRoute.name, initialChildren: children);

  static const String name = 'BadgesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BadgesPage();
    },
  );
}

/// generated route for
/// [BirthPage]
class BirthRoute extends PageRouteInfo<BirthRouteArgs> {
  BirthRoute({
    required String pregnancyId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         BirthRoute.name,
         args: BirthRouteArgs(pregnancyId: pregnancyId, key: key),
         rawPathParams: {'pregnancyId': pregnancyId},
         initialChildren: children,
       );

  static const String name = 'BirthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<BirthRouteArgs>(
        orElse: () =>
            BirthRouteArgs(pregnancyId: pathParams.getString('pregnancyId')),
      );
      return BirthPage(pregnancyId: args.pregnancyId, key: args.key);
    },
  );
}

class BirthRouteArgs {
  const BirthRouteArgs({required this.pregnancyId, this.key});

  final String pregnancyId;

  final Key? key;

  @override
  String toString() {
    return 'BirthRouteArgs{pregnancyId: $pregnancyId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BirthRouteArgs) return false;
    return pregnancyId == other.pregnancyId && key == other.key;
  }

  @override
  int get hashCode => pregnancyId.hashCode ^ key.hashCode;
}

/// generated route for
/// [BlockedPeoplePage]
class BlockedPeopleRoute extends PageRouteInfo<void> {
  const BlockedPeopleRoute({List<PageRouteInfo>? children})
    : super(BlockedPeopleRoute.name, initialChildren: children);

  static const String name = 'BlockedPeopleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BlockedPeoplePage();
    },
  );
}

/// generated route for
/// [BridgeInvitePage]
class BridgeInviteRoute extends PageRouteInfo<BridgeInviteRouteArgs> {
  BridgeInviteRoute({
    required String sessionId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         BridgeInviteRoute.name,
         args: BridgeInviteRouteArgs(sessionId: sessionId, key: key),
         rawPathParams: {'sessionId': sessionId},
         initialChildren: children,
       );

  static const String name = 'BridgeInviteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<BridgeInviteRouteArgs>(
        orElse: () =>
            BridgeInviteRouteArgs(sessionId: pathParams.getString('sessionId')),
      );
      return BridgeInvitePage(sessionId: args.sessionId, key: args.key);
    },
  );
}

class BridgeInviteRouteArgs {
  const BridgeInviteRouteArgs({required this.sessionId, this.key});

  final String sessionId;

  final Key? key;

  @override
  String toString() {
    return 'BridgeInviteRouteArgs{sessionId: $sessionId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BridgeInviteRouteArgs) return false;
    return sessionId == other.sessionId && key == other.key;
  }

  @override
  int get hashCode => sessionId.hashCode ^ key.hashCode;
}

/// generated route for
/// [BridgeNextStepPage]
class BridgeNextStepRoute extends PageRouteInfo<BridgeNextStepRouteArgs> {
  BridgeNextStepRoute({
    required String sessionId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         BridgeNextStepRoute.name,
         args: BridgeNextStepRouteArgs(sessionId: sessionId, key: key),
         rawPathParams: {'sessionId': sessionId},
         initialChildren: children,
       );

  static const String name = 'BridgeNextStepRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<BridgeNextStepRouteArgs>(
        orElse: () => BridgeNextStepRouteArgs(
          sessionId: pathParams.getString('sessionId'),
        ),
      );
      return BridgeNextStepPage(sessionId: args.sessionId, key: args.key);
    },
  );
}

class BridgeNextStepRouteArgs {
  const BridgeNextStepRouteArgs({required this.sessionId, this.key});

  final String sessionId;

  final Key? key;

  @override
  String toString() {
    return 'BridgeNextStepRouteArgs{sessionId: $sessionId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BridgeNextStepRouteArgs) return false;
    return sessionId == other.sessionId && key == other.key;
  }

  @override
  int get hashCode => sessionId.hashCode ^ key.hashCode;
}

/// generated route for
/// [BridgeRewritePage]
class BridgeRewriteRoute extends PageRouteInfo<void> {
  const BridgeRewriteRoute({List<PageRouteInfo>? children})
    : super(BridgeRewriteRoute.name, initialChildren: children);

  static const String name = 'BridgeRewriteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BridgeRewritePage();
    },
  );
}

/// generated route for
/// [BridgeSessionPage]
class BridgeSessionRoute extends PageRouteInfo<BridgeSessionRouteArgs> {
  BridgeSessionRoute({
    required String sessionId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         BridgeSessionRoute.name,
         args: BridgeSessionRouteArgs(sessionId: sessionId, key: key),
         rawPathParams: {'sessionId': sessionId},
         initialChildren: children,
       );

  static const String name = 'BridgeSessionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<BridgeSessionRouteArgs>(
        orElse: () => BridgeSessionRouteArgs(
          sessionId: pathParams.getString('sessionId'),
        ),
      );
      return BridgeSessionPage(sessionId: args.sessionId, key: args.key);
    },
  );
}

class BridgeSessionRouteArgs {
  const BridgeSessionRouteArgs({required this.sessionId, this.key});

  final String sessionId;

  final Key? key;

  @override
  String toString() {
    return 'BridgeSessionRouteArgs{sessionId: $sessionId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BridgeSessionRouteArgs) return false;
    return sessionId == other.sessionId && key == other.key;
  }

  @override
  int get hashCode => sessionId.hashCode ^ key.hashCode;
}

/// generated route for
/// [BridgeStartPage]
class BridgeStartRoute extends PageRouteInfo<void> {
  const BridgeStartRoute({List<PageRouteInfo>? children})
    : super(BridgeStartRoute.name, initialChildren: children);

  static const String name = 'BridgeStartRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BridgeStartPage();
    },
  );
}

/// generated route for
/// [CalendarPage]
class CalendarRoute extends PageRouteInfo<void> {
  const CalendarRoute({List<PageRouteInfo>? children})
    : super(CalendarRoute.name, initialChildren: children);

  static const String name = 'CalendarRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CalendarPage();
    },
  );
}

/// generated route for
/// [CareStatsPage]
class CareStatsRoute extends PageRouteInfo<void> {
  const CareStatsRoute({List<PageRouteInfo>? children})
    : super(CareStatsRoute.name, initialChildren: children);

  static const String name = 'CareStatsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CareStatsPage();
    },
  );
}

/// generated route for
/// [CareTabPage]
class CareTabRoute extends PageRouteInfo<void> {
  const CareTabRoute({List<PageRouteInfo>? children})
    : super(CareTabRoute.name, initialChildren: children);

  static const String name = 'CareTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CareTabPage();
    },
  );
}

/// generated route for
/// [ChildAddPage]
class ChildAddRoute extends PageRouteInfo<void> {
  const ChildAddRoute({List<PageRouteInfo>? children})
    : super(ChildAddRoute.name, initialChildren: children);

  static const String name = 'ChildAddRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChildAddPage();
    },
  );
}

/// generated route for
/// [ChildArchivePage]
class ChildArchiveRoute extends PageRouteInfo<ChildArchiveRouteArgs> {
  ChildArchiveRoute({
    required String childId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ChildArchiveRoute.name,
         args: ChildArchiveRouteArgs(childId: childId, key: key),
         rawPathParams: {'childId': childId},
         initialChildren: children,
       );

  static const String name = 'ChildArchiveRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ChildArchiveRouteArgs>(
        orElse: () =>
            ChildArchiveRouteArgs(childId: pathParams.getString('childId')),
      );
      return ChildArchivePage(childId: args.childId, key: args.key);
    },
  );
}

class ChildArchiveRouteArgs {
  const ChildArchiveRouteArgs({required this.childId, this.key});

  final String childId;

  final Key? key;

  @override
  String toString() {
    return 'ChildArchiveRouteArgs{childId: $childId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChildArchiveRouteArgs) return false;
    return childId == other.childId && key == other.key;
  }

  @override
  int get hashCode => childId.hashCode ^ key.hashCode;
}

/// generated route for
/// [ChildEditPage]
class ChildEditRoute extends PageRouteInfo<ChildEditRouteArgs> {
  ChildEditRoute({
    required String childId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ChildEditRoute.name,
         args: ChildEditRouteArgs(childId: childId, key: key),
         rawPathParams: {'childId': childId},
         initialChildren: children,
       );

  static const String name = 'ChildEditRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ChildEditRouteArgs>(
        orElse: () =>
            ChildEditRouteArgs(childId: pathParams.getString('childId')),
      );
      return ChildEditPage(childId: args.childId, key: args.key);
    },
  );
}

class ChildEditRouteArgs {
  const ChildEditRouteArgs({required this.childId, this.key});

  final String childId;

  final Key? key;

  @override
  String toString() {
    return 'ChildEditRouteArgs{childId: $childId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChildEditRouteArgs) return false;
    return childId == other.childId && key == other.key;
  }

  @override
  int get hashCode => childId.hashCode ^ key.hashCode;
}

/// generated route for
/// [ChildProfilePage]
class ChildProfileRoute extends PageRouteInfo<ChildProfileRouteArgs> {
  ChildProfileRoute({
    required String childId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ChildProfileRoute.name,
         args: ChildProfileRouteArgs(childId: childId, key: key),
         rawPathParams: {'childId': childId},
         initialChildren: children,
       );

  static const String name = 'ChildProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ChildProfileRouteArgs>(
        orElse: () =>
            ChildProfileRouteArgs(childId: pathParams.getString('childId')),
      );
      return ChildProfilePage(childId: args.childId, key: args.key);
    },
  );
}

class ChildProfileRouteArgs {
  const ChildProfileRouteArgs({required this.childId, this.key});

  final String childId;

  final Key? key;

  @override
  String toString() {
    return 'ChildProfileRouteArgs{childId: $childId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChildProfileRouteArgs) return false;
    return childId == other.childId && key == other.key;
  }

  @override
  int get hashCode => childId.hashCode ^ key.hashCode;
}

/// generated route for
/// [ChildrenPage]
class ChildrenRoute extends PageRouteInfo<void> {
  const ChildrenRoute({List<PageRouteInfo>? children})
    : super(ChildrenRoute.name, initialChildren: children);

  static const String name = 'ChildrenRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChildrenPage();
    },
  );
}

/// generated route for
/// [CircleChildPage]
class CircleChildRoute extends PageRouteInfo<void> {
  const CircleChildRoute({List<PageRouteInfo>? children})
    : super(CircleChildRoute.name, initialChildren: children);

  static const String name = 'CircleChildRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CircleChildPage();
    },
  );
}

/// generated route for
/// [CircleHomePage]
class CircleHomeRoute extends PageRouteInfo<void> {
  const CircleHomeRoute({List<PageRouteInfo>? children})
    : super(CircleHomeRoute.name, initialChildren: children);

  static const String name = 'CircleHomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CircleHomePage();
    },
  );
}

/// generated route for
/// [CircleMePage]
class CircleMeRoute extends PageRouteInfo<void> {
  const CircleMeRoute({List<PageRouteInfo>? children})
    : super(CircleMeRoute.name, initialChildren: children);

  static const String name = 'CircleMeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CircleMePage();
    },
  );
}

/// generated route for
/// [CircleMemoryDetailPage]
class CircleMemoryDetailRoute
    extends PageRouteInfo<CircleMemoryDetailRouteArgs> {
  CircleMemoryDetailRoute({
    required String memoryId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         CircleMemoryDetailRoute.name,
         args: CircleMemoryDetailRouteArgs(memoryId: memoryId, key: key),
         rawPathParams: {'memoryId': memoryId},
         initialChildren: children,
       );

  static const String name = 'CircleMemoryDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CircleMemoryDetailRouteArgs>(
        orElse: () => CircleMemoryDetailRouteArgs(
          memoryId: pathParams.getString('memoryId'),
        ),
      );
      return CircleMemoryDetailPage(memoryId: args.memoryId, key: args.key);
    },
  );
}

class CircleMemoryDetailRouteArgs {
  const CircleMemoryDetailRouteArgs({required this.memoryId, this.key});

  final String memoryId;

  final Key? key;

  @override
  String toString() {
    return 'CircleMemoryDetailRouteArgs{memoryId: $memoryId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CircleMemoryDetailRouteArgs) return false;
    return memoryId == other.memoryId && key == other.key;
  }

  @override
  int get hashCode => memoryId.hashCode ^ key.hashCode;
}

/// generated route for
/// [CirclePausedPage]
class CirclePausedRoute extends PageRouteInfo<void> {
  const CirclePausedRoute({List<PageRouteInfo>? children})
    : super(CirclePausedRoute.name, initialChildren: children);

  static const String name = 'CirclePausedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CirclePausedPage();
    },
  );
}

/// generated route for
/// [CirclePostPage]
class CirclePostRoute extends PageRouteInfo<void> {
  const CirclePostRoute({List<PageRouteInfo>? children})
    : super(CirclePostRoute.name, initialChildren: children);

  static const String name = 'CirclePostRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CirclePostPage();
    },
  );
}

/// generated route for
/// [CircleShellPage]
class CircleShellRoute extends PageRouteInfo<void> {
  const CircleShellRoute({List<PageRouteInfo>? children})
    : super(CircleShellRoute.name, initialChildren: children);

  static const String name = 'CircleShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CircleShellPage();
    },
  );
}

/// generated route for
/// [CircleWaitingPage]
class CircleWaitingRoute extends PageRouteInfo<void> {
  const CircleWaitingRoute({List<PageRouteInfo>? children})
    : super(CircleWaitingRoute.name, initialChildren: children);

  static const String name = 'CircleWaitingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CircleWaitingPage();
    },
  );
}

/// generated route for
/// [CollectionDetailPage]
class CollectionDetailRoute extends PageRouteInfo<CollectionDetailRouteArgs> {
  CollectionDetailRoute({
    required String code,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         CollectionDetailRoute.name,
         args: CollectionDetailRouteArgs(code: code, key: key),
         rawPathParams: {'code': code},
         initialChildren: children,
       );

  static const String name = 'CollectionDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CollectionDetailRouteArgs>(
        orElse: () =>
            CollectionDetailRouteArgs(code: pathParams.getString('code')),
      );
      return CollectionDetailPage(code: args.code, key: args.key);
    },
  );
}

class CollectionDetailRouteArgs {
  const CollectionDetailRouteArgs({required this.code, this.key});

  final String code;

  final Key? key;

  @override
  String toString() {
    return 'CollectionDetailRouteArgs{code: $code, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CollectionDetailRouteArgs) return false;
    return code == other.code && key == other.key;
  }

  @override
  int get hashCode => code.hashCode ^ key.hashCode;
}

/// generated route for
/// [CoupleSettingsPage]
class CoupleSettingsRoute extends PageRouteInfo<void> {
  const CoupleSettingsRoute({List<PageRouteInfo>? children})
    : super(CoupleSettingsRoute.name, initialChildren: children);

  static const String name = 'CoupleSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CoupleSettingsPage();
    },
  );
}

/// generated route for
/// [CoupleTabPage]
class CoupleTabRoute extends PageRouteInfo<void> {
  const CoupleTabRoute({List<PageRouteInfo>? children})
    : super(CoupleTabRoute.name, initialChildren: children);

  static const String name = 'CoupleTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CoupleTabPage();
    },
  );
}

/// generated route for
/// [CoupleWeekPage]
class CoupleWeekRoute extends PageRouteInfo<void> {
  const CoupleWeekRoute({List<PageRouteInfo>? children})
    : super(CoupleWeekRoute.name, initialChildren: children);

  static const String name = 'CoupleWeekRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CoupleWeekPage();
    },
  );
}

/// generated route for
/// [DayStoryPage]
class DayStoryRoute extends PageRouteInfo<DayStoryRouteArgs> {
  DayStoryRoute({String? childId, Key? key, List<PageRouteInfo>? children})
    : super(
        DayStoryRoute.name,
        args: DayStoryRouteArgs(childId: childId, key: key),
        rawQueryParams: {'childId': childId},
        initialChildren: children,
      );

  static const String name = 'DayStoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<DayStoryRouteArgs>(
        orElse: () =>
            DayStoryRouteArgs(childId: queryParams.optString('childId')),
      );
      return DayStoryPage(childId: args.childId, key: args.key);
    },
  );
}

class DayStoryRouteArgs {
  const DayStoryRouteArgs({this.childId, this.key});

  final String? childId;

  final Key? key;

  @override
  String toString() {
    return 'DayStoryRouteArgs{childId: $childId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DayStoryRouteArgs) return false;
    return childId == other.childId && key == other.key;
  }

  @override
  int get hashCode => childId.hashCode ^ key.hashCode;
}

/// generated route for
/// [DeleteAccountPage]
class DeleteAccountRoute extends PageRouteInfo<void> {
  const DeleteAccountRoute({List<PageRouteInfo>? children})
    : super(DeleteAccountRoute.name, initialChildren: children);

  static const String name = 'DeleteAccountRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DeleteAccountPage();
    },
  );
}

/// generated route for
/// [DiaryEditorPage]
class DiaryEditorRoute extends PageRouteInfo<DiaryEditorRouteArgs> {
  DiaryEditorRoute({String? childId, Key? key, List<PageRouteInfo>? children})
    : super(
        DiaryEditorRoute.name,
        args: DiaryEditorRouteArgs(childId: childId, key: key),
        rawQueryParams: {'childId': childId},
        initialChildren: children,
      );

  static const String name = 'DiaryEditorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<DiaryEditorRouteArgs>(
        orElse: () =>
            DiaryEditorRouteArgs(childId: queryParams.optString('childId')),
      );
      return DiaryEditorPage(childId: args.childId, key: args.key);
    },
  );
}

class DiaryEditorRouteArgs {
  const DiaryEditorRouteArgs({this.childId, this.key});

  final String? childId;

  final Key? key;

  @override
  String toString() {
    return 'DiaryEditorRouteArgs{childId: $childId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DiaryEditorRouteArgs) return false;
    return childId == other.childId && key == other.key;
  }

  @override
  int get hashCode => childId.hashCode ^ key.hashCode;
}

/// generated route for
/// [DisplaySettingsPage]
class DisplaySettingsRoute extends PageRouteInfo<void> {
  const DisplaySettingsRoute({List<PageRouteInfo>? children})
    : super(DisplaySettingsRoute.name, initialChildren: children);

  static const String name = 'DisplaySettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DisplaySettingsPage();
    },
  );
}

/// generated route for
/// [DraftsPage]
class DraftsRoute extends PageRouteInfo<void> {
  const DraftsRoute({List<PageRouteInfo>? children})
    : super(DraftsRoute.name, initialChildren: children);

  static const String name = 'DraftsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DraftsPage();
    },
  );
}

/// generated route for
/// [EventCreatePage]
class EventCreateRoute extends PageRouteInfo<void> {
  const EventCreateRoute({List<PageRouteInfo>? children})
    : super(EventCreateRoute.name, initialChildren: children);

  static const String name = 'EventCreateRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EventCreatePage();
    },
  );
}

/// generated route for
/// [ExpiredPage]
class ExpiredRoute extends PageRouteInfo<void> {
  const ExpiredRoute({List<PageRouteInfo>? children})
    : super(ExpiredRoute.name, initialChildren: children);

  static const String name = 'ExpiredRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ExpiredPage();
    },
  );
}

/// generated route for
/// [FamilyPage]
class FamilyRoute extends PageRouteInfo<void> {
  const FamilyRoute({List<PageRouteInfo>? children})
    : super(FamilyRoute.name, initialChildren: children);

  static const String name = 'FamilyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FamilyPage();
    },
  );
}

/// generated route for
/// [FamilyPlanPage]
class FamilyPlanRoute extends PageRouteInfo<void> {
  const FamilyPlanRoute({List<PageRouteInfo>? children})
    : super(FamilyPlanRoute.name, initialChildren: children);

  static const String name = 'FamilyPlanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FamilyPlanPage();
    },
  );
}

/// generated route for
/// [FamilySettingsPage]
class FamilySettingsRoute extends PageRouteInfo<void> {
  const FamilySettingsRoute({List<PageRouteInfo>? children})
    : super(FamilySettingsRoute.name, initialChildren: children);

  static const String name = 'FamilySettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FamilySettingsPage();
    },
  );
}

/// generated route for
/// [FamilyTreePage]
class FamilyTreeRoute extends PageRouteInfo<void> {
  const FamilyTreeRoute({List<PageRouteInfo>? children})
    : super(FamilyTreeRoute.name, initialChildren: children);

  static const String name = 'FamilyTreeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FamilyTreePage();
    },
  );
}

/// generated route for
/// [FirstsPage]
class FirstsRoute extends PageRouteInfo<FirstsRouteArgs> {
  FirstsRoute({
    required String childId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         FirstsRoute.name,
         args: FirstsRouteArgs(childId: childId, key: key),
         rawPathParams: {'childId': childId},
         initialChildren: children,
       );

  static const String name = 'FirstsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<FirstsRouteArgs>(
        orElse: () => FirstsRouteArgs(childId: pathParams.getString('childId')),
      );
      return FirstsPage(childId: args.childId, key: args.key);
    },
  );
}

class FirstsRouteArgs {
  const FirstsRouteArgs({required this.childId, this.key});

  final String childId;

  final Key? key;

  @override
  String toString() {
    return 'FirstsRouteArgs{childId: $childId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FirstsRouteArgs) return false;
    return childId == other.childId && key == other.key;
  }

  @override
  int get hashCode => childId.hashCode ^ key.hashCode;
}

/// generated route for
/// [HelpPage]
class HelpRoute extends PageRouteInfo<void> {
  const HelpRoute({List<PageRouteInfo>? children})
    : super(HelpRoute.name, initialChildren: children);

  static const String name = 'HelpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HelpPage();
    },
  );
}

/// generated route for
/// [HomeTabPage]
class HomeTabRoute extends PageRouteInfo<void> {
  const HomeTabRoute({List<PageRouteInfo>? children})
    : super(HomeTabRoute.name, initialChildren: children);

  static const String name = 'HomeTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeTabPage();
    },
  );
}

/// generated route for
/// [InviteCodePage]
class InviteCodeRoute extends PageRouteInfo<void> {
  const InviteCodeRoute({List<PageRouteInfo>? children})
    : super(InviteCodeRoute.name, initialChildren: children);

  static const String name = 'InviteCodeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InviteCodePage();
    },
  );
}

/// generated route for
/// [InvitePreviewPage]
class InvitePreviewRoute extends PageRouteInfo<InvitePreviewRouteArgs> {
  InvitePreviewRoute({String? code, Key? key, List<PageRouteInfo>? children})
    : super(
        InvitePreviewRoute.name,
        args: InvitePreviewRouteArgs(code: code, key: key),
        rawQueryParams: {'code': code},
        initialChildren: children,
      );

  static const String name = 'InvitePreviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<InvitePreviewRouteArgs>(
        orElse: () =>
            InvitePreviewRouteArgs(code: queryParams.optString('code')),
      );
      return InvitePreviewPage(code: args.code, key: args.key);
    },
  );
}

class InvitePreviewRouteArgs {
  const InvitePreviewRouteArgs({this.code, this.key});

  final String? code;

  final Key? key;

  @override
  String toString() {
    return 'InvitePreviewRouteArgs{code: $code, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InvitePreviewRouteArgs) return false;
    return code == other.code && key == other.key;
  }

  @override
  int get hashCode => code.hashCode ^ key.hashCode;
}

/// generated route for
/// [LeaveFamilyPage]
class LeaveFamilyRoute extends PageRouteInfo<void> {
  const LeaveFamilyRoute({List<PageRouteInfo>? children})
    : super(LeaveFamilyRoute.name, initialChildren: children);

  static const String name = 'LeaveFamilyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LeaveFamilyPage();
    },
  );
}

/// generated route for
/// [LetterComposerPage]
class LetterComposerRoute extends PageRouteInfo<LetterComposerRouteArgs> {
  LetterComposerRoute({
    String? childId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         LetterComposerRoute.name,
         args: LetterComposerRouteArgs(childId: childId, key: key),
         rawQueryParams: {'childId': childId},
         initialChildren: children,
       );

  static const String name = 'LetterComposerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<LetterComposerRouteArgs>(
        orElse: () =>
            LetterComposerRouteArgs(childId: queryParams.optString('childId')),
      );
      return LetterComposerPage(childId: args.childId, key: args.key);
    },
  );
}

class LetterComposerRouteArgs {
  const LetterComposerRouteArgs({this.childId, this.key});

  final String? childId;

  final Key? key;

  @override
  String toString() {
    return 'LetterComposerRouteArgs{childId: $childId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LetterComposerRouteArgs) return false;
    return childId == other.childId && key == other.key;
  }

  @override
  int get hashCode => childId.hashCode ^ key.hashCode;
}

/// generated route for
/// [MainShellPage]
class MainShellRoute extends PageRouteInfo<void> {
  const MainShellRoute({List<PageRouteInfo>? children})
    : super(MainShellRoute.name, initialChildren: children);

  static const String name = 'MainShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainShellPage();
    },
  );
}

/// generated route for
/// [MemoriesTabPage]
class MemoriesTabRoute extends PageRouteInfo<void> {
  const MemoriesTabRoute({List<PageRouteInfo>? children})
    : super(MemoriesTabRoute.name, initialChildren: children);

  static const String name = 'MemoriesTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MemoriesTabPage();
    },
  );
}

/// generated route for
/// [MemoryCommentsPage]
class MemoryCommentsRoute extends PageRouteInfo<MemoryCommentsRouteArgs> {
  MemoryCommentsRoute({
    required String memoryId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         MemoryCommentsRoute.name,
         args: MemoryCommentsRouteArgs(memoryId: memoryId, key: key),
         rawPathParams: {'memoryId': memoryId},
         initialChildren: children,
       );

  static const String name = 'MemoryCommentsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MemoryCommentsRouteArgs>(
        orElse: () =>
            MemoryCommentsRouteArgs(memoryId: pathParams.getString('memoryId')),
      );
      return MemoryCommentsPage(memoryId: args.memoryId, key: args.key);
    },
  );
}

class MemoryCommentsRouteArgs {
  const MemoryCommentsRouteArgs({required this.memoryId, this.key});

  final String memoryId;

  final Key? key;

  @override
  String toString() {
    return 'MemoryCommentsRouteArgs{memoryId: $memoryId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MemoryCommentsRouteArgs) return false;
    return memoryId == other.memoryId && key == other.key;
  }

  @override
  int get hashCode => memoryId.hashCode ^ key.hashCode;
}

/// generated route for
/// [MemoryComposerPage]
class MemoryComposerRoute extends PageRouteInfo<MemoryComposerRouteArgs> {
  MemoryComposerRoute({
    String? kind,
    String? childId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         MemoryComposerRoute.name,
         args: MemoryComposerRouteArgs(kind: kind, childId: childId, key: key),
         rawQueryParams: {'kind': kind, 'childId': childId},
         initialChildren: children,
       );

  static const String name = 'MemoryComposerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<MemoryComposerRouteArgs>(
        orElse: () => MemoryComposerRouteArgs(
          kind: queryParams.optString('kind'),
          childId: queryParams.optString('childId'),
        ),
      );
      return MemoryComposerPage(
        kind: args.kind,
        childId: args.childId,
        key: args.key,
      );
    },
  );
}

class MemoryComposerRouteArgs {
  const MemoryComposerRouteArgs({this.kind, this.childId, this.key});

  final String? kind;

  final String? childId;

  final Key? key;

  @override
  String toString() {
    return 'MemoryComposerRouteArgs{kind: $kind, childId: $childId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MemoryComposerRouteArgs) return false;
    return kind == other.kind && childId == other.childId && key == other.key;
  }

  @override
  int get hashCode => kind.hashCode ^ childId.hashCode ^ key.hashCode;
}

/// generated route for
/// [MemoryDetailPage]
class MemoryDetailRoute extends PageRouteInfo<MemoryDetailRouteArgs> {
  MemoryDetailRoute({
    required String memoryId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         MemoryDetailRoute.name,
         args: MemoryDetailRouteArgs(memoryId: memoryId, key: key),
         rawPathParams: {'memoryId': memoryId},
         initialChildren: children,
       );

  static const String name = 'MemoryDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MemoryDetailRouteArgs>(
        orElse: () =>
            MemoryDetailRouteArgs(memoryId: pathParams.getString('memoryId')),
      );
      return MemoryDetailPage(memoryId: args.memoryId, key: args.key);
    },
  );
}

class MemoryDetailRouteArgs {
  const MemoryDetailRouteArgs({required this.memoryId, this.key});

  final String memoryId;

  final Key? key;

  @override
  String toString() {
    return 'MemoryDetailRouteArgs{memoryId: $memoryId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MemoryDetailRouteArgs) return false;
    return memoryId == other.memoryId && key == other.key;
  }

  @override
  int get hashCode => memoryId.hashCode ^ key.hashCode;
}

/// generated route for
/// [MemoryPerspectivePage]
class MemoryPerspectiveRoute extends PageRouteInfo<MemoryPerspectiveRouteArgs> {
  MemoryPerspectiveRoute({
    required String memoryId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         MemoryPerspectiveRoute.name,
         args: MemoryPerspectiveRouteArgs(memoryId: memoryId, key: key),
         rawPathParams: {'memoryId': memoryId},
         initialChildren: children,
       );

  static const String name = 'MemoryPerspectiveRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MemoryPerspectiveRouteArgs>(
        orElse: () => MemoryPerspectiveRouteArgs(
          memoryId: pathParams.getString('memoryId'),
        ),
      );
      return MemoryPerspectivePage(memoryId: args.memoryId, key: args.key);
    },
  );
}

class MemoryPerspectiveRouteArgs {
  const MemoryPerspectiveRouteArgs({required this.memoryId, this.key});

  final String memoryId;

  final Key? key;

  @override
  String toString() {
    return 'MemoryPerspectiveRouteArgs{memoryId: $memoryId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MemoryPerspectiveRouteArgs) return false;
    return memoryId == other.memoryId && key == other.key;
  }

  @override
  int get hashCode => memoryId.hashCode ^ key.hashCode;
}

/// generated route for
/// [MemoryQuotePage]
class MemoryQuoteRoute extends PageRouteInfo<MemoryQuoteRouteArgs> {
  MemoryQuoteRoute({String? childId, Key? key, List<PageRouteInfo>? children})
    : super(
        MemoryQuoteRoute.name,
        args: MemoryQuoteRouteArgs(childId: childId, key: key),
        rawQueryParams: {'childId': childId},
        initialChildren: children,
      );

  static const String name = 'MemoryQuoteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<MemoryQuoteRouteArgs>(
        orElse: () =>
            MemoryQuoteRouteArgs(childId: queryParams.optString('childId')),
      );
      return MemoryQuotePage(childId: args.childId, key: args.key);
    },
  );
}

class MemoryQuoteRouteArgs {
  const MemoryQuoteRouteArgs({this.childId, this.key});

  final String? childId;

  final Key? key;

  @override
  String toString() {
    return 'MemoryQuoteRouteArgs{childId: $childId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MemoryQuoteRouteArgs) return false;
    return childId == other.childId && key == other.key;
  }

  @override
  int get hashCode => childId.hashCode ^ key.hashCode;
}

/// generated route for
/// [MemorySearchPage]
class MemorySearchRoute extends PageRouteInfo<void> {
  const MemorySearchRoute({List<PageRouteInfo>? children})
    : super(MemorySearchRoute.name, initialChildren: children);

  static const String name = 'MemorySearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MemorySearchPage();
    },
  );
}

/// generated route for
/// [MemoryStoryPage]
class MemoryStoryRoute extends PageRouteInfo<MemoryStoryRouteArgs> {
  MemoryStoryRoute({
    required String childId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         MemoryStoryRoute.name,
         args: MemoryStoryRouteArgs(childId: childId, key: key),
         rawPathParams: {'childId': childId},
         initialChildren: children,
       );

  static const String name = 'MemoryStoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MemoryStoryRouteArgs>(
        orElse: () =>
            MemoryStoryRouteArgs(childId: pathParams.getString('childId')),
      );
      return MemoryStoryPage(childId: args.childId, key: args.key);
    },
  );
}

class MemoryStoryRouteArgs {
  const MemoryStoryRouteArgs({required this.childId, this.key});

  final String childId;

  final Key? key;

  @override
  String toString() {
    return 'MemoryStoryRouteArgs{childId: $childId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MemoryStoryRouteArgs) return false;
    return childId == other.childId && key == other.key;
  }

  @override
  int get hashCode => childId.hashCode ^ key.hashCode;
}

/// generated route for
/// [MilestonePickerPage]
class MilestonePickerRoute extends PageRouteInfo<MilestonePickerRouteArgs> {
  MilestonePickerRoute({
    String? childId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         MilestonePickerRoute.name,
         args: MilestonePickerRouteArgs(childId: childId, key: key),
         rawQueryParams: {'childId': childId},
         initialChildren: children,
       );

  static const String name = 'MilestonePickerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<MilestonePickerRouteArgs>(
        orElse: () =>
            MilestonePickerRouteArgs(childId: queryParams.optString('childId')),
      );
      return MilestonePickerPage(childId: args.childId, key: args.key);
    },
  );
}

class MilestonePickerRouteArgs {
  const MilestonePickerRouteArgs({this.childId, this.key});

  final String? childId;

  final Key? key;

  @override
  String toString() {
    return 'MilestonePickerRouteArgs{childId: $childId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MilestonePickerRouteArgs) return false;
    return childId == other.childId && key == other.key;
  }

  @override
  int get hashCode => childId.hashCode ^ key.hashCode;
}

/// generated route for
/// [MissionCreatePage]
class MissionCreateRoute extends PageRouteInfo<MissionCreateRouteArgs> {
  MissionCreateRoute({
    String? childId,
    String? templateId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         MissionCreateRoute.name,
         args: MissionCreateRouteArgs(
           childId: childId,
           templateId: templateId,
           key: key,
         ),
         rawQueryParams: {'childId': childId, 'templateId': templateId},
         initialChildren: children,
       );

  static const String name = 'MissionCreateRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<MissionCreateRouteArgs>(
        orElse: () => MissionCreateRouteArgs(
          childId: queryParams.optString('childId'),
          templateId: queryParams.optString('templateId'),
        ),
      );
      return MissionCreatePage(
        childId: args.childId,
        templateId: args.templateId,
        key: args.key,
      );
    },
  );
}

class MissionCreateRouteArgs {
  const MissionCreateRouteArgs({this.childId, this.templateId, this.key});

  final String? childId;

  final String? templateId;

  final Key? key;

  @override
  String toString() {
    return 'MissionCreateRouteArgs{childId: $childId, templateId: $templateId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MissionCreateRouteArgs) return false;
    return childId == other.childId &&
        templateId == other.templateId &&
        key == other.key;
  }

  @override
  int get hashCode => childId.hashCode ^ templateId.hashCode ^ key.hashCode;
}

/// generated route for
/// [MissionDetailPage]
class MissionDetailRoute extends PageRouteInfo<MissionDetailRouteArgs> {
  MissionDetailRoute({
    required String missionId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         MissionDetailRoute.name,
         args: MissionDetailRouteArgs(missionId: missionId, key: key),
         rawPathParams: {'missionId': missionId},
         initialChildren: children,
       );

  static const String name = 'MissionDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MissionDetailRouteArgs>(
        orElse: () => MissionDetailRouteArgs(
          missionId: pathParams.getString('missionId'),
        ),
      );
      return MissionDetailPage(missionId: args.missionId, key: args.key);
    },
  );
}

class MissionDetailRouteArgs {
  const MissionDetailRouteArgs({required this.missionId, this.key});

  final String missionId;

  final Key? key;

  @override
  String toString() {
    return 'MissionDetailRouteArgs{missionId: $missionId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MissionDetailRouteArgs) return false;
    return missionId == other.missionId && key == other.key;
  }

  @override
  int get hashCode => missionId.hashCode ^ key.hashCode;
}

/// generated route for
/// [MissionHistoryPage]
class MissionHistoryRoute extends PageRouteInfo<void> {
  const MissionHistoryRoute({List<PageRouteInfo>? children})
    : super(MissionHistoryRoute.name, initialChildren: children);

  static const String name = 'MissionHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MissionHistoryPage();
    },
  );
}

/// generated route for
/// [MissionLibraryPage]
class MissionLibraryRoute extends PageRouteInfo<void> {
  const MissionLibraryRoute({List<PageRouteInfo>? children})
    : super(MissionLibraryRoute.name, initialChildren: children);

  static const String name = 'MissionLibraryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MissionLibraryPage();
    },
  );
}

/// generated route for
/// [MissionSettingsPage]
class MissionSettingsRoute extends PageRouteInfo<void> {
  const MissionSettingsRoute({List<PageRouteInfo>? children})
    : super(MissionSettingsRoute.name, initialChildren: children);

  static const String name = 'MissionSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MissionSettingsPage();
    },
  );
}

/// generated route for
/// [MonthRecapPage]
class MonthRecapRoute extends PageRouteInfo<MonthRecapRouteArgs> {
  MonthRecapRoute({String? childId, Key? key, List<PageRouteInfo>? children})
    : super(
        MonthRecapRoute.name,
        args: MonthRecapRouteArgs(childId: childId, key: key),
        rawQueryParams: {'childId': childId},
        initialChildren: children,
      );

  static const String name = 'MonthRecapRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<MonthRecapRouteArgs>(
        orElse: () =>
            MonthRecapRouteArgs(childId: queryParams.optString('childId')),
      );
      return MonthRecapPage(childId: args.childId, key: args.key);
    },
  );
}

class MonthRecapRouteArgs {
  const MonthRecapRouteArgs({this.childId, this.key});

  final String? childId;

  final Key? key;

  @override
  String toString() {
    return 'MonthRecapRouteArgs{childId: $childId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MonthRecapRouteArgs) return false;
    return childId == other.childId && key == other.key;
  }

  @override
  int get hashCode => childId.hashCode ^ key.hashCode;
}

/// generated route for
/// [MonthlyCameraPage]
class MonthlyCameraRoute extends PageRouteInfo<MonthlyCameraRouteArgs> {
  MonthlyCameraRoute({
    required String childId,
    int? month,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         MonthlyCameraRoute.name,
         args: MonthlyCameraRouteArgs(childId: childId, month: month, key: key),
         rawPathParams: {'childId': childId},
         rawQueryParams: {'month': month},
         initialChildren: children,
       );

  static const String name = 'MonthlyCameraRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<MonthlyCameraRouteArgs>(
        orElse: () => MonthlyCameraRouteArgs(
          childId: pathParams.getString('childId'),
          month: queryParams.optInt('month'),
        ),
      );
      return MonthlyCameraPage(
        childId: args.childId,
        month: args.month,
        key: args.key,
      );
    },
  );
}

class MonthlyCameraRouteArgs {
  const MonthlyCameraRouteArgs({required this.childId, this.month, this.key});

  final String childId;

  final int? month;

  final Key? key;

  @override
  String toString() {
    return 'MonthlyCameraRouteArgs{childId: $childId, month: $month, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MonthlyCameraRouteArgs) return false;
    return childId == other.childId && month == other.month && key == other.key;
  }

  @override
  int get hashCode => childId.hashCode ^ month.hashCode ^ key.hashCode;
}

/// generated route for
/// [MonthlyPhotosPage]
class MonthlyPhotosRoute extends PageRouteInfo<MonthlyPhotosRouteArgs> {
  MonthlyPhotosRoute({
    required String childId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         MonthlyPhotosRoute.name,
         args: MonthlyPhotosRouteArgs(childId: childId, key: key),
         rawPathParams: {'childId': childId},
         initialChildren: children,
       );

  static const String name = 'MonthlyPhotosRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MonthlyPhotosRouteArgs>(
        orElse: () =>
            MonthlyPhotosRouteArgs(childId: pathParams.getString('childId')),
      );
      return MonthlyPhotosPage(childId: args.childId, key: args.key);
    },
  );
}

class MonthlyPhotosRouteArgs {
  const MonthlyPhotosRouteArgs({required this.childId, this.key});

  final String childId;

  final Key? key;

  @override
  String toString() {
    return 'MonthlyPhotosRouteArgs{childId: $childId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MonthlyPhotosRouteArgs) return false;
    return childId == other.childId && key == other.key;
  }

  @override
  int get hashCode => childId.hashCode ^ key.hashCode;
}

/// generated route for
/// [MyDataPage]
class MyDataRoute extends PageRouteInfo<void> {
  const MyDataRoute({List<PageRouteInfo>? children})
    : super(MyDataRoute.name, initialChildren: children);

  static const String name = 'MyDataRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MyDataPage();
    },
  );
}

/// generated route for
/// [NotificationSettingsPage]
class NotificationSettingsRoute extends PageRouteInfo<void> {
  const NotificationSettingsRoute({List<PageRouteInfo>? children})
    : super(NotificationSettingsRoute.name, initialChildren: children);

  static const String name = 'NotificationSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationSettingsPage();
    },
  );
}

/// generated route for
/// [NotificationsPage]
class NotificationsRoute extends PageRouteInfo<void> {
  const NotificationsRoute({List<PageRouteInfo>? children})
    : super(NotificationsRoute.name, initialChildren: children);

  static const String name = 'NotificationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationsPage();
    },
  );
}

/// generated route for
/// [OnThisDayPage]
class OnThisDayRoute extends PageRouteInfo<void> {
  const OnThisDayRoute({List<PageRouteInfo>? children})
    : super(OnThisDayRoute.name, initialChildren: children);

  static const String name = 'OnThisDayRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnThisDayPage();
    },
  );
}

/// generated route for
/// [OnboardingActivatedPage]
class OnboardingActivatedRoute extends PageRouteInfo<void> {
  const OnboardingActivatedRoute({List<PageRouteInfo>? children})
    : super(OnboardingActivatedRoute.name, initialChildren: children);

  static const String name = 'OnboardingActivatedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingActivatedPage();
    },
  );
}

/// generated route for
/// [OnboardingChildPage]
class OnboardingChildRoute extends PageRouteInfo<void> {
  const OnboardingChildRoute({List<PageRouteInfo>? children})
    : super(OnboardingChildRoute.name, initialChildren: children);

  static const String name = 'OnboardingChildRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingChildPage();
    },
  );
}

/// generated route for
/// [OnboardingFamilyPage]
class OnboardingFamilyRoute extends PageRouteInfo<void> {
  const OnboardingFamilyRoute({List<PageRouteInfo>? children})
    : super(OnboardingFamilyRoute.name, initialChildren: children);

  static const String name = 'OnboardingFamilyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingFamilyPage();
    },
  );
}

/// generated route for
/// [OnboardingFirstMemoryPage]
class OnboardingFirstMemoryRoute extends PageRouteInfo<void> {
  const OnboardingFirstMemoryRoute({List<PageRouteInfo>? children})
    : super(OnboardingFirstMemoryRoute.name, initialChildren: children);

  static const String name = 'OnboardingFirstMemoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingFirstMemoryPage();
    },
  );
}

/// generated route for
/// [OnboardingInvitePartnerPage]
class OnboardingInvitePartnerRoute extends PageRouteInfo<void> {
  const OnboardingInvitePartnerRoute({List<PageRouteInfo>? children})
    : super(OnboardingInvitePartnerRoute.name, initialChildren: children);

  static const String name = 'OnboardingInvitePartnerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingInvitePartnerPage();
    },
  );
}

/// generated route for
/// [OnboardingNotificationsPage]
class OnboardingNotificationsRoute extends PageRouteInfo<void> {
  const OnboardingNotificationsRoute({List<PageRouteInfo>? children})
    : super(OnboardingNotificationsRoute.name, initialChildren: children);

  static const String name = 'OnboardingNotificationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingNotificationsPage();
    },
  );
}

/// generated route for
/// [OnboardingPregnancyPage]
class OnboardingPregnancyRoute extends PageRouteInfo<void> {
  const OnboardingPregnancyRoute({List<PageRouteInfo>? children})
    : super(OnboardingPregnancyRoute.name, initialChildren: children);

  static const String name = 'OnboardingPregnancyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingPregnancyPage();
    },
  );
}

/// generated route for
/// [OnboardingPrivacyPage]
class OnboardingPrivacyRoute extends PageRouteInfo<void> {
  const OnboardingPrivacyRoute({List<PageRouteInfo>? children})
    : super(OnboardingPrivacyRoute.name, initialChildren: children);

  static const String name = 'OnboardingPrivacyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingPrivacyPage();
    },
  );
}

/// generated route for
/// [OnboardingRolePage]
class OnboardingRoleRoute extends PageRouteInfo<void> {
  const OnboardingRoleRoute({List<PageRouteInfo>? children})
    : super(OnboardingRoleRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingRolePage();
    },
  );
}

/// generated route for
/// [OnboardingStagePage]
class OnboardingStageRoute extends PageRouteInfo<void> {
  const OnboardingStageRoute({List<PageRouteInfo>? children})
    : super(OnboardingStageRoute.name, initialChildren: children);

  static const String name = 'OnboardingStageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingStagePage();
    },
  );
}

/// generated route for
/// [OnboardingWaitingPage]
class OnboardingWaitingRoute extends PageRouteInfo<void> {
  const OnboardingWaitingRoute({List<PageRouteInfo>? children})
    : super(OnboardingWaitingRoute.name, initialChildren: children);

  static const String name = 'OnboardingWaitingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingWaitingPage();
    },
  );
}

/// generated route for
/// [PartnerInvitePage]
class PartnerInviteRoute extends PageRouteInfo<void> {
  const PartnerInviteRoute({List<PageRouteInfo>? children})
    : super(PartnerInviteRoute.name, initialChildren: children);

  static const String name = 'PartnerInviteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PartnerInvitePage();
    },
  );
}

/// generated route for
/// [PendingInvitesPage]
class PendingInvitesRoute extends PageRouteInfo<void> {
  const PendingInvitesRoute({List<PageRouteInfo>? children})
    : super(PendingInvitesRoute.name, initialChildren: children);

  static const String name = 'PendingInvitesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PendingInvitesPage();
    },
  );
}

/// generated route for
/// [PendingReviewPage]
class PendingReviewRoute extends PageRouteInfo<void> {
  const PendingReviewRoute({List<PageRouteInfo>? children})
    : super(PendingReviewRoute.name, initialChildren: children);

  static const String name = 'PendingReviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PendingReviewPage();
    },
  );
}

/// generated route for
/// [PhotoViewerPage]
class PhotoViewerRoute extends PageRouteInfo<PhotoViewerRouteArgs> {
  PhotoViewerRoute({
    required String memoryId,
    int? index,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         PhotoViewerRoute.name,
         args: PhotoViewerRouteArgs(memoryId: memoryId, index: index, key: key),
         rawPathParams: {'memoryId': memoryId},
         rawQueryParams: {'index': index},
         initialChildren: children,
       );

  static const String name = 'PhotoViewerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<PhotoViewerRouteArgs>(
        orElse: () => PhotoViewerRouteArgs(
          memoryId: pathParams.getString('memoryId'),
          index: queryParams.optInt('index'),
        ),
      );
      return PhotoViewerPage(
        memoryId: args.memoryId,
        index: args.index,
        key: args.key,
      );
    },
  );
}

class PhotoViewerRouteArgs {
  const PhotoViewerRouteArgs({required this.memoryId, this.index, this.key});

  final String memoryId;

  final int? index;

  final Key? key;

  @override
  String toString() {
    return 'PhotoViewerRouteArgs{memoryId: $memoryId, index: $index, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PhotoViewerRouteArgs) return false;
    return memoryId == other.memoryId &&
        index == other.index &&
        key == other.key;
  }

  @override
  int get hashCode => memoryId.hashCode ^ index.hashCode ^ key.hashCode;
}

/// generated route for
/// [PlansPage]
class PlansRoute extends PageRouteInfo<void> {
  const PlansRoute({List<PageRouteInfo>? children})
    : super(PlansRoute.name, initialChildren: children);

  static const String name = 'PlansRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PlansPage();
    },
  );
}

/// generated route for
/// [PregnancyArchivePage]
class PregnancyArchiveRoute extends PageRouteInfo<PregnancyArchiveRouteArgs> {
  PregnancyArchiveRoute({
    required String pregnancyId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         PregnancyArchiveRoute.name,
         args: PregnancyArchiveRouteArgs(pregnancyId: pregnancyId, key: key),
         rawPathParams: {'pregnancyId': pregnancyId},
         initialChildren: children,
       );

  static const String name = 'PregnancyArchiveRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PregnancyArchiveRouteArgs>(
        orElse: () => PregnancyArchiveRouteArgs(
          pregnancyId: pathParams.getString('pregnancyId'),
        ),
      );
      return PregnancyArchivePage(pregnancyId: args.pregnancyId, key: args.key);
    },
  );
}

class PregnancyArchiveRouteArgs {
  const PregnancyArchiveRouteArgs({required this.pregnancyId, this.key});

  final String pregnancyId;

  final Key? key;

  @override
  String toString() {
    return 'PregnancyArchiveRouteArgs{pregnancyId: $pregnancyId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PregnancyArchiveRouteArgs) return false;
    return pregnancyId == other.pregnancyId && key == other.key;
  }

  @override
  int get hashCode => pregnancyId.hashCode ^ key.hashCode;
}

/// generated route for
/// [PregnancyJourneyPage]
class PregnancyJourneyRoute extends PageRouteInfo<PregnancyJourneyRouteArgs> {
  PregnancyJourneyRoute({
    required String pregnancyId,
    String? tab,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         PregnancyJourneyRoute.name,
         args: PregnancyJourneyRouteArgs(
           pregnancyId: pregnancyId,
           tab: tab,
           key: key,
         ),
         rawPathParams: {'pregnancyId': pregnancyId},
         rawQueryParams: {'tab': tab},
         initialChildren: children,
       );

  static const String name = 'PregnancyJourneyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<PregnancyJourneyRouteArgs>(
        orElse: () => PregnancyJourneyRouteArgs(
          pregnancyId: pathParams.getString('pregnancyId'),
          tab: queryParams.optString('tab'),
        ),
      );
      return PregnancyJourneyPage(
        pregnancyId: args.pregnancyId,
        tab: args.tab,
        key: args.key,
      );
    },
  );
}

class PregnancyJourneyRouteArgs {
  const PregnancyJourneyRouteArgs({
    required this.pregnancyId,
    this.tab,
    this.key,
  });

  final String pregnancyId;

  final String? tab;

  final Key? key;

  @override
  String toString() {
    return 'PregnancyJourneyRouteArgs{pregnancyId: $pregnancyId, tab: $tab, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PregnancyJourneyRouteArgs) return false;
    return pregnancyId == other.pregnancyId &&
        tab == other.tab &&
        key == other.key;
  }

  @override
  int get hashCode => pregnancyId.hashCode ^ tab.hashCode ^ key.hashCode;
}

/// generated route for
/// [PrivacySettingsPage]
class PrivacySettingsRoute extends PageRouteInfo<void> {
  const PrivacySettingsRoute({List<PageRouteInfo>? children})
    : super(PrivacySettingsRoute.name, initialChildren: children);

  static const String name = 'PrivacySettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PrivacySettingsPage();
    },
  );
}

/// generated route for
/// [PrivateJournalPage]
class PrivateJournalRoute extends PageRouteInfo<void> {
  const PrivateJournalRoute({List<PageRouteInfo>? children})
    : super(PrivateJournalRoute.name, initialChildren: children);

  static const String name = 'PrivateJournalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PrivateJournalPage();
    },
  );
}

/// generated route for
/// [ProfileSettingsPage]
class ProfileSettingsRoute extends PageRouteInfo<void> {
  const ProfileSettingsRoute({List<PageRouteInfo>? children})
    : super(ProfileSettingsRoute.name, initialChildren: children);

  static const String name = 'ProfileSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileSettingsPage();
    },
  );
}

/// generated route for
/// [RelativeDetailPage]
class RelativeDetailRoute extends PageRouteInfo<RelativeDetailRouteArgs> {
  RelativeDetailRoute({
    required String memberId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         RelativeDetailRoute.name,
         args: RelativeDetailRouteArgs(memberId: memberId, key: key),
         rawPathParams: {'memberId': memberId},
         initialChildren: children,
       );

  static const String name = 'RelativeDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<RelativeDetailRouteArgs>(
        orElse: () =>
            RelativeDetailRouteArgs(memberId: pathParams.getString('memberId')),
      );
      return RelativeDetailPage(memberId: args.memberId, key: args.key);
    },
  );
}

class RelativeDetailRouteArgs {
  const RelativeDetailRouteArgs({required this.memberId, this.key});

  final String memberId;

  final Key? key;

  @override
  String toString() {
    return 'RelativeDetailRouteArgs{memberId: $memberId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RelativeDetailRouteArgs) return false;
    return memberId == other.memberId && key == other.key;
  }

  @override
  int get hashCode => memberId.hashCode ^ key.hashCode;
}

/// generated route for
/// [RelativeInvitePage]
class RelativeInviteRoute extends PageRouteInfo<void> {
  const RelativeInviteRoute({List<PageRouteInfo>? children})
    : super(RelativeInviteRoute.name, initialChildren: children);

  static const String name = 'RelativeInviteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RelativeInvitePage();
    },
  );
}

/// generated route for
/// [RequestComposePage]
class RequestComposeRoute extends PageRouteInfo<RequestComposeRouteArgs> {
  RequestComposeRoute({String? title, Key? key, List<PageRouteInfo>? children})
    : super(
        RequestComposeRoute.name,
        args: RequestComposeRouteArgs(title: title, key: key),
        rawQueryParams: {'title': title},
        initialChildren: children,
      );

  static const String name = 'RequestComposeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<RequestComposeRouteArgs>(
        orElse: () =>
            RequestComposeRouteArgs(title: queryParams.optString('title')),
      );
      return RequestComposePage(title: args.title, key: args.key);
    },
  );
}

class RequestComposeRouteArgs {
  const RequestComposeRouteArgs({this.title, this.key});

  final String? title;

  final Key? key;

  @override
  String toString() {
    return 'RequestComposeRouteArgs{title: $title, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RequestComposeRouteArgs) return false;
    return title == other.title && key == other.key;
  }

  @override
  int get hashCode => title.hashCode ^ key.hashCode;
}

/// generated route for
/// [RequestDetailPage]
class RequestDetailRoute extends PageRouteInfo<RequestDetailRouteArgs> {
  RequestDetailRoute({
    required String requestId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         RequestDetailRoute.name,
         args: RequestDetailRouteArgs(requestId: requestId, key: key),
         rawPathParams: {'requestId': requestId},
         initialChildren: children,
       );

  static const String name = 'RequestDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<RequestDetailRouteArgs>(
        orElse: () => RequestDetailRouteArgs(
          requestId: pathParams.getString('requestId'),
        ),
      );
      return RequestDetailPage(requestId: args.requestId, key: args.key);
    },
  );
}

class RequestDetailRouteArgs {
  const RequestDetailRouteArgs({required this.requestId, this.key});

  final String requestId;

  final Key? key;

  @override
  String toString() {
    return 'RequestDetailRouteArgs{requestId: $requestId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RequestDetailRouteArgs) return false;
    return requestId == other.requestId && key == other.key;
  }

  @override
  int get hashCode => requestId.hashCode ^ key.hashCode;
}

/// generated route for
/// [SafetySupportPage]
class SafetySupportRoute extends PageRouteInfo<void> {
  const SafetySupportRoute({List<PageRouteInfo>? children})
    : super(SafetySupportRoute.name, initialChildren: children);

  static const String name = 'SafetySupportRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SafetySupportPage();
    },
  );
}

/// generated route for
/// [SecuritySettingsPage]
class SecuritySettingsRoute extends PageRouteInfo<void> {
  const SecuritySettingsRoute({List<PageRouteInfo>? children})
    : super(SecuritySettingsRoute.name, initialChildren: children);

  static const String name = 'SecuritySettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SecuritySettingsPage();
    },
  );
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsPage();
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [ThanksComposePage]
class ThanksComposeRoute extends PageRouteInfo<ThanksComposeRouteArgs> {
  ThanksComposeRoute({
    String? missionId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ThanksComposeRoute.name,
         args: ThanksComposeRouteArgs(missionId: missionId, key: key),
         rawQueryParams: {'missionId': missionId},
         initialChildren: children,
       );

  static const String name = 'ThanksComposeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<ThanksComposeRouteArgs>(
        orElse: () => ThanksComposeRouteArgs(
          missionId: queryParams.optString('missionId'),
        ),
      );
      return ThanksComposePage(missionId: args.missionId, key: args.key);
    },
  );
}

class ThanksComposeRouteArgs {
  const ThanksComposeRouteArgs({this.missionId, this.key});

  final String? missionId;

  final Key? key;

  @override
  String toString() {
    return 'ThanksComposeRouteArgs{missionId: $missionId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ThanksComposeRouteArgs) return false;
    return missionId == other.missionId && key == other.key;
  }

  @override
  int get hashCode => missionId.hashCode ^ key.hashCode;
}

/// generated route for
/// [ThanksWallPage]
class ThanksWallRoute extends PageRouteInfo<void> {
  const ThanksWallRoute({List<PageRouteInfo>? children})
    : super(ThanksWallRoute.name, initialChildren: children);

  static const String name = 'ThanksWallRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ThanksWallPage();
    },
  );
}

/// generated route for
/// [TrashPage]
class TrashRoute extends PageRouteInfo<void> {
  const TrashRoute({List<PageRouteInfo>? children})
    : super(TrashRoute.name, initialChildren: children);

  static const String name = 'TrashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TrashPage();
    },
  );
}

/// generated route for
/// [UpgradePlanPage]
class UpgradePlanRoute extends PageRouteInfo<void> {
  const UpgradePlanRoute({List<PageRouteInfo>? children})
    : super(UpgradePlanRoute.name, initialChildren: children);

  static const String name = 'UpgradePlanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UpgradePlanPage();
    },
  );
}

/// generated route for
/// [WeeklyRecapPage]
class WeeklyRecapRoute extends PageRouteInfo<void> {
  const WeeklyRecapRoute({List<PageRouteInfo>? children})
    : super(WeeklyRecapRoute.name, initialChildren: children);

  static const String name = 'WeeklyRecapRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WeeklyRecapPage();
    },
  );
}

/// generated route for
/// [WelcomePage]
class WelcomeRoute extends PageRouteInfo<void> {
  const WelcomeRoute({List<PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WelcomePage();
    },
  );
}
