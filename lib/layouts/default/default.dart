import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import '/screens/conversations/views/index.dart';
import '/screens/contacts/views/index.dart';
import '/screens/notifications/views/index.dart';
import '/screens/settings/views/index.dart';
import '/imports.dart';

class DefaultLayoutController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final tabIndex = 0.obs;
  late TabController tabController;

  DefaultLayoutController() {
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void onReady() {
    super.onReady();
    tabIndex.listen((next) => tabController.index = next);
  }
}

class DefaultLayout extends GetView<DefaultLayoutController> {
  const DefaultLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DefaultLayoutController(),
      builder: (_) {
        return Obx(() {
          var tabIndex = controller.tabIndex.value;
          return buildMobile(context, tabIndex);
        });
      },
    );
  }

  Widget buildMobile(BuildContext context, int tabIndex) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller.tabController,
        children: [
          ConversationsView(),
          NotificationsView(),
          ContactsView(),
          SettingsView(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabIndex,
        onDestinationSelected: (next) => controller.tabIndex.value = next,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat),
            label: 'conversation'.tr,
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'notifications'.tr,
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'contacts'.tr,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'settings'.tr,
          )
        ],
      ),
    );
  }
}
