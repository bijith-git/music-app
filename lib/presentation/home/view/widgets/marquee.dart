import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:spotify_sdk/models/track.dart';

class MarqueeWidget extends StatelessWidget {
  final bool isArtist;
  const MarqueeWidget({
    Key? key,
    this.isArtist = false,
    required this.track,
  }) : super(key: key);

  final Track track;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 20,
      child: Marquee(
        blankSpace: 170,
        startAfter: const Duration(seconds: 3),
        crossAxisAlignment: CrossAxisAlignment.start,
        text:
            isArtist ? track.artists.map((e) => e.name).join(',') : track.name,
      ),
    );
  }
}
