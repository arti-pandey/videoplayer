import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:betterplayertest/constant.dart';
import 'package:betterplayertest/video_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class VideoPlayer extends GetView<VideoPlayerController> {
  final GlobalKey<ScaffoldState> drawerkey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key:  drawerkey,
      drawer:speedUIContainer(context),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              controller.isTouched.value = !controller.isTouched.value;
              SystemChrome.setEnabledSystemUIMode(
                  SystemUiMode.immersiveSticky,
                  overlays: []);
            },
            child: BetterPlayer(
              controller: controller.betterPlayerController!,
              key: controller.betterPlayerKey,
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Obx(() => controller.betterPlayerController!.isBuffering()!
                  ? const CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.black26,
                strokeWidth: 2.5,
              ) : Visibility(
                visible: controller.betterPlayerController!.isBuffering()! ||
                    controller.videoTotalTime != controller.videoTotalTime
                    ? controller.isTouched.value
                    : !controller.isTouched.value,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          print("backward clicked");
                          Duration? videoDuration =
                          await controller.betterPlayerController!
                              .videoPlayerController!.position;
                          if (controller.betterPlayerController!.isPlaying()!) {
                            Duration rewindDuration = Duration(
                                seconds:
                                (videoDuration!.inSeconds - 10),);
                            if (rewindDuration <
                                controller.betterPlayerController!
                                    .videoPlayerController!
                                    .value
                                    .duration!) {
                              controller.betterPlayerController!.seekTo(
                                  Duration(
                                      seconds:
                                      rewindDuration.inSeconds),);
                            } else {
                              controller.betterPlayerController!
                                  .seekTo(rewindDuration);
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25),
                            ),
                            color: Colors.black26,
                            border: Border.all(
                                width: 1,
                                style: BorderStyle.none,
                                color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Center(
                              child: Image.asset(
                                Constants.backward,
                                color: Colors.white,
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          print("play clicked");
                          if (controller.betterPlayerController!.isPlaying()!) {
                            print("play isPlaying");
                            controller.betterPlayerController!.pause();
                          } else {
                            print("play play");
                            if (controller.videoTotalTime == controller.videoProgress) {
                              controller.vedioIsComplete.value = !controller.vedioIsComplete.value;
                              // refreshIcon();
                            }
                            controller.betterPlayerController!.play();
                          }
                        },
                        child:  Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(37),
                            ),
                            color: Colors.black26,
                            border: Border.all(
                                width: 1,
                                style: BorderStyle.none,
                                color: Colors.black26),
                          ),
                          alignment: Alignment.center,
                          child: (controller.isVideoPlay.value == 0 )
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                            backgroundColor: Colors.black26,
                            strokeWidth: 2.5,
                          )
                              : Icon(
                            controller.isVideoPlay.value == 1
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 55,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          print("forward clicked");
                          Duration? videoDuration =
                          await controller.betterPlayerController!
                              .videoPlayerController!.position;
                          if (controller.betterPlayerController!.isPlaying()!) {
                            Duration forwardDuration = Duration(
                                seconds:
                                (videoDuration!.inSeconds + 10));
                            if (forwardDuration >
                                controller.betterPlayerController!
                                    .videoPlayerController!
                                    .value
                                    .duration!) {
                              controller.betterPlayerController!
                                  .seekTo(const Duration(seconds: 0));
                              controller.betterPlayerController!.pause();
                            } else {
                              controller.betterPlayerController!
                                  .seekTo(forwardDuration);
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25),
                            ),
                            color: Colors.black26,
                            border: Border.all(
                                width: 1,
                                style: BorderStyle.none,
                                color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Center(
                              child: Image.asset(
                                Constants.forward,
                                color: Colors.white,
                                height: 25,
                                width: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),)
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              margin: const EdgeInsets.only(top: 50, right: 10),
              alignment: Alignment.topRight,
              child:Obx(() => controller.showPlaceholder.value ? const SizedBox() : counterTimer(),) ,
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Obx(() => Visibility(
              visible:  !controller.isTouched.value,
              child: Container(
                // height: 40,
                color: Colors.black26,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                        controller.controllerDispose();
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Dynamic Elevated Pose',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          drawerkey.currentState!.openDrawer();
                          print("its clicked");
                          // _betterPlayerController.setSpeed(0.5);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Obx(() => Text(
                            controller.speedControllerName.value,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: 2.5,
                                fontWeight: FontWeight.bold),
                          ),),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.soundToggle();
                        },
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Obx(() => Icon(
                              controller.isMusicOn == true
                                  ? Icons.music_note
                                  : Icons.music_off,
                              size: 22,
                              color: Colors.white,
                            ),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),),
          ),
        ],
      ),);

  }

Widget speedUIContainer(context){
    return  Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width * 0.35,
      decoration: const BoxDecoration(
        color: Colors.black26,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50, bottom: 5),
            child: const Text(
              'playback Speed',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.3),
            ),
          ),
          const Divider(
            color: Colors.white,
          ),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        controller.betterPlayerController!.setSpeed(0.25);
                        controller.speedControllerName.value = '0.25x';
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: const Text(
                          '0.25x',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.betterPlayerController!.setSpeed(0.5);
                        controller.speedControllerName.value = '0.5x';

                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: const Text(
                          '0.5x',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.betterPlayerController!.setSpeed(1.0);
                        controller.speedControllerName.value = '1.0x';

                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text(
                          'Normal',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.betterPlayerController!.setSpeed(1.5);
                        controller.speedControllerName.value = '1.5x';
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text(
                          '1.5x',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.betterPlayerController!.setSpeed(1.75);
                        controller.speedControllerName.value = '1.7x';
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text(
                          '1.75x',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.betterPlayerController!.setSpeed(2.0);
                        controller.speedControllerName.value = '2.0x';
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text(
                          '2.0x',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
}

  Widget counterTimer() {
    return CircularPercentIndicator(
      circularStrokeCap: CircularStrokeCap.round,
      percent: controller.videoProgress!.inSeconds/ controller.videoTotalTime!.inSeconds,
      animation: false,
      radius: 65,
      lineWidth: 5.0,
      progressColor: Colors.purple.withOpacity(0.4),
      reverse: true,
      center: Text(
        '${controller.twoDigitHour} : ${controller.twoDigitMinutes} : ${controller.twoDigitSeconds}',
        style: const TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),

    );
  }

 /* Widget refreshIcon() {
    return Visibility(
      visible: videoProgress == videoTotalTime ? vedioIsComplete : isTouched,
      child: InkWell(
        onTap: () {
          print("play clicked");
          setState(() {
            isTouched = !isTouched;
            _betterPlayerController!.play();
          });
        },
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.20,
          width: MediaQuery
              .of(context)
              .size
              .width * 0.08,
          margin: EdgeInsets.symmetric(horizontal: 100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
            color: Colors.black26,
            border: Border.all(
                width: 1, style: BorderStyle.none, color: Colors.black26),
          ),
          alignment: Alignment.center,
          child: (_betterPlayerController!.isBuffering()! ||
              videoProgress == Duration.zero)
              ? CircularProgressIndicator(
            color: Colors.white,
            backgroundColor: Colors.black26,
            strokeWidth: 2.5,
          )
              : Icon(
            Icons.refresh,
            color: Colors.white,
            size: 55,
          ),
        ),
      ),
    );
  }*/

}
