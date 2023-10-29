import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/core/providers/home_provider.dart';
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

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String greetingText = getGreeting();

    return DefaultTabController(
      length: 2,
      child: ChangeNotifierProvider(
          create: (context) => HomeProvider(),
          builder: (context, _) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  greetingText,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                actions: [
                  IconButton(
                      onPressed: () async {},
                      icon: const Icon(Icons.notifications_outlined)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.settings_outlined))
                ],
              ),
              body: Consumer<HomeProvider>(
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
                        Expanded(
                          child: TabBarView(
                            children: [
                              MusicWidget(
                                scaffoldState: scaffoldKey,
                              ),
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
            );
          }),
    );
  }
}
