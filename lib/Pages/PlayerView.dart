import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_text/pdf_text.dart';



class AudioPage extends StatefulWidget {
  final String pdfUrl;

  AudioPage({required this.pdfUrl});

  @override
  _AudioPageState createState() => _AudioPageState();
}

enum TtsState { playing, stopped }

class _AudioPageState extends State<AudioPage> {
  FlutterTts flutterTts = FlutterTts();
  TtsState ttsState = TtsState.stopped;
  int currentPage = 0;
  String audioText = '';

  @override
  void initState() {
    super.initState();
    _getPdfText();
  }

  Future<void> _getPdfText() async {
    final document = await PDFDoc.fromFile(File(widget.pdfUrl));
    final page = await document.pageAt(currentPage);
    final text = await page.text;
    setState(() {
      audioText = text;
    });
  }

  Future<void> _speak() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(audioText);
    setState(() {
      ttsState = TtsState.playing;
    });

    await Future.delayed(Duration(seconds: audioText.length ~/ 20));
    setState(() {
      ttsState = TtsState.stopped;
    });
  }


  Future<void> _stop() async {
    await flutterTts.stop();
    setState(() {
      ttsState = TtsState.stopped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Book'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  audioText,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed:
                  ttsState == TtsState.stopped ? _speak : null,
                ),
                IconButton(
                  icon: Icon(Icons.stop),
                  onPressed:
                  ttsState == TtsState.playing ? _stop : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

