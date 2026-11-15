import 'package:group_schedule/lesson.dart';

/// Розбирає текстовий запис і повертає заняття та опис помилки.
({Lesson? lesson, String? error}) parseLesson(String line) {
  try {
    final lesson = Lesson.fromCsv(line);
    return (lesson: lesson, error: null);
  } on FormatException catch (error) {
    return (lesson: null, error: error.message);
  }
}
