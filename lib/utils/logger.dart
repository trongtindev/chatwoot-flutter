import 'package:logger/logger.dart' as logger;

class Logger extends logger.Logger {
  Logger() : super();
}

class PrettyPrinter extends logger.PrettyPrinter {
  @override
  List<String> log(logger.LogEvent event) {
    if (event.level == logger.Level.warning ||
        event.level == logger.Level.error) {
      return super.log(event);
    }
    return ['[${event.level.name}] [${event.time}] ${event.message}'];
    // return super.log(event);
  }
}

class AdvancedFileOutput extends logger.AdvancedFileOutput {
  AdvancedFileOutput({
    required super.path,
    required super.maxFileSizeKB,
    required int super.maxRotatedFilesCount,
  });

  @override
  void output(logger.OutputEvent event) {
    super.output(event);
    // ignore: avoid_print
    event.lines.forEach(print);
  }
}
