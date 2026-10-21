part of '../mobile/memory_composer_mobile_view.dart';

/// Khối ghi âm (loại Ghi âm — tài liệu 9.4 MEM-04 “Ghi âm”): nền
/// `secondary-100` bo 16 như VoiceCard; nút mic tròn 64 `secondary-500`;
/// trạng thái 13/700 `secondary-700`. Bấm để ghi, bấm lần nữa để dừng; bản
/// mẫu (không server) “ghi” đoạn 0:12.
class _VoiceRecorder extends StatelessWidget {
  const _VoiceRecorder({required this.controller});

  final MemoryComposerController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final seconds = controller.voiceDurationSec;
    final strong = AppColors.resolve(context, kColorSecondary7003F7A5C);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSecondary100E4F2EA),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Semantics(
            button: true,
            label: l10n.memVoiceTapToRecord,
            excludeSemantics: true,
            child: InkResponse(
              onTap: controller.toggleVoice,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.resolve(context, kColorSecondary5006FAE8E),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.recording
                      ? LucideIcons.square
                      : seconds == null
                      ? LucideIcons.mic
                      : LucideIcons.check,
                  size: 28,
                  color: AppColors.onPrimary(context),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
          Text(
            controller.recording
                ? l10n.memVoiceRecording
                : controller.micDenied
                ? l10n.memVoiceMicDenied
                : seconds == null
                ? l10n.memVoiceTapToRecord
                : l10n.memVoiceRecorded(memoryDuration(seconds)),
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: strong,
            ),
          ),
        ],
      ),
    );
  }
}
