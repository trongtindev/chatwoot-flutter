import '../controllers/index.dart';
import '/imports.dart';

class AgentsView extends GetView<AgentsController> {
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                return ListTile(
                  leading: Container(
                      padding: EdgeInsets.all(8),
                      width: 100,
                      child: Placeholder()),
                  title: Text('Place ${index + 1}'),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
