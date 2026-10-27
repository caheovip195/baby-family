import 'package:baby_family/data/dto/mission_completion.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Kết quả CARE-06: hoàn tác, hoặc xong (kèm ghi chú / ảnh tuỳ chọn).
typedef MissionCompletionChoice = ({bool undo, String note, bool hasPhoto});

/// CARE-06 “Hoàn thành nhiệm vụ” (Pencil `b75gi7`): vòng tròn 72
/// `secondary-500` + `check` 36, “Tuyệt vời! +5 💗 cho cây” 22/800, mô tả 14,
/// khối “Lưu lại khoảnh khắc này?” (nền `primary-50` bo 20), nút “Xong”,
/// “Hoàn tác”. Dùng ở CARE-01 và CARE-02.
class MissionCompletionSheet extends HookWidget {
  const MissionCompletionSheet({
    required this.hearts,
    required this.title,
    this.pendingSync = false,
    super.key,
  });

  final int hearts;
  final String title;

  /// Xong khi mất mạng: chưa biết Hearts, chưa lưu được khoảnh khắc.
  final bool pendingSync;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final note = useTextEditingController();
    final hasPhoto = useState(false);
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    void close({bool undo = false}) => Navigator.of(
      context,
    ).pop((undo: undo, note: note.text.trim(), hasPhoto: hasPhoto.value));

    Widget photoButton(IconData icon, String label) => Expanded(
      child: Material(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(
            color: AppColors.resolve(
              context,
              hasPhoto.value ? kColorPrimary500EE7B67 : kColorBorderEADFD6,
            ),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => hasPhoto.value = !hasPhoto.value,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSpacing.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: AppColors.resolve(context, kColorPrimary600C2513F),
                ),
                const SizedBox(width: AppSpacing.s2),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.text14.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return AppBottomSheet(
      gap: 18,
      children: [
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSecondary5006FAE8E),
              shape: BoxShape.circle,
              boxShadow: AppShadows.success,
            ),
            child: Icon(
              LucideIcons.check,
              size: 36,
              color: AppColors.onPrimary(context),
            ),
          ),
        ),
        Column(
          children: [
            Text(
              pendingSync
                  ? l10n.careCompletePendingSync
                  : l10n.careCompleteHearts(hearts),
              textAlign: TextAlign.center,
              style: AppTypography.adapt(
                context,
                AppTypography.h2.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: AppSpacing.compact),
            Text(
              l10n.careCompleteDesc(title, kValueMissionPhotoHearts),
              textAlign: TextAlign.center,
              style: AppTypography.adapt(
                context,
                AppTypography.text14.copyWith(color: kColorTextSecondary6B625B),
              ),
            ),
          ],
        ),
        // Lưu khoảnh khắc cần mạng (tải ảnh, server cộng Hearts).
        if (!pendingSync)
          Container(
            padding: const EdgeInsets.all(AppSpacing.s4),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorPrimary50FFF4F1),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  hasPhoto.value
                      ? l10n.carePhotoSelected
                      : l10n.careSaveMemoryQuestion,
                  style: AppTypography.adapt(context, AppTypography.title16),
                ),
                const SizedBox(height: AppSpacing.s3),
                Row(
                  children: [
                    photoButton(LucideIcons.camera, l10n.careCamera),
                    const SizedBox(width: AppSpacing.itemGap),
                    photoButton(LucideIcons.images, l10n.careGallery),
                  ],
                ),
                const SizedBox(height: AppSpacing.s3),
                Container(
                  constraints: const BoxConstraints(minHeight: 44),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.cardInset,
                  ),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: TextField(
                    controller: note,
                    style: AppTypography.adapt(context, AppTypography.text14),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: l10n.careNoteHint,
                      hintStyle: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          color: kColorTextTertiary9C928A,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        AppButton(label: l10n.careFinish, onPressed: close),
        Center(
          child: TextButton.icon(
            onPressed: () => close(undo: true),
            style: TextButton.styleFrom(foregroundColor: secondary),
            icon: const Icon(LucideIcons.undo2, size: 16),
            label: Text(
              l10n.careUndo,
              style: AppTypography.text14.copyWith(
                fontWeight: FontWeight.w600,
                color: secondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Luồng hoàn thành (mục 7.13.4): CARE-06 → hoàn tác ngay, hoặc (Xong) lưu
/// khoảnh khắc nếu có ghi chú/ảnh rồi hiện snackbar “Hoàn tác” trong phần còn
/// lại của `kValueMissionUndoWindow`.
Future<void> runMissionCompletionFlow(
  BuildContext context, {
  required MissionCompletion completion,
  required DateTime now,
  required Future<void> Function() onUndo,
  required Future<void> Function(String note) onSaveMoment,
}) async {
  final title = completion.mission.title;
  final result = await showAppBottomSheet<MissionCompletionChoice>(
    context,
    strongScrim: true,
    builder: (_) => MissionCompletionSheet(
      hearts: completion.heartsEarned,
      title: title,
      pendingSync: completion.pendingSync,
    ),
  );
  if (result?.undo ?? false) {
    await onUndo();
    return;
  }
  if (result != null && (result.note.isNotEmpty || result.hasPhoto)) {
    await onSaveMoment(result.note);
  }
  if (!context.mounted) {
    return;
  }
  final remaining = completion.undoUntil.difference(now);
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(context.l10n.careDoneSnack(title)),
        duration: remaining.isNegative || remaining == Duration.zero
            ? kValueMissionUndoWindow
            : remaining,
        action: SnackBarAction(label: context.l10n.careUndo, onPressed: onUndo),
      ),
    );
}
