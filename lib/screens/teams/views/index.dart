import '/imports.dart';

class TeamsView extends GetView<TeamsController> {
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
    );
  }

  Widget buildItem(BuildContext context, TeamInfo info) {
    return ListTile(
      leading: CircleAvatar(),
      title: Text(info.name),
    );
  }
}
