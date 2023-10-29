class Albums {
  List<AlbumsItem> items;

  Albums({
    required this.items,
  });

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
        items: List<AlbumsItem>.from(
            json["items"].map((x) => AlbumsItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class AlbumsItem {
  String albumType;
  List<Artist>? artists;
  String href;
  String id;
  List<Image>? images;
  String name;
  DateTime releaseDate;
  String totalTracks;
  String type;
  String uri;

  AlbumsItem({
    required this.albumType,
    this.artists,
    required this.href,
    required this.id,
    this.images,
    required this.name,
    required this.releaseDate,
    required this.totalTracks,
    required this.type,
    required this.uri,
  });

  factory AlbumsItem.fromJson(Map<String, dynamic> json) => AlbumsItem(
        albumType: json["album_type"] ?? "",
        artists: json["artists"] == null
            ? []
            : List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
        href: json["href"],
        id: json["id"],
        images: json["images"] == null
            ? []
            : List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        name: json["name"],
        releaseDate: DateTime.parse(
            json["release_date"] ?? DateTime.now().toIso8601String()),
        totalTracks: json["total_tracks"].toString(),
        type: json["type"] ?? "",
        uri: json["uri"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "album_type": albumType,
        "artists": List<dynamic>.from(artists!.map((x) => x.toJson())),
        "href": href,
        "id": id,
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
        "name": name,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "total_tracks": totalTracks,
        "type": type,
        "uri": uri,
      };
}

class Artist {
  String href;
  String id;
  String name;
  String type;
  String uri;

  Artist({
    required this.href,
    required this.id,
    required this.name,
    required this.type,
    required this.uri,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        href: json["href"],
        id: json["id"],
        name: json["name"],
        type: json["type"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
        "id": id,
        "name": name,
        "type": type,
        "uri": uri,
      };
}

class Image {
  int height;
  String url;
  int width;

  Image({
    required this.height,
    required this.url,
    required this.width,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        height: json["height"] ?? 70,
        url: json["url"],
        width: json["width"] ?? 70,
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "url": url,
        "width": width,
      };
}
