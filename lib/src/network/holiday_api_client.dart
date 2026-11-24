import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/public_holiday.dart';

/// Помилка отримання даних із зовнішнього API.
class HolidayApiException implements Exception {
  /// Опис помилки.
  final String message;

  /// Створює помилку API.
  const HolidayApiException(this.message);

  @override
  String toString() => message;
}

/// Отримує державні свята із зовнішнього REST API.
class HolidayApiClient {
  /// HTTP-клієнт для виконання запитів.
  final http.Client client;

  /// Базова адреса сервісу.
  final Uri baseUri;

  /// Створює клієнт із переданою HTTP-залежністю.
  HolidayApiClient(this.client, {Uri? baseUri})
    : baseUri = baseUri ?? Uri.parse('https://date.nager.at');

  /// Завантажує державні свята для країни та року.
  Future<List<PublicHoliday>> getHolidays(int year, String countryCode) async {
    final uri = baseUri.replace(
      path: '/api/v3/PublicHolidays/$year/$countryCode',
    );

    final response = await client.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HolidayApiException(
        'HTTP ${response.statusCode}: не вдалося отримати свята',
      );
    }

    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (decoded is! List) {
        throw const FormatException('Відповідь API повинна містити список');
      }

      return decoded.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Некоректний запис у відповіді');
        }

        return PublicHoliday.fromJson(item);
      }).toList();
    } on FormatException {
      rethrow;
    } on Object catch (error) {
      throw FormatException('Некоректна відповідь API: $error');
    }
  }
}
