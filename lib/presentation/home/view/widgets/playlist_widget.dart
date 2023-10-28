import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' hide Image;

class PlaylistWidget extends StatefulWidget {
  const PlaylistWidget({
    Key? key,
    required this.playlistTitle,
    required this.playlistItems,
  }) : super(key: key);
  final String playlistTitle;
  final List<PlaylistSimple> playlistItems;

  @override
  State<PlaylistWidget> createState() => _PlaylistWidgetState();
}

class _PlaylistWidgetState extends State<PlaylistWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
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
            height: MediaQuery.of(context).size.height / 4.8,
            child: ListView.builder(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: widget.playlistItems.length,
                itemBuilder: (_, i) {
                  var playList = widget.playlistItems[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.red,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      playList.images?.first.url ?? ""))),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 120,
                          child: Text(
                            playList.name ?? "",
                            maxLines: 3,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
