part of '../mobile/birth_mobile_view.dart';

/// B3–B4 (Pencil wQZI7): nền `us-50`, đệm 16/20/24/20, cách 16 — thẻ chào
/// mừng, thẻ báo tin cho người thân, nút `us-700` “Hoàn tất & báo tin 🎉”.
class _BirthWelcomeStep extends StatelessWidget {
  const _BirthWelcomeStep({required this.controller, required this.onDone});

  final BirthController controller;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s4,
        AppSpacing.screen,
        AppSpacing.s6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _WelcomeCard(
                    baby: controller.firstBaby,
                    familyName: controller.family?.name,
                    siblings: controller.siblings,
                  ),
                  if (controller.relatives.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.s4),
                    _AnnounceCard(
                      relatives: controller.relatives,
                      selected: controller.announceTo,
                      childName:
                          controller.firstBaby.nickname ??
                          controller.pregnancy?.name ??
                          '',
                      onToggle: controller.toggleAnnounce,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.s4),
                ],
              ),
            ),
          ),
          AppButton.us(
            label: context.l10n.pregBirthDone,
            isLoading: controller.isLoading,
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}
