import 'package:group_schedule/group_schedule.dart';
import 'package:test/test.dart';

void main() {
  test('Створення заняття через публічний інтерфейс пакета', () {
    final lesson = Lesson.fromCsv(
      'Математика;Іваненко І.І.;Практика;Понеділок;09:30;А-101;2026-11-02',
    );

    expect(lesson.subject, 'Математика');
    expect(lesson.formattedTime, '09:30');
    expect(lesson.room, 'А-101');
  });
}
