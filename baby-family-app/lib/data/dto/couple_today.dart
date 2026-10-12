import 'package:baby_family/data/model/us/couple_request.dart';
import 'package:baby_family/data/model/us/daily_question.dart';
import 'package:baby_family/data/model/us/mood_checkin.dart';
import 'package:baby_family/data/model/us/thanks.dart';

/// “Hôm nay của hai ta” (US-01, thẻ Papa & Mama trên HOME-01).
class CoupleToday {
  const CoupleToday({
    this.myCheckin,
    this.partnerCheckin,
    this.openRequests = const [],
    this.question,
    this.recentThanks = const [],
  });

  final MoodCheckin? myCheckin;

  /// Chỉ có khi bạn đời chia sẻ và chưa hết hiệu lực (BR-027/028).
  final MoodCheckin? partnerCheckin;
  final List<CoupleRequest> openRequests;
  final DailyQuestion? question;
  final List<Thanks> recentThanks;
}
