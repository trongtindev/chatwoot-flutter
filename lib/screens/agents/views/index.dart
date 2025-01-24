import '/imports.dart';

class AgentsView extends GetView<AgentsController> {
  final auth = Get.find<AuthService>();
  final realtime = Get.find<RealtimeService>();
  late final AgentsController c;

  AgentsView({super.key}) : c = Get.put(AgentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(t.agents_title),
              centerTitle: true,
              background: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    t.agents_description,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            final items = c.items.value;

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
        onPressed: controller.add,
        label: Text(t.agents_add),
        icon: Icon(Icons.add_outlined),
      ),
    );
  }

  Widget buildItem(BuildContext context, UserInfo info) {
    final isAdmin = auth.profile.value!.role == UserRole.administrator;

    return CustomListTile(
      leading: Obx(() {
        return avatar(
          context,
          url: info.thumbnail,
          isOnline: realtime.online.value.contains(info.id),
          fallback: info.name.substring(0, 1),
        );
      }),
      title: Text(info.name),
      subtitle: Text(info.role.label),
      trailing: Wrap(
        children: [
          if (isAdmin)
            IconButton.filledTonal(
              onPressed: () {},
              icon: Icon(Icons.edit_outlined),
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
