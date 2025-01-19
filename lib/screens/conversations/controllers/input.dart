import '/imports.dart';

class ConversationInputController extends GetxController {
  final _logger = Logger();

  final focusNode = FocusNode();
  final message = TextEditingController();

  final isEmpty = true.obs;
  final showEmoji = false.obs;
  final showMore = false.obs;
  final height = 200.0.obs;

  @override
  void onReady() {
    super.onReady();

    message.addListener(_onChanged);
  }

  @override
  void onClose() {
    message.removeListener(_onChanged);
    focusNode.dispose();

    super.onClose();
  }

  void _onChanged() {
    isEmpty.value = message.text.isEmpty;
    if (isEmpty.value == false) {
      showEmoji.value = false;
      showMore.value = false;
    }
  }

  void _onStateChanged(bool value) {
    _logger.d('_onStateChanged() => $value');

    if (value) {
      focusNode.requestFocus();
      return;
    }
    focusNode.unfocus();
  }

  void toggleEmoji() {
    showEmoji.value = !showEmoji.value;
    showMore.value = false;
    _onStateChanged(!showEmoji.value);
  }

  void toggleMore() {
    showMore.value = !showMore.value;
    showEmoji.value = false;
    _onStateChanged(!showMore.value);
  }

  Future<void> showFilePicker() async {
    _logger.d('showFilePicker');
  }

  Future<void> onPopInvokedWithResult(bool didPop, dynamic result) async {
    if (showEmoji.value || showMore.value) {
      showEmoji.value = false;
      showMore.value = false;
      return;
    }
    Get.back();
  }
}
