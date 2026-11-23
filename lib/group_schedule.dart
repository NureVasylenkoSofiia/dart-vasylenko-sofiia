/// Публічний інтерфейс пакета group_schedule.
///
/// Надає доступ до моделей та основних операцій
/// роботи з розкладом занять.
library;

export 'src/models/lesson.dart';
export 'src/models/lesson_type.dart';
export 'src/models/lesson_kind.dart';
export 'src/models/lesson_primary.dart';
export 'repository.dart';
export 'async_repository.dart';
export 'lesson_event_service.dart';
export 'lesson_schedule_service.dart';
export 'lesson_statistics.dart';
export 'lesson_report.dart';
export 'src/services/heavy_schedule_statistics.dart';
export 'src/storage/json_schedule_storage.dart';
export 'src/storage/large_schedule_reader.dart';
