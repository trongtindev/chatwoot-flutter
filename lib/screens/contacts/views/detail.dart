import '../../conversations/widgets/item.dart';
import '/screens/contacts/controllers/detail.dart';
import '/imports.dart';

class ContactDetailView extends StatelessWidget {
  final labels = Get.find<LabelsController>();
  final realtime = Get.find<RealtimeService>();
  final attributeService = Get.find<CustomAttributesController>();

  final ContactDetailController c;
  final int id;

  ContactDetailView({
    super.key,
    required this.id,
    ContactInfo? initial,
  }) : c = Get.put(ContactDetailController(id, initial: initial), tag: '$id');

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final info = c.info.value;
      if (info == null) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(child: CircularProgressIndicator()),
        );
      }

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
                  title: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      info.name,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  centerTitle: true,
                  background: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: avatar(
                        context,
                        url: info.thumbnail,
                        size: 96,
                        isOnline: realtime.online.contains(info.id),
                        fallback: info.name.substring(0, 1),
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.edit_outlined),
                    onPressed: () {},
                  ),
                  Padding(padding: EdgeInsets.only(right: 8)),
                ],
              ),
            ];
          },
          body: Builder(
            builder: (_) {
              return ListView(
                padding: EdgeInsets.all(4),
                children: [
                  buildActions(),
                  buildProfile(info),
                  buildLabels(context),
                  buildConversations(context),
                  buildAdditionalAttributes(info.additional_attributes),
                  buildCustomAttributes(info.custom_attributes),
                ],
              );
            },
          ),
        ),
      );
    });
  }

  Widget buildActions() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 2 / 1.25,
      padding: EdgeInsets.all(8),
      crossAxisCount: 3,
      children: [
        buildAction(
          iconData: Icons.call_outlined,
          label: t.call,
        ),
        buildAction(
          iconData: Icons.chat_outlined,
          label: t.message,
        ),
        buildAction(
          iconData: Icons.email_outlined,
          label: t.email,
        ),
      ],
    );
  }

  Widget buildAction({
    required IconData iconData,
    required String label,
  }) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Expanded(child: Icon(iconData)),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfile(ContactInfo info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(t.profile),
        Card(
          child: Column(
            children: [
              if (info.phone_number != null && info.phone_number!.isNotEmpty)
                buildAttribute(
                  label: t.phone,
                  value: info.phone_number!,
                  iconData: Icons.phone_outlined,
                ),
              if (info.email != null && info.email!.isNotEmpty)
                buildAttribute(
                  label: t.email,
                  value: info.email!,
                  iconData: Icons.email_outlined,
                ),
              if (info.last_activity_at != null)
                buildAttribute(
                  label: t.last_activity_at,
                  value: formatTimeago(info.last_activity_at!),
                  iconData: Icons.visibility_outlined,
                ),
              if (info.created_at != null)
                buildAttribute(
                  label: t.created_at,
                  value: formatTimeago(info.created_at!),
                  iconData: Icons.more_time_outlined,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLabels(BuildContext context) {
    return Obx(() {
      final items = c.labels.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabel(t.labels),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Wrap(
              spacing: 8,
              children: [
                ...items.map((e) {
                  final label = labels.items
                      .firstWhereOrNull((label) => label.title == e);

                  return Chip(
                    label: Row(
                      spacing: 8,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: label?.color ??
                                context.theme.colorScheme.surfaceContainerHigh,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        Text(e),
                      ],
                    ),
                    // deleteIcon: Icon(Icons.label_off_outlined),
                    // onDeleted: () {},
                  );
                }),
                Chip(
                  label: Text(t.modify),
                  deleteIcon: Icon(Icons.edit),
                  onDeleted: c.modifyLabels,
                )
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget buildConversations(BuildContext context) {
    return Obx(() {
      final items = c.conversations.value;
      if (items.isEmpty) return Container();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabel(t.conversations),
          Card(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                return ConversationItem(item, compact: true);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget buildAdditionalAttributes(
      ContactAdditionalAttributes additional_attributes) {
    final unavailableText = t.unavailable;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(t.attributes),
        Card(
          child: Column(
            children: [
              buildAttribute(
                label: t.city,
                value:
                    valueOrDefault(additional_attributes.city, unavailableText),
                iconData: Icons.location_on_outlined,
              ),
              buildAttribute(
                label: t.country,
                value: valueOrDefault(
                    additional_attributes.country, unavailableText),
                iconData: Icons.public_outlined,
              ),
              buildAttribute(
                label: t.company,
                value: valueOrDefault(
                    additional_attributes.company_name, unavailableText),
                iconData: Icons.work_outline,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCustomAttributes(Map<String, dynamic> custom_attributes) {
    final items = custom_attributes.entries.toList();
    if (items.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(t.custom_attributes),
        Card(
          child: Obx(() {
            final attributes = attributeService.items.value;

            return ListView.builder(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                final label = attributes
                    .firstWhereOrNull((e) => e.attribute_key == item.key);
                return buildAttribute(
                  label:
                      label != null ? label.attribute_display_name : item.key,
                  value: item.value,
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget buildAttribute({
    required String label,
    required String value,
    IconData? iconData,
  }) {
    return CustomListTile(
      leading: iconData != null ? Icon(iconData) : null,
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
