/// Одне заняття з розкладу університетської групи.
class Lesson {
  final String subject;
  final String teacher;
  final String lessonType;
  final String weekday;
  final int startMinutes;
  final String room;
  final DateTime date;

  /// Створює заняття із заданими характеристиками.
  const Lesson({
    required this.subject,
    required this.teacher,
    required this.lessonType,
    required this.weekday,
    required this.startMinutes,
    required this.room,
    required this.date,
  });

  /// Створює заняття з текстового рядка з роздільником ";".
  /// Для некоректних даних викидає FormatException.
  Lesson.fromCsv(String line)
    : this(
        subject: _parseFields(line)[0],
        teacher: _parseFields(line)[1],
        lessonType: _parseFields(line)[2],
        weekday: _parseFields(line)[3],
        startMinutes: _parseTime(_parseFields(line)[4]),
        room: _parseFields(line)[5],
        date: _parseDate(_parseFields(line)[6]),
      );

  /// Повертає стандартне заняття, якщо конкретні дані не задані.
  factory Lesson.defaultLesson() {
    return Lesson(
      subject: 'Невідома дисципліна',
      teacher: 'Не вказано',
      lessonType: 'Лекція',
      weekday: 'Понеділок',
      startMinutes: 480,
      room: 'А-000',
      date: DateTime(2026, 11, 2),
    );
  }

  /// Повертає час початку у форматі HH:mm.
  String get formattedTime {
    final hours = startMinutes ~/ 60;
    final minutes = startMinutes % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}';
  }

  /// Повертає короткий опис заняття.
  @override
  String toString() {
    return '$subject ($lessonType), $weekday '
        '$formattedTime, аудиторія $room';
  }
}

/// Розділяє рядок на поля та перевіряє їхню кількість.
List<String> _parseFields(String line) {
  final fields = line.split(';').map((field) => field.trim()).toList();

  if (fields.length != 7 || fields.any((field) => field.isEmpty)) {
    throw FormatException('Некоректна кількість або вміст полів');
  }

  return fields;
}

/// Перетворює час HH:mm на кількість хвилин.
int _parseTime(String value) {
  final parts = value.split(':');

  if (parts.length != 2) {
    throw FormatException('Некоректний формат часу');
  }

  final hours = int.tryParse(parts[0]);
  final minutes = int.tryParse(parts[1]);

  if (hours == null ||
      minutes == null ||
      hours < 0 ||
      hours > 23 ||
      minutes < 0 ||
      minutes > 59) {
    throw FormatException('Некоректне значення часу');
  }

  return hours * 60 + minutes;
}

/// Перетворює дату YYYY-MM-DD на DateTime.
DateTime _parseDate(String value) {
  final date = DateTime.tryParse(value);
  final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  if (date == null ||
      !datePattern.hasMatch(value) ||
      date.year.toString().padLeft(4, '0') != value.substring(0, 4) ||
      date.month.toString().padLeft(2, '0') != value.substring(5, 7) ||
      date.day.toString().padLeft(2, '0') != value.substring(8, 10)) {
    throw FormatException('Некоректна дата: $value');
  }

  return date;
}
