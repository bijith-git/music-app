import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/core/providers/spotify_provider.dart';
import 'package:spotify_clone/utils/secure_storage.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import 'widgets/widgets.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  String getGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return "Good morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good afternoon";
    } else {
      return "Good evening";
    }
  }

  getAcces() async {
    var accesToken = SecureStorage().getData(key: 'accessToken');
    final credentials = SpotifyApiCredentials(
        dotenv.env['CLIENT_ID'].toString(),
        dotenv.env['CLIENT_SECRET'].toString(),
        accessToken: accesToken,
        scopes: scopes);
    var spotify = await SpotifyApi.asyncFromCredentials(credentials);
    await spotify.playlists.me.all(1).then((playlists) {
      var lists = playlists.map((playlist) => playlist.name).join(', ');
      print('Playlists: $lists');
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    getAcces();
    String greetingText = getGreeting();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            greetingText,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  // isRemoteAccess =
                  //     await context.read<SpotifyProvider>().getRemoteAccess();
                  // setState(() {});
                  // print(isRemoteAccess);
                  // if (isRemoteAccess) {
                  // playerState =
                  //     SpotifySdk.subscribePlayerState().listen((event) {
                  //   setState(() {
                  //     track = event.track;
                  //   });
                  //   print(track?.imageUri.raw);
                  // });
                  // }
                },
                icon: const Icon(Icons.settings_remote)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.tune))
          ],
        ),
        // backgroundColor: Colors.green,
        body: Consumer<SpotifyProvider>(
          builder: (context, spotify, _) {
            return spotify.featuredPlaylist.isEmpty
                ? InAppWebView(
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                      ),
                    ),
                    initialUrlRequest:
                        URLRequest(url: Uri.parse('www.google.com')),
                    onWebViewCreated: (InAppWebViewController controller) {
                      print(controller.getOriginalUrl());
                    },
                    onProgressChanged:
                        (InAppWebViewController controller, int progress) {},
                    onUpdateVisitedHistory: (InAppWebViewController controller,
                        Uri? uri, __) async {
                      print(uri);
                      // if (mounted) {
                      //   if (uri
                      //       .toString()
                      //       .contains('https://bijith-dev.firebaseapp.com')) {
                      //     var grant =
                      //         SpotifyApi.authorizationCodeGrant(credentials);
                      //     var client = await grant
                      //         .handleAuthorizationResponse(uri!.queryParameters);
                      //     spotify = SpotifyApi.fromClient(client);
                      //     setState(() {});
                      //   }
                      // }
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      final url = navigationAction.request.url.toString();
                      print(url);
                      print(navigationAction.request.url?.queryParameters);

                      if (url.contains('http://192.168.137.1:3000')) {
                        print('inside');

                        // spotify.spotifyApi =
                        //     await spotify.getSpotifyClient(url);
                        // if (spotify.spotifyApi != null) {
                        //   spotify.getSongs();
                        // }

                        return NavigationActionPolicy.CANCEL;
                      }

                      // if (url.contains('bijith-dev.firebaseapp.com')) {
                      //   try {
                      //     var grant = SpotifyApi.authorizationCodeGrant(credentials);
                      //     var client = await grant.handleAuthorizationResponse(
                      //         navigationAction.request.url!.queryParameters);
                      //   } on PlatformException catch (e) {
                      //     String message = '';
                      //     if (e.code == 'ACTIVITY_NOT_FOUND') {
                      //       message =
                      //           'Google Pay app not found. Please install Google Pay and try again.';
                      //     } else {
                      //       message =
                      //           'An error occurred while processing your payment. Please try again later.';
                      //     }
                      //   }
                      //   return NavigationActionPolicy.CANCEL;
                      // }
                      return NavigationActionPolicy.ALLOW;
                    },
                    onCloseWindow: (controller) {
                      controller.clearCache();
                    },
                  )
                : PlaylistWidget(
                    playlistTitle: 'Featured',
                    playlistItems: spotify.featuredPlaylist);
          },
        ));

    // });
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

  // Future<void> connectToSpotifyRemote() async {
  //   try {
  //     setState(() {
  //       _loading = true;
  //     });
  //     var result = await SpotifySdk.connectToSpotifyRemote(
  //         clientId: dotenv.env['CLIENT_ID'].toString(),
  //         redirectUrl: dotenv.env['REDIRECT_URL'].toString());
  //     // setStatus(result
  //     //     ? 'connect to spotify successful'
  //     //     : 'connect to spotify failed');
  //     setState(() {
  //       _loading = false;
  //     });
  //   } on PlatformException catch (e) {
  //     setState(() {
  //       _loading = false;
  //     });
  //   } on MissingPluginException {
  //     setState(() {
  //       _loading = false;
  //     });
  //   }
  // }

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
      // Consumer<SpotifyProvider>(
      //     builder: (context, spotifyProvider, _) {
      //       var playerState = spotifyProvider.playerStateData;
      //       return Padding(
      //         padding: const EdgeInsets.symmetric(
      //             horizontal: 20, vertical: 10),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: <Widget>[
      //             isConnected
      //                 ? MusicThumbnailWidget(
      //                     imageUri: playerState?.track?.imageUri ??
      //                         ImageUri(
      //                             "spotify:image:ab67616d0000b273f6429dd1d2b1cc114020ec3c"))
      //                 : const Text('Connect to see an image...'),
      //             const SizedBox(height: 15),
      //             // track.isPodcast
      //             //     ? const PodcastControl()
      //             //     : Container(),
      //             const SizedBox(height: 15),
      //             SongDetalisWidget(track: playerState?.track),
      //             const SizedBox(height: 15),
      //             PlayBackControlsWidget(playerState: playerState),
      //             const SizedBox(height: 15),
      //           ],
      //         ),
      //       );
      //     },
      //   ),
      //; ),