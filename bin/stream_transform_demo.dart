import 'package:group_schedule/lesson_event_service.dart';

Stream<LessonEvent> createScheduleEvents() async* {
  yield const LessonEvent('Додано', 'Математика');
  yield const LessonEvent('Змінено', 'Програмування Dart');
  yield const LessonEvent('Додано', 'Бази даних');
  yield const LessonEvent('Видалено', 'Англійська мова');
  yield const LessonEvent('Додано', 'Комп’ютерні мережі');
  yield const LessonEvent('Додано', 'Програмування Dart');
}

Future<void> main() async {
  print('Конвеєр трансформації Stream');
  print('');

  final transformedStream = createScheduleEvents()
      .where((event) => event.action == 'Додано')
      .map((event) => 'Нове заняття: ${event.subject}')
      .take(2);

  print('Результати після where, map і take:');

  await for (final message in transformedStream) {
    print(message);
  }

  print('');
  print('Обробку перших двох подій завершено');
}
