import '/imports.dart';

class AssistantService extends GetxService {
  final _logger = Logger();

  Future<AssistantService> init() async {
    _logger.i('init()');

    _logger.i('init() => successful');
    return this;
  }
}
