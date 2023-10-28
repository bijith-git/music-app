import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/core/providers/spotify_provider.dart';
import 'package:spotify_clone/presentation/home/view/music.dart';

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

  @override
  Widget build(BuildContext context) {
    String greetingText = getGreeting();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                onPressed: () async {},
                icon: const Icon(Icons.notifications_outlined)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.settings_outlined))
          ],
        ),
        body: Consumer<SpotifyProvider>(
          builder: (context, spotify, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ButtonsTabBar(
                      physics: const NeverScrollableScrollPhysics(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      backgroundColor: Theme.of(context).primaryColor,
                      unselectedBackgroundColor:
                          Colors.grey[500]!.withOpacity(.5),
                      unselectedLabelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      radius: 100,
                      tabs: const [
                        Tab(
                          text: "Music",
                        ),
                        Tab(
                          text: "Podcast & Shows",
                        )
                      ]),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        MusicWidget(),
                        Center(
                          child: Text("Podcast"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    // });
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

// InAppWebView(
//               initialOptions: InAppWebViewGroupOptions(
//                 crossPlatform: InAppWebViewOptions(
//                   useShouldOverrideUrlLoading: true,
//                 ),
//               ),
//               initialUrlRequest:
//                   URLRequest(url: Uri.parse('www.google.com')),
//               onWebViewCreated: (InAppWebViewController controller) {
//                 print(controller.getOriginalUrl());
//               },
//               onProgressChanged:
//                   (InAppWebViewController controller, int progress) {},
//               onUpdateVisitedHistory: (InAppWebViewController controller,
//                   Uri? uri, __) async {
//                 print(uri);
//                 // if (mounted) {
//                 //   if (uri
//                 //       .toString()
//                 //       .contains('https://bijith-dev.firebaseapp.com')) {
//                 //     var grant =
//                 //         SpotifyApi.authorizationCodeGrant(credentials);
//                 //     var client = await grant
//                 //         .handleAuthorizationResponse(uri!.queryParameters);
//                 //     spotify = SpotifyApi.fromClient(client);
//                 //     setState(() {});
//                 //   }
//                 // }
//               },
//               shouldOverrideUrlLoading:
//                   (controller, navigationAction) async {
//                 final url = navigationAction.request.url.toString();
//                 print(url);
//                 print(navigationAction.request.url?.queryParameters);

//                 if (url.contains('http://192.168.137.1:3000')) {
//                   print('inside');

//                   // spotify.spotifyApi =
//                   //     await spotify.getSpotifyClient(url);
//                   // if (spotify.spotifyApi != null) {
//                   //   spotify.getSongs();
//                   // }

//                   return NavigationActionPolicy.CANCEL;
//                 }

//                 // if (url.contains('bijith-dev.firebaseapp.com')) {
//                 //   try {
//                 //     var grant = SpotifyApi.authorizationCodeGrant(credentials);
//                 //     var client = await grant.handleAuthorizationResponse(
//                 //         navigationAction.request.url!.queryParameters);
//                 //   } on PlatformException catch (e) {
//                 //     String message = '';
//                 //     if (e.code == 'ACTIVITY_NOT_FOUND') {
//                 //       message =
//                 //           'Google Pay app not found. Please install Google Pay and try again.';
//                 //     } else {
//                 //       message =
//                 //           'An error occurred while processing your payment. Please try again later.';
//                 //     }
//                 //   }
//                 //   return NavigationActionPolicy.CANCEL;
//                 // }
//                 return NavigationActionPolicy.ALLOW;
//               },
//               onCloseWindow: (controller) {
//                 controller.clearCache();
//               },
//             )
//           : PlaylistWidget(
//               playlistTitle: 'Featured',
//               playlistItems: spotify.featuredPlaylist);
