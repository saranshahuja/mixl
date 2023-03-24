import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mixl/Pages/Login.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _oldFileNameController = TextEditingController();
  final TextEditingController _newFileNameController = TextEditingController();

  // Upload the PDF file to Firebase Storage
  Future<void> _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = basename(file.path);

      try {
        await _storage.ref('pdfs/$fileName').putFile(file);
        ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(content: Text('File uploaded successfully!')));
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(this.context)
            .showSnackBar(SnackBar(content: Text(e.message!)));
      }
    } else {
      ScaffoldMessenger.of(this.context)
          .showSnackBar(SnackBar(content: Text('No file selected')));
    }
  }

  Future<void> _deleteFile() async {
    String oldFileName = _oldFileNameController.text;

    if (oldFileName.isNotEmpty) {
      try {
        await _storage.ref('pdfs/$oldFileName').delete();
        ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(content: Text('File deleted successfully!')));
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(this.context)
            .showSnackBar(SnackBar(content: Text(e.message!)));
      }
    } else {
      ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(content: Text('Enter the file name to delete')));
    }
  }

  // Rename the PDF file in Firebase Storage
  Future<void> _renameFile() async {
    String oldFileName = _oldFileNameController.text;
    String newFileName = _newFileNameController.text;

    if (oldFileName.isNotEmpty && newFileName.isNotEmpty) {
      try {
        // Copy the old file to the new file
        await _storage.ref('pdfs/$newFileName').putFile(
            (await _storage.ref('pdfs/$oldFileName').getData()) as File);

        // Delete the old file
        await _storage.ref('pdfs/$oldFileName').delete();

        ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(content: Text('File renamed successfully!')));
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(this.context)
            .showSnackBar(SnackBar(content: Text(e.message!)));
      }
    } else {
      ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(content: Text('Enter both old and new file names')));
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print('Error while signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        backgroundColor: Color(0xff2D2D2D),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _oldFileNameController,
                decoration: InputDecoration(
                  labelText: 'Old File Name',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _newFileNameController,
                decoration: InputDecoration(
                  labelText: 'New File Name',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _uploadFile,
                child: Text('Upload PDF File'),
              ),
              SizedBox(height: 160),
              ElevatedButton(
                onPressed: _deleteFile,
                child: Text('Delete PDF File'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _renameFile,
                child: Text('Rename PDF File'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
