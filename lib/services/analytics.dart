import '/imports.dart';

class AnalyticsService extends GetxService {
  final logger = Logger();

  Future<AnalyticsService> init() async {
    logger.i('init()');

    logger.i('init() => successful');
    return this;
  }
}
