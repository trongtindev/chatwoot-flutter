import '/screens/conversations/controllers/index.dart';
import '/screens/contacts/controllers/index.dart';
import '/screens/notifications/controllers/index.dart';
import '/imports.dart';

class BindingsConfig {
  Future<void> dependencies() async {
    await Get.putAsync(() => SettingsService().init());
    await Get.putAsync(() => DbService().init());
    await Get.putAsync(() => ApiService().init());
    await Get.putAsync(() => AssistantService().init());
    await Get.putAsync(() => AuthService().init());
    await Get.putAsync(() => AnalyticsService().init());
    await Get.putAsync(() => NotificationService().init());
    await Get.putAsync(() => RealtimeService().init());

    Get.lazyPut(() => ConversationsController());
    Get.lazyPut(() => NotificationsController());
    Get.lazyPut(() => ContactsController());
  }
}
