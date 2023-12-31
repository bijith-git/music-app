import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotify_clone/core/providers/spotify_authenticator.dart';
import 'package:spotify_clone/core/providers/spotify_provider.dart';
import 'package:spotify_clone/presentation/home/navigation.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_context.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:provider/provider.dart';

import 'package:spotify_clone/widgets/side_icon.dart';

void main() async {
  await dotenv.load(fileName: "lib/.env");
  await GetStorage.init();
  runApp(const MyApp());
}

GlobalKey<ScaffoldMessengerState> scaffoldMessaengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => SpotifyProvider(context: context),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => SpotifyAuthenticator(context: context),
        ),
      ],
      child: MaterialApp(
        title: 'Spotify Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
            scaffoldBackgroundColor: Colors.black,
            primaryColor: const Color(0xff1cab4f),
            colorScheme: const ColorScheme.dark(
                primary: Color(0xff1cab4f), onPrimary: Color(0xff1cab4f)),
            brightness: Brightness.dark,
            useMaterial3: true,
            textTheme: GoogleFonts.montserratTextTheme().apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            )),
        home: const NavBarWidget(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool _loading = false;
  bool _connected = false;

  CrossfadeState? crossfadeState;
  late ImageUri? currentTrackImageUri;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: StreamBuilder<ConnectionStatus>(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
          _connected = false;
          var data = snapshot.data;
          if (data != null) {
            _connected = data.connected;
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('SpotifySdk Example'),
              actions: [
                _connected
                    ? IconButton(
                        onPressed: disconnect,
                        icon: const Icon(Icons.exit_to_app),
                      )
                    : Container()
              ],
            ),
            body: _sampleFlowWidget(context),
            bottomNavigationBar: _connected ? _buildBottomBar(context) : null,
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      height: 125,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CustomIconButton(
                width: 50,
                icon: Icons.queue_music,
                onPressed: queue,
              ),
              CustomIconButton(
                width: 50,
                icon: Icons.playlist_play,
                onPressed: play,
              ),
              CustomIconButton(
                width: 50,
                icon: Icons.repeat,
                onPressed: toggleRepeat,
              ),
              CustomIconButton(
                width: 50,
                icon: Icons.shuffle,
                onPressed: toggleShuffle,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomIconButton(
                width: 50,
                onPressed: addToLibrary,
                icon: Icons.favorite,
              ),
              CustomIconButton(
                width: 50,
                onPressed: () => checkIfAppIsActive(context),
                icon: Icons.info,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sampleFlowWidget(BuildContext context2) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: connectToSpotifyRemote,
                  child: const Icon(Icons.settings_remote),
                ),
                TextButton(
                  onPressed: getAccessToken,
                  child: const Text('get auth token '),
                ),
              ],
            ),
            const Divider(),
            Text(
              'Player State',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            _connected
                ? _buildPlayerStateWidget()
                : const Center(
                    child: Text('Not connected'),
                  ),
            const Divider(),
            Text(
              'Player Context',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            _connected
                ? _buildPlayerContextWidget()
                : const Center(
                    child: Text('Not connected'),
                  ),
            const Divider(),
            Text(
              'Player Api',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: seekTo,
                  child: const Text('seek to 20000ms'),
                ),
                ElevatedButton(
                  onPressed: seekToRelative,
                  child: const Text('seek to relative 20000ms'),
                ),
              ],
            ),
            const Divider(),
            Text(
              'Connect Api',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: switchToLocalDevice,
                  child: const Text('switch to local device'),
                ),
              ],
            ),
            const Divider(),
            Text(
              'Crossfade State',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Status',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                    crossfadeState?.isEnabled == true ? 'Enabled' : 'Disabled'),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Duration',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(crossfadeState?.duration.toString() ?? 'Unknown'),
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: getCrossfadeState,
                      child: const Text(
                        'get crossfade state',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        _loading
            ? Container(
                color: Colors.black12,
                child: const Center(child: CircularProgressIndicator()))
            : const SizedBox(),
      ],
    );
  }

  Widget _buildPlayerStateWidget() {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        var track = snapshot.data?.track;
        currentTrackImageUri = track?.imageUri;
        var playerState = snapshot.data;

        if (playerState == null || track == null) {
          return Center(
            child: Container(),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomIconButton(
                  width: 50,
                  icon: Icons.skip_previous,
                  onPressed: skipPrevious,
                ),
                playerState.isPaused
                    ? CustomIconButton(
                        width: 50,
                        icon: Icons.play_arrow,
                        onPressed: resume,
                      )
                    : CustomIconButton(
                        width: 50,
                        icon: Icons.pause,
                        onPressed: pause,
                      ),
                CustomIconButton(
                  width: 50,
                  icon: Icons.skip_next,
                  onPressed: skipNext,
                ),
              ],
            ),
            track.isPodcast
                ? Row(
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
                  )
                : Container(),
            Text(
              'Track',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              '${track.name} by ${track.artist.name} from the album ${track.album.name}',
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
                Text('Shuffling: ${playerState.playbackOptions.isShuffling}'),
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
                Text('RepeatMode: ${playerState.playbackOptions.repeatMode}'),
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
                      value: RepeatMode
                          .values[playerState.playbackOptions.repeatMode.index],
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
                      onChanged: (repeatMode) => setRepeatMode(repeatMode!),
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
            _connected
                ? Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: spotifyImageWidget(track.imageUri),
                  )
                : const Text('Connect to see an image...'),
            Text(
              track.imageUri.raw,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlayerContextWidget() {
    return StreamBuilder<PlayerContext>(
      stream: SpotifySdk.subscribePlayerContext(),
      initialData: PlayerContext('', '', '', ''),
      builder: (BuildContext context, AsyncSnapshot<PlayerContext> snapshot) {
        var playerContext = snapshot.data;
        if (playerContext == null) {
          return const Center(
            child: Text('Not connected'),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Title',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(playerContext.title),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Subtitle',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Text(playerContext.subtitle),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Type',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Text(playerContext.type),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Uri',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Text(
              playerContext.uri,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        );
      },
    );
  }

  Widget spotifyImageWidget(ImageUri image) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: image,
          dimension: ImageDimension.large,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!);
          } else if (snapshot.hasError) {
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Error getting image')),
            );
          } else {
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Getting image...')),
            );
          }
        });
  }

  Future<void> disconnect() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.disconnect();

      setState(() {
        _loading = false;
      });
    } on PlatformException {
      setState(() {
        _loading = false;
      });
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
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

      setState(() {
        _loading = false;
      });
    } on PlatformException {
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
    } on PlatformException {}
  }

  Future getCrossfadeState() async {
    try {
      var crossfadeStateValue = await SpotifySdk.getCrossFadeState();
      setState(() {
        crossfadeState = crossfadeStateValue;
      });
    } on PlatformException {}
  }

  Future<void> queue() async {
    try {
      await SpotifySdk.queue(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException {}
  }

  Future<void> toggleRepeat() async {
    try {
      await SpotifySdk.toggleRepeat();
    } on PlatformException {}
  }

  Future<void> setRepeatMode(RepeatMode repeatMode) async {
    try {
      await SpotifySdk.setRepeatMode(
        repeatMode: repeatMode,
      );
    } on PlatformException {}
  }

  Future<void> setShuffle(bool shuffle) async {
    try {
      await SpotifySdk.setShuffle(
        shuffle: shuffle,
      );
    } on PlatformException {}
  }

  Future<void> toggleShuffle() async {
    try {
      await SpotifySdk.toggleShuffle();
    } on PlatformException {}
  }

  // Future<void> setPlaybackSpeed(
  //     PodcastPlaybackSpeed podcastPlaybackSpeed) async {
  //   try {
  //     await SpotifySdk.setPodcastPlaybackSpeed(
  //         podcastPlaybackSpeed: podcastPlaybackSpeed);
  //   } on PlatformException catch (e) {
  //
  //   } on MissingPluginException {
  //     setStatus('not implemented');
  //   }
  // }

  Future<void> play() async {
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException {}
  }

  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
    } on PlatformException {}
  }

  Future<void> resume() async {
    try {
      await SpotifySdk.resume();
    } on PlatformException {}
  }

  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } on PlatformException {}
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException {}
  }

  Future<void> seekTo() async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: 20000);
    } on PlatformException {}
  }

  Future<void> seekToRelative() async {
    try {
      await SpotifySdk.seekToRelativePosition(relativeMilliseconds: 20000);
    } on PlatformException {}
  }

  Future<void> switchToLocalDevice() async {
    try {
      // await SpotifySdk.switchToLocalDevice();
    } on PlatformException {}
  }

  Future<void> addToLibrary() async {
    try {
      await SpotifySdk.addToLibrary(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException {}
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
    } on PlatformException {}
  }

  // void setStatus(String code, {String? message}) {
  //   var text = message ?? '';
  //   _logger.i('$code$text');
  // }
}
