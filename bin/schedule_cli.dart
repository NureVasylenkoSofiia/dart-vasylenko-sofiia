import 'dart:io';

import 'package:group_schedule/src/cli/schedule_cli.dart';

Future<void> main(List<String> arguments) async {
  final cli = ScheduleCli();

  exitCode = await cli.run(arguments);
}
