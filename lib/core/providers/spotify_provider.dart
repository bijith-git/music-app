import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_clone/utils/error_message.dart';
import 'package:spotify_clone/utils/secure_storage.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

final List<String> scopes = [
  AuthorizationScope.playlist.modifyPrivate,
  AuthorizationScope.playlist.modifyPublic,
  AuthorizationScope.library.read,
  AuthorizationScope.library.modify,
  AuthorizationScope.connect.readPlaybackState,
  AuthorizationScope.connect.readCurrentlyPlaying,
  AuthorizationScope.connect.modifyPlaybackState,
  AuthorizationScope.listen.readRecentlyPlayed,
  AuthorizationScope.listen.readPlaybackPosition,
  AuthorizationScope.listen.readTop,
];

class SpotifyProvider extends ChangeNotifier {
  final BuildContext context;
  SecureStorage secureStorage = SecureStorage();
  SpotifyApi? spotifyApi;
  bool isLoading = true;
  List<PlaylistSimple> myPlaylist = [];
  List<PlaylistSimple> featuredPlaylist = [];

  // Uri authUri = getAuthUrl();

  // static final credentials = SpotifyApiCredentials(
  //     dotenv.env['CLIENT_ID'].toString(),
  //     dotenv.env['CLIENT_SECRET'].toString(),
  //     accessToken:
  //         'AQAbM6TkRh8I_6G0m_qfPaEl5Y6eiI1VpFCXBQgr6vnMuwQ3OlYZ05_4FJ-vDtzRAzCNiKKQKBYFpyijs52iDxEASXrSR8OvQe_7pZfDQC8VpgQDUYoyW5YKaHtrb2FMgoy4clhQrv-DR4C3CBMpqdgIYfvdqFFvhfdp2sNekdZCpdJIJ8lTryit8IgDpI6HRQ4HM9kJQsVmalSWa8lAz7oJOh1K2C2bjQXM-tnQbaccYTAiF96zY5I-t7rRB0Qvv9oB0_ZzTDDOohJWXruMgVSetYFTszUmcXvQI5PlfU3peo-aZMK8dEWw945r4JmNcB8CMzmzd2AhaEtHzd39aDppyj2CjUO45PRBtyFGDk3lr9sTDgpfUTXVIOvymNnFu14wT1FGkAXlygdsfXfyML5WUGJdAzjUM8daJARLqmjoz0W_cWZWl2oLE6Bx34NLjSKto4NNCyo75eeB3g2EIgMcHGtKb8Vf67pKy0uZH2kKzd7yaixn9VrPKw5PSgBqkgUmaq4-zR-iW2rSeVxmVlygjxP6Oy6FcDO6m16S3R_mYZ0',
  //     scopes: scopes);

  // static var grant = SpotifyApi.authorizationCodeGrant(credentials,
  //     onCredentialsRefreshed: ((credentials) {
  //   print(credentials);
  // }));
  SpotifyProvider({required this.context}) {
    // getloginAccess();
  }

  Future<bool> getAccessToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAccessToken(
          clientId: dotenv.env['CLIENT_ID'].toString(),
          redirectUrl: 'http://192.168.137.1:3000',
          scope: dotenv.env['API_SCOPE']);
      print(authenticationToken);

      if (authenticationToken.isNotEmpty) {
        secureStorage.saveData(key: 'accessToken', value: authenticationToken);
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      errorPopUp(message: e.toString(), context: context);
    } finally {
      notifyListeners();
    }
    return false;
  }

  Future<bool> getRemoteAccess() async {
    try {
      var accessToken = secureStorage.getData(key: 'accessToken');
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: dotenv.env['CLIENT_ID'].toString(),
          redirectUrl: dotenv.env['REDIRECT_URL'].toString(),
          accessToken: accessToken);
      if (result) {}
      return result;
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
      errorPopUp(message: err.toString(), context: context);
    }
    return false;
  }

  getSongs() async {
    spotifyApi!.playlists.featured.all().then(
      (value) {
        print(value.first.images);
        featuredPlaylist.addAll(value);
      },
    );
    spotifyApi!.playlists.me.all().then(
          (value) => myPlaylist.addAll(value),
        );
    isLoading = false;
    print(featuredPlaylist.first.name);
    notifyListeners();
  }

  // static Uri getAuthUrl() {
  //   var redirect = 'http://192.168.137.1:3000';
  //   var authUri =
  //       grant.getAuthorizationUrl(Uri.parse(redirect), scopes: scopes);
  //   return authUri;
  // }

  // Future<SpotifyApi> getSpotifyClient(String url) async {
  //   var redirectUrl = Uri.parse(url);
  //   var client =
  //       await grant.handleAuthorizationResponse(redirectUrl.queryParameters);
  //   return SpotifyApi.fromClient(client);
  // }
}
