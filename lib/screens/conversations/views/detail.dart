import '../controllers/chat.dart';
import '/screens/conversations/controllers/detail.dart';
import '/imports.dart';

class ConversationDetailView extends StatelessWidget {
  final macros = Get.find<MacrosController>();
  final labels = Get.find<LabelsController>();
  final realtime = Get.find<RealtimeService>();

  final int conversation_id;
  final ConversationDetailController c;
  final ConversationChatController base;

  ConversationDetailView({super.key, required this.conversation_id})
      : c = Get.put(
          ConversationDetailController(conversation_id: conversation_id),
          tag: '$conversation_id',
        ),
        base = Get.put(
          ConversationChatController(conversation_id: conversation_id),
          tag: '$conversation_id',
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          buildStatus(context),
          buildActions(context),
          buildMacros(context),
          buildLabels(context),
          buildParticipants(context),
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
    return Obx(() {
      final info = base.info.value!;
      final agent = info.meta.assignee;
      final team = info.meta.team;

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
    });
  }

  Widget buildMacros(BuildContext context) {
    return Obx(() {
      final items = macros.items.value;
      final executingId = c.executingMacroId.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabel(t.macros),
          Card(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];

                return CustomListTile(
                  enabled: executingId == null,
                  title: Text(item.name),
                  trailing: executingId == item.id
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        )
                      : Icon(Icons.play_circle),
                  onTap: () => c.executeMacro(item),
                );
              },
            ),
          ),
        ],
      );
    });
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
    return Obx(() {
      final items = c.participants.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabel(t.participants),
          Card(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 8,
                  children: items.map((e) {
                    return avatar(
                      context,
                      url: e.thumbnail,
                      isOnline: realtime.online.value.contains(e.id),
                      fallback: e.display_name.substring(0, 1),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      );
    });
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
