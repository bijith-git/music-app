import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import 'package:spotify_clone/widgets/side_icon.dart';

import 'widgets/widgets.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = false;
  bool _connected = false;
  late ImageUri? currentTrackImageUri;
  CrossfadeState? crossfadeState;

  @override
  void initState() {
    connectToSpotifyRemote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectionStatus>(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
          _connected = false;
          var data = snapshot.data;
          if (data != null) {
            _connected = data.connected;
          }
          return Scaffold(
              body: StreamBuilder<PlayerState>(
            stream: SpotifySdk.subscribePlayerState(),
            builder:
                (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
              var track = snapshot.data?.track;

              currentTrackImageUri = track?.imageUri;
              var playerState = snapshot.data;
              print(track!.name);
              if (playerState == null || track == null) {
                return Center(
                  child: Container(),
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _connected
                      ? MusicThumbnailWidget(imageUri: track.imageUri)
                      : const Text('Connect to see an image...'),
                  // PlayerWidget(
                  //   player: player,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedIconButton(
                        width: 50,
                        icon: Icons.skip_previous,
                        onPressed: skipPrevious,
                      ),
                      playerState.isPaused
                          ? SizedIconButton(
                              width: 50,
                              icon: Icons.play_arrow,
                              onPressed: resume,
                            )
                          : SizedIconButton(
                              width: 50,
                              icon: Icons.pause,
                              onPressed: pause,
                            ),
                      SizedIconButton(
                        width: 50,
                        icon: Icons.skip_next,
                        onPressed: skipNext,
                      ),
                    ],
                  ),
                  track.isPodcast ? const PodcastControl() : Container(),
                  Text(
                    'Track',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  track.name.length < 16
                      ? Text(
                          '${track.name} ',
                          maxLines: 1,
                        )
                      : MarqueeWidget(track: track),
                  track.artists.length > 2
                      ? MarqueeWidget(
                          track: track,
                          isArtist: true,
                        )
                      : Text(
                          '${track.artist.name} ',
                          maxLines: 2,
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Playback',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Playback speed: ${playerState.playbackSpeed}'),
                      Text(
                          'Progress: ${playerState.playbackPosition}ms/${track.duration}ms'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Paused: ${playerState.isPaused}'),
                      Text(
                          'Shuffling: ${playerState.playbackOptions.isShuffling}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Is episode: ${track.isEpisode}'),
                      Text('Is podcast: ${track.isPodcast}'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                          'RepeatMode: ${playerState.playbackOptions.repeatMode}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Repeat Mode:',
                          ),
                          DropdownButton<RepeatMode>(
                            value: RepeatMode.values[
                                playerState.playbackOptions.repeatMode.index],
                            items: const [
                              DropdownMenuItem(
                                value: RepeatMode.off,
                                child: Text('off'),
                              ),
                              DropdownMenuItem(
                                value: RepeatMode.track,
                                child: Text('track'),
                              ),
                              DropdownMenuItem(
                                value: RepeatMode.context,
                                child: Text('context'),
                              ),
                            ],
                            onChanged: (repeatMode) =>
                                setRepeatMode(repeatMode!),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Switch shuffle: '),
                          Switch.adaptive(
                            value: playerState.playbackOptions.isShuffling,
                            onChanged: (bool shuffle) => setShuffle(
                              shuffle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ));
        });
  }

  Future<void> play() async {
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      // setStatus(e.code, message: e.message);
    } on MissingPluginException {
      //
    }
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

  Future<void> seekToRelative() async {
    try {
      await SpotifySdk.seekToRelativePosition(relativeMilliseconds: 20000);
    } on PlatformException catch (e) {
      // setStatus(e.code, message: e.message);
    } on MissingPluginException {
      //
    }
  }

  Future<void> switchToLocalDevice() async {
    try {
      // await SpotifySdk.switchToLocalDevice();
    } on PlatformException catch (e) {
    } on MissingPluginException {}
  }

  Future<void> addToLibrary() async {
    try {
      await SpotifySdk.addToLibrary(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      // setStatus(e.code, message: e.message);
    } on MissingPluginException {
      //
    }
  }

  Future<void> checkIfAppIsActive(BuildContext context) async {
    try {
      await SpotifySdk.isSpotifyAppActive.then((isActive) {
        final snackBar = SnackBar(
            content: Text(isActive
                ? 'Spotify app connection is active (currently playing)'
                : 'Spotify app connection is not active (currently not playing)'));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } on PlatformException catch (e) {
      // setStatus(e.code, message: e.message);
    } on MissingPluginException {
      //
    }
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: dotenv.env['CLIENT_ID'].toString(),
          redirectUrl: dotenv.env['REDIRECT_URL'].toString());
      // setStatus(result
      //     ? 'connect to spotify successful'
      //     : 'connect to spotify failed');
      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<String> getAccessToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAccessToken(
          clientId: dotenv.env['CLIENT_ID'].toString(),
          redirectUrl: dotenv.env['REDIRECT_URL'].toString(),
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');
      // setStatus('Got a token: $authenticationToken');
      return authenticationToken;
    } on PlatformException catch (e) {
      return Future.error('$e.code: $e.message');
    } on MissingPluginException {
      return Future.error('not implemented');
    }
  }

  Future getPlayerState() async {
    try {
      return await SpotifySdk.getPlayerState();
    } on PlatformException catch (e) {
    } on MissingPluginException {}
  }

  Future getCrossfadeState() async {
    try {
      var crossfadeStateValue = await SpotifySdk.getCrossFadeState();
      setState(() {
        crossfadeState = crossfadeStateValue;
      });
    } on PlatformException catch (e) {
    } on MissingPluginException {}
  }

  Future<void> queue() async {
    try {
      await SpotifySdk.queue(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
    } on MissingPluginException {}
  }

  Future<void> toggleRepeat() async {
    try {
      await SpotifySdk.toggleRepeat();
    } on PlatformException catch (e) {
    } on MissingPluginException {}
  }

  Future<void> setRepeatMode(RepeatMode repeatMode) async {
    try {
      await SpotifySdk.setRepeatMode(
        repeatMode: repeatMode,
      );
    } on PlatformException catch (e) {
    } on MissingPluginException {}
  }

  Future<void> setShuffle(bool shuffle) async {
    try {
      await SpotifySdk.setShuffle(
        shuffle: shuffle,
      );
    } on PlatformException catch (e) {
    } on MissingPluginException {}
  }

  Future<void> toggleShuffle() async {
    try {
      await SpotifySdk.toggleShuffle();
    } on PlatformException catch (e) {
    } on MissingPluginException {}
  }
}
