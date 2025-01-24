import '/imports.dart';

class MacrosView extends GetView<MacrosController> {
  final auth = Get.find<AuthService>();

  MacrosView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MacrosController(),
      builder: (_) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(t.macros_title),
                  centerTitle: true,
                  background: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        t.macros_description,
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
            onPressed: () => openInAppBrowser('settings/macros/new'),
            label: Text(t.macros_add),
            icon: Icon(Icons.add_outlined),
          ),
        );
      },
    );
  }

  Widget buildItem(BuildContext context, MacroInfo info) {
    final isAdmin = auth.profile.value!.role == UserRole.administrator;

    return ListTile(
      contentPadding: EdgeInsets.only(left: 16, right: 8),
      title: Text(info.name),
      subtitle: Text(info.visibility.label),
      trailing: Wrap(
        children: [
          if (isAdmin)
            IconButton.filledTonal(
              onPressed: () =>
                  openInAppBrowser('settings/macros/${info.id}/edit'),
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
