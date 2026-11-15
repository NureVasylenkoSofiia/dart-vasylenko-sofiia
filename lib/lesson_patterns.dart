import 'package:group_schedule/lesson.dart';

/// Визначає рекомендацію за характеристиками заняття.
String getLessonNotice(Lesson lesson) {
  return switch (lesson) {
    Lesson(lessonType: 'Лабораторна', startMinutes: final time)
        when time < 600 =>
      'Рання лабораторна: варто прийти заздалегідь',

    Lesson(lessonType: 'Лабораторна') =>
      'Не забудьте підготуватися до лабораторної',

    Lesson(startMinutes: final time) when time >= 1080 => 'Пізнє заняття',

    _ => 'Заняття за звичайним розкладом',
  };
}
