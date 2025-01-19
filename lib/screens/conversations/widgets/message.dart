import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/state_manager.dart';
import '/imports.dart';

class Message extends GetWidget {
  final MessageInfo info;
  final BorderRadius borderRadius;

  const Message({
    super.key,
    required this.info,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthService>();

    switch (info.message_type) {
      case MessageType.incoming:
      case MessageType.outgoing:
        return buildMessage(context, auth);
      case MessageType.activity:
        return buildActivity(context);
      case MessageType.template:
        return buildTemplate(context, auth);
    }
  }

  Widget buildActivity(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Get.theme.colorScheme.tertiaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
          child: Text(
            info.content!,
            style: TextStyle(
              color: Get.theme.colorScheme.onTertiaryContainer,
              fontSize: Get.textTheme.labelMedium!.fontSize,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget buildTemplate(BuildContext context, AuthService auth) {
    var sender = MessageSenderInfo(
      id: 0,
      name: 'Bot',
      type: MessageSenderType.agent_bot,
      thumbnail: 'assets/images/bot-avatar.png',
    );
    return buildMessage(context, auth, sender: sender);
  }

  Widget buildMessage(BuildContext context, AuthService auth,
      {MessageSenderInfo? sender}) {
    sender ??= info.sender;

    var isOwner = sender?.id == auth.profile.value!.id;
    var isOtherAgent = info.sender == null;
    var backgroundColor = (() {
      if (isOtherAgent) return Get.theme.colorScheme.secondaryContainer;
      return isOwner
          ? Get.theme.colorScheme.primaryContainer
          : Get.theme.colorScheme.surfaceContainer;
    })();
    var alignment = isOwner ? Alignment.centerRight : Alignment.centerLeft;

    var created_at = formatTimeago(info.created_at);
    var statusIcon = (() {
      if (info.message_type == MessageType.incoming) return null;

      switch (info.status) {
        case MessageStatus.failed:
          return Icon(
            Icons.error_outline,
            size: 16,
            color: Get.theme.colorScheme.error,
          );
        case MessageStatus.sent:
          return Icon(
            Icons.task_alt,
            size: 16,
          );
        case MessageStatus.delivered:
          return Icon(
            Icons.task_alt,
            color: Get.theme.colorScheme.primary,
            size: 16,
          );
        case MessageStatus.progress:
          return SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        case MessageStatus.read:
          return Icon(
            Icons.done_all_outlined,
            size: 16,
            color: Get.theme.colorScheme.primary,
          );
      }
    })();

    return UnconstrainedBox(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.width * 0.75),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isOwner == false)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: avatar(
                  url: sender?.thumbnail,
                  isOnline:
                      sender?.availability_status == AvailabilityStatus.online,
                  fallback: sender?.name.substring(0, 1),
                  width: 28,
                  height: 28,
                ),
              ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(color: backgroundColor),
                  borderRadius: borderRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (info.attachments.isNotEmpty) buildAttachments(context),
                    if (info.content != null && info.content!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 8,
                        ),
                        child: MarkdownBody(
                          data: info.content!.trim(),
                          selectable: true,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          if (isOwner == false)
                            Text(
                              sender!.available_name ?? sender.name,
                              style: TextStyle(
                                fontSize: Get.textTheme.labelSmall!.fontSize,
                              ),
                            ),
                          Text(
                            created_at,
                            style: TextStyle(
                              fontSize: Get.textTheme.labelSmall!.fontSize,
                            ),
                          ),
                          if (statusIcon != null)
                            Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: statusIcon,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAttachments(BuildContext context) {
    return buildAttachment(info.attachments.first);
  }

  Widget buildAttachment(MessageAttachmentInfo info) {
    switch (info.file_type) {
      case AttachmentType.image:
        return buildImageAttachment(info);
      default:
        return Text('failed to parse attachment type: ${info.file_type.name}');
    }
  }

  Widget buildImageAttachment(MessageAttachmentInfo info) {
    var width = info.width != null ? info.width!.toDouble() : 16;
    var height = info.height != null ? info.height!.toDouble() : 9;

    return InkWell(
      onTap: () => Get.to(
        () => imageViewer(
          url: info.data_url!,
          title: '#${info.id} (${formatBytes(info.file_size!)})',
        ),
      ),
      child: AspectRatio(
        aspectRatio: width / height,
        child: Container(
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surfaceContainerHigh,
          ),
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.only(
              topLeft: borderRadius.topLeft,
              topRight: borderRadius.topRight,
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
            child: ExtendedImage.network(
              info.data_url!,
              loadStateChanged: (state) {
                switch (state.extendedImageLoadState) {
                  case LoadState.failed:
                    return Center(
                      child: Text('?'),
                    );
                  case LoadState.loading:
                    return ExtendedImage.network(info.thumb_url!);
                  default:
                    return null;
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
