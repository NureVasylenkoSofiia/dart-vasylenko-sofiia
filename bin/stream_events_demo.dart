import 'dart:async';

import 'package:group_schedule/lesson_event_service.dart';

Future<void> main() async {
  print('Перевірка StreamController');
  print('');

  final service = LessonEventService();

  print('Додаємо три події до підписки:');

  service.addEvent('Додано', 'Математика');
  service.addEvent('Змінено', 'Програмування Dart');
  service.addEvent('Видалено', 'Бази даних');

  print('Події додано');
  print('');

  print('Підписуємося через listen():');

  final subscription = service.events.listen((event) {
    print('Отримано подію: $event');
  });

  await Future<void>.delayed(const Duration(milliseconds: 100));

  print('');
  print('Скасовуємо підписку');

  await subscription.cancel();
  await service.close();

  print('Підписку скасовано, контролер закрито');
}
