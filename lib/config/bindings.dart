import '/screens/conversations/controllers/index.dart';
import '/screens/contacts/controllers/index.dart';
import '/screens/notifications/controllers/index.dart';
import '/imports.dart';

class BindingsConfig extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync(() => SettingsService().init());
    await Get.putAsync(() => DbService().init());
    await Get.putAsync(() => ApiService().init());
    await Get.putAsync(() => AuthService().init());
    await Get.putAsync(() => NotificationService().init());
    await Get.putAsync(() => RealtimeService().init());

    Get.lazyPut(() => AnalyticsService());
    Get.lazyPut(() => AssistantService());
    Get.lazyPut(() => AttributeService());
    Get.lazyPut(() => InboxService());
    Get.lazyPut(() => LabelService());

    Get.lazyPut(() => ContactsController());
    Get.lazyPut(() => ConversationsController()); // TODO: convert to service
    Get.lazyPut(() => NotificationsController()); // TODO: convert to service
  }
}
