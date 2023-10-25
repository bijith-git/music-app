import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class MusicThumbnailWidget extends StatefulWidget {
  final ImageUri imageUri;
  const MusicThumbnailWidget({
    Key? key,
    required this.imageUri,
  }) : super(key: key);

  @override
  State<MusicThumbnailWidget> createState() => _MusicThumbnailWidgetState();
}

class _MusicThumbnailWidgetState extends State<MusicThumbnailWidget> {
  bool isLoading = true;
  Uint8List? imageUint8List;
  PaletteGenerator? paletteGenerator;

  @override
  void initState() {
    super.initState();
    getMusicThumbnail();
  }

  updateColor(ImageProvider<Object> imageProvider) async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      imageProvider,
      maximumColorCount: 20,
    );
    setState(() {});
  }

  getMusicThumbnail() async {
    imageUint8List = await SpotifySdk.getImage(
        imageUri: widget.imageUri, dimension: ImageDimension.large);
    if (imageUint8List != null) {
      await updateColor(MemoryImage(imageUint8List!));
      printColors();
    }
    isLoading = false;
    setState(() {});
  }

  printColors() {
    print(paletteGenerator?.vibrantColor?.color);
    print(paletteGenerator?.darkMutedColor?.color);
    print(paletteGenerator?.darkVibrantColor?.color);
    print(paletteGenerator?.lightMutedColor?.color);
    print(paletteGenerator?.lightVibrantColor?.color);
    print(paletteGenerator?.dominantColor?.color);
    print(paletteGenerator?.mutedColor?.color);
    print(paletteGenerator?.vibrantColor?.color);
    paletteGenerator?.paletteColors.forEach((e) {
      print('paletterColor${e.color}');
    });
    paletteGenerator?.colors.forEach((element) {
      print('colors:$element');
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Material(
            shadowColor: paletteGenerator?.vibrantColor?.color ?? Colors.white,
            borderRadius: BorderRadius.circular(10),
            elevation: 3,
            child: Container(
              width: MediaQuery.of(context).size.width * .9,
              height: MediaQuery.of(context).size.height / 2.5,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: paletteGenerator?.vibrantColor?.color ??
                            Colors.white,
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(12, 9)),
                    BoxShadow(
                      color: paletteGenerator?.darkVibrantColor?.color ??
                          Colors.white,
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(-11, -5),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: MemoryImage(imageUint8List!),
                    fit: BoxFit.fill,
                  )),
            ),
          );
  }
}
