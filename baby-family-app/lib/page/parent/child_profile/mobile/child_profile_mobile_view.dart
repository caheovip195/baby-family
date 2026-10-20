import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/child/child_profile.dart';
import 'package:baby_family/page/parent/child_profile/child_profile_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/lunar_date.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/relative_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_setting_row.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/profile_body.dart';
part '../widgets/profile_header.dart';
part '../widgets/profile_relatives_row.dart';
part '../widgets/profile_stat_tile.dart';

/// CHD-01 “Hồ sơ bé” (Pencil `AR7Mw`).
class ChildProfileMobileView extends HookConsumerWidget {
  const ChildProfileMobileView({required this.childId, super.key});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(childProfileControllerProvider);
    useEffect(() {
      controller.init(childId);
      return null;
    }, [childId]);
    final child = controller.child;
    final profile = controller.profile;
    if (!controller.loaded || child == null || profile == null) {
      return BaseScaffold(
        body: Center(
          child: controller.hasError
              ? ErrorState(onRetry: controller.load)
              : const CircleLoadingProgress(),
        ),
      );
    }

    Future<void> edit() async {
      await context.router.push(ChildEditRoute(childId: child.id));
      await controller.load();
    }

    /// “Lưu trữ hồ sơ bé” → CHD-05 (tác động, lưu trữ, xoá vĩnh viễn sau 7 ngày).
    Future<void> archive() async {
      await context.router.push(ChildArchiveRoute(childId: child.id));
      await controller.load();
    }

    return BaseScaffold(
      body: ListView(
        padding: EdgeInsets.only(
          bottom: 28 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          _ProfileHeader(child: child, onEdit: edit),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.s1,
              AppSpacing.screen,
              0,
            ),
            child: _ProfileBody(
              child: child,
              profile: profile,
              today: controller.today,
              onArchive: archive,
            ),
          ),
        ],
      ),
    );
  }
}
