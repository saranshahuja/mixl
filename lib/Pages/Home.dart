import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mixl/Pages/Home.dart';
import 'package:mixl/Pages/PlayerView.dart';
import 'package:mixl/Pages/Search.dart';
import 'package:mixl/Pages/Settings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';



class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<String> _pdfFiles = [];
  FlutterTts flutterTts = FlutterTts();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPdfFiles();
  }

  Future<File> _downloadFile(String url, String filename) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  static const List<Widget> _widgetOptions = <Widget>[

    KeywordSearchPage(),
    UserSettingsPage(),

  ];


  Future<void> _loadPdfFiles() async {
    final ListResult result = await FirebaseStorage.instance.ref().listAll();
    final List<Reference> references = result.items;

    for (final ref in references) {
      if (ref.name.endsWith('.pdf')) {
        final url = 'gs://mixl-8e216.appspot.com';
        final filename = ref.name;
        final file = await _downloadFile(url, filename);
        _pdfFiles.add(file.path);
      }
    }

    setState(() {
      var _isLoading = false;
    });
  }



  void _onItemTapped(BuildContext context, int index) {
      setState(() {
        _selectedIndex = index;
      });

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _pdfFiles.length,
              itemBuilder: (context, index) {
                final file = File(_pdfFiles[index]);
                final filename = basename(file.path);
                return ListTile(
                  title: Text(filename),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AudioPage(pdfUrl: file.path),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
