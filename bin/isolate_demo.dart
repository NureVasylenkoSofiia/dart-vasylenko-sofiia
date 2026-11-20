import 'dart:isolate';

import 'package:group_schedule/heavy_schedule_statistics.dart';

int globalCounter = 0;

Future<void> main() async {
  const count = 20000000;

  print('Перевірка важкого обчислення');
  print('Кількість згенерованих занять: $count');
  print('');

  // 1. Обчислення в основному ізоляті.
  final directWatch = Stopwatch()..start();

  final directResult = calculateHeavyStatistics(count);

  directWatch.stop();

  print('Обчислення в основному ізоляті:');
  print(directResult);
  print('Час: ${directWatch.elapsedMilliseconds} мс');

  print('');

  // 2. Обчислення в окремому ізоляті.
  final isolateWatch = Stopwatch()..start();

  final isolateResult = await Isolate.run(
    () => calculateHeavyStatistics(count),
  );

  isolateWatch.stop();

  print('Обчислення через Isolate.run:');
  print(isolateResult);
  print('Час: ${isolateWatch.elapsedMilliseconds} мс');

  print('');

  final sameResult =
      directResult.length == isolateResult.length &&
      directResult.entries.every(
        (entry) => isolateResult[entry.key] == entry.value,
      );

  print('Результати обчислень збігаються: $sameResult');

  print('');
  print('Перевірка глобальної змінної в ізоляті');

  globalCounter = 10;

  print('До запуску ізоляту: $globalCounter');

  final isolateCounter = await Isolate.run(() {
    print('Початкове значення в окремому ізоляті: $globalCounter');

    globalCounter = 100;

    print('Змінене значення в окремому ізоляті: $globalCounter');

    return globalCounter;
  });

  print('Значення, повернене ізолятом: $isolateCounter');
  print('Значення в основному ізоляті: $globalCounter');
}
