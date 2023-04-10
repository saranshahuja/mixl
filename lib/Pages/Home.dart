import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mixl/Pages/UserHome.dart';
import 'package:mixl/Pages/PlayerView.dart';
import 'package:mixl/Pages/Search.dart';
import 'package:mixl/Pages/Settings.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:mixl/Pages/UserHome.dart';




class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<String> _pdfFiles = [];
  FlutterTts flutterTts = FlutterTts();
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    UserHome(),
    KeywordSearchPage(),
    UserSettingsPage(),

  ];






  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_widgetOptions.elementAt(_selectedIndex),


      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff2D2D2D),

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
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.deepPurple,
        onTap: (index) => _onItemTapped(index),
      ),
    );
  }
}
