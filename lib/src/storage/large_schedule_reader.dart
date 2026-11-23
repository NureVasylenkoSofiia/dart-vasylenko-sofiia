import 'dart:convert';
import 'dart:io';

/// Читає текстові файли розкладу поступово.
class LargeScheduleReader {
  /// Підраховує кількість непорожніх рядків у файлі.
  Future<int> countEntries(String filePath) async {
    final file = File(filePath);

    if (!await file.exists()) {
      throw FileSystemException('Файл не знайдено', filePath);
    }

    final lines = file
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    var count = 0;

    await for (final line in lines) {
      if (line.trim().isNotEmpty) {
        count++;
      }
    }

    return count;
  }
}
