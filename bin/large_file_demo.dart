import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:group_schedule/group_schedule.dart';

Future<void> main() async {
  print('Перевірка потокового читання великого файлу');

  final filePath = p.join(Directory.current.path, 'data', 'large_schedule.txt');

  final file = File(filePath);
  await file.parent.create(recursive: true);

  // Генеруємо файл поступово.
  final sink = file.openWrite();

  for (var i = 0; i < 10000; i++) {
    sink.writeln(
      'Математика;Іваненко І.І.;Практика;'
      'Понеділок;09:30;А-101;2026-11-02',
    );
  }

  await sink.close();

  print('Створено файл із 10000 записів');
  print('Шлях: $filePath');
  print('');

  final reader = LargeScheduleReader();

  final watch = Stopwatch()..start();

  final count = await reader.countEntries(filePath);

  watch.stop();

  print('Кількість прочитаних записів: $count');
  print('Час читання: ${watch.elapsedMilliseconds} мс');
  print('Файл оброблено через openRead()');
}
