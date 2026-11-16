import 'package:group_schedule/lesson.dart';
import 'package:group_schedule/lesson_statistics.dart';
import 'package:group_schedule/schedule_extensions.dart';

/// Формує текстовий звіт за списком занять.
String buildLessonReport(
  List<Lesson> lessons, {
  int topCount = 5,
  bool ascending = true,
  String separator = ' | ',
}) {
  final buffer = StringBuffer();

  buffer.writeln('Звіт про розклад занять');
  buffer.writeln('Усього занять: ${lessons.length}');
  buffer.writeln();

  final sortedLessons = sortLessonsByTime(lessons, ascending: ascending);

  final selectedLessons = sortedLessons.take(topCount < 0 ? 0 : topCount);

  for (final lesson in selectedLessons) {
    buffer.writeln(
      [
        lesson.subject,
        lesson.lessonType,
        lesson.weekday,
        lesson.formattedTime,
        lesson.room,
        lesson.date.toScheduleFormat(),
      ].join(separator),
    );
  }

  return buffer.toString();
}
