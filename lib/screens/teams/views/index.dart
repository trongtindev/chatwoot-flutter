import '/imports.dart';

class TeamsView extends GetView<TeamsController> {
  final auth = Get.find<AuthService>();
  final realtime = Get.find<RealtimeService>();

  TeamsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(t.teams_title),
              centerTitle: true,
              background: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    t.teams_description,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            final items = controller.items.value;

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => buildItem(context, items[i]),
                childCount: items.length,
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openInAppBrowser('settings/teams/new'),
        label: Text(t.teams_add),
        icon: Icon(Icons.add_outlined),
      ),
    );
  }

  Widget buildItem(BuildContext context, TeamInfo info) {
    final isAdmin = auth.profile.value!.role == UserRole.administrator;

    return CustomListTile(
      title: Text(info.name),
      trailing: Wrap(
        children: [
          if (isAdmin)
            IconButton.filledTonal(
              onPressed: () =>
                  openInAppBrowser('settings/teams/${info.id}/edit'),
              icon: Icon(Icons.settings_outlined),
            ),
          if (isAdmin)
            IconButton.filledTonal(
              onPressed: () => controller.delete(info),
              icon: Icon(
                Icons.delete_outline,
                color: context.theme.colorScheme.error,
              ),
            )
        ],
      ),
    );
  }
}
