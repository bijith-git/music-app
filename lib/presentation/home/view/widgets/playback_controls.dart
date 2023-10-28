import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_clone/presentation/home/view/widgets/repeat_icon.dart';
import 'package:spotify_clone/widgets/side_icon.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class PlayBackControlsWidget extends StatefulWidget {
  final PlayerState? playerState;
  const PlayBackControlsWidget({super.key, required this.playerState});

  @override
  State<PlayBackControlsWidget> createState() => _PlayBackControlsWidgetState();
}

class _PlayBackControlsWidgetState extends State<PlayBackControlsWidget> {
  @override
  void initState() {
    super.initState();
  }

  bool get isShuffle =>
      widget.playerState?.playbackOptions.isShuffling ?? false;
  ValueNotifier<int> get playBackPosition =>
      ValueNotifier(widget.playerState?.playbackPosition ?? 0);
  @override
  Widget build(BuildContext context) {
    return widget.playerState == null
        ? Text("Player statedate is null")
        : Column(
            children: [
              AudioProgressBar(
                currentProgress: Duration(
                    milliseconds: widget.playerState!.playbackPosition),
                totalProgress: Duration(
                    milliseconds: widget.playerState?.track?.duration ?? 5000),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomIconButton(
                    width: 50,
                    icon: Icons.shuffle,
                    iconColor: widget.playerState!.playbackOptions.isShuffling
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    onPressed: () async {
                      await setShuffle(!isShuffle);
                      setState(() {});
                    },
                  ),
                  CustomIconButton(
                    width: 50,
                    icon: Icons.skip_previous,
                    onPressed: skipPrevious,
                  ),
                  widget.playerState!.isPaused
                      ? CustomIconButton(
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          iconColor: Colors.black,
                          width: 50,
                          icon: Icons.play_arrow,
                          onPressed: resume,
                        )
                      : CustomIconButton(
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          iconColor: Colors.black,
                          width: 50,
                          icon: Icons.pause,
                          onPressed: pause,
                        ),
                  CustomIconButton(
                    width: 50,
                    icon: Icons.skip_next,
                    onPressed: skipNext,
                  ),
                  RepeatButton(
                    width: 50,
                    repeatMode: RepeatMode.values[
                        widget.playerState!.playbackOptions.repeatMode.index],
                  ),
                ],
              ),
            ],
          );
  }

  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
    } on PlatformException catch (e) {
      // setStatus(e.code, message: e.message);
    } on MissingPluginException {
      //
    }
  }

  Future<void> resume() async {
    try {
      await SpotifySdk.resume();
    } on PlatformException catch (e) {
      // setStatus(e.code, message: e.message);
    } on MissingPluginException {
      //
    }
  }

  Future<void> setShuffle(bool shuffle) async {
    try {
      await SpotifySdk.setShuffle(
        shuffle: shuffle,
      );
    } on PlatformException catch (e) {
    } on MissingPluginException {}
  }

  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } on PlatformException catch (e) {
      // setStatus(e.code, message: e.message);
    } on MissingPluginException {
      //
    }
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException catch (e) {
      // setStatus(e.code, message: e.message);
    } on MissingPluginException {
      //
    }
  }

  Future<void> seekTo() async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: 20000);
    } on PlatformException catch (e) {
      // setStatus(e.code, message: e.message);
    } on MissingPluginException {
      //
    }
  }
}

class AudioProgressBar extends StatefulWidget {
  final Duration currentProgress;
  final Duration totalProgress;
  final Function(double)? onTap;

  AudioProgressBar(
      {required this.currentProgress, required this.totalProgress, this.onTap});

  @override
  State<AudioProgressBar> createState() => _AudioProgressBarState();
}

class _AudioProgressBarState extends State<AudioProgressBar> {
  StreamSubscription<PlayerState?>? state;
  int currentProgress = 0;
  @override
  void initState() {
    super.initState();
  }

  getProgress() async {
    state = SpotifySdk.getPlayerState().asStream().listen((event) {
      currentProgress = event?.playbackPosition ?? 0;
    });
  }

  String startTime = '';
  String endTime = '';
  double progress = 0;
  @override
  Widget build(BuildContext context) {
    setState(() {});
    double _calculateProgress(double tapPosition, double totalWidth) {
      double progress = tapPosition / totalWidth;
      return progress.clamp(0.0, 1.0); // Ensure progress is between 0 and 1
    }

    return Column(
      children: [
        GestureDetector(
          onTapDown: (TapDownDetails details) {
            double tapPosition = details.localPosition.dx;
            double totalWidth =
                MediaQuery.of(context).size.width - 32; // Subtracting padding
            double progress = _calculateProgress(tapPosition, totalWidth);

            // widget.onTap(progress);
          },
          child: Container(
            width: double.infinity,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
            child: StreamBuilder<PlayerState>(
                stream: SpotifySdk.subscribePlayerState().asBroadcastStream(),
                builder: (context, AsyncSnapshot<PlayerState> snapshot) {
                  print(snapshot.data!.playbackPosition.toDouble());
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    progress = snapshot.data!.playbackPosition.toDouble() /
                        snapshot.data!.track!.duration;
                    startTime = _formatTime(Duration(
                        milliseconds: snapshot.data!.playbackPosition));
                    endTime = _formatTime(
                        Duration(milliseconds: snapshot.data!.track!.duration));
                    setState(() {});
                  });

                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
          ),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              startTime,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            ),
            Text(
              endTime,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(Duration duration) {
    String formattedTime =
        '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
        '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    return formattedTime;
  }
}
