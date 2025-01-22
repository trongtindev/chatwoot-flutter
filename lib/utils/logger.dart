import 'package:logger/logger.dart' as _logger;

class Logger extends _logger.Logger {
  Logger() : super();
}

class PrettyPrinter extends _logger.PrettyPrinter {
  @override
  List<String> log(_logger.LogEvent event) {
    if (event.level == _logger.Level.warning ||
        event.level == _logger.Level.error) {
      return super.log(event);
    }

    final stackTrace = StackTrace.current.toString().split('\n');
    List<String> items = ['- [${event.level.name}] ${event.message}'];
    if (stackTrace.length >= 4) {
      final stackLine = stackTrace[3].replaceFirst(RegExp(r'#\d+\s+'), '');
      items.insert(0, stackLine);
    }

    return items;
  }
}

class AdvancedFileOutput extends _logger.AdvancedFileOutput {
  AdvancedFileOutput({
    required super.path,
    required super.maxFileSizeKB,
    required int super.maxRotatedFilesCount,
  });

  @override
  void output(_logger.OutputEvent event) {
    super.output(event);
    // ignore: avoid_print
    event.lines.forEach(print);
  }
}

final logger = Logger();
