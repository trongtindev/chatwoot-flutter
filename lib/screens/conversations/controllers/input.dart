import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;
import 'package:mime/mime.dart';
import '/imports.dart';

class ConversationInputController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _cannedResponses = Get.find<CannedResponsesController>();

  final int id;
  final isEmpty = true.obs;
  final showMore = false.obs;
  final showRecorder = false.obs;
  final isRecording = false.obs;
  final height = 200.0.obs; // TODO: use keyboard height
  final isSending = false.obs;
  final isPrivate = false.obs;
  final sendMessageProgress = 0.0.obs;
  final focusNode = FocusNode();
  final message = TextEditingController();
  final files = RxList<FileInfo>();
  final amplitudes = RxList<double>();
  final recorderPath = Rxn<String>();
  final recorderDuration = Duration.zero.obs;
  final cannedResponses = RxList();

  AudioRecorder? _recorder;
  Timer? _fetchAmplitudeTimer;

  ConversationInputController({required this.id});

  @override
  void onInit() {
    super.onInit();

    focusNode.addListener(_onfocusNode);
    message.addListener(_onMessageChanged);
  }

  @override
  void onClose() {
    message.removeListener(_onMessageChanged);
    focusNode.dispose();
    _recorder?.cancel();
    _fetchAmplitudeTimer?.cancel();

    super.onClose();
  }

  void _onfocusNode() {
    if (focusNode.hasFocus) {
      showMore.value = false;
      showRecorder.value = false;
      return;
    }
  }

  void _onMessageChanged() {
    isEmpty.value = message.text.isEmpty;
    if (isEmpty.value == false) {
      showMore.value = false;
      showRecorder.value = false;
    }

    if (message.text.isNotEmpty && message.text.startsWith('/')) {
      cannedResponses.value = _cannedResponses.items
          .where((e) => e.short_code.startsWith(message.text))
          .toList();
    } else if (cannedResponses.value.isNotEmpty) {
      cannedResponses.value = [];
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

  void toggleMore() {
    showMore.value = !showMore.value;
    showRecorder.value = false;
    _onStateChanged(!showMore.value);
  }

  Future<void> toggleRecorder() async {
    if (!await ensurePermissionsGranted(permissions: [Permission.microphone])) {
      _logger.w('toggleRecorder() => permissions have not been granted!');
      return;
    }

    showRecorder.value = !showRecorder.value;
    showMore.value = false;

    _onStateChanged(!showRecorder.value);
  }

  Future<void> showFilePicker() async {
    if (!await ensurePermissionsGranted(permissions: [Permission.photos])) {
      _logger.w('permissions have not been granted!');
      return;
    }
    _logger.d('pickFiles()');
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      // allowedExtensions: env.ATTACHMENT_ALLOWED_EXTENSIONS,
      // type: FileType.custom,
    );
    if (result == null || result.count == 0) {
      _logger.d('pickFiles() => empty!');
      return;
    }

    _logger.d('pickFiles ${result.count} files');
    files.value = result.files
        .map(
          (e) => FileInfo(
            path: e.path!,
            size: e.size,
            contentType: lookupMimeType(e.path!),
          ),
        )
        .toList();
    focusNode.requestFocus();
  }

  Future<void> onPopInvokedWithResult(bool didPop, dynamic result) async {
    if (showMore.value || showRecorder.value) {
      showMore.value = false;
      showRecorder.value = false;
      return;
    }
    Get.back();
  }

  Future<void> sendMessage({List<FileInfo>? attachments}) async {
    try {
      _logger.d('sendMessage()');
      isSending.value = true;

      // TODO: make pending message
      // final echo_id = getUuid();
      final result = await _api.sendMessage(
        conversation_id: id,
        content: message.text,
        attachments: attachments ?? files,
        // echo_id: echo_id,
        private: isPrivate.value,
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

  Future<void> startRecord() async {
    final dir = await getApplicationCacheDirectory();
    final path = p.join(dir.path, '${getUuid()}.wav');
    _logger.d('path: $path');

    isRecording.value = true;
    recorderDuration.value = Duration.zero;

    _recorder ??= AudioRecorder();
    await _recorder!.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
      ),
      path: path,
    );

    _fetchAmplitudeTimer = Timer.periodic(
      Duration(milliseconds: 100),
      (_) => _fetchAmplitude(),
    );
  }

  Future<void> _fetchAmplitude() async {
    final amplitude = await _recorder!.getAmplitude();
    amplitudes.add(amplitude.current.abs());
    if (amplitudes.length > 50) amplitudes.removeAt(0);
    recorderDuration.value = Duration(
      milliseconds: recorderDuration.value.inMilliseconds + 100,
    );
  }

  Future<void> stopRecord({bool? cancel}) async {
    cancel ??= false;
    isRecording.value = false;
    _fetchAmplitudeTimer?.cancel();
    final path = await _recorder!.stop();
    if (cancel) return;
    _logger.d('path: $path');
    recorderPath.value = path;

    final file = File(path!);
    final bytes = await file.readAsBytes();
    final fileInfo = FileInfo(
      path: path,
      size: bytes.length,
      contentType: lookupMimeType(path),
    );

    sendMessage(attachments: [fileInfo]);
  }
}
