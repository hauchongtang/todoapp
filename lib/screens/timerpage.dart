import 'package:flutter/material.dart';
import 'package:todoapp/database_impl.dart';
import 'package:todoapp/widgets.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<TimerPage> with TickerProviderStateMixin {
  late AnimationController controller;
  bool isPlaying = false;
  bool isBreak = false;

  final DataBaseImpl _dbHelper = DataBaseImpl();

  Map<int, List<int>> timings = {
    0: [0],
    1: [2100, 300],
    2: [2100, 0],
    3: [2100, 0]
  };

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;
  int _time = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 3600));

    controller.addListener(() {
      if (controller.duration!.inSeconds == 3545) {
        FlutterRingtonePlayer.playNotification();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 24.0, bottom: 0),
            child: Text(
                "Please stay focused, if you leave this tab, timer will reset!"),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Text("Tap on the settings icon to change break time.")),
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) => AnimatedBuilder(
                        animation: controller,
                        builder: (context, build) {
                          return Text(
                            countText,
                            style: const TextStyle(
                                fontSize: 60, fontWeight: FontWeight.bold),
                          );
                        }),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (controller.isAnimating) {
                      controller.stop();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      controller.reverse(
                          from: controller.value == 0 ? 1.0 : controller.value);
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  child: RoundButton(
                      icon: isPlaying == true
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded),
                ),
                GestureDetector(
                  child: const RoundButton(icon: Icons.stop_rounded),
                  onTap: () {
                    controller.reset();
                    setState(() {
                      isPlaying = false;
                    });
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
