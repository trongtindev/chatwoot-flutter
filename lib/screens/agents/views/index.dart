import '/imports.dart';

class AgentsView extends GetView<AgentsController> {
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
    );
  }

  Widget buildItem(BuildContext context, UserInfo info) {
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
    );
  }
}
