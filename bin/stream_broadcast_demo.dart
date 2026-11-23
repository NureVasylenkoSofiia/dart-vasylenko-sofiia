import 'dart:async';

import 'package:group_schedule/lesson_event_service.dart';

Future<void> main() async {
  print('Порівняння single-subscription та broadcast Stream');
  print('');

  // 1. Потік з одноразовою підпискою.
  final singleController = StreamController<LessonEvent>();

  final firstSubscription = singleController.stream.listen((event) {
    print('Перший слухач: $event');
  });

  try {
    final secondSubscription = singleController.stream.listen((event) {
      print('Другий слухач: $event');
    });

    await secondSubscription.cancel();
  } catch (error) {
    print('Помилка повторної підписки: $error');
  }

  singleController.add(const LessonEvent('Додано', 'Математика'));

  await Future<void>.delayed(const Duration(milliseconds: 50));

  await firstSubscription.cancel();
  await singleController.close();

  print('');
  print('2. Широкомовний потік');

  final broadcastController = StreamController<LessonEvent>.broadcast();

  final firstListener = broadcastController.stream.listen((event) {
    print('Слухач 1: $event');
  });

  final secondListener = broadcastController.stream.listen((event) {
    print('Слухач 2: $event');
  });

  broadcastController.add(const LessonEvent('Змінено', 'Програмування Dart'));

  await Future<void>.delayed(const Duration(milliseconds: 50));

  await firstListener.cancel();
  await secondListener.cancel();
  await broadcastController.close();

  print('Обидві підписки скасовано');
}
