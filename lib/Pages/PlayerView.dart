import 'package:flutter/material.dart';




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
        title: Text(widget.songName),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Color(0xff252525),
            ),

          ],
        ),
      ),
    );
  }
}