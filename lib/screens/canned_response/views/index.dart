import '../controllers/index.dart';
import '/imports.dart';

class CannedResponseView extends GetView<CannedResponseController> {
  const CannedResponseView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CannedResponseController(),
      builder: (_) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(t.canned_response),
                  centerTitle: true,
                  background: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        t.canned_response_description,
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
      },
    );
  }
}
