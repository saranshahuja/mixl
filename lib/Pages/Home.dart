import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mixl/Pages/Login.dart';
import 'package:mixl/Pages/PlayerView.dart';
import 'package:mixl/Pages/Search.dart';
import 'package:mixl/Pages/Settings.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:pdf_text/pdf_text.dart';

class UserPage extends StatefulWidget {

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _currentIndex = 0;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final DatabaseReference _pdfRef = FirebaseDatabase.instance.reference().child('pdfs');
  final FlutterTts _flutterTts = FlutterTts();
  List<Map<String, dynamic>> _pdfFiles = [];


  final List<Widget> pages = [
    KeywordSearchPage(),
    UserSettingsPage(),
  ];



  @override
  void initState() {
    super.initState();
    _loadPdfFiles();
  }

  // Load PDF files from Firebase Storage
  Future<void> _loadPdfFiles() async {
    ListResult result = await _storage.ref('pdfs').list();
    List<Map<String, dynamic>> pdfs = [];

    for (var item in result.items) {
      String name = item.name;
      String url = await item.getDownloadURL();
      pdfs.add({"name": name, "url": url});
    }

    setState(() {
      _pdfFiles = pdfs;
    });
  }

  Future<void> _readPdfText(String url) async {
    final outputDir = await getTemporaryDirectory();
    final pdfFile = File('${outputDir.path}/temp.pdf');
    final pdfBytes = await _storage.refFromURL(url).getData();
    await pdfFile.writeAsBytes(pdfBytes!);

    PDFDoc document = await PDFDoc.fromFile(pdfFile);
    final pageCount = document.length;
    final textContent = StringBuffer();

    for (int i = 1; i <= pageCount; i++) {
      PDFPage page = await document.pageAt(i);
      String? text = await page.text;
      textContent.write(text ?? '');
    }

    await _flutterTts.speak(textContent.toString());
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print('Error while signing out: $e');
    }

  }

  List<String> songs = [  'Song 1',    'Song 2',    'Song 3',    'Song 4',    'Song 5',  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Page'),
          backgroundColor: Color(0xff2D2D2D),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: songs.length,
        itemBuilder: (BuildContext context, int index) {
          return Expanded(

            child: Padding(
              padding: const EdgeInsets.all(8.0),

              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                tileColor: const Color(0xff252525),
                title: Text(songs[index],textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayPage(songName: songs[index]),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => pages[_currentIndex],
            ),
          );

        },
        items: [

          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),

    );
  }
}
