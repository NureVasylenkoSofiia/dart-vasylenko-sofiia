import 'package:group_schedule/lesson.dart';
import 'package:group_schedule/lesson_parsing.dart';
import 'package:group_schedule/lesson_validator.dart';

/// Розбирає та перевіряє список текстових записів розкладу.
///
/// Повертає коректні заняття та повідомлення про помилки.
({List<Lesson> lessons, List<String> errors}) parseSchedule(
  List<String> lines,
) {
  final lessons = <Lesson>[];
  final errors = <String>[];

  for (var i = 0; i < lines.length; i++) {
    final (lesson: lesson, error: error) = parseLesson(lines[i]);

    if (lesson == null) {
      errors.add('Запис ${i + 1}: ${error ?? 'Невідома помилка'}');
      continue;
    }

    final validationErrors = validateLesson(lesson);

    if (validationErrors.isNotEmpty) {
      for (final validationError in validationErrors) {
        errors.add('Запис ${i + 1}: $validationError');
      }
      continue;
    }

    lessons.add(lesson);
  }

  return (lessons: lessons, errors: errors);
}
