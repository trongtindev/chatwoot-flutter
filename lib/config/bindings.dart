import '/screens/conversations/controllers/index.dart';
import '/screens/contacts/controllers/index.dart';
import '/screens/notifications/controllers/index.dart';
import '/imports.dart';

class BindingsConfig {
  Future<void> dependencies() async {
    // global services
    await Get.putAsync(() => DeviceService().init());
    await Get.putAsync(() => DbService().init());
    await Get.putAsync(() => ApiService().init());
    await Get.putAsync(() => AuthService().init());
    await Get.putAsync(() => AnalyticsService().init());
    await Get.putAsync(() => AssistantService().init());
    await Get.putAsync(() => NotificationService().init());
    await Get.putAsync(() => RealtimeService().init());
    await Get.putAsync(() => TranslatorService().init());

    // global controllers
    await Get.putAsync(() => CannedResponsesController().init(),
        permanent: true);
    await Get.putAsync(() => ContactsController().init(), permanent: true);
    await Get.putAsync(() => CustomAttributesController().init(),
        permanent: true);
    await Get.putAsync(() => InboxesController().init(), permanent: true);
    await Get.putAsync(() => ConversationsController().init(), permanent: true);
    await Get.putAsync(() => LabelsController().init(), permanent: true);
    await Get.putAsync(() => MacrosController().init(), permanent: true);
    await Get.putAsync(() => NotificationsController().init(), permanent: true);
    await Get.putAsync(() => TeamsController().init(), permanent: true);
    await Get.putAsync(() => AgentsController().init(), permanent: true);
  }
}
