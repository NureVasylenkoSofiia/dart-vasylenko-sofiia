import 'dart:io';

import 'package:group_schedule/group_schedule.dart';
import 'package:test/test.dart';

void main() {
  group('JsonScheduleStorage', () {
    late Directory tempDirectory;
    late JsonScheduleStorage storage;
    late Lesson lesson;

    setUp(() async {
      tempDirectory = await Directory.systemTemp.createTemp(
        'schedule_storage_test_',
      );

      storage = JsonScheduleStorage(tempDirectory.path);

      lesson = Lesson.fromCsv(
        'Математика;Іваненко І.І.;Практика;'
        'Понеділок;09:30;А-101;2026-11-02',
      );
    });

    tearDown(() async {
      await tempDirectory.delete(recursive: true);
    });

    test('Збереження та завантаження заняття', () async {
      await storage.save([lesson]);

      final loaded = await storage.load();

      expect(loaded, hasLength(1));
      expect(loaded.first, equals(lesson));
    });

    test('Відсутній файл повертає порожній список', () async {
      final loaded = await storage.load();

      expect(loaded, isEmpty);
    });

    test('Пошкоджений JSON викликає помилку', () async {
      final file = File(storage.filePath);

      await file.parent.create(recursive: true);
      await file.writeAsString('{invalid json}');

      await expectLater(storage.load(), throwsA(isA<FormatException>()));
    });

    test('Можна використовувати іншу назву файлу', () async {
      final customStorage = JsonScheduleStorage(
        tempDirectory.path,
        fileName: 'custom_schedule.json',
      );

      await customStorage.save([lesson]);

      final loaded = await customStorage.load();

      expect(loaded, hasLength(1));
      expect(customStorage.filePath, contains('custom_schedule.json'));
    });
  });
}
