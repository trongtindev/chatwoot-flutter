import 'package:chatwoot/screens/notifications/views/filter.dart';

import '/imports.dart';

class NotificationsController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();

  final unread_count = 0.obs;
  final includes = NotificationStatus.values.obs;
  final items = RxList<NotificationInfo>();
  final loading = true.obs;
  final error = ''.obs;

  @override
  void onReady() {
    super.onReady();
    getNotifications();
    includes.listen((_) => getNotifications());
  }

  Future<void> getNotifications() async {
    try {
      loading.value = true;
      var result = await _api.listNotifications(
        account_id: _auth.profile.value!.account_id,
        includes: includes,
      );
      var data = result.getOrThrow();

      items.value = data.payload;
      unread_count.value = data.meta.unread_count;
    } on ApiError catch (reason) {
      _logger.w(reason);
      error.value = reason.errors.join(';');
    } on Error catch (reason) {
      print(reason.stackTrace);
      _logger.e(reason);
      error.value = reason.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> showFilter() async {
    var result = await Get.bottomSheet<bool>(NotificationsFilterView());
    if (result == null || !result) return;
    getNotifications();
  }

  Future<void> readAll() async {}
}
