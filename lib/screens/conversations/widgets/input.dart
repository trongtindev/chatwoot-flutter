import '/screens/conversations/controllers/input.dart';
import '/imports.dart';

class ConversationInput extends GetView<ConversationInputController> {
  const ConversationInput({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ConversationInputController(),
      builder: (_) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: controller.onPopInvokedWithResult,
          child: Container(
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surfaceContainer,
              border: Border(
                top: BorderSide(
                  color: Get.theme.colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Obx(() {
                var isEmpty = controller.isEmpty.value;
                var showEmoji = controller.showEmoji.value;
                var showMore = controller.showMore.value;

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
                              hintText: 'conversation_input.message_hint'.tr,
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
                            icon: Icon(Icons.image_outlined),
                            onPressed: controller.showFilePicker,
                          ),
                        if (isEmpty == false)
                          IconButton(
                            icon: Icon(
                              Icons.send_outlined,
                              color: Get.theme.colorScheme.primary,
                            ),
                            onPressed: () {},
                          ),
                      ],
                    ),
                    if (showEmoji)
                      buildEmoji(context)
                    else if (showMore)
                      buildMore(context),
                  ],
                );
              }),
            ),
          ),
        );
      },
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
              color: Get.theme.colorScheme.outlineVariant,
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
}
