import 'package:group_schedule/src/models/lesson.dart';
import 'package:group_schedule/src/models/lesson_type.dart';

/// Перевіряє характеристики заняття та повертає список помилок.
List<String> validateLesson(Lesson lesson) {
  final errors = <String>[];

  if (LessonType.fromTitle(lesson.lessonType) == null) {
    errors.add('Невідомий тип заняття');
  }

  const weekdays = [
    'Понеділок',
    'Вівторок',
    'Середа',
    'Четвер',
    'П’ятниця',
    'Субота',
    'Неділя',
  ];

  final expectedWeekday = weekdays[lesson.date.weekday - 1];

  if (lesson.weekday != expectedWeekday) {
    errors.add('День тижня не відповідає даті');
  }

  const minStartMinutes = 8 * 60;
  const maxStartMinutes = 20 * 60;

  if (lesson.startMinutes < minStartMinutes ||
      lesson.startMinutes > maxStartMinutes) {
    errors.add('Час заняття поза допустимим діапазоном');
  }

  final roomPattern = RegExp(r'^[А-ЯІЇЄҐA-Z]-\d{3}$');

  if (!roomPattern.hasMatch(lesson.room)) {
    errors.add('Некоректний формат аудиторії');
  }

  return errors;
}
