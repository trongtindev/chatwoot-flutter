import '/imports.dart';
import 'package:translator/translator.dart';

final translator = GoogleTranslator();

class GoogleTranslatorProvider extends BaseTranslatorProvider {
  static String name = 'GoogleTranslatorProvider';

  @override
  Future<Result<String>> translate(
    String sourceText, {
    Locale? from,
    required Locale to,
  }) async {
    try {
      logger.d('sourceText: $sourceText t:${to.languageCode}');
      final result = await translator.translate(
        sourceText,
        from: from == null ? 'auto' : from.languageCode,
        to: to.languageCode,
      );
      return result.text.toSuccess();
    } on Exception catch (error) {
      logger.e(error);
      return error.toFailure();
    }
  }
}
