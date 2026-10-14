import 'package:auto_route/auto_route.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/design_qa.dart';

/// Batch 3 — Papa & Mama (US-00, US-08…14) và Tổng kết (REC-01, REC-03),
/// CARE-11: ảnh design QA + luồng chính.
void main() {
  setUpAll(loadAppFonts);

  group('design qa', () {
    testWidgets('design qa us_00', (tester) async {
      await pumpRoute(
        tester,
        const MainShellRoute(children: [CoupleTabRoute()]),
        seed: DemoSeed.partnerLeft,
      );
      expect(find.text('Không gian này cần đủ hai người'), findsOne);
      expect(find.text('Chỉ dành cho Papa & Mama'), findsOne);
      expect(
        find.text('Nhà Lan đang ở chế độ chỉ xem & tải về'),
        findsOne,
      );
      expect(find.text('Mời bạn đời tham gia'), findsOne);
      await saveDesignShot(tester, 'us_00');
    });

    testWidgets('design qa us_08', (tester) async {
      await pumpRoute(
        tester,
        const BridgeStartRoute(),
        size: const Size(390, 900),
      );
      expect(find.text('CẦU NỐI · BƯỚC 3/5'), findsOne);
      expect(find.text('Lúc này mình cần…'), findsOne);
      expect(find.text('Chăm Haru'), findsOne);
      expect(find.text('132/500'), findsOne);
      expect(find.text('Mình cảm thấy không an toàn'), findsOne);
      await saveDesignShot(tester, 'us_08');
    });

    testWidgets('design qa us_09', (tester) async {
      await pumpRoute(
        tester,
        const BridgeRewriteRoute(),
        size: const Size(390, 1040),
      );
      expect(find.text('TRUNG TÍNH'), findsOne);
      expect(find.text('Gợi ý bởi AI'), findsOne);
      expect(find.text('Dùng câu này'), findsOne);
      await saveDesignShot(tester, 'us_09');
    });

    testWidgets('design qa us_10', (tester) async {
      await pumpRoute(
        tester,
        BridgeInviteRoute(sessionId: 'br-1'),
        size: const Size(390, 940),
      );
      expect(
        find.text('Mama muốn trò chuyện bình tĩnh khi bạn sẵn sàng'),
        findsOne,
      );
      expect(find.text('Giúp đỡ thực tế'), findsOne);
      expect(find.text('Mình chưa sẵn sàng'), findsOne);
      await saveDesignShot(tester, 'us_10');
    });

    testWidgets('design qa us_11', (tester) async {
      await pumpRoute(
        tester,
        BridgeSessionRoute(sessionId: 'br-1'),
        size: const Size(390, 920),
      );
      expect(find.text('Bắt đầu 21:10 · Thứ Tư, 07/10'), findsOne);
      expect(find.text('Bạn (Mama)'), findsOne);
      expect(find.text('Papa: Mình hiểu'), findsOne);
      expect(find.text('Bạn chưa chọn'), findsOne);
      await saveDesignShot(tester, 'us_11');
    });

    testWidgets('design qa us_12', (tester) async {
      await pumpRoute(tester, BridgeNextStepRoute(sessionId: 'br-1'));
      expect(find.text('Papa trông con 30 phút'), findsOne);
      expect(find.text('Tối nay · 21:30'), findsOne);
      expect(find.text('Nhắc lúc 21:25 — chỉ hai bạn thấy'), findsOne);
      expect(find.text('Đã đồng ý'), findsOne);
      await saveDesignShot(tester, 'us_12');
    });

    testWidgets('design qa us_12b', (tester) async {
      await pumpRoute(tester, BridgeNextStepRoute(sessionId: 'br-1'));
      await tester.tap(find.text('Xác nhận bước này'));
      await tester.pumpAndSettle();
      expect(find.text('Hai bạn muốn đóng phiên này chứ?'), findsOne);
      expect(find.text('Papa đã đồng ý đóng phiên'), findsOne);
      expect(find.text('Cảm ơn anh đã lắng nghe 💛'), findsOne);
      await saveDesignShot(tester, 'us_12b');
    });

    testWidgets('design qa us_13', (tester) async {
      await pumpRoute(
        tester,
        const SafetySupportRoute(),
        size: const Size(390, 900),
      );
      expect(find.text('Sự an toàn của bạn là quan trọng nhất'), findsOne);
      expect(find.text('113'), findsOne);
      expect(find.text('Tổng đài quốc gia bảo vệ trẻ em'), findsOne);
      expect(
        find.text('Papa không nhận thông báo nào về màn hình này.'),
        findsOne,
      );
      await saveDesignShot(tester, 'us_13');
    });

    testWidgets('design qa us_14', (tester) async {
      await pumpRoute(
        tester,
        const CoupleWeekRoute(),
        size: const Size(390, 1010),
      );
      expect(find.text('Tuần 28/09 – 04/10'), findsOne);
      expect(find.text('lời nhờ được hỗ trợ'), findsOne);
      expect(find.text('Papa · Thứ Bảy, 03/10'), findsOne);
      await saveDesignShot(tester, 'us_14');
    });

    testWidgets('design qa rec_01', (tester) async {
      await pumpRoute(
        tester,
        DayStoryRoute(childId: 'haru'),
        size: const Size(390, 1290),
      );
      expect(find.text('CÂU CHUYỆN NGÀY · THỨ TƯ, 07/10'), findsOne);
      expect(find.text('Haru · 17 tháng 29 ngày'), findsOne);
      expect(find.text('Đã chọn 3/4'), findsOne);
      expect(find.text('Nhiệm vụ đã xong · 16:15'), findsOne);
      await saveDesignShot(tester, 'rec_01');
    });

    testWidgets('design qa rec_03', (tester) async {
      await pumpRoute(
        tester,
        MonthRecapRoute(childId: 'haru'),
        size: const Size(390, 1160),
      );
      expect(find.text('Haru tròn 18 tháng 🎉'), findsOne);
      expect(find.text('Tháng thứ 18 · 08/09 – 07/10/2026'), findsOne);
      expect(find.text('17 tháng 12 ngày · 20/09'), findsOne);
      expect(find.text('07/10 · Bà ngoại ghi'), findsOne);
      await saveDesignShot(tester, 'rec_03');
    });

    testWidgets('design qa care_11', (tester) async {
      await pumpRoute(tester, const CareStatsRoute());
      expect(find.text('32'), findsOne);
      expect(find.text('Hỗ trợ nhau'), findsOne);
      expect(find.text('/ 7 ngày'), findsOne);
      await saveDesignShot(tester, 'care_11');
    });
  });

  group('flows', () {
    testWidgets('US-01 tiles open Cầu nối and Tuần của hai ta', (tester) async {
      final router = await pumpRoute(
        tester,
        const MainShellRoute(children: [CoupleTabRoute()]),
        size: const Size(390, 1400),
      );
      await tester.tap(find.text('Cầu nối'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, BridgeStartRoute.name);
      await router.maybePop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tuần của hai ta'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, CoupleWeekRoute.name);
    });

    testWidgets('US-08 unsafe → US-13, quick exit clears to Home', (
      tester,
    ) async {
      final router = await pumpRoute(
        tester,
        const BridgeStartRoute(),
        size: const Size(390, 1000),
      );
      await tester.tap(find.text('Mình cảm thấy không an toàn'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, SafetySupportRoute.name);
      await tester.tap(find.text('Thoát nhanh'));
      await tester.pumpAndSettle();
      expect(router.stack, hasLength(1));
      expect(router.topRoute.name, HomeTabRoute.name);
    });

    testWidgets('US-08 → choose share → preview → send opens US-11', (
      tester,
    ) async {
      final router = await pumpRoute(
        tester,
        const BridgeStartRoute(),
        size: const Size(390, 1200),
      );
      await tester.tap(find.text('Tiếp tục'));
      await tester.pumpAndSettle();
      expect(find.text('CẦU NỐI · BƯỚC 4/5'), findsOne);
      await tester.tap(find.text('Chọn ý để chia sẻ'));
      await tester.pumpAndSettle();
      expect(find.text('Xem trước điều Papa sẽ nhận'), findsOne);
      await tester.tap(find.text('Gửi lời mời'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, BridgeSessionRoute.name);
    });

    testWidgets('US-11 “Mình hiểu” → US-12 → close → US-01', (tester) async {
      final router = await pumpRoute(
        tester,
        BridgeSessionRoute(sessionId: 'br-1'),
        size: const Size(390, 920),
      );
      await tester.tap(find.text('Mình hiểu'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, BridgeNextStepRoute.name);
      await tester.tap(find.text('Xác nhận bước này'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Đóng phiên'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, CoupleTabRoute.name);
    });

    testWidgets('CARE ⋯ sheet opens CARE-11', (tester) async {
      final router = await pumpRoute(
        tester,
        const MainShellRoute(children: [CareTabRoute()]),
      );
      await tester.tap(find.byTooltip('Thêm'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thống kê chăm con'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, CareStatsRoute.name);
    });

    testWidgets('US-00 at 360dp, text scale 1.3 does not overflow', (
      tester,
    ) async {
      await pumpRoute(
        tester,
        const MainShellRoute(children: [CoupleTabRoute()]),
        seed: DemoSeed.partnerLeft,
        size: kNarrowSize,
        textScale: 1.3,
      );
      expect(tester.takeException(), isNull);
    });

    for (final route in <PageRouteInfo>[
      const BridgeStartRoute(),
      BridgeSessionRoute(sessionId: 'br-1'),
      BridgeNextStepRoute(sessionId: 'br-1'),
      const CareStatsRoute(),
      MonthRecapRoute(childId: 'haru'),
      DayStoryRoute(childId: 'haru'),
    ]) {
      testWidgets('${route.routeName} 360dp ×1.3 dark', (tester) async {
        await pumpRoute(
          tester,
          route,
          size: kNarrowSize,
          textScale: 1.3,
          themeMode: ThemeMode.dark,
        );
        expect(tester.takeException(), isNull);
      });
    }
  });
}
