import 'package:baby_family/data/model/care/mission.dart';

/// Bảng nhiệm vụ một ngày nhìn từ người đang đăng nhập (CARE-01, HOME-01).
/// Nhiệm vụ của bạn đời không có `hearts` (BR-018).
class CareBoard {
  const CareBoard({
    required this.date,
    this.mine = const [],
    this.partner = const [],
    this.together = const [],
    this.heartsToday = 0,
    this.swapsLeft = 0,
  });

  final DateTime date;
  final List<Mission> mine;
  final List<Mission> partner;
  final List<Mission> together;

  /// Hearts của tôi hôm nay — chỉ hiển thị ở tab Của tôi.
  final int heartsToday;
  final int swapsLeft;

  List<Mission> get all => [...mine, ...partner, ...together];

  int get doneCount => all.where((mission) => mission.isDone).length;

  int get totalCount => all.length;

  bool get isEmpty => all.isEmpty;
}
