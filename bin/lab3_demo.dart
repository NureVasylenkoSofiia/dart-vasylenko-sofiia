import 'package:group_schedule/async_repository.dart';
import 'package:group_schedule/src/models/lesson.dart';

Future<void> main() async {
  print('Лабораторна робота №3');
  print('Перевірка асинхронного сховища');
  print('');

  final repository = AsyncRepository<Lesson>();

  final lesson = Lesson.fromCsv(
    'Математика;Іваненко І.І.;Практика;Понеділок;09:30;А-101;2026-11-02',
  );

  print('Збереження заняття...');
  await repository.save(lesson);
  print('Заняття збережено');

  print('');
  print('Завантаження заняття...');

  final loadedLesson = await repository.load(lesson.id);
  print('Результат: $loadedLesson');

  print('');
  print('Видалення заняття...');

  final isDeleted = await repository.delete(lesson.id);
  print('Успішно видалено: $isDeleted');

  final afterDelete = await repository.load(lesson.id);
  print('Після видалення: $afterDelete');
}
