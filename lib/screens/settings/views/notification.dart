import '../controllers/notification.dart';
import '/imports.dart';

class SettingsNotificationView extends StatelessWidget {
  final controller = Get.put(SettingsNotificationController());

  SettingsNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings_notification),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          CustomListTile(
            title: Text(t.notification_create_push),
            trailing: Wrap(
              children: [
                Switch(
                  value: true,
                  onChanged: (value) {},
                ),
                Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          CustomListTile(
            title: Text(t.notification_assignee_push),
          ),
          CustomListTile(
            title: Text(t.notification_new_message_push),
          ),
          CustomListTile(
            title: Text(t.notification_mention_push),
          ),
          CustomListTile(
            title: Text(t.notification_participating_new_message_push),
          ),
        ],
      ),
    );
  }
}
