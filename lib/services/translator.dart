import '/imports.dart';
export '/translator/translator.dart';

class TranslatorService extends GetxService {
  final provider = PersistentRx(
    GoogleTranslatorProvider.name,
    key: 'translator:provider',
  );

  BaseTranslatorProvider get getProvider {
    switch (provider.value) {
      case 'GoogleTranslatorProvider':
        return GoogleTranslatorProvider();
      default:
        throw Exception('Unsupported translator provider: ${provider.value}');
    }
  }

  Future<TranslatorService> init() async {
    return this;
  }
}
