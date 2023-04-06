import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


Future<void> requestStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    print('Storage permission granted.');
  } else {
    print('Storage permission denied.');
  }
}


Future<String?> loadPadFile(String fileName) async {
  String? contents;
  try {
    contents = await rootBundle.loadString('assets/$fileName');
  } catch (e) {
    print('Error loading the file: $e');
  }
  return contents;
}


FlutterTts flutterTts = FlutterTts();

void speak(String text) async {
  await flutterTts.setLanguage('en-US');
  await flutterTts.setPitch(1.0);
  await flutterTts.setSpeechRate(0.5);
  await flutterTts.speak(text);
}


class pdfpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Text-to-Speech')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              String? contents = await loadPadFile('Test.txt');
              if (contents != null) {
                speak(contents);
              }
            },
            child: Text('Speak file contents'),
          ),
        ),
      ),
    );
  }
}

