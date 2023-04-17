import 'dart:ffi';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_text/pdf_text.dart';



class AudioPage extends StatefulWidget {
  final String fileUrl;
  final String filename;

  const AudioPage({Key? key, required this.fileUrl, required this.filename,}) : super(key: key);

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



  PlayerState audioPlayerState = PlayerState.stopped;
  PlayerState? audioPlayer;
  Duration? duration;
  Duration? position;

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
          title: Text(widget.filename),
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
                    onPressed: extractPdfText,//_speak,
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



  Future<File> downloadPdfFromFirebaseStorage(String pdfUrl) async {
    // Create a Reference to the PDF file
    Reference reference = FirebaseStorage.instance.refFromURL(pdfUrl);

    // Get the application documents directory
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File localFile = File('${appDocDir.path}/downloaded_pdf.pdf');

    // Download the PDF file and save it locally
    await reference.writeToFile(localFile);

    return localFile;
  }


  Future<String> extractTextFromPdf(File pdfFile) async {
    // Create a PDFDoc instance from the file
    PDFDoc pdfDoc = await PDFDoc.fromFile(pdfFile);

    // Extract text from all pages
    String pdfText = '';
    List<PDFPage> pages = await pdfDoc.pages;
    for (PDFPage page in pages) {
      String pageText = await page.text;
      pdfText += pageText;
    }

    return pdfText;
  }
  Future<File> downloadFileFromUrl(String fileUrl) async {
    // Create a Reference to the file
    Reference reference = FirebaseStorage.instance.refFromURL(fileUrl);

    // Get the application documents directory
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String fileName = reference.name;
    File localFile = File('${appDocDir.path}/$fileName');

    // Download the file and save it locally
    await reference.writeToFile(localFile);

    return localFile;
  }

 void extractPdfText() async {
   File downloadedPdf = await downloadPdfFromFirebaseStorage(widget.fileUrl);
   String pdfText = await extractTextFromPdf(downloadedPdf);
   print(pdfText);
   await flutterTts.speak(pdfText);
  }




  void _stop() async {
    await flutterTts.stop();
  }
}