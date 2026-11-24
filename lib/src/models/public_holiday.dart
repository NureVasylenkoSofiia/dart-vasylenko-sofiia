/// Інформація про державне свято, отримана із REST API.
class PublicHoliday {
  /// Дата свята.
  final DateTime date;

  /// Назва свята місцевою мовою.
  final String localName;

  /// Міжнародна назва свята.
  final String name;

  /// Код країни.
  final String countryCode;

  /// Створює об'єкт державного свята.
  const PublicHoliday({
    required this.date,
    required this.localName,
    required this.name,
    required this.countryCode,
  });

  /// Створює об'єкт з JSON-відповіді API.
  factory PublicHoliday.fromJson(Map<String, dynamic> json) {
    try {
      return PublicHoliday(
        date: DateTime.parse(json['date'] as String),
        localName: json['localName'] as String,
        name: json['name'] as String,
        countryCode: json['countryCode'] as String,
      );
    } on Object catch (error) {
      throw FormatException('Некоректні дані свята: $error');
    }
  }

  @override
  String toString() =>
      '${date.toIso8601String().substring(0, 10)}'
      ' — $localName';
}
