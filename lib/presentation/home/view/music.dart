import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/core/providers/home_provider.dart';
import 'package:spotify_clone/presentation/home/view/widgets/playlist_widget.dart';
import 'package:spotify_clone/widgets/widgets.dart';

import '../../../core/constants/app_constants.dart';

class MusicWidget extends StatefulWidget {
  const MusicWidget({super.key});

  @override
  State<MusicWidget> createState() => _MusicWidgetState();
}

class _MusicWidgetState extends State<MusicWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<HomeProvider>(
      builder: (context, spotify, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                childAspectRatio: 2.4,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                crossAxisCount: 2,
                children: List.generate(spotify.userPlaylists.length, (index) {
                  var playlist = spotify.userPlaylists[index];
                  return Row(
                    children: [
                      CachedImageWidget(
                        width: 60,
                        height: 60,
                        imageUrl: playlist.images.first.url,
                      ),
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(4),
                                bottomRight: Radius.circular(4)),
                            color: grey,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          alignment: Alignment.center,
                          child: Text(
                            playlist.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  );
                }),
              ),
              PlaylistWidget(
                  playlistTitle: "Albums", playlistItems: spotify.albumsList),
              const SizedBox(height: 10),
              PlaylistWidget(
                  playlistTitle: "New Releases",
                  playlistItems: spotify.newReleaseList),
              const SizedBox(height: 10),
              PlaylistWidget(
                  playlistTitle: "Popular Playlists",
                  playlistItems: spotify.popularPlaylist)
            ],
          ),
        );
      },
    ));
  }
}
