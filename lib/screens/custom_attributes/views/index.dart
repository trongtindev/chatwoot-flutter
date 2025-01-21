import '../controllers/index.dart';
import '/imports.dart';

class CustomAttributesView extends GetView<CustomAttributesController> {
  final authService = Get.find<AuthService>();
  final service = Get.find<CustomAttributeService>();

  CustomAttributesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CustomAttributesController(),
      builder: (_) {
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
                    title: Text(t.custom_attributes_title),
                    centerTitle: true,
                    background: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          t.custom_attributes_description,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    controller: controller.tabController,
                    tabs: AttributeModel.values.map((e) {
                      return Tab(
                        text: e.label,
                      );
                    }).toList(),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: controller.tabController,
              children: AttributeModel.values.map((e) {
                return buildList(context, e);
              }).toList(),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            label: Text(t.custom_attributes_add),
            icon: Icon(Icons.add_outlined),
          ),
        );
      },
    );
  }

  Widget buildList(BuildContext context, AttributeModel model) {
    return Obx(() {
      final items =
          service.items.value.where((e) => e.attribute_model == model);
      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: items.length,
        itemBuilder: (_, i) {
          return buildItem(context, items.elementAt(i));
        },
      );
    });
  }

  Widget buildItem(BuildContext context, CustomAttribute info) {
    final isAdmin = authService.profile.value!.role == UserRole.administrator;
    return ListTile(
      title: Text(info.attribute_display_name),
      subtitle: Text(info.attribute_description),
      trailing: Wrap(
        children: [
          if (isAdmin)
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit_outlined),
            ),
          if (isAdmin)
            IconButton(
              onPressed: () {},
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
