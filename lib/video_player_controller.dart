import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:betterplayertest/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VideoPlayerController extends GetxController with WidgetsBindingObserver {
  AppLifecycleState? appLifecycleState;
  BetterPlayerTheme? playerTheme;
  BetterPlayerConfiguration? betterPlayerConfiguration;
  BetterPlayerDataSource? betterPlayerDataSource;
  BetterPlayerController? betterPlayerController ;
  var isVideoPlay = 0.obs;
  var isLoading = true.obs;
  var speedControllerName = '1.0x'.obs;
  var isMusicOn = true.obs;
  Duration? videoProgress = Duration.zero, videoTotalTime = Duration.zero;
  var isTouched = false.obs;
  StreamController<bool> placeholderStreamController =
      StreamController.broadcast();
  var showPlaceholder = true.obs;
  var isPictureInPicture = false.obs;
  var twoDigitMinutes = '00'.obs;

  var twoDigitSeconds = '00'.obs;

  var twoDigitHour = '00'.obs;
  var vedioIsComplete = false.obs;

  GlobalKey betterPlayerKey = GlobalKey();
  BetterPlayerNotificationConfiguration? betterPlayerNotificationConfiguration;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      Constants.videoUrl,
      /*notificationConfiguration: BetterPlayerNotificationConfiguration(
          showNotification: true,
          title: "Desk-Yoga",
          author: "Cuz-fitness",
          imageUrl: Constants.imageForNotification,
          activityName: "MainActivity",
    ),*/
    );

    playerTheme = BetterPlayerTheme.material;
    betterPlayerConfiguration = BetterPlayerConfiguration(
      /*  aspectRatio: 16 / 9,
       fit: BoxFit.fill,*/
      fit: BoxFit.fill,
      autoPlay: true,
      looping: false,
      placeholder: buildVideoPlaceholder(),
      showPlaceholderUntilPlay: true,
      // fullScreenByDefault: true,

      controlsConfiguration: BetterPlayerControlsConfiguration(
        playerTheme: playerTheme!,
        enableSubtitles: false,
        showControls: false,
      ),
    );

    betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      Constants.videoUrl,
      /*notificationConfiguration: BetterPlayerNotificationConfiguration(
          showNotification: true,
          title: "Desk-Yoga",
          author: "Cuz-fitness",
          imageUrl: Constants.imageForNotification,
          activityName: "MainActivity",
    ),*/
    );
    betterPlayerController = BetterPlayerController(betterPlayerConfiguration!);
    betterPlayerController!.setupDataSource(betterPlayerDataSource!);
    betterPlayerController!.addEventsListener((BetterPlayerEvent element) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
      if(element.betterPlayerEventType == BetterPlayerEventType.bufferingStart){
        isVideoPlay.value = 0;
      }else if(element.betterPlayerEventType == BetterPlayerEventType.bufferingEnd || element.betterPlayerEventType == BetterPlayerEventType.play){
        isVideoPlay.value = 1;
      }else if(element.betterPlayerEventType == BetterPlayerEventType.bufferingEnd || element.betterPlayerEventType == BetterPlayerEventType.pause){
        isVideoPlay.value = 2;
      }

      if (element.betterPlayerEventType == BetterPlayerEventType.pipStart) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
            overlays: []);

        betterPlayerController!.play();
      }
      if (element.betterPlayerEventType == BetterPlayerEventType.pipStop) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
            overlays: []);
        betterPlayerController!.play();
        isPictureInPicture.value = !isPictureInPicture.value;
      }
      print(
          'betterPlayerController event calling=>${element.betterPlayerEventType}');
      _onPlayerEvent(element);
      if (element.betterPlayerEventType == BetterPlayerEventType.play) {
        setPlaceholderVisibleState(false);
      }
    });
    betterPlayerController!.isPictureInPictureSupported();
    betterPlayerController!.setBetterPlayerGlobalKey(betterPlayerKey);
    super.onInit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appLifecycleState = state;
    if (state == AppLifecycleState.inactive) {
      print('AppLifecycleState state: Paused audio playback');
      betterPlayerController!.enablePictureInPicture(betterPlayerKey);
    }
  }


  printDuration(Duration duration) {
    twoDigits(int n) => n.toString().padLeft(2, "0");
    twoDigitMinutes.value = twoDigits(duration.inMinutes.remainder(60));
    twoDigitSeconds.value = twoDigits(duration.inSeconds.remainder(60));
    twoDigitHour.value = twoDigits(duration.inHours.remainder(60));
    //  print("time aaya"+twoDigitSeconds);
  }

  void setPlaceholderVisibleState(bool hidden) {
    placeholderStreamController.add(hidden);
    showPlaceholder.value = hidden;
  }

  void _onPlayerEvent(BetterPlayerEvent event) {
    if (betterPlayerController!.isPlaying()!) {
      if (checkIfCanProcessPlayerEvent(event)) {
        if (event.parameters!['progress'] != null &&
            event.parameters!['duration'] != null) {
          printDuration(videoProgress!);
          videoProgress = event.parameters!['progress'];
          videoTotalTime = event.parameters!['duration'];
        } else if (event.parameters!['progress'] != null &&
            event.parameters!['duration'] == null) {
          printDuration(videoProgress!);
          videoProgress = event.parameters!['progress'];
          videoTotalTime = Duration.zero;
        } else if (event.parameters!['duration'] != null &&
            event.parameters!['progress'] == null) {
          printDuration(videoProgress!);
          videoTotalTime = event.parameters!['duration'];
          videoProgress = Duration.zero;
        } else {
          printDuration(videoProgress!);
          videoProgress = Duration.zero;
          videoTotalTime = Duration.zero;
        }
        print('rogress of the video=>${videoProgress}');
        print('duration of the video=>${videoTotalTime}');
      }
    }
  }

  bool checkIfCanProcessPlayerEvent(BetterPlayerEvent event) {
    return event.betterPlayerEventType == BetterPlayerEventType.progress &&
        event.parameters != null &&
        event.parameters!['progress'] != null &&
        event.parameters!['duration'] != null;
  }

  controllerDispose() {
    placeholderStreamController.close();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    betterPlayerController!.dispose();
  }

  soundToggle() {
    isMusicOn.value
        ? betterPlayerController!.setVolume(0.0)
        : betterPlayerController!.setVolume(1.0);
    isMusicOn.value = !isMusicOn.value;
  }

  Widget buildVideoPlaceholder() {
    return StreamBuilder<bool>(
      stream: placeholderStreamController.stream,
      builder: (context, snapshot) {
        return showPlaceholder.value
            ? Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.network(
                        Constants.placeholderUrl,
                      ),
                    ),
                  ),
                  const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  )),
                ],
              )
            : const SizedBox();
      },
    );
  }
  @override
  void dispose() {
    placeholderStreamController.close();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    WidgetsBinding.instance.removeObserver(this);
  }
}
