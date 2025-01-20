import '/imports.dart';
import '../../canned_response/views/index.dart';
import '../../labels/views/index.dart';
import '../controllers/index.dart';
import 'appearance.dart';
import 'profile.dart';

class SettingTab {
  String title;
  Widget Function()? page;
  IconData iconData;
  String? internalUrl;
  String? externalUrl;

  SettingTab({
    required this.title,
    required this.iconData,
    this.page,
    this.internalUrl,
    this.externalUrl,
  });
}

class SettingsView extends StatelessWidget {
  final auth = Get.find<AuthService>();

  SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      [
        SettingTab(
          iconData: Icons.account_circle_outlined,
          title: t.profile,
          page: () => SettingsProfileView(),
        ),
        SettingTab(
          iconData: Icons.lock_outline,
          title: t.change_password,
          page: () => SettingsProfileView(),
        ),
      ],
      [
        SettingTab(
          iconData: Icons.work_outline,
          title: t.account,
        ),
        SettingTab(
          iconData: Icons.support_agent_outlined,
          title: t.agents,
        ),
        SettingTab(
          iconData: Icons.groups_2_outlined,
          title: t.teams,
        ),
        SettingTab(
          iconData: Icons.all_inbox_outlined,
          title: t.inboxes,
        ),
        SettingTab(
          iconData: Icons.label_outline,
          title: t.labels,
          page: () => LabelsView(),
        ),
        SettingTab(
          iconData: Icons.code_outlined,
          title: t.custom_attributes,
        ),
        SettingTab(
          iconData: Icons.auto_mode_outlined,
          title: t.automation,
          internalUrl: 'settings/automation/list',
        ),
        SettingTab(
          iconData: Icons.code_outlined,
          title: t.macros,
          internalUrl: 'settings/macros',
        ),
        SettingTab(
          iconData: Icons.forum_outlined,
          title: t.canned_response,
          page: () => CannedResponseView(),
        ),
        SettingTab(
          iconData: Icons.integration_instructions_outlined,
          title: t.integrations,
          internalUrl: 'settings/integrations',
        ),
        SettingTab(
          iconData: Icons.history_outlined,
          title: t.audit_logs,
        ),
      ],
      [
        SettingTab(
          iconData: Icons.visibility_outlined,
          title: t.set_availability,
        ),
        SettingTab(
          iconData: Icons.notifications_outlined,
          title: t.notifications,
          page: () => SettingsProfileView(),
        ),
        SettingTab(
          iconData: Icons.format_paint_outlined,
          title: t.appearance,
          page: () => SettingsAppearanceView(),
        ),
        SettingTab(
          iconData: Icons.translate_outlined,
          title: t.change_language,
        ),
      ],
      [
        SettingTab(
          iconData: Icons.swap_horiz_outlined,
          title: t.read_docs,
          externalUrl: env.HELP_URL,
        ),
      ]
    ];

    return GetBuilder(
      init: SettingsController(),
      builder: (_) {
        if (GetPlatform.isDesktop) {
          return buildDesktop(items.expand((e) => e).toList());
        }
        return buildMobile(context, items);
      },
    );
  }

  Widget buildMobile(BuildContext context, List<List<SettingTab>> items) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Column(
            children: [
              Obx(() {
                var profile = auth.profile.value!;
                return profileInfo(context, profile: profile);
              }),
              warningButton(
                label: t.edit,
                onPressed: () {},
              ),
              Padding(padding: EdgeInsets.all(8)),
              ListView.builder(
                padding: EdgeInsets.all(4),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (_, i) {
                  return Card(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: items[i].length,
                      itemBuilder: (_, j) {
                        var item = items[i][j];
                        var trailingIcon = Icons.chevron_right;

                        if (item.internalUrl != null) {
                          trailingIcon = Icons.open_in_browser;
                        } else if (item.externalUrl != null) {
                          trailingIcon = Icons.open_in_new;
                        }

                        return ListTile(
                          leading: Icon(item.iconData),
                          title: Text(item.title),
                          trailing: Icon(trailingIcon),
                          onTap: () {
                            if (item.page != null) {
                              Get.to(item.page);
                            } else if (item.internalUrl != null) {
                              openInternalBrowser(item.internalUrl!);
                            } else if (item.externalUrl != null) {
                              openBrowser(item.externalUrl!);
                            }
                          },
                        );
                      },
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
          // Expanded(
          //   child: TabBarView(
          //     children: items.map((e) => e.container).toList(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
