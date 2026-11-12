import 'package:group_schedule/lesson.dart';

void main() {
  final csvLesson = Lesson.fromCsv(
    'Математика;Іваненко І.І.;Лекція;Понеділок;09:30;А-101;2026-11-02',
  );

  final defaultLesson = Lesson.defaultLesson();

  print('Заняття з CSV: $csvLesson');
  print('Стандартне заняття: $defaultLesson');
  print('Час початку: ${csvLesson.formattedTime}');
}
