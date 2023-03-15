
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/album_art.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Song Title',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Artist Name',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.skip_previous, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.play_arrow, color: Colors.white, size: 48.0),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_next, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Lyrics',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Verse 1',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Chorus',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Verse 2',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Chorus',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}