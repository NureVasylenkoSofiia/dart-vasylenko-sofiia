import 'dart:convert';
import 'dart:io';

import 'package:group_schedule/group_schedule.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  group('HolidayApiClient', () {
    test('Успішне отримання свят', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v3/PublicHolidays/2026/UA');

        return http.Response.bytes(
          utf8.encode(
            jsonEncode([
              {
                'date': '2026-01-01',
                'localName': 'Новий Рік',
                'name': "New Year's Day",
                'countryCode': 'UA',
              },
            ]),
          ),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      try {
        final api = HolidayApiClient(client);
        final holidays = await api.getHolidays(2026, 'UA');

        expect(holidays, hasLength(1));
        expect(holidays.first.localName, 'Новий Рік');
        expect(holidays.first.countryCode, 'UA');
      } finally {
        client.close();
      }
    });

    test('Обробка HTTP 500', () async {
      final client = MockClient(
        (request) async => http.Response('Server error', 500),
      );

      try {
        final api = HolidayApiClient(client);

        await expectLater(
          api.getHolidays(2026, 'UA'),
          throwsA(isA<HolidayApiException>()),
        );
      } finally {
        client.close();
      }
    });

    test('Обробка некоректного JSON', () async {
      final client = MockClient(
        (request) async => http.Response('invalid json', 200),
      );

      try {
        final api = HolidayApiClient(client);

        await expectLater(
          api.getHolidays(2026, 'UA'),
          throwsA(isA<FormatException>()),
        );
      } finally {
        client.close();
      }
    });

    test('Обробка відсутності з’єднання', () async {
      final client = MockClient((request) async {
        throw const SocketException('Немає з’єднання');
      });

      try {
        final api = HolidayApiClient(client);

        await expectLater(
          api.getHolidays(2026, 'UA'),
          throwsA(isA<SocketException>()),
        );
      } finally {
        client.close();
      }
    });
  });
}
