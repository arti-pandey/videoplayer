import 'package:betterplayertest/video_player_controller.dart';
import 'package:get/get.dart';

class VideoPlayerBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => VideoPlayerController());
  }
}