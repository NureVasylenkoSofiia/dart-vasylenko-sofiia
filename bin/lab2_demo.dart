import 'package:group_schedule/lesson.dart';
import 'package:group_schedule/lesson_primary.dart';
import 'package:group_schedule/lesson_kind.dart';
import 'package:group_schedule/schedule_extensions.dart';
import 'package:group_schedule/repository.dart';
import 'package:group_schedule/lesson_type.dart';
import 'package:group_schedule/lesson_parsing.dart';
import 'package:group_schedule/lesson_patterns.dart';

void main() {
  final csvLesson = Lesson.fromCsv(
    'Математика;Іваненко І.І.;Лекція;Понеділок;09:30;А-101;2026-11-02',
  );

  final defaultLesson = Lesson.defaultLesson();

  print('Заняття з CSV: $csvLesson');
  print('Стандартне заняття: $defaultLesson');
  print('Час початку: ${csvLesson.formattedTime}');
  final primaryLesson = LessonPrimary(
    subject: 'Математика',
    teacher: 'Іваненко І.І.',
    lessonType: 'Лекція',
    weekday: 'Понеділок',
    startMinutes: 570,
    room: 'А-101',
    date: DateTime(2026, 11, 2),
  );

  print('');
  print('Заняття з первинним конструктором: $primaryLesson');
  print('Час початку: ${primaryLesson.formattedTime}');

  final lessonCopy = Lesson.fromCsv(
    'Математика;Іваненко І.І.;Лекція;Понеділок;09:30;А-101;2026-11-02',
  );

  final lessonsSet = <Lesson>{csvLesson, lessonCopy};

  print('');
  print('Чи однакові заняття: ${csvLesson == lessonCopy}');
  print('Кількість елементів у Set: ${lessonsSet.length}');

  print('');
  print('Типи занять та рекомендації:');

  final kinds = <LessonKind>[
    const LectureKind(),
    const PracticeKind(),
    const LaboratoryKind(),
    const SeminarKind(),
  ];

  for (final kind in kinds) {
    print(kind.describe());
    print('Підготовка: ${getPreparationAdvice(kind)}');

    if (kind is PreparationMaterials) {
      print(kind.getPreparationReminder());
    }
  }

  print('');
  print('Форматування дати через extension:');
  print('Дата заняття: ${csvLesson.date.toScheduleFormat()}');

  print('');
  print('Перевірка Repository:');

  final repository = Repository<Lesson>();

  repository.add(csvLesson);
  repository.add(lessonCopy);
  repository.add(defaultLesson);

  print('Кількість занять у сховищі: ${repository.count}');

  final foundLesson = repository.findById(csvLesson.id);
  print('Знайдене заняття: $foundLesson');

  final lectures = repository.where((lesson) => lesson.lessonType == 'Лекція');

  print('Кількість лекцій: ${lectures.length}');

  print('');
  print('Перевірка enum LessonType:');

  for (final type in LessonType.values) {
    print(type.describe());
  }

  final parsedType = LessonType.fromTitle(csvLesson.lessonType);
  print('Тип заняття з CSV: ${parsedType?.describe()}');

  print('');
  print('Перевірка розбору з Record:');

  final validResult = parseLesson(
    'Фізика;Петренко О.О.;Практика;Вівторок;11:15;Б-202;2026-11-03',
  );

  final (lesson: validLesson, error: validError) = validResult;

  print('Коректний запис: $validLesson');
  print('Помилка: $validError');

  final invalidResult = parseLesson(
    'Фізика;Петренко О.О.;Практика;Вівторок;abc;Б-202;2026-11-03',
  );

  final (lesson: invalidLesson, error: invalidError) = invalidResult;

  print('Некоректний запис: $invalidLesson');
  print('Помилка: $invalidError');

  print('');
  print('Перевірка pattern matching:');

  final earlyLab = Lesson.fromCsv(
    'Програмування;Сидоренко С.С.;Лабораторна;Середа;08:30;В-303;2026-11-04',
  );

  print('Результат перевірки: ${getLessonNotice(earlyLab)}');
  print('Звичайне заняття: ${getLessonNotice(csvLesson)}');
}
