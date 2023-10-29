import 'package:flutter/material.dart';
import 'package:spotify_clone/model/album_model.dart';
import 'package:spotify_clone/utils/secure_storage.dart';

import '../../../../widgets/widgets.dart';

class PlaylistWidget extends StatefulWidget {
  const PlaylistWidget({
    Key? key,
    required this.playlistTitle,
    required this.playlistItems,
  }) : super(key: key);
  final String playlistTitle;
  final List<AlbumsItem> playlistItems;

  @override
  State<PlaylistWidget> createState() => _PlaylistWidgetState();
}

class _PlaylistWidgetState extends State<PlaylistWidget> {
  @override
  Widget build(BuildContext context) {
    print(SecureStorage().getData(key: 'userData'));
    print(SecureStorage().getData(key: 'accessToken'));
    return widget.playlistItems.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.playlistTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 4.5,
                child: ListView.separated(
                    separatorBuilder: (_, i) => const SizedBox(width: 15),
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.playlistItems.length,
                    itemBuilder: (_, i) {
                      var playList = widget.playlistItems[i];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedImageWidget(
                            imageUrl: playList.images?.first.url ?? "",
                            width: 120,
                            height: 120,
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: 120,
                            child: Text(
                              playList.name,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      );
                    }),
              )
            ],
          );
  }
}
