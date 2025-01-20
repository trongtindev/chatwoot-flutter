import '/imports.dart';
import 'package:just_audio/just_audio.dart' as just_audio;

class AudioPlayer extends StatefulWidget {
  final String url;

  const AudioPlayer({
    super.key,
    required this.url,
  });

  @override
  State<AudioPlayer> createState() => AudioPlayerState();
}

class AudioPlayerState extends State<AudioPlayer> {
  just_audio.AudioPlayer? _audioPlayer;

  Duration duration = Duration(seconds: 0);
  Duration position = Duration(seconds: 0);
  bool isPlaying = false;
  bool isLoading = false;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  double get durationInMilliseconds => duration.inMilliseconds.toDouble();
  double get positionInMilliseconds =>
      min(durationInMilliseconds, position.inMilliseconds.toDouble());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.tertiaryContainer,
      ),
      child: Row(
        children: [
          if (isPlaying)
            IconButton(
              onPressed: _audioPlayer?.pause,
              icon: Icon(Icons.pause_circle_filled_outlined),
            )
          else
            IconButton(
              onPressed: play,
              icon: Icon(Icons.play_circle_fill_outlined),
            ),
          Expanded(
            child: Column(
              children: [
                Slider(
                  value: positionInMilliseconds,
                  max: durationInMilliseconds,
                  onChanged: (next) {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      Text(formatDuration(position)),
                      Spacer(),
                      Text(formatDuration(duration)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> play() async {
    try {
      if (_audioPlayer == null) {
        setState(() {
          isLoading = true;
        });

        _audioPlayer = just_audio.AudioPlayer();
        _audioPlayer!.durationStream.listen((next) {
          if (next == null) return;
          duration = next;
          setState(() {});
        });
        _audioPlayer!.playingStream.listen((next) {
          isPlaying = next;
          setState(() {});
        });
        _audioPlayer!.positionStream.listen((next) {
          position = next;
          setState(() {});
        });

        await _audioPlayer!.setUrl(widget.url);
        await _audioPlayer!.play();

        setState(() {
          isLoading = false;
          isLoaded = true;
        });
      } else {
        setState(() {
          position = Duration.zero;
        });
        _audioPlayer!.seek(Duration(seconds: 0));
        await _audioPlayer!.play();
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pause() async {}
}
