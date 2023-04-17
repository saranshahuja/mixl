import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mixl/Pages/PlayerView.dart';

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



  Future<List<Map<String, String>>> _fetchFileUrls() async {
    List<Map<String, String>> fileData = [];

    // Fetch files from the root directory
    final rootReference = FirebaseStorage.instance.ref();
    final result = await rootReference.list();

    for (var item in result.items) {
      String url = await item.getDownloadURL();
      String name = item.name;
      fileData.add({
        'url': url,
        'name': name,
      });
    }

    return fileData;
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
    body: FutureBuilder<List<Map<String, String>>>(
      future: _fetchFileUrls(),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, String>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                String fileName = snapshot.data![index]['name']!;
                String fileUrl = snapshot.data![index]['url']!;
                return ListTile(
                  title: Text(fileName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AudioPage(fileUrl: fileUrl, filename: fileName),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No files found'));
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ),


    );




  }

  Future<String> loadPadFile(String fileName) async {
    return await rootBundle.loadString('lib/assets/$fileName');
  }
}
