import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_proj/service/songs_service.dart';
import 'package:realtime_proj/websocket/websocket.dart';

import 'model/song.dart';

void main() async {
  await WebSocketManager.instance.openWebSocketConnection();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final wsMan = WebSocketManager.instance;

  @override
  Widget build(BuildContext context) {
    if(wsMan.webSocket.readyState == 3){
      wsMan.openWebSocketConnection();
    }
    return MaterialApp(
      title: 'Favorite Songs',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamProvider<List<Song>>.value(
        value: wsMan.socketStream,
        child: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = context.watch<List<Song>>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "🔥 Favorite Songs",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return DialogAddSongWidget();
              });
        },
      ),
      body: data == null
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: data.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (_, index) {
                Song s = data[index];
                return ListTile(
                  title: Text(s.songTitle),
                  subtitle: Text(s.artist),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: Text("Deletar Música?"),
                            actions: [
                              FlatButton(
                                textColor: Colors.grey,
                                onPressed: () => Navigator.pop(dialogContext),
                                child: Text("CANCELAR"),
                              ),
                              FlatButton(
                                  textColor: Colors.red,
                                  onPressed: () async {
                                    await SongsService.instance.deleteSong(s);
                                    Navigator.pop(dialogContext);
                                  },
                                  child: Text("APAGAR"))
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class DialogAddSongWidget extends StatefulWidget {
  @override
  _DialogAddSongWidgetState createState() => _DialogAddSongWidgetState();
}

class _DialogAddSongWidgetState extends State<DialogAddSongWidget> {
  final Song song = Song();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: AlertDialog(
        title: Text("Adicionar Nova Música"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              onSaved: (v) => song.songTitle = v,
              decoration: InputDecoration(hintText: "Título"),
              validator: (v) => v.isEmpty ? "Campo obrigatório" : null,
            ),
            TextFormField(
              onSaved: (v) => song.artist = v,
              decoration: InputDecoration(hintText: "Artista"),
              validator: (v) => v.isEmpty ? "Campo obrigatório" : null,
            ),
            TextFormField(
              onSaved: (v) => song.spotifyURL = v,
              decoration: InputDecoration(hintText: "Link Spotify"),
              validator: (v) => v.isEmpty ? "Campo obrigatório" : null,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  textColor: Colors.red,
                  onPressed: () => Navigator.pop(context),
                  child: Text("CANCELAR"),
                ),
                FlatButton(
                    textColor: Colors.green,
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        await SongsService.instance.addNewSong(song);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("ADICIONAR"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
