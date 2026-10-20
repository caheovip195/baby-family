import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/dto/birth_draft.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/page/parent/birth/birth_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_chip.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/announce_card.dart';
part '../widgets/birth_count_step.dart';
part '../widgets/birth_info_step.dart';
part '../widgets/birth_welcome_step.dart';
part '../widgets/first_photo_picker.dart';
part '../widgets/welcome_card.dart';

/// PREG-05 — luồng nhiều bước: B1 số bé (không có trong Pencil), B2 thông tin
/// bé (wpICu), B3–B4 thẻ chào mừng & báo tin (wQZI7), B5 → Trang chủ với bé
/// mới được chọn.
class BirthMobileView extends HookConsumerWidget {
  const BirthMobileView({required this.pregnancyId, super.key});

  final String pregnancyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(birthControllerProvider);
    useEffect(() {
      Future.microtask(() => controller.init(pregnancyId));
      return null;
    }, [pregnancyId]);
    final welcome = controller.step == 3;
    return BaseScaffold(
      backgroundColor: welcome ? kColorUs50F6F2FC : null,
      canPop: controller.step == 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          controller.back();
        }
      },
      appBar: welcome || !controller.isLoaded
          ? null
          : AppTopBar(
              step: controller.step,
              stepCount: BirthController.stepCount,
              onBack: () {
                if (!controller.back()) {
                  context.router.maybePop();
                }
              },
            ),
      body: SafeArea(child: _body(context, ref, controller)),
    );
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    BirthController controller,
  ) {
    if (!controller.isLoaded) {
      return Center(
        child: controller.hasError
            ? ErrorState(onRetry: controller.load)
            : const CircleLoadingProgress(),
      );
    }
    return switch (controller.step) {
      1 => _BirthCountStep(controller: controller),
      2 => _BirthInfoStep(
        key: ValueKey(controller.babyIndex),
        controller: controller,
      ),
      _ => _BirthWelcomeStep(
        controller: controller,
        onDone: () => _complete(context, ref, controller),
      ),
    };
  }

  Future<void> _complete(
    BuildContext context,
    WidgetRef ref,
    BirthController controller,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = context.l10n.pregnancyBirthComplete;
    final router = context.router;
    final id = await controller.complete(ref.read(todayProvider));
    if (id == null || !context.mounted) {
      return;
    }
    await router.replaceAll([
      const MainShellRoute(children: [HomeTabRoute()]),
    ]);
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

/// `dd/MM/yyyy` → ngày; sai định dạng → null.
DateTime? _parseDate(String text) {
  final parts = text.trim().split(RegExp(r'[/.\-]'));
  if (parts.length != 3) {
    return null;
  }
  final day = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final year = int.tryParse(parts[2]);
  if (day == null || month == null || year == null) {
    return null;
  }
  return DateTime(year, month, day);
}

/// “3,2 kg” → 3.2; không có số → null.
double? _parseMeasure(String text) {
  final match = RegExp(r'\d+(?:[.,]\d+)?').firstMatch(text);
  return match == null
      ? null
      : double.tryParse(match.group(0)!.replaceAll(',', '.'));
}

String _formatMeasure(BuildContext context, double value) =>
    NumberFormat.decimalPattern(context.localeName).format(value);
