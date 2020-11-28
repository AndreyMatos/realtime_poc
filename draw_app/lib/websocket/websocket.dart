import 'dart:io' show Platform;
import 'package:websocket/websocket.dart';

class WebSocketManager {
  static final WebSocketManager instance = WebSocketManager();
  final String wsURL = !Platform.isAndroid ? "ws://localhost:3000" : "ws://10.0.2.2:3000";
  final heartbeatIntervalInSeconds = 5;
  bool active = true;
  WebSocket webSocket;

  openWebSocketConnection() async {
    webSocket = await WebSocket.connect(wsURL);
    startAutoReconnectListener();
  }

  Stream get socketStream => webSocket.stream;

  startAutoReconnectListener() async {
    while (active) {
      await Future.delayed(Duration(seconds: heartbeatIntervalInSeconds));
      if (webSocket.readyState != 1) {
        openWebSocketConnection();
      }
    }
  }

  dispose() {
    active = false;
  }
}
