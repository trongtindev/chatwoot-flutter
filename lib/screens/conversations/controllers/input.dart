import 'package:file_picker/file_picker.dart';
import '/imports.dart';

class ConversationInputController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();

  final int conversation_id;
  final isEmpty = true.obs;
  final showEmoji = false.obs;
  final showMore = false.obs;
  final showRecorder = false.obs;
  final isRecording = false.obs;
  final height = 200.0.obs; // TODO: use keyboard height
  final isSending = false.obs;
  final sendMessageProgress = 0.0.obs;
  final focusNode = FocusNode();
  final message = TextEditingController();
  final files = RxList<PlatformFile>();

  ConversationInputController({required this.conversation_id});

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
    showRecorder.value = false;
    _onStateChanged(!showEmoji.value);
  }

  void toggleMore() {
    showMore.value = !showMore.value;
    showEmoji.value = false;
    showRecorder.value = false;
    _onStateChanged(!showMore.value);
  }

  Future<void> toggleRecorder() async {
    if (!await ensurePermissionsGranted(permissions: [Permission.microphone])) {
      _logger.w('toggleRecorder() => permissions have not been granted!');
      return;
    }

    showRecorder.value = !showRecorder.value;
    showEmoji.value = false;
    showMore.value = false;

    _onStateChanged(!showRecorder.value);
  }

  Future<void> showFilePicker() async {
    if (!await ensurePermissionsGranted(permissions: [Permission.photos])) {
      _logger.w('showFilePicker() => permissions have not been granted!');
      return;
    }
    _logger.d('showFilePicker()');

    var result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      // allowedExtensions: env.ATTACHMENT_ALLOWED_EXTENSIONS,
      // type: FileType.custom,
    );
    if (result == null || result.count == 0) {
      _logger.d('showFilePicker() => empty!');
      return;
    }

    _logger.d('showFilePicker() => ${result.count} files');
    files.value = result.files;
  }

  Future<void> onPopInvokedWithResult(bool didPop, dynamic result) async {
    if (showEmoji.value || showMore.value) {
      showEmoji.value = false;
      showMore.value = false;
      return;
    }
    Get.back();
  }

  Future<void> sendMessage() async {
    try {
      _logger.d('sendMessage()');
      isSending.value = true;

      // TODO: make pending message
      // final echo_id = getUuid();
      var result = await _api.sendMessage(
        conversation_id: conversation_id,
        content: message.text,
        attachments: files,
        // echo_id: echo_id,
        onProgress: (next) => sendMessageProgress.value = next,
      );
      result.getOrThrow();

      // reset
      message.text = '';
      files.value = [];
    } catch (error) {
      errorHandler(error);
    } finally {
      isSending.value = false;
      sendMessageProgress.value = 0.0;
    }
  }
}
