import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spotify_clone/core/constants/app_constants.dart';
import 'package:spotify_clone/presentation/home/view/home.dart';
import 'package:spotify_clone/presentation/my_library/library.dart';
import 'package:spotify_clone/presentation/player/player.dart';
import 'package:spotify_clone/presentation/search/search.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
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
      bottomSheet: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: MusicPlayerScreen()));
        },
        child: Container(
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
                child: Image.network(
                    'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP._KrRAWUfyu9V5PApNFtj0wHaEK%26pid%3DApi&f=1&ipt=f0f9877f1d6459a3717daa03c98d954fe1369ea699bbe749e54c193ecfe3037b&ipo=images',
                    width: 50,
                    fit: BoxFit.cover,
                    height: 50),
              ),
              const SizedBox(width: 5),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("fasdfsdfsdfsdfsdf"),
                  Text("fasdfsdfsdfsdfsdf"),
                ],
              ),
              const Spacer(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.computer)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.pause)),
            ],
          ),
        ),
      ),
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
