import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class MusicWidget extends StatefulWidget {
  const MusicWidget({super.key});

  @override
  State<MusicWidget> createState() => _MusicWidgetState();
}

class _MusicWidgetState extends State<MusicWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            childAspectRatio: 2.4,
            mainAxisSpacing: 5,
            crossAxisSpacing: 10,
            crossAxisCount: 2,
            children: List.generate(4, (index) {
              return Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.w89cIv-rZu6AKrxeGpno0wHaE7%26pid%3DApi&f=1&ipt=8d71733020c970053b3bcf71b09e81bda46393ded1940c718d70b867fbe7b0bd&ipo=images'))),
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
                      child: const Text(
                        "Liked Song",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              );
            }),
          ),
        ],
      ),
    ));
  }
}
