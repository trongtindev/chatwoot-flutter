import '/imports.dart';
export './providers/google.dart';

abstract class BaseTranslatorProvider {
  static String name = 'BaseTranslatorProvider';

  Future<Result<String>> translate(
    String sourceText, {
    Locale? from,
    required Locale to,
  });
}
