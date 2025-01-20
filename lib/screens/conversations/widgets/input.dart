import '/screens/conversations/controllers/input.dart';
import '/imports.dart';

class ConversationInput extends GetView<ConversationInputController> {
  final int conversation_id;
  const ConversationInput({
    super.key,
    required this.conversation_id,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ConversationInputController(conversation_id: conversation_id),
      builder: (_) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: controller.onPopInvokedWithResult,
          child: Container(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surfaceContainer,
            ),
            child: Stack(
              children: [
                buildBody(context),
                Obx(() {
                  final isSending = controller.isSending.value;
                  final sendMessageProgress =
                      controller.sendMessageProgress.value;

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
          ),
        );
      },
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
          buildAttachments(),
          Obx(() {
            var isEmpty = controller.isEmpty.value;
            var showEmoji = controller.showEmoji.value;
            var showMore = controller.showMore.value;
            var showRecorder = controller.showRecorder.value;
            var isSending = controller.isSending.value;

            return Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.emoji_symbols),
                      onPressed: controller.toggleEmoji,
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        focusNode: controller.focusNode,
                        controller: controller.message,
                        decoration: InputDecoration(
                          hintText: t.message_hint,
                          border: InputBorder.none,
                        ),
                        minLines: 1,
                        maxLines: 3,
                      ),
                    ),
                    if (isEmpty)
                      IconButton(
                        icon: Icon(showMore
                            ? Icons.more_horiz
                            : Icons.more_horiz_outlined),
                        onPressed: controller.toggleMore,
                      ),
                    if (isEmpty)
                      IconButton(
                        icon: Icon(Icons.mic_outlined),
                        onPressed: controller.toggleRecorder,
                      ),
                    if (isEmpty)
                      IconButton(
                        icon: Icon(Icons.image_outlined),
                        onPressed: controller.showFilePicker,
                      ),
                    if (isEmpty == false)
                      IconButton(
                        icon: Icon(
                          Icons.send_outlined,
                          color: isSending
                              ? null
                              : context.theme.colorScheme.primary,
                        ),
                        onPressed: isSending ? null : controller.sendMessage,
                      ),
                  ],
                ),
                if (showEmoji)
                  buildEmoji(context)
                else if (showMore)
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
      child: Text('buildRecorder'),
    );
  }

  Widget buildAttachments() {
    return Obx(() {
      var files = controller.files;
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

  Widget buildAttachment(PlatformFile file) {
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
                  var isImage =
                      ['jpg', 'png', 'jpeg'].contains(file.extension ?? '');
                  if (isImage) {
                    return Image.file(
                      File(file.path!),
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
}
