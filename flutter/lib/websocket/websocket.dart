import 'package:websocket/websocket.dart';
import '../model/song.dart';
import 'dart:convert';
import 'dart:io' show Platform;

class WebSocketManager {
  static final WebSocketManager instance = WebSocketManager();
  final String wsURL = !Platform.isAndroid ? "ws://localhost:3000" : "ws://10.0.2.2:3000";
  WebSocket webSocket;

  openWebSocketConnection() async {
    webSocket = await WebSocket.connect(wsURL);
  }

  Stream<List<Song>> get socketStream =>
      webSocket.stream.map((event) => (jsonDecode(event) as List<dynamic>).map((json) => Song.fromJson(json)).toList());
}
