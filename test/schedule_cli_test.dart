import 'dart:io';

import 'package:group_schedule/src/cli/schedule_cli.dart';
import 'package:group_schedule/group_schedule.dart';
import 'package:test/test.dart';

void main() {
  group('ScheduleCli', () {
    late Directory tempDirectory;
    late ScheduleCli cli;
    late JsonScheduleStorage storage;

    setUp(() async {
      tempDirectory = await Directory.systemTemp.createTemp(
        'schedule_cli_test_',
      );

      cli = ScheduleCli(baseDirectory: tempDirectory.path);
      storage = JsonScheduleStorage(tempDirectory.path);
    });

    tearDown(() async {
      await tempDirectory.delete(recursive: true);
    });

    test('Команда help завершується успішно', () async {
      final result = await cli.run(['--help']);

      expect(result, 0);
    });

    test('Команда list читає заняття з файлу', () async {
      final lesson = Lesson.fromCsv(
        'Математика;Іваненко І.І.;Практика;'
        'Понеділок;09:30;А-101;2026-11-02',
      );

      await storage.save([lesson]);

      final result = await cli.run(['list']);

      expect(result, 0);

      final lessons = await storage.load();
      expect(lessons, hasLength(1));
    });

    test('Команда add зберігає нове заняття', () async {
      final result = await cli.run([
        '--csv',
        'Історія;Коваленко К.К.;Лекція;'
            'Четвер;11:00;А-210;2026-11-05',
        'add',
      ]);

      expect(result, 0);

      final lessons = await storage.load();
      expect(lessons, hasLength(1));
      expect(lessons.first.subject, 'Історія');
    });

    test('Команда add без CSV повертає помилку', () async {
      final result = await cli.run(['add']);

      expect(result, 1);
    });

    test('Некоректна назва файлу відхиляється', () async {
      final result = await cli.run(['--file', '../other.json', 'list']);

      expect(result, 1);
    });

    test('Невідома команда повертає помилку', () async {
      final result = await cli.run(['unknown']);

      expect(result, 1);
    });

    test('Невідома опція повертає помилку', () async {
      final result = await cli.run(['--unknown', 'list']);

      expect(result, 1);
    });

    test('Неправильне розширення файлу відхиляється', () async {
      final result = await cli.run(['--file', 'schedule.txt', 'list']);

      expect(result, 1);
    });
  });
}
