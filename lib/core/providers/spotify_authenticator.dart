import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import 'package:spotify_clone/utils/error_message.dart';
import 'package:spotify_clone/utils/secure_storage.dart';

class SpotifyAuthenticator extends ChangeNotifier {
  final BuildContext context;
  bool initialLunch = false;
  SpotifyAuthenticator({
    required this.context,
  }) {
    getAccessToken();
    Timer(Duration(minutes: 55), () => getAccessToken);
  }
  SecureStorage secureStorage = SecureStorage();
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