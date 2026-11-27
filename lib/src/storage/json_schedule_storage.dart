import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'package:group_schedule/group_schedule.dart';

/// Зберігає та завантажує розклад у форматі JSON.
class JsonScheduleStorage {
  /// Створює файлове сховище для розкладу в заданому каталозі.
  final String filePath;

  /// Створює файлове сховище для вибраного JSON-файлу.
  JsonScheduleStorage(String baseDirectory, {String fileName = 'schedule.json'})
    : filePath = p.join(baseDirectory, 'data', fileName);

  /// Зберігає список занять у JSON-файл.
  Future<void> save(List<Lesson> lessons) async {
    final file = File(filePath);

    await file.parent.create(recursive: true);

    final jsonData = lessons.map((lesson) => lesson.toJson()).toList();

    final jsonText = const JsonEncoder.withIndent('  ').convert(jsonData);

    await file.writeAsString(jsonText, encoding: utf8);
  }

  /// Завантажує заняття з JSON-файлу.
  Future<List<Lesson>> load() async {
    final file = File(filePath);

    if (!await file.exists()) {
      return [];
    }

    final jsonText = await file.readAsString(encoding: utf8);
    final decoded = jsonDecode(jsonText);

    if (decoded is! List) {
      throw const FormatException('JSON повинен містити список занять');
    }

    return decoded.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Некоректний запис заняття в JSON');
      }

      try {
        return Lesson.fromJson(item);
      } on Object catch (error) {
        throw FormatException('Некоректні дані заняття: $error');
      }
    }).toList();
  }
}
