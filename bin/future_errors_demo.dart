import 'dart:async';

Future<String> loadLesson(String name, {bool shouldFail = false}) async {
  await Future<void>.delayed(const Duration(milliseconds: 300));

  if (shouldFail) {
    throw Exception('Не вдалося завантажити заняття: $name');
  }

  return 'Завантажено: $name';
}

Future<void> main() async {
  print('Обробка помилок через Future.wait');
  print('');

  try {
    final results = await Future.wait([
      loadLesson('Математика'),
      loadLesson('Програмування Dart', shouldFail: true),
      loadLesson('Бази даних'),
    ]);

    for (final result in results) {
      print(result);
    }
  } catch (error) {
    print('Future.wait завершився помилкою:');
    print(error);
  }

  print('');
  print('Обробка помилок через .wait');
  print('');

  try {
    final results = await [
      loadLesson('Математика'),
      loadLesson('Програмування Dart', shouldFail: true),
      loadLesson('Бази даних'),
    ].wait;

    for (final result in results) {
      print(result);
    }
  } on ParallelWaitError<List<String?>, List<AsyncError?>> catch (error) {
    print('.wait завершився з ParallelWaitError');
    final errorCount = error.errors.where((item) => item != null).length;
    print('Кількість помилок: $errorCount');
    print('');

    for (var i = 0; i < error.values.length; i++) {
      print('Операція ${i + 1}:');

      final value = error.values[i];
      final asyncError = error.errors[i];

      if (asyncError != null) {
        print('Помилка: ${asyncError.error}');
      } else {
        print('Результат: $value');
      }
    }
  }
}
