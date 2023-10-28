import 'package:flutter/material.dart';
import 'package:spotify_clone/presentation/home/view/home.dart';
import 'package:spotify_clone/presentation/my_library/library.dart';
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
      body: body[currentIndex],
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
            backgroundColor: const Color(0x00ffffff),
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
