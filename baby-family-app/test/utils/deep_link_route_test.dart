import 'package:baby_family/utils/router/deep_link_route.dart';
import 'package:flutter_test/flutter_test.dart';

/// BF-20261030-005: deep link của thông báo → route theo vai trò.
void main() {
  test('Parents open memories, Papa & Mama, recaps and the family', () {
    String? parent(String link) => routeForDeepLink(link, circle: false);
    expect(parent('babyfamily://memories/m-1'), '/memory/m-1');
    expect(parent('babyfamily://us'), '/main/us');
    expect(parent('babyfamily://recaps/weekly'), '/recap/week');
    expect(parent('babyfamily://family/circle'), '/family');
    expect(parent('babyfamily://calendar/events/e-1'), '/calendar');
    expect(parent('babyfamily://families/f-1/billing'), '/billing/plan');
    expect(parent('babyfamily://families/f-1'), isNull);
    expect(parent('babyfamily://memories'), isNull);
    expect(parent('https://evil.example/memories/1'), isNull);
    expect(parent('babyfamily://unknown'), isNull);
  });

  test('relatives never land on Parent-only screens', () {
    String? circle(String link) => routeForDeepLink(link, circle: true);
    expect(circle('babyfamily://memories/m-1'), '/circle/memory/m-1');
    expect(circle('babyfamily://year-books'), '/circle/year-books');
    expect(circle('babyfamily://recaps/weekly?x=1'), '/recap/week');
    expect(circle('babyfamily://us'), isNull);
    expect(circle('babyfamily://family/circle'), isNull);
    expect(circle('babyfamily://calendar/events/e-1'), isNull);
    expect(circle('babyfamily://families/f-1/billing'), isNull);
  });
}
