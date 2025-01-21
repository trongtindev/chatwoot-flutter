import '../controllers/index.dart';
import '/imports.dart';

class MacrosView extends GetView<MacrosController> {
  final authService = Get.find<AuthService>();
  final service = Get.find<MacroService>();

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
                final items = service.items.value;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      return buildItem(context, items[i]);
                    },
                    childCount: items.length,
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget buildItem(BuildContext context, MacroInfo info) {
    final isAdmin = authService.profile.value!.role == UserRole.administrator;
    return ListTile(
      contentPadding: EdgeInsets.only(left: 16, right: 8),
      title: Text(info.name),
      subtitle: Text(info.visibility.label),
      trailing: Wrap(
        children: [
          if (isAdmin)
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit_outlined),
            ),
          if (isAdmin)
            IconButton(
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
