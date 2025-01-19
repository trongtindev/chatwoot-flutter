import '/imports.dart';

class DeeplinkService extends GetxService {
  final _logger = Logger();

  Future<DeeplinkService> init() async {
    _logger.i('init()');

    _logger.i('init() => successful');
    return this;
  }
}
