import 'package:flutter/material.dart';

class PodcastControl extends StatelessWidget {
  const PodcastControl({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            child: const SizedBox(
              width: 50,
              child: Text("x0.5"),
            ),
            onPressed: () {}
            // setPlaybackSpeed(
            //     PodcastPlaybackSpeed.playbackSpeed_50),
            ),
        TextButton(
            child: const SizedBox(
              width: 50,
              child: Text("x1"),
            ),
            onPressed: () {}
            // onPressed: () => setPlaybackSpeed(
            //     PodcastPlaybackSpeed.playbackSpeed_100),
            ),
        TextButton(
            child: const SizedBox(
              width: 50,
              child: Text("x1.5"),
            ),
            onPressed: () {}
            // onPressed: () => setPlaybackSpeed(
            //     PodcastPlaybackSpeed.playbackSpeed_150),
            ),
        TextButton(
            child: const SizedBox(
              width: 50,
              child: Text("x3.0"),
            ),
            onPressed: () {}
            // onPressed: () => setPlaybackSpeed(
            //     PodcastPlaybackSpeed.playbackSpeed_300),
            ),
      ],
    );
  }
}
