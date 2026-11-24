import 'package:group_schedule/group_schedule.dart';
import 'package:test/test.dart';

void main() {
  group('Lesson JSON', () {
    late Lesson lesson;

    setUp(() {
      lesson = Lesson.fromCsv(
        'Математика;Іваненко І.І.;Практика;'
        'Понеділок;09:30;А-101;2026-11-02',
      );
    });

    test('Серіалізація заняття в JSON', () {
      final json = lesson.toJson();

      expect(json['subject'], 'Математика');
      expect(json['lessonType'], 'Практика');
      expect(json['startMinutes'], 570);
      expect(json['date'], '2026-11-02T00:00:00.000');
    });

    test('Відновлення заняття з JSON', () {
      final json = lesson.toJson();

      final restored = Lesson.fromJson(json);

      expect(restored, equals(lesson));
    });

    test('Помилка при відсутньому полі', () {
      final json = lesson.toJson();
      json.remove('subject');

      expect(() => Lesson.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('Помилка при неправильній даті', () {
      final json = lesson.toJson();
      json['date'] = 'invalid-date';

      expect(() => Lesson.fromJson(json), throwsA(isA<FormatException>()));
    });
  });
}
