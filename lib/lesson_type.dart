/// Категорії занять університетської групи.
enum LessonType {
  lecture('Лекція', 90),
  practice('Практика', 90),
  laboratory('Лабораторна', 120),
  seminar('Семінар', 90);

  /// Назва типу заняття українською.
  final String title;

  /// Тривалість заняття у хвилинах.
  final int durationMinutes;

  /// Створює категорію заняття.
  const LessonType(this.title, this.durationMinutes);

  /// Повертає короткий опис категорії.
  String describe() => '$title ($durationMinutes хв)';

  /// Знаходить категорію за українською назвою.
  static LessonType? fromTitle(String title) {
    for (final type in LessonType.values) {
      if (type.title == title) {
        return type;
      }
    }

    return null;
  }
}
