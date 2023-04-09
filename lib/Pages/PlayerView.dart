import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_text/pdf_text.dart';

class AudioPage extends StatefulWidget {
  final String filePath;

  const AudioPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  late FlutterTts flutterTts;
  late String _text;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _loadText();
  }

  Future<void> _loadText() async {
    final file = File(widget.filePath);
    _text = await file.readAsString();
  }

  Future<void> _toggleAudio() async {
    if (_isPlaying) {
      await flutterTts.stop();
    } else {
      await flutterTts.speak(_text);
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
              iconSize: 64,
              onPressed: _toggleAudio,
            ),
            Text(
              _isPlaying ? 'Playing' : 'Stopped',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
