import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/track.dart';

import 'marquee.dart';

class SongDetalisWidget extends StatelessWidget {
  final Track track;
  const SongDetalisWidget({
    Key? key,
    required this.track,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          track.name.split('(').first.length < 16
              ? Text(
                  '${track.name.split('(').first} ',
                  style: textTheme.titleLarge!.copyWith(color: Colors.white),
                  maxLines: 1,
                )
              : MarqueeWidget(
                  style: textTheme.titleLarge!.copyWith(color: Colors.white),
                  track: track,
                  height: 40,
                ),
          track.artists.length > 4
              ? MarqueeWidget(
                  style: textTheme.titleMedium!.copyWith(color: Colors.white),
                  track: track,
                  isArtist: true,
                  height: 25,
                )
              : Text(
                  '${track.artist.name} ',
                  style: textTheme.titleMedium!.copyWith(color: Colors.white),
                  maxLines: 2,
                ),
        ],
      ),
    );
  }
}
