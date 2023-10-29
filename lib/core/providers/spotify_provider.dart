import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/core/client/api_client.dart';
import 'package:spotify_clone/utils/secure_storage.dart';

class SpotifyProvider extends ChangeNotifier {
  final BuildContext context;
  static final dio = createDio();
  final inspector = DioInspector(dio);
  SecureStorage secureStorage = SecureStorage();
  SpotifyApi? spotifyApi;
  bool isLoading = true;
  List<PlaylistSimple> myPlaylist = [];
  List<PlaylistSimple> featuredPlaylist = [];

  SpotifyProvider({required this.context}) {
    // getFavorite();
  }

  getSongs() async {
    spotifyApi!.playlists.featured.all().then(
      (value) {
        featuredPlaylist.addAll(value);
      },
    );
    spotifyApi!.playlists.me.all().then(
          (value) => myPlaylist.addAll(value),
        );
    isLoading = false;
    notifyListeners();
  }

  getFavorite() async {
    final response = await inspector.send<dynamic>(
      RequestOptions(
          method: 'GET',
          path:
              'https://api.spotify.com/v1/users/31nxnczd353im5ddjljjsrl3maga/playlists',
          headers: {
            'Authorization':
                "Bearer BQBVTk-t7JhA-FD08sK06i67cuXY_Xe8mj3FLwQ5q839w836Il4VC9ns4I4JKuMMfvfVBv44HkSManW2TRKYPR4fVJeAcF0c7c5QqnfvBZQQDH3YL5AtHCyGcECiWfWUyLGCXRPD7V1GDtF391FIluJeyKGmNPUISvPvxWmxTt-BuvyiwM-eUBeIO51cNmAygXKVhaCtukBtiwrJCWDqY1e3X06SRzP6LYyMreMeMIRqRTiPLlIuNTVqR74e_z7HnYAmuMZRQcFlRdWFwXxS-QcfBSOCmO6UxOZnl9RFA6nnuaR_WYHBWvrlBX149g"
          }),
    );

    if (response.statusCode == 200) {
      var data = Playlist.fromJson(response.data['items']);
      print(data.description);
      print('Success! Response data: ${response.data}');
    } else {
      print('Error! Response status: ${response.statusCode}');
    }
  }
}
