import '/screens/conversations/controllers/index.dart';
import '/imports.dart';

class ConversationItem extends StatelessWidget {
  final labels = Get.find<LabelsController>();
  final realtime = Get.find<RealtimeService>();
  final controller = Get.find<ConversationsController>();

  final ConversationInfo info;
  final bool compact;

  ConversationItem(
    this.info, {
    super.key,
    bool? compact,
  }) : compact = compact != null && compact;

  @override
  Widget build(
    BuildContext context,
  ) {
    final last_activity_at = formatTimeago(info.last_activity_at);
    final typeIcon = (() {
      var type = info.messages.first.message_type;
      switch (type) {
        case MessageType.incoming:
          return Icons.subdirectory_arrow_right_outlined;
        default:
          return null;
      }
    })();

    return CustomListTile(
      isThreeLine: info.labels.isNotEmpty && !compact,
      leading: compact
          ? null
          : Obx(() {
              return avatar(
                context,
                url: info.meta.sender.thumbnail,
                fallback: info.meta.sender.name.substring(0, 1),
                isOnline: realtime.online.contains(info.meta.sender.id),
                isTyping: realtime.typingUsers.contains(info.meta.sender.id),
              );
            }),
      title: Row(
        children: [
          Expanded(
            child: Text(
              info.meta.sender.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Text(
            last_activity_at,
            style: TextStyle(
              fontSize: Get.textTheme.labelSmall!.fontSize,
              color: context.theme.colorScheme.outline,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 4,
            children: [
              if (typeIcon != null)
                Icon(
                  typeIcon,
                  size: 16,
                  color: context.theme.colorScheme.outline,
                ),
              buildLastMessage(context, info),
              if (info.unread_count > 0)
                Badge(label: Text('${info.unread_count}')),
              if (info.last_non_activity_message != null &&
                  info.last_non_activity_message?.sender?.id !=
                      info.meta.sender.id)
                avatar(
                  context,
                  size: 18,
                  url: info.last_non_activity_message?.sender?.thumbnail,
                ),
            ],
          ),
          if (info.labels.isNotEmpty && !compact)
            Obx(() {
              final items = labels.items.value;

              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  height: 34,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: info.labels.length,
                    itemBuilder: (_, i) {
                      final title = info.labels[i];
                      final label =
                          items.firstWhereOrNull((e) => e.title == title);

                      return Padding(
                        padding: EdgeInsets.only(left: i > 0 ? 8 : 0),
                        child: buildLabelItem(
                          context,
                          info.labels[i],
                          info: label,
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
        ],
      ),
      tileColor: info.unread_count > 0
          ? context.theme.colorScheme.primaryContainer
          : null,
      onTap: () => controller.onTap(info),
    );
  }

  Widget buildLastMessage(BuildContext context, ConversationInfo info) {
    final message = info.last_non_activity_message;
    final content = (() {
      if (message == null) return null;

      if (message.attachments.isNotEmpty) {
        if (message.attachments.length == 1) {
          return message.attachments.first.file_type.label;
        } else {
          return t.attachment_files_content;
        }
      }

      switch (message.content_type) {
        case MessageContentType.text:
          return message.content;
        default:
          return message.content_type.name;
      }
    })();

    if (content == null) return Container();
    return Expanded(
      child: Text(
        content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: context.theme.colorScheme.outline,
        ),
      ),
    );
  }

  Widget buildLabelItem(BuildContext context, String title, {LabelInfo? info}) {
    return Chip(
      label: Row(
        spacing: 4,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color:
                  info?.color ?? context.theme.colorScheme.surfaceContainerHigh,
              border: Border.all(),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Text(title),
        ],
      ),
      padding: EdgeInsets.zero,
    );
  }
}
