
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/album_art.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Song Title',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  Text(
                    'Artist Name',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.skip_previous, color: Colors.black),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.play_arrow, color: Colors.black, size: 48.0),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}