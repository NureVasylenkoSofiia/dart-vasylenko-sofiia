import 'dart:async';

Future<String> loadLesson(String name) async {
  await Future<void>.delayed(const Duration(milliseconds: 500));

  return 'Завантажено: $name';
}

Future<void> main() async {
  print('Порівняння послідовного та одночасного виконання');
  print('');

  // 1. Послідовне виконання
  final sequentialWatch = Stopwatch()..start();

  final first = await loadLesson('Математика');
  final second = await loadLesson('Програмування Dart');
  final third = await loadLesson('Бази даних');

  sequentialWatch.stop();

  print('Послідовне виконання:');
  print(first);
  print(second);
  print(third);
  print('Час: ${sequentialWatch.elapsedMilliseconds} мс');

  print('');

  // 2. Одночасне виконання
  final parallelWatch = Stopwatch()..start();

  final results = await Future.wait([
    loadLesson('Математика'),
    loadLesson('Програмування Dart'),
    loadLesson('Бази даних'),
  ]);

  parallelWatch.stop();

  print('Одночасне виконання через Future.wait:');

  for (final result in results) {
    print(result);
  }

  print('Час: ${parallelWatch.elapsedMilliseconds} мс');
}
