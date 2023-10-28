
import 'package:flutter/material.dart';
import 'package:spotify_clone/presentation/search/widgets/browser_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Search",
                style: textTheme.titleLarge!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined))
            ],
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        constraints: const BoxConstraints(maxHeight: 50),
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[900],
                        ),
                        hintStyle: textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                        hintText: "What do you want to listen to?",
                        border: const OutlineInputBorder()),
                  ),
                )),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Browse all",
                  style: textTheme.bodyLarge!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                GridView.count(
                  shrinkWrap: true,
                  childAspectRatio: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 14,
                  crossAxisCount: 2,
                  children: List.generate(
                      10,
                      (index) => BrowseWidget(
                            title: "Podcast",
                            textTheme: textTheme,
                            img:
                                'https://t.scdn.co/images/fe06caf056474bc58862591cd60b57fc.jpeg',
                          )),
                ),
              ],
            ),
          )),
    );
  }
}
