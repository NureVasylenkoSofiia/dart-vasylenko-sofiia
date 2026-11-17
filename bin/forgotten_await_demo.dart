import 'dart:async';

import 'package:group_schedule/async_repository.dart';
import 'package:group_schedule/lesson.dart';

Future<void> main() async {
  final repository = AsyncRepository<Lesson>(
    delay: const Duration(milliseconds: 500),
  );

  final lesson = Lesson.fromCsv(
    'Математика;Іваненко І.І.;Практика;Понеділок;09:30;А-101;2026-11-02',
  );

  print('Початок збереження');

  // Навмисно не використовуємо await.
  final saveFuture = repository.save(lesson);

  print('Програма продовжила виконання без очікування save()');

  // Чекаємо коротше, ніж триває збереження.
  await Future<void>.delayed(const Duration(milliseconds: 100));

  final loadedBefore = await repository.load(lesson.id);
  print('Результат першого завантаження: $loadedBefore');

  await saveFuture;

  final loadedAfter = await repository.load(lesson.id);
  print('Результат після очікування: $loadedAfter');
  await repository.load('missing-id');
}
