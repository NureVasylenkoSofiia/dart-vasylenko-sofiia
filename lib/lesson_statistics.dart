import 'package:group_schedule/src/models/lesson.dart';

/// Повертає лабораторні заняття.
List<Lesson> filterLaboratoryLessons(List<Lesson> lessons) {
  return lessons.where((lesson) => lesson.lessonType == 'Лабораторна').toList();
}

/// Повертає унікальні назви дисциплін.
Set<String> getUniqueSubjects(List<Lesson> lessons) {
  return lessons.map((lesson) => lesson.subject).toSet();
}

/// Підраховує кількість занять через fold.
int countLessons(List<Lesson> lessons) {
  return lessons
      .where((lesson) => lesson.subject.isNotEmpty)
      .map((lesson) => 1)
      .fold(0, (sum, value) => sum + value);
}

/// Групує заняття за днями тижня.
Map<String, List<Lesson>> groupLessonsByWeekday(List<Lesson> lessons) {
  final groups = <String, List<Lesson>>{};

  for (final lesson in lessons) {
    groups.putIfAbsent(lesson.weekday, () => []).add(lesson);
  }

  return groups;
}

/// Підраховує кількість занять для кожного дня тижня.
Map<String, int> countLessonsByWeekday(List<Lesson> lessons) {
  final groups = groupLessonsByWeekday(lessons);

  return groups.map(
    (day, items) => MapEntry(day, items.fold(0, (count, _) => count + 1)),
  );
}

/// Сортує заняття за часом початку.
List<Lesson> sortLessonsByTime(List<Lesson> lessons, {bool ascending = true}) {
  final result = List<Lesson>.from(lessons);

  result.sort(
    (a, b) => ascending
        ? a.startMinutes.compareTo(b.startMinutes)
        : b.startMinutes.compareTo(a.startMinutes),
  );

  return result;
}

/// Сортує заняття за назвою дисципліни.
List<Lesson> sortLessonsBySubject(
  List<Lesson> lessons, {
  bool ascending = true,
}) {
  final result = List<Lesson>.from(lessons);

  result.sort(
    (a, b) => ascending
        ? a.subject.compareTo(b.subject)
        : b.subject.compareTo(a.subject),
  );

  return result;
}
