import '/screens/conversations/controllers/index.dart';
import '/screens/notifications/controllers/index.dart';
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
  void onInit() {
    super.onInit();
    tabController.addListener(_onTabController);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void _onTabController() {
    if (tabController.index == tabIndex.value) return;
    tabIndex.value = tabController.index;
  }
}

class DefaultLayout extends GetView<DefaultLayoutController> {
  final theme = Get.find<ThemeService>();
  final conversations = Get.find<ConversationsController>();
  final notifications = Get.find<NotificationsController>();

  DefaultLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DefaultLayoutController(),
      builder: (_) {
        if (GetPlatform.isDesktop) {
          return buildDesktop(context);
        }
        return buildMobile(context);
      },
    );
  }

  Widget buildMobile(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller.tabController,
        children: [
          ConversationsView(),
          NotificationsView(),
          ContactsView(),
          SettingsView(),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final tabIndex = controller.tabIndex.value;
        final conversations_unread_count = conversations.unread_count.value;
        final notifications_unread_count = notifications.unread_count.value;

        return NavigationBar(
          selectedIndex: tabIndex,
          onDestinationSelected: (next) =>
              controller.tabController.index = next,
          destinations: [
            NavigationDestination(
              icon: Badge(
                isLabelVisible: conversations_unread_count > 0,
                label: Text('$conversations_unread_count'),
                child: Icon(Icons.chat_outlined),
              ),
              label: t.conversations,
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: notifications_unread_count > 0,
                label: Text('$notifications_unread_count'),
                child: Icon(Icons.notifications_outlined),
              ),
              label: t.notifications,
            ),
            NavigationDestination(
              icon: Icon(Icons.group_outlined),
              label: t.contacts,
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              label: t.settings,
            )
          ],
        );
      }),
    );
  }

  Widget buildDesktop(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surfaceContainer,
      body: Row(
        children: [
          buildDesktopNavigationRail(context),
          Expanded(
            child: GetRouterOutlet(
              initialRoute: '/',
              anchorRoute: '/',
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDesktopNavigationRail(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: buildDesktopNavigationRailDestination(context),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CircleAvatar(),
        ),
      ],
    );
  }

  Widget buildDesktopNavigationRailDestination(BuildContext context) {
    return Obx(() {
      final tabIndex = controller.tabIndex.value;
      final conversations_unread_count = conversations.unread_count.value;
      final notifications_unread_count = notifications.unread_count.value;

      return NavigationRail(
        backgroundColor: context.theme.colorScheme.surfaceContainer,
        selectedIndex: tabIndex,
        onDestinationSelected: (value) => controller.tabIndex.value = value,
        destinations: [
          NavigationRailDestination(
            icon: Badge(
              isLabelVisible: conversations_unread_count > 0,
              label: Text('$conversations_unread_count'),
              child: Icon(Icons.chat_outlined),
            ),
            label: Text(t.conversations),
          ),
          NavigationRailDestination(
            icon: Badge(
              isLabelVisible: notifications_unread_count > 0,
              label: Text('$notifications_unread_count'),
              child: Icon(Icons.notifications_outlined),
            ),
            label: Text(t.notifications),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.group_outlined),
            label: Text(t.contacts),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.settings_outlined),
            label: Text(t.settings),
          ),
        ],
      );
    });
  }
}
