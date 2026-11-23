import 'package:group_schedule/async_repository.dart';
import 'package:group_schedule/src/models/lesson.dart';
import 'package:test/test.dart';

void main() {
  group('AsyncRepository', () {
    late AsyncRepository<Lesson> repository;
    late Lesson lesson;

    setUp(() {
      repository = AsyncRepository<Lesson>(
        delay: const Duration(milliseconds: 1),
      );

      lesson = Lesson.fromCsv(
        'Математика;Іваненко І.І.;Практика;Понеділок;09:30;А-101;2026-11-02',
      );
    });

    test('Збереження та завантаження заняття', () async {
      await repository.save(lesson);

      final result = await repository.load(lesson.id);

      expect(result, equals(lesson));
    });

    test('Завантаження неіснуючого заняття', () async {
      final result = await repository.load('missing-id');

      expect(result, isNull);
    });

    test('Повторне збереження заняття', () async {
      await repository.save(lesson);
      await repository.save(lesson);

      final lessons = await repository.watchAll().toList();

      expect(lessons, hasLength(1));
    });

    test('Видалення заняття', () async {
      await repository.save(lesson);

      final deleted = await repository.delete(lesson.id);
      final result = await repository.load(lesson.id);

      expect(deleted, isTrue);
      expect(result, isNull);
    });

    test('Видалення неіснуючого заняття', () async {
      final deleted = await repository.delete('missing-id');

      expect(deleted, isFalse);
    });

    test('Порядок надходження занять у потоці', () async {
      final secondLesson = Lesson.fromCsv(
        'Бази даних;Петренко П.П.;Лекція;Вівторок;10:45;Б-202;2026-11-03',
      );

      await repository.save(lesson);
      await repository.save(secondLesson);

      await expectLater(
        repository.watchAll(),
        emitsInOrder([lesson, secondLesson, emitsDone]),
      );
    });
  });
}
