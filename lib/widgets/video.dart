import '/imports.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart' as video_player;

class VideoPlayerController extends GetxController {
  final String url;
  VideoPlayerController({
    required this.url,
  });

  final duration = Duration.zero.obs;
  final position = Duration.zero.obs;
  final isPlaying = false.obs;
  final isLoaded = false.obs;
  final isEnded = false.obs;

  late video_player.VideoPlayerController _videoPlayerController;
  late ChewieController chewieController;

  @override
  void onInit() {
    super.onInit();

    _videoPlayerController =
        video_player.VideoPlayerController.networkUrl(Uri.parse(url));
    chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
    );
  }

  @override
  void onClose() {
    chewieController.dispose();
    _videoPlayerController.dispose();

    super.onClose();
  }
}

class VideoPlayer extends StatelessWidget {
  final int id;
  final String url;
  final double aspectRatio;

  const VideoPlayer({
    super.key,
    required this.id,
    required this.url,
    double? aspectRatio,
  }) : aspectRatio = aspectRatio ?? 16 / 9;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoPlayerController>(
      init: VideoPlayerController(url: url),
      tag: id.toString(),
      builder: (controller) {
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: Chewie(
            controller: controller.chewieController,
          ),
        );
      },
    );
  }
}
