import 'dart:convert';

PlaylistModel playlistModelFromJson(String str) =>
    PlaylistModel.fromJson(json.decode(str));

String playlistModelToJson(PlaylistModel data) => json.encode(data.toJson());

class PlaylistModel {
  String href;
  List<PlaylistItem> items;

  PlaylistModel({
    required this.href,
    required this.items,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) => PlaylistModel(
        href: json["href"],
        items: List<PlaylistItem>.from(
            json["items"].map((x) => PlaylistItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "href": href,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class PlaylistItem {
  bool collaborative;
  String description;
  String href;
  String id;
  List<Image> images;
  String name;
  Owner owner;
  dynamic primaryColor;
  bool public;
  String snapshotId;
  Tracks tracks;
  String type;
  String uri;

  PlaylistItem({
    required this.collaborative,
    required this.description,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.owner,
    required this.primaryColor,
    required this.public,
    required this.snapshotId,
    required this.tracks,
    required this.type,
    required this.uri,
  });

  factory PlaylistItem.fromJson(Map<String, dynamic> json) => PlaylistItem(
        collaborative: json["collaborative"],
        description: json["description"],
        href: json["href"],
        id: json["id"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        name: json["name"],
        owner: Owner.fromJson(json["owner"]),
        primaryColor: json["primary_color"],
        public: json["public"],
        snapshotId: json["snapshot_id"],
        tracks: Tracks.fromJson(json["tracks"]),
        type: json["type"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "collaborative": collaborative,
        "description": description,
        "href": href,
        "id": id,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "name": name,
        "owner": owner.toJson(),
        "primary_color": primaryColor,
        "public": public,
        "snapshot_id": snapshotId,
        "tracks": tracks.toJson(),
        "type": type,
        "uri": uri,
      };
}

class Image {
  int? height;
  String url;
  int? width;

  Image({
    required this.height,
    required this.url,
    required this.width,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        height: json["height"],
        url: json["url"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "url": url,
        "width": width,
      };
}

class Owner {
  String displayName;
  String href;
  String id;
  String type;
  String uri;

  Owner({
    required this.displayName,
    required this.href,
    required this.id,
    required this.type,
    required this.uri,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        displayName: json["display_name"],
        href: json["href"],
        id: json["id"],
        type: json["type"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "display_name": displayName,
        "href": href,
        "id": id,
        "type": type,
        "uri": uri,
      };
}

class Tracks {
  String href;
  int total;

  Tracks({
    required this.href,
    required this.total,
  });

  factory Tracks.fromJson(Map<String, dynamic> json) => Tracks(
        href: json["href"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
        "total": total,
      };
}
