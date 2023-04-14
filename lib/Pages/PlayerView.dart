import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mixl/Pages/pdfPage.dart';
import 'package:path_provider/path_provider.dart';



class AudioPage extends StatefulWidget {
  const AudioPage({Key? key}) : super(key: key);

  @override
  State<AudioPage> createState() => _MyAudioPage();
}

class _MyAudioPage extends State<AudioPage> {
  FlutterTts flutterTts = FlutterTts();
  TextEditingController controller = TextEditingController();

  double volume = 1.0;
  double pitch = 1.0;
  double speechRate = 0.5;
  List<String>? languages;
  String langCode = "en-US";

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    languages = List<String>.from(await flutterTts.getLanguages);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Test.txt"),
          backgroundColor: Color(0xff2D2D2D),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    child: const Text("Speak"),
                    onPressed: _speak,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    child: const Text("Stop"),
                    onPressed: _stop,
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Volume",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Slider(
                      min: 0.0,
                      max: 1.0,
                      value: volume,
                      activeColor: Colors.deepPurple,
                      onChanged: (value) {
                        setState(() {
                          volume = value;
                        });

                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                          double.parse((volume).toStringAsFixed(2)).toString(),
                          style: const TextStyle(fontSize: 17)),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Pitch",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Slider(
                      min: 0.5,
                      max: 2.0,
                      value: pitch,
                      activeColor: Colors.deepPurple,
                      onChanged: (value) {
                        setState(() {
                          pitch = value;
                        });
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                          double.parse((pitch).toStringAsFixed(2)).toString(),
                          style: const TextStyle(fontSize: 17)),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Speech Rate",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Slider(
                      min: 0.0,
                      max: 1.0,
                      value: speechRate,
                      activeColor: Colors.deepPurple,
                      onChanged: (value) {
                        setState(() {
                          speechRate = value;
                        });
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                          double.parse((speechRate).toStringAsFixed(2))
                              .toString(),
                          style: const TextStyle(fontSize: 17)),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ));
  }

  void initSetting() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.setLanguage(langCode);
  }


  Future<String> readTextFromFile(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('$fileName');
      String text = await file.readAsString();
      return text;
    } catch (e) {
      print('Error reading file: $e');
      return '';
    }
  }
  void _speak() async {
    initSetting();
    String? contents = await loadPadFile('lib/assets/Test.txt');
    String fileContent = await readTextFromFile(contents!);
    await flutterTts.speak(contents);
  }

  void _stop() async {
    await flutterTts.stop();
  }
}