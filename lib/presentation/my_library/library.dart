import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/core/constants/app_constants.dart';
import 'package:spotify_clone/core/providers/user_library_provider.dart';
import 'package:spotify_clone/utils/secure_storage.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    print(SecureStorage().getData(key: 'accessToken'));
    var textTheme = Theme.of(context).textTheme;
    return ChangeNotifierProvider(
        lazy: false,
        create: (context) => UserLibraryProvider(),
        builder: (context, _) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "Your Library",
                  style: textTheme.titleLarge!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                actions: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add))
                ],
              ),
              body: Consumer<UserLibraryProvider>(
                builder: (context, state, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ButtonsTabBar(
                            physics: const NeverScrollableScrollPhysics(),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            backgroundColor: Theme.of(context).primaryColor,
                            unselectedBackgroundColor:
                                Colors.grey[500]!.withOpacity(.5),
                            unselectedLabelStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                            radius: 100,
                            center: false,
                            tabs: const [
                              Tab(
                                text: "Playlists",
                              ),
                              Tab(
                                text: "Podcast & Shows",
                              ),
                              Tab(
                                text: "Artists",
                              )
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .4,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Center(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  width: 40,
                                                  height: 5,
                                                  decoration: BoxDecoration(
                                                      color: grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Center(
                                                child: Text("Sort by",
                                                    style: textTheme.bodyLarge!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)),
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                width: double.infinity,
                                                height: 1,
                                                color: grey,
                                              ),
                                              ListTile(
                                                title: const Text('Recents'),
                                                trailing: Icon(Icons.check,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              ListTile(
                                                title: const Text(
                                                    'Recently added'),
                                                trailing: Icon(Icons.check,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              ListTile(
                                                title:
                                                    const Text('Alphabetical'),
                                                trailing: Icon(Icons.check,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              ListTile(
                                                title: const Text('Creator'),
                                                trailing: Icon(Icons.check,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.swap_vert,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "Recents",
                                      style: textTheme.labelSmall!.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                            IconButton(
                                onPressed: () {
                                  pressed = !pressed;
                                  setState(() {});
                                },
                                icon: Icon(pressed
                                    ? Icons.format_list_bulleted
                                    : Icons.grid_view))
                          ],
                        ),
                        state.playlist.isEmpty
                            ? const Center(
                                child: Text('NO play'),
                              )
                            : Expanded(
                                child: !pressed
                                    ? ListView.separated(
                                        separatorBuilder: (_, i) =>
                                            const SizedBox(height: 10),
                                        itemCount: state.playlist.length,
                                        itemBuilder: (_, i) {
                                          var playlist = state.playlist[i];
                                          return ListTile(
                                              leading: Image.network(
                                                  playlist.images.first.url),
                                              title: Text(
                                                playlist.name,
                                                style: textTheme.bodyMedium!
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                              subtitle: Text(
                                                playlist.owner.displayName,
                                                style: textTheme.bodySmall!
                                                    .copyWith(
                                                        color: Colors.white),
                                              ));
                                        })
                                    : GridView.count(
                                        childAspectRatio: .7,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        crossAxisCount: 3,
                                        children: List.generate(
                                            state.playlist.length, (index) {
                                          var playlist = state.playlist[index];
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.network(
                                                  playlist.images.first.url),
                                              const SizedBox(height: 5),
                                              Text(
                                                playlist.name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textTheme.bodyMedium!
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}
