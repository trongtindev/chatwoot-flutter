import '/imports.dart';

class CannedResponsesView extends StatelessWidget {
  final CannedResponsesController c;
  final auth = Get.find<AuthService>();

  CannedResponsesView({super.key}) : c = Get.find<CannedResponsesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(t.canned_responses),
              centerTitle: true,
              background: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    t.canned_responses_description,
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
                (_, i) {
                  final item = items[i];
                  return buildItem(context, item);
                },
                childCount: items.length,
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(t.canned_response_add),
        icon: Icon(Icons.add_outlined),
      ),
    );
  }

  Widget buildItem(BuildContext context, CannedResponseInfo info) {
    final isAdmin = auth.profile.value!.role == UserRole.administrator;

    return ListTile(
      contentPadding: EdgeInsets.only(left: 16, right: 8),
      title: Text(info.short_code),
      subtitle: Text(
        info.content.replaceAll('\n', ' '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Wrap(
        children: [
          if (isAdmin)
            IconButton.filledTonal(
              onPressed: () {},
              icon: Icon(Icons.edit_outlined),
            ),
          if (isAdmin)
            IconButton.filledTonal(
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
