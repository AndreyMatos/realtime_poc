class Song {
  int id;
  String songTitle;
  String artist;
  String spotifyURL;

  Song();

  Song.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    songTitle = json["song_title"];
    artist = json["artist"];
    spotifyURL = json["spotify_url"];
  }

  Map<String, dynamic> toJSON() {
    return {
      "song_title": songTitle,
      "artist": artist,
      "spotify_url": spotifyURL,
    };
  }
}
