import 'dart:math';

import 'package:flutter/material.dart';

class BrowseWidget extends StatelessWidget {
  final String title;
  final String img;
  const BrowseWidget({
    Key? key,
    required this.title,
    required this.img,
    required this.textTheme,
  }) : super(key: key);

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
            [Random().nextInt(9) * 100],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              title,
              style: textTheme.bodyLarge!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            left: 120,
            top: 20,
            right: -20,
            child: Transform.rotate(
              angle: pi / 3.8,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(img),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
