import 'schedule_parser.dart';

/// Повертає тільки лабораторні заняття зі списку [entries].
List<ScheduleEntry> filterLaboratoryLessons(List<ScheduleEntry> entries) {
  return entries.where((entry) => entry.lessonType == 'Лабораторна').toList();
}

/// Повертає назви дисциплін без повторень.
List<String> getUniqueSubjects(List<ScheduleEntry> entries) {
  return entries.map((entry) => entry.subject).toSet().toList();
}

/// Підраховує загальну кількість занять.
int countLessons(List<ScheduleEntry> entries) {
  return entries
      .where((entry) => entry.startMinutes >= 0)
      .map((entry) => 1)
      .fold<int>(0, (total, value) => total + value);
}

/// Групує заняття за днями тижня.
Map<String, List<ScheduleEntry>> groupByWeekday(List<ScheduleEntry> entries) {
  final groups = <String, List<ScheduleEntry>>{};

  for (final entry in entries) {
    groups.putIfAbsent(entry.weekday, () => <ScheduleEntry>[]);
    groups[entry.weekday]?.add(entry);
  }

  return groups;
}

/// Підраховує кількість занять для кожного дня тижня.
Map<String, int> countLessonsByWeekday(
  Map<String, List<ScheduleEntry>> groups,
) {
  return groups.map(
    (weekday, entries) =>
        MapEntry(weekday, entries.fold<int>(0, (count, _) => count + 1)),
  );
}

/// Сортує заняття за часом початку.
///
/// Якщо [ascending] дорівнює `true`, сортує за зростанням.
/// Якщо `false` — за спаданням.
List<ScheduleEntry> sortByStartTime(
  List<ScheduleEntry> entries, {
  bool ascending = true,
}) {
  final result = List<ScheduleEntry>.of(entries);

  result.sort((first, second) {
    final comparison = first.startMinutes.compareTo(second.startMinutes);
    return ascending ? comparison : -comparison;
  });

  return result;
}

/// Сортує заняття за назвою дисципліни.
///
/// Напрям сортування визначається параметром [ascending].
List<ScheduleEntry> sortBySubject(
  List<ScheduleEntry> entries, {
  bool ascending = true,
}) {
  final result = List<ScheduleEntry>.of(entries);

  result.sort((first, second) {
    final comparison = first.subject.compareTo(second.subject);
    return ascending ? comparison : -comparison;
  });

  return result;
}
