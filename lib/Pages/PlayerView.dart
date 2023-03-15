
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';



class PlayPage extends StatefulWidget {
final String songName;

PlayPage({required this.songName});

@override
_PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
 // AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2D2D2D),

        title: Text(widget.songName),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container()

          ],
        ),
      ),
    );
  }
}