/// Базовий тип заняття в розкладі.
sealed class LessonKind {
  const LessonKind();

  /// Назва типу заняття.
  String get name;

  /// Рекомендована тривалість заняття у хвилинах.
  int get durationMinutes;

  /// Повертає короткий опис типу заняття.
  String describe() => '$name, $durationMinutes хв';
}

/// Спільна поведінка для занять, що потребують підготовки матеріалів.
mixin PreparationMaterials on LessonKind {
  /// Формує нагадування про підготовку.
  String getPreparationReminder() {
    return 'Для заняття "$name" потрібно підготувати навчальні матеріали';
  }
}

/// Лекційне заняття.
final class LectureKind extends LessonKind with PreparationMaterials {
  /// Створює об'єкт лекційного заняття.
  const LectureKind();

  @override
  String get name => 'Лекція';

  @override
  int get durationMinutes => 90;
}

/// Практичне заняття.
final class PracticeKind extends LessonKind {
  /// Створює об'єкт практичного заняття.
  const PracticeKind();

  @override
  String get name => 'Практика';

  @override
  int get durationMinutes => 90;
}

/// Лабораторне заняття.
final class LaboratoryKind extends LessonKind {
  /// Створює об'єкт лабораторного заняття.
  const LaboratoryKind();

  @override
  String get name => 'Лабораторна';

  @override
  int get durationMinutes => 120;
}

/// Семінарське заняття.
final class SeminarKind extends LessonKind with PreparationMaterials {
  /// Створює об'єкт семінарського заняття.
  const SeminarKind();

  @override
  String get name => 'Семінар';

  @override
  int get durationMinutes => 90;
}

/// Повертає рекомендацію щодо підготовки залежно від типу заняття.
String getPreparationAdvice(LessonKind kind) {
  return switch (kind) {
    LectureKind() => 'Ознайомитися з теоретичним матеріалом',
    PracticeKind() => 'Повторити приклади та розв’язати задачі',
    LaboratoryKind() => 'Підготувати середовище розробки',
    SeminarKind() => 'Підготувати запитання для обговорення',
    PreparationMaterials() => 'Підготувати навчальні матеріали',
  };
}
