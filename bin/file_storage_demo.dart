import 'dart:io';

import 'package:group_schedule/group_schedule.dart';

Future<void> main() async {
  print('Перевірка файлового сховища JSON');
  print('');

  final storage = JsonScheduleStorage(Directory.current.path);

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

  print('Зберігаємо ${lessons.length} заняття...');

  await storage.save(lessons);

  print('Файл створено: ${storage.filePath}');
  print('');

  final loadedLessons = await storage.load();

  print('Завантажено занять: ${loadedLessons.length}');

  for (final lesson in loadedLessons) {
    print(lesson);
  }

  print('');
  print('Дані збігаються: ${lessons.toString() == loadedLessons.toString()}');
}
