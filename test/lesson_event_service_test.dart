import 'package:group_schedule/lesson_event_service.dart';
import 'package:test/test.dart';

void main() {
  group('LessonEventService', () {
    late LessonEventService service;

    setUp(() {
      service = LessonEventService();
    });

    test('Буферизація подій до підписки', () async {
      service.addEvent('Додано', 'Математика');
      service.addEvent('Змінено', 'Програмування Dart');
      service.addEvent('Видалено', 'Бази даних');

      final verification = expectLater(
        service.events.map((event) => event.toString()),
        emitsInOrder([
          'Додано: Математика',
          'Змінено: Програмування Dart',
          'Видалено: Бази даних',
          emitsDone,
        ]),
      );

      await service.close();
      await verification;
    });

    test('Обробка помилки та наступної події потоку', () async {
      final verification = expectLater(
        service.events.map((event) => event.toString()),
        emitsInOrder([
          'Додано: Математика',
          emitsError(isA<StateError>()),
          'Змінено: Програмування Dart',
          emitsDone,
        ]),
      );

      service.addEvent('Додано', 'Математика');

      service.addError(StateError('Помилка оновлення розкладу'));

      service.addEvent('Змінено', 'Програмування Dart');

      await service.close();
      await verification;
    });
  });
}
