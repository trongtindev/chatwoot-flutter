import '/imports.dart';
import '../../agents/views/index.dart';
import '../../audit_logs/views/index.dart';
import '../../custom_attributes/views/index.dart';
import '../../inboxes/views/index.dart';
import '../../macros/views/index.dart';
import '../../teams/views/index.dart';
import '../../canned_responses/views/index.dart';
import '../../labels/views/index.dart';
import '../controllers/index.dart';
import 'appearance.dart';
import 'change_password.dart';
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

class SettingsView extends GetView<SettingsController> {
  final authService = Get.find<AuthService>();

  SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = authService.profile.value!.role == UserRole.administrator;
    final items = [
      [
        SettingTab(
          iconData: Icons.account_circle_outlined,
          title: t.profile,
          page: () => SettingsProfileView(),
        ),
        SettingTab(
          iconData: Icons.visibility_outlined,
          title: t.set_availability,
        ),
        SettingTab(
          iconData: Icons.lock_outline,
          title: t.change_password,
          page: () => SettingsChangePasswordView(),
        ),
      ],
      [
        if (isAdmin)
          SettingTab(
            iconData: Icons.work_outline,
            title: t.account,
          ),
        if (isAdmin)
          SettingTab(
            iconData: Icons.support_agent_outlined,
            title: t.agents,
            page: () => AgentsView(),
          ),
        if (isAdmin)
          SettingTab(
            iconData: Icons.groups_2_outlined,
            title: t.teams,
            page: () => TeamsView(),
          ),
        if (isAdmin)
          SettingTab(
            iconData: Icons.all_inbox_outlined,
            title: t.inboxes,
            page: () => InboxesView(),
          ),
        if (isAdmin)
          SettingTab(
            iconData: Icons.label_outline,
            title: t.labels,
            page: () => LabelsView(),
          ),
        if (isAdmin)
          SettingTab(
            iconData: Icons.code_outlined,
            title: t.custom_attributes,
            page: () => CustomAttributesView(),
          ),
        if (isAdmin)
          SettingTab(
            iconData: Icons.auto_mode_outlined,
            title: t.automation,
            internalUrl: 'settings/automation/list',
          ),
        SettingTab(
          iconData: Icons.code_outlined,
          title: t.macros,
          page: () => MacrosView(),
        ),
        SettingTab(
          iconData: Icons.forum_outlined,
          title: t.canned_responses,
          page: () => CannedResponsesView(),
        ),
        if (isAdmin)
          SettingTab(
            iconData: Icons.integration_instructions_outlined,
            title: t.integrations,
            internalUrl: 'settings/integrations',
          ),
        if (isAdmin)
          SettingTab(
            iconData: Icons.history_outlined,
            title: t.audit_logs,
            page: () => AuditLogsView(),
          ),
      ],
      [
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
    return GetBuilder(
      init: SettingsController(),
      builder: (_) {
        final profile = authService.profile.value;
        if (profile == null) return Scaffold();

        return Scaffold(
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: 250.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        profile.display_name,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    centerTitle: true,
                    background: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: avatar(
                          context,
                          url: profile.avatar_url,
                          size: 96,
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: ListView(
              padding: EdgeInsets.all(4),
              children: [
                Column(
                  children: [
                    warningButton(
                      label: t.logout,
                      appendIcon: Icon(Icons.logout_outlined),
                      onPressed: controller.logout,
                    ),
                    ListView.builder(
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

                              return CustomListTile(
                                leading: Icon(item.iconData),
                                title: Text(item.title),
                                trailing: Icon(trailingIcon),
                                onTap: () {
                                  if (item.page != null) {
                                    Get.to(item.page!);
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
          ),
        );
      },
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
