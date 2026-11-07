import 'schedule_parser.dart';
import 'schedule_utils.dart';

/// Перевіряє коректність значень у записі [entry].
///
/// Повертає список порушень. Якщо список порожній,
/// запис відповідає правилам розкладу.
List<String> validateScheduleEntry(ScheduleEntry entry) {
  final errors = <String>[];

  const allowedTypes = {'Лекція', 'Практика', 'Лабораторна'};

  const weekdays = [
    'Понеділок',
    'Вівторок',
    'Середа',
    'Четвер',
    'П’ятниця',
    'Субота',
    'Неділя',
  ];

  if (!allowedTypes.contains(entry.lessonType)) {
    errors.add('Некоректний тип заняття');
  }

  if (!weekdays.contains(entry.weekday)) {
    errors.add('Некоректний день тижня');
  } else if (weekdays[entry.date.weekday - 1] != entry.weekday) {
    errors.add('День тижня не відповідає даті');
  }

  const earliestStart = 8 * 60;
  const latestStart = 20 * 60;

  if (entry.startMinutes < earliestStart || entry.startMinutes > latestStart) {
    errors.add('Час заняття поза допустимим діапазоном');
  }

  if (entry.room.trim().isEmpty) {
    errors.add('Аудиторія не вказана');
  } else if (!isValidRoom(entry.room)) {
    errors.add('Некоректний формат аудиторії');
  }

  return errors;
}
