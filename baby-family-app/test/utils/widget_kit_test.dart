import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/gen/assets.gen.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_chip.dart';
import 'package:baby_family/utils/widget/app_choice_card.dart';
import 'package:baby_family/utils/widget/app_language_chip.dart';
import 'package:baby_family/utils/widget/app_progress_bar.dart';
import 'package:baby_family/utils/widget/app_switch.dart';
import 'package:baby_family/utils/widget/app_tab_bar.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/child_switcher.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/memory_card.dart';
import 'package:baby_family/utils/widget/memory_list_skeleton.dart';
import 'package:baby_family/utils/widget/mission_card.dart';
import 'package:baby_family/utils/widget/offline_banner.dart';
import 'package:baby_family/utils/widget/quick_create_sheet.dart';
import 'package:baby_family/utils/widget/quote_card.dart';
import 'package:baby_family/utils/widget/section_header.dart';
import 'package:baby_family/utils/widget/segmented_tabs.dart';
import 'package:baby_family/utils/widget/story_ring.dart';
import 'package:baby_family/utils/widget/underline_tabs.dart';
import 'package:baby_family/utils/widget/voice_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../helpers/design_qa.dart';

final _hana = Child(
  id: 'hana',
  familyId: 'f',
  name: 'Hana',
  birthDate: DateTime(2024, 6, 1),
  avatarAsset: 'assets/images/demo_hana.jpg',
);
final _haru = Child(
  id: 'haru',
  familyId: 'f',
  name: 'Haru',
  birthDate: DateTime(2026, 5, 1),
  colorIndex: 1,
  avatarAsset: 'assets/images/demo_haru.jpg',
);
final _bo = Child(
  id: 'bo',
  familyId: 'f',
  name: 'Bơ',
  kind: ChildKind.pregnancy,
  dueDate: DateTime(2027, 1, 24),
  colorIndex: 3,
  pregnancyOrder: 3,
);

/// Every kit widget with Pencil sample content (HOME-01, CARE-01, MEM-01…).
Widget _kitGallery() => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    const AppTopBar(step: 2, stepCount: 5),
    AppButton(label: 'Tiếp tục', onPressed: () {}),
    const SizedBox(height: 8),
    AppButton.secondary(label: 'Để sau', onPressed: () {}),
    const SizedBox(height: 8),
    AppButton.social(
      label: 'Tiếp tục với Apple',
      icon: LucideIcons.apple,
      onPressed: () {},
    ),
    const SizedBox(height: 8),
    AppButton.us(label: 'Gửi lời nhờ', onPressed: () {}),
    const SizedBox(height: 8),
    const AppTextField(label: 'Tên của bạn', hint: 'Nhập tên'),
    const SizedBox(height: 8),
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        AppChip(label: 'Bố', onTap: () {}),
        AppChip(label: 'Papa', selected: true, onTap: () {}),
        AppLanguageChip(label: 'Tiếng Việt', onTap: () {}),
        AppSwitch(value: true, onChanged: (_) {}),
        AppSwitch(value: false, onChanged: (_) {}),
      ],
    ),
    const SizedBox(height: 8),
    AppChoiceCard(
      title: 'Mama',
      description: 'Mẹ của bé — cùng Papa quản lý gia đình',
      icon: LucideIcons.heart,
      selected: true,
      onTap: () {},
    ),
    const SizedBox(height: 8),
    Row(
      children: [
        ChildSwitcher(
          children: [_hana, _haru, _bo],
          today: DateTime(2026, 10, 7),
          onChanged: (_) {},
        ),
        const SizedBox(width: 8),
        ChildAvatar(child: _bo),
        const SizedBox(width: 8),
        ChildAvatar(child: _hana.copyWith(avatarAsset: null)),
      ],
    ),
    const SizedBox(height: 8),
    const SectionHeader(title: 'Nhiệm vụ hôm nay', actionLabel: 'Xem tất cả'),
    const SizedBox(height: 8),
    SegmentedTabs(
      labels: const ['Của tôi', 'Của Papa', 'Cùng nhau'],
      counts: const ['1/4', '3/3', '0/1'],
      selectedIndex: 0,
      onChanged: (_) {},
    ),
    const SizedBox(height: 8),
    MissionCard(
      title: 'Đọc sách tranh 10 phút',
      meta: 'Gợi ý hôm nay · Gắn kết · +5 💗',
      child: _hana,
      onToggle: () {},
    ),
    const SizedBox(height: 8),
    MissionCard(
      title: 'Hát cho Haru nghe một bài',
      meta: 'Đã xong 08:40 · +5 💗',
      done: true,
      child: _haru,
      onToggle: () {},
    ),
    const SizedBox(height: 8),
    const AppCard(child: AppProgressBar(value: 0.5)),
    const SizedBox(height: 8),
    UnderlineTabs(
      labels: const ['Dòng thời gian', 'Ảnh', 'Bộ sưu tập'],
      selectedIndex: 0,
      onChanged: (_) {},
    ),
    const SizedBox(height: 8),
    Row(
      children: [
        StoryRing(
          child: _hana,
          label: 'Hana',
          subtitle: '5 ảnh',
          badgeCount: 3,
        ),
        StoryRing(child: _bo, label: 'Bơ', subtitle: 'Tuần 24'),
        StoryRing.add(label: 'Ghi lại', onTap: () {}),
      ],
    ),
    const SizedBox(height: 8),
    MemoryCard(
      photoAsset: 'assets/images/design_memoryDetailAsset.jpg',
      caption: 'Lần đầu Hana bế em Haru 🥹',
      bothTellPreview: 'Papa kể: “Anh đứng sau cầm máy mà run tay…”',
      meta: 'Hana & Haru · Mama đăng · 2 giờ trước',
      reactionEmojis: '❤️🥹',
      reactionCount: 5,
    ),
    const SizedBox(height: 8),
    QuoteCard(
      quote: 'Mẹ ơi, trăng đi theo con kìa! Trăng thích con hả mẹ?',
      meta: 'Hana · 2 tuổi 4 tháng · Papa ghi lại tối qua',
      avatar: ChildAvatar(child: _hana, size: 24),
      reactions: '😂 🥹  Bà ngoại và 2 người khác',
    ),
    const SizedBox(height: 8),
    const VoiceCard(
      title: 'Tiếng cười giòn tan khi Papa thổi bụng',
      duration: '0:12',
    ),
    const SizedBox(height: 8),
    const OfflineBanner(pendingUploads: 2),
  ],
);

