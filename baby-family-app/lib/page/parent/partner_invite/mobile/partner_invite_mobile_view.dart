import 'package:baby_family/page/parent/partner_invite/partner_invite_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// FAM-02 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class PartnerInviteMobileView extends HookConsumerWidget {
  const PartnerInviteMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(partnerInviteControllerProvider);
    return AppSkeletonScreen(
      code: 'FAM-02',
      title: context.l10n.familyInvitePartnerTitle,
    );
  }
}
