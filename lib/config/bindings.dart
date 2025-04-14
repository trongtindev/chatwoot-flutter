import '/screens/conversations/controllers/index.dart';
import '/screens/contacts/controllers/index.dart';
import '/screens/notifications/controllers/index.dart';
import '/imports.dart';

class BindingsConfig {
  Future<void> dependencies() async {
    // global services
    await Get.put(DeviceService()).init();
    await Get.put(DbService()).init();
    await Get.put(ApiService()).init();
    await Get.put(AuthService()).init();
    await Get.put(AnalyticsService()).init();
    await Get.put(AssistantService()).init();
    await Get.put(RealtimeService()).init();
    await Get.put(NotificationService()).init();
    await Get.put(TranslatorService()).init();

    // global controllers
    await Get.put(CannedResponsesController(), permanent: true).init();
    await Get.put(ContactsController(), permanent: true).init();
    await Get.put(CustomAttributesController(), permanent: true).init();
    await Get.put(InboxesController(), permanent: true).init();
    await Get.put(ConversationsController(), permanent: true).init();
    await Get.put(LabelsController(), permanent: true).init();
    await Get.put(MacrosController(), permanent: true).init();
    await Get.put(NotificationsController(), permanent: true).init();
    await Get.put(TeamsController(), permanent: true).init();
    await Get.put(AgentsController(), permanent: true).init();
  }
}
