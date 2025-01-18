import '/imports.dart';
import 'package:toastification/toastification.dart';

class NotificationService extends GetxService {
  final _logger = Logger();

  Future<NotificationService> init() async {
    _logger.i('init()');

    _logger.i('init() => successful');
    return this;
  }

  void show({
    required String title,
    String? description,
    ToastificationType? type,
  }) {
    toastification.show(
      title: Text(title),
      description: description != null ? Text(description) : null,
      type: type ?? ToastificationType.info,
      autoCloseDuration: const Duration(seconds: 5),
      alignment: Alignment.bottomRight,
    );
  }
}
