import 'dart:convert';

import 'package:draw_app/websocket/websocket.dart';
import 'package:flutter/material.dart';
import 'package:whiteboardkit/drawing_controller.dart';
import 'package:whiteboardkit/whiteboard.dart';

void main() async {
  await WebSocketManager.instance.openWebSocketConnection();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DrawingController controller = DrawingController();
  final wsServer = WebSocketManager.instance;

  @override
  void initState() {
    super.initState();
    controller.onChange().listen((event) {
      wsServer.webSocket.add(jsonEncode(event.toJson()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Draw Something"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Whiteboard(
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    wsServer.dispose();
    super.dispose();
  }
}
