import 'package:group_schedule/lesson.dart';
import 'package:group_schedule/lesson_primary.dart';
import 'package:group_schedule/lesson_kind.dart';
import 'package:group_schedule/schedule_extensions.dart';
import 'package:group_schedule/repository.dart';
import 'package:group_schedule/lesson_type.dart';
import 'package:group_schedule/lesson_parsing.dart';
import 'package:group_schedule/lesson_patterns.dart';
import 'package:group_schedule/lesson_schedule_service.dart';
import 'package:group_schedule/schedule_data.dart';
import 'package:group_schedule/lesson_validator.dart';
import 'package:group_schedule/lesson_statistics.dart';
import 'package:group_schedule/lesson_report.dart';

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

  print('');
  print('Обробка повного розкладу через об’єкти Lesson:');

  final scheduleResult = parseSchedule(rawSchedule);
  final (lessons: scheduleLessons, errors: scheduleErrors) = scheduleResult;

  print('Усього записів: ${rawSchedule.length}');
  print('Коректних занять: ${scheduleLessons.length}');
  print('Відхилених записів: ${scheduleErrors.length}');

  print('');
  print('Помилки розбору:');

  for (final error in scheduleErrors) {
    print(error);
  }

  print('');
  print('Перші три заняття:');

  for (final lesson in scheduleLessons.take(3)) {
    print(lesson);
  }

  print('');
  print('Перевірка валідатора Lesson:');

  final validErrors = validateLesson(csvLesson);
  print('Помилки коректного заняття: ${validErrors.length}');

  final invalidDayLesson = Lesson(
    subject: 'Математика',
    teacher: 'Іваненко І.І.',
    lessonType: 'Лекція',
    weekday: 'П’ятниця',
    startMinutes: 570,
    room: 'А-101',
    date: DateTime(2026, 11, 2),
  );

  final invalidDayErrors = validateLesson(invalidDayLesson);

  print('Помилки заняття з неправильним днем:');
  for (final error in invalidDayErrors) {
    print(error);
  }

  print('');
  print('Статистика розкладу через Lesson:');

  final laboratoryLessons = filterLaboratoryLessons(scheduleLessons);
  final uniqueSubjects = getUniqueSubjects(scheduleLessons);
  final totalLessons = countLessons(scheduleLessons);
  final lessonsByDay = countLessonsByWeekday(scheduleLessons);

  print('Усього занять: $totalLessons');
  print('Лабораторних занять: ${laboratoryLessons.length}');
  print('Унікальних дисциплін: ${uniqueSubjects.length}');

  print('');
  print('Кількість занять за днями тижня:');

  for (final entry in lessonsByDay.entries) {
    print('${entry.key}: ${entry.value}');
  }

  final sortedByTime = sortLessonsByTime(scheduleLessons);
  final sortedBySubject = sortLessonsBySubject(
    scheduleLessons,
    ascending: false,
  );

  print('');
  print('Перші три заняття за часом:');

  for (final lesson in sortedByTime.take(3)) {
    print(lesson);
  }

  print('');
  print('Перші три заняття за назвою (спадання):');

  for (final lesson in sortedBySubject.take(3)) {
    print(lesson);
  }

  print('');
  print('Текстовий звіт для об’єктів Lesson:');

  final report = buildLessonReport(
    scheduleLessons,
    topCount: 5,
    ascending: true,
    separator: ' | ',
  );

  print(report);
}
