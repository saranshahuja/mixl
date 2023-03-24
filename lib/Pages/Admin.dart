import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mixl/Pages/Login.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  File? _selectedFile;
  String? _fileName;

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null || _fileName == null) return;

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageRef = storage.ref().child(_fileName!);

    try {
      await storageRef.putFile(_selectedFile!);
      print('File uploaded successfully!');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('File Uploaded'),
          content: Text('The file has been uploaded successfully.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error uploading file: $e');
    }
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
        title: Text('Admin'),
        backgroundColor: Color(0xff2D2D2D),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedFile != null
                ? Text('Selected File: $_fileName')
                : Text('No file selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectFile,
              child: Text('Select File'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Upload File'),
            ),
          ],
        ),
      ),
    );
  }
}
