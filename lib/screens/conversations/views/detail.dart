import '../controllers/chat.dart';
import '/screens/conversations/controllers/detail.dart';
import '/imports.dart';

class ConversationDetailView extends StatelessWidget {
  final labels = Get.find<LabelsController>();
  final realtime = Get.find<RealtimeService>();

  final int id;
  final ConversationDetailController c;
  final ConversationChatController base;

  ConversationDetailView({super.key, required this.id})
      : c = Get.put(ConversationDetailController(id: id), tag: '$id'),
        base = Get.put(ConversationChatController(id: id), tag: '$id');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
        children: [
          buildStatus(context),
          buildActions(context),
          buildLabels(context),
          // buildParticipants(context),
          buildAttributes(context),
        ],
      ),
    );
  }

  Widget buildStatus(BuildContext context) {
    final items =
        ConversationStatus.values.where((e) => e != ConversationStatus.all);

    return Obx(() {
      final info = base.info.value!;

      return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 3 / 4,
        padding: EdgeInsets.all(8),
        crossAxisSpacing: 8,
        crossAxisCount: items.length,
        children: items.map((e) {
          return Container(
            decoration: BoxDecoration(
              color: e.color,
              border:
                  e == info.status ? Border.all(color: e.outlineColor) : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: () => c.changeStatus(e),
              child: Column(
                children: [
                  Expanded(child: Icon(e.icon)),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Text(e.label),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget buildActions(BuildContext context) {
    final agent = base.info.value!.meta.assignee;
    final team = base.info.value!.meta.team;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(t.actions),
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (agent != null)
                ListTile(
                  leading: Obx(() {
                    return avatar(
                      context,
                      url: agent.thumbnail,
                      isOnline: realtime.online.contains(agent.id),
                    );
                  }),
                  title: Text(t.agent),
                  subtitle: Text(agent.name),
                  trailing: Icon(Icons.chevron_right_outlined),
                  onTap: c.showAgentAssign,
                )
              else
                ListTile(
                  leading: CircleAvatar(),
                  title: Text(t.agent),
                  subtitle: Text(t.unassigned),
                  trailing: Icon(Icons.chevron_right_outlined),
                  onTap: c.showAgentAssign,
                ),
              if (team != null)
                ListTile(
                  leading: avatar(
                    context,
                    fallback: team.name.substring(0, 1),
                  ),
                  title: Text(t.team),
                  subtitle: Text(team.name),
                  trailing: Icon(Icons.chevron_right_outlined),
                  onTap: c.showTeamAssign,
                )
              else
                ListTile(
                  leading: CircleAvatar(),
                  title: Text(t.team),
                  subtitle: Text(t.unassigned),
                  trailing: Icon(Icons.chevron_right_outlined),
                  onTap: c.showTeamAssign,
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLabels(BuildContext context) {
    return Obx(() {
      final items = base.info.value!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabel(t.labels),
          Wrap(
            spacing: 8,
            children: [
              ...items.labels.map((e) {
                final label =
                    labels.items.firstWhereOrNull((label) => label.title == e);

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
                  // onDeleted: label == null ? null : () => c.removeLabel(label),
                );
              }),
              Chip(
                label: Text(t.modify),
                onDeleted: c.showLabelPicker,
                deleteIcon: Icon(Icons.edit),
              )
            ],
          ),
        ],
      );
    });
  }

  Widget buildParticipants(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [buildLabel(t.participants), Text('buildParticipants')],
    );
  }

  Widget buildAttributes(BuildContext context) {
    final attributes = base.info.value!.additional_attributes;
    if (attributes == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(t.attributes),
        Card(
          child: Column(
            children: [
              ListTile(
                title: Text(t.conversation_id),
                subtitle: Text('${base.info.value!.id}'),
              ),
              if (attributes.initiated_at != null)
                ListTile(
                  title: Text(t.initiated_at),
                  subtitle: Text(attributes.initiated_at.toString()),
                ),
              if (attributes.initiated_from != null)
                ListTile(
                  title: Text(t.initiated_from),
                  subtitle: Text(attributes.initiated_from!),
                ),
              if (attributes.initiated_from != null)
                ListTile(
                  title: Text(t.initiated_from),
                  subtitle: Text(attributes.initiated_from.toString()),
                ),
              if (attributes.browser != null) ...[
                ListTile(
                  title: Text(t.browser),
                  subtitle: Text(attributes.browser!.browser_name),
                ),
                ListTile(
                  title: Text(t.operating_system),
                  subtitle: Text(
                      '${attributes.browser!.platform_name} ${attributes.browser!.platform_version}'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
