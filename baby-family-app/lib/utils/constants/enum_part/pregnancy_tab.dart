part of '../enum.dart';

/// Tab của PREG-01…04 (query `tab` của PregnancyJourneyPage).
enum PregnancyTab {
  timeline,
  bump,
  ultrasound,
  prep;

  static PregnancyTab fromName(String? name) =>
      PregnancyTab.values.where((tab) => tab.name == name).firstOrNull ??
      PregnancyTab.timeline;
}
