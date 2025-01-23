import 'package:flutter_markdown/flutter_markdown.dart';
import '/imports.dart';

class Message extends StatelessWidget {
  final auth = Get.find<AuthService>();
  final realtime = Get.find<RealtimeService>();

  final MessageInfo info;
  final BorderRadius borderRadius;

  Message({
    super.key,
    required this.info,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
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
          color: context.theme.colorScheme.tertiaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
          child: Text(
            info.content!,
            style: TextStyle(
              color: context.theme.colorScheme.onTertiaryContainer,
              fontSize: Get.textTheme.labelMedium!.fontSize,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget buildTemplate(BuildContext context, AuthService auth) {
    return buildMessage(context, auth);
  }

  Widget buildMessage(BuildContext context, AuthService auth) {
    final sender = info.sender ??
        UserInfo(
          id: 0,
          name: 'Bot',
          type: UserType.agent_bot,
          thumbnail: 'assets/images/bot-avatar.png',
        );

    final isOwner = sender.id == auth.profile.value!.id;
    final isAgent = !isOwner && sender.type == UserType.user;
    final backgroundColor = (() {
      if (info.private) return context.theme.colorScheme.tertiaryContainer;
      if (isAgent) return context.theme.colorScheme.secondaryContainer;
      return isOwner
          ? context.theme.colorScheme.primaryContainer
          : context.theme.colorScheme.surfaceContainer;
    })();
    final alignment = isOwner ? Alignment.centerRight : Alignment.centerLeft;

    final created_at = formatTimeago(info.created_at);
    final statusIcon = (() {
      if (info.message_type == MessageType.incoming) return null;
      if (info.content_attributes.deleted) {
        return Icon(
          Icons.remove_circle_outline,
          size: 16,
          color: context.theme.colorScheme.tertiary,
        );
      }

      switch (info.status) {
        case MessageStatus.failed:
          return Icon(
            Icons.error_outline,
            size: 16,
            color: context.theme.colorScheme.error,
          );
        case MessageStatus.sent:
          return Icon(
            Icons.task_alt,
            size: 16,
          );
        case MessageStatus.delivered:
          return Icon(
            Icons.task_alt,
            color: context.theme.colorScheme.primary,
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
            color: context.theme.colorScheme.primary,
          );
        default:
          return Icon(
            Icons.question_mark_outlined,
            size: 16,
            color: context.theme.colorScheme.primary,
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
                child: Obx(() {
                  final online = realtime.online;
                  return avatar(
                    context,
                    url: sender.thumbnail,
                    isOnline: online.contains(sender.id),
                    fallback: sender.name.substring(0, 1),
                    size: 28,
                  );
                }),
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
                      buildContent(context),
                    // TODO: align right
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          if (info.private)
                            Text(
                              t.private,
                              style: TextStyle(
                                fontSize: Get.textTheme.labelSmall!.fontSize,
                              ),
                            ),
                          if (isOwner == false)
                            Text(
                              sender.display_name,
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

  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
      ),
      child: MarkdownBody(
        data: info.content!.trim(),
        selectable: true,
        onTapLink: (text, href, title) {
          if (href == null || href.isEmpty) return;
          openBrowser(href);
        },
      ),
    );
  }

  Widget buildAttachments(BuildContext context) {
    final length = info.attachments.length;

    final first = info.attachments.first;
    if (length == 1 && first.data_url != null) {
      switch (first.file_type) {
        case AttachmentType.audio:
          return AudioPlayer(
            id: first.id,
            url: first.data_url!,
          );
        case AttachmentType.image:
          return buildImageAttachment(context, info: info.attachments.first);
        default:
          return Text('failed to parse attachment type: ${first.file_type}');
      }
    }

    return Text('failed to parse $length attachments');
  }

  Widget buildImageAttachment(
    BuildContext context, {
    required MessageAttachmentInfo info,
  }) {
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
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surfaceContainerHigh,
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
