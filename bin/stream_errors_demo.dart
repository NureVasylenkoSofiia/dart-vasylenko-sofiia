import 'dart:async';

import 'package:group_schedule/lesson_event_service.dart';

Stream<LessonEvent> createEventStream() {
  final controller = StreamController<LessonEvent>();

  controller.add(const LessonEvent('Додано', 'Математика'));

  controller.addError(StateError('Помилка оновлення розкладу'));

  controller.add(const LessonEvent('Змінено', 'Програмування Dart'));

  unawaited(controller.close());

  return controller.stream;
}

Future<void> main() async {
  print('Перевірка помилок у Stream');
  print('');

  print('1. Обробка через await for');

  try {
    await for (final event in createEventStream()) {
      print('Отримано: $event');
    }
  } catch (error) {
    print('Перехоплено помилку: $error');
  }

  print('');
  print('2. Обробка через listen()');

  final completed = Completer<void>();

  final subscription = createEventStream().listen(
    (event) {
      print('Отримано: $event');
    },
    onError: (Object error) {
      print('Помилка в listen(): $error');
    },
    onDone: () {
      print('Потік завершено');
      completed.complete();
    },
    cancelOnError: false,
  );

  try {
    await completed.future;
  } finally {
    await subscription.cancel();
    print('Підписку скасовано');
  }
}
