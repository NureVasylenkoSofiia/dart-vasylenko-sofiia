import 'package:group_schedule/lesson.dart';
import 'package:group_schedule/lesson_primary.dart';

void main() {
  final csvLesson = Lesson.fromCsv(
    'Математика;Іваненко І.І.;Лекція;Понеділок;09:30;А-101;2026-11-02',
  );

  final defaultLesson = Lesson.defaultLesson();

  print('Заняття з CSV: $csvLesson');
  print('Стандартне заняття: $defaultLesson');
  print('Час початку: ${csvLesson.formattedTime}');
  final primaryLesson = LessonPrimary(
    subject: 'Математика',
    teacher: 'Іваненко І.І.',
    lessonType: 'Лекція',
    weekday: 'Понеділок',
    startMinutes: 570,
    room: 'А-101',
    date: DateTime(2026, 11, 2),
  );

  print('');
  print('Заняття з первинним конструктором: $primaryLesson');
  print('Час початку: ${primaryLesson.formattedTime}');

  final lessonCopy = Lesson.fromCsv(
    'Математика;Іваненко І.І.;Лекція;Понеділок;09:30;А-101;2026-11-02',
  );

  final lessonsSet = <Lesson>{csvLesson, lessonCopy};

  print('');
  print('Чи однакові заняття: ${csvLesson == lessonCopy}');
  print('Кількість елементів у Set: ${lessonsSet.length}');
}
