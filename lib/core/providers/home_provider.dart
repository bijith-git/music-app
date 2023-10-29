import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/client/api_client.dart';
import 'package:spotify_clone/core/constants/api_path.dart';
import 'package:spotify_clone/model/album_model.dart';
import 'package:spotify_clone/model/playlist_model.dart';

class HomeProvider extends ChangeNotifier {
  bool isLoading = false;
  static final dio = createDio();
  final inspector = DioInspector(dio);
  List<AlbumsItem> newReleaseList = [];
  List<AlbumsItem> albumsList = [];
  List<AlbumsItem> popularPlaylist = [];
  List<PlaylistItem> userPlaylists = [];

  HomeProvider() {
    getHomeData();
  }
  getHomeData() async {
    await Future.wait([
      getFeaturedPlaylist(),
      getNewRelease(),
      getAlbums(),
    ]);
    getUserPlaylist();
  }

  Future<List<AlbumsItem>> getNewRelease() async {
    final response = await inspector.send<dynamic>(
      RequestOptions(
          method: 'GET',
          path: ApiConfig.baseUrl + ApiEndPoint.newRelease,
          queryParameters: {'country': "IN"}),
    );
    if (response.data != null) {
      newReleaseList.clear();
      (response.data as Map<String, dynamic>)['albums']['items']
          .map((e) => newReleaseList.add(AlbumsItem.fromJson(e)))
          .toList();
      notifyListeners();
    }
    return newReleaseList;
  }

  Future<List<AlbumsItem>> getAlbums() async {
    final response = await inspector.send<dynamic>(
      RequestOptions(
          method: 'GET',
          path: ApiConfig.baseUrl + ApiEndPoint.getAlbum,
          queryParameters: {'country': "[IN,US,UK]"}),
    );
    if (response.data != null) {
      albumsList.clear();
      response.data['items']
          .map((e) => albumsList.add(AlbumsItem.fromJson(e)))
          .toList();
      notifyListeners();
    }
    return albumsList;
  }

  Future<List<AlbumsItem>> getFeaturedPlaylist() async {
    final response = await inspector.send<dynamic>(
      RequestOptions(
          method: 'GET',
          path: ApiConfig.baseUrl + ApiEndPoint.featuredPlaylist,
          queryParameters: {'country': "IN"}),
    );
    if (response.data != null) {
      popularPlaylist.clear();
      (response.data as Map<String, dynamic>)['playlists']['items']
          .map((e) => popularPlaylist.add(AlbumsItem.fromJson(e)))
          .toList();
      notifyListeners();
    }
    return popularPlaylist;
  }

  Future<List<PlaylistItem>> getUserPlaylist() async {
    final response = await inspector.send<dynamic>(
      RequestOptions(
          method: 'GET',
          path: ApiConfig.baseUrl + ApiEndPoint.usrPlaylist,
          queryParameters: {'country': "IN"}),
    );
    if (response.data != null) {
      userPlaylists.clear();
      (response.data as Map<String, dynamic>)['items']
          .map((e) => userPlaylists.add(PlaylistItem.fromJson(e)))
          .toList();
      notifyListeners();
    }
    return userPlaylists;
  }
}
