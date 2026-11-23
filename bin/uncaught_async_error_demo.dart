import 'dart:async';

Future<void> loadScheduleWithError() async {
  await Future<void>.delayed(const Duration(milliseconds: 300));

  throw Exception('Помилка завантаження розкладу');
}

Future<void> main() async {
  print('Демонстрація обробки асинхронної помилки');

  try {
    await loadScheduleWithError();

    print('Завантаження завершено');
  } catch (error) {
    print('Помилку перехоплено: $error');
  }

  print('Програма продовжила виконання');
}
