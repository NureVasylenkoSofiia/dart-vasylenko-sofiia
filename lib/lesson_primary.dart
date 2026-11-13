/// Альтернативна модель заняття з первинним конструктором Dart 3.13.
class const LessonPrimary({
  required final String subject,
  required final String teacher,
  required final String lessonType,
  required final String weekday,
  required final int startMinutes,
  required final String room,
  required final DateTime date,
}) {
  /// Час початку заняття у форматі HH:mm.
  String get formattedTime {
    final hours = startMinutes ~/ 60;
    final minutes = startMinutes % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return '$subject ($lessonType), $weekday '
        '$formattedTime, аудиторія $room';
  }
}
