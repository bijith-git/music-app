import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.expand_more,
              size: 39,
            ),
          ),
          centerTitle: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "PLAYING FRO YOUR LIBRARY",
                style: textTheme.labelSmall!.copyWith(fontSize: 8),
              ),
              Text(
                "Liked Songs",
                style: textTheme.labelSmall!.copyWith(fontSize: 8),
              ),
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        body: Column(children: [
          const Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Center(
                  child: ArtWorkImage(
                      image:
                          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP._KrRAWUfyu9V5PApNFtj0wHaEK%26pid%3DApi&f=1&ipt=f0f9877f1d6459a3717daa03c98d954fe1369ea699bbe749e54c193ecfe3037b&ipo=images'),
                ),
              )),
          Expanded(
              child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'javan',
                      style:
                          textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    Text(
                      '-',
                      style: textTheme.titleMedium
                          ?.copyWith(color: Colors.white60),
                    ),
                  ],
                ),
                const Icon(
                  Icons.favorite,
                )
              ],
            ),
            const SizedBox(height: 16),
            // StreamBuilder(
            //     stream: player.onPositionChanged,
            //     builder: (context, data) {
            //       return ProgressBar(
            //         progress: data.data ?? const Duration(seconds: 0),
            //         // total: music.duration ?? const Duration(minutes: 4),
            //         bufferedBarColor: Colors.white38,
            //         baseBarColor: Colors.white10,
            //         thumbColor: Colors.white,
            //         timeLabelTextStyle:
            //             const TextStyle(color: Colors.white),
            //         progressBarColor: Colors.white,
            //         onSeek: (duration) {
            //           // player.seek(duration);
            //         },
            //       );
            //     }),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             LyricsPage( )));
                    },
                    icon: const Icon(Icons.shuffle, color: Colors.white)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_previous,
                        color: Colors.white, size: 36)),
                IconButton(
                    onPressed: () async {
                      // if (player.state == PlayerState.playing) {
                      //   await player.pause();
                      // } else {
                      //   await player.resume();
                      // }
                      // setState(() {});
                    },
                    icon: const Icon(
                      // player.state == PlayerState.playing
                      // ?
                      Icons.pause,
                      // : Icons.play_circle,
                      color: Colors.white,
                      size: 60,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_next,
                        color: Colors.white, size: 36)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.repeat,
                    )),
              ],
            ),
          ]))
        ]));
  }
}

class ArtWorkImage extends StatelessWidget {
  final String? image;

  const ArtWorkImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * .4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: image != null
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(image!),
                )
              : null),
    );
  }
}

class LyricsPage extends StatefulWidget {
  // final Music music;
  final AudioPlayer player;

  const LyricsPage(
      {super.key,
      //  required this.music,
      required this.player});

  @override
  State<LyricsPage> createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  // List<Lyric>? lyrics;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  StreamSubscription? streamSubscription;

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // streamSubscription = widget.player.onPositionChanged.listen((duration) {
    //   DateTime dt = DateTime(1970, 1, 1).copyWith(
    //       hour: duration.inHours,
    //       minute: duration.inMinutes.remainder(60),
    //       second: duration.inSeconds.remainder(60));
    //   if(lyrics != null) {
    //     for (int index = 0; index < lyrics!.length; index++) {
    //       if (index > 4 && lyrics![index].timeStamp.isAfter(dt)) {
    //         itemScrollController.scrollTo(
    //             index: index - 3, duration: const Duration(milliseconds: 600));
    //         break;
    //       }
    //     }
    //   }
    // });
    // get(Uri.parse(
    //         'https://paxsenixofc.my.id/server/getLyricsMusix.php?q=${widget.music.songName} ${widget.music.artistName}&type=default'))
    //     .then((response) {
    //   String data = response.body;
    //   lyrics = data
    //       .split('\n')
    //       .map((e) => Lyric(e.split(' ').sublist(1).join(' '),
    //           DateFormat("[mm:ss.SS]").parse(e.split(' ')[0])))
    //       .toList();
    //   setState(() {});
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: widget.music.songColor,
      body: 'lyrics' != null
          ? SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0)
                    .copyWith(top: 20),
                child: StreamBuilder<Duration>(
                    stream: widget.player.onPositionChanged,
                    builder: (context, snapshot) {
                      return ScrollablePositionedList.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          // Duration duration =
                          //     snapshot.data ?? const Duration(seconds: 0);
                          // DateTime dt = DateTime(1970, 1, 1).copyWith(
                          //     hour: duration.inHours,
                          //     minute: duration.inMinutes.remainder(60),
                          //     second: duration.inSeconds.remainder(60));
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              'lyrics![index].words',
                              style: TextStyle(
                                color:
                                    // lyrics![index].timeStamp.isAfter(dt)
                                    //     ? Colors.white38
                                    // :
                                    Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                        itemScrollController: itemScrollController,
                        scrollOffsetController: scrollOffsetController,
                        itemPositionsListener: itemPositionsListener,
                        scrollOffsetListener: scrollOffsetListener,
                      );
                    }),
              ),
            )
          : const SizedBox(),
    );
  }
}
