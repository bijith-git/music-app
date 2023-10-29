import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/core/client/api_client.dart';
import 'package:spotify_clone/utils/secure_storage.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late SpotifyApi spotifyApi;
  Music music = Music();

  getSpotifyClient() async {
    var token = SecureStorage().getData(key: 'accessToken');
    spotifyApi = SpotifyApi.withAccessToken(token);
    setState(() {});
    spotifyApi.player.currentlyPlaying().then((PlaybackState? track) async {
      if (track != null) {
        String? tempSongName = track.item?.name;
        if (tempSongName != null) {
          music.songName = tempSongName;
          music.artistName = track.item!.artists?.first.name ?? "";
          music.trackId = track.item!.id ?? "";
          String? image = track.item!.album?.images?.first.url;
          if (image != null) {
            music.songImage = image;
            final tempSongColor = await getImagePalette(NetworkImage(image));
            if (tempSongColor != null) {
              music.songColor = tempSongColor;
            }
          }
          music.artistImage = track.item!.artists?.first.images?.first.url;
          final yt = YoutubeExplode();
          final video = (await yt.search
                  .search("$tempSongName ${music.artistName ?? ""}"))
              .first;
          final videoId = video.id.value;
          music.duration = video.duration;
          setState(() {});
          var manifest = await yt.videos.streamsClient.getManifest(videoId);
          var audioUrl = manifest.audioOnly.last.url;
          player.play(UrlSource(audioUrl.toString()));
        }
      }
    });
  }

  Future<Color?> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor?.color;
  }

  @override
  void initState() {
    getSpotifyClient();
    super.initState();
  }

  final player = AudioPlayer();

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
        backgroundColor: music.songColor,
        appBar: AppBar(
          backgroundColor: music.songColor,
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
                "PLAYING FROM YOUR LIBRARY",
                style: textTheme.labelSmall!
                    .copyWith(fontSize: 8, fontWeight: FontWeight.bold),
              ),
              Text(
                "Liked Songs",
                style: textTheme.labelSmall!
                    .copyWith(fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        body: StreamBuilder<PlaybackState>(
            stream: spotifyApi.player.currentlyPlaying().asStream(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const CircularProgressIndicator();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(children: [
                  Expanded(
                      flex: 2,
                      child: Center(
                        child: ArtWorkImage(image: music.songImage),
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
                              music.songName ?? "not provided",
                              style: textTheme.titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            Text(
                              music.artistName ?? "not provided",
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
                    StreamBuilder(
                        stream: player.onPositionChanged,
                        builder: (context, data) {
                          return ProgressBar(
                            progress: data.data ?? const Duration(seconds: 0),
                            total: music.duration ?? const Duration(minutes: 4),
                            bufferedBarColor: Colors.white38,
                            baseBarColor: Colors.white10,
                            thumbColor: Colors.white,
                            timeLabelTextStyle:
                                const TextStyle(color: Colors.white),
                            progressBarColor: Colors.white,
                            onSeek: (duration) {
                              player.seek(duration);
                            },
                          );
                        }),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LyricsPage(
                                            music: music,
                                            player: player,
                                          )));
                            },
                            icon:
                                const Icon(Icons.shuffle, color: Colors.white)),
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
                ]),
              );
            }));
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
  final Music music;
  final AudioPlayer player;

  const LyricsPage({super.key, required this.music, required this.player});

  @override
  State<LyricsPage> createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  List<Lyric>? lyrics;
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
    streamSubscription = widget.player.onPositionChanged.listen((duration) {
      DateTime dt = DateTime(1970, 1, 1).copyWith(
          hour: duration.inHours,
          minute: duration.inMinutes.remainder(60),
          second: duration.inSeconds.remainder(60));
      if (lyrics != null) {
        for (int index = 0; index < lyrics!.length; index++) {
          if (index > 4 && lyrics![index].timeStamp.isAfter(dt)) {
            itemScrollController.scrollTo(
                index: index - 3, duration: const Duration(milliseconds: 600));
            break;
          }
        }
      }
    });
    getlyrics();
    super.initState();
  }

  getlyrics() async {
    final dio = createDio();
    final inspector = DioInspector(dio);
    final response = await inspector.send<dynamic>(
      RequestOptions(
          method: 'GET',
          path: 'https://paxsenixofc.my.id/server/getLyricsMusix.php',
          queryParameters: {
            "q": "${widget.music.songName} ${widget.music.artistName}",
            "type": "default"
          }),
    );
    if (response.data != null) {
      String data = response.data;
      lyrics = data
          .split('\n')
          .map((e) => Lyric(e.split(' ').sublist(1).join(' '),
              DateFormat("[mm:ss.SS]").parse(e.split(' ')[0])))
          .toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.music.songColor,
      body: lyrics != null
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
                          Duration duration =
                              snapshot.data ?? const Duration(seconds: 0);
                          DateTime dt = DateTime(1970, 1, 1).copyWith(
                              hour: duration.inHours,
                              minute: duration.inMinutes.remainder(60),
                              second: duration.inSeconds.remainder(60));
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              lyrics![index].words,
                              style: TextStyle(
                                color: lyrics![index].timeStamp.isAfter(dt)
                                    ? Colors.white38
                                    : Colors.white,
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

class Music {
  Duration? duration;
  String trackId;
  String? artistName;
  String? songName;
  String? songImage;
  String? artistImage;
  Color? songColor;

  Music(
      {this.duration,
      this.trackId = '',
      this.artistName,
      this.songName,
      this.songImage,
      this.artistImage,
      this.songColor});
}

class Lyric {
  final String words;
  final DateTime timeStamp;

  Lyric(this.words, this.timeStamp);
}
