import 'package:betterplayertest/HomeScreen.dart';
import 'package:betterplayertest/video_player.dart';
import 'package:betterplayertest/video_player_binding.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOMESCREEN;
  static final routes = [
    GetPage(
      name: _Paths.VIDEOPLAYER,
      page: () =>  VideoPlayer(),
      binding: VideoPlayerBinding(),
    ),
    GetPage(
      name: _Paths.HOMESCREEN,
      page: () => const HomeScreen(),
    ),
  ];
}
