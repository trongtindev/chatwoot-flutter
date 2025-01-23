import '/screens/conversations/controllers/input.dart';
import '/imports.dart';

class ConversationInput extends StatelessWidget {
  final int id;
  late final ConversationInputController c;
  late final CannedResponsesController cannedResponses;

  ConversationInput({
    super.key,
    required this.id,
  })  : c = Get.put(ConversationInputController(id: id), tag: '$id'),
        cannedResponses = Get.find<CannedResponsesController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: c.onPopInvokedWithResult,
      child: Obx(() {
        final isPrivate = c.isPrivate.value;
        return Container(
          decoration: BoxDecoration(
            color: isPrivate
                ? context.theme.colorScheme.tertiaryContainer
                : context.theme.colorScheme.surfaceContainer,
          ),
          child: Stack(
            children: [
              buildBody(context),
              Obx(() {
                final isSending = c.isSending.value;
                final sendMessageProgress = c.sendMessageProgress.value;

                if (!isSending) return Container();
                return Positioned(
                  child: LinearProgressIndicator(
                    value: sendMessageProgress > 0 && sendMessageProgress < 1
                        ? sendMessageProgress
                        : null,
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 4,
        right: 4,
        top: 4,
        bottom: 4 + MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: Column(
        children: [
          buildCannedResponses(context),
          buildAttachments(),
          Obx(() {
            final isEmpty = c.isEmpty.value;
            final isPrivate = c.isPrivate.value;
            final showMore = c.showMore.value;
            final showRecorder = c.showRecorder.value;
            final isSending = c.isSending.value;

            return Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(isPrivate
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined),
                      onPressed: () => c.isPrivate.value = !isPrivate,
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        focusNode: c.focusNode,
                        controller: c.message,
                        decoration: InputDecoration(
                          hintText: isPrivate
                              ? t.message_private_hint
                              : t.message_hint,
                          border: InputBorder.none,
                        ),
                        minLines: 1,
                        maxLines: 3,
                      ),
                    ),
                    if (isEmpty && !isPrivate)
                      IconButton(
                        icon: Icon(
                          showMore
                              ? Icons.more_horiz
                              : Icons.more_horiz_outlined,
                        ),
                        onPressed: c.toggleMore,
                      ),
                    if (isEmpty)
                      IconButton(
                        icon: Icon(
                          showRecorder ? Icons.mic : Icons.mic_outlined,
                        ),
                        onPressed: c.toggleRecorder,
                      ),
                    if (isEmpty)
                      IconButton(
                        icon: Icon(Icons.image_outlined),
                        onPressed: c.showFilePicker,
                      ),
                    if (!isEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.send_outlined,
                          color: isSending
                              ? null
                              : context.theme.colorScheme.primary,
                        ),
                        onPressed: isSending ? null : c.sendMessage,
                      ),
                  ],
                ),
                if (showMore)
                  buildMore(context)
                else if (showRecorder)
                  buildRecorder(context),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget buildBottom({required BuildContext context, required Widget child}) {
    var height = max(MediaQuery.of(context).viewInsets.bottom, 200.0);
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: context.theme.colorScheme.outlineVariant,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget buildEmoji(BuildContext context) {
    return buildBottom(
      context: context,
      child: Text('buildEmoji'),
    );
  }

  Widget buildMore(BuildContext context) {
    return buildBottom(
      context: context,
      child: Text('buildMore'),
    );
  }

  Widget buildRecorder(BuildContext context) {
    return buildBottom(
      context: context,
      child: Obx(() {
        final isRecording = c.isRecording.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: isRecording
              ? [
                  // TODO: make waveform
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      bottom: 16,
                      right: 16,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                              'assets/images/typing.gif',
                              width: 32,
                            ),
                          ),
                          Text(formatDuration(c.recorderDuration.value)),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      IconButton.filledTonal(
                        onPressed: () => c.stopRecord(cancel: true),
                        icon: Icon(
                          Icons.delete_outline,
                          size: 48,
                        ),
                      ),
                      IconButton.filled(
                        onPressed: c.stopRecord,
                        icon: Icon(
                          Icons.send_outlined,
                          size: 48,
                        ),
                      ),
                    ],
                  ),
                ]
              : [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(t.tap_to_record),
                  ),
                  IconButton.filled(
                    onPressed: c.startRecord,
                    icon: Icon(
                      Icons.mic_outlined,
                      size: 48,
                    ),
                  ),
                ],
        );
      }),
    );
  }

  Widget buildAttachments() {
    return Obx(() {
      final files = c.files.value;
      if (files.isEmpty) return Container();

      return SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: files.length,
          itemBuilder: (_, i) {
            return buildAttachment(files[i]);
          },
        ),
      );
    });
  }

  Widget buildAttachment(FileInfo file) {
    return Card(
      child: InkWell(
        onTap: () {
          print('onTap');
        },
        child: AspectRatio(
          aspectRatio: 4 / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Builder(builder: (_) {
                  final isImage =
                      ['jpg', 'png', 'jpeg'].contains(file.extension);

                  if (isImage) {
                    return Image.file(
                      File(file.path),
                      width: double.infinity,
                      height: double.infinity,
                    );
                  }

                  return Center(
                    child: Icon(Icons.file_present_outlined),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCannedResponses(BuildContext context) {
    return Obx(() {
      final items = c.cannedResponses.value;
      if (items.isEmpty) return Container();

      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 250,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (_, i) => buildCannedResponse(items[i]),
        ),
      );
    });
  }

  Widget buildCannedResponse(CannedResponseInfo info) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 4,
          children: [
            Expanded(
              child: Text(
                info.content.replaceAll('\n', ' '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              info.short_code,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
