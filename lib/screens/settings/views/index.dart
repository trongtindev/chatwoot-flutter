import '/imports.dart';
import '../controllers/index.dart';
import 'appearance.dart';
import 'profile.dart';

class SettingTab {
  IconData iconData;
  String title;
  Widget container;

  SettingTab({
    required this.iconData,
    required this.title,
    required this.container,
  });
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(context) {
    final items = [
      [
        SettingTab(
          iconData: Icons.account_circle_outlined,
          title: 'settings.profile'.tr,
          container: SettingsProfileView(),
        ),
        SettingTab(
          iconData: Icons.lock_outline,
          title: 'settings.change_password'.tr,
          container: SettingsProfileView(),
        ),
      ],
      [
        SettingTab(
          iconData: Icons.notifications_outlined,
          title: 'settings.set_availability'.tr,
          container: Text('ok'),
        ),
        SettingTab(
          iconData: Icons.notifications_outlined,
          title: 'settings.notifications'.tr,
          container: SettingsProfileView(),
        ),
        SettingTab(
          iconData: Icons.format_paint_outlined,
          title: 'settings.appearance'.tr,
          container: SettingsAppearanceView(),
        ),
        SettingTab(
          iconData: Icons.translate_outlined,
          title: 'settings.languages'.tr,
          container: Text('ok'),
        ),
      ],
      [
        SettingTab(
          iconData: Icons.swap_horiz_outlined,
          title: 'settings.read_docs'.tr,
          container: Text('ok'),
        ),
        SettingTab(
          iconData: Icons.live_help_outlined,
          title: 'settings.chat_with_us'.tr,
          container: Text('ok'),
        ),
      ]
    ];

    return GetBuilder(
      init: SettingsController(),
      builder: (_) {
        if (GetPlatform.isDesktop) {
          return buildDesktop(items.expand((e) => e).toList());
        }
        return buildMobile(items);
      },
    );
  }

  Widget buildMobile(List<List<SettingTab>> items) {
    final auth = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
        children: [
          Column(
            children: [
              Obx(() {
                return profileInfo(auth.profile.value!);
              }),
              warningButton(
                label: 'edit'.tr,
                onPressed: () {},
              ),
              Padding(padding: EdgeInsets.all(8)),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (_, i) {
                  return Card(
                    child: ListView.builder(
                      itemCount: items[i].length,
                      itemBuilder: (_, j) {
                        var item = items[i][j];
                        return ListTile(
                          leading: Icon(item.iconData),
                          title: Text(item.title),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () => Get.to(() => item.container),
                        );
                      },
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDesktop(List<SettingTab> items) {
    return DefaultTabController(
      length: items.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: items.map((e) {
              return Tab(
                child: Text(e.title),
              );
            }).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: items.map((e) => e.container).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
