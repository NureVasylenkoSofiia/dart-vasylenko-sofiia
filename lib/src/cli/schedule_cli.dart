import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import 'package:group_schedule/group_schedule.dart';

import 'dart:async';

import 'package:http/http.dart' as http;

/// Обробник команд консольного застосунку.
class ScheduleCli {
  /// Каталог, у якому зберігаються дані застосунку.
  final String baseDirectory;

  /// Створює CLI для заданого робочого каталогу.
  ScheduleCli({String? baseDirectory})
    : baseDirectory = baseDirectory ?? Directory.current.path;

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
      ..addOption('year', defaultsTo: '2026', help: 'Рік для отримання свят')
      ..addOption(
        'country',
        defaultsTo: 'UA',
        help: 'Код країни для отримання свят',
      )
      ..addFlag('help', abbr: 'h', negatable: false, help: 'Показати довідку');

    try {
      final result = parser.parse(arguments);

      if (result['help'] == true || result.rest.isEmpty) {
        print('Команди: list, add, holidays');
        print(parser.usage);
        return 0;
      }

      final command = result.rest.first;
      final fileName = result['file'] as String;

      // Дозволяємо тільки прості назви JSON-файлів.
      final validFileName = RegExp(r'^[a-zA-Z0-9_-]+\.json$');

      if (!validFileName.hasMatch(fileName)) {
        stderr.writeln('Помилка: --file повинен містити лише назву JSON-файлу');
        return 1;
      }

      final filePath = p.join(baseDirectory, 'data', fileName);

      final storage = JsonScheduleStorage(baseDirectory, fileName: fileName);

      if (command == 'holidays') {
        final yearText = result['year'] as String;
        final country = (result['country'] as String).toUpperCase();
        final year = int.tryParse(yearText);

        if (year == null || year < 1 || year > 9999) {
          stderr.writeln('Помилка: некоректний рік');
          return 1;
        }

        if (!RegExp(r'^[A-Z]{2}$').hasMatch(country)) {
          stderr.writeln('Помилка: код країни повинен містити 2 літери');
          return 1;
        }

        final client = http.Client();

        try {
          final api = HolidayApiClient(client);
          final holidays = await api.getHolidays(year, country);

          print('Державні свята: $country, $year');
          print('Знайдено свят: ${holidays.length}');
          print('');

          for (final holiday in holidays) {
            print(holiday);
          }

          return 0;
        } finally {
          client.close();
        }
      }

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
    } on SocketException catch (error) {
      stderr.writeln('Немає з’єднання: $error');
      return 1;
    } on http.ClientException catch (error) {
      stderr.writeln('Помилка HTTP-клієнта: $error');
      return 1;
    } on TimeoutException catch (error) {
      stderr.writeln('Перевищено час очікування: $error');
      return 1;
    } on HolidayApiException catch (error) {
      stderr.writeln('Помилка зовнішнього API: $error');
      return 1;
    }
  }
}
