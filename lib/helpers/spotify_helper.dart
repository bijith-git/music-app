import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_clone/main.dart';
import 'package:spotify_clone/utils/error_message.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifyHelper {
  static Future<String> getAccessToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAccessToken(
          clientId: dotenv.env['CLIENT_ID'].toString(),
          redirectUrl: dotenv.env['REDIRECT_URL'].toString(),
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');

      return authenticationToken;
    } catch (e) {
      errorPopUp(
          message: e.toString(),
          context: scaffoldMessaengerKey.currentContext!);
      print('outside');
      return Future.error('$e.code: $e.message');
    }
  }
}
