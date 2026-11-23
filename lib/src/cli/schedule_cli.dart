import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import 'package:group_schedule/group_schedule.dart';

/// Обробник команд консольного застосунку.
class ScheduleCli {
  /// Виконує команду на основі аргументів.
  Future<int> run(List<String> arguments) async {
    final parser = ArgParser()
      ..addOption(
        'file',
        abbr: 'f',
        defaultsTo: 'schedule.json',
        help: 'Назва JSON-файлу у папці data',
      )
      ..addOption('subject', abbr: 's', help: 'Фільтр за назвою дисципліни')
      ..addOption('csv', help: 'Новий запис заняття у форматі CSV')
      ..addFlag('help', abbr: 'h', negatable: false, help: 'Показати довідку');

    try {
      final result = parser.parse(arguments);

      if (result['help'] == true || result.rest.isEmpty) {
        print('Команди: list, add');
        print(parser.usage);
        return 0;
      }

      final command = result.rest.first;
      final fileName = result['file'] as String;

      final filePath = p.join(Directory.current.path, 'data', fileName);

     final storage = JsonScheduleStorage(
  Directory.current.path,
  fileName: fileName,
);

      if (command == 'list') {
        final lessons = await storage.load();

        final subjectFilter = result['subject'] as String?;

        final filtered = subjectFilter == null
            ? lessons
            : lessons
                  .where(
                    (lesson) => lesson.subject.toLowerCase().contains(
                      subjectFilter.toLowerCase(),
                    ),
                  )
                  .toList();

        print('Файл: $filePath');
        print('Знайдено занять: ${filtered.length}');

        for (final lesson in filtered) {
          print(lesson);
        }

        return 0;
      }

      if (command == 'add') {
        final csv = result['csv'] as String?;

        if (csv == null || csv.isEmpty) {
          stderr.writeln('Помилка: потрібно вказати --csv');
          return 1;
        }

        final lesson = Lesson.fromCsv(csv);

        final lessons = await storage.load();
        lessons.add(lesson);

        await storage.save(lessons);

        print('Заняття додано: $lesson');
        return 0;
      }

      stderr.writeln('Невідома команда: $command');
      return 1;
    } on FormatException catch (error) {
      stderr.writeln('Помилка формату: $error');
      return 1;
    } on FileSystemException catch (error) {
      stderr.writeln('Помилка файлу: $error');
      return 1;
    }
  }
}
