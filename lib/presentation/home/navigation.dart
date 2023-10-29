import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spotify_clone/core/constants/app_constants.dart';
import 'package:spotify_clone/presentation/home/view/home.dart';
import 'package:spotify_clone/presentation/my_library/library.dart';
import 'package:spotify_clone/presentation/player/connected_devides.dart';
import 'package:spotify_clone/presentation/player/player.dart';
import 'package:spotify_clone/presentation/search/search.dart';
import 'package:spotify_clone/widgets/widgets.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  @override
  void initState() {
    super.initState();
    connectToSpotify();
  }

  bool isConnected = false;
  connectToSpotify() async {
    isConnected = await SpotifySdk.connectToSpotifyRemote(
        clientId: dotenv.env['CLIENT_ID'].toString(),
        redirectUrl: dotenv.env['REDIRECT_URL'].toString());
    setState(() {});
  }

  List<Widget> body = [
    const HomePage(),
    const SearchScreen(),
    const LibraryScreen()
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: body[currentIndex],
      bottomSheet: isConnected
          ? GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: const MusicPlayerScreen()));
              },
              child: StreamBuilder<PlayerState>(
                  stream: SpotifySdk.subscribePlayerState(),
                  builder: (context, AsyncSnapshot<PlayerState> snapshot) {
                    var track = snapshot.data?.track;
                    var playerState = snapshot.data;
                    if (playerState == null || track == null) {
                      return Center(
                        child: Container(),
                      );
                    }
                    return Container(
                      alignment: Alignment.center,
                      decoration: const ShapeDecoration(
                          color: grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6)))),
                      height: MediaQuery.of(context).size.height * .08,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ImageUriWidget(image: track.imageUri),
                          ),
                          const SizedBox(width: 5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                track.artist.name ?? track.album.name ?? "",
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child: const ConnectedDevicesWidget()));
                              },
                              icon: const Icon(Icons.computer)),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite)),
                          IconButton(
                              onPressed: () async {
                                if (playerState.isPaused) {
                                  await SpotifySdk.resume();
                                } else {
                                  await SpotifySdk.pause();
                                }
                              },
                              icon: Icon(playerState.isPaused
                                  ? Icons.play_arrow
                                  : Icons.pause)),
                        ],
                      ),
                    );
                  }),
            )
          : const SizedBox(),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
            enableFeedback: false,
            useLegacyColorScheme: false,
            elevation: 0,
            currentIndex: currentIndex,
            selectedLabelStyle:
                const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 9),
            selectedItemColor: Colors.white,
            onTap: (index) {
              currentIndex = index;
              setState(() {});
            },
            backgroundColor: const Color.fromARGB(168, 9, 9, 9),
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.home_filled),
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.search_sharp),
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.library_music),
                icon: Icon(Icons.library_music_outlined),
                label: 'Your Libary',
              ),
            ]),
      ),
    );
  }
}
