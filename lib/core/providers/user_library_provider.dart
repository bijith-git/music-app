import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/client/api_client.dart';
import 'package:spotify_clone/core/constants/api_path.dart';
import 'package:spotify_clone/model/playlist_model.dart';
import 'package:spotify_clone/utils/secure_storage.dart';

class UserLibraryProvider extends ChangeNotifier {
  bool isLoading = false;
  static final dio = createDio();
  final inspector = DioInspector(dio);
  List<PlaylistItem> playlist = [];
  SecureStorage secureStorage = SecureStorage();
  UserLibraryProvider() {
    getUsrPlaylist();
  }
  getUsrPlaylist() async {
    final response = await inspector.send<dynamic>(
      RequestOptions(
        method: 'GET',
        path: ApiConfig.baseUrl + ApiEndPoint.usrPlaylist,
      ),
    );
    if (response.data != null) {
      playlist.clear();
      var data = PlaylistModel.fromJson(response.data);
      data.items.map((e) => playlist.add(e)).toList();
      notifyListeners();
    }
  }
}
