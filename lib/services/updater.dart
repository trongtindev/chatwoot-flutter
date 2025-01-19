import '/imports.dart';

class UpdaterService extends GetxService {
  final _logger = Logger();

  Future<UpdaterService> init() async {
    _logger.i('init()');

    _logger.i('init() => successful');
    return this;
  }
}
