/// Тип навчального заняття та його тривалість.
enum LessonType {
  /// Лекційне заняття.
  lecture('Лекція', 90),

  /// Практичне заняття.
  practice('Практика', 90),

  /// Лабораторне заняття.
  laboratory('Лабораторна', 120),

  /// Семінарське заняття.
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
