import '/imports.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:just_audio/just_audio.dart' show ProcessingState;

class AudioPlayerController extends GetxController {
  final String url;
  AudioPlayerController({
    required this.url,
  });

  final duration = Duration.zero.obs;
  final position = Duration.zero.obs;
  final isPlaying = false.obs;
  final isLoaded = false.obs;
  final isEnded = false.obs;

  late StreamSubscription _stateStream;
  late StreamSubscription _durationStream;
  late StreamSubscription _playingStream;
  late StreamSubscription _positionStream;
  late just_audio.AudioPlayer _audioPlayer;

  @override
  void onInit() {
    super.onInit();

    _audioPlayer = just_audio.AudioPlayer();
    _stateStream = _audioPlayer.playerStateStream.listen((next) {
      if (next.processingState == ProcessingState.ready) isLoaded.value = true;
      if (next.processingState == ProcessingState.completed) {
        isEnded.value = true;
        isPlaying.value = false;
      }
    });
    _durationStream = _audioPlayer.durationStream.listen((next) {
      if (next == null) return;
      duration.value = next;
    });
    _playingStream = _audioPlayer.playingStream.listen((next) {
      isPlaying.value = next;
    });
    _positionStream = _audioPlayer.positionStream.listen((next) {
      position.value = next;
    });

    _audioPlayer.setUrl(url);
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    _stateStream.cancel();
    _durationStream.cancel();
    _playingStream.cancel();
    _positionStream.cancel();

    super.onClose();
  }

  Future<void> pause() async {
    isPlaying.value = false;
    _audioPlayer.pause();
  }

  Future<void> play() async {
    if (isPlaying.value) return;
    isPlaying.value = true;
    _audioPlayer.play();
  }

  Future<void> restart() async {
    isEnded.value = false;
    isPlaying.value = false;
    _audioPlayer.seek(Duration.zero);
    isPlaying.value = true;
    _audioPlayer.play();
  }
}

class AudioPlayer extends StatelessWidget {
  final int id;
  final String url;

  const AudioPlayer({
    super.key,
    required this.id,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioPlayerController>(
      init: AudioPlayerController(url: url),
      tag: id.toString(),
      builder: (controller) {
        return Obx(() {
          final isPlaying = controller.isPlaying.value;
          final isEnded = controller.isEnded.value;
          final position = controller.position.value;
          final duration = controller.duration.value;

          final durationInMilliseconds = duration.inMilliseconds.toDouble();
          final positionInMilliseconds =
              min(durationInMilliseconds, position.inMilliseconds.toDouble());

          Widget icon;
          if (isEnded) {
            icon = IconButton(
              onPressed: controller.restart,
              icon: Icon(Icons.restart_alt_outlined),
            );
          } else if (isPlaying) {
            icon = IconButton(
              onPressed: controller.pause,
              icon: Icon(Icons.pause_circle_filled_outlined),
            );
          } else {
            icon = IconButton(
              onPressed: controller.play,
              icon: Icon(Icons.play_circle_fill_outlined),
            );
          }

          return CustomListTile(
            leading: CircleAvatar(child: icon),
            title: Slider(
              value: positionInMilliseconds,
              max: durationInMilliseconds,
              onChanged: (next) {},
            ),
            subtitle: Row(
              children: [
                Text(formatDuration(position)),
                Spacer(),
                Text(formatDuration(duration)),
              ],
            ),
            // trailing: IconButton(
            //   icon: Icon(Icons.transcribe),
            //   onPressed: () {},
            // ),
          );
        });
      },
    );
  }
}
