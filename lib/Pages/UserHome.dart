import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mixl/Pages/PlayerView.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Login.dart';



class UserHome extends StatefulWidget {
  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {


  Future<String> _loadFileContents(String fileName) async {
    // Load the file contents for the given file name
    final file = await File(fileName).readAsString();
    return file;
  }


  Future<List<String>> _getItems() async {
    List<String> itemList = [];

    // Retrieve the reference to the folder where the files are stored
    final folderRef = FirebaseStorage.instance.ref().child('gs://mixl-8e216.appspot.com');

    // Get the list of items
    final result = await folderRef.listAll();

    // Get the download URL for each item and add it to the itemList
    for (var item in result.items) {
      final url = await item.getDownloadURL();
      itemList.add(url);
    }

    return itemList;
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Color(0xff2D2D2D),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),


    );




  }

  Future<String> loadPadFile(String fileName) async {
    return await rootBundle.loadString('lib/assets/$fileName');
  }
}
