class ApiConfig {
  static const baseUrl = 'https://api.spotify.com/v1/';
}

class ApiEndPoint {
  static String getAlbum = 'me/albums';
  static String newReleases = 'browse/new-releases';
  static String getPlaylist = 'playlists';
  static String usrPlaylist = 'me/playlists';
  static String featuredPlaylist = 'browse/featured-playlists';
  static String newRelease = 'browse/new-releases';
  static String getProfile = 'me';
  static String getDevices = 'me/player/devices';
  static String transferPlay = 'me/player';
  static String recommendations = 'recommendations';
}