void main() {
  setUpAll(loadAppFonts);

  for (final size in [kDesignSize, kNarrowSize]) {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      testWidgets('kit renders at ${size.width} ${mode.name} ×1.3', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          _kitGallery(),
          size: size,
          themeMode: mode,
          textScale: 1.3,
        );
        expect(tester.takeException(), isNull);
        expect(find.text('Đọc sách tranh 10 phút'), findsOneWidget);
      });
    }
  }

  testWidgets('states render (STATE-01/02/04)', (tester) async {
    await pumpScreen(
      tester,
      Column(
        children: [
          EmptyState(
            illustration: Assets.images.zn57N.path,
            title: 'Chưa có ký ức nào của Haru',
            description: 'Lưu khoảnh khắc đầu tiên nhé',
            actionLabel: 'Thêm ký ức',
            onAction: () {},
          ),
          ErrorState(onRetry: () {}, code: 'Mã lỗi: MEM-500'),
          const SizedBox(height: 900, child: MemoryListSkeleton()),
        ],
      ),
      size: kNarrowSize,
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
  });

  testWidgets('tab bar active colours', (tester) async {
    var tapped = MainTab.home;
    await pumpScreen(
      tester,
      AppTabBar(
        current: MainTab.us,
        onSelected: (tab) => tapped = tab,
        onCreate: () {},
      ),
    );
    await tester.tap(find.text('Ký ức'));
    expect(tapped, MainTab.memories);
  });

  testWidgets('SW-01 sheet lists Cả nhà + children with ages', (tester) async {
    String? picked = 'x';
    await pumpScreen(
      tester,
      ChildSwitcher(
        children: [_hana, _haru, _bo],
        today: DateTime(2026, 10, 7),
        onChanged: (id) => picked = id,
        onManage: () {},
      ),
    );
    await tester.tap(find.byType(ChildSwitcher));
    await tester.pumpAndSettle();
    expect(find.text('Xem theo'), findsOneWidget);
    expect(find.text('2 tuổi 4 tháng'), findsOneWidget);
    expect(find.text('5 tháng 6 ngày'), findsOneWidget);
    expect(find.text('Thai #3 · Bơ'), findsOneWidget);
    expect(find.text('Tuần 24 + 3 ngày'), findsOneWidget);
    expect(find.text('Quản lý các con'), findsOneWidget);
    await tester.tap(find.text('Haru'));
    await tester.pumpAndSettle();
    expect(picked, 'haru');
  });

  group('design qa', () {
    testWidgets('kit gallery', (tester) async {
      await pumpScreen(tester, _kitGallery(), size: const Size(390, 2400));
      await saveDesignShot(tester, 'kit_gallery');
    });

    testWidgets('tab bar (luKhc)', (tester) async {
      await pumpScreen(
        tester,
        Align(
          alignment: Alignment.bottomCenter,
          child: AppTabBar(
            current: MainTab.home,
            onSelected: (_) {},
            onCreate: () {},
          ),
        ),
        size: const Size(390, 120),
        wrapInScaffold: false,
      );
      await saveDesignShot(tester, 'kit_tab_bar');
    });

    testWidgets('QC-01 sheet (IWfKB)', (tester) async {
      await pumpScreen(
        tester,
        Builder(
          builder: (context) => Center(
            child: TextButton(
              onPressed: () => showQuickCreateSheet(context),
              child: const Text('open'),
            ),
          ),
        ),
        wrapInScaffold: false,
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await saveDesignShot(tester, 'kit_quick_create');
    });

    testWidgets('bottom sheet frame', (tester) async {
      await pumpScreen(
        tester,
        const Align(
          alignment: Alignment.bottomCenter,
          child: AppBottomSheet(title: 'Xem theo', children: [Text('…')]),
        ),
        wrapInScaffold: false,
      );
      await saveDesignShot(tester, 'kit_bottom_sheet');
    });
  });
}
