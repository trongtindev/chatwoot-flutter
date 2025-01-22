import '/imports.dart';

class InboxesView extends GetView<InboxesController> {
  const InboxesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: InboxesController(),
      builder: (_) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(t.inboxes_title),
                  centerTitle: true,
                  background: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        t.inboxes_description,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Obx(() {
                final items = controller.inboxes.value;

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
            onPressed: () {},
            label: Text(t.inboxes_add),
            icon: Icon(Icons.add_outlined),
          ),
        );
      },
    );
  }

  Widget buildItem(BuildContext context, InboxInfo info) {
    return ListTile(
      leading: isNullOrEmpty(info.avatar_url)
          ? info.channel_type.icon
          : avatar(
              context,
              url: info.avatar_url,
              fallback: info.name.substring(0, 1),
            ),
      title: Text(info.name),
      subtitle: Text(info.channel_type.name),
      trailing: Icon(Icons.open_in_browser_outlined),
    );
  }
}
