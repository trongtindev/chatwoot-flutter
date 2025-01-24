import '../controllers/index.dart';
import '../widgets/item.dart';
import '/imports.dart';

class ConversationsView extends GetView<ConversationsController> {
  final labels = Get.find<LabelsController>();
  final realtimeService = Get.find<RealtimeService>();

  ConversationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.conversations),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined),
            onPressed: controller.showFilter,
          ),
          Padding(padding: EdgeInsets.only(right: 8)),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            notificationPredicate: (scrollNotification) {
              var pixels = scrollNotification.metrics.pixels;
              var maxScrollExtent = scrollNotification.metrics.maxScrollExtent;
              var isScrollEnded = pixels >= maxScrollExtent * 0.8;
              if (isScrollEnded) controller.loadMore();
              return defaultScrollNotificationPredicate(scrollNotification);
            },
            onRefresh: () => controller.getConversations(reset: true),
            child: Obx(() {
              if (controller.loading.value && controller.items.isEmpty) {
                return buildPlaceholder();
              } else if (controller.error.isNotEmpty) {
                return errorState(
                  context,
                  title: t.error,
                  error: controller.error.value,
                  onRetry: controller.getConversations,
                );
              } else if (controller.items.isEmpty) {
                return emptyState(
                  context,
                  image: 'conversations.png',
                  title: t.conversation_empty_title,
                  description: t.conversation_empty_description,
                );
              }

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.items.length,
                    itemBuilder: (_, i) {
                      final item = controller.items[i];
                      return ConversationItem(item);
                    },
                  ),
                  if (controller.is_load_more.value) loadMore(),
                  if (controller.is_no_more.value) noMore(),
                ],
              );
            }),
          ),
          Obx(() {
            if (controller.loading.value && !controller.is_load_more.value) {
              return Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: LinearProgressIndicator(),
                ),
              );
            }
            return Container();
          }),
        ],
      ),
    );
  }

  // TODO: make this better with skeleton
  Widget buildPlaceholder() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
