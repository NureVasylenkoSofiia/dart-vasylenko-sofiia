import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:group_schedule/group_schedule.dart';

Future<void> main() async {
  print('Перевірка зовнішнього REST API');
  print('Отримання державних свят України за 2026 рік');
  print('');

  final client = http.Client();

  try {
    final api = HolidayApiClient(client);
    final holidays = await api.getHolidays(2026, 'UA');

    print('Успішно отримано свят: ${holidays.length}');
    print('');

    for (final holiday in holidays.take(5)) {
      print(holiday);
    }
  } on SocketException catch (error) {
    stderr.writeln('Немає з’єднання: $error');
    exitCode = 1;
  } on http.ClientException catch (error) {
    stderr.writeln('Помилка HTTP-клієнта: $error');
    exitCode = 1;
  } on TimeoutException catch (error) {
    stderr.writeln('Перевищено час очікування: $error');
    exitCode = 1;
  } on HolidayApiException catch (error) {
    stderr.writeln('Помилка сервера: $error');
    exitCode = 1;
  } on FormatException catch (error) {
    stderr.writeln('Некоректний JSON: $error');
    exitCode = 1;
  } finally {
    client.close();
  }
}
