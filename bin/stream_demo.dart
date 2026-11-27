import 'package:group_schedule/async_repository.dart';
import 'package:group_schedule/src/models/lesson.dart';

Future<void> main() async {
  print('Лабораторна робота №3');
  print('Перевірка Stream та async*');
  print('');

  final repository = AsyncRepository<Lesson>(
    delay: const Duration(milliseconds: 100),
  );

  final lessons = [
    Lesson.fromCsv(
      'Математика;Іваненко І.І.;Практика;Понеділок;09:30;А-101;2026-11-02',
    ),
    Lesson.fromCsv(
      'Програмування Dart;Петренко П.П.;Лекція;Вівторок;10:45;Б-202;2026-11-03',
    ),
    Lesson.fromCsv(
      'Бази даних;Сидоренко С.С.;Лабораторна;Середа;12:30;А-305;2026-11-04',
    ),
  ];

  for (final lesson in lessons) {
    await repository.save(lesson);
  }

  print('Збережено ${lessons.length} заняття');
  print('');

  print('Створюємо Stream...');
  final stream = repository.watchAll();

  print('Stream створено, але підписки ще немає');
  print('Тіло генератора поки не виконувалося');
  print('');

  print('Починаємо читання через await for:');

  var count = 0;

  await for (final lesson in stream) {
    count++;
    print('Отримано заняття $count: ${lesson.subject}');
  }

  print('');
  print('Усього отримано занять: $count');
}
