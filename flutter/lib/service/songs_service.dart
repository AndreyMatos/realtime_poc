import 'dart:io';

import 'package:realtime_proj/model/song.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SongsService {
  static final String baseURL =  !Platform.isAndroid ? "http://localhost:3000" : "http://10.0.2.2:3000";
  static final SongsService instance = SongsService();

  Future<Map<String, dynamic>> addNewSong(Song song) async {
    try {
      http.Response response = await http.post(
        "$baseURL/new_song",
        body: jsonEncode(song.toJSON()),
        headers: {"Content-Type": "application/json"},
      );
      Map<String, dynamic> parsedResponse = jsonDecode(response.body);
      return parsedResponse;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> deleteSong(Song song) async {
    try {
      http.Response response = await http.delete("$baseURL/song/${song.id}");
      Map<String, dynamic> parsedResponse = jsonDecode(response.body);
      return parsedResponse;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
